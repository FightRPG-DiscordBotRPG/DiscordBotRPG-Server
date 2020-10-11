const conf = require("../../conf/conf");
const conn = require("../../conf/mysql");
const PSTreeNodes = require("../../bin/PSTree/PSTreeNodes");
const PSTreeNode = require("../../bin/PSTree/PSTreeNode");
const Globals = require("../../bin/Globals");
const Skill = require("../../bin/SkillsAndStatus/Skill");
const Translator = require("../../bin/Translator/Translator");
const State = require("../../bin/SkillsAndStatus/State");
const NodeVisuals = require("../../bin/PSTree/PSTreeNodeVisuals");

const express = require("express"),
    app = express(),
    port = 25012,
    url = require('url'),
    compression = require('compression');
require('express-async-errors');
app.listen(port, () => console.log("Starting RESTful api server for PSTree on: " + port));
app.use(express.urlencoded({
    extended: true
}));
app.use(express.json());
app.use(compression());

const nodesObject = new PSTreeNodes();


async function Start() {
    // Load Object before 
    await nodesObject.load();
    await Globals.loadGlobals();
    await Translator.load();
    app.get("/nodes", async (req, res) => {
        res.json(await nodesObject.toApi());
    });

    app.get("/nodes/visuals", async (req, res) => {
        res.json(await nodesObject.visualsToApi());
    });

    app.get("/skills", async (req, res) => {
        let results = await conn.query("SELECT idSkill FROM skills");
        let promises = [];
        let skills = [];
        for (let data of results) {
            let skill = new Skill();
            skills.push(skill);
            promises.push((async (skillFunc) => {
                await skillFunc.loadWithID(data.idSkill);
            })(skill));
        }

        await Promise.all(promises);

        res.json({ skills: skills.map(s => s.toApiSimple()) });
    });

    app.get("/states", async (req, res) => {
        let results = await conn.query("SELECT idState FROM states");
        let promises = [];
        let states = [];
        for (let data of results) {
            let state = new State();
            states.push(state);
            promises.push((async (stateFunc) => {
                await stateFunc.loadWithID(data.idState);
            })(state));
        }

        await Promise.all(promises);

        res.json({ skills: states.map(s => s.toApi()) });
    });

    app.post("/visuals_update", async (req, res) => {
        let json = JSON.parse(req.body.visuals);

        await ClearAllVisuals();

        let allVisuals = [];
        let promisesToWait = [];

        for (let nodeVisual of json.visuals) {
            allVisuals.push(nodeVisual);
            nodeVisual = JSON.parse(nodeVisual);

            let visual = Object.assign(new NodeVisuals(), nodeVisual);
            promisesToWait.push(visual.save());
        }

        await Promise.all(promisesToWait);

        res.json({ done: true });
    });

    app.post("/nodes_update", async (req, res) => {
        let json = JSON.parse(req.body.dataNodes);

        await ClearAllNodes();

        let allNodesObject = [];
        let promisesToWait = [];

        for (let nodeJson of json.nodes) {

            nodeJson = JSON.parse(nodeJson.trim());

            /**
             * @type {PSTreeNode}
             */
            let node = Object.assign(new PSTreeNode(), nodeJson);
            allNodesObject.push(node);
            node.updateFromAssign();

            promisesToWait.push(node.save());

        }

        await Promise.all(promisesToWait);

        promisesToWait = [];
        for (let node of allNodesObject) {
            promisesToWait.push(node.saveLinks());
        }

        await Promise.all(promisesToWait);
        await nodesObject.load();
        res.json({ done: true });
    });
}

async function ClearAllNodes() {
    await conn.query("DELETE FROM pstreenodessecondarystatselementalresistsdata");
    await conn.query("DELETE FROM pstreenodesstatesdata");
    await conn.query("DELETE FROM pstreenodeslinks");
    await conn.query("DELETE FROM pstreenodesskillsunlockdata");
    await conn.query("DELETE FROM pstreenodesstatsdata");
    await conn.query("DELETE FROM pstreenodessecondarystatsdata");
    await conn.query("DELETE FROM pstreenodes");
}

async function ClearAllVisuals() {
    await conn.query("UPDATE pstreenodes SET idNodeVisual = ?", [null]);
    await conn.query("DELETE FROM localizationnodespstree");
    await conn.query("DELETE FROM pstreepossiblesnodesvisuals");
}

Start();
