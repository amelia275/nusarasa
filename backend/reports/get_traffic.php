<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../_db.php';

$data = [];
$data['total_orders'] = (int)$pdo->query("SELECT COUNT(*) FROM orders")->fetchColumn();
$data['today_orders'] = (int)$pdo->query("SELECT COUNT(*) FROM orders WHERE DATE(created_at)=CURDATE()")->fetchColumn();
$data['total_payments'] = (float)$pdo->query("SELECT IFNULL(SUM(amount),0) FROM payments WHERE status='success'")->fetchColumn();

echo json_encode(['ok'=>true, 'data'=>$data]);
