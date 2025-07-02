<?php
require_once '../config/db_config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['user_id'])) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Authentication required']);
        exit;
    }

    // Validasi semua field
    $required_fields = ['emotion', 'intensity', 'emotion_trigger', 'notes'];
    foreach ($required_fields as $field) {
        if (!isset($data[$field]) || $data[$field] === '') {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => "Missing required field: $field"]);
            exit;
        }
    }

    // Simpan ke variabel
    $user_id = intval($data['user_id']);
    $emotion = $data['emotion'];
    $intensity = intval($data['intensity']);
    $trigger = $data['emotion_trigger'];
    $notes = $data['notes'];

    // Siapkan statement
    $stmt = $conn->prepare("INSERT INTO emotion_logs (user_id, emotion, intensity, emotion_trigger, notes) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("isiss", $user_id, $emotion, $intensity, $trigger, $notes);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Emotion logged successfully']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error logging emotion: ' . $stmt->error]);
    }

    $stmt->close();
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
