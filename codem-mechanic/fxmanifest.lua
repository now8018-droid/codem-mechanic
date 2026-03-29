fx_version 'cerulean'
game 'gta5'
version '1.6'
author 'CodeM'
description 'Codem Mechanic'

shared_scripts {
	'config/*.lua',
}

client_scripts {
	'client/*.lua',
	'editable/client_editable.lua',
}
server_scripts {
	-- '@mysql-async/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'mysql-async'.:warning:
	'@oxmysql/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'oxmysql'.:warning:
	'server/bossmenu.lua',
	'editable/server_config.lua',
	'server/server.lua',
	'editable/server_editable.lua',
}

ui_page "html/index.html"
files {
	'html/index.html',
	'html/css/*.css',
	'html/fonts/*.TTF',
	'html/fonts/*.*',
	'html/sound/*.*',
	'html/images/**/*.png',
	'html/images/**/**/*.png',
	'html/js/*.js',
	'html/js/**/*.js',
	'html/images/**/*.png',
	'html/pages/**/*.js',
	'html/pages/**/*.html',
	'html/pages/**/components/**/*.js',
	'html/pages/**/components/**/*.html',
}

escrow_ignore {
	'server/bossmenu.lua',
	'editable/*.lua',
	'client/bossmenu.lua',
	'config/*.lua',
	'client/camera.lua'
}

lua54 'yes'
dependency '/assetpacks'