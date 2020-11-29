const SkillBuild = require("./SkillBuild");
const conn = require("../../conf/mysql");
const Globals = require("../Globals");
const Utils = require("../Utilities/Utils");

class SkillBuildMonster extends SkillBuild {

    /**
     * 
     * @param {CharacterEntity} monster
     */
    constructor(monster) {
        super();
        this.monster = monster;
    }

    /**
     * 
     * @param {any} idStatProfil
     */
    async load(id) {
        this.id = id;
        this.clear();
        let res = await conn.query("SELECT * FROM monstersbuilds WHERE idStatsProfil = ?;", [this.id]);
        for (let item of res) {
            this.skillsIds[item.priority] = item.idSkill;
        }
        await this.loadSkills();
    }

    /**
     * 
     * @param {string} lang
     */
    toApi(lang = "en") {
        return {
            build: this.skillsObjects.map((e) => e.toApi(this.monster, lang)),
        }
    }
}


module.exports = SkillBuildMonster;

/**
 * @typedef {import("../Entities/CharacterEntity")} CharacterEntity
 **/