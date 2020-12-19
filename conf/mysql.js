'use strict';
var MySql = require('mysql');
const util = require("util");
const conf = require("./conf.js");

var connection = MySql.createPool(conf.database);
var query = util.promisify(connection.query).bind(connection);
let connMaker = {
    isForeignKeyCheckDisabled: false,
    connection: connection,
    /**
     * @returns {Promise<any[]>}
     **/
    query: async (sql, arr = []) => {
        if (connMaker.isForeignKeyCheckDisabled) {
            sql = `SET FOREIGN_KEY_CHECKS = 0;${sql}${sql.slice(-1) === ";" ? "" : ";"}SET FOREIGN_KEY_CHECKS = 1;`;
        }
        const result = await query(sql, arr);
        return JSON.parse(JSON.stringify(result));
    },
    /**
     * @returns {Promise<any[]>}
     **/
    raw: async (sql) => {
        const result = await query("?", [MySql.raw(sql)]);
        return JSON.parse(JSON.stringify(result));
    }
}



module.exports = connMaker;