'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");
const MarketplaceOrder = require("./MarketplaceOrder");


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
        page = page ? (page <= 0 ? 1 : page) : 1;
        let perPage = 5;
        let res = conn.query("SELECT * FROM marketplacesorders WHERE idMarketplace = ? ORDER BY price DESC LIMIT ? OFFSET ?", [this.id, perPage, page - 1]);
        return res;
    }

    showCharacterOrders(idCharacter, page, lang) {
        let str = "```\n";
        str += Translator.getString(lang, "marketplace", "header_str") + "\n\n";
        let orders = this.getCharacterOrders();
        for (let order of orders) {
            let morder = new MarketplaceOrder(this.id, order.idItem, order.idCharacter, order.number, order.price);
            str += morder.toStr(lang) + "\n";
        }
        str += "```";
        return str;
    }

   

}

module.exports = Marketplace;
