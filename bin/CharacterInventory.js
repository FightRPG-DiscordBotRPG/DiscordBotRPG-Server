'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Item = require("./Items/Item.js");
const Consumable = require("./Items/Consumable");
const Translator = require("./Translator/Translator");
const Stats = require("./Stats/Stats");
const Utils = require("./Utilities/Utils.js");
const SimpleItemData = require("./Items/SimpleItemData.js");
const RebirthData = require("./Rebirths/RebirthData.js");

class CharacterInventory {
    // Discord User Info
    constructor(id) {
        this.id = id;
    }

    // Load user from DB
    // If not exist create new one
    async loadInventory(id) {
        this.id = id;
    }

    async isEquipable(idEmplacement) {
        idEmplacement = idEmplacement > 0 ? idEmplacement : 1;
        let isEquipable = await conn.query(`SELECT *
                                            FROM charactersinventory
                                            INNER JOIN items ON items.idItem = charactersinventory.idItem
                                            INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                            INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                            INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                                            WHERE idCharacter = ?
                                            ORDER BY items.favorite DESC, items.idItem ASC, itemsbase.idRarity DESC
                                            LIMIT 1 OFFSET ?`, [this.id, idEmplacement - 1]);

        if (isEquipable[0]) {
            return isEquipable[0].equipable == 1;
        }
        return false;
    }

    async addToInventory(idItem, number) {
        number = number > 0 ? number : 1;
        if (await this.isThisItemInInventory(idItem)) {
            await conn.query("UPDATE charactersinventory SET number = number + ? WHERE idCharacter = ? AND idItem = ?;", [number, this.id, idItem]);
        } else {
            await conn.query("INSERT INTO charactersinventory VALUES (?, ?, ?);", [this.id, idItem, number]);
        }
    }

    static async addToInventory(idCharacter, idItem, number) {
        number = number > 0 ? number : 1;
        if (await CharacterInventory.isThisItemInInventory(idCharacter, idItem)) {
            await conn.query("UPDATE charactersinventory SET number = number + ? WHERE idCharacter = ? AND idItem = ?;", [number, idCharacter, idItem]);
        } else {
            await conn.query("INSERT INTO charactersinventory VALUES (?, ?, ?);", [idCharacter, idItem, number]);
        }
    }

    // Used by craft
    async removeSomeFromInventoryIdBase(idBase, number, deleteObject) {
        number = number ? number : 1;
        let item = await this.getItemByBase(idBase);
        if (item != null) {
            item.number -= number;
            if (item.number <= 0) {
                await this.deleteFromInventory(item, deleteObject);
            } else {
                await conn.query("UPDATE `charactersinventory` SET `number` = number - ? WHERE `charactersinventory`.`idCharacter` = ? AND `charactersinventory`.`idItem` = ?;", [number, this.id, item.id])
            }
        }
    }

    /**
     * Remove from inventory item | idEmplacement needs to be in the array
     * @param {any} idEmplacement
     * @param {any} number
     * @param {any} deleteObject
     */
    async removeSomeFromInventory(idEmplacement, number, deleteObject) {
        number = number ? number : 1;
        let item = await this.getItem(idEmplacement);
        if (item != null) {
            item.number -= number;
            if (item.number <= 0) {
                await this.deleteFromInventory(item, deleteObject);
            } else {
                await conn.query("UPDATE `charactersinventory` SET `number` = number - ? WHERE `charactersinventory`.`idCharacter` = ? AND `charactersinventory`.`idItem` = ?;", [number, this.id, item.id])
            }
        }
    }

    /**
     * 
     * @param {Item} item 
     * @param {Number} number 
     * @param {Boolean} deleteObject 
     */
    async removeSomeFromInventoryItem(item, number, deleteObject) {
        number = number ? number : 1;
        item.number -= number;
        if (item.number <= 0) {
            await this.deleteFromInventory(item, deleteObject);
        } else {
            await conn.query("UPDATE `charactersinventory` SET `number` = number - ? WHERE `charactersinventory`.`idCharacter` = ? AND `charactersinventory`.`idItem` = ?;", [number, this.id, item.id])
        }
    }

    /**
     * Remove item from database character inventory and if demand remove it from the game
     * @param {Item} item
     * @param {boolean} deleteObject
     */
    async deleteFromInventory(item, deleteObject) {
        await conn.query("DELETE FROM charactersinventory WHERE idCharacter = ? AND idItem = ?", [this.id, item.id]);
        if (deleteObject) {
            await Item.deleteItem(item.id);
        }
    }

    /**
     * Delete all objects from inventory
     */
    async deleteAllFromInventory(params, lang = "en") {

        let searchParamsResult = Globals.getSearchParams(params, false, true);

        let paramsResult = Utils.getParamsAndSqlMore(searchParamsResult, [this.id], 1);

        // Only way to do
        // Multiple queries 1 query = impossible
        let res = await conn.query(`SELECT charactersinventory.idItem
                                    FROM charactersinventory
                                    INNER JOIN items ON items.idItem = charactersinventory.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN itemspower ON itemspower.idItem = charactersinventory.idItem
                                    ${Utils.getLocalizationInnerJoin(lang)}
                                    WHERE idCharacter = ? AND favorite = 0 ${paramsResult.more};`, paramsResult.sqlParams);
        let ids = [];
        for (let i in res) {
            ids[i] = res[i].idItem;
        }

        // Delete from inventory
        await conn.query(`DELETE ci FROM
                          charactersinventory ci
                          INNER JOIN items ON items.idItem = ci.idItem
                          INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                          INNER JOIN itemspower ON itemspower.idItem = ci.idItem
                          ${Utils.getLocalizationInnerJoin(lang)}
                          WHERE idCharacter = ? AND favorite = 0 ${paramsResult.more};`, paramsResult.sqlParams);

        // Delete items
        await Item.deleteItems(ids);
    }

    async getAllInventoryValue(params, lang = "en") {

        let searchParamsResult = Globals.getSearchParams(params, false, true);
        let paramsResult = Utils.getParamsAndSqlMore(searchParamsResult, [this.id], 1);

        let value = await conn.query(`SELECT COALESCE(SUM((items.level * (1+itemsbase.idRarity) * charactersinventory.number)), 0) as value
                                      FROM charactersinventory
                                      INNER JOIN items ON items.idItem = charactersinventory.idItem
                                      INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                      INNER JOIN itemspower ON itemspower.idItem = charactersinventory.idItem
                                      ${Utils.getLocalizationInnerJoin(lang)}
                                      WHERE idCharacter = ? AND items.favorite = 0 ${paramsResult.more};`, paramsResult.sqlParams);

        value = value[0]["value"];
        return { value: value, isFiltered: searchParamsResult.values.length > 0 };
    }



    /**
     * 
     * @param {*} page 
     * @param {{rarity: Number,type: Number,level: Number, power: Number}} params
     */
    async getAllItemsAtThisPage(page, params, lang = "en") {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 10;
        let maxPage = Math.ceil(await this.getNumberOfItem(params, lang) / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;
        let items = {};
        let offset = (page - 1) * perPage;

        let searchParamsResult = Globals.getSearchParams(params);

        let paramsResult = Utils.getParamsAndSqlMore(searchParamsResult, [this.id, perPage, offset], 1);

        let res = await conn.query(`SELECT * 
                                    FROM
                                    (
                                        SELECT *, @rn:=@rn+1 as idEmplacement
                                        FROM (select @rn:=0) row_nums,
                                            (SELECT items.idItem, itemssoustypes.idSousType, charactersinventory.number, items.level, itemsbase.idRarity, itemsbase.idType, itemspower.power, nameItem, items.favorite, items.rebirthLevel
                                                FROM charactersinventory
                                                INNER JOIN items ON items.idItem = charactersinventory.idItem
                                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                                INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                                INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                                                INNER JOIN itemspower ON itemspower.idItem = charactersinventory.idItem
                                                ${Utils.getLocalizationInnerJoin(lang)}
                                                WHERE idCharacter = ?
                                                ORDER BY items.favorite DESC, items.idItem ASC, itemsbase.idRarity
                                            ) character_inventory
                                    ) inventory_filtered ${paramsResult.more} LIMIT ? OFFSET ?;`, paramsResult.sqlParams);

        let promises = [];

        for (let i in res) {
            promises.push((async () => {
                try {
                    let item = await Item.newItem(res[i].idItem, res[i].nomSousType);
                    item.number = res[i].number;
                    items[res[i].idEmplacement] = item;
                } catch (ex) {
                    console.log(ex);
                }
            })());
        }

        await Promise.all(promises);

        return {
            items: items,
            maxPage: maxPage,
            page: page
        };
    }

    /**
     * 
     * @param {Craft} craft
     */
    async getCraftMissingComponents(craft) {
        await this.getMissingComponents(craft.requiredItems);
        return craft;
    }

    /**
     * 
     * @param {RebirthData} rebirth
     */
    async getRebirthRequiredItems(rebirth) {
        await this.getMissingComponents(rebirth.requiredItems);
        return rebirth;
    }

    /**
     * Update required items with the missing data
     * Returns the required items object
     * @param {SimpleItemData[]} requiredItems
     */
    async getMissingComponents(requiredItems) {

        if (requiredItems == null || requiredItems.length === 0) {
            return requiredItems;
        }
        let idArr = [];
        let keys = {};
        for (let i in requiredItems) {
            let item = requiredItems[i];
            let idBase = item.idBase;
            keys[idBase] = i;
            idArr.push(idBase);
            item.missing = item.number;
        }

        let resources = await this.getNumbersOfThoseItemsByIDBase(idArr);

        for (let resource of resources) {
            requiredItems[keys[resource.idBaseItem]].missing -= resource.number;
            requiredItems[keys[resource.idBaseItem]].missing = requiredItems[keys[resource.idBaseItem]].missing >= 0 ? requiredItems[keys[resource.idBaseItem]].missing : 0;
        }

        return requiredItems;
    }

    /**
     * 
     * @param {*} page 
     * @param {*} lang 
     * @param {{rarity: Number,type: Number,level: Number, power: Number}} params
     */
    async toApi(page, lang, params) {
        let res = await this.getAllItemsAtThisPage(page, params, lang);
        for (let item in res.items) {
            res.items[item] = await res.items[item].toApiLight(lang);
        }
        return res;
    }

    /**
     * Returns if inventory is empty
     */
    async isEmpty() {
        return await this.getNumberOfItem() == 0;
    }

    async getNumberOfItem(params, lang = "en") {

        let searchParamsResult = Globals.getSearchParams(params, false, true);
        let paramsResult = Utils.getParamsAndSqlMore(searchParamsResult, [this.id, lang], 2);

        let res = await conn.query(`SELECT COUNT(*) as cnt 
                                    FROM charactersinventory
                                    INNER JOIN items ON items.idItem = charactersinventory.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN itemspower ON itemspower.idItem = charactersinventory.idItem
                                    ${Utils.getLocalizationInnerJoin(lang)}
                                    WHERE idCharacter = ? ${paramsResult.more};`, paramsResult.sqlParams);
        return res[0] != null ? res[0].cnt : 0;
    }

    /**
     * To Know if this emplacement is used
     * Should be "is this Emplacement used"
     * @param {number} idEmplacement
     * @returns {Promise<boolean>}
     */
    async doIHaveThisItem(idEmplacement) {
        if (idEmplacement <= await this.getNumberOfItem() && idEmplacement > 0) {
            return true;
        }
        return false;
    }

    async doIHaveThisItemRealID(idItem) {
        if (await this.getItemOfThisIDItem(idItem) != null) {
            return true;
        }
        return false;
    }

    // craft system
    /**
     * Base ID of item
     * @param {number} idItem 
     */
    async getItemOfThisID(idBaseItem) {
        let res = await conn.query(`SELECT * 
                                    FROM charactersinventory
                                    INNER JOIN items ON items.idItem = charactersinventory.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                    INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                                    WHERE items.idBaseItem = ? AND charactersinventory.idCharacter = ?;`, [idBaseItem, this.id]);
        if (res[0] != null) {
            let item = await Item.newItem(res[0].idItem, res[0].nomSousType);
            item.number = res[0].number;
            return item;
        }
        return null;
    }

    /**
     * 
     * @param {*} idItem 
     * @param {*} number
     * ID Item is the real ID, not the id relative to inventory emplacement 
     * Number is to also check if the item number is at least the Number argument (optional)
     */
    async isThisItemInInventory(idItem, number = 1) {
        return await CharacterInventory.isThisItemInInventory(this.id, idItem, number);
    }

    static async isThisItemInInventory(idCharacter, idItem, number = 1) {
        idItem = idItem >= 0 ? idItem : 0;
        let res = await conn.query("SELECT charactersinventory.idItem FROM charactersinventory WHERE idCharacter = ? AND idItem = ? AND number >= ?;", [idCharacter, idItem, number]);
        return res[0] != null;
    }

    async getIdOfThisIdBase(idBaseItem, level = 1, rebirthLevel = 0) {
        return CharacterInventory.getIdOfThisIdBase(this.id, idBaseItem, level, rebirthLevel);
    }

    static async getIdOfThisIdBase(idCharacter, idBaseItem, level = 1, rebirthLevel = 0) {
        level = level >= 1 ? level : 1;
        let res = await conn.query(`SELECT * 
                                    FROM charactersinventory
                                    INNER JOIN items ON items.idItem = charactersinventory.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                    INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                                    WHERE items.idBaseItem = ? AND items.level = ? AND items.rebirthLevel = ? AND charactersinventory.idCharacter = ?;`, [idBaseItem, level, rebirthLevel, idCharacter]);
        if (res[0]) {
            return res[0].idItem;
        }
        return null;
    }

    async getNumbersOfThoseItemsByIDBase(listOfWantedItems) {
        return await CharacterInventory.getNumbersOfThoseItemsByIDBase(this.id, listOfWantedItems);
    }

    /**
     * Don't check level be careful
     * @param {number} idCharacter
     * @param {Array<number>} listOfWantedItems
     */
    static async getNumbersOfThoseItemsByIDBase(idCharacter, listOfWantedItems) {
        return await conn.query(`SELECT items.idBaseItem, number 
                                    FROM charactersinventory
                                    LEFT JOIN items 
                                        ON items.idItem = charactersinventory.idItem
                                    LEFT JOIN itemsbase
                                        ON itemsbase.idBaseItem = items.idBaseItem
                                    WHERE items.idBaseItem IN (?) AND charactersinventory.idCharacter = ?;`, [listOfWantedItems, idCharacter]);
    }


    /**
     * 
     * @param {*} idEmplacement 
     * @returns {Promise<Item>}
     * Instantiate the require item
     * If idEmplacement not valid 
     * Intantiate first item in inventory
     * If inventory is empty => throw err  ----> 21/02/2020 Now returns null
     */
    async getItem(idEmplacement) {
        idEmplacement = idEmplacement > 0 ? idEmplacement : 1;
        let res = await conn.query(`SELECT * 
                                    FROM charactersinventory
                                    INNER JOIN items ON items.idItem = charactersinventory.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                    INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                                    WHERE idCharacter = ?
                                    ORDER BY items.favorite DESC, items.idItem ASC, itemsbase.idRarity DESC LIMIT 1 OFFSET ?`, [this.id, idEmplacement - 1]);
        if (res[0] != null) {
            let item = await Item.newItem(res[0].idItem, res[0].nomSousType);
            item.number = res[0].number;
            return item;
        }
        return null;

    }

    // Only used by craft -> don't care about level of item take first one
    async getItemByBase(idBase) {
        idBase = idBase > 0 ? idBase : 1;
        let res = await conn.query(`SELECT *
                                    FROM charactersinventory
                                    INNER JOIN items ON items.idItem = charactersinventory.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                    INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                                    WHERE idCharacter = ? AND items.idBaseItem = ?;`, [this.id, idBase]);
        if (res[0] != null) {
            let item = await Item.newItem(res[0].idItem, res[0].nomSousType);
            item.number = res[0].number;
            return item;
        }
        return null;
    }

    /**
     * 
     * @param {number} idEmplacement 
     * @returns Returns idItem if exist else return 0
     */
    async getIdItemOfThisEmplacement(idEmplacement) {
        idEmplacement = idEmplacement > 0 ? idEmplacement : 1;
        let res = await conn.query(`SELECT * 
                                    FROM charactersinventory
                                    INNER JOIN items ON items.idItem = charactersinventory.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                    INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                                    WHERE idCharacter = ?
                                    ORDER BY items.favorite DESC, items.idItem ASC, itemsbase.idRarity DESC LIMIT 1 OFFSET ?`, [this.id, idEmplacement - 1]);
        if (res[0]) {
            return res[0].idItem;
        }
        return 0;
    }

    async getItemOfThisIDItem(idItem) {
        idItem = idItem > 0 ? idItem : 1;
        let res = await conn.query(`SELECT * 
                                    FROM charactersinventory
                                    INNER JOIN items ON items.idItem = charactersinventory.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
                                    INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                                    WHERE idCharacter = ? AND charactersinventory.idItem = ?;`, [this.id, idItem]);
        if (res[0] != null) {
            let item = await Item.newItem(res[0].idItem, res[0].nomSousType);
            item.number = res[0].number;
            return item;
        }
        return null;

    }

}

module.exports = CharacterInventory;


/**
 * @typedef {import("./CraftSystem/Craft")} Craft
 **/