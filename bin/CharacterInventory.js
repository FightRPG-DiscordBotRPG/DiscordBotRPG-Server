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
    loadInventory(id) {
        this.id = id;
    }

    isEquipable(idEmplacement) {
        idEmplacement = idEmplacement > 0 ? idEmplacement : 1;
        let isEquipable = conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? ORDER BY items.favorite DESC LIMIT 1 OFFSET ?", [this.id, idEmplacement-1]);

        if(isEquipable[0]) {
            return isEquipable[0].equipable == 1;
        }
        return false;
    }

    addToInventory(idItem, number) {
        number = number > 0 ? number : 1;
        if(this.isThisItemInInventory(idItem)) {
            conn.query("UPDATE charactersinventory SET number = number + ? WHERE idCharacter = ? AND idItem = ?;", [number, this.id, idItem]);
        } else {
            conn.query("INSERT INTO charactersinventory VALUES (?, ?, ?);", [this.id, idItem, number]);
        }
    }

    /*
    modInventory(idItem, number) {
        number = number ? number : 1;
        this.objects[idItem].number = number;
        conn.query("UPDATE charactersinventory SET number = " + number + " WHERE idCharacter = " + this.id + " AND idItem = " + idItem);
    }*/

    removeSomeFromInventoryIdBase(idBase, number, deleteObject) {
        number = number ? number : 1;
        let item = this.getItemByBase(idBase);
        if(item != null) {
            item.number -= number;
            if (item.number <= 0) {
                this.deleteFromInventory(item, deleteObject);
            } else {
                conn.query("UPDATE `charactersinventory` SET `number` = number - ? WHERE `charactersinventory`.`idCharacter` = ? AND `charactersinventory`.`idItem` = ?;", [number, this.id, item.id])
            }
        }
    }

    /**
     * Remove from inventory item | idEmplacement needs to be in the array
     * @param {any} idEmplacement
     * @param {any} number
     * @param {any} deleteObject
     */
    removeSomeFromInventory(idEmplacement, number, deleteObject) {
        number = number ? number : 1;
        let item = this.getItem(idEmplacement);
        item.number -= number;
        if (item.number <= 0) {
            this.deleteFromInventory(item, deleteObject);
        } else {
            conn.query("UPDATE `charactersinventory` SET `number` = number - ? WHERE `charactersinventory`.`idCharacter` = ? AND `charactersinventory`.`idItem` = ?;", [number, this.id, item.id])
        }
    }

    /**
     * Remove item from database character inventory and if demand remove it from the game
     * @param {Item} item
     * @param {boolean} deleteObject
     */
    deleteFromInventory(item, deleteObject) {
        conn.query("DELETE FROM charactersinventory WHERE idCharacter = ? AND idItem = ?", [this.id, item.id]);
        if (deleteObject) {
            Item.deleteItem(item.id);
        }
    }

    /**
     * Delete all objects from inventory
     */
    deleteAllFromInventory() {

        // Only way to do
        // Multiple queries 1 query = impossible
        let res = conn.query("SELECT charactersinventory.idItem FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem WHERE idCharacter = 1 AND favorite = 0");
        let ids = [];
        for(let i in res) {
            ids[i] = res[i].idItem;
        }

        // Delete from inventory
        conn.query("DELETE ci FROM charactersinventory ci INNER JOIN items ON items.idItem = ci.idItem WHERE idCharacter = ? AND favorite = 0", [this.id]);

        // Delete items
        Item.deleteItems(ids);
    }

    getAllInventoryValue() {
        let value = conn.query("SELECT COALESCE(SUM((items.level * (1+ itemsbase.idRarity * 2) * charactersinventory.number)), 0) as value FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem WHERE idCharacter = ? AND items.favorite = 0", [this.id])[0]["value"];
        return value;
    }

    getAllItemsAtThisPage(page) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 10;
        let maxPage = Math.ceil(this.getNumberOfItem() / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;
        let items = [];

        let res = conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? ORDER BY items.favorite DESC LIMIT ? OFFSET ?;", [this.id, perPage, (page - 1) * perPage]);

        for(let i in res) {
            let item = Item.newItem(res[i].idItem, res[i].nomType);
            item.number = res[i].number;
            items[i] = item;
        }

        return { items: items, maxPage: maxPage, page: page };
    }

    /**
     * 
     * @param {number} page 
     * @param {string} lang 
     */
    toStr(page, lang) {
        let str = "```";
        //str += "|   nb   |" + "                             Nom                               |" + "         Type         |" + " Niveau |" + "    Rareté    |\n";
        str += Translator.getString(lang, "inventory_equipment", "id") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "name") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "type") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "level") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "rarity") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "power") + "\n\n";

        let res = this.getAllItemsAtThisPage(page);
        let index = (res.page - 1) * 10 + 1;
        if(res.items.length > 0) {
            for(let item of res.items) {
                str += index + " - " + item.toStr(lang) + "\n";
                index++;
            }
        } else {
            str += Translator.getString(lang, "inventory_equipment", "empty_inventory");
        }

        str += "\n\n" + Translator.getString(lang, "inventory_equipment", "page_x_out_of", [res.page, res.maxPage])
        str += "```"
        return str;
    }

    /**
     * 
     * @param {number} idEmplacement 
     * @param {Stats} compareStats 
     * @param {string} lang 
     */
    seeThisItem(idEmplacement, compareStats, lang) {
        let item = this.getItem(idEmplacement);
        let embed = new Discord.RichEmbed()
            .setAuthor(item.getName(lang) + (item.isFavorite == true ? " ★" : ""), Globals.addr + "images/items/" + item.image + ".png")
            .setColor(item.rarityColor)
            .addField(Translator.getString(lang, "item_types", item.typeName) + " (" + Translator.getString(lang, "item_sous_types", item.sousTypeName) + ")" + " | " + Translator.getString(lang, "rarities", item.rarity) + " | " + Translator.getString(lang, "general", "lvl") + " : " + item.level + " | " + Translator.getString(lang, "inventory_equipment", "power") + " : " + item.getPower() + "%"
            , item.getDesc(lang))
            .addField(Translator.getString(lang, "inventory_equipment", "attributes") + " : ", item.stats.toStr(compareStats, lang));
        
        return embed;
    }

    /**
     * Returns if inventory is empty
     */
    isEmpty() {
        return this.getNumberOfItem() == 0;
    }

    getNumberOfItem() {
        let res = conn.query("SELECT COUNT(*) as cnt FROM charactersinventory WHERE idCharacter = ?;", [this.id]);
        return res[0].cnt;
    }

    /**
     * To Know if this emplacement is used
     * Should be "is this Emplacement used"
     * @param {number} idEmplacement
     * @returns {boolean}
     */
    doIHaveThisItem(idEmplacement) {
        if(idEmplacement <= this.getNumberOfItem() && idEmplacement > 0) {
            return true;
        }
        return false;
    }

    // craft system
    /**
     * Base ID of item
     * @param {number} idItem 
     */
    getItemOfThisID(idBaseItem) {
        let res = conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE items.idBaseItem = ? AND charactersinventory.idCharacter = ?;", [idBaseItem, this.id]);
        if(res[0] != null) {
            let item = Item.newItem(res[0].idItem, res[0].nomType);
            item.number = res[0].number;
            return item;
        }
        return null;
    }

    // craft system
    /**
     * @deprecated
     * @param {Array<number>} ArrItemsIDs 
     */
    getItemsOfThosesIds(ArrItemsIDs) {
        let arr = [];
        for(let i in this.objects) {
            if(ArrItemsIDs.indexOf(this.objects[i].idBaseItem) > -1) {
                arr.push({item:this.objects[i], index:i});
            }
        }
        return arr;
    }

    isThisItemInInventory(idItem) {
        idItem = idItem >= 0 ? idItem : 0;
        let res = conn.query("SELECT charactersinventory.idItem FROM charactersinventory WHERE idCharacter = ? AND idItem = ?;", [this.id, idItem]);
        return res[0] != null;
    }

    
    /**
     * @deprecated
     * @param {number} idBase 
     */
    getEmplacementOfThisItemIdBase(idBase) {
        for(let i in this.objects) {
            if(this.objects[i].idBaseItem == idBase) {
                return i;
            }
        }
        return -1;
    }

    getIdOfThisIdBase(idBaseItem) {
        let res = conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE items.idBaseItem = ? AND charactersinventory.idCharacter = ?;", [idBaseItem, this.id]);
        if(res[0]) {
            return res[0].idItem;
        }
        return null;
    }

    
    // Instantiate the require item
    // If idEmplacement not valid 
    // Intantiate first item in inventory
    // If inventory is empty => throw err 
    getItem(idEmplacement) {
        idEmplacement = idEmplacement > 0 ? idEmplacement : 1;
        let res = conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? ORDER BY items.favorite DESC LIMIT 1 OFFSET ?", [this.id, idEmplacement-1]);
        let item = Item.newItem(res[0].idItem, res[0].nomType);
        item.number = res[0].number;
        return item;
    }

    getItemByBase(idBase) {
        idBase = idBase > 0 ? idBase : 1;
        let res = conn.query("SELECT items.idItem, charactersinventory.number, itemstypes.nomType FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? AND items.idBaseItem = ?;", [this.id, idBase]);
        if(res[0] != null) {
            let item = Item.newItem(res[0].idItem, res[0].nomType);
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
    getIdItemOfThisEmplacement(idEmplacement) {
        idEmplacement = idEmplacement > 0 ? idEmplacement : 1;
        let res = conn.query("SELECT * FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ? ORDER BY items.favorite DESC LIMIT 1 OFFSET ?", [this.id, idEmplacement-1]);
        if(res[0]) {
            return res[0].idItem;
        }
        return 0;
    }

    /*
     *      API CALLS
    */
    apiGetInv(page) {
        page = page ? page - 1 : 0;
        let keys = Object.keys(this.objects);
        let apiReturn = {
            nbrPages: 0, inv: {}};
        if (keys.length > 0) {
            // Doing pagination
            let paginated = keys.slice(page * 8, (page + 1) * 8);
            if (paginated.length === 0) {
                page = 0;
                paginated = keys.slice(page * 8, (page + 1) * 8)
            }

            // Create string for each objects
            for (let i of paginated) {
                apiReturn.inv[i] = this.objects[i].toApiLight();
                    /*{
                        name: this.objects[i].name,
                        desc: this.objects[i].desc,
                        image: "http://192.168.1.20:8080/" + "images/items/" + this.objects[i].image + ".png",
                        rarity: this.objects[i].rarity,
                        rarityColor: this.objects[i].rarityColor,
                        level: this.objects[i].level,
                        typeName: this.objects[i].typeName,
                        equipable: this.objects[i].equipable === 1 ? true : false,
                        number: this.objects[i].number,
                    };*/
            }
        }
        let nbrOfPages = keys.length > 0 ? Math.ceil(keys.length / 8) : 1;
        apiReturn.nbrPages = nbrOfPages;
        return apiReturn;
    }

    apiGetItem(id) {
        return this.objects[id].toApi();
    }

}

module.exports = CharacterInventory;
