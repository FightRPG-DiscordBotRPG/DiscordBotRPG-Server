'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardCraftLevel extends Leaderboard {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("SELECT DISTINCT * FROM(SELECT *, @rn:=@rn+1 as rank FROM(SELECT characters.idCharacter FROM characters INNER JOIN characterscraftlevel ON characterscraftlevel.idCharacter = characters.idCharacter, (select @rn:=0) row_nums GROUP BY characters.idCharacter ORDER BY characterscraftlevel.actualLevel DESC, characterscraftlevel.actualExp DESC, characters.idCharacter) user_ranks) user_ranks_2 WHERE idCharacter = ?;", [this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    async getMaximumRank() {
        let res = await conn.query("SELECT COUNT(*) as count FROM characters");
        return res != null && res[0] ? res[0].count : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT DISTINCT characters.idCharacter, users.userName, users.isConnected, characterscraftlevel.actualLevel, characterscraftlevel.actualExp FROM characters INNER JOIN characterscraftlevel ON characterscraftlevel.idCharacter = characters.idCharacter INNER JOIN users ON users.idCharacter = characters.idCharacter ORDER BY characterscraftlevel.actualLevel DESC, characterscraftlevel.actualExp DESC, characters.idCharacter LIMIT ?, 11", [offset]);
    }

    async getSumOfAll() {
        return (await conn.query("SELECT SUM(characterscraftlevel.actualLevel) as totalLevels, SUM(characterscraftlevel.actualExp) as totalExp FROM characterscraftlevel;"))[0];
    }

}

module.exports = LeaderboardCraftLevel;