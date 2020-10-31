const Item = require("../Item");
const Consumable = require("../Consumable");
const Translator = require("../../Translator/Translator");


class LootBox extends Consumable {
    constructor(id) {
        super(id);
        this.openResult = {
            items: [],
            gold: 0
        }
        this.canBeMultUsed = true;
        this.maxUseInOneTime = 100;
    }

    addItem(id, number) {
        let item = {
            id: id,
            number: number
        };
        this.openResult.items.push(item);
    }

    addGold(goldNumber) {
        this.openResult.gold += goldNumber;
    }

    resultToString(lang) {
        let msg = this.numberOfUse > 1 ? Translator.getString(lang, "lootboxes", "open_message_mult", [this.numberOfUse]) : Translator.getString(lang, "lootboxes", "open_message");
        let drop = false;
        if (this.openResult.items.length > 0) {
            for (let i = 0; i < this.openResult.items.length; i++) {
                msg += Item.getName(this.openResult.items[i].id, lang) + " [x" + Translator.getFormater(lang).format(this.openResult.items[i].number) + "]";
                if (i < (this.openResult.items.length - 1)) {
                    msg += ", ";
                }
            }
            drop = true;
        }
        if (this.openResult.gold > 0) {
            msg += "\n" + Translator.getFormater(lang).format(this.openResult.gold) + "G";
            drop = true;
        }

        if (drop == false) {
            msg = this.numberOfUse > 1 ? Translator.getString(lang, "lootboxes", "no_drop_mult", [this.numberOfUse]) : Translator.getString(lang, "lootboxes", "no_drop");
        }

        return msg;

    }

}

module.exports = LootBox;