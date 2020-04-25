'use strict';
const conn = require("../../conf/mysql.js");
const MarketplaceOrder = require("./MarketplaceOrder");
const Item = require("../Items/Item.js");
const Globals = require("../Globals");

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

    async getCharacterOrders(idCharacter, page, params, lang) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 5;

        let maxPage = Math.ceil((await this.getCharacterNumberOfOrders(idCharacter, params, lang)) / perPage);


        let sqlParams = [lang, this.id, idCharacter, perPage, (page - 1) * perPage];
        let more = "";

        let searchParamsResult = Globals.getSearchParams(params, false, true);
        if (searchParamsResult.values.length > 0) {
            sqlParams = sqlParams.slice(0, 3).concat(searchParamsResult.values.concat(sqlParams.slice(3)))
            more = searchParamsResult.sqlQuery;
        }

        page = maxPage > 0 && maxPage < page ? maxPage : page;
        let res = await conn.query(`SELECT idMarketplace, marketplacesorders.idItem, marketplacesorders.idCharacter, marketplacesorders.number, marketplacesorders.price FROM marketplacesorders 
                                    INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem AND localizationitems.lang = ?
                                    INNER JOIN itemspower ON itemspower.idItem = items.idItem
                                    WHERE idMarketplace = ? AND idCharacter = ? ${more} ORDER BY price DESC LIMIT ? OFFSET ?`, sqlParams);

        maxPage = maxPage > 0 ? maxPage : 1;
        return {
            res: res,
            maxPage: maxPage,
            page: page <= maxPage && page > 0 ? page : maxPage
        };
    }

    async getCharacterNumberOfOrders(idCharacter, params, lang) {
        let sqlParams = [lang, this.id, idCharacter];
        let more = "";

        let searchParamsResult = Globals.getSearchParams(params, false, true);
        if (searchParamsResult.values.length > 0) {
            sqlParams = sqlParams.slice(0, 3).concat(searchParamsResult.values.concat(sqlParams.slice(3)))
            more = searchParamsResult.sqlQuery;
        }

        let res = await conn.query(`SELECT COUNT(*) FROM marketplacesorders
                                    INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem AND localizationitems.lang = ?
                                    INNER JOIN itemspower ON itemspower.idItem = items.idItem
                                    WHERE idMarketplace = ? AND idCharacter = ? ${more};`, sqlParams);

        return res[0]["COUNT(*)"];
    }

    async getNumberOfOrders(params, lang) {
        let sqlParams = [lang, this.id];
        let more = "";

        let searchParamsResult = Globals.getSearchParams(params, false, true);
        if (searchParamsResult.values.length > 0) {
            sqlParams = sqlParams.slice(0, 2).concat(searchParamsResult.values.concat(sqlParams.slice(2)))
            more = searchParamsResult.sqlQuery;
        }

        let res = await conn.query(`SELECT COUNT(*) FROM marketplacesorders
                                    INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                    INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                    INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem AND localizationitems.lang = ?
                                    INNER JOIN itemspower ON itemspower.idItem = items.idItem
                                    WHERE idMarketplace = ? ${more};`, sqlParams);

        return res[0]["COUNT(*)"];
    }

    async getAllOrdersCorrespondingTo(page, params, lang) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 5;


        let maxPage = Math.ceil((await this.getNumberOfOrders(params, lang)) / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;

        let sqlParams = [lang, this.id, perPage, (page - 1) * perPage];
        let more = "";

        let searchParamsResult = Globals.getSearchParams(params, false, true);
        if (searchParamsResult.values.length > 0) {
            sqlParams = sqlParams.slice(0, 2).concat(searchParamsResult.values.concat(sqlParams.slice(2)))
            more = searchParamsResult.sqlQuery;
        }

        let res = await conn.query(`SELECT idMarketplace, marketplacesorders.idItem, marketplacesorders.idCharacter, marketplacesorders.number, marketplacesorders.price FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem AND localizationitems.lang = ?
                                INNER JOIN itemspower ON itemspower.idItem = items.idItem
                                WHERE marketplacesorders.idMarketplace = ? ${more} ORDER BY marketplacesorders.price ASC LIMIT ? OFFSET ?`,
            sqlParams);

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

    async apiCharacterOrders(idCharacter, page, params, lang) {
        let res = await this.getCharacterOrders(idCharacter, Number.parseInt(page), params, lang);
        return await this.createApiShow(res, lang)
    }

    async apiSearchOrders(page, params, lang) {
        let res = await this.getAllOrdersCorrespondingTo(Number.parseInt(page), params, lang);
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