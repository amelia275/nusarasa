<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';

$today = date('Ymd');
$prefix = 'NR-' . $today;

$stmt = $pdo->prepare("SELECT COUNT(*) as cnt FROM orders WHERE DATE(created_at) = CURDATE()");
$stmt->execute();
$row = $stmt->fetch();
$seq = intval($row['cnt']) + 1;

$order_number = $prefix . '-' . str_pad($seq, 3, '0', STR_PAD_LEFT);

echo json_encode([
    'ok' => true,
    'order_number' => $order_number
]);
