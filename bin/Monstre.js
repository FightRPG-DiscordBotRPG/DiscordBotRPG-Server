'use strict';
const conn = require("../conf/mysql.js");
const StatsMonstres = require("./Stats/StatsMonstres");
const Globals = require("./Globals.js");
const WorldEntity = require("./WorldEntity.js");

class Monstre extends WorldEntity {

    constructor(id) {
        super()
        this._type = "Monster";


        this.id = id;
        this.name = "";
        this.actualHP = 0;
        this.maxHP = 0;
        this.level = 0;
        this.xp = 0;
        this.money = 0;
        this.luckBonus = 0;
        this.stats = new StatsMonstres();
        this.difficulty = {};
        this.type = "";

        // Functions
        this.loadMonster();

    }


    loadMonster() {
        let tDifficulty = Math.floor(Math.random() * (4 - 0) + 0);
        this.difficulty = Globals.mDifficulties[tDifficulty];
        let res = conn.query("SELECT DISTINCT name, avglevel, nom FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType WHERE idMonstre = " + this.id)[0];
        let bonus = 1;
        this.type = res["nom"];

        if (this.type == "elite") {
            bonus = 2;
            this.luckBonus = 40;
            this.stats.loadStat(this.id, 1.3);
        } else if (this.type == "normal") {
            this.stats.loadStat(this.id, this.difficulty.value);
        } else if (this.type == "boss") {
            bonus = 10;
            this.luckBonus = 120;
            this.stats.loadStat(this.id, 2);
        }




        this.level = res["avglevel"];
        this.name = res["name"];
        this.updateStats();
        this.xp = Math.round((10 * (Math.pow(this.level, 2))) / 6 * bonus);
        this.money = Math.round((Math.random() * (this.level * 2 - this.level) + this.level) * bonus);
    }

    updateStats() {
        // Partie equipement
        // TODO

        // Partie Stats
        // Con : 1 -> 10HP & Level : 1 -> 10HP
        this.maxHP = 10 + this.stats.constitution * 10;
        this.actualHP = this.maxHP;
    }

    damageCalcul() {
        let baseDamage = (this.stats.strength + 1) * 2;
        return Math.ceil(Math.random() * (baseDamage * 1.25 - baseDamage * 0.75) + baseDamage * 0.75);
    }

    isThisACriticalHit() {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let critique = this.stats.dexterity / max;

        // Cap to 50%;
        critique = critique > .5 ? .5 : critique;

        return Math.random() <= critique ? true : false;

    }

    stun(advWill) {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let stun = (this.stats.charisma) / max;
        let otherResist = (advWill) / max;

        // Cap to 50%;
        stun = stun > .5 ? .5 : stun;
        otherResist = otherResist > .5 ? .5 : otherResist;
        let chanceToStun = stun >= otherResist ? stun : 0;

        return Math.random() <= chanceToStun ? true : false;
    }

    // percentage reduction
    damageDefenceReduction() {
        let reduction = Math.round(this.stats.armor / ((8 * (this.level ^ 2)) / 7 + 5));
        return reduction > 0.5 ? 0.5 : 1 - reduction;
    }

    getLevel() {
        return this.level;
    }

    // Get Stat
    getStat(statName) {
        if (this.stats[statName]) {
            return this.stats[statName];
        }
        return 0;
    }

}

module.exports = Monstre;
