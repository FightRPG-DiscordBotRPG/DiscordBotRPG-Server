const conf = require("../../conf/conf");
const conn = require("../../conf/mysql");
const Nodes = require("../../bin/PSTree/Nodes");
const Globals = require("../../bin/Globals");

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
    app.get("/nodes", async (req, res) => {
        res.json(await nodesObject.toApi());
    });

    app.get("/nodes/visuals", async (req, res) => {
        res.json(await nodesObject.visualsToApi());
    });
}

Start();
