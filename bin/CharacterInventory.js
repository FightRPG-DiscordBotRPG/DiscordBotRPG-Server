'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Item = require("./Item.js");
const Discord = require("discord.js");

class CharacterInventory {
    // Discord User Info
    constructor(id) {
        this.id = id;
        this.objects = {};
    }

    // Load user from DB
    // If not exist create new one
    loadInventory(id) {
        this.id = id;
        let res = conn.query("SELECT idItem, number FROM charactersinventory WHERE idCharacter = " + this.id);
        for (let i = 0; i < res.length; i++) {
            this.objects[res[i]["idItem"]] = new Item(res[i]["idItem"]);
            this.objects[res[i]["idItem"]].number = res[i]["number"];
            // push
        }
    }

    isEquipable(idItem) {
        if (this.objects[idItem].equipable == true) {
            return true;
        }
        return false;
    }

    addToInventory(idItem, number) {
        number = number ? number : 1;
        if (this.objects[idItem]) {
            this.objects[idItem].number += number;
            conn.query("UPDATE charactersinventory SET number = " + this.objects[idItem].number + " WHERE idCharacter = " + this.id + " AND idItem = " + idItem);
        } else {
            this.objects[idItem] = new Item(idItem);
            this.objects[idItem].number = number;
            conn.query("INSERT INTO charactersinventory VALUES (" + this.id + "," + idItem + ", " + number + ")");
        }
    }

    modInventory(idItem, number) {
        number = number ? number : 1;
        this.objects[idItem].number = number;
        conn.query("UPDATE charactersinventory SET number = " + number + " WHERE idCharacter = " + this.id + " AND idItem = " + idItem);
    }

    removeSomeFromInventory(idItem, number, deleteObject) {
        number = number ? number : 1;
        this.objects[idItem].number -= number;
        if (this.objects[idItem].number <= 0) {
            this.deleteFromInventory(idItem, deleteObject);
        }
    }

    deleteFromInventory(idItem, deleteObject) {
        conn.query("DELETE FROM charactersinventory WHERE idCharacter = " + this.id + " AND idItem = " + idItem);
        if (deleteObject) {
            this.objects[idItem].deleteItem();
        }
        delete this.objects[idItem];
    }

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
        str += "|   id   |" + "                             Nom                               |" + "         Type         |" + " Niveau |" + "    Rareté    |\n";
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

    seeThisItem(idItem) {
        let embed = new Discord.RichEmbed()
            .setColor(this.objects[idItem].rarityColor)
            .addField(this.objects[idItem].name + " | " + this.objects[idItem].typeName + " | " + this.objects[idItem].rarity + " | Lv : " + this.objects[idItem].level, this.objects[idItem].desc)
            .addField("Attributes : ", this.objects[idItem].stats.toStr())
        return embed;
    }

    doIHaveThisItem(itemId) {
        if (this.objects[itemId]) {
            return true;
        }
        return false;
    }

    getIdOfThisIdBase(idBaseItem) {
        for (let i in this.objects) {
            //console.log("This " + this.objects[i].idBaseItem + " vs " + idBaseItem)
            if (this.objects[i].idBaseItem == idBaseItem) {
                return this.objects[i].id;
            }
        }
        return null;
    }


}

module.exports = CharacterInventory;
