<?php
header('Content-Type: application/json');
session_start();
require_once __DIR__ . '/../_db.php';

$menu_id = intval($_POST['menu_id'] ?? 0);
$qty = max(1, intval($_POST['quantity'] ?? 1));
$note = trim($_POST['note'] ?? '');

if (!$menu_id) { echo json_encode(['ok'=>false,'msg'=>'Missing menu_id']); exit; }

$sid = session_id();

// check if exists
$stmt = $pdo->prepare("SELECT cart_id, quantity FROM carts WHERE session_id = :sid AND menu_id = :mid LIMIT 1");
$stmt->execute(['sid'=>$sid,'mid'=>$menu_id]);
$ex = $stmt->fetch();

if ($ex) {
  $newQty = $ex['quantity'] + $qty;
  $u = $pdo->prepare("UPDATE carts SET quantity = :q, note = :note WHERE cart_id = :cid");
  $u->execute(['q'=>$newQty,'note'=>$note,'cid'=>$ex['cart_id']]);
} else {
  $i = $pdo->prepare("INSERT INTO carts (session_id, menu_id, quantity, note) VALUES (:sid,:mid,:q,:note)");
  $i->execute(['sid'=>$sid,'mid'=>$menu_id,'q'=>$qty,'note'=>$note]);
}

echo json_encode(['ok'=>true]);
