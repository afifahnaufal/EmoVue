<?php
require_once 'config/db_config.php';

// Insert default user
$sql = "INSERT INTO users (username, password, email) VALUES 
        ('default_user', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'default@example.com')";

if (mysqli_query($conn, $sql)) {
    echo "Default user created successfully!";
} else {
    echo "Error: " . mysqli_error($conn);
}

mysqli_close($conn);
