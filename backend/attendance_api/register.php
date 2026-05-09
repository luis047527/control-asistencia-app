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

$name = trim($_POST['name'] ?? '');
$email = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';

if ($name === '' || $email === '' || $password === '') {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Completa nombre, correo y contrasena.',
    ]);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Ingresa un correo valido.',
    ]);
    exit;
}

if (strlen($password) < 6) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'La contrasena debe tener al menos 6 caracteres.',
    ]);
    exit;
}

$statement = $pdo->prepare('SELECT id FROM users WHERE email = :email LIMIT 1');
$statement->execute(['email' => $email]);

if ($statement->fetch()) {
    http_response_code(409);
    echo json_encode([
        'success' => false,
        'message' => 'Este correo ya esta registrado.',
    ]);
    exit;
}

$passwordHash = password_hash($password, PASSWORD_DEFAULT);

$statement = $pdo->prepare(
    'INSERT INTO users (name, email, password, role, active)
     VALUES (:name, :email, :password, :role, :active)'
);
$statement->execute([
    'name' => $name,
    'email' => $email,
    'password' => $passwordHash,
    'role' => 'employee',
    'active' => 1,
]);

$userId = (int) $pdo->lastInsertId();

echo json_encode([
    'success' => true,
    'message' => 'Registro completado.',
    'user' => [
        'id' => $userId,
        'name' => $name,
        'email' => $email,
        'role' => 'employee',
        'active' => 1,
    ],
]);
