const conn = require("../../conf/mysql");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");
const Craft = require("./Craft");
const Utils = require("../Utilities/Utils");

class CraftingBuilding {
    constructor() {
        this.id = 0;
        this.minRarity = 1;
        this.maxRarity = 1;
        this.minLevel = 0;
        this.maxLevel = 0;
        this.isActive = false;
    }

    async load(idArea) {
        let res = await conn.query("SELECT idCraftBuilding, rarityMin, rarityMax, active, minLevel, maxLevel FROM craftbuilding INNER JOIN itemsrarities ON itemsrarities.idRarity = craftbuilding.rarityMax WHERE idArea = ?", [idArea]);
        if (res[0]) {
            this.id = res[0]["idCraftBuilding"];
            this.minRarity = res[0]["rarityMin"];
            this.maxRarity = res[0]["rarityMax"];
            this.isActive = res[0]["active"];
            this.minLevel = res[0]["minLevel"];
            this.maxLevel = res[0]["maxLevel"];
        }
    }

    async getNumberOfItems(params, lang = "en") {
        let searchParamsResult = Globals.getSearchParams(params, false, true, { "name": true, "rarity": true, "type": true, "subtype": true });

        let paramsCount = Utils.getParamsAndSqlMore(searchParamsResult, [this.minRarity, this.maxRarity, this.maxLevel, this.minLevel, lang], 5);



        let res = await conn.query(`SELECT COUNT(*) FROM craftitem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem
                                INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem 
                                WHERE itemsbase.idRarity >= ? AND itemsbase.idRarity <= ? AND craftitem.minLevel <= ? AND craftitem.maxLevel >= ? AND lang = ? ${paramsCount.more};`, paramsCount.sqlParams
        );

        return res[0]["COUNT(*)"];
    }

    async getCraftingList(page, params, lang = "en") {
        page = Number.parseInt(page ? page : 1);
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 10;

        let maxPage = await this.getNumberOfItems(params, lang);
        page = maxPage > 0 && maxPage < page ? maxPage : page;


        let searchParamsResult = Globals.getSearchParams(params, true, false, { "name": true, "rarity": true, "type": true, "subtype": true });

        let paramsSearch = Utils.getParamsAndSqlMore(searchParamsResult, [this.minRarity, this.maxRarity, this.maxLevel, this.minLevel, lang, perPage, (page - 1) * perPage], 5);

        let res = await conn.query(`SELECT * FROM (SELECT *, @rn:=@rn+1 as idEmplacement FROM (select @rn:=0) row_nums, 
                                (SELECT * FROM craftitem 
                                    INNER JOIN itemsbase USING(idBaseItem)
                                    INNER JOIN itemstypes USING(idType)
                                    INNER JOIN itemssoustypes USING(idSousType)
                                    INNER JOIN localizationitems USING(idBaseItem)
                                    WHERE itemsbase.idRarity >= ? AND itemsbase.idRarity <= ? AND craftitem.minLevel <= ? AND craftitem.maxLevel >= ? AND lang = ? ORDER BY craftitem.minLevel ASC, craftitem.idCraftItem) craftlist
                                ) craftlist_filtered ${paramsSearch.more} LIMIT ? OFFSET ?`, paramsSearch.sqlParams);

        return {
            res: res,
            maxPage: maxPage,
            page: page
        };
    }

    async craftingListToApi(page, params, lang="en") {
        let res = await this.getCraftingList(page, params, lang);
        let toApi = {
            page: res.page,
            maxPage: res.maxPage > 0 ? res.maxPage : 1,
            crafts: {},
        }
        let crafts = res.res;
        let index = 1;
        let indexOffset = (res.page - 1) * 10;

        for (let craft of crafts) {
            let craftToApi = {};
            let itemName = Translator.getString(lang, "itemsNames", craft.idBaseItem);
            craftToApi.idEmplacement = craft.idEmplacement;
            craftToApi.name = itemName;
            craftToApi.type = Translator.getString(lang, "item_types", craft.nomType);
            craftToApi.type_shorthand = craft.nomType;
            craftToApi.minLevel = craft.minLevel < this.getMinLevel() ? this.getMinLevel() : craft.minLevel;
            craftToApi.maxLevel = craft.maxLevel > this.getMaxLevel() ? this.getMaxLevel() : craft.maxLevel;
            craftToApi.rarity = Translator.getString(lang, "rarities", Globals.itemsrarities[craft.idRarity]);
            craftToApi.rarity_shorthand = Globals.itemsrarities[craft.idRarity];
            toApi.crafts[(index + indexOffset)] = craftToApi;
            index++;
        }
        return toApi;
    }

    async getCraft(idCraft) {
        idCraft = await this.getRealIdCraft(idCraft);

        if (idCraft > 0) {
            let craft = new Craft(idCraft);
            await craft.load();
            if (craft.exist && craft.canBeCraft(this.maxRarity)) {
                if (craft.itemInfo.maxLevel > this.maxLevel) {
                    craft.itemInfo.maxLevel = this.maxLevel;
                }
                if (craft.itemInfo.minLevel < this.minLevel) {
                    craft.itemInfo.minLevel = this.minLevel;
                }
                return craft;
            }
        }
        return null;
    }

    async getRealIdCraft(idCraft) {
        idCraft = idCraft && Number.isInteger(Number.parseInt(idCraft)) ? idCraft : 1;
        let res;
        if (idCraft > 0) {
            res = await conn.query("SELECT * FROM craftitem INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE itemsbase.idRarity >= ? AND itemsbase.idRarity <= ? AND craftitem.minLevel <= ? AND craftitem.maxLevel >= ? ORDER BY craftitem.minLevel ASC, craftitem.idCraftItem LIMIT 1 OFFSET ?", [this.minRarity, this.maxRarity, this.maxLevel, this.minLevel, idCraft - 1]);
        }

        return res != null && res[0] != null ? res[0].idCraftItem : 0;
    }

    getMinLevel() {
        return this.minLevel;
    }

    getMaxLevel() {
        return this.maxLevel;
    }

}

module.exports = CraftingBuilding;