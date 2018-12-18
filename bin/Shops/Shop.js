const conn = require("../../conf/mysql");
const ShopItem = require("./ShopItem");

class Shop {

    constructor(id) {
        this.id = id;
    }

    async isActive() {
        let res = await conn.query("SELECT active FROM shop WHERE idShop = ?;", [this.id]);
        if (res[0] != null) {
            return res[0]["active"] == 1;
        }
        return false;
    }

    async getTax() {
        let res = await conn.query("SELECT tax FROM shop WHERE idShop = ?;", [this.id]);
        if (res[0] != null) {
            return res[0]["tax"];
        }
        return false;
    }

    async getItemsIdsAtThisPage(page) {
        page = Number.parseInt(page ? page : 1);
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 10;
        let maxPage = Math.ceil((await conn.query(`SELECT COUNT(*) FROM shopitems WHERE idShop = ?;`,
            [this.id]))[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;

        let res = await conn.query(`SELECT shopitems.idSellableItems FROM shopitems INNER JOIN sellableitems ON sellableitems.idSellableItems = shopitems.idSellableItems WHERE shopitems.idShop = ? ORDER BY price DESC LIMIT ? OFFSET ?;`, [this.id, perPage, (page - 1) * perPage]);

        return {
            res: res,
            maxPage: maxPage < 1 ? 1 : maxPage,
            page: page
        };
    }

    async itemsToApi(page = 1, lang = "en") {
        let res = await this.getItemsIdsAtThisPage(page);
        let tax = await this.getTax();
        let itemsLoadForPromise = [];
        for (let r of res.res) {
            let item = new ShopItem(r.idSellableItems);
            let as = async () => {
                await item.load();
                item.setTax(tax);
                return await item.toApi(lang);
            }
            itemsLoadForPromise.push(as());
        }

        let itemsToApi = await Promise.all(itemsLoadForPromise);
        return {
            page: res.page,
            maxPage: res.maxPage,
            perPage: 10,
            items: itemsToApi,
        }
    }

    async getTrueID(idItem) {
        idItem = idItem && Number.isInteger(Number.parseInt(idItem)) ? idItem : 1;
        let res;
        if (idItem > 0) {
            res = await conn.query("SELECT shopitems.idSellableItems FROM shopitems INNER JOIN sellableitems ON sellableitems.idSellableItems = shopitems.idSellableItems WHERE shopitems.idShop = ? ORDER BY price DESC LIMIT 1 OFFSET ?;", [this.id, idItem - 1]);
        }

        return res != null && res[0] != null ? res[0].idSellableItems : 0;
    }

    /**
     * 
     * @param {number} idItem 
     * @returns {ShopItem}
     */
    async getItem(idItem) {
        let trueID = await this.getTrueID(idItem);
        if (trueID > 0) {
            let item = new ShopItem(trueID);
            await item.load();
            return item;
        }
        return null;
    }





}

module.exports = Shop;