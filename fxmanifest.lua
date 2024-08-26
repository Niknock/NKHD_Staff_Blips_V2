fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Niknock HD'
description 'Staff Blips'
version '2.0.0'

client_script{
	'client.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/*.lua',
}

server_script{
	'@es_extended/locale.lua',
	'config.lua',
	'locales/*.lua',
	'server.lua'
}

shared_scripts {
	'config.lua',
    '@es_extended/imports.lua'
}

dependencies {
	'es_extended',
}
