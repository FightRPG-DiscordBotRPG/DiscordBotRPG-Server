const SkillBuild = require("./SkillBuild");
const conn = require("../../conf/mysql");
const Globals = require("../Globals");
const Utils = require("../Utilities/Utils");

class SkillBuildCharacter extends SkillBuild {

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

    async pushSkill(id) {
        if (this.canAddMore()) {
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

    /**
     * 
     * @param {Promise<boolean>} isSuccess
     */
    async returnSuccessAndSave(isSuccess) {
        await conn.query("DELETE FROM charactersbuilds WHERE idCharacter = ?;", [this.id]);
        await conn.query("INSERT INTO charactersbuilds VALUES " + this.skillsIds.map((e, i) => `(${this.id},${e},${i})`).join(",") + ";");
        return isSuccess;
    }
}


module.exports = SkillBuildCharacter;