'use strict';
const conn = require("../../../conf/mysql");

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
    }

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        this.id = id;
        this.hitRate = 0;
        this.evadeRate = 0;
        this.criticalRate = 0;
        this.regenHp = 0;
        this.regenMp = 0;
        this.regenEnergy = 0;
        this.skillManaCost = 0;
        this.skillEnergyCost = 0;
        this.physicalCriticalEvadeRate = 0;
        this.magicalCriticalEvadeRate = 0;
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
        SecondaryStats.prototype.possibleStats.push(stat.name);
    }
}

loadPossibleStats();

module.exports = SecondaryStats;
