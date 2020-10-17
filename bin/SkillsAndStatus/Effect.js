const conn = require("../../conf/mysql");
const WorldEntity = require("../Entities/WorldEntity");
const EntityAffectedLogger = require("../Fight/Logger/EntityAffectedLogger");
const Skill = require("./Skill");



class Effect {
    constructor() {
        this.id = 0;
        this.idEffectType = 0;
        this.percentageValue = 0;
        this.fixedValue = 0;
        this.stateValue = null;
        this.statValue = null;
        this.roundsValue = 0;
    }

    async loadWithID(id) {
        this.id = id;
        let res = await conn.query("SELECT * FROM effectsskills WHERE idEffectSkill = ?;", [this.id]);

        this.idEffectType = res[0].idEffectType;
        this.percentageValue = res[0].percentageValue;
        this.fixedValue = res[0].fixedValue;
        this.stateValue = res[0].stateValue;
        this.statValue = res[0].statValue;
        this.roundsValue = res[0].roundsValue;
    }

    /**
	 * 
	 * @param {Array<{entity: WorldEntity, logger: EntityAffectedLogger}>} targets
     * @param {Skill} skillUsed
	 */
    async applyToAll(targets, skillUsed) {
        for (let target of targets) {
            await this.applyToOne(target, skillUsed);
        }
    }

	/**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
	 * @param {Skill} skillUsed
	 */
    async applyToOne(target, skillUsed) {
        throw "Not implemented";
    }

    static async newEffect(id) {
        let effect = new Effect();
        await effect.loadWithID(id);

        let factorizedEffect = EffectFactory.factoryEffectList[effect.idEffectType]();

        for (let key in effect) {
            factorizedEffect[key] = effect[key];
        }

        return factorizedEffect;

    }

    /**
     * 
     * @param {string} lang
     */
    toApi(lang = "en") {
        throw "Not implemented";
    }


}

class EffectFactory {
    /**
    * @callback factoryEffectFunction
    * @returns {Effect} x - ...
    */

    /**
     * @type {Object.<string, factoryEffectFunction>}
     */
    static factoryEffectList = {
        "1": () => { return new EffectRecoverHp(); },
        "2": () => { return new EffectRecoverMp(); },
        "3": () => { return new EffectRecoverEnergy(); },
        "4": () => { return new EffectAddState(); },
        "5": () => { return new EffectRemoveState(); },
    }
}

module.exports = Effect;

const EffectAddState = require("./Effetcs/EffectAddState");
const EffectRecoverEnergy = require("./Effetcs/EffectRecoverEnergy");
const EffectRecoverHp = require("./Effetcs/EffectRecoverHp");
const EffectRecoverMp = require("./Effetcs/EffectRecoverMp");
const EffectRemoveState = require("./Effetcs/EffectRemoveState");