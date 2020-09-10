const State = require("../../SkillsAndStatus/State");
const DamageAndHealLogger = require("./DamageAndHealLogger");

class EntityAffectedLogger {
    constructor() {

        this.entity = {
            name: "",
            actualHP: 0,
            maxHP: 0,
            actualMP: 0,
            maxMP: 0,
            actualEnergy: 0,
            maxEnergy: 0,
            level: 0,
        };

        this.battle = {
            /**
             * @type {Array<State>}
             */
            removedStates: [],
            /**
             * @type {Array<State>}
             */
            addedStates: [],

            statesResults: new DamageAndHealLogger(),
            skillResults: new DamageAndHealLogger(),
            isCritical: false,
        };

    }

    /**
     * 
     * @param {State} value
     */
    logRemoveState(value) {
        this.battle.removedStates.push(value);
    }

    /**
    *
    * @param {State} value
    */
    logAddState(value) {
        this.battle.addedStates.push(value);
    }

    // Log for skill result

    logSkillRecoverHp(value) {
        this.battle.skillResults.hpRegen += value;
    }

    logSkillRecoverMp(value) {
        this.battle.skillResults.mpRegen += value;
    }

    logSkillRecoverEnergy(value) {
        this.battle.skillResults.energyRegen += value;
    }

    logSkillDamageHp(value) {
        this.battle.skillResults.hpDamage += value;
    }

    logSkillDamageMp(value) {
        this.battle.skillResults.mpDamage += value;
    }

    logSkillDamageEnergy(value) {
        this.battle.skillResults.energyDamage += value;
    }

    // Log for states results

    logStatesRecoverHp(value) {
        this.battle.statesResults.hpRegen += value;
    }

    logStatesRecoverMp(value) {
        this.battle.statesResults.mpRegen += value;
    }

    logStatesRecoverEnergy(value) {
        this.battle.statesResults.energyRegen += value;
    }

    logStatesDamageHp(value) {
        this.battle.statesResults.hpDamage += value;
    }

    logStatesDamageMp(value) {
        this.battle.statesResults.mpDamage += value;
    }

    logStatesDamageEnergy(value) {
        this.battle.statesResults.energyDamage += value;
    }

    // Drains

    logDrainHp(value) {
        this.logSkillRecoverHp(value);
    }

    logDrainMp(value) {
        this.logSkillRecoverMp(value);
    }

    /**
     * Use this for recovery per turn based on states effects
     * @param {{
            hp: number,
            mp: number,
            energy: number
        }} recoverObject
     */
    logRecovers(recoverObject) {
        this.logGenericForRecover((x) => this.logStatesRecoverHp(x), (x) => this.logStatesDamageHp(x), recoverObject.hp);
        this.logGenericForRecover((x) => this.logStatesRecoverMp(x), (x) => this.logStatesDamageMp(x), recoverObject.mp);
        this.logGenericForRecover((x) => this.logStatesRecoverEnergy(x), (x) => this.logStatesDamageEnergy(x), recoverObject.energy);
    }

    /**
     * Should Only Be Called by logRecovers function
     * @param {Function} funcRecover
     * @param {Function} funcDamage
     * @param {number} value
     */
    logGenericForRecover(funcRecover, funcDamage, value) {
        if (value >= 0) {
            funcRecover(value);
        } else {
            funcDamage(-value);
        }
    }

}

module.exports = EntityAffectedLogger;