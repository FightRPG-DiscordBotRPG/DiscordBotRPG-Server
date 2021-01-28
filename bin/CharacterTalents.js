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
         * @type {Object<string, PSTreeNode>}
         **/
        this.talents = {};
        this.unlockedSkillsIds = {};
        this.stats = new Stats();
        this.secondaryStats = new SecondaryStats();
        /**
         * @type {Character}
         **/
        this.character = null;
    }

    /**
     * 
     * @param {Character} character
     * @param {string|number} id
     */
    async load(character, id = null) {
        if (id !== null) {
            this.id = id;
        }
        this.character = character;
        let res = await conn.query("SELECT * FROM characterstalents WHERE idCharacter = ?;", [this.id]);

        for (let item of res) {
            this.talents[item.idNode] = Globals.pstreenodes.getNode(item.idNode);
        }

        await this.reloadStats();
    }

    async reloadStats() {
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
        await this.character.updateStatsAndHeal();
    }

    isTalentUnlocked(idNode) {
        return this.talents[idNode] != null;
    }

    isSkillUnlocked(idSkill) {
        return this.unlockedSkillsIds[idSkill] === true;
    }

    async canUnlock(idNode) {
        return (await this.haveEnoughPoints(idNode)) && this.isReachable(idNode) && !this.isTalentUnlocked(idNode);
    }

    async haveEnoughPoints(idNode) {
        return (await this.character.getTalentPoints()) >= Globals.pstreenodes.getNode(idNode).getRealCost();
    }

    async reset() {
        await conn.query("DELETE FROM characterstalents WHERE idCharacter = ?;", [this.id]);
        this.talents = {};
        await this.reloadStats();
    }

    /**
     * 
     * @param {number} idNode
     */
    isReachable(idNode) {
        let node = Globals.pstreenodes.getNode(idNode);
        for (let unlockedNode of Object.values(this.talents)) {
            if (unlockedNode.id !== idNode && (unlockedNode.linkedNodesIds.includes(idNode) || node.isInitial)) {
                return true;
            }
        }

        // If after search not ok
        // Return if node is initial
        // Since search only look through unlocked talents
        // And initial are always available
        return node.isInitial;
    }

    /**
     * 
     * @param {number} idNode
     * @param {boolean} ingoreCheck true by default
     * Unlock the node for character. 
     * ignoreCheck to not check if the node can be unlocked
     * Reload everything after unlock
     */
    async unlock(idNode, ignoreCheck = true) {
        if (ignoreCheck || await this.canUnlock(idNode)) {
            this.talents[idNode] = Globals.pstreenodes.getNode(idNode);
            await Promise.all([
                conn.query("INSERT INTO characterstalents VALUES (?, ?);", [this.id, idNode]),
                this.character.removeTalentPoints(this.talents[idNode].getRealCost()),
            ]);
            await this.reloadStats();
            return true;
        }
        return false;
    }

    async toApi(lang = "en") {
        return {
            talents: await this.getTalentsToApi(lang),
            unlockedSkills: Object.keys(this.unlockedSkillsIds).map(e => Translator.getString(lang, "skillNames", e) + ` (${e})`),
            stats: this.stats.toApi(),
            secondaryStats: this.secondaryStats.toApi(),
            initialTalents: Globals.pstreenodes.initialTalents,
            talentPoints: await this.character.getTalentPoints(),
        }
    }

    toExport() {
        return {
            talents: Object.values(this.talents).map(e => e.id).join(",")
        }
    }

    async import(talentsIds) {

    }

    async getTalentsToApi(lang = "en") {
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

/**
 * @typedef {import("./Character")} Character
 * @typedef {import("./Group")} Group
 **/