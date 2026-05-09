CREATE DATABASE IF NOT EXISTS attendance_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE attendance_db;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('admin', 'employee') NOT NULL DEFAULT 'employee',
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email, password, role, active)
VALUES
  (
    'Administrador',
    'admin@lumibell.com',
    '$2y$10$jbB31ldkVDbg2hpSpj8g4.53mshfkKkR1mLSarxTKhxs8fWRaUh4m',
    'admin',
    1
  ),
  (
    'Empleado Demo',
    'empleado@lumibell.com',
    '$2y$10$jbB31ldkVDbg2hpSpj8g4.53mshfkKkR1mLSarxTKhxs8fWRaUh4m',
    'employee',
    1
  )
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  password = VALUES(password),
  role = VALUES(role),
  active = VALUES(active);
