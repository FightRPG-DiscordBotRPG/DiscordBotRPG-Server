'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardPvP extends Leaderboard {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("WITH ranked_orders AS (SELECT idCharacter, RANK() OVER (ORDER BY charactershonor.Honor DESC) as 'rnk' FROM charactershonor) SELECT rnk as 'rank' FROM ranked_orders WHERE idCharacter = ?;", [this.id]);
        return res != null && res[0] ? res[0].rank : 1;
    }

    async getMaximumRank() {
        let res = await conn.query("SELECT COUNT(*) as count FROM charactershonor");
        return res != null && res[0] ? res[0].count : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT DISTINCT charactershonor.idCharacter, charactershonor.Honor, users.userName, users.isConnected, levels.actualLevel FROM charactershonor INNER JOIN levels ON levels.idCharacter = charactershonor.idCharacter INNER JOIN users ON users.idCharacter = charactershonor.idCharacter ORDER BY Honor DESC, charactershonor.idCharacter LIMIT ?, 11", [offset]);
    }

    async getSumOfAll() {
        return (await conn.query("SELECT SUM(charactershonor.Honor) as totalHonor FROM charactershonor;"))[0];
    }

}

module.exports = LeaderboardPvP;