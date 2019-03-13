'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardGold extends Leaderboard {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("SELECT DISTINCT * FROM(SELECT @rn:=@rn+1 as rank, characters.idCharacter, characters.money FROM characters, (select @rn:=0) row_nums GROUP BY characters.idCharacter ORDER BY characters.money DESC) user_ranks WHERE idCharacter = ?;", [this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    async getMaximumRank() {
        let res = await conn.query("SELECT COUNT(*) as count FROM characters");
        return res != null && res[0] ? res[0].count : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT DISTINCT characters.idCharacter, characters.money, users.userName, users.isConnected, levels.actualLevel FROM characters INNER JOIN levels ON levels.idCharacter = characters.idCharacter INNER JOIN users ON users.idCharacter = characters.idCharacter ORDER BY money DESC, characters.idCharacter LIMIT ?, 11", [offset]);
    }

    async getSumOfAll() {
        return (await conn.query("SELECT SUM(money) as totalGold FROM characters;"))[0];
    }

}

module.exports = LeaderboardGold;