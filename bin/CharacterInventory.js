'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Item = require("./Item.js");
const Discord = require("discord.js");

class CharacterInventory {
    // Discord User Info
    constructor(id) {
        this.id = id;
        //this.objects = {};
        this.objects = [];
    }

    // Load user from DB
    // If not exist create new one
    loadInventory(id) {
        this.id = id;
        let res = conn.query("SELECT idItem, number FROM charactersinventory WHERE idCharacter = " + this.id);
        for (let i = 0; i < res.length; i++) {
            /*this.objects[res[i]["idItem"]] = new Item(res[i]["idItem"]);
            this.objects[res[i]["idItem"]].number = res[i]["number"];*/
            this.objects.push(new Item(res[i]["idItem"]));
            this.objects[i].number = res[i]["number"];
            // push
        }
    }

    isEquipable(idEmplacement) {
        if (this.objects[idEmplacement].equipable == true) {
            return true;
        }
        return false;
    }

    addToInventory(idItem, number) {
        number = number ? number : 1;
        let idEmplacement = this.getIdEmplacementOfItem(idItem);
        if (idEmplacement >= 0) {
            this.objects[idEmplacement].number += number;
            conn.query("UPDATE charactersinventory SET number = " + this.objects[idEmplacement].number + " WHERE idCharacter = " + this.id + " AND idItem = " + idItem);
        } else {
            let nItem = new Item(idItem);
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
        this.objects = this.objects.filter(val => val);
    }

    /**
     * Delete all objects from inventory
     */
    deleteAllFromInventory() {
        let empty = true;
        for (let i in this.objects) {
            conn.query("DELETE FROM charactersinventory WHERE idCharacter = " + this.id + " AND idItem = " + this.objects[i].id);
            this.objects[i].deleteItem();
            delete this.objects[i];
            empty = false;
        }

        if (empty) {
            return false;
        } else {
            return true;
        }
    }

    getAllInventoryValue() {
        let value = 0;
        for (let i in this.objects) {
            value += this.objects[i].getCost();
        }
        return value;
    }

    // Affichage
    toStr(page) {
        page = page ? page - 1 : 0;
        let str = "```";
        str += "|   nb   |" + "                             Nom                               |" + "         Type         |" + " Niveau |" + "    Rareté    |\n";
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
                str += "|" + " ".repeat(Math.floor((8 - i.toString().length) / 2)) + i + " ".repeat(Math.ceil((8 - i.toString().length) / 2)) + "|";
                str += this.objects[i].toStr() + "\n";
            }
        } else {
            str += "|                                                                                                                 |\n";
            str += "|                                           Votre inventaire est vide !                                           |\n";
            str += "|_________________________________________________________________________________________________________________|";
        }
        let nbrOfPages = keys.length > 0 ? Math.ceil(keys.length / 8) : "1";
        str += "\n\nPage " + (page + 1) + "/" + nbrOfPages;
        str += "```"
        return str;
    }

    /**
     * Send string to show - supposing idEmplacement valid
     * @param {any} idEmplacement
     */
    seeThisItem(idEmplacement) {
        let embed = new Discord.RichEmbed()
            .setColor(this.objects[idEmplacement].rarityColor)
            .addField(this.objects[idEmplacement].name + " | " + this.objects[idEmplacement].typeName + " | " + this.objects[idEmplacement].rarity + " | Lv : " + this.objects[idEmplacement].level, this.objects[idEmplacement].desc)
            .addField("Attributes : ", this.objects[idEmplacement].stats.toStr())
        return embed;
    }

    /**
     * To Know if this emplacement is used
     * @param {any} itemId
     */
    doIHaveThisItem(itemId) {
        /*for (let i in this.objects) {
            if (this.objects[i].id === itemId) {
                return true;
            }
        }
        return false;*/
        console.log(itemId);
        if (this.objects[itemId]) {
            return true;
        }
        return false;
    }

    getIdEmplacementOfItem(itemId) {
        for (let i in this.objects) {
            if (this.objects[i].id === itemId) {
                return i;
            }
        }
        return -1;
    }

    getIdOfThisIdBase(idBaseItem) {
        for (let i in this.objects) {
            //console.log("This " + this.objects[i].idBaseItem + " vs " + idBaseItem)
            if (this.objects[i].idBaseItem === idBaseItem) {
                return this.objects[i].id;
            }
        }
        return null;
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
                apiReturn.inv[i] = this.objects[i];
            }
        }
        let nbrOfPages = keys.length > 0 ? Math.ceil(keys.length / 8) : "1";
        apiReturn.nbrPages = nbrOfPages;
        apiReturn.page = page + 1;
        return apiReturn;
    }

    apiGetItem(id) {
        return this.objects[id];
    }

}

module.exports = CharacterInventory;
