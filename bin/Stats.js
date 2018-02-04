'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");

class Stats {

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        // recherche base de donn�e
        this.id = id;
        this.force = 0;
        this.intelligence = 0;
        this.constitution = 0;
        this.defense = 0;
        this.dexterite = 0;
        this.charisme = 0;
        this.sagesse = 0;
        this.volonte = 0;
        this.perception = 0;
        this.luck = 0;
    }

    toStr(otherStats) {
        let str = "```";
        let count = 1;
        let totalSpaces = 25;
        for (let stat in Globals.statsIds) {
            //let end = stat === "luck" ? "" : "   |   ";
            let end = "";
            let beforeNumber = "";
            let statStr = "";
            if (stat !== "defense") {
                statStr = this[stat].toString() + "+" + otherStats[stat].toString();
            } else {
                statStr = otherStats[stat].toString();
            }
            
            let nbrChar = stat.length + 2;
            let lessSpaces = totalSpaces - nbrChar - (2 + statStr.length);
            beforeNumber += " ".repeat(lessSpaces);
            if (count === 2) {
                end += "\n"
                count = 0;
            } else {
                
                end += " ".repeat(3) + "|" + " ".repeat(3);
            }
            count++;
            str += "" + stat + beforeNumber + "[" + statStr + "]" + end;
        }
        str += "```"
        return str;
    }

    // Reset
    reset() {
        for (let stat in Globals.statsIds) {
            this[stat] = 0;
            conn.query("UPDATE statscharacters SET value = " + this[stat] + " WHERE idStat = " + Globals.statsIds[stat] + " AND idCharacter = " + this.id);
        }
    }

    // Save to DB
    saveStat() {
        for (let stat in Globals.statsIds) {
            //console.log(this[stat] + " " + Globals.statsIds[stat] + " " + this.id + "\n");
            conn.query("UPDATE statscharacters SET value = " + this[stat] + " WHERE idStat = " + Globals.statsIds[stat] + " AND idCharacter = " + this.id);
        }
    }

    saveThisStat(stat) {
        conn.query("UPDATE statscharacters SET value = " + this[stat] + " WHERE idStat = " + Globals.statsIds[stat] + " AND idCharacter = " + this.id);
    }

    // Load from DB
    loadStat(id) {
        this.id = id;
        let res = conn.query("SELECT DISTINCT value, nom FROM statscharacters INNER JOIN stats ON statscharacters.idStat = stats.idStat WHERE idCharacter = " + this.id);
        for (let stat in res) {
            this[res[stat].nom] = parseInt(res[stat].value, 10);
        }
    }

    // New Stat if not exist
    init(id) {
        for (let i = 1; i <= Globals.maxStatsId; ++i) {
            conn.query("INSERT INTO statscharacters VALUES (" + id + ", " + i + ", 0)");
        }
        this.loadStat(id);
    }

}

module.exports = Stats;
