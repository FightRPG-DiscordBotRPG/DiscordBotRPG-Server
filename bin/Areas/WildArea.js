'use strict';
const Area = require("./Area");

class WildArea extends Area {

    constructor(id) {
        super(id, id);
        this.fightPossible = true;
        this.authorizedBonuses = ["xp_fight", "xp_collect", "gold_drop", "item_drop", "collect_drop"];
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