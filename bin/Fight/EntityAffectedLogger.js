const State = require("../SkillsAndStatus/State");

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
            hpDamage: 0,
            mpDamage: 0,
            energyDamage: 0,
            hpRegen: 0,
            mpRegen: 0,
            energyRegen: 0,
            isCritical: false,
        };

    }

    /**
     * 
     * @param {Array<State>} value
     */
    logRemovedStates(value) {
        this.battle.removedStates = value
    }

    /**
    * 
    * @param {Array<State>} value
    */
    logAddeddStates(value) {
        this.battle.addedStates = value
    }

    logRecoverHp(value) {
        this.battle.hpRegen += value;
    }

    logRecoverMp(value) {
        this.battle.hpRegen += value;
    }

    logRecoverEnergy(value) {
        this.battle.hpRegen += value;
    }

    logDamageHp(value) {
        this.battle.hpDamage += value;
    }

    logDamageMp(value) {
        this.battle.mpDamage += value;
    }

    logDamageEnergy(value) {
        this.battle.energyDamage += value;
    }

    logDrainHp(value) {
        this.logRecoverHp(value);
    }

    logDrainMp(value) {
        this.logRecoverMp(value);
    }

}

module.exports = EntityAffectedLogger;