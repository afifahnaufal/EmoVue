<?php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_NAME', 'emosync');

// Attempt to connect to MySQL database using MySQLi object-oriented style
$conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD);

// Check connection
if ($conn->connect_error) {
    die("ERROR: Could not connect. " . $conn->connect_error);
}

// Create database if not exists
$sql = "CREATE DATABASE IF NOT EXISTS " . DB_NAME;
if ($conn->query($sql)) {
    $conn->select_db(DB_NAME);
} else {
    echo "ERROR: Could not execute $sql. " . $conn->error;
}

// Create users table
$sql = "CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if(!mysqli_query($conn, $sql)) {
    echo "ERROR: Could not create users table. " . mysqli_error($conn);
}

// Create teams table
$sql = "CREATE TABLE IF NOT EXISTS teams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
)";

if(!mysqli_query($conn, $sql)) {
    echo "ERROR: Could not create teams table. " . mysqli_error($conn);
}

// Create team_members table
// naon ieu errorna didieu
$sql = "CREATE TABLE IF NOT EXISTS team_members ( 
    id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT,
    user_id INT,
    role VARCHAR(50),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES teams(team_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE KEY team_user_unique (team_id, user_id)
)";

if(!mysqli_query($conn, $sql)) {
    echo "ERROR: Could not create team_members table. " . mysqli_error($conn);
}

// Create emotion_analysis table
$sql = "CREATE TABLE IF NOT EXISTS emotion_analysis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    emotion_type VARCHAR(50),
    intensity INT,
    analysis TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
)";

if(!mysqli_query($conn, $sql)) {
    echo "ERROR: Could not create emotion_analysis table. " . mysqli_error($conn);
}

// Create emotion_logs table
$sql = "CREATE TABLE IF NOT EXISTS emotion_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    emotion_type VARCHAR(50),
    intensity INT,
    trigger_text TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)";

if(!mysqli_query($conn, $sql)) {
    echo "ERROR: Could not create emotion_logs table. " . mysqli_error($conn);
}

// Create weekly_reflections table
$sql = "CREATE TABLE IF NOT EXISTS weekly_reflections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    week_start DATE,
    week_end DATE,
    reflection TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
)";

if(!mysqli_query($conn, $sql)) {
    echo "ERROR: Could not create weekly_reflections table. " . mysqli_error($conn);
}

// Create chats table
$sql = "CREATE TABLE IF NOT EXISTS chats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    message TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id)
)";

if(!mysqli_query($conn, $sql)) {
    echo "ERROR: Could not create chats table. " . mysqli_error($conn);
}
?>
