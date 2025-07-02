<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

date_default_timezone_set('Asia/Jakarta');

require_once '../config/db_config.php';

// Ensure database connection is established
if (!$conn) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Database connection failed']);
    exit;
}

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : null;

    if (!$user_id) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'User ID is required']);
        exit;
    }

    try {
        // Get current timestamp and start of week
        $now = date('Y-m-d H:i:s');
        $start_of_week = date('Y-m-d 00:00:00', strtotime('-6 days')); // 7 hari termasuk hari ini
        // var_dump($start_of_week);
        // Check if emotion_logs table exists
        $check_sql = "SHOW TABLES LIKE 'emotion_logs'";
        $result = $conn->query($check_sql);
        
        if ($result->num_rows == 0) {
            throw new Exception('Emotion logs table does not exist');
        }

        // Prepare SQL query
        $sql = "SELECT 
                    DATE_FORMAT(created_at, '%Y-%m-%d') as date,
                    emotion,
                    intensity,
                    emotion_trigger,
                    notes
                FROM emotion_logs
                WHERE user_id = ? 
                  AND created_at >= ? AND created_at <= ?
                ORDER BY created_at DESC";

        $stmt = $conn->prepare($sql);
        if (!$stmt) {
            throw new Exception('Prepare failed: ' . $conn->error);
        }

        if (!$stmt->bind_param("iss", $user_id, $start_of_week, $now)) {
            throw new Exception('Bind param failed: ' . $stmt->error);
        }

        $stmt->execute();
        $result = $stmt->get_result();

        $emotions = [];
        while ($row = $result->fetch_assoc()) {
            // Normalisasi nama emosi agar selalu sesuai frontend
            $map = [
                'happy' => 'Senang',
                'angry' => 'Marah',
                'sad' => 'Sedih',
                'neutral' => 'Netral',
                'stress' => 'Stres',
                'senang' => 'Senang',
                'marah' => 'Marah',
                'sedih' => 'Sedih',
                'netral' => 'Netral',
                'stres' => 'Stres'
            ];
            $e = strtolower($row['emotion']);
            if (isset($map[$e])) $row['emotion'] = $map[$e];
            else $row['emotion'] = ucfirst($e); // fallback
            $emotions[] = $row;
        }
        $stmt->close();

        // Hitung statistik
        $statistics = calculateEmotionStats($emotions);

        echo json_encode([
            'success' => true,
            'start_date' => $start_of_week,
            'end_date' => $now,
            'data' => $emotions,
            'statistics' => $statistics
        ]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'message' => 'Server error: ' . $e->getMessage(),
            'error' => $e->getMessage()
        ]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}

// Fungsi untuk menghitung statistik emosi
function calculateEmotionStats($emotions) {
    $types = ['Senang', 'Marah', 'Stres', 'Sedih'];
    $stats = [
        'total' => count($emotions),
        'by_type' => array_fill_keys($types, 0),
        'intensity' => [
            'average' => 0,
            'max' => 0,
            'min' => 100
        ]
    ];

    foreach ($emotions as $emotion) {
        $type = $emotion['emotion'];
        if (isset($stats['by_type'][$type])) {
            $stats['by_type'][$type]++;
        }

        $intensity = floatval($emotion['intensity']);
        $stats['intensity']['average'] += $intensity;

        if ($intensity > $stats['intensity']['max']) {
            $stats['intensity']['max'] = $intensity;
        }
        if ($intensity < $stats['intensity']['min']) {
            $stats['intensity']['min'] = $intensity;
        }
    }

    if ($stats['total'] > 0) {
        $stats['intensity']['average'] = round($stats['intensity']['average'] / $stats['total'], 2);
    } else {
        $stats['intensity']['min'] = 0;
    }

    return $stats;
}
?>
