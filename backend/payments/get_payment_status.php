<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../_db.php';

$order_id = intval($_GET['order_id'] ?? 0);
if (!$order_id) { http_response_code(422); echo json_encode(['error'=>'order_id required']); exit; }

$stmt = $pdo->prepare("SELECT * FROM payments WHERE order_id = :oid ORDER BY payment_id DESC LIMIT 1");
$stmt->execute([':oid'=>$order_id]);
$pay = $stmt->fetch();

echo json_encode(['ok'=>true, 'payment'=>$pay]);
