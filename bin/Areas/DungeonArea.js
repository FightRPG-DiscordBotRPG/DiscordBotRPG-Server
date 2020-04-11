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
        if (this.paths.from.length >= 1) {
            if (this.paths.from.length === 1) {
                return Globals.areasManager.getArea(this.paths.from[0]).constructor !== DungeonArea;
            } else {
                let fromArea = Globals.areasManager.getArea(this.paths.from[0]);
                for (let idArea of this.paths.from) {
                    fromArea = Globals.areasManager.getArea(idArea)
                    if (fromArea.constructor !== DungeonArea) {
                        return true;
                    }
                }
            }
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
        if (this.paths.to.length === 1) {
            return Globals.areasManager.getArea(this.paths.to[0]);
        } else {
            let areaToReturn = Globals.areasManager.getArea(this.paths.to[0]);
            for (let idArea of this.paths.to) {
                areaToReturn = Globals.areasManager.getArea(idArea)
                if (areaToReturn.constructor === DungeonArea) {
                    return areaToReturn;
                }
            }
            return areaToReturn;
        }
    }

    canTravelTo() {
        return this.isFirstFloor();
    }
}

module.exports = DungeonArea;