<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';
$stmt = $pdo->query("SELECT * FROM inventory ORDER BY item_name");
$data = $stmt->fetchAll();
echo json_encode(['ok'=>true,'data'=>$data]);
