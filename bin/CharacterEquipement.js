'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Item = require("./Item.js");
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
                .setAuthor(this.objects[type].name + (this.objects[type].isFavorite == true ? " ★" : ""), Globals.addr + "images/items/" + this.objects[type].image + ".png")
                .setColor(this.objects[type].rarityColor)
                .addField(Translator.getString(lang, "item_types", this.objects[type].typeName) + " (" + Translator.getString(lang, "item_sous_types", this.objects[type].sousTypeName) + ")" + " | " + Translator.getString(lang, "rarities", this.objects[type].rarity) + " | " + Translator.getString(lang, "general", "lvl") + " : " + this.objects[type].level + " | " + Translator.getString(lang, "inventory_equipment", "power") + " : " + this.objects[type].getPower() + "%" + " (" + Translator.getString(lang, "inventory_equipment", "currently_equipped") + ")"
                , this.objects[type].desc != null ? this.objects[type].desc : Translator.getString(lang, "inventory_equipment", "no_desc"))
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
        if (this.objects[item.type]) {
            //console.log("Equip And Swap");
            if (this.objects[item.type].id !== idItem) {
                let toReturn = this.objects[item.type].id;

                // On enlève les stats de l'objet
                this.removeStats(item.type);
                // On remplace l'objet
                this.objects[item.type] = item;
                conn.query("UPDATE charactersequipements SET idItem = " + idItem + " WHERE idCharacter = " + this.id + " AND idType = " + item.type + ";");
                this.addStats(item.type);
                // return id object
                return toReturn;
            }
        } else {
            //console.log("Equip Only");
            this.objects[item.type] = item;
            conn.query("INSERT INTO charactersequipements VALUES(" + this.id + ", " + idItem + ", " + item.type + ");");
            // Une fois tout fait on peut add les stats
            this.addStats(item.type);
            return -1;
        }

    }

    unEquip(type) {
        if (this.objects[type]) {
            let idItem = this.objects[type].id;
            conn.query("DELETE FROM charactersequipements WHERE idCharacter = " + this.id + " AND idType = " + type);
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
        //let str = "| id |                  Nom                    |         Type         | idType | Niveau |    Rareté    |\n\n";
        let str = "";
        str += Translator.getString(lang, "inventory_equipment", "name") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "type") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "level") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "rarity") + " - ";
        str += Translator.getString(lang, "inventory_equipment", "power") + "\n\n";
        let empty = true;
        let count = 0;
        for (let i in this.objects) {
            /*
            //str += " + " + this.objects[i].name + " | " + this.objects[i].typeName + " | " + this.objects[i].type + " | " + this.objects[i].level + " | " + this.objects[i].rarity + "\n";
            // Id
            count = 4 - this.objects[i].id.toString().length;
            str += "|" + " ".repeat(Math.floor(count / 2)) + this.objects[i].id + " ".repeat(Math.ceil(count / 2)) + "|";

            // Name
            count = 41 - this.objects[i].name.length;
            str += " ".repeat(Math.floor(count / 2)) + this.objects[i].name + " ".repeat(Math.ceil(count/2)) + "|";

            // Type
            count = 22 - this.objects[i].typeName.length;
            str += " ".repeat(Math.floor(count / 2)) + this.objects[i].typeName + " ".repeat(Math.ceil(count / 2)) + "|";

            // Id Type
            count = 8 - this.objects[i].type.toString().length;
            str += " ".repeat(Math.floor(count / 2)) + this.objects[i].type + " ".repeat(Math.ceil(count / 2)) + "|";

            // Niveau
            count = 8 - this.objects[i].level.toString().length;
            str += " ".repeat(Math.floor(count / 2)) + this.objects[i].level + " ".repeat(Math.ceil(count / 2)) + "|";

            // Raret�
            count = 14 - this.objects[i].rarity.length;
            str += " ".repeat(Math.floor(count / 2)) + this.objects[i].rarity + " ".repeat(Math.ceil(count / 2)) + "|\n";
            */
            str += this.objects[i].toStr(lang) + "\n";

            empty = false;

        }
        if (empty) {
            let strNoObjects = Translator.getString(lang, "inventory_equipment", "nothing_equipped");
            /*count = (77) - strNoObjects.length;
            str += "|" + " ".repeat(Math.floor(count / 2)) + strNoObjects + " ".repeat(Math.ceil(count / 2)) + "|";*/
            str += strNoObjects;
        }

        return str;
    }

    getItem(idEmplacement) {
        return this.objects[idEmplacement];
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
