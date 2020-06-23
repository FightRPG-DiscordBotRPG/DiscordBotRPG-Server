const Effect = require("../Effect");
const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/EntityAffectedLogger");
const Skill = require("../Skill");

class EffectRemoveState extends Effect {

    /**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
     * @param {Skill} skillUsed
     */
    applyToOne(target) {
        let chance = this.percentageValue;

        if (Math.random() < chance) {
            target.logger.logRemoveState(target.entity.removeState(this.stateValue));
        }
    }

}

module.exports = EffectRemoveState;