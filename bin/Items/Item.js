﻿'use strict';
const conn = require("../../conf/mysql.js");
const StatsItems = require("../Stats/StatsItems.js");
const SecondaryStatsItems = require("../Stats/Secondary/SecondaryStatsItems");
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
        this.subType = 0;
        this.subTypeName = "";
        this.equipable = true;
        this.stackable = false;
        this.stats = new StatsItems(id);
        this.secondaryStats = new SecondaryStatsItems(id);
        this.power = 0;
        this.number = 1;
        this.isFavorite = false;
    }


    async loadItem() {
        /*SELECT DISTINCT nomItem, descItem, itemsbase.idType, nomType, nomRarity, couleurRarity, level FROM items INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity WHERE items.idItem = 1;*/
        let res = await conn.query("SELECT DISTINCT itemsbase.idBaseItem, imageItem, itemsbase.idType, nomType, nomRarity, itemsbase.idRarity, couleurRarity, level, equipable, stackable, usable, favorite, itemsbase.idSousType, nomSousType, power FROM items INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType INNER JOIN itemspower ON itemspower.idItem = items.idItem WHERE items.idItem = ?;", [this.id]);
        res = res[0];
        this.idBaseItem = res["idBaseItem"];
        this.level = res["level"];
        this.image = res["imageItem"];

        this.rarity = res["nomRarity"];
        this.rarityColor = res["couleurRarity"];
        this.idRarity = res["idRarity"];

        this.type = res["idType"];
        this.typeName = res["nomType"];

        this.subType = res["idSousType"];
        this.subTypeName = res["nomSousType"];

        this.equipable = res["equipable"];
        this.stackable = res["stackable"];
        this.usable = res["usable"];
        this.isFavorite = res["favorite"];

        this.power = res["power"];
        await Promise.all([this.stats.loadStats(), this.secondaryStats.loadStats()]);
    }

    async deleteItem() {
        await Promise.all([this.stats.deleteStats(), this.secondaryStats.deleteStats(), conn.query("DELETE FROM itemspower WHERE idItem = ?;", [this.id])]);
        await conn.query("DELETE FROM items WHERE idItem = ?;", [this.id]);
    }

    static async deleteItem(idItem) {
        await Promise.all([StatsItems.deleteStats(idItem), SecondaryStatsItems.deleteStats(idItem), conn.query("DELETE FROM itemspower WHERE idItem = ?;", [idItem])]);
        await conn.query("DELETE FROM items WHERE idItem = ?;", [idItem]);
    }

    /**
     * Insert an item to the database (using idBase and level and optionally power)
     * and returns the id if done
     * else return -1
     * @param {*} idBase 
     * @param {*} level 
     */
    static async lightInsert(idBase, level, power = 0) {
        if (idBase != null && idBase > 0 && level != null && level > 0) {
            let insertID = (await conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES (NULL, ?, ?);", [idBase, level]))["insertId"];
            await conn.query("INSERT INTO itemspower VALUES (?, ?);", [insertID, power]);
            return insertID;
        }
        return -1;
    }

    /**
     * 
     * @param {Array<number>} idItems 
     */
    static async deleteItems(idItems) {
        if (idItems.toString().length > 0) {
            let itemsToDelete = "(" + idItems.toString() + ")";
            await Promise.all([
                StatsItems.deleteStatsMultiple(idItems),
                SecondaryStatsItems.deleteStatsMultiple(idItems),
                conn.query("DELETE FROM itemspower WHERE idItem IN " + itemsToDelete + ";"),
            ]);

            await conn.query("DELETE FROM items WHERE idItem IN " + itemsToDelete + ";");
        }
    }

    getLevel() {
        return this.level;
    }

    getIdRarity() {
        return this.idRarity;
    }

    /**
     * This will be a general static function to get power based on stats
     * @param {Stats} stats 
     * @param {SecondaryStats} secondaryStats
     */
    static calculPower(stats, secondaryStats) {
        let statsPossible = Object.keys(Globals.statsIdsByName);
        let secondaryStatsPossible = [...Globals.allSecondaryStatsNames];
        let power = 0;
        for (let i of statsPossible) {
            let statPower = 0;
            if (i != "armor") {
                statPower = stats[i] / 100;
            } else {
                statPower = stats[i] / Math.ceil((8 * (Math.pow(50, 2)) / 7) / 4.5);
            }
            let mult = 1;
            switch (i) {
                case Stats.possibleStats.Strength:
                case Stats.possibleStats.Intellect:
                case Stats.possibleStats.Dexterity:
                    mult = 1;
                    break;
                case Stats.possibleStats.Constitution:
                case Stats.possibleStats.Wisdom:
                    mult = 0.9;
                    break;
                case Stats.possibleStats.Perception:
                case Stats.possibleStats.Luck:
                    mult = 0.25;
                    break;
                case Stats.possibleStats.Will:
                case Stats.possibleStats.Charisma:
                case Stats.possibleStats.Armor:
                    mult = 0.65;
            }
            power += statPower * mult;
        }

        for (let i of secondaryStatsPossible) {
            let statPower = secondaryStats[i] / 3;

            let mult = 1;
            switch (i) {
                case SecondaryStats.possibleStats.CriticalRate:
                case SecondaryStats.possibleStats.EvadeRate:
                case SecondaryStats.possibleStats.HitRate:
                case SecondaryStats.possibleStats.MagicalEvadeRate:
                case SecondaryStats.possibleStats.CritcalEvadeRate:
                    mult = 0.7;
                    break;
                case SecondaryStats.possibleStats.RegenEnergy:
                    mult = 0.5;
                    break;
                case SecondaryStats.possibleStats.SkillEnergyCost:
                case SecondaryStats.possibleStats.SkillManaCost:
                    mult = 0.6;
                    break;
                case SecondaryStats.possibleStats.RegenHp:
                case SecondaryStats.possibleStats.Threat:
                case SecondaryStats.possibleStats.RegenMp:
                    mult = 0.6 / 100;
                    break;
                case SecondaryStats.possibleElementalResists.Air:
                case SecondaryStats.possibleElementalResists.Dark:
                case SecondaryStats.possibleElementalResists.Earth:
                case SecondaryStats.possibleElementalResists.Fire:
                case SecondaryStats.possibleElementalResists.Water:
                case SecondaryStats.possibleElementalResists.Light:
                    mult = 1;
                    break;

            }
            power += statPower * mult;
        }
        return Math.floor(power / 5 * 100);
    }

    async calculPower() {
        return Item.calculPower(this.stats, this.secondaryStats);
    }

    async getPower() {
        return this.power;
    }

    async updatePower() {
        await conn.query("UPDATE itemspower SET power = ? WHERE idItem = ?;", [this.calculPower(), this.id]);
    }

    async setFavorite(value) {
        value = value != false && value != true ? false : value;
        this.isFavorite = value;
        await conn.query("UPDATE items SET favorite = ? WHERE idItem = ?", [this.isFavorite, this.id]);
    }

    /**
     * @returns {Number}
     */
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

    static getName(idBase, lang = "en") {
        return Translator.getString(lang, "itemsNames", idBase);
    }

    static getDesc(idBase, lang = "en") {
        let desc = Translator.getString(lang, "itemsDesc", idBase, [], true);
        return desc != null ? desc : Translator.getString(lang, "inventory_equipment", "no_desc");
    }


    /* 
     * API CALLS HERE
     */

    async toApi(lang) {
        let toApiObject = await this.toApiLight(lang);
        toApiObject.desc = this.getDesc(lang);
        toApiObject.stats = this.stats.toApi();
        toApiObject.secondaryStats = this.secondaryStats.toApi();

        return toApiObject;
    }

    async toApiLight(lang) {
        let toApiObject = {
            id: this.id,
            name: this.getName(lang),
            rarity: Translator.getString(lang, "rarities", this.rarity),
            rarity_shorthand: this.rarity,
            rarityColor: this.rarityColor,
            level: this.getLevel(),
            type: Translator.getString(lang, "item_types", this.typeName),
            type_shorthand: this.typeName,
            subType: Translator.getString(lang, "item_sous_types", this.subTypeName),
            subtype_shorthand: this.subTypeName,
            power: await this.getPower(),
            equipable: this.isEquipable(),
            number: this.number,
            price: this.getCost(),
            isFavorite: this.isFavorite,
            image: this.image,
            usable: this.isUsable(),
            desc: "",
            /**
             * @type {StatsItems}
             */
            stats: {},
            /**
            * @type {SecondaryStatsItems}
            */
            secondaryStats: {},
        };
        return toApiObject;
    }

}

Item.newItem = async (idItem, stype) => {
    let itemToReturn;
    switch (stype) {
        case "consumable":
            itemToReturn = new Consumable(idItem);
            break;
        case "loot_box_equipment":
            itemToReturn = new EquipmentLootBox(idItem);
            break;
        case "reset_time_potion":
            itemToReturn = new ResetTimePotion(idItem);
            break;
        case "founder_box":
            itemToReturn = new FounderGift(idItem);
            break;
        case "random_loot_box_equipment":
            itemToReturn = new EquipmentRandomLootBox(idItem);
            break;
        case "horse":
            itemToReturn = new Horse(idItem);
            break;
        case "salamander":
            itemToReturn = new Salamander(idItem);
            break;
        case "camel":
            itemToReturn = new Camel(idItem);
            break;
        case "polar_bear":
            itemToReturn = new PolarBear(idItem);
            break;
        case "energy_potion":
            itemToReturn = new EnergyPotion(idItem);
            break;
        default:
            itemToReturn = new Item(idItem);
            break;
    }
    await itemToReturn.loadItem();

    return itemToReturn;
};

module.exports = Item;

const EquipmentLootBox = require("./LootBoxes/EquipmentLootBox");
const Consumable = require("./Consumable");
const ResetTimePotion = require("./Potions/ResetTimePotion");
const FounderGift = require("./LootBoxes/FounderGift");
const EquipmentRandomLootBox = require("./LootBoxes/EquipmentRandomLootBox");
const Horse = require("./Mounts/Horse");
const Salamander = require("./Mounts/Salamander");
const Camel = require("./Mounts/Camel");
const PolarBear = require("./Mounts/PolarBear");
const EnergyPotion = require("./Potions/EnergyPotion");
const Stats = require("../Stats/Stats");
const SecondaryStats = require("../Stats/Secondary/SecondaryStats");