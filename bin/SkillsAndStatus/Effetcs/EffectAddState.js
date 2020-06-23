const Effect = require("../Effect");
const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/EntityAffectedLogger");
const Skill = require("../Skill");

class EffectAddState extends Effect {

    /**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
     * @param {Skill} skillUsed
     */
    applyToOne(target, skillUsed) {
        let chance = this.percentageValue;

        if (!skillUsed.isRawDamage()) {
            chance *= target.entity.getStateRate(this.stateValue);
            chance *= target.attacker.getLuckEffectRate(target.entity);
        }
        if (Math.random() < chance) {
            target.logger.logAddState(await target.entity.addState(this.stateValue))
        }
    }

}

module.exports = EffectAddState;