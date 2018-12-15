'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardPvP extends Leaderboard {

    constructor(id) {
        super(id);
    }

    getPlayerRank() {
        let res = conn.query("SELECT DISTINCT * FROM (SELECT @rn:=@rn+1 as rank, charactershonor.idCharacter, charactershonor.Honor FROM charactershonor, (select @rn:=0) row_nums GROUP BY charactershonor.idCharacter ORDER BY charactershonor.Honor DESC) user_ranks WHERE idCharacter = ?;", [this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    getMaximumRank() {
        let res = conn.query("SELECT COUNT(*) as count FROM charactershonor");
        return res != null && res[0] ? res[0].count : 1;
    }

    dbGetLeaderboard(offset) {
        return conn.query("SELECT DISTINCT charactershonor.idCharacter, charactershonor.Honor, users.userName, users.isConnected, levels.actualLevel FROM charactershonor INNER JOIN levels ON levels.idCharacter = charactershonor.idCharacter INNER JOIN users ON users.idCharacter = charactershonor.idCharacter ORDER BY Honor DESC, charactershonor.idCharacter LIMIT ?, 11", [offset]);
    }

}

module.exports = LeaderboardPvP;