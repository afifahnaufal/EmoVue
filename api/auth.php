<?php
require_once '../config/db_config.php';
header('Content-Type: application/json');

// Handle user authentication
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (isset($data['username']) && isset($data['password'])) {
        $username = mysqli_real_escape_string($conn, $data['username']);
        $password = $data['password'];
        
        // Check if user exists
        $sql = "SELECT id, password FROM users WHERE username = '$username'";
        $result = mysqli_query($conn, $sql);
        
        if (mysqli_num_rows($result) === 1) {
            $user = mysqli_fetch_assoc($result);
            if (password_verify($password, $user['password'])) {
                echo json_encode(['success' => true, 'user_id' => $user['id']]);
            } else {
                http_response_code(401);
                echo json_encode(['success' => false, 'message' => 'Kata sandi salah']);
            }
        } else {
            http_response_code(404);
            echo json_encode(['success' => false, 'message' => 'Pengguna tidak ditemukan']);
        }
    } else {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Kredensial tidak lengkap']);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metode tidak diizinkan']);
}
?>
