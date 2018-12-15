'use strict';
const Monster = require("../bin/Monstre");
const Fight = require("../bin/Fight/Fight");
const RateLimit = require('express-rate-limit');
const User = require("../bin/User.js");
const conn = require("../conf/mysql.js");
const Globals = require("../bin/Globals.js");
const LootSystem = require("../bin/LootSystem.js");
const AreasManager = require("../bin/Areas/AreasManager.js");
const sizeof = require('object-sizeof');
const Guild = require("../bin/Guild.js");
const https = require('https');
const fs = require('fs');
const Translator = require("../bin/Translator/Translator");
const express = require("express"),
    app = express(),
    api = express.Router(),
    port = 8880,
    url = require('url');
const path = require('path');


/*
const httpsOptions = {
    key: fs.readFileSync('path/to/key'),
    cert: fs.readFileSync('path/to/cert')
}*/

app.listen(port, () => console.log("Starting RESTful api server on: " + port));

//app.enable('trust proxy'); // only if you're behind a reverse proxy (Heroku, Bluemix, AWS if you use an ELB, custom Nginx setup, etc)

var limiter = new RateLimit({
    windowMs: 1 * 60 * 1000, // 1 minute
    max: 30, // limit each IP to 100 requests per windowMs
    delayMs: 0, // disable delaying - full speed until the max limit is reached
    handler: (req, res) => {
        res.json({
            error: "Vous avez fait trop d'actions, veuillez attendre un peu."
        })
    },
});

//  apply to all requests
app.use(limiter);

/*https.createServer(httpsOptions, app).listen(8443);*/

app.use(express.static(path.join(__dirname, '../public')));
app.use('/', api);

//console.log(path.join(__dirname, '../public'));


api.get("/areas/resources", (req, res) => {
    let urlParts = url.parse(req.url, true);
    let parameters = urlParts.query;
    let lang = "en";
    lang = parameters.lang != null ? (Translator.isLangExist(parameters.lang) ? parameters.lang : "en") : "en";
    let ressources = conn.query("SELECT localizationareas.nameArea, localizationitems.nameItem FROM areasresources INNER JOIN localizationareas ON areasresources.idArea = localizationareas.idArea INNER JOIN localizationitems ON areasresources.idBaseItem = localizationitems.idBaseItem WHERE localizationareas.lang = ? AND localizationitems.lang = ? ORDER BY localizationareas.idArea", [lang, lang]);

    let html = "<p>Res" + (lang == "fr" ? "s" : "") + "ources : ";
    let precedName = "";
    for (let r of ressources) {
        if (precedName != r.nameArea) {
            html += "</p>";
            html += "<p>" + r.nameArea + "<br>";
            precedName = r.nameArea;
        }
        html += r.nameItem + ", ";
    }
    html += "</p>";
    res.send(html);
});





function getEquipableIDType(string) {
    let r = -1;
    switch (string) {
        case "weapon":
            r = 1;
            break;
        case "chest":
            r = 2;
            break;
        case "legs":
            r = 3;
            break;
        case "head":
            r = 4;
            break;
    }
    return r;
}