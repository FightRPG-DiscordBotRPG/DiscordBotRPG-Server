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
        //this.objects = {};
        /**
         * @type {Array<Item>}
         */
        this.objects = [];
    }

    // Load user from DB
    // If not exist create new one
    loadInventory(id) {
        this.id = id;
        let res = conn.query("SELECT charactersinventory.idItem, number, itemstypes.nomType FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idCharacter = ?", [this.id]);
        for (let i = 0; i < res.length; i++) {
            this.objects.push(Item.newItem(res[i]["idItem"], res[i]["nomType"]));  
            this.objects[i].number = res[i]["number"];
            // push
        }
    }

    isEquipable(idEmplacement) {
        if (this.objects[idEmplacement].isEquipable()) {
            return true;
        }
        return false;
    }

    getItem(idEmplacement) {
        return this.objects[idEmplacement];
    }

    addToInventory(idItem, number) {
        number = number ? number : 1;
        let idEmplacement = this.getIdEmplacementOfItem(idItem);
        if (idEmplacement >= 0) {
            this.objects[idEmplacement].number += number;
            conn.query("UPDATE charactersinventory SET number = " + this.objects[idEmplacement].number + " WHERE idCharacter = " + this.id + " AND idItem = " + idItem);
        } else {
            let nItem = Item.newItem(idItem, Item.getType(idItem));
            nItem.number = number;
            this.objects.push(nItem);
            conn.query("INSERT INTO charactersinventory VALUES (" + this.id + "," + idItem + ", " + number + ")");
        }
    }

    /*
    modInventory(idItem, number) {
        number = number ? number : 1;
        this.objects[idItem].number = number;
        conn.query("UPDATE charactersinventory SET number = " + number + " WHERE idCharacter = " + this.id + " AND idItem = " + idItem);
    }*/

    /**
     * Remove from inventory item | idEmplacement needs to be in the array
     * @param {any} idEmplacement
     * @param {any} number
     * @param {any} deleteObject
     */
    removeSomeFromInventory(idEmplacement, number, deleteObject) {
        number = number ? number : 1;
        this.objects[idEmplacement].number -= number;
        if (this.objects[idEmplacement].number <= 0) {
            this.deleteFromInventory(idEmplacement, deleteObject);
        } else {
            conn.query("UPDATE `charactersinventory` SET `number` = number - ? WHERE `charactersinventory`.`idCharacter` = ? AND `charactersinventory`.`idItem` = ?;", [number, this.id, this.objects[idEmplacement].id])
        }
    }

    /**
     * Remove item from database character inventory and if demand remove it from the game
     * @param {any} idItem
     * @param {any} deleteObject
     */
    deleteFromInventory(idEmplacement, deleteObject) {
        conn.query("DELETE FROM charactersinventory WHERE idCharacter = " + this.id + " AND idItem = " + this.objects[idEmplacement].id);
        if (deleteObject) {
            this.objects[idEmplacement].deleteItem();
        }
        delete this.objects[idEmplacement];
        this.reorderInventory();
    }

    reorderInventory() {
        this.objects = this.objects.filter(val => val);
    }

    /**
     * Delete all objects from inventory
     */
    deleteAllFromInventory() {
        let empty = true;

        // Update database inventory
        conn.query("DELETE ci FROM charactersinventory ci INNER JOIN items ON items.idItem = ci.idItem WHERE idCharacter = ? AND favorite = 0", [this.id]);

        // Then delete all items
        for (let i in this.objects) {
            //conn.query("DELETE FROM charactersinventory WHERE idCharacter = " + this.id + " AND idItem = " + this.objects[i].id);
            if(!this.objects[i].isFavorite) {
                this.objects[i].deleteItem();
                delete this.objects[i];
    
                empty = false;
            }

        }

        this.reorderInventory();
        if (empty) {
            return false;
        } else {
            return true;
        }
    }

    getAllInventoryValue() {
        let value = 0;
        for (let i in this.objects) {
            if(!this.objects[i].isFavorite) {
                value += this.objects[i].getCost();
            }
        }
        return value;
    }

    /**
     * 
     * @param {number} page 
     * @param {string} lang 
     */
    toStr(page, lang) {
        page = page ? page - 1 : 0;
        let str = "```";
        //str += "|   nb   |" + "                             Nom                               |" + "         Type         |" + " Niveau |" + "    Rareté    |\n";
        str += Translator.getString(lang, "inventory_equipment", "id") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "name") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "type") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "level") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "rarity") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "power") + "\n\n";

        let keys = Object.keys(this.objects);
        if (keys.length > 0) {
            // Doing pagination
            let paginated = keys.slice(page * 8, (page + 1) * 8);
            if (paginated.length === 0) {
                page = 0;
                paginated = keys.slice(page * 8, (page + 1) * 8)
            }

            // Create string for each objects
            for (let i of paginated) {
                /*str += "|" + " ".repeat(Math.floor((8 - i.toString().length) / 2)) + i + " ".repeat(Math.ceil((8 - i.toString().length) / 2)) + "|";
                str += this.objects[i].toStr() + "\n";*/
                str += i + " - " + this.objects[i].toStr(lang) + "\n";
            }
        } else {
            /*str += "|                                                                                                                       |\n";
            str += "|                                              Votre inventaire est vide !                                              |\n";
            str += "|_______________________________________________________________________________________________________________________|";*/
            str += Translator.getString(lang, "inventory_equipment", "empty_inventory");
        }
        let nbrOfPages = keys.length > 0 ? Math.ceil(keys.length / 8) : 1;
        //str += "\n\nPage " + (page + 1) + "/" + nbrOfPages;
        str += "\n\n" + Translator.getString(lang, "inventory_equipment", "page_x_out_of", [(page + 1), nbrOfPages])
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
        let embed = new Discord.RichEmbed()
            .setAuthor(this.objects[idEmplacement].getName(lang) + (this.objects[idEmplacement].isFavorite == true ? " ★" : ""), Globals.addr + "images/items/" + this.objects[idEmplacement].image + ".png")
            .setColor(this.objects[idEmplacement].rarityColor)
            .addField(Translator.getString(lang, "item_types", this.objects[idEmplacement].typeName) + " (" + Translator.getString(lang, "item_sous_types", this.objects[idEmplacement].sousTypeName) + ")" + " | " + Translator.getString(lang, "rarities", this.objects[idEmplacement].rarity) + " | " + Translator.getString(lang, "general", "lvl") + " : " + this.objects[idEmplacement].level + " | " + Translator.getString(lang, "inventory_equipment", "power") + " : " + this.objects[idEmplacement].getPower() + "%"
            , this.objects[idEmplacement].getDesc(lang))
            .addField(Translator.getString(lang, "inventory_equipment", "attributes") + " : ", this.objects[idEmplacement].stats.toStr(compareStats, lang));
        
        return embed;
    }

    /**
     * To Know if this emplacement is used
     * @param {number} itemId
     * @returns {boolean}
     */
    doIHaveThisItem(itemId) {
        /*for (let i in this.objects) {
            if (this.objects[i].id === itemId) {
                return true;
            }
        }
        return false;
        console.log(itemId);*/
        if (this.objects[itemId]) {
            return true;
        }
        return false;
    }

    // craft system
    getItemOfThisID(itemId) {
        for(let item of this.objects) {
            if(item.idBaseItem == itemId) {
                return item;
            }
        }
        return null;
    }

    // craft system
    getItemsOfThosesIds(ArrItemsIDs) {
        let arr = [];
        for(let i in this.objects) {
            if(ArrItemsIDs.indexOf(this.objects[i].idBaseItem) > -1) {
                arr.push({item:this.objects[i], index:i});
            }
        }
        return arr;
    }

    getIdEmplacementOfItem(itemId) {
        for (let i in this.objects) {
            if (this.objects[i].id === itemId) {
                return i;
            }
        }
        return -1;
    }

    getEmplacementOfThisItemIdBase(idBase) {
        for(let i in this.objects) {
            if(this.objects[i].idBaseItem == idBase) {
                return i;
            }
        }
        return -1;
    }

    getIdOfThisIdBase(idBaseItem) {
        /*let item = conn.query("SELECT charactersinventory.idItem FROM charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem WHERE items.idBaseItem = ? AND charactersinventory.idCharacter = ?;" , [idBaseItem, this.id]);
        if(item[0] != null) {
            return item[0].idItem;
        }
        return null;*/

        for (let i in this.objects) {
            if (this.objects[i].idBaseItem === idBaseItem) {
                return this.objects[i].id;
            }
        }
        return null;
    }

    getIdItemOfThisEmplacement(idEmplacement) {
        return this.objects[idEmplacement] ? this.objects[idEmplacement].id : -1;
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
