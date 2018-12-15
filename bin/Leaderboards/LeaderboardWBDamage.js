'use strict';
const conn = require("../../conf/mysql.js");
const LeaderboardWB = require("./LeaderboardWB");

class LeaderboardWBDamage extends LeaderboardWB {

    constructor(id) {
        super(id);
    }

    getPlayerRank() {
        let res = conn.query("SELECT DISTINCT * FROM (SELECT @rn:=@rn+1 as rank, charactersattacks.idCharacter FROM charactersattacks INNER JOIN users ON users.idCharacter = charactersattacks.idCharacter, (select @rn:=0) row_nums WHERE idSpawnedBoss = ? ORDER BY charactersattacks.damage DESC) user_ranks WHERE idCharacter = ?;", [this.getBossID(), this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    dbGetLeaderboard(offset) {
        return conn.query("SELECT charactersattacks.idCharacter, users.userName, users.isConnected, charactersattacks.damage, levels.actualLevel FROM charactersattacks INNER JOIN users ON users.idCharacter = charactersattacks.idCharacter INNER JOIN levels ON levels.idCharacter = charactersattacks.idCharacter WHERE idSpawnedBoss = ? ORDER BY charactersattacks.damage DESC, charactersattacks.attackCount DESC LIMIT ?, 11", [this.getBossID(), offset]);
    }

}

module.exports = LeaderboardWBDamage;