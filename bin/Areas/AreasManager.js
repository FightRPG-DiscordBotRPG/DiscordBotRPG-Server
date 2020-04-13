'use strict';
const conn = require("../../conf/mysql.js");
const WildArea = require("./WildArea.js");
const CityArea = require("./CityArea.js");
const DungeonArea = require("./DungeonArea");
const Globals = require("../Globals.js");
const Translator = require("../Translator/Translator");
const Graph = require('node-dijkstra');
const Region = require("./Region");
const Area = require("./Area");
const Achievements = require("../Achievement/Achievements");


class AreasManager {


    constructor() {
        /**
         * @type {Map<Number, Area>}
         * */
        this.areas = new Map();
        /**
         * @type {Array<Region>}
         **/
        this.regions = {};
        this.paths = new Graph();
        this.pathsGoldCosts = new Graph();
        this.pathsAchievementsNeededCost = new Graph();
    }

    async loadAreasManager() {
        await this.loadRegions();
        await this.loadAreas();
        await this.loadPaths();
        await this.loadConnectedAreas();
    }

    async loadConnectedAreas() {
        for (let rk of Object.keys(this.regions)) {
            let res = await conn.query("SELECT idArea2 as idArea FROM areaspaths WHERE areaspaths.idArea1 IN (SELECT idArea FROM areasregions WHERE areasregions.idRegion = ?) AND areaspaths.idArea2 NOT IN (SELECT idArea FROM areasregions WHERE areasregions.idRegion = ?)", [rk, rk]);
            for (let find of res) {
                this.regions[rk].addConnectedArea(this.areas.get(find.idArea));
            }
        }
    }

    async loadRegions() {
        let res = await conn.query("SELECT idRegion FROM regions");
        for (let region of res) {
            this.regions[region.idRegion] = new Region(region.idRegion);
        }
    }

    async loadAreas() {
        let res = await conn.query("SELECT areas.idArea, NomAreaType, idRegion FROM areas INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType INNER JOIN areasregions ON areasregions.idArea = areas.idArea INNER JOIN areasmonsterslevels ON areasmonsterslevels.idArea = areas.idArea ORDER BY areasmonsterslevels.minLevel ASC, areasmonsterslevels.maxLevel ASC, idArea");
        let area;
        for (let i in res) {
            switch (res[i].NomAreaType) {
                case "wild":
                    area = new WildArea(res[i].idArea);
                    break;
                case "city":
                    area = new CityArea(res[i].idArea);
                    break;
                case "dungeon":
                    area = new DungeonArea(res[i].idArea);
                    break;
            }
            await area.loadArea();
            this.areas.set(res[i].idArea, area);
            this.regions[res[i].idRegion].addArea(this.areas.get(res[i].idArea));
        }
    }

    async loadPaths() {
        let res = await conn.query("SELECT DISTINCT idArea FROM areas");

        // Need to load paths from each areas before doing nodes for path travel system

        for (let area of res) {
            // Adding id areas to area1 paths (used to know what areas are connected => example for dungeons to know if first floor)
            // Doing a request to get paths from for areas
            let pathsFrom = await conn.query("SELECT * FROM areaspaths WHERE idArea2 = ?", [area.idArea]);
            for (let path of pathsFrom) {
                this.getArea(area.idArea).paths.from.push(path.idArea1);
            }

            let pathsTo = await conn.query("SELECT * FROM areaspaths WHERE idArea1 = ?", [area.idArea]);
            for (let path of pathsTo) {
                this.getArea(area.idArea).paths.to.push(path.idArea2);
            }


        }

        for (let area of res) {
            let pathsTo = await conn.query("SELECT * FROM areaspaths WHERE idArea1 = ?", [area.idArea]);
            let node = {};
            let nodeGold = {};
            let nodeAchievements = {};
            for (let path of pathsTo) {
                //console.log(path.idArea1 + " -> " + path.idArea2 + " | cost : " + path.time);
                if (this.getArea(path.idArea2).canTravelTo()) {
                    node[path.idArea2] = path.time;
                    nodeGold[path.idArea2] = path.goldPrice + 1;

                    let achievementsNeeded = await conn.query("SELECT idAchievement FROM areasrequirements WHERE idArea = ?;", [area.idArea]);
                    if (achievementsNeeded.length > 0) {
                        nodeAchievements[path.idArea2] = 2;
                    } else {
                        nodeAchievements[path.idArea2] = 1;
                    }
                } else {
                    console.log(this.getArea(path.idArea2));
                }

            }

            // Add it only if you can travel to area (example for not working travel: dungeon that is not first room)
            //if (this.getArea(area.idArea).canTravelTo()) {
                this.paths.addNode(area.idArea.toString(), node);
                this.pathsGoldCosts.addNode(area.idArea.toString(), nodeGold);
                this.pathsAchievementsNeededCost.addNode(area.idArea.toString(), nodeAchievements);
            //}




            //if (area.idArea1 === 7) {
            //    console.log(this.getArea(area.idArea1).getEntrance());
            //}
        }
    }

    /**
     * 
     * @param {string} from 
     * @param {string} to 
     */
    async getPathCosts(from, to) {
        let path = this.paths.path(from.toString(), to.toString(), {
            cost: true
        });
        let pathGold = this.pathsGoldCosts.path(from.toString(), to.toString(), {
            cost: true
        });
        let pathAchievement = this.pathsAchievementsNeededCost.path(from.toString(), to.toString(), { cost: true });

        let achievementsNeeded = [];

        // Somehow the node ignore the TO area
        achievementsNeeded = achievementsNeeded.concat(this.getArea(to).getRequiredAchievements());

        if (pathAchievement.cost - pathAchievement.path.length === 0) {
            for (let idArea of pathAchievement.path) {
                idArea = parseInt(idArea);
                // But don't ignore the FROM so we need to ignore it, it will be bad to stuck a player in an area
                if (idArea !== from) {
                    achievementsNeeded = achievementsNeeded.concat(this.getArea(idArea).getRequiredAchievements());
                }
            }
        }

        let toReturn = {
            timeToWait: path.cost,
            goldPrice: pathGold.cost - (pathGold.path.length - 1),
            neededAchievements: await achievementsNeeded
}

        return toReturn;
    }

    /**
     * 
     * @param {number} idArea 
     * @param {number} idEnemy 
     * @param {number} perception 
     * @returns {boolean}
     */
    canIFightThisMonster(idArea, idEnemy, perception) {
        let area = this.areas.get(idArea);
        if (area.areaType === "dungeon") {
            return true;
        } else {
            let monsterID = this.areas.get(idArea).getMonsterId(idEnemy);
            if (monsterID) {
                let bonus = 1 + (perception / 100);
                let chance = Math.random();
                if (chance <= Globals.chanceToFightTheMonsterYouWant * bonus) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * 
     * @param {number} idArea 
     * @param {string} serviceName 
     */
    getService(idArea, serviceName) {
        return this.areas.get(idArea).getService(serviceName);
    }

    /**
     * 
     * @param {number} idArea 
     * @param {number} idEnemy 
     */
    selectRandomMonsterIn(idArea, idEnemy) {
        return this.areas.get(idArea).getRandomMonster(idEnemy);
    }

    /**
     * 
     * @param {number} idArea 
     * @param {number} idEnemy 
     */
    getMonsterIdIn(idArea, idEnemy) {
        return this.areas.get(idArea).getMonsterId(idEnemy);
    }

    async thisAreaToApi(idArea, lang) {
        let area = this.areas.get(idArea)
        return await area.toApi(lang);
    }

    async thisRegionToApi(currentArea, lang) {
        return await this.regions[currentArea.idRegion].toApi(lang);
    }

    canISellToThisArea(idArea) {
        if (this.areas.get(idArea).areaType == "city") {
            return true;
        }
        return false;
    }

    canIFightInThisArea(idArea) {
        return this.areas.get(idArea).canIFightHere();
    }

    exist(idArea) {
        if (this.areas.get(idArea)) {
            return true;
        }
        return false;
    }

    existInRegion(idRegion, index) {
        if (this.regions[idRegion]) {
            return this.regions[idRegion].exist(index);
        }
        return false;
    }

    isConnectedToRegion(idRegion, index) {
        if (this.regions[idRegion]) {
            return this.regions[idRegion].isConnected(index);
        }
        return false;
    }

    // Single Getters for an area

    getNameOf(idArea, lang) {
        return this.areas.get(idArea).getName(lang);
    }

    async getPlayersOf(idArea, page, lang) {
        let area = this.areas.get(idArea);
        return await area.getPlayers(page, lang);
    }

    getResources(idArea) {
        return this.areas.get(idArea).getResources();
    }

    getResource(idArea, index) {
        return this.areas.get(idArea).getResource(index);
    }

    getAreaForThisRegion(idRegion, index) {
        return this.regions[idRegion].getArea(index);
    }

    getConnectedAreaForThisRegion(idRegion, index) {
        return this.regions[idRegion].getConnectedArea(index);
    }

    /*
     *   CONQUEST
     */
    async claim(idArea, idGuild) {
        let area = this.areas.get(idArea);
        return await area.claim(idGuild);
    }

    async unclaimAll(idGuild) {
        for (let [key, value] of this.areas) {
            if (this.areas.get(key).owner == idGuild) {
                let area = this.areas.get(key);
                await area.unclaim();
            }
        }
    }

    async haveOwner(idArea) {
        let area = this.areas.get(idArea);
        return await area.haveOwner();
    }

    /**
     * 
     * @param {any} idArea
     * @returns {Area | CityArea | DungeonArea | WildArea}
     */
    getArea(idArea) {
        return this.areas.get(idArea);
    }

    /*
     * API
     */
    async toApi(actualArea) {
        let areas = {};
        for (let i in Globals.areasTypes) {
            areas[Globals.areasTypes[i]] = [];
        }

        for (let [key, value] of this.areas) {
            let area = this.areas.get(key);
            areas[this.areas.get(key).areaType].push(await area.toApiLight());
            if (key == actualArea) {
                areas[this.areas.get(key).areaType][areas[this.areas.get(key).areaType].length - 1].actual = true;
            } else {
                areas[this.areas.get(key).areaType][areas[this.areas.get(key).areaType].length - 1].actual = false;
            }
        }
        return areas;
    }

    async toApiThisAreaFull(idArea) {
        if (this.areas.get(idArea)) {
            let area = this.areas.get(idArea);
            return await area.toApiFull();
        }
        return null;
    }


}

module.exports = AreasManager;