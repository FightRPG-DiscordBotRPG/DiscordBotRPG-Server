'use strict';
const conn = require("../../../conf/mysql");
const { elementsTypesNameById } = require("../../Globals");

class SecondaryStats {

    static possibleStats = {
        HitRate: "hitRate",
        EvadeRate: "evadeRate",
        CriticalRate: "criticalRate",
        RegenHp: "regenHp",
        RegenMp: "regenMp",
        RegenEnergy: "regenEnergy",
        SkillManaCost: "skillManaCost",
        SkillEnergyCost: "skillEnergyCost",
        PhysicalCritcalEvadeRate: "physicalCriticalEvadeRate",
        MagicalCriticalEvadeRate: "magicalCriticalEvadeRate",
        Threat: "threat",
    }

    static possibleElementalResists = {
        Physical: "physicalResist",
        Fire: "fireResist",
        Water: "waterResist",
        Earth: "earthResist",
        Air: "airResist",
        Dark: "darkResist",
        Light: "lightResist"
    }

    static possibleStatsShort = {
        hr: SecondaryStats.possibleStats.HitRate,
        evr: SecondaryStats.possibleStats.EvadeRate,
        cr: SecondaryStats.possibleStats.CriticalRate,
        rhp: SecondaryStats.possibleStats.RegenHp,
        rmp: SecondaryStats.possibleStats.RegenMp,
        rnrj: SecondaryStats.possibleStats.RegenEnergy,
        smc: SecondaryStats.possibleStats.SkillManaCost,
        senrjc: SecondaryStats.possibleStats.SkillEnergyCost,
        physcevr: SecondaryStats.possibleStats.PhysicalCritcalEvadeRate,
        magcevr: SecondaryStats.possibleStats.MagicalCriticalEvadeRate,
        threat: SecondaryStats.possibleStats.Threat,
    }

    static possibleElementalResistsShort = {
        pr: SecondaryStats.possibleElementalResists.Physical,
        fr: SecondaryStats.possibleElementalResists.Fire,
        wr: SecondaryStats.possibleElementalResists.Water,
        er: SecondaryStats.possibleElementalResists.Earth,
        ar: SecondaryStats.possibleElementalResists.Air,
        dr: SecondaryStats.possibleElementalResists.Dark,
        lr: SecondaryStats.possibleElementalResists.Light
    }

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        this.id = id;
        this.hitRate = 100;
        this.evadeRate = 0;
        this.criticalRate = 0;
        this.regenHp = 0;
        this.regenMp = 0;
        this.regenEnergy = 10;
        this.skillManaCost = 0;
        this.skillEnergyCost = 0;
        this.physicalCriticalEvadeRate = 0;
        this.magicalCriticalEvadeRate = 0;
        this.threat = 0;

        this.physicalResist = 0;
        this.fireResist = 0;
        this.waterResist = 0;
        this.earthResist = 0;
        this.airResist = 0;
        this.darkResist = 0;
        this.lightResist = 0;
    }

    /**
     * @param {string} statName
     */
    getStat(statName) {

        if (SecondaryStats.possibleStatsShort[statName]) {
            statName = SecondaryStats.possibleStatsShort[statName];
        }

        if (this[statName] !== null) {
            return this[statName];
        }

        return 0;
    }

    getElementalResist(elementalResist) {
        if (SecondaryStats.possibleElementalResistsShort[elementalResist]) {
            elementalResist = SecondaryStats.possibleElementalResistsShort[elementalResist];
        }

        if (this[elementalResist] !== null) {
            if (this[elementalResist] >= 0) {
                this[elementalResist] = -this[elementalResist];
            }
            if (this[elementalResist] < 0) {
                return 1 + (-this[elementalResist]) / 100;
            } else {
                // max 50%
                return 1 - (Math.min(this[elementalResist], 50)/100);
            }
        }

        return 1;
    }

    toApi() {
        return this;
    }

}

async function loadPossibleStats() {
    // Used to reset stats on runtime

    let res = await conn.query("SELECT * FROM secondarystats;");
    SecondaryStats.prototype.possibleStats = [];
    for (let stat of res) {
        SecondaryStats.prototype.possibleStats.push(stat.name);
    }

    res = await conn.query("SELECT * FROM elementstypes;");
    for (let stat of res) {
        SecondaryStats.prototype.possibleStats.push(`${stat.shorthand}Resist`);
    }
}

loadPossibleStats();

module.exports = SecondaryStats;
