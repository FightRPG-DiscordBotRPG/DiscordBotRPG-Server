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
        let value = this.getValue(target.entity);

        if (value !== 0) {
        //value = Math.floor(value);
            target.entity.healHp(value);
            target.logger.logSkillRecoverHp(value);
        }
    }

    /**
     * 
     * @param {WorldEntity} entity
     */
    getValue(entity) {
        return Math.floor(entity.maxHP * this.percentageValue + this.fixedValue);
    }

    /**
     * 
     * @param {string} lang
     */
    toApi(lang="en") {
        return {
            type: this.typeShorthand,
            percentageValue: this.percentageValue,
            fixedValue: this.fixedValue,
        };
    }

}

module.exports = EffectRecoverHp;