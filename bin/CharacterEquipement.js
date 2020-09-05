'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Item = require("./Items/Item.js");
const Mount = require("./Items/Mounts/Mount");
const Consumable = require("./Items/Consumable");
const StatsEquipment = require("./Stats/StatsEquipment");
const SecondaryStatsEquipment = require("./Stats/Secondary/SecondaryStatsEquipment");
const Translator = require("./Translator/Translator");

class CharacterEquipement {
    // Discord User Info
    constructor(id) {
        this.id = id;
        this.objects = {};
        this.stats = new StatsEquipment();
        this.secondaryStats = new SecondaryStatsEquipment();
    }

    // Load equipement from DB

    async loadEquipements(id) {
        this.id = id;
        this.stats.id = id;
        this.secondaryStats.id = id;
        await this.updateStats();
    }

    async getPower() {
        let avgPower = 0;
        let items = await this.getAllItems();
        for (let i in items) {
            avgPower += await items[i].getPower();
        }
        return Math.floor(avgPower / 4);
    }

    async updateStats() {
        await Promise.all([this.stats.update(), this.secondaryStats.update()]);
    }

    // -1 Pas Swap
    // Sinon return id item à swap
    async equip(idItem) {
        let item = new Item(idItem);
        await item.loadItem();
        if (!await this.isSlotFree(item.getEquipTypeID())) {
            let equipedItem = await this.getItem(item.getEquipTypeID());
            if (equipedItem.id !== idItem) {
                let toReturn = equipedItem.id;
                await conn.query("UPDATE charactersequipements SET idItem = ? WHERE idCharacter = ? AND idType = ?;", [idItem, this.id, item.getEquipTypeID()]);
                await this.updateStats();
                return toReturn;
            }
        } else {
            await conn.query("INSERT INTO charactersequipements VALUES(?, ?, ?);", [this.id, idItem, item.getEquipTypeID()]);
            await this.updateStats();
            return -1;
        }

    }

    async unEquip(type) {
        if (!await this.isSlotFree(type)) {
            let idItem = await this.getItem(type);
            idItem = idItem.id;
            await conn.query("DELETE FROM charactersequipements WHERE idCharacter = ? AND idType = ?;", [this.id, type]);
            await this.updateStats();
            return idItem;
        }
        return -1;
    }

    /**
     * @returns {Array<Item>}
     */
    async getAllItems() {
        let res = await conn.query("SELECT itemstypes.nomType, charactersequipements.idItem FROM charactersequipements INNER JOIN itemstypes ON itemstypes.idType = charactersequipements.idType WHERE charactersequipements.idCharacter = ?;", [this.id]);
        let items = [];
        for (let i in res) {
            items[i] = await Item.newItem(res[i].idItem, res[i].nomType);
        }
        return items;
    }

    async toApi(lang) {
        let res = await this.getAllItems();
        let toSend = [];
        for (let i in res) {
            toSend[i] = await res[i].toApiLight(lang);
        }
        await Promise.all(toSend);
        return toSend;
    }

    async isSlotFree(idEmplacement) {
        let res = await conn.query("SELECT * FROM charactersequipements WHERE idCharacter = ? AND idType = ?;", [this.id, idEmplacement]);
        return res[0] == null;
    }

    /**
     * 
     * @returns {Promise<Item>} 
     */
    async getItem(idEmplacement) {
        let res = await conn.query("SELECT itemstypes.nomType, charactersequipements.idItem, itemssoustypes.nomSousType FROM charactersequipements INNER JOIN items ON items.idItem = charactersequipements.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType WHERE charactersequipements.idCharacter = ? AND itemstypes.idType = ?;", [this.id, idEmplacement]);
        if (res[0]) {
            return await Item.newItem(res[0].idItem, res[0].nomSousType);
        }
        return null;
    }

    async getItemByIDItem(idItem) {
        let res = await conn.query("SELECT itemstypes.nomType, charactersequipements.idItem, itemssoustypes.nomSousType FROM charactersequipements INNER JOIN items ON items.idItem = charactersequipements.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType WHERE charactersequipements.idCharacter = ? AND charactersequipements.idItem = ?;", [this.id, idItem]);
        if (res[0]) {
            return await Item.newItem(res[0].idItem, res[0].nomSousType);
        }
        return null;
    }

    /**
     * 
     * @param {string} typeName
     * @return {Item | Mount | Consumable}
     */
    async getItemByTypeName(typeName) {
        let res = await conn.query("SELECT itemstypes.nomType, charactersequipements.idItem, itemssoustypes.nomSousType FROM charactersequipements INNER JOIN items ON items.idItem = charactersequipements.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType WHERE charactersequipements.idCharacter = ? AND itemstypes.nomType = ?;", [this.id, typeName]);
        if (res[0]) {
            return await Item.newItem(res[0].idItem, res[0].nomSousType);
        }
        return null;
    }

    getStat(statName) {
        return this.stats.getStat(statName);
    }

    getSecondaryStat(statName) {
        if (this.secondaryStats.getStat(statName) > 0)
            console.log(statName);
        return this.secondaryStats.getStat(statName);
    }

}

module.exports = CharacterEquipement;