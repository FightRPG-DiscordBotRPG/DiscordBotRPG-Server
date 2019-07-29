'use strict';
var MySql = require('mysql');
const util = require("util");

var connection = MySql.createConnection({
    host: 'localhost',
    user: 'discord_bot_rpg',
    password: '',
    database: 'discord_bot_rpg',
    charset: "utf8mb4_unicode_ci"
});

var query = util.promisify(connection.query).bind(connection);
let connMaker = {
    connection: connection,
    query: async (sql, arr = []) => {
        try {
            const result = await query(sql, arr);
            return JSON.parse(JSON.stringify(result));
        } catch (err) {
            throw err;
        }
    }
}



module.exports = connMaker;