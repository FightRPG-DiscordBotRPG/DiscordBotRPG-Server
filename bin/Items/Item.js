'use strict';
const conn = require("../../conf/mysql.js");
const StatsItems = require("../Stats/StatsItems.js");
const Globals = require("../Globals.js");
const Translator = require("../Translator/Translator.js");


class Item {

    constructor(id) {
        this.id = id;
        this.idBaseItem = 0;
        this.image = "";
        this.rarity = "";
        this.rarityColor = "";
        this.idRarity = 0;
        this.level = 0;
        this.type = 0;
        this.typeName = "";
        this.sousType = 0;
        this.sousTypeName = "";
        this.equipable = true;
        this.stackable = false;
        this.stats = new StatsItems(id);
        this.number = 1;
        this.isFavorite = false;

        // Functions0
        this.loadItem();

    }


    loadItem() {
        /*SELECT DISTINCT nomItem, descItem, itemsbase.idType, nomType, nomRarity, couleurRarity, level FROM items INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity WHERE items.idItem = 1;*/
        let res = conn.query("SELECT DISTINCT itemsbase.idBaseItem, imageItem, itemsbase.idType, nomType, nomRarity, itemsbase.idRarity, couleurRarity, level, equipable, stackable, usable, favorite, itemsbase.idSousType, nomSousType FROM items INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType WHERE items.idItem = ?;", [this.id])[0];
        this.idBaseItem = res["idBaseItem"];
        this.level = res["level"];
        this.image = res["imageItem"];

        this.rarity = res["nomRarity"];
        this.rarityColor = res["couleurRarity"];
        this.idRarity = res["idRarity"];

        this.type = res["idType"];
        this.typeName = res["nomType"];

        this.sousType = res["idSousType"];
        this.sousTypeName = res["nomSousType"];

        this.equipable = res["equipable"];
        this.stackable = res["stackable"];
        this.usable = res["usable"];
        this.isFavorite = res["favorite"];
    }

    deleteItem() {
        this.stats.deleteStats();
        conn.query("DELETE FROM items WHERE idItem = ?;", [this.id]);
    }

    static deleteItem(idItem) {
        StatsItems.deleteStats(idItem);
        conn.query("DELETE FROM items WHERE idItem = ?;", [idItem]);
    }

    /**
     * 
     * @param {Array<number>} idItems 
     */
    static deleteItems(idItems) {
        if (idItems.toString().length > 0) {
            let itemsToDelete = "(" + idItems.toString() + ")";
            StatsItems.deleteStatsMultiple(idItems);
            conn.query("DELETE FROM items WHERE idItem IN " + itemsToDelete + ";");
        }
    }

    getLevel() {
        return this.level;
    }

    getIdRarity() {
        return this.idRarity;
    }

    getPower() {
        let statsPossible = Object.keys(Globals.statsIds);
        let power = 0;
        for (let i of statsPossible) {
            let statPower = 0;
            if (i != "armor") {
                statPower = this.stats[i] / (Globals.maxLevel * 2);
            } else {
                statPower = this.stats[i] / Math.ceil((8 * (Math.pow(Globals.maxLevel, 2)) / 7) / 4.5);
            }
            power += statPower;
        }
        return Math.floor(power / 5 * 100);
    }

    setFavorite(value) {
        value = value != false && value != true ? false : value;
        this.isFavorite = value;
        conn.query("UPDATE items SET favorite = ? WHERE idItem = ?", [this.isFavorite, this.id]);
    }

    getEquipTypeID() {
        return this.type;
    }

    /**
     * @returns {boolean}
     */
    isEquipable() {
        return this.equipable;
    }

    /**
     * @returns {boolean}
     */
    isStackable() {
        return this.stackable;
    }

    /**
     * @returns {boolean}
     */
    isUsable() {
        return this.usable;
    }

    toStr(lang) {
        let numberStr = this.number > 1 ? " [x" + this.number + "]" : "";
        return this.getName(lang) + (this.isFavorite == true ? " ★" : "") + numberStr + " - " + Translator.getString(lang, "item_types", this.typeName) + " (" + Translator.getString(lang, "item_sous_types", this.sousTypeName) + ")" + " - " + this.level + " - " + Translator.getString(lang, "rarities", this.rarity) + " - " + this.getPower() + "%";
    }

    getCost(number) {
        return Math.round((this.level * (1 + this.idRarity)) * (number <= this.number ? number : this.number));
    }

    getName(lang = "en") {
        return Translator.getString(lang, "itemsNames", this.idBaseItem);
    }

    getDesc(lang = "en") {
        let desc = Translator.getString(lang, "itemsDesc", this.idBaseItem, [], true);
        return desc != null ? desc : Translator.getString(lang, "inventory_equipment", "no_desc");
    }

    static getName(lang = "en", idBase) {
        return Translator.getString(lang, "itemsNames", idBase);
    }

    static getDesc(lang = "en", idBase) {
        let desc = Translator.getString(lang, "itemsDesc", idBase, [], true);
        return desc != null ? desc : Translator.getString(lang, "inventory_equipment", "no_desc");
    }


    /* 
     * API CALLS HERE
     */

    toApi(lang) {
        let toApiObject = {
            name: this.getName(lang),
            desc: this.getDesc(lang),
            rarity: Translator.getString(lang, "rarities", this.rarity),
            rarityColor: this.rarityColor,
            level: this.getLevel(),
            type: Translator.getString(lang, "item_types", this.typeName),
            subType: Translator.getString(lang, "item_sous_types", this.sousTypeName),
            power: this.getPower(),
            equipable: this.isEquipable(),
            number: this.number,
            price: this.getCost(),
            isFavorite: this.isFavorite,
            image: this.image,
            usable: this.isUsable(),
            stats: this.stats.toApi()
        };
        return toApiObject;
    }

    toApiLight(lang) {
        let toApiObject = {
            name: this.getName(lang),
            rarity: Translator.getString(lang, "rarities", this.rarity),
            rarityColor: this.rarityColor,
            level: this.getLevel(),
            type: Translator.getString(lang, "item_types", this.typeName),
            subType: Translator.getString(lang, "item_sous_types", this.sousTypeName),
            power: this.getPower(),
            equipable: this.isEquipable(),
            number: this.number,
            price: this.getCost(),
            isFavorite: this.isFavorite,
            image: this.image,
            usable: this.isUsable(),
        };
        return toApiObject;
    }

    static getType(idItem) {
        let res = conn.query("SELECT itemstypes.nomType FROM items INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE items.idItem = ?", [idItem]);
        if (res[0]) {
            return res[0].nomType;
        }
        return "unknown";
    }

}

Item.newItem = (idItem, stype) => {
    switch (stype) {
        case "consumable":
            return new Consumable(idItem);
        case "loot_box_equipment":
            return new EquipmentLootBox(idItem);
        case "reset_time_potion":
            return new ResetTimePotion(idItem);
        case "founder_box":
            return new FounderGift(idItem);
        case "random_loot_box_equipment":
            return new EquipmentRandomLootBox(idItem);
        case "horse":
            return new Horse(idItem);
        default:
            return new Item(idItem);
    }
};

module.exports = Item;

const EquipmentLootBox = require("./LootBoxes/EquipmentLootBox");
const Consumable = require("./Consumable");
const ResetTimePotion = require("./ResetTimePotion");
const FounderGift = require("./LootBoxes/FounderGift");
const EquipmentRandomLootBox = require("./LootBoxes/EquipmentRandomLootBox");
const Horse = require("./Mounts/Horse");