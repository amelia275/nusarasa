<?php
header('Content-Type: application/json');
session_start();
require_once __DIR__ . '/../_db.php';

$cart_id = intval($_POST['cart_id'] ?? 0);
$qty = max(1, intval($_POST['quantity'] ?? 1));
$note = trim($_POST['note'] ?? '');

if (!$cart_id) { echo json_encode(['ok'=>false,'msg'=>'Missing cart_id']); exit; }

$u = $pdo->prepare("UPDATE carts SET quantity = :q, note = :note WHERE cart_id = :cid");
$u->execute(['q'=>$qty,'note'=>$note,'cid'=>$cart_id]);

echo json_encode(['ok'=>true]);
