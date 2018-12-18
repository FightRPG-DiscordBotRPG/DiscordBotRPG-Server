'use strict';
const conn = require("../../conf/mysql.js");
const MarketplaceOrder = require("./MarketplaceOrder");
const Item = require("../Items/Item.js");

class Marketplace {

    constructor() {
        this.id = 0;
        this.tax = 0;
        this.isActive = false;
    }

    async loadMakerplace(idArea) {
        let res = await conn.query("SELECT * FROM marketplaces WHERE idArea = ?", [idArea]);
        if (res[0]) {
            this.id = res[0]["idMarketplace"];
            this.tax = res[0]["tax"];
            this.isActive = res[0]["active"];
        }
    }

    getTax() {
        return this.tax;
    }

    async getCharacterOrders(idCharacter, page) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 5;
        let res = await conn.query("SELECT COUNT(*) FROM marketplacesorders WHERE idMarketplace = ? AND idCharacter = ?", [this.id, idCharacter]);
        let maxPage = Math.ceil(res[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;
        res = await conn.query("SELECT * FROM marketplacesorders WHERE idMarketplace = ? AND idCharacter = ? ORDER BY price DESC LIMIT ? OFFSET ?", [this.id, idCharacter, perPage, (page - 1) * perPage]);

        maxPage = maxPage > 0 ? maxPage : 1;
        return {
            res: res,
            maxPage: maxPage,
            page: page <= maxPage && page > 0 ? page : maxPage
        };
    }

    async getAllOrdersCorrespondingTo(itemName, level, page, lang) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 5;

        let res = await conn.query(`SELECT COUNT(*) FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem AND localizationitems.lang = ?
                                WHERE marketplacesorders.idMarketplace = ? AND instr(localizationitems.nameItem, ?) AND items.level = ?`,
            [lang, this.id, itemName, level]);
        let maxPage = Math.ceil(res[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;
        res = await conn.query(`SELECT * FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem AND localizationitems.lang = ?
                                WHERE marketplacesorders.idMarketplace = ? AND instr(localizationitems.nameItem, ?) AND items.level = ? ORDER BY marketplacesorders.price ASC LIMIT ? OFFSET ?`,
            [lang, this.id, itemName, level, perPage, (page - 1) * perPage]);

        maxPage = maxPage > 0 ? maxPage : 1;
        return {
            res: res,
            maxPage: maxPage,
            page: page <= maxPage && page > 0 ? page : maxPage
        };
    }

    async getAll(page) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 5;
        let res = await conn.query(`SELECT COUNT(*) FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                WHERE marketplacesorders.idMarketplace = ? ORDER BY marketplacesorders.price DESC`,
            [this.id]);
        let maxPage = Math.ceil(res[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;

        res = await conn.query(`SELECT * FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                WHERE marketplacesorders.idMarketplace = ? ORDER BY marketplacesorders.price DESC LIMIT ? OFFSET ?`,
            [this.id, perPage, (page - 1) * perPage]);


        maxPage = maxPage > 0 ? maxPage : 1;
        return {
            res: res,
            maxPage: maxPage,
            page: page <= maxPage && page > 0 ? page : maxPage
        };
    }

    async getThisOrder(idItem) {
        idItem = idItem ? idItem : null;
        let res = await conn.query("SELECT * FROM marketplacesorders WHERE idItem = ?", [idItem]);
        return res[0] ? new MarketplaceOrder(res[0]["idMarketplace"], idItem, res[0]["idCharacter"], res[0]["number"], res[0]["price"]) : null;
    }

    async apiCharacterOrders(idCharacter, page, lang) {
        let res = await this.getCharacterOrders(idCharacter, Number.parseInt(page));
        return await this.createApiShow(res, lang)
    }

    async apiSearchOrder(itemName, level, page, lang) {
        let res = await this.getAllOrdersCorrespondingTo(itemName, level, Number.parseInt(page), lang);
        return await this.createApiShow(res, lang);
    }

    async apiShowAll(page, lang) {
        let res = await this.getAll(Number.parseInt(page));
        return await this.createApiShow(res, lang);
    }

    async createApiShow(res, lang) {
        let orders = res.res;
        let toApi = {
            page: res.page,
            maxPage: res.maxPage > 0 ? res.maxPage : 1,
            orders: [],
        }
        for (let order of orders) {
            let morder = new MarketplaceOrder(this.id, order.idItem, order.idCharacter, order.number, order.price);
            toApi.orders.push(await morder.toApi(lang));
        }
        return toApi;
    }

    async apiItemOrder(idItem, character, lang) {
        let item = new Item(idItem);
        await item.loadItem();
        let compareStats = await character.getEquipement().getItem(this.getEquipableIDType(item.typeName));
        if (compareStats != null) {
            compareStats = compareStats.stats;
        } else {
            compareStats = {};
        }
        return {
            item: await item.toApi(lang),
            equippedStats: compareStats,
        };
    }


    // Temp
    getEquipableIDType(string) {
        let r = -1;
        switch (string) {
            case "weapon":
                r = 1;
                break;
            case "chest":
                r = 2;
                break;
            case "legs":
                r = 3;
                break;
            case "head":
                r = 4;
                break;
        }
        return r;
    }




}

module.exports = Marketplace;