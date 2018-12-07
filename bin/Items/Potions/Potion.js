const Translator = require("../../Translator/Translator");
const Consumable = require("../Consumable");

class Potion extends Consumable {
    constructor(id) {
        super(id);
    }

    resultToString(lang) {
        return Translator.getString(lang, "potions", "drink", [this.getName(lang)]);
    }
}

module.exports = Potion;