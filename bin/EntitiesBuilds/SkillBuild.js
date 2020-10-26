const Skill = require("../SkillsAndStatus/Skill");

class SkillBuild {
    constructor() {
        this.id = null;
        /**
         * @type {number[]}
         * */
        this.skillsIds = [];

        /** 
         * @type {Skill[]}
         */
        this.skillsObjects = [];
        /**
        * @type {Object.<number, Skill>}
        */
        this.skills = {};


        this.skillToTestIndex = -1;
    }

    clear() {
        this.skillsIds = [];
        this.skillsObjects = [];
        this.skills = {};
    }

    /**
    * 
    * @param {number} idSkill
    */
    isSkillEquipped(idSkill) {
        return this.skills[idSkill] != null;
    }

    async loadSkills() {
        let promises = [];
        //let skillsToTest = [];
        for (let item of this.skillsIds) {
            let s = new Skill();
            this.skills[item] = s;
            this.skillsObjects.push(s);
            promises.push(s.loadWithID(item));
        }
        await Promise.all(promises);
        this.skillToTestIndex = 0;
    }

    getSelectedSkill() {
        return this.skills[this.skillsIds[this.skillToTestIndex]];
    }

    prepareNextSkill() {
        this.skillToTestIndex++;
        if (this.skillToTestIndex >= this.skillsIds.length) {
            this.skillToTestIndex = 0;
        }
    }


}

module.exports = SkillBuild