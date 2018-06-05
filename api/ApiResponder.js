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
const Leaderboard = require("../bin/Leaderboard.js");
const Guild = require("../bin/Guild.js");
const https = require('https');
const fs = require('fs');
const express = require("express"),
    app = express(),
    api = express.Router(),
    port = process.env.PORT || 8080,
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
        res.json({error : "Vous avez fait trop d'actions, veuillez attendre un peu."})
    },
});

//  apply to all requests
app.use(limiter);

/*https.createServer(httpsOptions, app).listen(8443);*/

app.use(express.static(path.join(__dirname, '../public')));
app.use('/api', api);

console.log(path.join(__dirname, '../public'));






/*
 * NON EXPRESS
 */








var connectedUsers = Globals.connectedUsers;
var connectedGuilds = Globals.connectedGuilds;
var areasManager = Globals.areasManager;
var fightManager = Globals.fightManager;




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
                areasManager.addOnePlayer(connectedUsers[id].character.area);
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
 * Areas
 */

api.get("/areas", (req, res) => {
    let authorIdentifier = res.locals.userid;
    res.json(areasManager.toApi(connectedUsers[authorIdentifier].character.area));
});

api.get("/area", (req, res) => {
    let authorIdentifier = res.locals.userid;
    res.json(areasManager.toApiThisAreaFull(connectedUsers[authorIdentifier].character.area));
});

api.post("/character/travel", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let wantedAreaToTravel = parseInt(res.locals.parameters.area, 10);
    let msg = {};
    let error;
    if (connectedUsers[authorIdentifier].character.canFightAt <= Date.now()) {
        if (areasManager.exist(wantedAreaToTravel)) {
            if (wantedAreaToTravel == connectedUsers[authorIdentifier].character.area) {
                error = "Vous êtes déjà à cet endroit.";
            } else {

                // Update le compte de joueurs
                areasManager.updateTravel(connectedUsers[authorIdentifier].character.area, wantedAreaToTravel);

                // change de zone
                connectedUsers[authorIdentifier].character.changeArea(wantedAreaToTravel);

                // Messages
                /*"Vous avez bien voyagé vers la zone : " + areasManager.getNameOf(wantedAreaToTravel) + ".";
                "\nVous êtes fatigué vous allez devoir attendre " + Math.ceil((connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000) + " secondes avant de pouvoir refaire une action.";*/
            }

        } else {
            error = "Cette zone n'existe pas !";
        }
    } else {
        error = "Vous êtes trop fatigué pour voyager vous devez encore attendre : " + Math.ceil((connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000) + " secondes.";
    }

    if (error) {
        msg["error"] = error;
    } else {
        msg["success"] = "Vous avez bien voyagé vers la zone: " + areasManager.getNameOf(wantedAreaToTravel) + "." +
        "\nVous êtes fatigué vous allez devoir attendre " + Math.ceil((connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000) + " secondes avant de pouvoir refaire une action.";
    }

    res.json(msg);
});


/*
 * FIGHT
 */

api.post("/fightpve", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let idEnemy = parseInt(res.locals.parameters.idEnemy, 10);
    let toApi = {};
    if (areasManager.canIFightInThisArea(connectedUsers[authorIdentifier].character.area)) {
        if (idEnemy != undefined && Number.isInteger(idEnemy)) {
            let canIFightTheMonster = areasManager.canIFightThisMonster(connectedUsers[authorIdentifier].character.area, idEnemy, connectedUsers[authorIdentifier].character.getStat("perception"));

            if (!canIFightTheMonster) {
                idEnemy = areasManager.selectRandomMonsterIn(connectedUsers[authorIdentifier].character.area, idEnemy);
            } else {
                idEnemy = areasManager.getMonsterIdIn(connectedUsers[authorIdentifier].character.area, idEnemy);
            }
            toApi = fightManager._apiFightPvE([connectedUsers[authorIdentifier].character], [{ id: idEnemy, number: 1 }], authorIdentifier, canIFightTheMonster)

        } else {
            // Error Message
            toApi.error = "Vous devez entrer l'identifiant du monstre que vous voulez attaquer.";
        }
    } else {
        toApi.error = "Vous ne pouvez pas vous battre en ville.";
    }
    res.json(toApi);
});


/*
 *  CHARACTER
 */

api.get("/character", (req, res) => {
    let authorIdentifier = res.locals.userid;
    res.json(connectedUsers[authorIdentifier].apiInfoPanel());
});

api.post("/character/upstat", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let stat = res.locals.parameters.stat;
    let nbr = parseInt(res.locals.parameters.number, 10);
    let msg = {};

    let done = connectedUsers[authorIdentifier].character.upStat(stat, nbr);
    if (!done) {
        msg["error"] = "Vous ne pouvez pas faire cela.";
    }

    res.json(msg);
});


api.post("/character/reset", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let msg = {};
    if (!connectedUsers[authorIdentifier].character.resetStats()) {
        msg["error"] = "Vous n'avez pas assez d'argent pour reset vos stats !";
    }
    res.json(msg);
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
    let idItemToSee = parseInt(res.locals.parameters.iditem, 10);
    let msg;
    let doIHaveThisItem = false;

    if (idItemToSee !== undefined && Number.isInteger(idItemToSee)) {
        //msg = this.connectedUsers[authorIdentifier].character.inv.seeThisItem(invIdItem);
        //msg = this.connectedUsers[authorIdentifier].character.inv.toStr(invPage);
        doIHaveThisItem = connectedUsers[authorIdentifier].character.inv.doIHaveThisItem(idItemToSee);
        if (doIHaveThisItem) {
            msg = connectedUsers[authorIdentifier].character.inv.apiGetItem(idItemToSee);

            if (msg.equipable == true && connectedUsers[authorIdentifier].character.equipement.objects[getEquipableIDType(msg.typeName)])
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
 * Equipement Related 
 */

api.post("/character/equip", (req, res) => {
    let toEquip = parseInt(res.locals.parameters.iditem, 10);
    let authorIdentifier = res.locals.userid;
    let msg = {};
    let error;
    let typeName = "head";

    if (toEquip !== undefined && Number.isInteger(toEquip)) {
        if (connectedUsers[authorIdentifier].character.inv.doIHaveThisItem(toEquip)) {
            if (connectedUsers[authorIdentifier].character.inv.isEquipable(toEquip)) {
                let swapItem = connectedUsers[authorIdentifier].character.equipement.equip(connectedUsers[authorIdentifier].character.inv.objects[toEquip].id);
                typeName = connectedUsers[authorIdentifier].character.inv.objects[toEquip].typeName;
                connectedUsers[authorIdentifier].character.inv.deleteFromInventory(toEquip);
                if (swapItem > 0) {
                    connectedUsers[authorIdentifier].character.inv.addToInventory(swapItem);
                }
            } else {
                error = "Vous ne pouvez pas équiper cet objet.";
            }
        } else {
            error = "Vous n'avez pas cet objet !";
        }
    } else {
        error = "Vous devez entrer l'identifiant de l'objet à équiper.";
    }

    if (error) {
        msg["error"] = error;
    } else {
        msg["newItemId"] = typeName;
    }

    res.json(msg);

    
});

api.post("/character/unequip", (req, res) => {
    let toUnequip = getEquipableIDType(res.locals.parameters.iditem);
    let authorIdentifier = res.locals.userid;
    let error;
    let idToSend = 0;
    let msg = {};
    if (toUnequip != -1 && Number.isInteger(toUnequip)) {
        let itemToInventory = connectedUsers[authorIdentifier].character.equipement.unEquip(toUnequip);
        if (itemToInventory > 0) {
            connectedUsers[authorIdentifier].character.inv.addToInventory(itemToInventory);
            idToSend = connectedUsers[authorIdentifier].character.inv.objects.length - 1;
        } else {
            error = "Vous n'avez pas d'objets d'équipé dans cet emplacement !";
        }
    } else {
        error = "Vous devez choisir le type à retirer.";
    }

    if (error) {
        msg["error"] = error;
    } else {
        msg["newItemId"] = idToSend;
    }
    res.json(msg);
});

api.get("/character/equipment", (req, res) => {
    let authorIdentifier = res.locals.userid;
    let msg = connectedUsers[authorIdentifier].character.equipement.apiGetAllImages();;
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