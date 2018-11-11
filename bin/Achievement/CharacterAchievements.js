const conn = require("../../conf/mysql");

class CharacterAchievements {
    constructor(id) {
        this.id = id;
    }

    hasAchievement(idAchiev) {
        let res = conn.query("SELECT * FROM charactersachievements WHERE idAchievement = ?;", [idAchiev]);
        return res.length > 0;
    }

    getAchievementEarnList() {
        let res = conn.query("SELECT nameAchievment, descAchievement, points FROM charactersachievements INNER JOIN achievement ON achievement.idAchievement = charactersachievements.idAchievement INNER JOIN localizationachievements ON localizationachievements.idAchievement = charactersachievements.idAchievement WHERE idCharacter = ?;", [this.id]);
        return res;
    }
}

module.exports = CharacterAchievements;