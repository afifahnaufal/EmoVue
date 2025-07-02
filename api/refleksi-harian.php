<?php
header('Content-Type: application/json');
require_once '../config.php'; // Pastikan file ini ada untuk koneksi DB

$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;
if ($user_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'user_id diperlukan']);
    exit;
}

$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
if ($mysqli->connect_errno) {
    echo json_encode(['success' => false, 'message' => 'Gagal koneksi DB']);
    exit;
}

$stmt = $mysqli->prepare("SELECT emotion, notes, created_at FROM emotion_logs WHERE user_id = ? ORDER BY created_at DESC LIMIT 1");
$stmt->bind_param('i', $user_id);
$stmt->execute();
$stmt->store_result();
$stmt->bind_result($emotion, $notes, $created_at);

if ($stmt->num_rows > 0) {
    $stmt->fetch();
    // Mapping emoji
    $emoji_map = [
        'senang' => '😊',
        'sedih'  => '😢',
        'marah'  => '😡',
        'stres'  => '😣',
        'netral' => '😐',
    ];
    $emoji = isset($emoji_map[strtolower($emotion)]) ? $emoji_map[strtolower($emotion)] : '';
    echo json_encode([
        'success' => true,
        'data' => [
            'emotion' => strtolower($emotion),
            'emoji' => $emoji,
            'notes' => $notes,
            'tanggal' => $created_at
        ]
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'Data tidak ditemukan']);
}
$stmt->close();
$mysqli->close();
