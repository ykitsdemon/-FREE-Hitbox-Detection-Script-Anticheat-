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