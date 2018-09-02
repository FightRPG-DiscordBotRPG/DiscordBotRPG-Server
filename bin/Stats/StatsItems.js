'use strict';
const conn = require("../../conf/mysql.js");
const Stats = require("./Stats.js");
const Globals = require("../Globals.js");
const Translator = require("../Translator/Translator");

class StatsItems extends Stats{

    constructor(id) {
        super(id, id);
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

    toStr(compareStats, lang) {
        let str = "```";
        let count = 1;
        let totalSpaces = 30;
        let noStats = true;
        compareStats = compareStats != undefined ? compareStats : {};
        for (let stat in Globals.statsIds) {
            if (this[stat] > 0 || compareStats[stat]) {
                let diff = compareStats[stat] >= 0 ? " -> " + (this[stat] - compareStats[stat]) : " -> 0";
                
                noStats = false;
                let end = "";
                let beforeNumber = "";
                let statStr = this[stat].toString();
                let statLocalized = Translator.getString(lang, "stats", stat);
                let nbrChar = statLocalized.length + 2 + diff.length;
                let lessSpaces = totalSpaces - nbrChar - (2 + statStr.length);
                beforeNumber += " ".repeat(lessSpaces);
                if (count === 2) {
                    end += "\n"
                    count = 0;
                } else {

                    end += " ".repeat(1) + "|" + " ".repeat(1);
                }
                count++;
                str += "" + statLocalized + beforeNumber + "[" + this[stat] + diff + "]" + end;
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
