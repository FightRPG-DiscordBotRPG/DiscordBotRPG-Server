'use strict';
const Area = require("./Area");
const Globals = require("../Globals");
const conn = require("../../conf/mysql");

class DungeonArea extends Area {

    constructor(id) {
        super(id, id);
        this.fightPossible = true;
        this.authorizedBonuses = ["xp_fight", "xp_collect", "gold_drop", "item_drop", "collect_drop"];

        this.minItemRarityName = "legendary";
        this.minItemRarityId = 5;

        this.maxItemRarityName = "legendary";
        this.maxItemRarityId = 5;

        this.entranceCacheValue = null;
        this.nextFloorOrExitCacheValue = null;
    }


    async isFirstFloor() {

        if (this.isFirstFloorCacheValue !== null) {
            return this.isFirstFloorCacheValue;
        }

        let res = await conn.query("SELECT * FROM areaspaths INNER JOIN areas ON areas.idArea = areaspaths.idArea1 WHERE idArea2 = ?", [this.id]);
        for (let item of res) {
            if (item.idAreaType !== 3) {
                this.isFirstFloorCacheValue = true;
                return true;
            }
        }

        this.isFirstFloorCacheValue = false;
        return false;
    }

    async isLastFloor() {

        if (this.isLastFloorCacheValue !== null) {
            return this.isLastFloorCacheValue;
        }

        let res = await conn.query("SELECT * FROM areaspaths INNER JOIN areas ON areas.idArea = areaspaths.idArea2 WHERE idArea1 = ?", [this.id]);
        for (let item of res) {
            if (item.idAreaType === 3) {
                this.isLastFloorCacheValue = false;
                return false;
            }
        }


        this.isLastFloorCacheValue = true;
        return true;
    }

    async getEntrance() {

        if (this.entranceCacheValue !== null) {
            return this.entranceCacheValue;
        }

        let area = this;
        while (Globals.areasManager.getArea(area.paths.from[0]).constructor === DungeonArea && !(await Globals.areasManager.getArea(area.paths.from[0]).isFirstFloor())) {
            area = Globals.areasManager.getArea(area.paths.from[0]);
        }
        this.entranceCacheValue = Globals.areasManager.getArea(area.paths.from[0]);
        return this.entranceCacheValue;
    }

    async getNextFloorOrExit() {

        if (this.nextFloorOrExitCacheValue !== null) {
            return this.nextFloorOrExitCacheValue;
        }

        if (this.paths.to.length === 1) {
            let possibleReturnArea = Globals.areasManager.getArea(this.paths.to[0]);
            if (possibleReturnArea instanceof DungeonArea) {
                this.nextFloorOrExitCacheValue = possibleReturnArea;
                return possibleReturnArea;
            } else {
                // If not dungeon returns first floor instead of end area
                // Temp fix to get players to always returns to first floor
                this.nextFloorOrExitCacheValue = await this.getEntrance();
                return this.nextFloorOrExitCacheValue;
            }
        } else {
            let areaToReturn = Globals.areasManager.getArea(this.paths.to[0]);
            for (let idArea of this.paths.to) {
                areaToReturn = Globals.areasManager.getArea(idArea)
                if (areaToReturn.constructor === DungeonArea) {
                    this.nextFloorOrExitCacheValue = areaToReturn;
                    return areaToReturn;
                }
            }

            this.nextFloorOrExitCacheValue = areaToReturn;
            return areaToReturn;
        }
    }

    async canTravelTo() {
        return await this.isFirstFloor();
    }
}

module.exports = DungeonArea;