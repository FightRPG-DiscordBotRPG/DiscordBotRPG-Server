const Translator = require("../../Translator/Translator");
const Potion = require("./Potion");

class EnergyPotion extends Potion {
    constructor(id) {
        super(id);
    }

    async use(character) {
        this.numberOfUse++;
        character.reduceWaitTime(this.getReductionPercentage());
    }

    resultToString(lang) {
        let msg = super.resultToString(lang);
        msg += Translator.getString(lang, "potions", "reduce_time", [this.getReductionPercentage() * 100]);
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