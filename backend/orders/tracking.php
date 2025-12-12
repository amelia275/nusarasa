<?php
require_once __DIR__ . '/../_db.php';
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $order_id = intval($_GET['order_id'] ?? 0);
    if (!$order_id) { echo json_encode([]); exit; }
    $stmt = $pdo->prepare("SELECT * FROM tracking WHERE order_id = :oid ORDER BY updated_at DESC");
    $stmt->execute([':oid'=>$order_id]);
    echo json_encode($stmt->fetchAll());
    exit;
}

if ($method === 'POST') {
    $body = json_decode(file_get_contents('php://input'), true);
    $order_id = intval($body['order_id'] ?? 0);
    $allowed = ['pending','in_kitchen','out_for_delivery'];
    $status = in_array($body['status'] ?? '', $allowed) ? $body['status'] : 'pending';
    $note = trim($body['note'] ?? '');

    if (!$order_id) { http_response_code(422); echo json_encode(['err'=>'No order id']); exit; }

    $stmt = $pdo->prepare("INSERT INTO tracking (order_id, status, note) VALUES (:oid, :st, :note)");
    $stmt->execute([':oid'=>$order_id, ':st'=>$status, ':note'=>$note]);

    // update orders.status mapping (kitchen statuses map to orders.status)
    $map = [
      'pending' => 'Pending',
      'in_kitchen' => 'Diproses',
      'out_for_delivery' => 'Selesai'
    ];
    $newOrderStatus = $map[$status] ?? 'Pending';
    $pdo->prepare("UPDATE orders SET status = :st WHERE order_id = :oid")->execute([':st'=>$newOrderStatus, ':oid'=>$order_id]);

    echo json_encode(['success'=>true]);
    exit;
}
