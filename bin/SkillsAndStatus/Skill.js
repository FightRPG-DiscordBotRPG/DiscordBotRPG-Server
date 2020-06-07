const conn = require("../../conf/mysql");
const Effect = require("./Effect");


class Skill {
    constructor() {
        this.id = 0;
        this.shorthand = "";
        this.idSkillType = null;
        this.energyCost = 0;
        this.manaCost = 0;
        this.idTargetRange = 1;
        this.timeToCast = 0;
        this.successRate = 0;
        this.repeat = 1;
        this.energyGain = 0;
        this.idAttackType = 0;
        this.damage = {
            idDamageType: 0,
            idElementType: null,
            formula: "1",
            variance: 0,
            criticalHit: false,
        }
        /**
         * @type {Array<Effect>}
         */
        this.effects = [];
        this.requiredSubtype = [];

        this.damage = null;

        this.currentCastPreparation = 0;
    }

    async loadWithID(id) {
        this.id = id;
        let res = await conn.query("SELECT * FROM skills INNER JOIN castinfo ON castinfo.idSkill = skills.idSkill LEFT JOIN damageinfo ON damageinfo.idSkill = skills.idSkill WHERE skills.idSkill = ?;", [this.id]);

        this.shorthand = res[0].shorthand;
        this.idSkillType = res[0].idSkillType;
        this.energyCost = res[0].energyCost;
        this.manaCost = res[0].manaCost;
        this.idTargetRange = res[0].idTargetRange;
        this.timeToCast = res[0].timeToCast;
        this.successRate = res[0].successRate;
        this.repeat = res[0].repeat;
        this.energyGain = res[0].energyGain;
        this.idAttackType = res[0].idAttackType;
        this.damage = {
            idDamageType: res[0].idDamageType,
            idElementType: res[0].idElementType,
            formula: res[0].formula,
            variance: res[0].variance,
            criticalHit: res[0].criticalHit,
        }

        res = await conn.query("SELECT idEffectSkill FROM effectsskills WHERE idSkill = ?;", [this.id]);

        let promises = [];
        for (let item of res) {
            let e = new Effect();
            this.effects.push(e);
            promises.push(e.loadWithID(item.idEffectSkill));
        }

        await Promise.all(promises);
    }

    canBeCast() {
        return this.currentCastPreparation >= this.timeToCast;
    }

    resetCast() {
        this.currentCastPreparation = 0;
    }

    isTargetingAliveEnemies() {
        return [1, 2, 3, 4, 5].includes(this.idTargetRange);
    }

    isTargetingAliveAllies() {
        return [6, 7, 8, 9].includes(this.idTargetRange);
    }

    isTargetingDeadAllies() {
        return [10, 11, 12, 13].includes(this.idTargetRange);
    }

    isTargetingSelf() {
        return this.idTargetRange === 14;
    }

    getNumberOfTarget() {
        switch (this.idTargetRange) {
            case 1:
            case 9:
            case 13:
                return 99;
            case 2:
            case 6:
            case 10:
                return 1;
            case 3:
            case 7:
            case 11:
                return 2;
            case 4:
            case 8:
            case 12:
                return 3;
            case 5:
                return 4;
            default:
                return 0;
        }
    }
}


module.exports = Skill;