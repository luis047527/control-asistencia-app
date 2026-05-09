<?php
declare(strict_types=1);

require_once __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'message' => 'Metodo no permitido.',
    ]);
    exit;
}

$email = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';

if ($email === '' || $password === '') {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Ingresa correo y contrasena.',
    ]);
    exit;
}

$statement = $pdo->prepare(
    'SELECT id, name, email, password, role, active FROM users WHERE email = :email LIMIT 1'
);
$statement->execute(['email' => $email]);
$user = $statement->fetch();

if (!$user || (int) $user['active'] !== 1) {
    http_response_code(401);
    echo json_encode([
        'success' => false,
        'message' => 'Correo o contrasena incorrectos.',
    ]);
    exit;
}

$storedPassword = (string) $user['password'];
$validPassword = password_verify($password, $storedPassword);

// Temporary compatibility for old test rows saved as plain text.
// Prefer storing password_hash($password, PASSWORD_DEFAULT) in production.
if (!$validPassword && hash_equals($storedPassword, $password)) {
    $validPassword = true;
}

if (!$validPassword) {
    http_response_code(401);
    echo json_encode([
        'success' => false,
        'message' => 'Correo o contrasena incorrectos.',
    ]);
    exit;
}

unset($user['password']);

echo json_encode([
    'success' => true,
    'message' => 'Inicio de sesion correcto.',
    'user' => $user,
]);
