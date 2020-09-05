'use strict';
const conn = require("../../../conf/mysql.js");
const SecondaryStats = require("./SecondaryStats");

class SecondaryStatsItems extends SecondaryStats {

    constructor(id) {
        super(id, id);
    }

    // Load from DB

    async loadStats() {
        // load from database
        let res = await conn.query("SELECT DISTINCT value, name FROM itemssecondarystats INNER JOIN secondarystats ON itemssecondarystats.idSecondaryStat = secondarystats.idSecondaryStat WHERE idItem = ?;", [this.id]);
        for (let stat in res) {
            this[res[stat].nom] = res[stat].value;
        }
    }

    async deleteStats() {
        await conn.query("DELETE FROM itemssecondarystats WHERE idItem = ?;", [this.id]);
    }

    static async deleteStats(idItem) {
        await conn.query("DELETE FROM itemssecondarystats WHERE idItem = ?", [idItem]);
    }

    /**
     * 
     * @param {Array<number>} idItems 
     */
    static async deleteStatsMultiple(idItems) {
        if (idItems.toString().length > 0) {
            let itemsToDelete = "(" + idItems.toString() + ")";
            await conn.query("DELETE FROM itemssecondarystats WHERE idItem IN " + itemsToDelete + ";");
        }
    }

}

module.exports = SecondaryStatsItems;