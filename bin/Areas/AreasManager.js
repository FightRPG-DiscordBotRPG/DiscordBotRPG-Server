'use strict';
const conn = require("../../conf/mysql.js");
const WildArea = require("./WildArea.js");
const CityArea = require("./CityArea.js");
const DungeonArea = require("./DungeonArea");
const Globals = require("../Globals.js");
const Discord = require("discord.js");
const Translator = require("../Translator/Translator");
const Graph = require('node-dijkstra');
const Region = require("./Region");


class AreasManager {


    constructor() {
        this.areas = new Map();
        this.regions = {};
        this.paths = new Graph();

        this.loadRegions();
        this.loadAreas();
        this.loadPaths();
    }

    loadRegions() {
        let res = conn.query("SELECT idRegion FROM regions");
        for(let region of res) {
            this.regions[region.idRegion] = new Region(region.idRegion);
        }
    }

    loadAreas() {
        let res = conn.query("SELECT areas.idArea, NomAreaType, idRegion FROM areas INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType INNER JOIN areasregions ON areasregions.idArea = areas.idArea ORDER BY AreaLevels ASC");
        for (let i in res) {
            switch (res[i].NomAreaType) {
                case "wild":
                    this.areas.set(res[i].idArea, new WildArea(res[i].idArea));
                    break;
                case "city":
                    this.areas.set(res[i].idArea, new CityArea(res[i].idArea));
                    break;
                case "dungeon":
                    this.areas.set(res[i].idArea, new DungeonArea(res[i].idArea));
                    break;
            }
            this.regions[res[i].idRegion].addArea(this.areas.get(res[i].idArea));
        }

    }

    loadPaths() {
        let res = conn.query("SELECT DISTINCT idArea1 FROM areaspaths");
        for(let area of res) {
            let paths = conn.query("SELECT * FROM areaspaths WHERE idArea1 = ?", [area.idArea1]);
            let node = {};
            for(let path of paths) {
                //console.log(path.idArea1 + " -> " + path.idArea2 + " | cost : " + path.time);
                node[path.idArea2] = path.time;
            }
            this.paths.addNode(area.idArea1.toString(), node);
        }
    }

    /**
     * 
     * @param {string} from 
     * @param {string} to 
     */
    getPathCosts(from, to) {
        let path = this.paths.path(from.toString(), to.toString(), {cost:true});
        
        let toReturn = {
            timeToWait : path.cost,
            goldPrice : 0
        }
        /*console.log(from + " -> " + to);
        console.log(toReturn);*/
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
        //let res = conn.query("SELECT idMonstre FROM AreasMonsters WHERE idArea = " + idArea + " AND idMonstre = " + idEnemy);
        let monsterID = this.areas.get(idArea).getMonsterId(idEnemy);
        if (monsterID) {
            let bonus = 1 + (perception / 100);
            let chance = Math.random();
            if (chance <= Globals.chanceToFightTheMonsterYouWant * bonus) {
                return true;
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
        /*let res = conn.query("SELECT idMonstre FROM AreasMonsters WHERE idArea = " + idArea + " AND NOT idMonstre = " + idEnemy + " ORDER BY RAND() LIMIT 1;");
        if (res.length > 0) {
            return res[0]["idMonstre"];
        }
        return 1;*/
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

    /**
     * 
     * @param {number} idArea 
     * @param {string} lang 
     */
    seeThisArea(idArea, lang) {
        return this.areas.get(idArea).toStr(lang);
    }

    /**
     * 
     * @param {number} idArea 
     * @param {string} lang 
     */
    seeConquestOfThisArea(idArea, lang) {
        return this.areas.get(idArea).conquestToStr(lang);
    }

    seeAllAreas(lang) {
        let str = "```";

        // No Map
        /*for (let i in this.areas) {
            console.log(i);
            switch (this.areas[i].areaType) {
                case "Wild":
                    str += this.areas[i].id + " | " + this.areas[i].name + " | Niveaux : " + this.areas[i].levels + "\n";
                    break;
                case "City":
                    str += this.areas[i].id + " | " + this.areas[i].name + " (Ville) | Niveaux : " + this.areas[i].levels + "\n";
                    break;
            }

        }*/
        //console.log(this.areas.);
        // Map
        for (let [key, value] of this.areas) {
            switch (this.areas.get(key).areaType) {
                case "wild":
                    //str += this.areas.get(key).id + " | " + this.areas.get(key).name + " | Niveaux : " + this.areas.get(key).levels + "\n";
                    str += Translator.getString(lang, "area", "wild_area", [this.areas.get(key).id, this.areas.get(key).getName(lang), this.areas.get(key).levels]) + "\n";
                    break;
                case "city":
                    //str += this.areas.get(key).id + " | " + this.areas.get(key).name + " (Ville) | Niveau : " + this.areas.get(key).levels + "\n";
                    str += Translator.getString(lang, "area", "city_area", [this.areas.get(key).id, this.areas.get(key).getName(lang), this.areas.get(key).levels]) + "\n";
                    break;
                case "dungeon":
                    str += Translator.getString(lang, "area", "dungeon_area", [this.areas.get(key).id, this.areas.get(key).getName(lang), this.areas.get(key).levels]) + "\n";
                    break;
            }

        }
        str += "```";

        return new Discord.RichEmbed()
        .setColor([0, 255, 0])
        .setAuthor(Translator.getString(lang, "area", "areas"))
        .addField(Translator.getString(lang, "area", "list"), str)
        .setImage("https://image.ibb.co/nKdAGK/map_base.png");
    }

    seeAllAreasInThisRegion(area, lang) {
        return this.regions[area.idRegion].seeAreas(lang);
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

    // Single Getters for an area

    getNameOf(idArea, lang) {
        return this.areas.get(idArea).getName(lang);
    }

    getPlayersOf(idArea, page, lang) {
        return this.areas.get(idArea).getPlayers(page, lang);
    }

    getResources(idArea) {
        return this.areas.get(idArea).getResources();
    }
    getResource(idArea, index) {
        return this.areas.get(idArea).getResource(index);
    }

    /*
    *   CONQUEST
    */
    claim(idArea, idGuild) {
        return this.areas.get(idArea).claim(idGuild);
    }

    unclaimAll(idGuild) {
        for (let [key, value] of this.areas) {
            if (this.areas.get(key).owner == idGuild) {
                this.areas.get(key).unclaim();
            }
        }
    }

    haveOwner(idArea) {
        return this.areas.get(idArea).haveOwner();
    }

    getArea(idArea) {
        return this.areas.get(idArea);
    }

    /*
     * API
     */
    toApi(actualArea) {
        let areas = {};
        for (let i in Globals.areasTypes) {
            areas[Globals.areasTypes[i]] = [];
        }

        for (let [key, value] of this.areas) {
            areas[this.areas.get(key).areaType].push(this.areas.get(key).toApiLight());
            if (key == actualArea) {
                areas[this.areas.get(key).areaType][areas[this.areas.get(key).areaType].length - 1].actual = true;
            } else {
                areas[this.areas.get(key).areaType][areas[this.areas.get(key).areaType].length - 1].actual = false;
            }
        }
        return areas;
    }

    toApiThisAreaFull(idArea) {
        if (this.areas.get(idArea)) {
            return this.areas.get(idArea).toApiFull();
        }
        return null;
    }


}

module.exports = AreasManager;
