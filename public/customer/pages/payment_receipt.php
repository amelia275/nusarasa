<?php
require_once __DIR__ . '/../../../backend/_db.php';

$payment_id = intval($_GET['id'] ?? 0);
if (!$payment_id) die("Invalid payment ID.");

// Query disesuaikan dengan struktur tabel orders (tidak ada customer_name)
$stmt = $pdo->prepare("
    SELECT 
        p.*, 
        o.order_number, 
        o.table_number
    FROM payments p
    JOIN orders o ON p.order_id = o.order_id
    WHERE p.payment_id = :pid
");
$stmt->execute([':pid' => $payment_id]);
$pay = $stmt->fetch();

if (!$pay) die("Payment not found.");
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Struk Pembayaran</title>
<style>
body { font-family: Arial; max-width: 380px; margin: auto; padding: 20px; }
h2 { text-align: center; }
.box { border: 1px dashed #000; padding: 15px; margin-top: 20px; }
</style>
</head>
<body>

<h2>STRUK PEMBAYARAN</h2>

<div class="box">
    <p><b>Order No:</b> <?= $pay['order_number'] ?></p>
    <p><b>Meja:</b> <?= $pay['table_number'] ?></p>
    <p><b>Metode:</b> <?= strtoupper($pay['payment_method']) ?></p>
    <p><b>Tanggal:</b> <?= $pay['payment_date'] ?></p>
    <p><b>Total:</b> Rp <?= number_format($pay['amount'], 0, ',', '.') ?></p>
    <p><b>Status:</b> <?= strtoupper($pay['status']) ?></p>
</div>

<br>
<button onclick="window.print()">Print</button>

</body>
</html>
