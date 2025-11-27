<?php
require_once __DIR__ . '/../_db.php';
$from = $_GET['from'] ?? null;
$to = $_GET['to'] ?? null;

$sql = "SELECT sl.*, i.item_name FROM stock_logs sl JOIN inventory i ON i.inventory_id = sl.inventory_id WHERE 1=1";
$params = [];
if ($from) { $sql .= " AND sl.created_at >= :from"; $params[':from']=$from.' 00:00:00'; }
if ($to)   { $sql .= " AND sl.created_at <= :to";   $params[':to']=$to.' 23:59:59'; }
$sql .= " ORDER BY sl.created_at DESC LIMIT 1000";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
echo json_encode($stmt->fetchAll());
