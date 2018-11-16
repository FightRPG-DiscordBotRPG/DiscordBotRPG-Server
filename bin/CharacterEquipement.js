'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Item = require("./Items/Item.js");
const Discord = require("discord.js");
const StatsEquipment = require("./Stats/StatsEquipment");
const Translator = require("./Translator/Translator");

class CharacterEquipement {
    // Discord User Info
    constructor(id) {
        this.id = id;
        this.objects = {};
        this.stats = new StatsEquipment();
    }

    // Load equipement from DB

    loadEquipements(id) {
        this.id = id;
        this.stats.id = id;
        this.stats.update();
    }

    seeThisItem(type, lang) {
        let embed;
        let item = this.getItem(type);
        if (item) {
            embed = new Discord.RichEmbed()
                .setAuthor(item.getName(lang) + (item.isFavorite == true ? " ★" : ""), Globals.addr + "images/items/" + item.image + ".png")
                .setColor(item.rarityColor)
                .addField(Translator.getString(lang, "item_types", item.typeName) + " (" + Translator.getString(lang, "item_sous_types", item.sousTypeName) + ")" + " | " + Translator.getString(lang, "rarities", item.rarity) + " | " + Translator.getString(lang, "general", "lvl") + " : " + item.level + " | " + Translator.getString(lang, "inventory_equipment", "power") + " : " + item.getPower() + "%" + " (" + Translator.getString(lang, "inventory_equipment", "currently_equipped") + ")", item.getDesc(lang))
                .addField(Translator.getString(lang, "inventory_equipment", "attributes") + " : ", item.stats.toStr({}, lang));
        } else {
            embed = "``` " + Translator.getString(lang, "inventory_equipment", "nothing_in_this_slot") + " ```";
        }


        return embed;
    }

    getPower() {
        let avgPower = 0;
        let items = this.getAllItems();
        for (let i in items) {
            avgPower += items[i].getPower();
        }
        return Math.floor(avgPower / Globals.equipsPossible.length);
    }

    // -1 Pas Swap
    // Sinon return id item à swap
    equip(idItem) {
        let item = new Item(idItem);
        if (!this.isSlotFree(item.getEquipTypeID())) {
            //console.log("Equip And Swap");
            let equipedItem = this.getItem(item.getEquipTypeID());
            if (equipedItem.id !== idItem) {
                let toReturn = equipedItem.id;
                conn.query("UPDATE charactersequipements SET idItem = ? WHERE idCharacter = ? AND idType = ?;", [idItem, this.id, item.getEquipTypeID()])
                // return id object
                this.stats.update();
                return toReturn;
            }
        } else {
            //console.log("Equip Only");
            conn.query("INSERT INTO charactersequipements VALUES(?, ?, ?);", [this.id, idItem, item.getEquipTypeID()]);
            this.stats.update();
            return -1;
        }

    }

    unEquip(type) {
        if (!this.isSlotFree(type)) {
            let idItem = this.getItem(type).id;
            conn.query("DELETE FROM charactersequipements WHERE idCharacter = ? AND idType = ?;", [this.id, type]);
            this.stats.update();
            return idItem;
        }
        return -1;
    }

    toStr(lang) {
        let str = "";
        str += Translator.getString(lang, "inventory_equipment", "name") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "type") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "level") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "rarity") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "power") + "\n\n";
        let empty = true;

        let items = this.getAllItems();
        for (let i in items) {
            str += items[i].toStr(lang) + "\n";
            empty = false;
        }
        if (empty) {
            str += Translator.getString(lang, "inventory_equipment", "nothing_equipped");
        }

        return str;
    }

    getAllItems() {
        let res = conn.query("SELECT itemstypes.nomType, charactersequipements.idItem FROM charactersequipements INNER JOIN itemstypes ON itemstypes.idType = charactersequipements.idType WHERE charactersequipements.idCharacter = ?;", [this.id]);
        let items = [];
        for (let i in res) {
            items[i] = Item.newItem(res[i].idItem, res[i].nomType);
        }
        return items;
    }

    toApi(lang) {
        let res = this.getAllItems();
        for (let i in res) {
            res[i] = res[i].toApiLight(lang);
        }
        return res;
    }

    isSlotFree(idEmplacement) {
        let res = conn.query("SELECT * FROM charactersequipements WHERE idCharacter = ? AND idType = ?;", [this.id, idEmplacement]);
        return res[0] == null;
    }

    getItem(idEmplacement) {
        let res = conn.query("SELECT itemstypes.nomType, charactersequipements.idItem FROM charactersequipements INNER JOIN itemstypes ON itemstypes.idType = charactersequipements.idType WHERE charactersequipements.idCharacter = ? AND itemstypes.idType = ?;", [this.id, idEmplacement]);
        if (res[0]) {
            return Item.newItem(res[0].idItem, res[0].nomType);
        }
        return null;
    }

    getStat(statName) {
        return this.stats.getStat(statName);
    }

    apiGetItem(type) {
        if (this.objects[type]) {
            return this.objects[type].toApi();
        }
        return null;
    }

    apiGetAllImages() {
        let toReturn = {
            head: "",
            chest: "",
            legs: "",
            weapon: ""
        };

        for (let i in this.objects) {
            toReturn[this.objects[i].typeName] = Globals.addr + "images/items/" + this.objects[i].image + ".png";
        }

        return toReturn;
    }

    updateStats() {
        this.stats.update();
    }

}

module.exports = CharacterEquipement;