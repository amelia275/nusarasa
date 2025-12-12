<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../_db.php';

// ================================
// DETEKSI JSON / FORM-DATA
// ================================
$raw = file_get_contents("php://input");
$json = json_decode($raw, true);

if ($json && is_array($json)) {
    // request via JSON (QRIS)
    $order_id = intval($json['order_id'] ?? 0);
    $payment_method = $json['payment_method'] ?? 'qris';
    $amount = floatval($json['amount'] ?? 0);
    $transaction_ref = $json['transaction_ref'] ?? null;
    $proof_path = null; // QRIS tidak pakai file upload
} else {
    // request via form-data (cash upload)
    $order_id = intval($_POST['order_id'] ?? 0);
    $payment_method = in_array($_POST['payment_method'] ?? '', ['cash','qris']) ? $_POST['payment_method'] : 'cash';
    $amount = floatval($_POST['amount'] ?? 0);
    $transaction_ref = trim($_POST['transaction_ref'] ?? null);

    // Upload bukti hanya kalau kolom proof_image ADA
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
}

// ================================
// AUTO-BUAT TRANSACTION REF
// ================================
if (!$transaction_ref || trim($transaction_ref) === "") {
    $transaction_ref = "TRX-" . time() . "-" . rand(1000, 9999);
}

// ================================
// VALIDASI
// ================================
if (!$order_id || $amount <= 0) {
    echo json_encode(['ok'=>false, 'msg'=>'Missing required fields']);
    exit;
}

try {
    $pdo->beginTransaction();

    // ================================
    // INSERT TANPA proof_image
    // ================================
    $stmt = $pdo->prepare("
        INSERT INTO payments (order_id, payment_method, payment_date, amount, status, transaction_ref)
        VALUES (:oid, :pm, NOW(), :amt, 'pending', :ref)
    ");
    $stmt->execute([
        ':oid'=>$order_id,
        ':pm'=>$payment_method,
        ':amt'=>$amount,
        ':ref'=>$transaction_ref
    ]);

    $payment_id = $pdo->lastInsertId();

if (in_array($payment_method, ['cash','qris'])) {
    $pdo->prepare("UPDATE payments SET status='success' WHERE payment_id=:pid")
        ->execute([':pid'=>$payment_id]);
}

    $pdo->commit();

    echo json_encode(['ok'=>true, 'payment_id'=>$payment_id]);

} catch (Exception $e) {
    $pdo->rollBack();
    echo json_encode(['ok'=>false, 'msg'=>$e->getMessage()]);
}
