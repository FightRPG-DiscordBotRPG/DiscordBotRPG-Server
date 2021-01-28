'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals.js");

class Stats {

    static possibleStats = {
        Strength: "strength",
        Intellect: "intellect",
        Constitution: "constitution",
        Armor: "armor",
        Dexterity: "dexterity",
        Charisma: "charisma",
        Wisdom: "wisdom",
        Will: "will",
        Perception: "perception",
        Luck: "luck"
    }

    static possibleStatsShort = {
        str: Stats.possibleStats.Strength,
        int: Stats.possibleStats.Intellect,
        con: Stats.possibleStats.Constitution,
        armor: Stats.possibleStats.Armor,
        dex: Stats.possibleStats.Dexterity,
        cha: Stats.possibleStats.Charisma,
        wis: Stats.possibleStats.Wisdom,
        will: Stats.possibleStats.Will,
        per: Stats.possibleStats.Perception,
        luck: Stats.possibleStats.Luck
    }

    static ratiosBasedOnSubtype = {
        armor: {
            "metal": 1.2,
            "cloth": 0.8,
            "leather": 1,
            "bow": 0.15,
            "dagger": 0.15,
            "sword": 0.15,
            "wand": 0.15,
            "whip": 0.15,
            "staff": 0.15,
        },
        strength: {
            "metal": 0.8,
            "cloth": 0.8,
            "leather": 0.8,
            "bow": 0.8,
            "dagger": 0.8,
            "sword": 1.2,
            "wand": 0.8,
            "whip": 1,
            "staff": 0.6,
        },
        intellect: {
            "metal": 0.8,
            "cloth": 1.2,
            "leather": 0.8,
            "bow": 0.8,
            "dagger": 0.8,
            "sword": 0.8,
            "wand": 1.2,
            "whip": 0.8,
            "staff": 1.4,
        },
        constitution: {
            "metal": 1.4,
            "cloth": 1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        wisdom: {
            "metal": 1,
            "cloth": 1.2,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        dexterity: {
            "metal": 0.8,
            "cloth": 1,
            "leather": 1.2,
            "bow": 1.4,
            "dagger": 1.2,
            "sword": 1,
            "wand": 1,
            "whip": 1.4,
            "staff": 1,
        },
        charisma: {
            "metal": 1,
            "cloth": 1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 0.6,
            "staff": 1,
        },
        will: {
            "metal": 1,
            "cloth": 1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1.2,
            "staff": 1,
        },
        perception: {
            "metal": 1,
            "cloth": 1,
            "leather": 1.2,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        luck: {
            "metal": 1,
            "cloth": 1,
            "leather": 1,
            "bow": 1,
            "dagger": 1.2,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        }


    }


    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        this.id = id;
        this.strength = 0;
        this.intellect = 0;
        this.constitution = 0;
        this.armor = 0;
        this.dexterity = 0;
        this.charisma = 0;
        this.wisdom = 0;
        this.will = 0;
        this.perception = 0;
        this.luck = 0;
    }

    getStat(statName) {
        if (Stats.possibleStatsShort[statName]) {
            statName = Stats.possibleStatsShort[statName];
        }
        if (this[statName] >= 0) {
            return this[statName];
        }
        return 0;
    }

    toApi() {
        let r = {};
        let statsPossible = Object.keys(Globals.statsIdsByName);
        for (let i in statsPossible) {
            r[statsPossible[i]] = this[statsPossible[i]];
        }
        return r;
    }

    getOptimalArmor(level = 1, rebirthLevel = 0) {
        return ((8 * (Math.pow(level, 2))) / 7 + 5);
    }

    getOptimalStun(level = 1, rebirthLevel = 0) {
        return this.getMaximumStat(level, rebirthLevel);
    }

    getMaximumStat(level = 1, rebirthLevel = 0) {
        return level * 8;
    }

    /**
     * 
     * @param {...Stats} otherStats
     */
    add(...otherStats) {
        let statsPossible = Object.keys(Globals.statsIdsByName);
        for (let i in statsPossible) {
            this[statsPossible[i]] += otherStats.reduce((acc, val) => acc + val[statsPossible[i]], 0);
        }
    }

    /**
     * 
     * @param {...Stats} otherStats
     */
    subtract(...otherStats) {
        let statsPossible = Object.keys(Globals.statsIdsByName);
        for (let i in statsPossible) {
            this[statsPossible[i]] -= otherStats.reduce((acc, val) => acc + val[statsPossible[i]], 0);
        }
    }

    /**
     * 
     * @param {number} num
     */
    divide(num) {
        let statsPossible = Object.keys(Globals.statsIdsByName);
        for (let i in statsPossible) {
            this[statsPossible[i]] /= num;
        }
    }




}

async function loadPossibleStats() {
    let res = await conn.query("SELECT * FROM stats;");
    Stats.prototype.possibleStats = [];
    for (let stat of res) {
        Stats.prototype.possibleStats.push(stat.nom);
    }
}

loadPossibleStats();

module.exports = Stats;
