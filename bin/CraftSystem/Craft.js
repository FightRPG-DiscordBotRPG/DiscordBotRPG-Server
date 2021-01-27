const conn = require("../../conf/mysql");
const Translator = require("../Translator/Translator");
const Item = require("../Items/Item");
const SimpleItemData = require("../Items/SimpleItemData");

class Craft {
    constructor(id) {
        this.id = id;
        this.exist = false;
        /**
         * @type {Array<SimpleItemData>}
         **/
        this.requiredItems = [];
        /**
         * @type {{
                idBase: number,
                image: string,
                typename: string,
                stypename:  string,
                rarity:     string,
                idRarity: number,
                rarityColor: string,
                maxLevel: number,
                minLevel: number,
                stackable: boolean,
                minRebirthLevel: number,
                maxRebirthLevel: number,
            }}
         **/
        this.itemInfo = {};
    }

    async load() {
        let res = await conn.query(`SELECT DISTINCT itemsbase.idRarity, imageItem, nomType, nomRarity, couleurRarity, nomSousType, maxLevel, minLevel, stackable, itemsbase.idBaseItem, craftitem.minRebirthLevel, craftitem.maxRebirthLevel FROM craftitemsneeded 
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
                minRebirthLevel: res.minRebirthLevel,
                maxRebirthLevel: res.maxRebirthLevel,
            }

            res = await conn.query(`SELECT imageItem, nomType, nomRarity, couleurRarity, nomSousType, maxLevel, minLevel, number, itemsbase.idBaseItem, craftitemsneeded.minRebirthLevel FROM craftitemsneeded 
            INNER JOIN craftitem ON craftitem.idCraftItem = craftitemsneeded.IdCraftItem
            INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitemsneeded.NeededItem
            INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType 
            INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity 
            INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
            WHERE craftitemsneeded.IdCraftItem = ?;`, [this.id]);

            for (let item of res) {
                this.requiredItems.push(SimpleItemData.createFromData({
                    idBase: item.idBaseItem,
                    typename: item.nomType,
                    stypename: item.nomSousType,
                    rarity: item.nomRarity,
                    number: item.number,
                    minRebirthLevel: item.minRebirthLevel,
                }));
            }
        }
    }

    toApi(lang) {
        let craft = {};
        craft.name = Item.getName(this.itemInfo.idBase, lang);
        craft.desc = Item.getDesc(this.itemInfo.idBase, lang);
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
        craft.minRebirthLevel = this.itemInfo.minRebirthLevel;
        craft.maxRebirthLevel = this.itemInfo.maxRebirthLevel;
        craft.maxLevel = this.itemInfo.maxLevel;
        craft.requiredItems = [];

        for (let item of this.requiredItems) {
            craft.requiredItems.push(item.toApi(lang));
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