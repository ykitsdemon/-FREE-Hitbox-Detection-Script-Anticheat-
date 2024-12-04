CREATE TABLE IF NOT EXISTS player_bans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_identifier VARCHAR(50) NOT NULL,
    player_name VARCHAR(100),
    ban_reason TEXT NOT NULL,
    ban_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ban_duration INT DEFAULT 0, -- Duration in minutes (0 = permanent)
    UNIQUE KEY unique_identifier (player_identifier)
);
