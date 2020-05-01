'use strict';
const conn = require("../../conf/mysql.js");
const Leaderboard = require("./Leaderboard");

class LeaderboardAchievements extends Leaderboard {

    constructor(id) {
        super(id);
    }

    async getPlayerRank() {
        let res = await conn.query("WITH ranked_orders AS(SELECT idCharacter, RANK() OVER(ORDER BY rankings.points DESC, rankings.actualLevel DESC, rankings.idCharacter ASC) as 'rnk' FROM(SELECT characters.idCharacter,  actualLevel, IfNull(SUM(points), 0) as points FROM characters INNER JOIN levels ON levels.idCharacter = characters.idCharacter LEFT JOIN charactersachievements ON charactersachievements.idCharacter = characters.idCharacter LEFT JOIN achievement ON charactersachievements.idAchievement = achievement.idAchievement GROUP BY characters.idCharacter) rankings) SELECT rnk as 'rank' FROM ranked_orders WHERE idCharacter = ?;", [this.id]);

        return res != null && res[0] ? res[0].rank : 1;
    }

    async getMaximumRank() {
        let res = await conn.query("SELECT COUNT(*) as count FROM characters");
        return res != null && res[0] ? res[0].count : 1;
    }

    async dbGetLeaderboard(offset) {
        return await conn.query("SELECT users.idCharacter, users.userName, users.isConnected, points, levels.actualLevel FROM (SELECT characters.idCharacter,  actualLevel, IfNull(SUM(points), 0) as points FROM characters INNER JOIN levels ON levels.idCharacter = characters.idCharacter LEFT JOIN charactersachievements ON charactersachievements.idCharacter = characters.idCharacter LEFT JOIN achievement ON charactersachievements.idAchievement = achievement.idAchievement GROUP BY characters.idCharacter) rankings INNER JOIN users ON users.idCharacter = rankings.idCharacter INNER JOIN levels ON levels.idCharacter = users.idCharacter ORDER BY rankings.points DESC, actualLevel DESC, users.idCharacter ASC LIMIT ?, 11", [offset]);
    }

    async getSumOfAll() {
        return (await conn.query("SELECT SUM(points) as totalPoints FROM charactersachievements INNER JOIN achievement ON charactersachievements.idAchievement = achievement.idAchievement"))[0];
    }

}

module.exports = LeaderboardAchievements;