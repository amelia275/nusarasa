<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';
$from = $_GET['from'] ?? null;
$to = $_GET['to'] ?? null;

$sql = "SELECT p.*, o.order_number, o.table_number FROM payments p JOIN orders o ON o.order_id = p.order_id WHERE 1=1 ";
$params=[];

if ($from) { $sql .= " AND p.payment_date >= :from"; $params['from']=$from.' 00:00:00'; }
if ($to) { $sql .= " AND p.payment_date <= :to"; $params['to']=$to.' 23:59:59'; }

$sql .= " ORDER BY p.payment_date DESC LIMIT 1000";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
echo json_encode(['ok'=>true,'data'=>$stmt->fetchAll()]);
