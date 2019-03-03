const conn = require("../../conf/mysql");
const Translator = require("../Translator/Translator");

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

        let res = await conn.query("SELECT achievement.idAchievement, achievement.name_identifier, achievement.points, COALESCE(baseLocalization.lang, defaultLocalization.lang) as lang, COALESCE(baseLocalization.nameAchievement, defaultLocalization.nameAchievement) as nameAchievement, COALESCE(baseLocalization.descAchievement, defaultLocalization.descAchievement) as descAchievement, (CASE WHEN EXISTS(SELECT 1 FROM charactersachievements WHERE charactersachievements.idCharacter = ? AND charactersachievements.idAchievement = achievement.idAchievement) THEN true ELSE false END) as earned FROM achievement LEFT JOIN localizationachievements as baseLocalization ON baseLocalization.idAchievement = achievement.idAchievement AND baseLocalization.lang = ? LEFT JOIN localizationachievements as defaultLocalization ON defaultLocalization.idAchievement = achievement.idAchievement AND defaultLocalization.lang = 'en' ORDER BY earned DESC, points DESC LIMIT ? OFFSET ?;", [this.id, lang, perPage, (page - 1) * perPage]);

        return {
            totalAchievements: counts.totalAchievements,
            totalAchievementsEarned: counts.totalAchievementsEarned,
            totalPoints: counts.totalPoints != null ? counts.totalPoints : 0,
            achievements: res,
            maxPage: maxPage,
            page: page
        }

    }

    async getSpecificAchievement(idAchievement, lang = "en") {
        let res = await conn.query("SELECT achievement.idAchievement, achievement.name_identifier, achievement.points, COALESCE(baseLocalization.lang, defaultLocalization.lang) as lang, COALESCE(baseLocalization.nameAchievement, defaultLocalization.nameAchievement) as nameAchievement, COALESCE(baseLocalization.descAchievement, defaultLocalization.descAchievement) as descAchievement, (CASE WHEN EXISTS(SELECT 1 FROM charactersachievements WHERE charactersachievements.idCharacter = ? AND charactersachievements.idAchievement = achievement.idAchievement) THEN true ELSE false END) as earned FROM achievement LEFT JOIN localizationachievements as baseLocalization ON baseLocalization.idAchievement = achievement.idAchievement AND baseLocalization.lang = ? LEFT JOIN localizationachievements as defaultLocalization ON defaultLocalization.idAchievement = achievement.idAchievement AND defaultLocalization.lang = 'en' WHERE achievement.idAchievement = ?;", [this.id, lang, idAchievement]);

        return res.length > 0 ? res[0] : null;
    }

    async unlock(idAchievement, user) {
        if (!(await this.hasAchievement(idAchievement))) {
            await conn.query("INSERT IGNORE INTO charactersachievements VALUES (?, ?);", [this.id, idAchievement]);
            if (user != null) {
                let achievement = await this.getSpecificAchievement(idAchievement, user.getLang());
                user.achievementTell(Translator.getString(user.getLang(), "character", "achievement_earned", [achievement.nameAchievement]));
            }
        }

    }
}

module.exports = CharacterAchievements;