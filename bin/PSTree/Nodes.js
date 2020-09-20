const conn = require("../../conf/mysql");
const NodeVisuals = require("./NodeVisuals");
const Node = require("./Node");

class Nodes {
    constructor() {
        /**
         * @type {Object<number, Node>}
         */
        this.allNodes = {};

        /**
        * @type {Array<NodeVisuals>}
        */
        this.possibleNodesVisuals = [];
    }

    async load() {

        let promises;
        let res = null;

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
                let node = new Node();
                await node.load(id);
                node.visuals = this.possibleNodesVisuals.find((x) => x.id === nodeRes.idNodeVisual)
                return node;
            })());
        }

        await Promise.all(promises);

        for (let node of promises) {
            // TODO : Add links
            node = await node;
            this.allNodes[node.id] = node;
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

    async visualsToApi(lang = "en") {
        let values = [];
        let promises = [];
        for (let i in this.possibleNodesVisuals) {
            let visual = this.possibleNodesVisuals[i];
            values.push(visual);
            promises.push(visual.toApi(lang));
        }

        await Promise.all(promises);

        return { visuals: values };
    }
}

module.exports = Nodes;