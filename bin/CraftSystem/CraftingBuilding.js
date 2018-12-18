const conn = require("../../conf/mysql");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");
const Craft = require("./Craft");

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

    async getCraftingList(page) {
        page = Number.parseInt(page ? page : 1);
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 10;
        let res = await conn.query(`SELECT COUNT(*) FROM craftitem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem
                                WHERE itemsbase.idRarity >= ? AND itemsbase.idRarity <= ? AND craftitem.minLevel <= ? AND craftitem.maxLevel >= ?;`,
            [this.minRarity, this.maxRarity, this.maxLevel, this.minLevel]);
        let maxPage = Math.ceil(res[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;

        res = await conn.query(`SELECT * FROM craftitem INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE itemsbase.idRarity >= ? AND itemsbase.idRarity <= ? AND craftitem.minLevel <= ? AND craftitem.maxLevel >= ? ORDER BY craftitem.minLevel ASC, craftitem.idCraftItem LIMIT ? OFFSET ?`, [this.minRarity, this.maxRarity, this.maxLevel, this.minLevel, perPage, (page - 1) * perPage]);

        return {
            res: res,
            maxPage: maxPage,
            page: page
        };
    }

    async craftingListToApi(page = 1, lang) {
        let res = await this.getCraftingList(page);
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
            craftToApi.name = itemName;
            craftToApi.type = Translator.getString(lang, "item_types", craft.nomType);
            craftToApi.minLevel = craft.minLevel < this.getMinLevel() ? this.getMinLevel() : craft.minLevel;
            craftToApi.maxLevel = craft.maxLevel > this.getMaxLevel() ? this.getMaxLevel() : craft.maxLevel;
            craftToApi.rarity = Translator.getString(lang, "rarities", Globals.itemsrarities[craft.idRarity]);
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