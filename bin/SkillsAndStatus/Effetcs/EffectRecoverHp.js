const Effect = require("../Effect");
const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/EntityAffectedLogger");
const Skill = require("../Skill");

class EffectRecoverHp extends Effect {

	/**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
	 */
    async applyToOne(target) {
        // TODO: Add recovery resistance
        let value = Math.floor(target.entity.maxHP * this.percentageValue + this.fixedValue);

        if (value !== 0) {
        //value = Math.floor(value);
            target.entity.healHp(value);
            target.logger.logRecoverHp(value);
        }
	}

}

module.exports = EffectRecoverHp;