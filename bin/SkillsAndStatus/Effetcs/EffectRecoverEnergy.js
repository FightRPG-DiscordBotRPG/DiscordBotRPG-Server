const Effect = require("../Effect");
const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/Logger/EntityAffectedLogger");

class EffectRecoverEnergy extends Effect {

	/**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
	 */
    async applyToOne(target) {
        // IDEA: Add recovery resistance
        let value = Math.floor(this.fixedValue);

        if (value !== 0) {
            //value = Math.floor(value);
            target.entity.healEnergy(value);
            target.logger.logSkillRecoverEnergy(value);
        }
    }

}

module.exports = EffectRecoverEnergy;