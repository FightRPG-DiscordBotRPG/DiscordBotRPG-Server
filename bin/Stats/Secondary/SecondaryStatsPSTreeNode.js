'use strict';
const conn = require("../../../conf/mysql.js");
const SecondaryStats = require("./SecondaryStats");

class SecondaryStatsPSTreeNode extends SecondaryStats {

    constructor(id) {
        super(id, id);
    }

    // Load from DB

    async loadStats() {
        // load from database
        let res = await conn.query("SELECT DISTINCT value, name FROM pstreenodessecondarystatsdata INNER JOIN secondarystats ON pstreenodessecondarystatsdata.idSecondaryStat = secondarystats.idSecondaryStat WHERE idNode = ?;", [this.id]);
        for (let stat in res) {
            this[res[stat].name] = res[stat].value;
        }

        res = await conn.query("SELECT DISTINCT shorthand, value FROM pstreenodessecondarystatselementalresistsdata INNER JOIN elementstypes ON pstreenodessecondarystatselementalresistsdata.idElementType = elementstypes.idElementType WHERE idNode = ?;", [this.id]);
        for (let stat in res) {
            this[res[stat].shorthand + "Resist"] = res[stat].value;
        }
    }

    async deleteStats() {
        await Promise.all([
            conn.query("DELETE FROM pstreenodessecondarystatsdata WHERE idNode = ?;", [this.id]),
            conn.query("DELETE FROM pstreenodessecondarystatselementalresistdata WHERE idNode = ?;", [this.id]
            )]);
    }

    static async deleteStats(idNode) {
        await Promise.all([
            conn.query("DELETE FROM pstreenodessecondarystatsdataWHERE idNode = ?", [idNode]),
            conn.query("DELETE FROM pstreenodessecondarystatselementalresistdata WHERE idNode = ?", [idNode])
        ]);
    }

    /**
     * 
     * @param {Array<number>} idNodes 
     */
    static async deleteStatsMultiple(idNodes) {
        if (idNodes.toString().length > 0) {
            let itemsToDelete = "(" + idNodes.toString() + ")";
            await Promise.all([
                conn.query("DELETE FROM pstreenodessecondarystatsdataWHERE idNode IN " + itemsToDelete + ";"),
                conn.query("DELETE FROM pstreenodessecondarystatselementalresistdata WHERE idNode IN " + itemsToDelete + ";")
            ]);
        }
    }

}

module.exports = SecondaryStatsPSTreeNode;