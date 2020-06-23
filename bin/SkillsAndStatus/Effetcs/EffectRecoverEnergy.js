const Effect = require("../Effect");
const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/EntityAffectedLogger");
const Skill = require("../Skill");

class EffectRecoverEnergy extends Effect {

	/**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
	 */
    applyToOne(target) {
        // TODO: Add recovery resistance
        let value = Math.floor(this.fixedValue);

        if (value !== 0) {
            //value = Math.floor(value);
            target.entity.healEnergy(value);
            target.logger.logRecoverEnergy(value);
        }
    }

}

module.exports = EffectRecoverEnergy;