const NodeVisuals = require("./NodeVisuals");
const SecondaryStatsPSTreeNode = require("../Stats/Secondary/SecondaryStatsPSTreeNode");
const StatsPSTreeNode = require("../Stats/StatsPSTreeNode");
const Skill = require("../SkillsAndStatus/Skill");
const State = require("../SkillsAndStatus/State");
const conn = require("../../conf/mysql");

class Node {
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
		 * @type {Object<number,Node>}
		 */
        this.children = {};
        this.parents = {};

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
            y: this.x,
            cost: this.cost,
            initial: this.isInitial,
            linkedNodes: Object.keys(this.children)
        }
    }

	/**
	 * 
	 * @param {Node} node
	 */
    addChild(node) {
        this.children[node.id] = node;
    }

    /**
     *
     * @param {Node} node
     */
    addParent(node) {
        this.parents[node.id] = node;
    }

}

module.exports = Node;