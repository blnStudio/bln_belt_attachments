fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'BLN Studio <bln.tebex.io>'
description 'Realistically display your weapons and items on your character\'s belt when equipped from inventory but not in use! Works with lanterns, lassos, machetes, and more.'
version '1.2.1'

client_scripts {
    'c/*.lua'
}

server_scripts {
    's/*.lua'
}

shared_scripts {
    'config.lua'
}
