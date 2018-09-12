'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");
const MarketplaceOrder = require("./MarketplaceOrder");
const Item = require("../Items/Item.js");
const Discord = require("discord.js");

class Marketplace {

    constructor() {
        this.id = 0; 
        this.tax = 0;
        this.isActive = false;
    }

    loadMakerplace(idArea) {
        let res = conn.query("SELECT * FROM marketplaces WHERE idArea = ?", [idArea]);
        if (res[0]) {
            this.id = res[0]["idMarketplace"];
            this.tax = res[0]["tax"];
            this.isActive = res[0]["active"];
        }
    }

    saveOrder(order) {
        conn.query();
    }

    getTax() {
        return this.tax;
    }

    getCharacterOrders(idCharacter, page) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 5;
        let maxPage = Math.ceil(conn.query("SELECT COUNT(*) FROM marketplacesorders WHERE idMarketplace = ? AND idCharacter = ?", [this.id, idCharacter])[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;
        let res = conn.query("SELECT * FROM marketplacesorders WHERE idMarketplace = ? AND idCharacter = ? ORDER BY price DESC LIMIT ? OFFSET ?", [this.id, idCharacter, perPage, (page - 1) * perPage]);
        return { res: res, maxPage: maxPage, page: page };
    }

    getAllOrdersCorrespondingTo(itemName, level, page, lang) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 5;

        let maxPage = Math.ceil(conn.query(`SELECT COUNT(*) FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem AND localizationitems.lang = ?
                                WHERE marketplacesorders.idMarketplace = ? AND instr(localizationitems.nameItem, ?) AND items.level = ?`,
            [lang, this.id, itemName, level])[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;
        let res = conn.query(`SELECT * FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem AND localizationitems.lang = ?
                                WHERE marketplacesorders.idMarketplace = ? AND instr(localizationitems.nameItem, ?) AND items.level = ? ORDER BY marketplacesorders.price ASC LIMIT ? OFFSET ?`,
            [lang, this.id, itemName, level, perPage, (page - 1) * perPage]);

        return { res: res, maxPage: maxPage, page: page };
    }

    getAll(page) {
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 5;
        let maxPage = Math.ceil(conn.query(`SELECT COUNT(*) FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                WHERE marketplacesorders.idMarketplace = ? ORDER BY marketplacesorders.price DESC`,
            [this.id])[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;

        let res = conn.query(`SELECT * FROM marketplacesorders
                                INNER JOIN items ON items.idItem = marketplacesorders.idItem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
                                WHERE marketplacesorders.idMarketplace = ? ORDER BY marketplacesorders.price DESC LIMIT ? OFFSET ?`,
            [this.id, perPage, (page - 1) * perPage]);



        return { res: res, maxPage: maxPage, page: page };
    }

    getThisOrder(idItem) {
        idItem = idItem ? idItem : null;
        let res = conn.query("SELECT * FROM marketplacesorders WHERE idItem = ?", [idItem]);
        return res[0] ? new MarketplaceOrder(res[0]["idMarketplace"], idItem, res[0]["idCharacter"], res[0]["number"], res[0]["price"]) : null;
    }

    showCharacterOrders(idCharacter, page, lang) {
        let res = this.getCharacterOrders(idCharacter, Number.parseInt(page));
        return this.createShow(res, lang);
    }

    showSearchOrder(itemName, level, page, lang) {
        let res = this.getAllOrdersCorrespondingTo(itemName, level, Number.parseInt(page), lang);
        return this.createShow(res, lang);
    }

    showAll(page, lang) {
        let res = this.getAll(Number.parseInt(page));
        return this.createShow(res, lang);
    }

    createShow(res, lang) {
        let str = "```\n";
        str += Translator.getString(lang, "marketplace", "header_str") + "\n\n";
        let orders = res.res;
        if (orders.length > 0) {
            for (let order of orders) {
                let morder = new MarketplaceOrder(this.id, order.idItem, order.idCharacter, order.number, order.price);
                str += morder.toStr(lang) + "\n";
            }
            str += "\n";
        } else {
            str += Translator.getString(lang, "general", "nothing_at_this_page") + "\n\n";
        }
        str += Translator.getString(lang, "general", "page_out_of_x", [res.page, res.maxPage > 0 ? res.maxPage : 1])
        str += "```";
        return str;
    }



    showItemOrder(idItem, character, lang) {
        let item = new Item(idItem);
        let compareStats = character.getEquipement().getItem(this.getEquipableIDType(item.typeName));
        if (compareStats != null) {
            compareStats = compareStats.stats;
        }

        return new Discord.RichEmbed()
            .setAuthor(item.getName(lang), Globals.addr + "images/items/" + item.image + ".png")
            .setColor(item.rarityColor)
            .addField(Translator.getString(lang, "item_types", item.typeName) + " (" + Translator.getString(lang, "item_sous_types", item.sousTypeName) + ")" + " | " + Translator.getString(lang, "rarities", item.rarity) + " | " + Translator.getString(lang, "general", "lvl") + " : " + item.level + " | " + Translator.getString(lang, "inventory_equipment", "power") + " : " + item.getPower() + "%"
            , item.getDesc(lang))
            .addField(Translator.getString(lang, "inventory_equipment", "attributes") + " : ", item.stats.toStr(compareStats, lang));
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
