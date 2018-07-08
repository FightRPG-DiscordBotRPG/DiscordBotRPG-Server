'use strict';
const conn = require("../conf/mysql.js");
const StatsMonstres = require("./Stats/StatsMonstres");
const Globals = require("./Globals.js");
const WorldEntity = require("./WorldEntity.js");

class Monstre extends WorldEntity {

    constructor(id) {
        super();
        this._type = "Monster";


        this.id = id;
        this.name = "";
        this.actualHP = 0;
        this.maxHP = 0;
        this.level = 0;
        this.xp = 0;
        this.money = 0;
        this.luckBonus = 0;
        this.stats = new StatsMonstres();
        this.difficulty = {};
        this.type = "";

        // Functions
        this.loadMonster();

    }


    loadMonster() {
        let tDifficulty = Math.floor(Math.random() * (4 - 0) + 0);
        this.difficulty = Globals.mDifficulties[tDifficulty];
        let res = conn.query("SELECT DISTINCT name, avglevel, nom FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType WHERE idMonstre = " + this.id)[0];
        let bonus = 1;
        this.type = res["nom"];

        if (this.type == "elite") {
            bonus = 2;
            this.luckBonus = 40;
            this.stats.loadStat(this.id, 1.3);
        } else if (this.type == "normal") {
            this.stats.loadStat(this.id, this.difficulty.value);
        } else if (this.type == "boss") {
            bonus = 10;
            this.luckBonus = 120;
            this.stats.loadStat(this.id, 2);
        }




        this.level = res["avglevel"];
        this.name = res["name"];
        this.updateStats();
        this.xp = Math.round((10 * (Math.pow(this.level, 2))) / 6 * bonus);
        this.money = Math.round((Math.random() * (this.level * 2 - this.level) + this.level) * bonus);
    }

}

module.exports = Monstre;
