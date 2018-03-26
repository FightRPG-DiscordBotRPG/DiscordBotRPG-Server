'use strict';
const conn = require("../conf/mysql.js");
const ItemsStats = require("./Stats/StatsItems.js");
const Globals = require("./Globals.js");


class Item {

    constructor(id) {
        this.id = id;
        this.idBaseItem = 0;
        this.name = "";
        this.desc = "";
        this.image = "";
        this.rarity = "";
        this.rarityColor = "";
        this.idRarity = 0;
        this.level = 0;
        this.type = 0;
        this.typeName = "";
        this.equipable = true;
        this.stats = new ItemsStats(id);
        this.number = 1;

        // Functions0
        this.loadItem();

    }


    loadItem() {
        /*SELECT DISTINCT nomItem, descItem, itemsbase.idType, nomType, nomRarity, couleurRarity, level FROM items INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity WHERE items.idItem = 1;*/
        let res = conn.query("SELECT DISTINCT itemsbase.idBaseItem, nomItem, descItem, imageItem, itemsbase.idType, nomType, nomRarity, itemsbase.idRarity, couleurRarity, level, equipable FROM items INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity WHERE items.idItem = "+this.id+";")[0];
        this.idBaseItem = res["idBaseItem"];
        this.name = res["nomItem"];
        this.desc = res["descItem"] !== undefined ? res["descItem"] : "Aucune description pour cet objet.";
        this.level = res["level"];
        this.image = res["imageItem"];

        this.rarity = res["nomRarity"];
        this.rarityColor = res["couleurRarity"];
        this.idRarity = res["idRarity"];

        this.type = res["idType"];
        this.typeName = res["nomType"];

        this.equipable = res["equipable"];
        
    }

    deleteItem() {
        this.stats.deleteStats();
        conn.query("DELETE FROM items WHERE idItem = " + this.id + ";");
    }

    toStr() {
        //return this.id + "|" + this.name + " | " + this.typeName + " | Lv : " + this.level + " | " + this.rarity;

        let str = "";
        let count = 0;
        let strNum = "";

        /*
        count = 8 - this.id.toString().length;
        str += "|" + " ".repeat(Math.floor(count / 2)) + this.id + " ".repeat(Math.ceil(count / 2)) + "|";*/

        // Nom | Si + 1 item on affiche le nombre
        count = 63 - this.name.length;
        if (this.number > 1) {
            count -= (this.number.toString().length + 4);
            strNum = " [x" + this.number + "]";
        }

        str += " ".repeat(Math.floor(count / 2)) + this.name + strNum + " ".repeat(Math.ceil(count / 2)) + "|";

        //type
        count = 22 - this.typeName.length;
        str += " ".repeat(Math.floor(count / 2)) + this.typeName + " ".repeat(Math.ceil(count / 2)) + "|";

        // Niveau
        count = 8 - this.level.toString().length;
        str += " ".repeat(Math.floor(count / 2)) + this.level + " ".repeat(Math.ceil(count / 2)) + "|";

        // Rareté
        count = 14 - this.rarity.length;
        str += " ".repeat(Math.floor(count / 2)) + this.rarity + " ".repeat(Math.ceil(count / 2)) + "|";

        return str;
    }

    getCost(number) {
        return Math.round((this.level * (1 + this.idRarity * 2)) * (number <= this.number ? number : this.number));
    }

    /* 
     * API CALLS HERE
     */

    toApi() {
        let toApiObject = {
            name: this.name,
            desc: this.desc,
            rarity: this.rarity,
            rarityColor: this.rarityColor,
            level: this.level,        
            typeName: this.typeName,
            equipable: this.equipable,
            number: this.number,
            price: this.getCost(),
            image: "http://192.168.1.20:8080/" + "images/items/" + this.image + ".png",
        };
        if (this.equipable == true)
            toApiObject.stats = this.stats.toApi();

        return toApiObject;
    }


}

module.exports = Item;
