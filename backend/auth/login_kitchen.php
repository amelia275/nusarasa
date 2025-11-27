<?php
header('Content-Type: application/json');
require_once __DIR__ . '/../_db.php';

$post = json_decode(file_get_contents('php://input'), true);
if (!$post) { echo json_encode(['ok'=>false,'msg'=>'no input']); exit; }
$username = $post['username'] ?? '';
$password = $post['password'] ?? '';

$stmt = $pdo->prepare("SELECT user_id, username, password, role FROM users WHERE username = :u LIMIT 1");
$stmt->execute(['u'=>$username]);
$user = $stmt->fetch();
if (!$user) {
  echo json_encode(['ok'=>false,'msg'=>'Invalid user']);
  exit;
}

// NOTE: in dump passwords are plain — change to password_hash in production.
// For now allow either plaintext or hashed.
$valid = password_verify($password, $user['password'] ?? '') || ($password === $user['password']);
if (!$valid) {
  echo json_encode(['ok'=>false,'msg'=>'Invalid credentials']);
  exit;
}

// create simple session token (demo)
$token = base64_encode($user['user_id'].'|'.$user['username'].'|'.time());
echo json_encode(['ok'=>true,'token'=>$token,'user'=>['id'=>$user['user_id'],'username'=>$user['username'],'role'=>$user['role'] ]]);
