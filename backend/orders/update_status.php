<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';

$post = json_decode(file_get_contents('php://input'), true);
$order_number = $post['order_number'] ?? null;
$new_status   = $post['status'] ?? null;
$note         = $post['note'] ?? null; // optional

if (!$order_number || !$new_status) {
    echo json_encode(['ok' => false, 'msg' => 'Missing']);
    exit;
}

// ===============================
// MAPPING STATUS KITCHEN -> TRACKING
// ===============================
$trackingStatus = match ($new_status) {
    'Pending'  => 'in_kitchen',
    'Diproses' => 'in_kitchen',
    'Selesai'  => 'delivered',
    default    => 'in_kitchen'
};

// ===============================
// Ambil order_id dari order_number
// ===============================
$stmt = $pdo->prepare("SELECT order_id FROM orders WHERE order_number = :o");
$stmt->execute(['o' => $order_number]);
$row = $stmt->fetch();

if (!$row) {
    echo json_encode(['ok' => false, 'msg' => 'Order not found']);
    exit;
}

$order_id = $row['order_id'];

// ===============================
// Update tabel orders
// ===============================
$stmt = $pdo->prepare("UPDATE orders SET status = :s WHERE order_id = :id");
$stmt->execute(['s' => $new_status, 'id' => $order_id]);

// ===============================
// Insert ke tabel tracking
// ===============================
$tr = $pdo->prepare("
    INSERT INTO tracking (order_id, status, note)
    VALUES (:id, :s, :n)
");
$tr->execute([
    'id' => $order_id,
    's'  => $trackingStatus,
    'n'  => $note
]);

// ===============================
// Autosync stock kalau Diproses
// ===============================
if ($new_status === 'Diproses') {
    require_once __DIR__ . '/../stock/autosync.php';
    $result = autosync_reduce_stock_by_order_number($pdo, $order_number);
}

echo json_encode(['ok' => true, 'msg' => 'updated']);
