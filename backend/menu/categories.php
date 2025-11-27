<?php
header('Content-Type: application/json');

require_once __DIR__ . '/../_db.php';

$stmt = $pdo->query("SELECT category_id, category_name FROM categories ORDER BY category_name");
$rows = $stmt->fetchAll();

echo json_encode($rows);
