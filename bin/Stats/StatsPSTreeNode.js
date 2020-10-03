'use strict';
const conn = require("../../conf/mysql.js");
const Stats = require("./Stats.js");
const Globals = require("../Globals.js");
const Translator = require("../Translator/Translator");

class StatsPSTreeNode extends Stats {

    constructor(id) {
        super(id, id);
    }

    // Load from DB

    async loadStats() {
        // load from database
        let res = await conn.query("SELECT DISTINCT value, nom FROM pstreenodesstatsdata INNER JOIN stats ON pstreenodesstatsdata.idStat = stats.idStat WHERE idNode = ?;", [this.id]);
        for (let stat in res) {
            this[res[stat].nom] = res[stat].value;
        }
    }

    async save() {
        let promisesToWait = [];

        for (let statName in Globals.statsIdsByName) {
            let idStat = Globals.statsIdsByName[statName];
            promisesToWait.push(conn.query("REPLACE INTO pstreenodesstatsdata VALUES (?, ?, ?)", [this.id, idStat, this[statName]]));
        }

        await Promise.all(promisesToWait);
    }

    async deleteStats() {
        await conn.query("DELETE FROM pstreenodesstatsdata WHERE idNode = ?;", [this.id]);
    }

    static async deleteStats(idNode) {
        await conn.query("DELETE FROM pstreenodesstatsdata WHERE idNode = ?", [idNode]);
    }

    /**
     * 
     * @param {Array<number>} idNodes 
     */
    static async deleteStatsMultiple(idNodes) {
        if (idNodes.toString().length > 0) {
            let itemsToDelete = "(" + idNodes.toString() + ")";
            await conn.query("DELETE FROM pstreenodesstatsdata WHERE idNode IN " + itemsToDelete + ";");
        }
    }

}

module.exports = StatsPSTreeNode;