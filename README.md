# [FREE] Hitbox Detection Script (AntiCheat)

## Description
This is a **hitbox detection** script designed for **FiveM**. It helps identify and flag players that are suspected of manipulating their hitboxes to gain an unfair advantage in the game. This script will detect suspicious hitbox activity based on thresholds for hit frequency and accuracy, and then take actions such as **kicking** or **banning** the flagged players. The script also sends logs to a **Discord webhook** for your admins to monitor the detected activity.

## Features
- Detects suspicious hitbox activity based on hit frequency and accuracy.
- **Kicks** or **bans** flagged players.
- Logs detected activity and actions to a **Discord webhook**.
- **MySQL Database Integration** for storing player bans (using either **oxmysql** or **mysql-async**).
- Configurable settings for Discord webhook, hitbox thresholds, and actions (kick/ban).
- Easy integration with your FiveM server and database resources.

## Installation

### 1. Download the Script
Download the script from the repository or clone it into your FiveM server’s resource folder.

### 2. Add the Script to `server.cfg`
Add the following line to your `server.cfg` to start the resource:
```
ensure Ricos_HitboxDetectionScript
```

### 3. Configure the Script
Before running the script, configure the settings in the `config.lua` file.
- **Webhook URL**: Replace with your Discord webhook URL to send notifications.
- **Bot Name**: Customize the bot's name that will send the notifications.
- **Thresholds**: Set the hit frequency and accuracy thresholds for detecting suspicious activity.
- **Actions**: Choose whether to kick or ban flagged players, and set ban duration if applicable.
- **Database**: Choose between **oxmysql** or **mysql-async** for storing ban data.

### 4. Database Setup
Ensure that you have either **oxmysql** or **mysql-async** installed on your server. The script uses these to log player bans into the database.

#### SQL Table for Bans
Make sure to create the following table in your database to store player ban data:
```sql
CREATE TABLE IF NOT EXISTS `player_bans` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `player_identifier` VARCHAR(255) NOT NULL,
  `player_name` VARCHAR(255) NOT NULL,
  `ban_reason` TEXT NOT NULL,
  `ban_start` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `ban_duration` INT NOT NULL
);
```

## Configuration Guide

### config.lua

```lua
-- ===========================================================
-- Config file for the Hitbox Detection Script
-- DO NOT EDIT OR REMOVE THE COMMENTED GUIDES UNLESS YOU KNOW WHAT YOU'RE DOING
-- ===========================================================

Config = {}  -- ( NO TOUCHY! )

-- ===========================================================
-- Discord Webhook Settings
-- ===========================================================

Config.WebhookURL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"  -- CHANGE ME!
Config.BotName = "Rico's Hitbox Monitor"  -- The name of the bot that sends messages -- CHANGE ME!
Config.BotLogo = "https://your-image-url.com/logo.png"  -- URL for the bot's avatar image -- CHANGE ME!
Config.EmbedImage = "https://your-image-url.com/embed-image.png"  -- URL for the embed's image -- CHANGE ME!

-- ===========================================================
-- Hitbox Detection Thresholds
-- ===========================================================

Config.HitFrequencyThreshold = 10  -- Max hits allowed per minute ( DON'T TOUCH unless you know what you're doing )
Config.HitAccuracyThreshold = 95  -- Max hit accuracy percentage allowed ( DON'T TOUCH unless you know what you're doing )

-- ===========================================================
-- Action Settings
-- ===========================================================

Config.EnableKick = true  -- Set to true to kick flagged players 
Config.EnableBan = true   -- Set to true to ban flagged players 

-- ONLY HAVE ONE OF THESE ON at a time! Disable the other to choose between kicking or banning.
Config.KickReason = "You have been KICKED for suspicious hitbox activity detected. This is an automated system, please contact server staff/owner if this was a mistake."
Config.BanTime = 60  -- Ban duration in minutes (set to 0 for a permanent ban)

-- ===========================================================
-- Database Settings
-- ===========================================================

Config.DatabaseResource = "oxmysql"  -- Set to "oxmysql" or "mysql-async" (Choose the resource you are using)
```

### Key Options:
- **WebhookURL**: Discord webhook to log events.
- **BotName**: Name of the bot sending the logs.
- **BotLogo**: Avatar image URL for the bot.
- **EmbedImage**: Image URL for the embedded log.
- **HitFrequencyThreshold**: Maximum number of hits allowed per minute.
- **HitAccuracyThreshold**: Maximum allowed hit accuracy percentage.
- **EnableKick**: Set to `true` to kick flagged players.
- **EnableBan**: Set to `true` to ban flagged players.
- **KickReason**: Reason given to players who are kicked.
- **BanTime**: Duration for which a player is banned (in minutes).
- **DatabaseResource**: Set to "oxmysql" or "mysql-async" based on your choice of database resource.

## Usage
- The script will monitor hitbox activity for players.
- If a player’s hit frequency or accuracy exceeds the defined thresholds, they will be flagged.
- Based on your configuration, the flagged player will either be kicked or banned.
- Ban data will be logged in the database, and notifications will be sent to your configured Discord webhook.

## License
This script is **free** to use. However, you are not allowed to redistribute it for profit or without proper attribution.

## Support
For any issues or questions, feel free to raise an issue in the GitHub repository.
