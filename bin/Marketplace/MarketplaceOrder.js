'use strict';
const conn = require("../../conf/mysql.js");
const Item = require("../Items/Item.js");


class MarketplaceOrder {

    constructor(idMarketplace, idItem, idCharacter, number, price) {
        this.idMarketplace = idMarketplace;
        this.idItem = idItem;
        this.idCharacter = idCharacter;
        this.number = number;
        this.price = price;
    }

    async update() {
        await conn.query("UPDATE marketplacesorders SET number = ? WHERE idItem = ?;", [this.number, this.idItem]);
    }

    async place() {
        await conn.query("INSERT INTO marketplacesorders VALUES (?,?,?,?,?)", [this.idMarketplace, this.idItem, this.idCharacter, this.number, this.price]);
    }

    async remove() {
        await conn.query("DELETE FROM marketplacesorders WHERE idItem = ?", [this.idItem]);
    }

    async toApi(lang) {
        let item = new Item(this.idItem);
        await item.loadItem();
        item.number = this.number;
        let username = await conn.query("SELECT userName FROM users WHERE idCharacter = ?", [this.idCharacter]);
        username = username[0]["userName"];
        return {
            seller_name: username,
            idItem: this.idItem,
            item: await item.toApiLight(lang),
            price: this.price,
        }
    }



}

module.exports = MarketplaceOrder;