<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../_db.php';

// create_payment.php
// expects POST: order_id, payment_method (cash|qris), amount, transaction_ref (optional), optional proof file 'proof'
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405); echo json_encode(['error'=>'Method not allowed']); exit;
}

$order_id = intval($_POST['order_id'] ?? 0);
$payment_method = in_array($_POST['payment_method'] ?? '', ['cash','qris']) ? $_POST['payment_method'] : 'cash';
$amount = floatval($_POST['amount'] ?? 0);
$transaction_ref = trim($_POST['transaction_ref'] ?? null);

if (!$order_id || $amount <= 0) {
  http_response_code(422); echo json_encode(['error'=>'Missing required fields']); exit;
}

// optional file upload proof
$proof_path = null;
if (!empty($_FILES['proof']['name'])) {
  $dir = __DIR__ . '/../uploads/payments/';
  if (!is_dir($dir)) mkdir($dir, 0755, true);
  $ext = pathinfo($_FILES['proof']['name'], PATHINFO_EXTENSION);
  $fname = 'pay_' . time() . '_' . bin2hex(random_bytes(4)) . '.' . $ext;
  if (move_uploaded_file($_FILES['proof']['tmp_name'], $dir . $fname)) {
    $proof_path = 'uploads/payments/' . $fname;
  }
}

try {
  $pdo->beginTransaction();

  $stmt = $pdo->prepare("INSERT INTO payments (order_id, payment_method, payment_date, amount, status, transaction_ref) VALUES (:oid, :pm, NOW(), :amt, 'pending', :ref)");
  $stmt->execute([':oid'=>$order_id, ':pm'=>$payment_method, ':amt'=>$amount, ':ref'=>$transaction_ref]);

  $payment_id = $pdo->lastInsertId();

  // If cash payment, set payment.status = success immediately and set order status to processing
  if ($payment_method === 'cash') {
    $u = $pdo->prepare("UPDATE payments SET status='success' WHERE payment_id=:pid");
    $u->execute([':pid'=>$payment_id]);

    $upOrder = $pdo->prepare("UPDATE orders SET status='processing' WHERE order_id=:oid");
    $upOrder->execute([':oid'=>$order_id]);
  } else {
    // for qris, order should remain waiting_payment until verified
    // If current order status is not waiting_payment, set it (safety)
    $pdo->prepare("UPDATE orders SET status='waiting_payment' WHERE order_id=:oid")->execute([':oid'=>$order_id]);
  }

  $pdo->commit();
  echo json_encode(['ok'=>true, 'payment_id'=>$payment_id]);
} catch (Exception $e) {
  $pdo->rollBack();
  http_response_code(500);
  echo json_encode(['ok'=>false, 'error'=>'DB error','msg'=>$e->getMessage()]);
}
