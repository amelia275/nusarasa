<?php
header('Content-Type: application/json');
session_start();
require_once __DIR__ . '/../_db.php';

$sid = session_id();

$stmt = $pdo->prepare("
  SELECT c.cart_id, c.menu_id, c.quantity, c.note, mi.name, mi.price, mi.image, c.created_at
  FROM carts c
  LEFT JOIN menu_items mi ON mi.menu_id = c.menu_id
  WHERE c.session_id = :sid
  ORDER BY c.created_at DESC
");
$stmt->execute(['sid'=>$sid]);
$rows = $stmt->fetchAll();

echo json_encode(['ok'=>true,'data'=>$rows]);
