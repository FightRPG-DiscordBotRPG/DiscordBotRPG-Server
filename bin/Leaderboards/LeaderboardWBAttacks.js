'use strict';
const conn = require("../../conf/mysql.js");
const LeaderboardWB = require("./LeaderboardWB");

class LeaderboardWBAttacks extends LeaderboardWB {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("SELECT DISTINCT * FROM (SELECT @rn:=@rn+1 as rank, charactersattacks.idCharacter FROM charactersattacks INNER JOIN users ON users.idCharacter = charactersattacks.idCharacter, (select @rn:=0) row_nums WHERE idSpawnedBoss = ? ORDER BY charactersattacks.attackCount DESC) user_ranks WHERE idCharacter = ?;", [await this.getBossID(), this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT charactersattacks.idCharacter, users.userName, users.isConnected, charactersattacks.attackCount, levels.actualLevel FROM charactersattacks INNER JOIN users ON users.idCharacter = charactersattacks.idCharacter INNER JOIN levels ON levels.idCharacter = charactersattacks.idCharacter WHERE idSpawnedBoss = ? ORDER BY charactersattacks.attackCount DESC, charactersattacks.damage DESC LIMIT ?, 11", [await this.getBossID(), offset]);
    }

}

module.exports = LeaderboardWBAttacks;