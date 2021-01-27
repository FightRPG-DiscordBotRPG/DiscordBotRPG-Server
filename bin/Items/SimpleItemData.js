const Item = require("./Item");
const Translator = require("../Translator/Translator");

class SimpleItemData {
    constructor() {
        this.idBase = 0;
        this.typename = "";
        this.stypename = "";
        this.rarity = "";
        this.number = 0;
        this.minRebirthLevel = 0;
    }

    /**
     * 
     * @param {any} data
     * @returns {SimpleItemData}
     */
    static createFromData(data) {
        return Object.assign(new SimpleItemData(), data);
    }

    async toApi(lang = "en") {
        return {
            name: Item.getName(this.idBase, lang),
            type: Translator.getString(lang, "item_types", this.typename),
            type_shorthand: this.typename,
            subType: Translator.getString(lang, "item_sous_types", this.stypename),
            subType_shorthand: this.stypename,
            rarity: Translator.getString(lang, "rarities", this.rarity),
            rarity_shorthand: this.rarity,
            number: this.number,
            missing: this.missing,
        }
    }
}


module.exports = SimpleItemData;