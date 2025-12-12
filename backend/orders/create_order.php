<?php
header('Content-Type: application/json');
session_start();
require_once __DIR__ . '/../_db.php';

$body = json_decode(file_get_contents('php://input'), true);
$table_number = intval($body['table_number'] ?? 0);
$payment_method = in_array($body['payment_method'] ?? '', ['cash','qris']) ? $body['payment_method'] : 'cash';

if (!$table_number) { 
    echo json_encode(['ok'=>false,'msg'=>'Missing table_number']); 
    exit; 
}

$sid = session_id();

// fetch cart items
$stmt = $pdo->prepare("
    SELECT c.cart_id, c.menu_id, c.quantity, c.note, mi.price 
    FROM carts c 
    JOIN menu_items mi ON mi.menu_id = c.menu_id 
    WHERE c.session_id = :sid
");
$stmt->execute(['sid'=>$sid]);
$items = $stmt->fetchAll();

if (!$items) { 
    echo json_encode(['ok'=>false,'msg'=>'Cart empty']); 
    exit; 
}

$order_number = $body['order_number'] ?? null;

if (!$order_number) {
    echo json_encode(['ok' => false, 'msg' => 'Missing order_number']);
    exit;
}

// compute total
$total = 0;
foreach ($items as $it) {
    $total += floatval($it['price']) * intval($it['quantity']);
}

try {
    $pdo->beginTransaction();

    // insert order
    $ins = $pdo->prepare("
        INSERT INTO orders (order_number, table_number, payment_method, status, created_at) 
        VALUES (:on, :tn, :pm, 'Pending', NOW())
    ");
    $ins->execute([
        'on' => $order_number,
        'tn' => $table_number,
        'pm' => $payment_method
    ]);
    $order_id = $pdo->lastInsertId();
    // tracking awal (pending)
    $pdo->prepare("
        INSERT INTO tracking (order_id, status, note, updated_at)
        VALUES (:oid, 'pending', NULL, NOW())
    ")->execute(['oid' => $order_id]);


    // insert order_items
    $oi = $pdo->prepare("
        INSERT INTO order_items (order_id, menu_id, quantity, subtotal, note) 
        VALUES (:oid, :mid, :qty, :sub, :note)
    ");
    foreach ($items as $it) {
        $subtotal = floatval($it['price']) * intval($it['quantity']);
        $oi->execute([
            'oid' => $order_id,
            'mid' => $it['menu_id'],
            'qty' => $it['quantity'],
            'sub' => $subtotal,
            'note' => $it['note'] ?? ''
        ]);
    }

    // jika QRIS → langsung lunas
    $paymentStatus = ($payment_method === 'qris') ? 'success' : 'pending';

    $p = $pdo->prepare("
        INSERT INTO payments (order_id, payment_method, amount, status, payment_date) 
        VALUES (:oid, :pm, :amt, :st, NOW())
    ");
    $p->execute([
        'oid' => $order_id,
        'pm'  => $payment_method,
        'amt' => $total,
        'st'  => $paymentStatus
    ]);


    // clear cart
    $del = $pdo->prepare("DELETE FROM carts WHERE session_id = :sid");
    $del->execute(['sid'=>$sid]);

    $pdo->commit();

    echo json_encode([
        'ok' => true,
        'data' => [
            'order_id' => $order_id,
            'order_number' => $order_number,
            'total' => $total
        ]
    ]);

} catch (Exception $e) {
    $pdo->rollBack();

    echo json_encode([
        'ok' => false,
        'msg' => 'Server error',
        'detail' => $e->getMessage()
    ]);
}
