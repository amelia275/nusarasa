<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';
$post = json_decode(file_get_contents('php://input'), true);
$inventory_id = (int)($post['inventory_id'] ?? 0);
$change = (int)($post['change'] ?? 0);
$reason = $post['reason'] ?? 'manual';

if (!$inventory_id || $change === 0) { echo json_encode(['ok'=>false,'msg'=>'missing']); exit; }
$pdo->beginTransaction();
$pdo->prepare("UPDATE inventory SET quantity = GREATEST(quantity + :chg,0) WHERE inventory_id = :iid")
    ->execute(['chg'=>$change,'iid'=>$inventory_id]);
$pdo->prepare("INSERT INTO stock_logs (inventory_id, change_amount, reason) VALUES (:iid, :chg, :r)")
    ->execute(['iid'=>$inventory_id,'chg'=>$change,'r'=>$reason]);
$pdo->commit();
echo json_encode(['ok'=>true]);
