<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../_db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405); echo json_encode(['error'=>'Method not allowed']); exit;
}

$payment_id = intval($_POST['payment_id'] ?? 0);
$status = $_POST['status'] ?? '';

if (!$payment_id || !in_array($status, ['success','failed'])) {
  http_response_code(422); echo json_encode(['error'=>'Missing or invalid fields']); exit;
}

try {
  $pdo->beginTransaction();

  $stmt = $pdo->prepare("SELECT order_id FROM payments WHERE payment_id=:pid LIMIT 1");
  $stmt->execute([':pid'=>$payment_id]);
  $row = $stmt->fetch();
  if (!$row) {
    throw new Exception('Payment not found');
  }
  $order_id = $row['order_id'];

  $pdo->prepare("UPDATE payments SET status=:st WHERE payment_id=:pid")->execute([':st'=>$status, ':pid'=>$payment_id]);

  if ($status === 'success') {
    // mark order to processing
    $pdo->prepare("UPDATE orders SET status='processing' WHERE order_id=:oid")->execute([':oid'=>$order_id]);
  } else {
    // failed -> keep waiting_payment or set to 'waiting_payment' for retry
    $pdo->prepare("UPDATE orders SET status='waiting_payment' WHERE order_id=:oid")->execute([':oid'=>$order_id]);
  }

  $pdo->commit();
  echo json_encode(['ok'=>true]);
} catch (Exception $e) {
  $pdo->rollBack();
  http_response_code(500);
  echo json_encode(['ok'=>false,'error'=>'DB error','msg'=>$e->getMessage()]);
}
