'use strict';
const User = require("../bin/User.js");
const conn = require("../conf/mysql.js");
const Globals = require("../bin/Globals.js");
const LootSystem = require("../bin/LootSystem.js");
const AreasManager = require("../bin/Areas/AreasManager.js");
const sizeof = require('object-sizeof');
const Leaderboard = require("../bin/Leaderboard.js");
const Guild = require("../bin/Guild.js");
const https = require('https');
const fs = require('fs');
const express = require("express"),
    app = express(),
    api = express.Router(),
    port = process.env.PORT || 8080,
    url = require('url');


/*
const httpsOptions = {
    key: fs.readFileSync('path/to/key'),
    cert: fs.readFileSync('path/to/cert')
}*/

app.listen(port, () => console.log("Starting RESTful api server on: " + port));

/*https.createServer(httpsOptions, app).listen(8443);*/

app.use('/api', api);

var connectedUsers = Globals.connectedUsers;
var connectedGuilds = Globals.connectedGuilds;
var areasManager = Globals.areasManager;




/**
 * CROSS DOMAIN
 */

// this array is used for identification of allowed origins in CORS
const originWhitelist = ['http://localhost:8080'];

// middleware route that all requests pass through

/*
api.use((request, response, next) => {

	let origin = request.headers.host;
    console.log(request.headers);
	// only allow requests from origins that we trust
	if (originWhitelist.indexOf(origin) > -1) {
		response.setHeader('Access-Control-Allow-Origin', origin);
	}
	// only allow get requests, separate methods by comma e.g. 'GET, POST'
	response.setHeader('Access-Control-Allow-Methods', 'GET');
	response.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
	response.setHeader('Access-Control-Allow-Credentials', true);

	// push through to the proper route
	next();
});*/


// Init character if not connected

api.use((req, res, next) => {
	let urlParts = url.parse(req.url, true);
	let parameters = urlParts.query;
	let secretid = parameters.secretid;
    console.log(parameters);
	if(!secretid) {
		res.status(400).send({ error: "Bad Request !" });
	} else {
        let id = User.getUserId(secretid);
        if (id) {
            // Load user if exist and not connected
            if (!connectedUsers[id]) {
                connectedUsers[id] = new User(id, "API_CALL_DEFAULT_USERNAME");
                connectedUsers[id].loadUser();
                console.log(sizeof(connectedUsers));
            }
            // Load guild
            if (connectedUsers[id].character.isInGuild()) {
                if (!connectedGuilds[connectedUsers[id].character.idGuild]) {
                    connectedGuilds[connectedUsers[id].character.idGuild] = new Guild();
                    connectedGuilds[connectedUsers[id].character.idGuild].loadGuild(connectedUsers[id].character.idGuild);
                }
            }

            res.locals.parameters = parameters;
            res.locals.userid = id;
            next();
        } else {
            res.status(401).send({ error: "UNKNOWN_USER" });
        }
	}

});








/*api.post("/area/claim", (req, res) => {
    let authorIdentifier = res.locals.userid;

	res.json(res.locals);
});*/

api.get("/onlineplayers", (req, res) => {
    let arr = [];
    for (let i in connectedUsers) {
        arr.push(connectedUsers[i].username);
    }
    res.json(arr);
});

/*
 *  Get test
 */
api.get("/", (req, res) => {
    res.json({ exist : true });
});


/*
 *  INVENTORY
*/

api.get("/character/inventory", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let invPage = parseInt(res.locals.parameters.page);
    let msg;
    if (invPage && Number.isInteger(invPage)) {
        //msg = this.connectedUsers[authorIdentifier].character.inv.seeThisItem(invIdItem);
        msg = connectedUsers[authorIdentifier].character.inv.apiGetInv(invPage);
    } else {
        msg = connectedUsers[authorIdentifier].character.inv.apiGetInv();
    }

	res.json(msg);
});

api.get("/character/item", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let raw = res.locals.parameters.iditem;
    let idItemToSee = parseInt(res.locals.parameters.iditem,10);
    let msg;
    let doIHaveThisItem = false;

    if (idItemToSee !== undefined && Number.isInteger(idItemToSee)) {
        //msg = this.connectedUsers[authorIdentifier].character.inv.seeThisItem(invIdItem);
        //msg = this.connectedUsers[authorIdentifier].character.inv.toStr(invPage);
        doIHaveThisItem = connectedUsers[authorIdentifier].character.inv.doIHaveThisItem(idItemToSee);
        if (doIHaveThisItem) {
            msg = connectedUsers[authorIdentifier].character.inv.apiGetItem(idItemToSee);

            if(msg.equipable == true)
                msg["equippedItemStats"] = connectedUsers[authorIdentifier].character.equipement.objects[getEquipableIDType(msg.typeName)].stats;
        } else {
            msg = { error: "Vous n'avez pas cet objet." };
        }
    } else {
        idItemToSee = getEquipableIDType(raw);
        if (idItemToSee > 0) {
            msg = connectedUsers[authorIdentifier].character.equipement.apiGetItem(idItemToSee);
            if (msg == {}) {
                msg = { error: "Vous n'avez pas d'objets équipé dans cet emplacement." };
            }
        } else {
            msg = { error: "Cet emplacement n'existe pas." };
        }
    }
    res.json(msg);
});

api.post("/character/sellitem", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let msg = {};
    let sellIdItem = parseInt(res.locals.parameters.iditem, 10);
    let numberOfItemsToSell = parseInt(res.locals.parameters.number, 10);
    numberOfItemsToSell = Number.isInteger(numberOfItemsToSell) ? numberOfItemsToSell : 1;
    let error;
    let itemValue = 0;

    if (areasManager.canISellToThisArea(connectedUsers[authorIdentifier].character.area)) {
        if (sellIdItem !== undefined && Number.isInteger(sellIdItem)) {
            itemValue = connectedUsers[authorIdentifier].character.sellThisItem(sellIdItem, numberOfItemsToSell);
            if (itemValue <= 0) {
                error = "Vous ne possedez pas cet objet.";
            }
        } else {
            error = "Vous devez entrez l'ID de l'item à vendre !";
        }
    } else {
        error = "Vous devez être dans une ville pour pouvoir vendre vos objets.";
    }

    if (error) {
        msg["error"] = error;
    } else {
        msg["itemValue"] = itemValue;
    }
    res.json(msg);
});

api.post("/character/sellallitems", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let msg = {};
    let error;
    let allSelled = 0;

    if (areasManager.canISellToThisArea(connectedUsers[authorIdentifier].character.area)) {
        allSelled = connectedUsers[authorIdentifier].character.sellAllInventory();
        if (allSelled <= 0) {
            error = "Le marchand n'accepte pas de vous acheter du vent...";
        }
    } else {
        error = "Vous devez être dans une ville pour pouvoir vendre vos objets."
    }
    
    if (error) {
        msg["error"] = error;
    } else {
        msg["itemValue"] = allSelled;
    }
    res.json(msg);
});


/*
api.get('/character', (request, response) => {
	var urlParts = url.parse(request.url, true);
	var parameters = urlParts.query;
	var myParam = parameters.myParam;

	var myResponse = `I multiplied the number you gave me (${myParam}) by 5 and got: ${myParam * 5}`;

	response.json({ message: myResponse });
});*/


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