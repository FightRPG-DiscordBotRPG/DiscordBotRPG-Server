'use strict';
const conn = require("../../conf/mysql.js");
const WildArea = require("./WildArea.js");
const CityArea = require("./CityArea.js");
const Globals = require("../Globals.js");
const Discord = require("discord.js");

class AreasManager {

    constructor() {
        this.areas = new Map();
        this.loadAreas();
    }

    loadAreas() {
        let res = conn.query("SELECT idArea, NomAreaType FROM areas INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType ORDER BY AreaLevels ASC");
        for (let i in res) {
            switch (res[i].NomAreaType) {
                case "Wild":
                    this.areas.set(res[i].idArea, new WildArea(res[i].idArea));
                    break;
                case "City":
                    this.areas.set(res[i].idArea, new CityArea(res[i].idArea));
                    break;
            }
            
        }
    }

    canIFightThisMonster(idArea, idEnemy, perception) {
        let res = conn.query("SELECT idMonstre FROM AreasMonsters WHERE idArea = " + idArea + " AND idMonstre = " + idEnemy);
        if (res.length > 0) {
            let bonus = 1 + (perception / 100);
            let chance = Math.random();
            if (chance <= Globals.chanceToFightTheMonsterYouWant * bonus) {
                return true;
            }
        }

        return false;
    }

    selectRandomMonsterIn(idArea, idEnemy) {
        let res = conn.query("SELECT idMonstre FROM AreasMonsters WHERE idArea = " + idArea + " AND NOT idMonstre = " + idEnemy + " ORDER BY RAND() LIMIT 1;");
        if (res.length > 0) {
            return res[0]["idMonstre"];
        }
        return 1;
    }

    // Return string embed discord
    seeThisArea(idArea) {
        return this.areas.get(idArea).toStr();
    }

    seeAllAreas() {
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
                case "Wild":
                    str += this.areas.get(key).id + " | " + this.areas.get(key).name + " | Niveaux : " + this.areas.get(key).levels + "\n";
                    break;
                case "City":
                    str += this.areas.get(key).id + " | " + this.areas.get(key).name + " (Ville) | Niveau : " + this.areas.get(key).levels + "\n";
                    break;
            }

        }
        str += "```";
        return str;
    }

    canISellToThisArea(idArea) {
        if (this.areas.get(idArea).areaType == "City") {
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

    // Update nbr players when a player travel to another location
    updateTravel(from, to) {
        this.areas.get(from).nbrPlayers -= 1;
        this.areas.get(to).nbrPlayers += 1;
    }

    // Single Getters for an area

    getNameOf(idArea) {
        return this.areas.get(idArea).name;
    }

    getPlayersOf(idArea, page, connectedUsers) {
        return this.areas.get(idArea).getPlayers(page, connectedUsers);
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


}

module.exports = AreasManager;
