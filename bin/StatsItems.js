'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");

class StatsItems {

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
        this.loadStats();
    }

    // Load from DB

    loadStats() {
        // load from database
        let res = conn.query("SELECT DISTINCT value, nom FROM itemsstats INNER JOIN stats ON itemsstats.idStat = stats.idStat WHERE idItem = " + this.id);
        for (let stat in res) {
            this[res[stat].nom] = res[stat].value;
        }
    }

    deleteStats() {
        conn.query("DELETE FROM itemsstats WHERE idItem = " + this.id + ";");
    }

    toStr() {
        let str = "```";
        let count = 1;
        let totalSpaces = 25;
        let noStats = true;
        for (let stat in Globals.statsIds) {
            if (this[stat] > 0) {
                noStats = false;
                let end = "";
                let beforeNumber = "";
                let statStr = this[stat].toString();
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
                str += "" + stat + beforeNumber + "[" + this[stat] + "]" + end;
            }

        }
        if (noStats) {
            str += "Cet objet n'a pas de stats !";
        }
        str += "```";
        return str;
    }

}

module.exports = StatsItems;
