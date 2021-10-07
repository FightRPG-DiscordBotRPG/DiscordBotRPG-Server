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
        this.clear();
        let res = await conn.query("SELECT * FROM charactersbuilds WHERE idCharacter = ?;", [this.id]);
        for (let item of res) {
            this.skillsIds[item.priority] = item.idSkill;
        }
        await this.loadSkills();
    }

    canAddMore() { 
        return this.skillsIds.length < Globals.maximumSkillsPerBuild;
    }

    /**
     * 
     * @param {number} idSkill
     */
    canEquip(idSkill) {
        return this.getErrorEquip(idSkill) === null;
    }

    /**
     * 
     * @param {number} idSkill
     * @returns {string|null} Null if no errors
     */
    getErrorEquip(idSkill) {
        if (!this.canAddMore()) {
            return "skill_build_cant_add_more";
        }

        if (this.isSkillEquipped(idSkill)) {
            return "skill_build_already_equipped";
        }

        if (!this.character.talents.isSkillUnlocked(idSkill)) {
            return "skill_build_not_unlocked";
        }

        return null;
    }

    /**
     * 
     * @param {number} id
     */
    async pushSkill(id) {
        if (this.canEquip(id)) {
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
    }

    /**
     * 
     * @param {Promise<boolean>} isSuccess
     */
    async returnSuccessAndSave(isSuccess) {
        if (isSuccess) {
            await conn.query("DELETE FROM charactersbuilds WHERE idCharacter = ?;", [this.id]);
            if (this.skillsIds.length > 0) {
                await conn.query("INSERT INTO charactersbuilds VALUES " + this.skillsIds.map((e, i) => e != null ? `(${this.id},${e},${i})` : ""s).join(",") + ";");
            }
            await this.reload();
        }
        return isSuccess;
    }

    /**
     * 
     * @param {string} lang
     */
    toApi(lang = "en") {
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