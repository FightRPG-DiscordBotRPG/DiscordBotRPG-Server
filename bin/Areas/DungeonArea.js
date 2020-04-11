'use strict';
const Area = require("./Area");
const Globals = require("../Globals");

class DungeonArea extends Area {

    constructor(id) {
        super(id, id);
        this.fightPossible = true;
        this.authorizedBonuses = ["xp_fight", "xp_collect", "gold_drop", "item_drop", "collect_drop"];
    }

    isFirstFloor() {
        if (this.paths.from[0]) {
            return Globals.areasManager.getArea(this.paths.from[0]).constructor !== DungeonArea;
        }
        return false;
    }

    getEntrance() {
        let area = this;
        while (Globals.areasManager.getArea(area.paths.from[0]).constructor === DungeonArea) {
            area = Globals.areasManager.getArea(area.paths.from[0]);
        }
        return Globals.areasManager.getArea(area.paths.from[0]);
    }

    getNextFloorOrExit() {
        return Globals.areasManager.getArea(this.paths.to[0]);
    }
}

module.exports = DungeonArea;