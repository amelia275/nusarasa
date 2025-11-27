<?php
require_once __DIR__ . '/../_db.php';
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405); echo json_encode(['error'=>'Method not allowed']); exit;
}
$menu_id = intval($_POST['menu_id'] ?? 0);
if (!$menu_id) { http_response_code(422); echo json_encode(['error'=>'No id']); exit; }
$name = trim($_POST['name'] ?? '');
$price = floatval($_POST['price'] ?? 0);
$description = trim($_POST['description'] ?? '');
$category_id = intval($_POST['category_id'] ?? 0);
$status = in_array($_POST['status'] ?? 'available', ['available','unavailable']) ? $_POST['status'] : 'available';

$fields = "name=:name, price=:price, description=:desc, category_id=NULLIF(:category_id,0), status=:status";
$params = [':name'=>$name,':price'=>$price,':desc'=>$description,':category_id'=>$category_id,':status'=>$status,':menu_id'=>$menu_id];

// image?
if (!empty($_FILES['image']['name'])) {
  $uploaddir = __DIR__ . '/../uploads/menu/';
  if (!is_dir($uploaddir)) mkdir($uploaddir,0755,true);
  $ext = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
  $fname = 'menu_' . time() . '_' . bin2hex(random_bytes(4)) . '.' . $ext;
  $dest = $uploaddir . $fname;
  if (move_uploaded_file($_FILES['image']['tmp_name'], $dest)) {
    $imagePath = 'uploads/menu/' . $fname;
    $fields .= ", image=:image";
    $params[':image'] = $imagePath;
  }
}

$sql = "UPDATE menu_items SET $fields WHERE menu_id = :menu_id";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
echo json_encode(['success'=>true]);
