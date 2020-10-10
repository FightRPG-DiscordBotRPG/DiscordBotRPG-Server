'use strict';
var MySql = require('mysql');
const util = require("util");
const conf = require("./conf.js");

var connection = MySql.createConnection(conf.database);
var query = util.promisify(connection.query).bind(connection);
let connMaker = {
    connection: connection,
    query: async (sql, arr = []) => {
        const result = await query(sql, arr);
        return JSON.parse(JSON.stringify(result));
    },
    raw: async (sql) => {
        const result = await query("?", [MySql.raw(sql)]);
        return JSON.parse(JSON.stringify(result));
    }
}



module.exports = connMaker;