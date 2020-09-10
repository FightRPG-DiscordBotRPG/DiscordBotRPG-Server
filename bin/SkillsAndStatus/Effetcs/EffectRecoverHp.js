const Effect = require("../Effect");
const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/Logger/EntityAffectedLogger");
const Skill = require("../Skill");

class EffectRecoverHp extends Effect {

	/**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
	 */
    async applyToOne(target) {
        // IDEA: Add recovery resistance
        let value = Math.floor(target.entity.maxHP * this.percentageValue + this.fixedValue);

        if (value !== 0) {
        //value = Math.floor(value);
            target.entity.healHp(value);
            target.logger.logSkillRecoverHp(value);
        }
	}

}

module.exports = EffectRecoverHp;