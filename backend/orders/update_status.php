<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';

$post = json_decode(file_get_contents('php://input'), true);

$order_number = $post['order_number'] ?? null;
$new_status   = $post['status'] ?? null;
$note         = $post['note'] ?? null;

if (!$order_number || !$new_status) {
    echo json_encode(['ok' => false, 'msg' => 'Missing parameters']);
    exit;
}

$trackingStatus = match ($new_status) {
    'Pending'  => 'pending',
    'Diproses' => 'in_kitchen',
    'Selesai'  => 'out_for_delivery',
    default    => 'pending'
};

// ======================================
// Ambil order_id dari order_number
// ======================================
$stmt = $pdo->prepare("SELECT order_id FROM orders WHERE order_number = :o");
$stmt->execute(['o' => $order_number]);
$row = $stmt->fetch();

if (!$row) {
    echo json_encode(['ok' => false, 'msg' => 'Order not found']);
    exit;
}

$order_id = $row['order_id'];

// ======================================
// Update status di tabel orders
// ======================================
$pdo->prepare("UPDATE orders SET status = :s WHERE order_id = :id")
    ->execute(['s' => $new_status, 'id' => $order_id]);

// ======================================
// Insert tracking history
// ======================================
$pdo->prepare("
    INSERT INTO tracking (order_id, status, note, updated_at)
    VALUES (:id, :s, :n, NOW())
")->execute([
    'id' => $order_id,
    's'  => $trackingStatus,
    'n'  => $note
]);

// ======================================
// Trigger AUTOSYNC hanya saat Diproses
// ======================================
if ($new_status === 'Diproses') {
    require_once __DIR__ . '/../stock/autosync.php';
    autosync_reduce_stock_by_order_number($pdo, $order_number);
}

echo json_encode(['ok' => true, 'msg' => 'updated']);
