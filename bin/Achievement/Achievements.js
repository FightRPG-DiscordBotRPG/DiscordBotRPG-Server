const conn = require("../../conf/mysql");
const Translator = require("../Translator/Translator");

class Achievements {

    /**
     * 
     * @param {Array<number>} arrayOfIdAchievement
     * @param {string} lang
     */
    static async getAllAchievementsNames(arrayOfIdAchievement, lang="en") {

        let res = await conn.query(`SELECT COALESCE(baseLocalization.nameAchievement, defaultLocalization.nameAchievement) as nameAchievement 
                                    FROM achievement LEFT JOIN localizationachievements as baseLocalization ON baseLocalization.idAchievement = achievement.idAchievement AND baseLocalization.lang = ? LEFT JOIN localizationachievements as defaultLocalization ON defaultLocalization.idAchievement = achievement.idAchievement AND defaultLocalization.lang = 'en' WHERE achievement.idAchievement IN (?);`, [lang, arrayOfIdAchievement.join(",")]);
        return res.map((x) => x.nameAchievement);

    }
}

module.exports = Achievements;