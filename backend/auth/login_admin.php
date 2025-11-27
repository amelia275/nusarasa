<?php
header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/../_db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405); echo json_encode(['error'=>'Method not allowed']); exit;
}

$username = trim($_POST['username'] ?? '');
$password = trim($_POST['password'] ?? '');

if (!$username || !$password) { http_response_code(422); echo json_encode(['error'=>'Missing credentials']); exit; }

$stmt = $pdo->prepare("SELECT user_id, username, password, role FROM users WHERE username = :u LIMIT 1");
$stmt->execute([':u'=>$username]);
$user = $stmt->fetch();

if (!$user) {
  http_response_code(401); echo json_encode(['ok'=>false,'error'=>'Invalid login']); exit;
}

// support hashed and plaintext (legacy)
$stored = $user['password'];
$ok = false;
if (password_get_info($stored)['algo']) {
  if (password_verify($password, $stored)) $ok = true;
} else {
  if ($password === $stored) $ok = true;
}

if (!$ok) { http_response_code(401); echo json_encode(['ok'=>false,'error'=>'Invalid login']); exit; }

// return basic info (frontend can store session as needed)
echo json_encode(['ok'=>true, 'user'=>['user_id'=>$user['user_id'],'username'=>$user['username'],'role'=>$user['role']]]);
