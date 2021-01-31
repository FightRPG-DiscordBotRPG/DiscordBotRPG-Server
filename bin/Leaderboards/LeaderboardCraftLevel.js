'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardCraftLevel extends Leaderboard {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("WITH ranked_orders AS (SELECT idCharacter, RANK() OVER (ORDER BY characterscraftlevel.rebirthLevel DESC, characterscraftlevel.actualLevel DESC, characterscraftlevel.actualExp DESC) as 'rnk' FROM characterscraftlevel) SELECT rnk as 'rank' FROM ranked_orders WHERE idCharacter = ?;", [this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT DISTINCT characters.idCharacter, users.userName, users.isConnected, characterscraftlevel.actualLevel as actualCraftLevel, characterscraftlevel.actualExp as actualCraftExp, characterscraftlevel.rebirthLevel as craftRebirthLevel, levels.actualLevel, levels.rebirthLevel FROM characters INNER JOIN characterscraftlevel ON characterscraftlevel.idCharacter = characters.idCharacter INNER JOIN users ON users.idCharacter = characters.idCharacter INNER JOIN levels ON levels.idCharacter = characters.idCharacter ORDER BY characterscraftlevel.rebirthLevel DESC, characterscraftlevel.actualLevel DESC, characterscraftlevel.actualExp DESC, characters.idCharacter LIMIT ?, 11", [offset]);
    }

    async getSumOfAll() {
        return (await conn.query("SELECT SUM(characterscraftlevel.actualLevel) as totalLevels, SUM(characterscraftlevel.actualExp) as totalExp FROM characterscraftlevel;"))[0];
    }

}

module.exports = LeaderboardCraftLevel;