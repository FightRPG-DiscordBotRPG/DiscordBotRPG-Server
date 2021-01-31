const conn = require("../../conf/mysql");
const Item = require("../Items/Item");
const Translator = require("../Translator/Translator");

class ShopItem {
    constructor(id) {
        this.id = id;
        this.level = 0;
        this.rebirthLevel = 0;
        this.name = "";
        this.number = 0;
        this.price = 0;
        this.type = "";
        this.subType = "";
        this.rarity = "";
        this.idBase = 0;
        this.tax = 0;
    }

    async load() {
        let res = await conn.query("SELECT level, number, price, itemstypes.nomType, itemssoustypes.nomSousType, itemsrarities.nomRarity, sellableitems.idBaseItem, rebirthLevel FROM sellableitems INNER JOIN itemsbase ON itemsbase.idBaseItem = sellableitems.idBaseItem INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType WHERE idSellableItems = ?;", [this.id]);
        if (res[0] != null) {
            this.level = res[0].level;
            this.number = res[0].number;
            this.price = res[0].price;
            this.rebirthLevel = res[0].rebirthLevel;

            this.idBase = res[0].idBaseItem;


            this.rarity = res[0].nomRarity;
            this.type = res[0].nomType;
            this.subType = res[0].nomSousType;
        }
    }

    /**
     * 
     * @param {float} tax 
     */
    setTax(tax) {
        this.tax = tax + 1;
    }

    toApi(lang = "en") {
        return {
            name: Item.getName(this.idBase, lang),
            desc: Item.getDesc(this.idBase, lang),
            rarity: Translator.getString(lang, "rarities", this.rarity),
            rarity_shorthand: this.rarity,
            type: Translator.getString(lang, "item_types", this.type),
            type_shorthand: this.type,
            subType: Translator.getString(lang, "item_sous_types", this.subType),
            subType_shorthand: this.subType,
            level: this.level,
            rebirthLevel: this.rebirthLevel,
            number: this.number,
            price: this.price,
            priceWithTax: Math.round(this.price * this.tax),
        }
    }

    getName(lang = "en") {
        return Item.getName(this.idBase, lang);
    }


}

module.exports = ShopItem;