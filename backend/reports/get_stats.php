<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';

// today's sales
$stmt = $pdo->prepare("SELECT SUM(p.amount) as total FROM payments p WHERE DATE(p.payment_date) = CURDATE() AND p.status='success'");
$stmt->execute();
$today = $stmt->fetchColumn();

// top menu (last 30 days)
$stmt = $pdo->prepare("SELECT mi.name, SUM(oi.quantity) as sold FROM order_items oi JOIN menu_items mi ON mi.menu_id = oi.menu_id JOIN orders o ON o.order_id = oi.order_id WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) GROUP BY oi.menu_id ORDER BY sold DESC LIMIT 5");
$stmt->execute();
$top = $stmt->fetchAll();

// low stocks
$stmt = $pdo->prepare("SELECT inventory_id, item_name, quantity FROM inventory WHERE quantity <= 5 ORDER BY quantity ASC LIMIT 10");
$stmt->execute();
$low = $stmt->fetchAll();

// recent orders
$stmt = $pdo->prepare("SELECT order_number, table_number, status, created_at FROM orders ORDER BY created_at DESC LIMIT 6");
$stmt->execute();
$recent = $stmt->fetchAll();

echo json_encode(['ok'=>true,'today_sales'=>$today,'top_menu'=>$top,'low_stock'=>$low,'recent_orders'=>$recent]);
