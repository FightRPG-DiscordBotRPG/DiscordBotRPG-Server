const conn = require("../../../conf/mysql.js");
const Globals = require("../../Globals.js");
const CharacterAchievements = require("../../Achievement/CharacterAchievements.js");

class BaseLevelSystem {

    constructor() {
        this.id = 0;
        this.idUser = null;
        this.actualLevel = 1;
        this.actualXP = 0;
        this.expToNextLevel = 0;
        this.maxLevel = 0;
        this.rebirthLevel = 0;

        // Change this when extends
        // DONT CHANGE ON RUNTIME
        this.databaseTable = "";
        /**
         * @type {Object<number, idToUnlock>}
         **/
        this.achievementsToUnlocksForLevels = {};
        this.achievementsToUnlocksForRebirthLevels = {};
    }

    /**
     * 
     * @param {number} id
     * @param {string} charAchievement
     */
    async load(id, idUser) {
        this.idUser = idUser;
        this.id = id;
        let res = await conn.query("SELECT actualLevel, actualExp, rebirthLevel FROM " + this.databaseTable + " WHERE idCharacter = ?;", [this.id]);
        res = res[0];
        this.actualLevel = res["actualLevel"];
        this.actualXP = res["actualExp"];
        this.rebirthLevel = res["rebirthLevel"];
        this.maxLevel = Globals.maxLevel;

        await this.updateExpNextLevel();
    }

    async init(id, idUser) {
        this.idUser = idUser;
        this.id = id;
        await conn.query("INSERT INTO " + this.databaseTable + " VALUES (?, 1, 0, 0)", [this.id]);
        this.actualLevel = 1;
        this.actualXP = 0;
        let res = await conn.query("SELECT * FROM levelsrequire WHERE level = 1");
        this.expToNextLevel = res[0]["expNextLevel"];
        this.maxLevel = Globals.maxLevel;
    }

    /**
     * Add and save xp into database
     * @param {any} exp
     */
    async addThisExp(exp) {
        this.actualXP += exp;
        while (this.actualXP >= this.expToNextLevel && this.actualLevel < this.maxLevel) {
            await this.levelUp();
        }
        await this.save();
    }

    async levelUp() {
        this.actualLevel += 1;
        this.actualXP -= this.expToNextLevel;
        this.actualXP = this.actualLevel >= Globals.maxLevel ? 0 : this.actualXP;
        await this.updateExpNextLevel();
        await this.save();

        // Add achiev here
        if (this.idUser != null) {
            if (this.achievementsToUnlocksForLevels[this.actualLevel]) {
                CharacterAchievements.unlock(this.achievementsToUnlocksForLevels[this.actualLevel], this.idUser);
            }

            if (this.achievementsToUnlocksForRebirthLevels[this.rebirthLevel]) {
                CharacterAchievements.unlock(this.achievementsToUnlocksForRebirthLevels[this.rebirthLevel], this.idUser);
            }
        }
    }

    async save() {
        await conn.query("UPDATE "+ this.databaseTable +" SET actualExp = ?, actualLevel = ?, rebirthLevel = ? WHERE idCharacter = ?", [this.actualXP, this.actualLevel, this.rebirthLevel, this.id]);
    }

    async updateExpNextLevel() {
        let res = await conn.query("SELECT expNextLevel FROM levelsrequire WHERE level = ?;", [this.actualLevel]);
        this.expToNextLevel = res[0]["expNextLevel"];
    }


    getLevel() {
        return this.actualLevel;
    }

    getRebirthLevel() {
        return this.rebirthLevel;
    }

    async rebirth() {
        this.actualXP = 0;
        this.actualLevel = 1;
        this.rebirthLevel += 1;
        await this.save();
        await this.updateExpNextLevel();
    }

}

module.exports = BaseLevelSystem;