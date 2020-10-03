'use strict';
const conn = require("../../../conf/mysql");
const { elementsTypesNameById } = require("../../Globals");
const Globals = require("../../Globals");

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
        CritcalEvadeRate: "criticalEvadeRate",
        MagicalEvadeRate: "magicalEvadeRate",
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
        cevr: SecondaryStats.possibleStats.CritcalEvadeRate,
        magevr: SecondaryStats.possibleStats.MagicalEvadeRate,
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

    static ratiosBasedOnSubtype = {
        hitRate: {
            "metal": 0.5,
            "cloth": 1.2,
            "leather": 1.1,
            "bow": 1,
            "dagger": 1,
            "sword": 1.4,
            "wand": 1,
            "whip": 1.1,
            "staff": 1,
        },
        evadeRate: {
            "metal": 0.5,
            "cloth": 1.2,
            "leather": 1.1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 0.8,
        },
        criticalRate: {
            "metal": 0.9,
            "cloth": 1.1,
            "leather": 1.1,
            "bow": 1.4,
            "dagger": 1.4,
            "sword": 1,
            "wand": 1,
            "whip": 1.2,
            "staff": 1,
        },
        regenHp: {
            "metal": 1.5,
            "cloth": 0.6,
            "leather": 0.8,
            "bow": 0.8,
            "dagger": 0.8,
            "sword": 0.8,
            "wand": 0.6,
            "whip": 0.8,
            "staff": 0.6,
        },
        regenMp: {
            "metal": 0.6,
            "cloth": 1.3,
            "leather": 0.9,
            "bow": 0.8,
            "dagger": 0.8,
            "sword": 0.8,
            "wand": 1.4,
            "whip": 0.8,
            "staff": 1.4,
        },
        regenEnergy: {
            "metal": 1.2,
            "cloth": 0.6,
            "leather": 1.2,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 0.8,
            "whip": 1.1,
            "staff": 0.8,
        },
        skillManaCost: {
            "metal": 0.6,
            "cloth": 1.4,
            "leather": 0.9,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1.4,
            "whip": 1,
            "staff": 1.2,
        },
        skillEnergyCost: {
            "metal": 1.2,
            "cloth": 0.8,
            "leather": 1.2,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 0.8,
            "whip": 1,
            "staff": 0.8,
        },
        criticalEvadeRate: {
            "metal": 1,
            "cloth": 1,
            "leather": 1.3,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        magicalEvadeRate: {
            "metal": 1,
            "cloth": 1.4,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        threat: {
            "metal": 1.4,
            "cloth": 0.6,
            "leather": 0.8,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        physicalResist: {
            "metal": 1.6,
            "cloth": 0.4,
            "leather": 0.6,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        fireResist: {
            "metal": 1,
            "cloth": 1.1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1.1,
        },
        waterResist: {
            "metal": 1,
            "cloth": 1.1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1.1,
        },
        earthResist: {
            "metal": 1,
            "cloth": 1.1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1.1,
        },
        airResist: {
            "metal": 1,
            "cloth": 1.1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1.1,
        },
        darkResist: {
            "metal": 1,
            "cloth": 1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        lightResist: {
            "metal": 1,
            "cloth": 1,
            "leather": 1,
            "bow": 1,
            "dagger": 1,
            "sword": 1,
            "wand": 1,
            "whip": 1,
            "staff": 1,
        },
        
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
        this.criticalEvadeRate = 0;
        this.magicalEvadeRate = 0;
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

        if (!isNaN(this[elementalResist])) {
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
        let r = {};
        let statsPossible = Globals.allSecondaryStatsNames;
        for (let i in statsPossible) {
            r[statsPossible[i]] = this[statsPossible[i]];
        }
        return r;
    }

    getFlatElementalResist(elementName) {
        return this[elementName + "Resist"];
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
