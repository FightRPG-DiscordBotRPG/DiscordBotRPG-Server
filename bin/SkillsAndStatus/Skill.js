const conn = require("../../conf/mysql");
const Effect = require("./Effect");
const WorldEntity = require("../Entities/WorldEntity");
const Stats = require("../Stats/Stats");
const Utils = require("../Utilities/Utils");
const Trait = require("./Trait");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");

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

    /**
     * 
     * @param {number} id
     */
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

        for (let item of res) {
            let e = await Effect.newEffect(item.idEffectSkill);
            this.effects.push(e);
        }

        this.parseFormula();
    }

    parseFormula() {
        if (this.damage.formula) {
            let formula = this.damage.formula;

            // Replace short stat name by getter
            for (let key in Stats.possibleStatsShort) {
                formula = formula.replace(`.${key}`, `.getStat("${key}")`);
            }

            formula = formula.replace(".def", ".getPhysicalDefense()");
            formula = formula.replace(".mdf", ".getMagicalDefense()");

            this.actualHP = 0;
            this.maxHP = 0;
            this.actualMP = 0;
            this.maxMP = 0;
            this.actualEnergy = 0;
            this.maxEnergy = 0;

            formula = formula.replace(".hp", ".actualHP");
            formula = formula.replace(".mhp", ".maxHP");

            formula = formula.replace(".mp", ".actualMP");
            formula = formula.replace(".mmp", ".maxMP");

            formula = formula.replace(".nrg", ".actualEnergy");
            formula = formula.replace(".mnrg", ".maxEnergy");

            formula = formula.replace(".level", ".getLevel()");

            this.damage.formula = formula;

        }
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

    isPhysical() {
        return this.idAttackType === 2;
    }

    isMagical() {
        return this.idAttackType === 3;
    }

    isRawDamage() {
        return this.idAttackType === 1;
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

    /**
     * 
     * @param {Array} arr
     */
    isDamageTypeIncluded(arr) {
        return arr.includes(this.damage?.idDamageType);
    }

    isInflictingDamageHp() {
        return this.isDamageTypeIncluded([1, 3]);
    }

    isInflictingDamageMp() {
        return this.isDamageTypeIncluded([2, 4]);
    }

    isAffectingHp() {
        return this.isDamageTypeIncluded([1, 3, 5]);
    }

    isAffectingMp() {
        return this.isDamageTypeIncluded([2, 4, 6]);
    }

    isDamage() {
        return this.isDamageTypeIncluded([1, 2]);
    }

    isDrain() {
        return this.isDamageTypeIncluded([3, 4]);
    }

    isRecover() {
        return this.isDamageTypeIncluded([5, 6]);
    }

    isHpRecover() {
        return this.isDamageTypeIncluded([5]);
    }

    isMpRecover() {
        return this.isDamageTypeIncluded([6]);
    }

    /**
     * 
     * @param {WorldEntity} attacker
     * @param {WorldEntity} defender
     */
    evaluateWithTarget(attacker, defender) {
        return this.evaluateSkill(attacker, defender);
    }

    /**
    *
    * @param {WorldEntity} attacker
    * @param {WorldEntity} defender
    */
    evaluateSkill(attacker, defender) {
        let baseValue = this.evalBaseDamageFormula(attacker, defender);
        let value = baseValue * this.repeat;
        value *= this.getElementalRate(attacker);
        value *= defender.getElementalResist(Globals.elementsTypesNameById[this.damage.idElementType] + "Resist");

        if (this.isPhysical()) {
            value *= defender.getPhysicalDefense(attacker.getLevel());
        }
        if (this.isMagical()) {
            value *= defender.getMagicalDefense(attacker.getLevel());
        }

        return Math.round(Utils.getVariance(value, this.damage.variance));
    }

    /**
    *
    * @param {WorldEntity} attacker
    * @param {WorldEntity} defender
    */
    evalBaseDamageFormula(attacker, defender) {
        try {
            // Thoses are used in eval
            let a = attacker;
            let b = defender;

            return Math.max(eval(this.damage?.formula), 0) || 1;

        } catch (e) {
            console.log(e);
            return 0;
        }
    }

    /**
     * 
     * @param {WorldEntity} attacker
     */
    getElementalRate(attacker) {
        return attacker.getTraitsValueMult(Trait.TraitTypesNames.ElementRate, this.damage.idElementType);
    }

    getRepeatNumber() {
        if (this.isDamage() || this.isDrain()) {
            //repeats += this.subject().attackTimesAdd();
        }
        return Math.floor(this.repeat);
    }

    getDesc(lang="en") {
        return Translator.getString(lang, "skillDesc", this.id);
    }

    getName(lang = "en") {
        return Translator.getString(lang, "skillName", this.id);
    }

    /**
     * 
     * @param {string} casterName
     * @param {string} lang
     */
    getMessage(casterName, lang = "en") {
        return `${casterName} ${Translator.getString(lang, "skillMessage", this.id, [this.getName()])}`;
    }
}


module.exports = Skill;