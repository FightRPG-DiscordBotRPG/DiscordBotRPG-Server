const SkillBuild = require("./SkillBuild");
const conn = require("../../conf/mysql");
const Globals = require("../Globals");
const Utils = require("../Utilities/Utils");

class SkillBuildCharacter extends SkillBuild {

    /**
     * 
     * @param {CharacterEntity} character
     */
    constructor(character) {
        super();
        this.character = character;
    }

    /**
     * 
     * @param {any} id
     */
    async load(id) {
        this.id = id;
        let res = await conn.query("SELECT * FROM charactersbuilds WHERE idCharacter = ?;", [this.id]);
        for (let item of res) {
            this.skillsIds[item.priority] = item.idSkill;
        }
    }

    canAddMore() {
        return this.skillsIds.length < Globals.maximumSkillsPerBuild;
    }

    /**
     * 
     * @param {number} idSkill
     */
    canEquip(idSkill) {
        return this.canAddMore() && !this.isSkillEquipped(idSkill) && this.character.talents.isSkillUnlocked(idSkill);
    }

    /**
     * 
     * @param {number} id
     */
    async pushSkill(id) {
        if (this.canEquip()) {
            this.skillsIds.push(id);
            return await this.returnSuccessAndSave(true);
        }
        return false;
    }

    /**
     * 
     * @param {number} id
     * @param {number} priority
     */
    async swapSkill(id, priority) {
        return await this.returnSuccessAndSave(Utils.swapArrayItemToIndex(this.skillsIds, id, priority));
    }

    /**
     * 
     * @param {number} id
     */
    async removeSkill(id) {
        return await this.returnSuccessAndSave(Utils.removeItemFromArray(this.skillsIds, id));
    }

    async reset() {
        await conn.query("DELETE FROM charactersbuilds WHERE idCharacter = ?;", [this.id]);
        this.reload();
    }

    async reload() {
        await this.load(this.id);
        await this.loadSkills();
    }

    /**
     * 
     * @param {Promise<boolean>} isSuccess
     */
    async returnSuccessAndSave(isSuccess) {
        await conn.query("DELETE FROM charactersbuilds WHERE idCharacter = ?;", [this.id]);
        await conn.query("INSERT INTO charactersbuilds VALUES " + this.skillsIds.map((e, i) => `(${this.id},${e},${i})`).join(",") + ";");
        await this.reload();
        return isSuccess;
    }

    /**
     * 
     * @param {string} lang
     */
    toApi(lang="en") {
        return {
            build: this.skillsObjects.map((e) => e.toApi(this.character, lang)),
            maximumSkills: Globals.maximumSkillsPerBuild,
        }
    }
}


module.exports = SkillBuildCharacter;

/**
 * @typedef {import("../Entities/CharacterEntity")} CharacterEntity
 **/