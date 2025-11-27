<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';
$post = json_decode(file_get_contents('php://input'), true);
$order_number = $post['order_number'] ?? null;
if (!$order_number) { echo json_encode(['ok'=>false]); exit; }

$stmt = $pdo->prepare("SELECT order_id FROM orders WHERE order_number = :o");
$stmt->execute(['o'=>$order_number]);
$o = $stmt->fetch();
if (!$o) { echo json_encode(['ok'=>false,'msg'=>'not found']); exit; }
$order_id = $o['order_id'];

$pdo->beginTransaction();
$pdo->prepare("DELETE FROM order_items WHERE order_id = :oid")->execute(['oid'=>$order_id]);
$pdo->prepare("DELETE FROM payments WHERE order_id = :oid")->execute(['oid'=>$order_id]);
$pdo->prepare("DELETE FROM tracking WHERE order_id = :oid")->execute(['oid'=>$order_id]);
$pdo->prepare("DELETE FROM orders WHERE order_id = :oid")->execute(['oid'=>$order_id]);
$pdo->commit();

echo json_encode(['ok'=>true,'msg'=>'deleted']);
