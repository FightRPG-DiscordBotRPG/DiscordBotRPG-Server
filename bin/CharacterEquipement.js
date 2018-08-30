'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Item = require("./Items/Item.js");
const Discord = require("discord.js");
const Stats = require("./Stats/Stats.js");
const Translator = require("./Translator/Translator");

class CharacterEquipement {
    // Discord User Info
    constructor(id) {
        this.id = id;
        this.objects = {};
        this.stats = new Stats();
    }

    // Load equipement from DB

    loadEquipements(id) {
        this.id = id;
        let res = conn.query("SELECT idItem, idType FROM charactersequipements WHERE idCharacter = " + this.id + ";");
        for (let i = 0; i < res.length; i++) {
            this.objects[res[i]["idType"]] = new Item(res[i]["idItem"]);
        }
        this.loadStats();
    }

    doIHaveThisItem(itemId) {
        for (let i in this.objects) {
            if (this.objects[i].id === itemId) {
                return this.objects[i].type;
            }
        }
        return -1;
    }

    seeThisItem(type, lang) {
        let embed;
        if (this.objects[type]) {
            embed = new Discord.RichEmbed()
                .setAuthor(this.objects[type].getName(lang) + (this.objects[type].isFavorite == true ? " ★" : ""), Globals.addr + "images/items/" + this.objects[type].image + ".png")
                .setColor(this.objects[type].rarityColor)
                .addField(Translator.getString(lang, "item_types", this.objects[type].typeName) + " (" + Translator.getString(lang, "item_sous_types", this.objects[type].sousTypeName) + ")" + " | " + Translator.getString(lang, "rarities", this.objects[type].rarity) + " | " + Translator.getString(lang, "general", "lvl") + " : " + this.objects[type].level + " | " + Translator.getString(lang, "inventory_equipment", "power") + " : " + this.objects[type].getPower() + "%" + " (" + Translator.getString(lang, "inventory_equipment", "currently_equipped") + ")"
                , this.objects[type].getDesc(lang))
                .addField(Translator.getString(lang, "inventory_equipment", "attributes") + " : ", this.objects[type].stats.toStr({}, lang));
        } else {
            embed = "``` " + Translator.getString(lang, "inventory_equipment", "nothing_in_this_slot") + " ```";
        }


        return embed;
    }

    // A faire lors du chargement de la bdd
    loadStats() {
        // Pour chaque objets
        for (let i in this.objects) {
            // Pour chaque stats
            for (let j in Globals.statsIds) {
                // J'ajoute les stats dans ma tabel de stats
                this.stats[j] += this.objects[i].stats[j];
            }
        }


    }

    getPower() {
        let avgPower = 0;
        for (let i in this.objects) {
            avgPower += this.objects[i].getPower();
        }
        return Math.round(avgPower / Globals.equipsPossible.length);
    }

    // -1 Pas Swap
    // Sinon return id item à swap
    equip(idItem) {
        let item = new Item(idItem);
        if (this.objects[item.getEquipTypeID()]) {
            //console.log("Equip And Swap");
            if (this.objects[item.getEquipTypeID()].id !== idItem) {
                let toReturn = this.objects[item.getEquipTypeID()].id;

                // On enlève les stats de l'objet
                this.removeStats(item.getEquipTypeID());
                // On remplace l'objet
                this.objects[item.getEquipTypeID()] = item;
                conn.query("UPDATE charactersequipements SET idItem = ? WHERE idCharacter = ? AND idType = ?;", [idItem, this.id, item.getEquipTypeID()])
                this.addStats(item.getEquipTypeID());
                // return id object
                return toReturn;
            }
        } else {
            //console.log("Equip Only");
            this.objects[item.getEquipTypeID()] = item;
            conn.query("INSERT INTO charactersequipements VALUES(?, ?, ?);", [this.id, idItem, item.getEquipTypeID()]);
            // Une fois tout fait on peut add les stats
            this.addStats(item.getEquipTypeID());
            return -1;
        }

    }

    unEquip(type) {
        if (this.objects[type]) {
            let idItem = this.objects[type].id;
            conn.query("DELETE FROM charactersequipements WHERE idCharacter = ? AND idType = ?;");
            this.removeStats(type);
            delete this.objects[type];
            return idItem;
        }
        return -1;
    }

    removeStats(typeId) {
        for (let i in this.objects[typeId].stats) {
            // Si c'est bien une stat
            if (i !== "id") {
                //console.log(this.stats[i] + " - " + this.objects[typeId].stats[i]);
                this.stats[i] -= this.objects[typeId].stats[i];
            }

        }
    }

    addStats(typeId) {
        //console.log(typeId);
        for (let i in this.objects[typeId].stats) {
            // Si c'est bien une stat
            //console.log(i);
            if (i !== "id") {
                //console.log(this.stats[i] + this.objects[typeId].stats[i]);
                this.stats[i] += this.objects[typeId].stats[i];
            }

        }
    }

    toStr(lang) {
        let str = "";
        str += Translator.getString(lang, "inventory_equipment", "name") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "type") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "level") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "rarity") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "power") + "\n\n";
        let empty = true;
        let count = 0;
        for (let i in this.objects) {
            str += this.objects[i].toStr(lang) + "\n";
            empty = false;
        }
        if (empty) {
            let strNoObjects = Translator.getString(lang, "inventory_equipment", "nothing_equipped");
            str += strNoObjects;
        }

        return str;
    }

    getItem(idEmplacement) {
        return this.objects[idEmplacement];
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
        let toReturn = {head: "", chest: "", legs: "", weapon: ""};

        for (let i in this.objects) {
            toReturn[this.objects[i].typeName] = Globals.addr + "images/items/" + this.objects[i].image + ".png";
        }

        return toReturn;
    }

}

module.exports = CharacterEquipement;
