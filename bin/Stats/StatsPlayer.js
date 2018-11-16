'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals.js");
const Stats = require("./Stats.js");
const Translator = require("../Translator/Translator");


class StatsPlayer extends Stats {

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        super(id, id);
    }

    toStr(otherStats, lang) {
        let str = "```";
        let count = 1;
        let totalSpaces = 25;
        for (let stat in Globals.statsIds) {
            //let end = stat === "luck" ? "" : "   |   ";
            let end = "";
            let beforeNumber = "";
            let statStr = "";
            let statLocaleString = Translator.getString(lang, "stats", stat);
            if (stat !== "armor") {
                statStr = this[stat].toString() + "+" + otherStats[stat].toString();
            } else {
                statStr = otherStats[stat].toString();
            }

            let nbrChar = statLocaleString.length + 2;
            let lessSpaces = totalSpaces - nbrChar - (2 + statStr.length);
            beforeNumber += " ".repeat(lessSpaces);
            if (count === 2) {
                end += "\n"
                count = 0;
            } else {

                end += " ".repeat(3) + "|" + " ".repeat(3);
            }
            count++;
            str += "" + statLocaleString + beforeNumber + "[" + statStr + "]" + end;
        }
        str += "```"
        return str;
    }

    // Reset
    reset() {
        for (let stat in Globals.statsIds) {
            this[stat] = 0;
            conn.query("UPDATE statscharacters SET value = ? WHERE idStat = ? AND idCharacter = ?;", [this[stat], Globals.statsIds[stat], this.id]);
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
        let res = conn.query("SELECT DISTINCT value, nom FROM statscharacters INNER JOIN stats ON statscharacters.idStat = stats.idStat WHERE idCharacter = ?;", [this.id]);
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

module.exports = StatsPlayer;