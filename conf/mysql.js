'use strict';
var MySql = require('mysql2');
const util = require("util");
const conf = require("./conf.js");

var connection = MySql.createPool(conf.database);
var query = util.promisify(connection.query).bind(connection);
let connMaker = {
    isForeignKeyCheckDisabled: false,
    connection: connection,
    test: 0,
    /**
     * @returns {Promise<any[]>}
     **/
    query: async (sql, arr = []) => {
        connMaker.test++;
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