<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';

$id = $_GET['id'] ?? null;

if ($id) {
    $stmt = $pdo->prepare("SELECT mi.*, c.category_name 
                           FROM menu_items mi
                           LEFT JOIN categories c ON c.category_id = mi.category_id
                           WHERE mi.menu_id = ?");
    $stmt->execute([$id]);
    $item = $stmt->fetch();

    if ($item) {
        $item['image'] = basename($item['image']);
    }

    echo json_encode([
        "ok" => true,
        "data" => $item
    ]);
    exit;
}

$stmt = $pdo->query("SELECT mi.*, c.category_name 
                     FROM menu_items mi 
                     LEFT JOIN categories c ON c.category_id = mi.category_id 
                     ORDER BY mi.name");

$data = $stmt->fetchAll();

foreach ($data as &$item) {
    $item['image'] = basename($item['image']);
}

echo json_encode([
    "ok" => true,
    "data" => $data
]);
