'use strict';
const Area = require("./Area");
const AreaBonus = require("./AreaBonus");

class WildArea extends Area {

    constructor(id) {
        super(id, id);        
        this.fightPossible = true;
        this.authorizedBonuses = [AreaBonus.identifiers.xpFight, AreaBonus.identifiers.xpCollect, AreaBonus.identifiers.goldDrop, AreaBonus.identifiers.itemDrop, AreaBonus.identifiers.collectDrop];
    }

    async loadItemsLootTable() {
        if (this.minLevel >= 20) {
            this.minItemRarityId = 3;
            this.minItemRarityName = "superior";
        }
        super.loadItemsLootTable();
    }
}

module.exports = WildArea;