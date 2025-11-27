<?php
require_once __DIR__ . '/../_db.php';

$on = $_GET['order_number'] ?? '';
$stmt = $pdo->prepare("SELECT order_id FROM orders WHERE order_number = :on LIMIT 1");
$stmt->execute([':on'=>$on]);
$row = $stmt->fetch();

echo json_encode($row ?: []);
