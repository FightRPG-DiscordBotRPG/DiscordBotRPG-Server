const Translator = require("../../Translator/Translator");
const Potion = require("./Potion");

class EnergyPotion extends Potion {
    constructor(id) {
        super(id);
        this.maxUseInOneTime = 5;
    }

    /**
     * 
     * @param {Character} character
     * @param {number}
     */
    async use(character, numberOfUse=1) {
        this.numberOfUse += numberOfUse;
        character.reduceWaitTime(this.getReductionPercentageWithNumberOfUse(numberOfUse));
    }

    getReductionPercentageWithNumberOfUse(numberOfUse = 1) {
        return (1 - (Math.pow(1 - this.getReductionPercentage(), numberOfUse))).toFixed(2);
    }

    resultToString(lang) {
        let msg = super.resultToString(lang);
        msg += Translator.getString(lang, "potions", "reduce_time", [this.getReductionPercentageWithNumberOfUse(this.numberOfUse) * 100]);
        return msg;
    }

    getReductionPercentage() {
        return this.getIdRarity() * 0.1;
    }

    getDesc(lang = "en") {
        let desc = super.getDesc(lang);
        desc += "\n" + Translator.getString(lang, "inventory_equipment", "wait_time_reduction", [this.getReductionPercentage() * 100]);
        return desc;
    }
}

module.exports = EnergyPotion;

/**
 * @typedef {import("../../Character")} Character
 **/
