const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/Logger/EntityAffectedLogger");
const Skill = require("../Skill");
const Effect = require("../Effect");
const Globals = require("../../Globals");


class EffectAddState extends Effect {

    /**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
     * @param {Skill} skillUsed
     */
    async applyToOne(target, skillUsed) {
        if (this.stateValue <= 0) {
            return;
        }

        let chance = this.percentageValue;

        if (!skillUsed.isRawDamage()) {

            if (skillUsed.id === 1 && this.stateValue === 13) {
                // PENDING : Hardcoded for stun on auto attack
                chance = target.attacker.stun(target.entity.getStat("will")) ? 1 : 0;
            } else {
                chance *= target.entity.getStateRate(this.stateValue);
                chance *= target.attacker.getLuckEffectRate(target.entity);
            }

            // is stun
            if (this.stateValue === 13) {
                if (target.entity.consecutiveStuns < Globals.maxConsecutiveStuns) {
                    target.entity.consecutiveStuns++;
                } else {
                    target.entity.consecutiveStuns = 0;
                    chance = 0;
                }

            }

        }
        if (Math.random() < chance) {
            let addedState = await target.entity.addState(this.stateValue);
            //Can be null if state is already here
            if (addedState) {
                target.logger.logAddState(addedState);
            }
        }
    }

}

module.exports = EffectAddState;