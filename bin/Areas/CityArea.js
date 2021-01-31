'use strict';
const conn = require("../../conf/mysql.js");
const Area = require("./Area");
const Marketplace = require("../Marketplace/Marketplace");
const CraftingBuilding = require("../CraftSystem/CraftingBuilding");
const Shop = require("../Shops/Shop");

class CityArea extends Area {

    constructor(id) {
        super(id, id);
        this.services = {
            "marketplace": new Marketplace(),
            "craftingbuilding": new CraftingBuilding(),
            "shop": null,
        }

        this.authorizedBonuses = ["xp_craft"];

        this.minItemRarityId = 0;
        this.maxItemRarityId = 0;
    }

    async loadArea() {
        await super.loadArea();
        await Promise.all([
            this.services.marketplace.loadMakerplace(this.id),
            this.services.craftingbuilding.load(this.id),
        ]);

        let res = await conn.query("SELECT idShop FROM areasshops WHERE idArea = ?;", [this.id]);
        if (res[0] != null) {
            this.services.shop = new Shop(res[0].idShop);
        }
    }

    async toApi(lang) {
        let apiObj = await super.toApi(lang);
        let craftingbuilding = this.getService("craftingbuilding");
        let shopbuilding = this.getService("shop");
        let minLevel = 0,
            maxLevel = 0,
            isActive = false,
            tax = 0;
        if (craftingbuilding != null) {
            minLevel = craftingbuilding.getMinLevel();
            maxLevel = craftingbuilding.getMaxLevel();
            isActive = craftingbuilding.isActive == true;

        }
        apiObj.craft = {
            isActive: isActive,
            minLevel: minLevel,
            maxLevel: maxLevel,
        }

        apiObj.marketplace = {
            tax: this.services.marketplace.getTax() * 100,
            isActive: true,
        }

        isActive = false;

        if (shopbuilding != null) {
            isActive = await shopbuilding.isActive();
            tax = await shopbuilding.getTax() * 100;
        }

        apiObj.shop = {
            isActive: isActive,
            tax: tax,
        }
        return apiObj;
    }


}



module.exports = CityArea;