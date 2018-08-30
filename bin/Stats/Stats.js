'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals.js");

class Stats {

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        this.id = id;
        this.strength = 0;
        this.intellect = 0;
        this.constitution = 0;
        this.armor = 0;
        this.dexterity = 0;
        this.charisma = 0;
        this.wisdom = 0;
        this.will = 0;
        this.perception = 0;
        this.luck = 0;
    }

    getStat(statName) {
        if(this[statName] >= 0) {
            return this[statName];
        }
        return 0;
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

    toApi() {
        let r = {};
        let statsPossible = Object.keys(Globals.statsIds);
        for (let i in statsPossible) {
            r[statsPossible[i]] = this[statsPossible[i]];
        }
        return r;
    }


}

module.exports = Stats;
