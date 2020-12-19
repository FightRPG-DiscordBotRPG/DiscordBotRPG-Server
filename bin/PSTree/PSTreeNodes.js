const conn = require("../../conf/mysql");
const NodeVisuals = require("./PSTreeNodeVisuals");
const PSTreeNode = require("./PSTreeNode");
const Translator = require("../Translator/Translator");

class PSTreeNodes {
    constructor() {
        /**
         * @type {Object<number, PSTreeNode>}
         */
        this.allNodes = {};

        /**
        * @type {Array<NodeVisuals>}
        */
        this.possibleNodesVisuals = [];

        /**
         * @type {Array<Number>}
         **/
        this.initialTalents = [];
    }

    async load() {

        let promises;
        let res = null;

        this.allNodes = {};
        this.possibleNodesVisuals = [];
        this.initialTalents = [];

        res = await conn.query("SELECT * FROM pstreepossiblesnodesvisuals");
        promises = [];
        for (let item of res) {
            let visual = new NodeVisuals();
            this.possibleNodesVisuals.push(visual);
            let id = item.idNode;
            promises.push((async () => {
                await visual.load(id);
                return visual;
            })());
        }

        await Promise.all(promises);

        res = await conn.query("SELECT idNode, idNodeVisual FROM pstreenodes");

        /**
         * @type Array<Node> 
         **/
        promises = [];

        for (let item of res) {
            let id = item.idNode;
            let nodeRes = item;
            promises.push((async () => {
                let node = new PSTreeNode();
                await node.load(id);
                node.visuals = this.possibleNodesVisuals.find((x) => x.id === nodeRes.idNodeVisual);
                return node;
            })());
        }

        await Promise.all(promises);

        for (let node of promises) {
            node = await node;
            this.allNodes[node.id] = node;
            if (node.isInitial) {
                this.initialTalents.push(node.id);
            }
        }

        // Do links
        res = await conn.query("SELECT * FROM pstreenodeslinks");

        for (let item of res) {
            this.allNodes[item.idNodeParent].addChild(this.allNodes[item.PSTreeNodesChild]);
            this.allNodes[item.PSTreeNodesChild].addParent(this.allNodes[item.idNodeParent]);
        }

    }

    async toApi(lang = "en") {
        let nodes = [];

        for (let id in this.allNodes) {
            nodes.push(await this.allNodes[id].toApi(lang));
        }

        return {
            nodes: nodes,
        };
    }

    async visualsToApi() {
        let values = [];

        for (let i in this.possibleNodesVisuals) {
            let visual = this.possibleNodesVisuals[i];
            let visualToApi = visual.toApi();
            visualToApi.localizedNames = {};
            for (let lang in Translator.translations) {
                visualToApi.localizedNames[lang] = visual.getName(lang);
            }
            values.push(visualToApi);
        }

        return { visuals: values };
    }

    /**
     * 
     * @param {number} idNode
     */
    getNode(idNode) {
        return this.allNodes[idNode];
    }
}

module.exports = PSTreeNodes;