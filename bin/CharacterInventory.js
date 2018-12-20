'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Item = require("./Items/Item.js");
const Consumable = require("./Items/Consumable");
const Discord = require("discord.js");
const Translator = require("./Translator/Translator");
const Stats = require("./Stats/Stats");

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
        let isEquipable = await conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? ORDER BY items.favorite DESC, items.idItem ASC, itemsbase.idRarity DESC LIMIT 1 OFFSET ?", [this.id, idEmplacement - 1]);

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
        item.number -= number;
        if (item.number <= 0) {
            await this.deleteFromInventory(item, deleteObject);
        } else {
            await conn.query("UPDATE `charactersinventory` SET `number` = number - ? WHERE `charactersinventory`.`idCharacter` = ? AND `charactersinventory`.`idItem` = ?;", [number, this.id, item.id])
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
    async deleteAllFromInventory(params) {

        let more = "";
        let sqlParams = [this.id];
        if (params != null) {
            let moreValue = null;
            if (params.rarity != null && params.rarity > 0) {
                more += "idRarity = ?";
                moreValue = params.rarity;
            } else if (params.level != null && params.level > 0) {
                more += "level = ?";
                moreValue = params.level;
            } else if (params.type != null && params.type > 0) {
                more += "idType = ?";
                moreValue = params.type;
            }

            if (moreValue != null) {
                more = "AND " + more;
                sqlParams.push(moreValue);
            }

        }

        // Only way to do
        // Multiple queries 1 query = impossible
        let res = await conn.query("SELECT charactersinventory.idItem FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem WHERE idCharacter = ? AND favorite = 0 " + more + ";", sqlParams);
        let ids = [];
        for (let i in res) {
            ids[i] = res[i].idItem;
        }

        // Delete from inventory
        await conn.query("DELETE ci FROM charactersinventory ci INNER JOIN items ON items.idItem = ci.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem WHERE idCharacter = ? AND favorite = 0 " + more + ";", sqlParams);

        // Delete items
        await Item.deleteItems(ids);
    }

    async getAllInventoryValue(params) {
        let more = "";
        let sqlParams = [this.id];
        if (params != null) {
            let moreValue = null;
            if (params.rarity != null && params.rarity > 0) {
                more += "idRarity = ?";
                moreValue = params.rarity;
            } else if (params.level != null && params.level > 0) {
                more += "level = ?";
                moreValue = params.level;
            } else if (params.type != null && params.type > 0) {
                more += "idType = ?";
                moreValue = params.type;
            }

            if (moreValue != null) {
                more = "AND " + more;
                sqlParams.push(moreValue);
            }

        }
        let value = await conn.query("SELECT COALESCE(SUM((items.level * (1+itemsbase.idRarity) * charactersinventory.number)), 0) as value FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem WHERE idCharacter = ? AND items.favorite = 0 " + more + ";", sqlParams);
        value = value[0]["value"];
        return value;
    }



    /**
     * 
     * @param {*} page 
     * @param {{rarity: Number, type: Number, level: Number}} params 
     */
    async getAllItemsAtThisPage(page, params) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 10;
        let maxPage = Math.ceil(await this.getNumberOfItem(params) / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;
        let items = {};
        let more = "";
        let offset = (page - 1) * perPage;
        let sqlParams = [this.id, perPage, offset];
        if (params != null) {
            let moreValue = null;
            if (params.rarity != null && params.rarity > 0) {
                more += "idRarity = ?";
                moreValue = params.rarity;
            } else if (params.level != null && params.level > 0) {
                more += "level = ?";
                moreValue = params.level;
            } else if (params.type != null && params.type > 0) {
                more += "idType = ?";
                moreValue = params.type;
            }

            if (moreValue != null) {
                more = "WHERE " + more;
                sqlParams.splice(1, 0, moreValue);
            }

        }

        let res = await conn.query("SELECT * FROM (SELECT *, @rn:=@rn+1 as idEmplacement FROM (select @rn:=0) row_nums, (SELECT items.idItem, itemssoustypes.idSousType, charactersinventory.number, items.level, itemsbase.idRarity, itemsbase.idType FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? ORDER BY items.favorite DESC, items.idItem ASC, itemsbase.idRarity) character_inventory) inventory_filtered " + more + " LIMIT ? OFFSET ?;", sqlParams);

        for (let i in res) {
            let item = await Item.newItem(res[i].idItem, res[i].nomSousType);
            item.number = res[i].number;
            items[res[i].idEmplacement] = item;
        }

        return {
            items: items,
            maxPage: maxPage,
            page: page
        };
    }

    /**
     * 
     * @param {*} page 
     * @param {*} lang 
     * @param {{rarity: Number,type: Number,level: Number}} params
     */
    async toApi(page, lang, params) {
        let res = await this.getAllItemsAtThisPage(page, params);
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

    async getNumberOfItem(params) {
        let sqlParams = [this.id];
        let more = "";
        if (params != null) {
            let moreValue = null;
            if (params.rarity != null && params.rarity > 0) {
                more += "idRarity = ?";
                moreValue = params.rarity;
            } else if (params.level != null && params.level > 0) {
                more += "level = ?";
                moreValue = params.level;
            } else if (params.type != null && params.type > 0) {
                more += "idType = ?";
                moreValue = params.type;
            }

            if (moreValue != null) {
                more = "AND " + more;
                sqlParams.push(moreValue);
            }

        }
        let res = await conn.query("SELECT COUNT(*) as cnt FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem WHERE idCharacter = ? " + more + ";", sqlParams);
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
        let res = await conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE items.idBaseItem = ? AND charactersinventory.idCharacter = ?;", [idBaseItem, this.id]);
        if (res[0] != null) {
            let item = await Item.newItem(res[0].idItem, res[0].nomSousType);
            item.number = res[0].number;
            return item;
        }
        return null;
    }

    async isThisItemInInventory(idItem) {
        idItem = idItem >= 0 ? idItem : 0;
        let res = await conn.query("SELECT charactersinventory.idItem FROM charactersinventory WHERE idCharacter = ? AND idItem = ?;", [this.id, idItem]);
        return res[0] != null;
    }

    static async isThisItemInInventory(idCharacter, idItem) {
        idItem = idItem >= 0 ? idItem : 0;
        let res = await conn.query("SELECT charactersinventory.idItem FROM charactersinventory WHERE idCharacter = ? AND idItem = ?;", [idCharacter, idItem]);
        return res[0] != null;
    }

    async getIdOfThisIdBase(idBaseItem, level = 1) {
        level = level >= 1 ? level : 1;
        let res = await conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE items.idBaseItem = ? AND items.level = ? AND charactersinventory.idCharacter = ?;", [idBaseItem, level, this.id]);
        if (res[0]) {
            return res[0].idItem;
        }
        return null;
    }

    static async getIdOfThisIdBase(idCharacter, idBaseItem, level = 1) {
        level = level >= 1 ? level : 1;
        let res = await conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE items.idBaseItem = ? AND items.level = ? AND charactersinventory.idCharacter = ?;", [idBaseItem, level, idCharacter]);
        if (res[0]) {
            return res[0].idItem;
        }
        return null;
    }


    // Instantiate the require item
    // If idEmplacement not valid 
    // Intantiate first item in inventory
    // If inventory is empty => throw err 
    /**
     * 
     * @param {*} idEmplacement 
     * @returns {Promise<Item>}
     */
    async getItem(idEmplacement) {
        idEmplacement = idEmplacement > 0 ? idEmplacement : 1;
        let res = await conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? ORDER BY items.favorite DESC, items.idItem ASC, itemsbase.idRarity DESC LIMIT 1 OFFSET ?", [this.id, idEmplacement - 1]);
        let item = await Item.newItem(res[0].idItem, res[0].nomSousType);
        item.number = res[0].number;
        return item;
    }

    // Only used by craft -> don't care about level of item take first one
    async getItemByBase(idBase) {
        idBase = idBase > 0 ? idBase : 1;
        let res = await conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? AND items.idBaseItem = ?;", [this.id, idBase]);
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
        let res = await conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? ORDER BY items.favorite DESC, items.idItem ASC, itemsbase.idRarity DESC LIMIT 1 OFFSET ?", [this.id, idEmplacement - 1]);
        if (res[0]) {
            return res[0].idItem;
        }
        return 0;
    }

    async getItemOfThisIDItem(idItem) {
        idItem = idItem > 0 ? idItem : 1;
        let res = await conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? AND charactersinventory.idItem = ?;", [this.id, idItem]);
        if (res[0] != null) {
            let item = await Item.newItem(res[0].idItem, res[0].nomSousType);
            item.number = res[0].number;
            return item;
        }
        return null;

    }

}

module.exports = CharacterInventory;