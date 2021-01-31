'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardLevel extends Leaderboard {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("WITH ranked_orders AS (SELECT idCharacter, RANK() OVER (ORDER BY levels.rebirthLevel DESC, levels.actualLevel DESC, levels.actualExp DESC) as 'rnk' FROM levels) SELECT rnk as 'rank' FROM ranked_orders WHERE idCharacter = ?;", [this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT DISTINCT characters.idCharacter, users.userName, users.isConnected, levels.actualLevel, levels.actualExp, levels.rebirthLevel FROM characters INNER JOIN levels ON levels.idCharacter = characters.idCharacter INNER JOIN users ON users.idCharacter = characters.idCharacter ORDER BY levels.rebirthLevel DESC, levels.actualLevel DESC, levels.actualExp DESC, characters.idCharacter LIMIT ?, 11", [offset]);
    }

    async getSumOfAll() {
        return (await conn.query("SELECT SUM(levels.actualLevel) as totalLevels, SUM(levels.actualExp) as totalExp FROM levels;"))[0];
    }

}

module.exports = LeaderboardLevel;