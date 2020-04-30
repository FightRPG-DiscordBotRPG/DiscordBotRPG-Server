'use strict';
const conn = require("../../conf/mysql.js");
const StatsMonstres = require("../Stats/StatsMonstres");
const Globals = require("../Globals.js");
const WorldEntity = require("./WorldEntity.js");
const Translator = require("../Translator/Translator");

class Monstre extends WorldEntity {

    constructor(id) {
        super();
        this._type = "Monster";


        this.id = id;
        this.name = "g_monster";
        this.actualHP = 0;
        this.maxHP = 0;
        this.level = 0;
        this.xp = 0;
        this.money = 0;
        this.luckBonus = 0;
        this.stats = new StatsMonstres();
        this.difficulty = {};
        this.type = "";
    }


    async loadMonster(level=null) {
        this.difficulty = Globals.mDifficulties[2];
        let res = await conn.query("SELECT DISTINCT monstrestypes.idType, avglevel, nom FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType WHERE idMonstre = ?;", [this.id]);
        res = res[0];
        let bonus = 1;
        this.type = res["nom"];
        this.level = level && level > 0 ? level : (res["avglevel"] > 0 ? res["avglevel"] : 1);
        let multiplier = res["idType"];

        if (this.type == "elite") {
            bonus = 2;
            this.luckBonus = 40;

        } else if (this.type == "normal") {
            let tDifficulty = Math.floor(Math.random() * 4);
            this.difficulty = Globals.mDifficulties[tDifficulty];
            multiplier = this.difficulty.value;
        } else if (this.type == "boss") {
            bonus = 8;
            this.luckBonus = 120;
        }

        await this.stats.loadStat(this.id, multiplier, this.getLevel());

        this.updateStats();
        this.xp = Math.round((10 * (Math.pow(this.getLevel(), 2))) / 6 * bonus);
        this.money = Math.round((Math.random() * (this.getLevel() * 2 - this.getLevel()) + this.getLevel()) * bonus);
    }

    getName(lang = "en") {
        return Translator.getString(lang, "monstersNames", this.id);
    }

    static getName(id, lang = "en") {
        return Translator.getString(lang, "monstersNames", id);
    }

    needToBeMaxLevel() {
        if (this.type == "normal") {
            return false;
        }
        return true;
    }

}

module.exports = Monstre;