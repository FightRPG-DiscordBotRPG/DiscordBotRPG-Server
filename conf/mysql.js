'use strict';
var MySql = require('mysql');
const util = require("util");
const deasync = require("deasync");

var connection = MySql.createConnection({
    host: 'localhost',
    user: 'discord_bot_rpg',
    password: 'sdobFWDViY5tgGYe',
    database: 'discord_bot_rpg',
    charset: "utf8mb4_unicode_ci"
});

var query = util.promisify(connection.query).bind(connection);
query = deasync(query);
let connMaker = {
    connection: connection,
    query: (sql, arr = []) => {
        try {
            const result = query(sql, arr);
            return JSON.parse(JSON.stringify(result));
        } catch (err) {
            throw err;
        }
    }
}



module.exports = connMaker;

//sdo#FWDViY5tgG*e
//sdobFWDViY5tgGYe