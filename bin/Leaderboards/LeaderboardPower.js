'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardPower extends Leaderboard {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("WITH ranked_orders AS(SELECT idCharacter, RANK() OVER(ORDER BY rankings.power DESC, rankings.rebirthLevel DESC, rankings.actualLevel DESC, rankings.idCharacter ASC) as 'rnk' FROM(SELECT characters.idCharacter, IfNull(SUM(power), 0) as power, actualLevel, rebirthLevel FROM characters LEFT JOIN charactersequipements ON charactersequipements.idCharacter = characters.idCharacter LEFT JOIN itemspower ON itemspower.idItem = charactersequipements.idItem INNER JOIN levels ON levels.idCharacter = characters.idCharacter GROUP by characters.idCharacter) rankings) SELECT rnk as 'rank' FROM ranked_orders WHERE idCharacter = ?;", [this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT users.idCharacter, users.userName, users.isConnected, power, actualLevel, rebirthLevel FROM (SELECT characters.idCharacter, IfNull(SUM(power), 0) as power FROM characters LEFT JOIN charactersequipements ON charactersequipements.idCharacter = characters.idCharacter LEFT JOIN itemspower ON itemspower.idItem = charactersequipements.idItem GROUP by characters.idCharacter) rankings INNER JOIN users ON users.idCharacter = rankings.idCharacter INNER JOIN levels ON levels.idCharacter = users.idCharacter ORDER BY rankings.power DESC, rebirthLevel DESC, actualLevel DESC, users.idCharacter ASC LIMIT ?, 11", [offset]);
    }

    async getSumOfAll() {
        return (await conn.query("SELECT IfNull(SUM(power), 0) as totalPower FROM characters LEFT JOIN charactersequipements ON charactersequipements.idCharacter = characters.idCharacter LEFT JOIN itemspower ON itemspower.idItem = charactersequipements.idItem;"))[0];
    }

}

module.exports = LeaderboardPower;