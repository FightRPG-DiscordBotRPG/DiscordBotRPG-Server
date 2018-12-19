'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");

class LevelSystem {

    constructor(id) {
        this.id = id;
        this.actualLevel = 1;
        this.actualXP = 0;
        this.expToNextLevel = 0;
        this.maxLevel = 0;
    }

    async loadLevelSystem(id) {
        this.id = id;
        let res = await conn.query("SELECT actualLevel, actualExp FROM levels WHERE idCharacter = " + id);
        res = res[0];
        this.actualLevel = res["actualLevel"];
        this.actualXP = res["actualExp"];
        this.maxLevel = Globals.maxLevel;

        res = await conn.query("SELECT expNextLevel FROM levelsrequire WHERE level = " + this.actualLevel);
        res = res[0];
        this.expToNextLevel = res["expNextLevel"];
    }

    async init(id) {
        this.id = id;
        await conn.query("INSERT INTO levels VALUES (" + this.id + ", 0, 1)");
        this.actualLevel = 1;
        this.actualXP = 0;
        let res = await conn.query("SELECT * FROM levelsrequire WHERE level = 1");
        this.expToNextLevel = res[0]["expNextLevel"];
        this.maxLevel = Globals.maxLevel;
    }

    async addThisExp(exp) {
        this.actualXP += exp;
        while (this.actualXP >= this.expToNextLevel && this.actualLevel < this.maxLevel) {
            await this.levelUp();
        }
    }

    async levelUp() {
        this.actualLevel += 1;
        this.actualXP -= this.expToNextLevel;
        this.actualXP = this.actualLevel >= Globals.maxLevel ? 0 : this.actualXP;
        let res = await conn.query("SELECT expNextLevel FROM levelsrequire WHERE level = ?;", [this.actualLevel]);
        this.expToNextLevel = res[0]["expNextLevel"];
    }

    async saveMyExp() {
        await conn.query("UPDATE levels SET actualExp = ? WHERE idCharacter = ?;", [this.actualXP, this.id]);
    }

    async saveMyLevel() {
        await conn.query("UPDATE levels SET actualExp = ?, actualLevel = ? WHERE idCharacter = ?", [this.actualXP, this.actualLevel, this.id]);
    }

}

module.exports = LevelSystem;