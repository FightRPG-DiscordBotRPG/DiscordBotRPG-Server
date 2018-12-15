'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardWB extends Leaderboard {

    constructor(id) {
        super(id);
        this.bossID = null;
    }

    getBossID() {
        // Select last participated
        if (this.bossID == null || Number.isNaN(this.bossID)) {
            let res = conn.query("SELECT * FROM charactersattacks WHERE charactersattacks.idCharacter = ? AND charactersattacks.idSpawnedBoss NOT IN (SELECT bossspawninfo.idSpawnedBoss FROM bossspawninfo WHERE bossspawninfo.idSpawnedBoss != NULL) ORDER BY charactersattacks.idSpawnedBoss DESC LIMIT 1;", [this.id]);
            this.setBossID(res[0] != null ? res[0].idSpawnedBoss : null);
        }
        return this.bossID;
    }

    getMaximumRank() {
        let res = conn.query("SELECT COUNT(*) as count FROM charactersattacks WHERE idSpawnedBoss = ?;", [this.getBossID()]);
        return res != null && res[0] ? res[0].count : 1;
    }

    setBossID(idSpawnedBoss) {
        this.bossID = idSpawnedBoss;
    }

}

module.exports = LeaderboardWB;