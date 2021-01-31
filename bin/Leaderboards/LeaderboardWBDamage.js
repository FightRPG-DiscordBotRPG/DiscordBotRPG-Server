'use strict';
const conn = require("../../conf/mysql.js");
const LeaderboardWB = require("./LeaderboardWB");

class LeaderboardWBDamage extends LeaderboardWB {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("WITH ranked_orders AS (SELECT idCharacter, RANK() OVER(ORDER BY charactersattacks.damage DESC) as 'rnk' FROM charactersattacks WHERE idSpawnedBoss = ?) SELECT rnk as 'rank' FROM ranked_orders WHERE idCharacter = ?;", [await this.getBossID(), this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT charactersattacks.idCharacter, users.userName, users.isConnected, charactersattacks.damage, levels.actualLevel, levels.rebirthLevel FROM charactersattacks INNER JOIN users ON users.idCharacter = charactersattacks.idCharacter INNER JOIN levels ON levels.idCharacter = charactersattacks.idCharacter WHERE idSpawnedBoss = ? ORDER BY charactersattacks.damage DESC, charactersattacks.attackCount DESC LIMIT ?, 11", [await this.getBossID(), offset]);
    }

}

module.exports = LeaderboardWBDamage;