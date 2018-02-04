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

    loadLevelSystem(id) {
        this.id = id;
        let res = conn.query("SELECT actualLevel, actualExp FROM levels WHERE idCharacter = " + id)[0];
        this.actualLevel = res["actualLevel"];
        this.actualXP = res["actualExp"];
        this.maxLevel = Globals.maxLevel;

        res = conn.query("SELECT expNextLevel FROM levelsrequire WHERE level = " + this.actualLevel)[0];
        this.expToNextLevel = res["expNextLevel"];
    }

    saveLevelSystem() {
        //conn.query("UPDATE levels SET actualLevel = " + this.actualLevel + ", actualExp = " + this.actualXP);
    }

    init(id) {
        this.id = id;
        conn.query("INSERT INTO levels VALUES (" + this.id + ", 0, 1)");
        this.actualLevel = 1;
        this.actualXP = 0;
        this.expToNextLevel = conn.query("SELECT * FROM levelsrequire WHERE level = 1")[0]["expNextLevel"];
        this.maxLevel = Globals.maxLevel;
    }

    addThisExp(exp) {
        this.actualXP += exp;
        while (this.actualXP >= this.expToNextLevel && this.actualLevel < this.maxLevel) {
            this.levelUp();
        }
    }

    levelUp() {
        this.actualLevel += 1;
        this.actualXP -= this.expToNextLevel;
        this.actualXP = this.actualLevel >= Globals.maxLevel ? 0 : this.actualXP;   
        this.expToNextLevel = conn.query("SELECT expNextLevel FROM levelsrequire WHERE level = " + this.actualLevel)[0]["expNextLevel"];
    }

    saveMyExp() {
        conn.query("UPDATE levels SET actualExp = " + this.actualXP + " WHERE idCharacter = " + this.id);
    }

    saveMyLevel() {
        conn.query("UPDATE levels SET actualExp = " + this.actualXP + ", actualLevel = " + this.actualLevel + " WHERE idCharacter = " + this.id);
    }

}

module.exports = LevelSystem;
