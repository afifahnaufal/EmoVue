USE emosync;

-- Create emotions table
CREATE TABLE IF NOT EXISTS emotions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emotion VARCHAR(50) NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert some sample emotions
INSERT INTO emotions (emotion) VALUES ('Marah'), ('Stres'), ('Sedih'), ('Senang'), ('Tenang');

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create user_emotions table to track emotions per user
CREATE TABLE IF NOT EXISTS user_emotions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    emotion_id INT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
