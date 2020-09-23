const conf = require("../../conf/conf");
const conn = require("../../conf/mysql");
const Nodes = require("../../bin/PSTree/Nodes");
const Globals = require("../../bin/Globals");
const Skill = require("../../bin/SkillsAndStatus/Skill");
const Translator = require("../../bin/Translator/Translator");
const State = require("../../bin/SkillsAndStatus/State");

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

const nodesObject = new Nodes();


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
                skillFunc.name = skillFunc.getName();
            })(skill));
        }

        await Promise.all(promises);

        res.json({ skills: skills });
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
}

Start();
