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

    /**
     * 
     * @param {{
            hp: number,
            mp: number,
            energy: number
        }} recoverObject
     */
    logRecovers(recoverObject) {
        this.logGenericForRecover((x) => this.logRecoverHp(x), (x) => this.logDamageHp(x), recoverObject.hp);
        this.logGenericForRecover((x) => this.logRecoverMp(x), (x) => this.logDamageMp(x), recoverObject.mp);
        this.logGenericForRecover((x) => this.logRecoverEnergy(x), (x) => this.logDamageEnergy(x), recoverObject.energy);
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
            funcDamage(value);
        }
    }

}

module.exports = EntityAffectedLogger;