const Translator = require("../Translator/Translator");
const Potion = require("./Potion");

class ResetTimePotion extends Potion {
    constructor(id) {
        super(id);
    }

    use(character) {
        character.resetWaitTime();
    }

    resultToString(lang) {
        let msg = super.resultToString(lang);
        msg += Translator.getString(lang, "potions", "reset_time");
        return msg;
    }
}

module.exports = ResetTimePotion;