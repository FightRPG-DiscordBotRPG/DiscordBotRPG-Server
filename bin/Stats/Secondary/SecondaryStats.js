'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals.js");

class SecondaryStats {

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
        str: SecondaryStats.possibleStats.Strength,
        int: SecondaryStats.possibleStats.Intellect,
        con: SecondaryStats.possibleStats.Constitution,
        armor: SecondaryStats.possibleStats.Armor,
        dex: SecondaryStats.possibleStats.Dexterity,
        cha: SecondaryStats.possibleStats.Charisma,
        wis: SecondaryStats.possibleStats.Wisdom,
        will: SecondaryStats.possibleStats.Will,
        per: SecondaryStats.possibleStats.Perception,
        luck: SecondaryStats.possibleStats.Luck
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
        if (SecondaryStats.possibleStatsShort[statName]) {
            statName = SecondaryStats.possibleStatsShort[statName];
        }
        if (this[statName] >= 0) {
            return this[statName];
        }
        return 0;
    }

    toApi() {
        return this;
    }

}

async function loadPossibleStats() {
    let res = await conn.query("SELECT * FROM secondarystats;");
    SecondaryStats.prototype.possibleStats = [];
    for (let stat of res) {
        SecondaryStats.prototype.possibleStats.push(stat.nom);
    }
}

loadPossibleStats();

module.exports = SecondaryStats;
