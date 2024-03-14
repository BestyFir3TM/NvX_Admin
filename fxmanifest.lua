fx_version 'adamant'
game 'gta5'
lua54 'yes'

Author 'BestyFir3TM - Novix Development'
Description 'Admin Menu For Server FiveM [AIO]'
Version '1.0.0'

server_scripts {
    'Config/Config.logs.lua',
    'Config/Config.lua',
    'Server/*.lua'
}

client_scripts {
    'Config/Config.lua',
    'Client/*.lua'
}

dependencies {
	'/server:7290',
    '/onesync',
}