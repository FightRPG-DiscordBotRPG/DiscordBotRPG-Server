'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Monstre = require("./Monstre");

class MonstreGroup  {

    constructor() {
        /**
         * @type {Array<number>}
         */
        this.monstersIDs = [];
        this.enemiesObjetsToFight = [];

        // Maximum here so we dont have to seek every time
        this.avglevel = 0;
        this.name = "";
        this.type = "";
        this.numberOfMonsters = 0;
    }

    /**
     * 
     * @param {Array<Monstre>} listMonster 
     */
    setMonsters(listMonster) {
        this.avglevel = 0;
        let highestType = 0;
        let indexTo = 0;
        for (let i in listMonster) {
            if (Globals.monstersIds[listMonster[i].type] > highestType) {
                highestType = Globals.monstersIds[listMonster[i].type];
                indexTo = i;
            }


            this.avglevel += listMonster[i].avglevel * listMonster[i].number;
            this.numberOfMonsters += listMonster[i].number;
            this.monstersIDs.push(listMonster[i].id);
            this.enemiesObjetsToFight.push({ id: listMonster[i].id, number: listMonster[i].number });

        }
        this.name = listMonster[indexTo].name;
        this.type = listMonster[indexTo].type;
        this.avglevel = Math.round(this.avglevel / this.numberOfMonsters);
    }

    getMonstersIDs() {
        return this.monstersIDs;
    }

    getMonsters() {
        return this.enemiesObjetsToFight;
    }








    

}

module.exports = MonstreGroup;
