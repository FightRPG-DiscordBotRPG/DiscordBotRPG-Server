const syncmysql = require("./conf/mysqlsync");
const mysqlperso = require("./conf/mysql");

let dt = Date.now();
console.log("Test mysql-sync");
syncmysql.query("SELECT * FROM users");

console.log(((Date.now() - dt)) + " ms");

dt = Date.now();
console.log("Test mysql-perso");
let va = mysqlperso.query("SELECT * FROM users");
console.log(((Date.now() - dt)) + " ms");


let asyncTest = async () => {
    var MySql = require('mysql');
    const util = require("util");
    var connection = MySql.createConnection({
        host: 'localhost',
        user: 'discord_bot_rpg',
        password: 'sdobFWDViY5tgGYe',
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

    let dt = Date.now();
    console.log("Test async mysql");
    let variable = await connMaker.query("SELECT * FROM users");
    console.log(((Date.now() - dt)) + " ms");

}

asyncTest();