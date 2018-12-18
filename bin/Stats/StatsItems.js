'use strict';
const conn = require("../../conf/mysql.js");
const Stats = require("./Stats.js");
const Globals = require("../Globals.js");
const Translator = require("../Translator/Translator");

class StatsItems extends Stats {

    constructor(id) {
        super(id, id);
    }

    // Load from DB

    async loadStats() {
        // load from database
        let res = await conn.query("SELECT DISTINCT value, nom FROM itemsstats INNER JOIN stats ON itemsstats.idStat = stats.idStat WHERE idItem = ?;", [this.id]);
        for (let stat in res) {
            this[res[stat].nom] = res[stat].value;
        }
    }

    async deleteStats() {
        await conn.query("DELETE FROM itemsstats WHERE idItem = ?;", [this.id]);
    }

    static async deleteStats(idItem) {
        await conn.query("DELETE FROM itemsstats WHERE idItem = ?", [idItem]);
    }

    /**
     * 
     * @param {Array<number>} idItems 
     */
    static async deleteStatsMultiple(idItems) {
        if (idItems.toString().length > 0) {
            let itemsToDelete = "(" + idItems.toString() + ")";
            await conn.query("DELETE FROM itemsstats WHERE idItem IN " + itemsToDelete + ";");
        }
    }

}

module.exports = StatsItems;