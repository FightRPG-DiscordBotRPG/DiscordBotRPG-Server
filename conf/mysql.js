'use strict';
var MySql = require('sync-mysql');

var connection = new MySql({
    host: 'localhost',
    user: 'discord_bot_rpg',
    password: 'sdobFWDViY5tgGYe',
    database: 'discord_bot_rpg',
    charset: "utf8mb4_unicode_ci"
});

module.exports = connection;

//sdo#FWDViY5tgG*e
//sdobFWDViY5tgGYe
