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
        let res = await conn.query("SELECT * FROM monstersbuilds WHERE idMonstersBuildsProfil = ?;", [this.id]);

        let toShuffle = [];
        for (let item of res) {
            if (!this.skillsIds[item.priority]) {
                this.skillsIds[item.priority] = item.idSkill;
            } else {
                toShuffle.push(item.idSkill);
            }
        }

        if (toShuffle.length > 0) {
            Utils.shuffleFisherYates(toShuffle);
            for (let item of toShuffle) {
                this.skillsIds.push(item);
            }
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