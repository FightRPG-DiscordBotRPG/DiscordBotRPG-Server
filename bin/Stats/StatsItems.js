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
            this[res[stat].nom] = Number.parseInt(res[stat].value);
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

    getOptimalArmor(level = 1, rebirthLevel = 0) {
        return ((8 * (Math.pow(level, 2))) / 7 + 5) * this.getMultiplerRebirth(rebirthLevel);
    }

    getMaximumStat(level = 1, rebirthLevel = 0) {
        return super.getMaximumStat(level) * this.getMultiplerRebirth(rebirthLevel);
    }

    getMultiplerRebirth(rebirthLevel = 0) {
        return 1 + Globals.rebirthManager.rebirthsLevelsModifiers[rebirthLevel].percentageBonusToItemsStats / 100;
    }

}

module.exports = StatsItems;