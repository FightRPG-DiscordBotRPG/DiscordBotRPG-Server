const NodeVisuals = require("./PSTreeNodeVisuals");
const SecondaryStatsPSTreeNode = require("../Stats/Secondary/SecondaryStatsPSTreeNode");
const StatsPSTreeNode = require("../Stats/StatsPSTreeNode");
const Skill = require("../SkillsAndStatus/Skill");
const State = require("../SkillsAndStatus/State");
const conn = require("../../conf/mysql");

class PSTreeNode {
    constructor() {

		/**
		 * @type {NodeVisuals}
		 */
        this.visuals;

		/**
		 * @type {StatsPSTreeNode}
		 */
        this.stats;

		/**
		 * @type {SecondaryStatsPSTreeNode}
		 */
        this.secondaryStats;

		/**
		 * @type {Object<number, boolean>}
		 */
        this.skillsUnlockedIds = {};


		/**
		 * @type {Object<number, boolean>}
		 */
        this.statesProtectedFromIds = {};

		/**
		 * @type {Object<number, boolean>}
		 */
        this.statesAddedIds = {};

        this.x = 0;
        this.y = 0;
        this.cost = 0;
        this.isInitial = false;

		/**
		 * @type {Object<number,PSTreeNode>}
		 */
        this.children = {};
        this.parents = {};

        /**
         * Array of linked nodes ids
         * @type Array<number>
         **/
        this.linkedNodes = [];

    }

	/**
	 * 
	 * @param {number} id
	 */
    async load(id) {
        this.id = id;

        let res = (await conn.query("SELECT * FROM pstreenodes WHERE idNode = ?;", [id]))[0];

        if (!res) {
            return;
        }

        this.x = res.x;
        this.y = res.y;
        this.cost = res.cost;
        this.isInitial = res.isInitial;

        // Load skills

        res = await conn.query("SELECT * FROM pstreenodesskillsunlockdata WHERE idNode = ?;", [id]);

        for (let skill of res) {
            this.skillsUnlockedIds[skill.idSkill] = true;
        }

        res = await conn.query("SELECT * FROM pstreenodesstatesdata WHERE idNode = ?;", [id]);

        for (let state of res) {
            if (state.isProtectedFrom) {
                this.statesProtectedFromIds[state.idState] = true;
            } else if (state.isAdded) {
                this.statesAddedIds[state.idState] = true;
            }
        }


        this.stats = new StatsPSTreeNode(this.id);
        this.secondaryStats = new SecondaryStatsPSTreeNode(this.id);

        await Promise.all([
            this.stats.loadStats(),
            this.secondaryStats.loadStats()
        ]);

    }

    async toApi(lang = "en") {
        return {
            id: this.id,
            visuals: this.visuals ? await this.visuals.toApi(lang) : null,
            stats: this.stats.toApi(),
            secondaryStats: this.secondaryStats.toApi(),
            skillsUnlockedIds: Object.keys(this.skillsUnlockedIds),
            statesProtectedFromIds: Object.keys(this.statesProtectedFromIds),
            statesAddedIds: Object.keys(this.statesAddedIds),
            x: this.x,
            y: this.y,
            cost: this.cost,
            isInitial: this.isInitial,
            linkedNodes: Object.keys(this.children)
        }
    }

	/**
	 * 
	 * @param {PSTreeNode} node
	 */
    addChild(node) {
        this.children[node.id] = node;
        this.updateLinkedNodes();
    }

    /**
     *
     * @param {PSTreeNode} node
     */
    addParent(node) {
        this.parents[node.id] = node;
        this.updateLinkedNodes();
    }

    updateLinkedNodes() {
        this.linkedNodes = Object.keys(this.children);
    }

    updateFromAssign() {
        this.stats = Object.assign(new StatsPSTreeNode(), this.stats);
        this.secondaryStats = Object.assign(new SecondaryStatsPSTreeNode(), this.secondaryStats);
        this.visuals = Object.assign(new NodeVisuals(), this.visuals);

        this.stats.id = this.id;
        this.secondaryStats.id = this.id;

        this.updatePropertyAfterAssign("skillsUnlocked", "skillsUnlockedIds");
        this.updatePropertyAfterAssign("statesProtectedFrom", "statesProtectedFromIds");
        this.updatePropertyAfterAssign("statesAdded", "statesAddedIds");
    }

    /**
     * Only used from api with unity tool
     **/
    updatePropertyAfterAssign(unusedProperty, usedProperty) {
        if (this[unusedProperty]) {
            this[usedProperty] = [];
            for (let item of this[unusedProperty]) {
                this[usedProperty].push(item.id);
            }
        }
    }



    async save() {
        await conn.query("REPLACE INTO pstreenodes VALUES (?, ?, ?, ?, ?, ?)", [this.id, this.visuals.id, this.x, this.y, this.cost, this.isInitial]);

        let promisesToWait = [];
        promisesToWait.push(this.secondaryStats.save());
        promisesToWait.push(this.stats.save());

        //console.log(this);
        for (let idSkill of this.skillsUnlockedIds) {
            promisesToWait.push(conn.query("REPLACE INTO pstreenodesskillsunlockdata VALUES (?, ?)", [this.id, idSkill]));
        }

        for (let idState of this.statesAddedIds) {
            promisesToWait.push(conn.query("REPLACE INTO pstreenodesstatesdata VALUES (?, ?, ?, ?)", [this.id, idState, false, true]));
        }

        for (let idState of this.statesProtectedFromIds) {
            promisesToWait.push(conn.query("REPLACE INTO pstreenodesstatesdata VALUES (?, ?, ?, ?)", [this.id, idState, true, false]));
        }

        await Promise.all(promisesToWait);
    }

    async saveLinks() {
        let promises = [];
        for (let item of this.linkedNodes) {
            promises.push(conn.query("REPLACE INTO pstreenodeslinks VALUES (?, ?)", [this.id, item]));
        }

        await Promise.all(promises);
    }

}

module.exports = PSTreeNode;