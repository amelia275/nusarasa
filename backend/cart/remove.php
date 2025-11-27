<?php
header('Content-Type: application/json');
session_start();
require_once __DIR__ . '/../_db.php';

$cart_id = intval($_POST['cart_id'] ?? 0);
if (!$cart_id) { echo json_encode(['ok'=>false,'msg'=>'Missing cart_id']); exit; }

$d = $pdo->prepare("DELETE FROM carts WHERE cart_id = :cid");
$d->execute(['cid'=>$cart_id]);

echo json_encode(['ok'=>true]);
