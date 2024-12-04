fx_version 'cerulean'
game 'gta5'

author 'Rico'
description 'Hitbox detection script with kick and ban also with discord logs integration'
version '1.0.0'

-- Server Scripts
server_scripts {
    'config.lua',
    'server.lua'
}

-- Dependencies (if applicable)
-- ( !!!!! COMMENT ONE OUT DEPENDING ON WITCH ONE YOUR USING !!!!! )
dependencies {
    'mysql-async',
    'oxmysql',
}

-- Additional Metadata ( you dont need to change )
lua54 'yes'

escrow_ignore {
    'config.lua',
  }
