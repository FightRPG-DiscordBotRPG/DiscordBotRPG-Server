'use strict';
const conn = require("../../conf/mysql.js");
const WorldEntity = require("./WorldEntity.js");
const StatsMonsters = require("../Stats/StatsMonsters");
const SecondaryStatsMonsters = require("../Stats/Secondary/SecondaryStatsMonsters");
const Globals = require("../Globals.js");
const Translator = require("../Translator/Translator");
const SkillBuildMonster = require("../EntitiesBuilds/SkillBuildMonster");

class Monster extends WorldEntity {

    constructor(id) {
        super();
        this._type = "Monster";
        this.uuid = id;
        this.decoratedId = null;
        this.id = id;
        this.name = "g_monster";
        this.actualHP = 0;
        this.maxHP = 0;
        this.level = 0;
        this.xp = 0;
        this.money = 0;
        this.luckBonus = 0;
        this.stats = new StatsMonsters();
        this.secondaryStats = new SecondaryStatsMonsters();
        this.difficulty = {};
        this.type = "";
        this.skillBuild = new SkillBuildMonster();
    }


    async loadMonster(level=null) {
        this.difficulty = Globals.mDifficulties[2];
        let res = await conn.query("SELECT DISTINCT monstrestypes.idType, avglevel, nom, idStatsProfil, idMonstersBuildsProfil FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType INNER JOIN statsmonstres ON statsmonstres.idMonstre = monstres.idMonstre WHERE monstres.idMonstre = ?;", [this.id]);
        res = res[0];
        let bonus = 1;
        this.type = res["nom"];
        this.level = level && level > 0 ? level : (res["avglevel"] > 0 ? res["avglevel"] : 1);
        let multiplier = res["idType"];

        if (this.type == "elite") {
            bonus = 2;
            this.luckBonus = this.stats.getMaximumStat(this.getLevel()) * 0.4;

        } else if (this.type == "normal") {
            let tDifficulty = Math.floor(Math.random() * 4);
            this.difficulty = Globals.mDifficulties[tDifficulty];
            multiplier = this.difficulty.value;
        } else if (this.type == "boss") {
            bonus = 8;
            this.luckBonus = this.stats.getMaximumStat(this.getLevel());
        }

        await Promise.all([this.stats.loadStat(this.id, multiplier, this.getLevel()), this.secondaryStats.loadStat(this.id, multiplier, this.getLevel()), this.skillBuild.load(res["idMonstersBuildsProfil"])]);

        this.updateStats();
        this.xp = Math.round((10 * (Math.pow(this.getLevel(), 2))) / 6 * bonus);
        this.money = Math.round((Math.random() * (this.getLevel() * 2 - this.getLevel()) + this.getLevel()) * bonus);

    }

    getName(lang = "en") {
        return Translator.getString(lang, "monstersNames", this.id) + (this.decoratedId !== null ? " #" + this.decoratedId : "");
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

    getIdentity(lang = "en") {
        let identity = super.getIdentity(lang);
        identity.monsterType = this.type;
        identity.monsterDifficultyName = this.difficulty.name;
        return identity;
    }

}

module.exports = Monster;