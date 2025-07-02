<?php
header('Content-Type: application/json');

try {
    // Get input text
    $data = json_decode(file_get_contents('php://input'), true);
    $text = $data['text'] ?? '';
    $text = strtolower($text); // Convert to lowercase for case-insensitive matching

    // Define emotion levels
    $emotionLevels = [
        'negative' => [
            'keywords' => ['marah', 'stres', 'sedih', 'kesal', 'kecewa', 'frustasi'],
            'severity' => 1
        ],
        'severe_negative' => [
            'keywords' => ['stress berat', 'marah berat', 'sangat marah', 'sangat stress', 'depresi', 'putus asa'],
            'severity' => 3
        ]
    ];

    // Check for severe negative emotions first
    $severity = 0;
    $matchedEmotions = [];
    
    foreach ($emotionLevels as $level => $data) {
        foreach ($data['keywords'] as $keyword) {
            if (stripos($text, $keyword) !== false) {
                $severity = $data['severity'];
                $matchedEmotions[] = $keyword;
            }
        }
    }

    // Only show alert for severe negative emotions (severity 3)
    $hasAlert = $severity >= 3;
    $alert = [
        'hasAlert' => $hasAlert,
        'message' => $hasAlert ? "Deteksi Emosi Negatif: {$text}" : '',
        'suggestions' => $hasAlert ? [
            "Ambil beberapa tarikan napas dalam-dalam",
            "Beristirahat sejenak dan berpindah dari situasi yang memicu",
            "Coba lakukan meditasi singkat",
            "Minum air putih untuk menenangkan diri",
            "Berbicara dengan rekan kerja atau teman yang dipercaya",
            "Hubungi profesional kesehatan mental jika perlu"
        ] : [],
        'debug' => [
            'severity' => $severity,
            'matched_emotions' => $matchedEmotions
        ]
    ];

    echo json_encode($alert);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Terjadi kesalahan saat menganalisis emosi',
        'debug' => $e->getMessage()
    ]);
}
