const WorldEntity = require("../../Entities/WorldEntity");
const EntityAffectedLogger = require("../../Fight/Logger/EntityAffectedLogger");
const Skill = require("../Skill");
const Effect = require("../Effect");
const Translator = require("../../Translator/Translator");


class EffectRemoveState extends Effect {

    /**
     * @param {{entity: WorldEntity, logger: EntityAffectedLogger, attacker: WorldEntity}} target
     * @param {Skill} skillUsed
     */
    async applyToOne(target) {
        let chance = this.percentageValue;

        if (Math.random() < chance) {
            target.logger.logRemoveState(target.entity.removeState(this.stateValue));
        }
    }

    toApi(lang = "en") {
        return {
            type: "removeState",
            stateRemoved: Translator.getString(lang, "statesNames", this.stateValue),
        };
    }

}

module.exports = EffectRemoveState;