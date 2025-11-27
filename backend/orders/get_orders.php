<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';
$on = $_GET['order_number'] ?? '';
if (!$on) { echo json_encode(['ok'=>false,'msg'=>'Missing']); exit; }

$stmt = $pdo->prepare("SELECT o.*, p.status as payment_status, p.amount FROM orders o LEFT JOIN payments p ON p.order_id = o.order_id WHERE o.order_number = :on LIMIT 1");
$stmt->execute(['on'=>$on]);
$order = $stmt->fetch();
if (!$order) { echo json_encode(['ok'=>false,'msg'=>'Not found']); exit; }

$it = $pdo->prepare("SELECT oi.*, mi.name FROM order_items oi LEFT JOIN menu_items mi ON mi.menu_id = oi.menu_id WHERE oi.order_id = :oid");
$it->execute(['oid'=>$order['order_id']]);
$order_items = $it->fetchAll();

echo json_encode(['ok'=>true,'order'=>$order,'items'=>$order_items]);
