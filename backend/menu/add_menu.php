<?php
require_once __DIR__ . '/../_db.php';

// only POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error'=>'Method not allowed']);
    exit;
}

$name = trim($_POST['name'] ?? '');
$price = floatval($_POST['price'] ?? 0);
$description = trim($_POST['description'] ?? '');
$category_id = intval($_POST['category_id'] ?? 0);
$status = in_array($_POST['status'] ?? 'available', ['available','unavailable']) ? $_POST['status'] : 'available';
$imagePath = null;

if ($name === '' || $price <= 0) {
    http_response_code(422);
    echo json_encode(['error'=>'Invalid name or price']);
    exit;
}

// handle upload
if (!empty($_FILES['image']['name'])) {
    $uploaddir = __DIR__ . '/../uploads/menu/';
    if (!is_dir($uploaddir)) mkdir($uploaddir, 0755, true);
    $ext = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
    $fname = 'menu_' . time() . '_' . bin2hex(random_bytes(4)) . '.' . $ext;
    $dest = $uploaddir . $fname;
    if (move_uploaded_file($_FILES['image']['tmp_name'], $dest)) {
        $imagePath = 'uploads/menu/' . $fname;
    }
}

$sql = "INSERT INTO menu_items (name, category_id, description, price, image, status)
        VALUES (:name, NULLIF(:category_id, 0), :desc, :price, :image, :status)";
$stmt = $pdo->prepare($sql);
$stmt->execute([
    ':name'=>$name, ':category_id'=>$category_id, ':desc'=>$description,
    ':price'=>$price, ':image'=>$imagePath, ':status'=>$status
]);

echo json_encode(['success'=>true, 'menu_id'=>$pdo->lastInsertId()]);
