const conn = require("../conf/mysql");
const PSTreeNode = require("./PSTree/PSTreeNode");
const Stats = require("./Stats/Stats");
const SecondaryStats = require("./Stats/Secondary/SecondaryStats");
const Globals = require("./Globals");
const Translator = require("./Translator/Translator");

class CharacterTalents {
    constructor(id) {
        this.id = id;
        /**
         * @type {Array<PSTreeNode>}
         **/
        this.talents = {};
        this.unlockedSkillsIds = {};
        this.stats = new Stats();
        this.secondaryStats = new SecondaryStats();
    }

    async load(id = null) {
        if (id !== null) {
            this.id = id;
        }

        let res = await conn.query("SELECT * FROM characterstalents WHERE idCharacter = ?;", [this.id]);

        for (let item of res) {
            this.talents[item.idNode] = Globals.pstreenodes.getNode(item.idNode);
        }

        this.reloadStats();
	}

    reloadStats() {
        this.stats = new Stats();
        this.secondaryStats = new SecondaryStats();
        this.unlockedSkillsIds = {};

        for (let item of Object.values(this.talents)) {
            this.stats.add(item.stats);
            this.secondaryStats.add(item.secondaryStats);

            for (let id of Object.keys(item.skillsUnlockedIds)) {
                this.unlockedSkillsIds[id] = true;
			}
        }
    }

    isSKillUnlocked(idSkill) {
        this.unlockedSkillsIds[idSkill] === true;
    }

    canUnlock(idNode) {
        let node = Globals.pstreenodes.getNode(idNode);
        for (let unlockedNode of Object.values(this.talents)) {
            if (unlockedNode.id !== idNode && (unlockedNode.linkedNodes.includes(idNode) || node.isInitial)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 
     * @param {number} idNode
     * Unlock the node for character. 
     * ignoreCheck to not check if the node can be unlocked
     * Reload everything after unlock
     */
    unlock(idNode, ignoreCheck=true) {
        if (ignoreCheck || this.canUnlock(idNode)) {
            this.talents[idNode] = Globals.pstreenodes.getNode(idNode);
            this.reloadStats();
        }
    }

    async toApi(lang = "en") {
        return {
            talents: await this.getTalentsToApi(lang),
            unlockedSkills: Object.keys(this.unlockedSkillsIds).map(e => Translator.getString(lang, "skillNames", e) + ` (${e})`),
            stats: this.stats.toApi(),
            secondaryStats: this.secondaryStats.toApi(),
        }
    }

    async getTalentsToApi(lang="en") {
        let allPromises = [];
        let toReturn = [];
        for (let talent of Object.values(this.talents)) {
            allPromises.push(talent.toApi(lang));
        }

        await Promise.all(allPromises);

        for (let item of allPromises) {
            toReturn.push(await item);
        }

        return toReturn;

    }
}

module.exports = CharacterTalents;