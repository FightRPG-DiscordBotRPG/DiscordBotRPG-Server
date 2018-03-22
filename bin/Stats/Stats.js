'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals.js");

class Stats {

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        this.id = id;
        this.force = 0;
        this.intelligence = 0;
        this.constitution = 0;
        this.armor = 0;
        this.dexterite = 0;
        this.charisme = 0;
        this.sagesse = 0;
        this.volonte = 0;
        this.perception = 0;
        this.luck = 0;
    }

    toStr() {
        let str = "```"
        for (let stat in Globals.statsIds) {
            //let end = stat === "luck" ? "" : "   |   ";
            let end = "";
            let beforeNumber = "";

            let nbrChar = stat.length + 2;
            let lessSpaces = totalSpaces - nbrChar;
            beforeNumber += " ".repeat(lessSpaces);
            if (count === 2) {
                end += "\n"
                count = 0;
            } else {

                end += " ".repeat(3) + "|" + " ".repeat(3);
            }
            count++;
            str += "" + stat + beforeNumber + end;
        }
        str += "```"
        return str;
    }

}

module.exports = Stats;
