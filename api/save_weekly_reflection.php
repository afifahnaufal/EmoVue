<?php
require_once '../config/db_config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    // Validasi input
    $required_fields = ['user_id', 'week_start', 'reflection_text'];
    foreach ($required_fields as $field) {
        if (!isset($data[$field]) || empty($data[$field])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => "Missing required field: $field"]);
            exit;
        }
    }

    try {
        // Prepare statement
        $stmt = $conn->prepare("
            INSERT INTO weekly_reflections 
            (user_id, week_start, reflection_text, created_at) 
            VALUES (?, ?, ?, NOW())
        ");
        
        // Bind parameters
        $user_id = intval($data['user_id']);
        $week_start = $data['week_start'];
        $reflection_text = $data['reflection_text'];
        
        $stmt->bind_param("iss", $user_id, $week_start, $reflection_text);
        
        // Execute
        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Weekly reflection saved successfully']);
        } else {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'Error saving reflection: ' . $stmt->error]);
        }
        
        $stmt->close();
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Server error: ' . $e->getMessage()]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
