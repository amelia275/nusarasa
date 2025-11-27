<?php
require_once __DIR__ . '/../_db.php';
$from = $_GET['from'] ?? null; // YYYY-MM-DD
$to = $_GET['to'] ?? null;

$sql = "SELECT o.*, GROUP_CONCAT(CONCAT(oi.menu_id,':',oi.quantity) SEPARATOR ';') AS items
        FROM orders o
        LEFT JOIN order_items oi ON oi.order_id = o.order_id
        WHERE o.status = 'Selesai' ";

$params = [];
if ($from) { $sql .= " AND o.completed_at >= :from "; $params[':from']=$from . ' 00:00:00'; }
if ($to)   { $sql .= " AND o.completed_at <= :to ";   $params[':to']=$to . ' 23:59:59'; }
$sql .= " GROUP BY o.order_id ORDER BY o.completed_at DESC LIMIT 500";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
echo json_encode($stmt->fetchAll());
