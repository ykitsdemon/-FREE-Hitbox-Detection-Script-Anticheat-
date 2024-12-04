-- Load configuration
local Config = Config or {}

local hitboxChecks = {}

-- Function to execute database queries
local function executeQuery(query, params, callback)
    if Config.DatabaseResource == "oxmysql" then
        exports.oxmysql:execute(query, params, callback)
    elseif Config.DatabaseResource == "mysql-async" then
        MySQL.Async.execute(query, params, callback)
    end
end

-- Function to fetch data from the database
local function fetchQuery(query, params, callback)
    if Config.DatabaseResource == "oxmysql" then
        exports.oxmysql:query(query, params, callback)
    elseif Config.DatabaseResource == "mysql-async" then
        MySQL.Async.fetchAll(query, params, callback)
    end
end

-- Function to log a ban into the database
local function logBan(playerId, playerIdentifier, playerName, banReason, banDuration)
    local query = [[
        INSERT INTO player_bans (player_identifier, player_name, ban_reason, ban_duration)
        VALUES (?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE 
            ban_reason = VALUES(ban_reason),
            ban_start = CURRENT_TIMESTAMP,
            ban_duration = VALUES(ban_duration)
    ]]
    executeQuery(query, {playerIdentifier, playerName, banReason, banDuration})
end

-- Function to check if a player is banned
local function isPlayerBanned(playerIdentifier, callback)
    local query = [[
        SELECT * FROM player_bans WHERE player_identifier = ? AND 
        (ban_duration = 0 OR TIMESTAMPADD(MINUTE, ban_duration, ban_start) > CURRENT_TIMESTAMP)
    ]]
    fetchQuery(query, {playerIdentifier}, function(result)
        callback(result and #result > 0 and result[1] or nil)
    end)
end

-- Function to handle a player ban
local function banPlayer(playerId)
    local playerName = GetPlayerName(playerId) or "Unknown"
    local identifiers = GetPlayerIdentifiers(playerId)
    local playerIdentifier = identifiers[1] -- Use the first identifier (usually Steam or license)
    local banDuration = Config.BanTime > 0 and Config.BanTime or 0
    local banReason = string.format(
        "Suspicious hitbox activity detected. Your account has been %s banned. Please contact server staff if you believe this is an error.",
        Config.BanTime > 0 and string.format("temporarily (%d minutes)", Config.BanTime) or "permanently"
    )

    -- Log the ban to the database
    logBan(playerId, playerIdentifier, playerName, banReason, banDuration)

    -- Drop the player
    DropPlayer(playerId, banReason)
end

-- Function to send logs to Discord
local function sendToDiscord(title, description, color)
    local payload = {
        username = Config.BotName,
        avatar_url = Config.BotLogo,
        embeds = {
            {
                title = title,
                description = description,
                color = color,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                image = { url = Config.EmbedImage }
            }
        }
    }
    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, "POST", json.encode(payload), { ["Content-Type"] = "application/json" })
end

-- Event to log hitbox activity
RegisterServerEvent("hitboxCheck:logHit")
AddEventHandler("hitboxCheck:logHit", function(targetPlayer, isCritical)
    local sourcePlayer = source
    local currentTime = os.time()

    -- Initialize player data if not present
    if not hitboxChecks[sourcePlayer] then
        hitboxChecks[sourcePlayer] = {
            hitCount = 0,
            criticalHitCount = 0,
            startTime = currentTime,
        }
    end

    local playerData = hitboxChecks[sourcePlayer]

    -- Reset counts if a minute has passed
    if currentTime - playerData.startTime >= 60 then
        playerData.hitCount = 0
        playerData.criticalHitCount = 0
        playerData.startTime = currentTime
    end

    -- Increment counts
    playerData.hitCount = playerData.hitCount + 1
    if isCritical then
        playerData.criticalHitCount = playerData.criticalHitCount + 1
    end

    -- Check thresholds
    local hitFrequency = playerData.hitCount
    local criticalAccuracy = (playerData.criticalHitCount / playerData.hitCount) * 100

    if hitFrequency > Config.HitFrequencyThreshold or criticalAccuracy > Config.HitAccuracyThreshold then
        local playerName = GetPlayerName(sourcePlayer) or "Unknown"
        local message = string.format(
            "**Player Flagged:** %s (ID: %d)\n**Hits:** %d\n**Accuracy:** %.2f%%\n**Thresholds:** Frequency (%d), Accuracy (%.2f%%)",
            playerName, sourcePlayer, hitFrequency, criticalAccuracy, Config.HitFrequencyThreshold, Config.HitAccuracyThreshold
        )

        -- Send alert to Discord
        sendToDiscord("Suspicious Hitbox Activity Detected", message, 16711680) -- Red color

        -- Kick the player if enabled
        if Config.EnableKick then
            DropPlayer(sourcePlayer, Config.KickReason)
        end

        -- Ban the player if enabled
        if Config.EnableBan then
            banPlayer(sourcePlayer)
        end
    end
end)

-- Event to check bans when a player connects
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local identifiers = GetPlayerIdentifiers(source)
    local playerIdentifier = identifiers[1] -- Use the first identifier

    deferrals.defer()
    deferrals.update("Checking ban status...")

    isPlayerBanned(playerIdentifier, function(banData)
        if banData then
            local reason = banData.ban_duration > 0
                and string.format("You are banned for %d minutes. Reason: %s", banData.ban_duration, banData.ban_reason)
                or string.format("You are permanently banned. Reason: %s", banData.ban_reason)
            deferrals.done(reason)
        else
            deferrals.done()
        end
    end)
end) 