const conn = require("../../conf/mysql");

class CharacterAchievements {
    constructor(id) {
        this.id = id;
    }

    async load(id) {
        this.id = id;
    }

    async hasAchievement(idAchiev) {
        let res = await conn.query("SELECT * FROM charactersachievements WHERE idAchievement = ?;", [idAchiev]);
        return res.length > 0;
    }

    async getAchievementEarnList(lang = "en") {
        let res = await conn.query("SELECT nameAchievement, descAchievement, points FROM charactersachievements INNER JOIN achievement ON achievement.idAchievement = charactersachievements.idAchievement INNER JOIN localizationachievements ON localizationachievements.idAchievement = charactersachievements.idAchievement WHERE idCharacter = ?;", [this.id]);
        return res;
    }

    async getAchievementList(page, lang = "en") {
        page = page > 0 ? page : 1;
        let counts = (await conn.query("SELECT * FROM ((SELECT COUNT(*) as totalAchievements FROM achievement) ta JOIN (SELECT COUNT(*) as totalAchievementsEarned, SUM(points) as totalPoints FROM charactersachievements INNER JOIN achievement ON achievement.idAchievement = charactersachievements.idAchievement WHERE idCharacter = ?) tae);",
            [this.id]))[0];

        let perPage = 5;
        let maxPage = Math.ceil(counts.totalAchievements / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;

        let res = await conn.query("SELECT *, (CASE WHEN EXISTS(SELECT 1 FROM charactersachievements WHERE charactersachievements.idCharacter = ? AND charactersachievements.idAchievement = achievement.idAchievement) THEN true ELSE false END) as earned FROM achievement INNER JOIN localizationachievements ON localizationachievements.idAchievement = achievement.idAchievement WHERE lang = ? ORDER BY earned DESC, points DESC LIMIT ? OFFSET ?;", [this.id, lang, perPage, (page - 1) * perPage]);

        return {
            totalAchievements: counts.totalAchievements,
            totalAchievementsEarned: counts.totalAchievementsEarned,
            totalPoints: counts.totalPoints != null ? counts.totalPoints : 0,
            achievements: res,
            maxPage: maxPage,
            page: page
        }

    }
}

module.exports = CharacterAchievements;