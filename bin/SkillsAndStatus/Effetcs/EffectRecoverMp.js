const Effect = require("../Effect");
const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/EntityAffectedLogger");
const Skill = require("../Skill");

class EffectRecoverMp extends Effect {

	/**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
	 */
    applyToOne(target) {
        // TODO: Add recovery resistance
        let value = Math.floor(target.entity.maxMP * this.percentageValue + this.fixedValue);

        if (value !== 0) {
            //value = Math.floor(value);
            target.entity.healMp(value);
            target.logger.logRecoverMp(value);
        }
    }

}

module.exports = EffectRecoverMp;