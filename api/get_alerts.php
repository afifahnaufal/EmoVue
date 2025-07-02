<?php
header('Content-Type: application/json');

try {
    // Cek koneksi database
    require_once '../config/db_config.php';
    
    if (!$conn) {
        throw new Exception('Koneksi database gagal');
    }

    // Query untuk mengambil data emosi terakhir
    $sql = "SELECT emotion_type as emotion, created_at as timestamp FROM emotion_logs ORDER BY created_at DESC LIMIT 1";
    
    if (!mysqli_query($conn, $sql)) {
        throw new Exception('Query gagal: ' . mysqli_error($conn));
    }

    $result = mysqli_query($conn, $sql);
    $row = mysqli_fetch_assoc($result);

    $alert = [
        'hasAlert' => false,
        'message' => '',
        'suggestions' => [],
        'debug' => [
            'query' => $sql,
            'result' => $row ? 'Ada' : 'Tidak ada data',
            'emotion' => $row ? $row['emotion'] : 'Tidak ada data'
        ]
    ];

    // Define severe negative emotions
    $severeEmotions = ['Stress Berat', 'Marah Berat', 'Sangat Marah', 'Sangat Stress', 'Depresi', 'Putus Asa'];

    if ($row && in_array($row['emotion'], $severeEmotions)) {
        $alert['hasAlert'] = true;
        $alert['message'] = "Deteksi Emosi Negatif: {$row['emotion']}";
        
        // Tambahkan saran-saran
        $alert['suggestions'] = [
            "Ambil beberapa tarikan napas dalam-dalam",
            "Beristirahat sejenak dan berpindah dari situasi yang memicu",
            "Coba lakukan meditasi singkat",
            "Minum air putih untuk menenangkan diri",
            "Berbicara dengan rekan kerja atau teman yang dipercaya",
            "Hubungi profesional kesehatan mental jika perlu"
        ];
    }

    echo json_encode($alert);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Terjadi kesalahan saat mengambil data peringatan',
        'debug' => $e->getMessage()
    ]);
}
?>
