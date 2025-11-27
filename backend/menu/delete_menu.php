<?php
require_once __DIR__ . '/../_db.php';
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); echo json_encode(['err'=>'Method not allowed']); exit; }
$menu_id = intval($_POST['menu_id'] ?? 0);
if (!$menu_id) { http_response_code(422); echo json_encode(['err'=>'No id']); exit; }

// fetch image
$stmt = $pdo->prepare("SELECT image FROM menu_items WHERE menu_id = :id");
$stmt->execute([':id'=>$menu_id]);
$row = $stmt->fetch();
if ($row && $row['image']) {
    $path = __DIR__ . '/../' . $row['image'];
    if (file_exists($path)) @unlink($path);
}

$del = $pdo->prepare("DELETE FROM menu_items WHERE menu_id = :id");
$del->execute([':id'=>$menu_id]);
echo json_encode(['success'=>true]);
