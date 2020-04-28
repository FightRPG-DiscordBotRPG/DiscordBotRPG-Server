const conn = require("../../conf/mysql");
const Translator = require("../Translator/Translator");
const Item = require("../Items/Item");

class Craft {
    constructor(id) {
        this.id = id;
        this.exist = false;
        this.requiredItems = [];
        this.itemInfo = {};
    }

    async load() {
        let res = await conn.query(`SELECT DISTINCT itemsbase.idRarity, imageItem, nomType, nomRarity, couleurRarity, nomSousType, maxLevel, minLevel, stackable, itemsbase.idBaseItem FROM craftitemsneeded 
        INNER JOIN craftitem ON craftitem.idCraftItem = craftitemsneeded.IdCraftItem
        INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem
        INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType 
        INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity 
        INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
        WHERE craftitemsneeded.IdCraftItem = ?;
        `, [this.id]);
        if (res[0]) {
            res = res[0];
            this.exist = true;
            this.itemInfo = {
                idBase: res.idBaseItem,
                image: res.imageItem,
                typename: res.nomType,
                stypename: res.nomSousType,
                rarity: res.nomRarity,
                idRarity: res.idRarity,
                rarityColor: res.couleurRarity,
                maxLevel: res.maxLevel,
                minLevel: res.minLevel,
                stackable: res.stackable,
            }

            res = await conn.query(`SELECT imageItem, nomType, nomRarity, couleurRarity, nomSousType, maxLevel, minLevel, number, itemsbase.idBaseItem FROM craftitemsneeded 
            INNER JOIN craftitem ON craftitem.idCraftItem = craftitemsneeded.IdCraftItem
            INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitemsneeded.NeededItem
            INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType 
            INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity 
            INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
            WHERE craftitemsneeded.IdCraftItem = ?;`, [this.id]);

            for (let item of res) {
                this.requiredItems.push({
                    idBase: item.idBaseItem,
                    typename: item.nomType,
                    stypename: item.nomSousType,
                    rarity: item.nomRarity,
                    number: item.number
                });
            }
        }
    }

    toApi(lang) {
        let craft = {};
        craft.name = Item.getName(lang, this.itemInfo.idBase);
        craft.desc = Item.getDesc(lang, this.itemInfo.idBase);
        craft.image = this.itemInfo.image;
        craft.rarityColor = this.itemInfo.rarityColor;
        craft.rarity = Translator.getString(lang, "rarities", this.itemInfo.rarity);
        craft.rarity_shorthand = this.itemInfo.rarity;
        craft.type = Translator.getString(lang, "item_types", this.itemInfo.typename);
        craft.type_shorthand = this.itemInfo.typename;
        craft.subType = Translator.getString(lang, "item_sous_types", this.itemInfo.stypename);
        craft.subType_shorthand = this.itemInfo.stypename;
        craft.minLevel = this.itemInfo.minLevel;
        craft.maxLevel = this.itemInfo.maxLevel;
        craft.requiredItems = [];

        for (let item of this.requiredItems) {
            craft.requiredItems.push({
                name: Item.getName(lang, item.idBase),
                type: Translator.getString(lang, "item_types", item.typename),
                type_shorthand: item.typename,
                subType: Translator.getString(lang, "item_sous_types", item.stypename),
                subType_shorthand: item.stypename,
                rarity: Translator.getString(lang, "rarities", item.rarity),
                rarity_shorthand: item.rarity,
                number: item.number,
            })
        }
        return craft;
    }

    canBeCraft(buildingRarityLevel) {
        return this.itemInfo.idRarity <= buildingRarityLevel;
    }

    /**
     * @returns {string}
     */
    getRarity() {
        return this.itemInfo.rarity;
    }

    isStackable() {
        return this.itemInfo.stackable;
    }

}

module.exports = Craft;