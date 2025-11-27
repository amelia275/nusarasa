<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../_db.php';

// optional filters: status, from, to
$status = $_GET['status'] ?? null;
$from = $_GET['from'] ?? null;
$to = $_GET['to'] ?? null;

$where = [];
$params = [];

if ($status) { 
    $where[] = "o.status = :status"; 
    $params[':status'] = $status; 
}
if ($from) { 
    $where[] = "DATE(o.created_at) >= :from"; 
    $params[':from'] = $from; 
}
if ($to) {
    $where[] = "DATE(o.created_at) <= :to";   
    $params[':to'] = $to; 
}

$sql = "SELECT o.* FROM orders o";
if ($where) $sql .= " WHERE " . implode(' AND ', $where);
$sql .= " ORDER BY o.created_at DESC LIMIT 500";

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$orders = $stmt->fetchAll();

foreach ($orders as &$o) {

    // ambil items
    $si = $pdo->prepare("
        SELECT oi.order_item_id, oi.menu_id, oi.quantity, oi.subtotal, oi.note, m.name 
        FROM order_items oi 
        LEFT JOIN menu_items m ON oi.menu_id=m.menu_id 
        WHERE oi.order_id = :oid
    ");
    $si->execute([':oid'=>$o['order_id']]);
    $o['items'] = $si->fetchAll();

    // ambil payment terbaru
    $p = $pdo->prepare("SELECT * FROM payments WHERE order_id=:oid ORDER BY payment_id DESC LIMIT 1");
    $p->execute([':oid'=>$o['order_id']]);
    $o['payment'] = $p->fetch();

    // ambil tracking terbaru
    $t = $pdo->prepare("SELECT * FROM tracking WHERE order_id = :oid ORDER BY updated_at DESC LIMIT 1");
    $t->execute([':oid'=>$o['order_id']]);
    $o['tracking'] = $t->fetch();
}

echo json_encode(['ok'=>true, 'data'=>$orders]);
