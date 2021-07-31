const Globals = require("./bin/Globals.js");
const Translator = require("./bin/Translator/Translator");
const FightManager = require("./bin/FightManager");
const crypto = require("crypto");
const AreasManager = require("./bin/Areas/AreasManager.js");
const conf = require("./conf/conf");
const DatabaseInitializer = require("./bin/DatabaseInitializer");
const ModuleHandler = require("./bin/Modules/ModuleHandler");
const User = require("./bin/User");
const LootSystem = require("./bin/LootSystem");
const DBL = require("dblapi.js");
const WorldBossSpawner = require("./bin/WorldBosses/WorldBossSpawner");
const PSTreeNodes = require("./bin/PSTree/PSTreeNodes.js");
const RebirthManager = require("./bin/Rebirths/RebirthManager.js");
const axios = require("axios").default;
const EventsManager = require("./bin/Events/EventsManager.js");
const CharacterAppearance = require("./bin/Appearance/CharacterAppearance.js");
const Appearance = require("./bin/Appearance/Appearance.js");
const ItemAppearance = require("./bin/Appearance/ItemAppearance.js");
const { start } = require("repl");


async function startUp(app) {
    await Globals.loadGlobals();

    await Translator.load();

    let syncStartWith = Date.now();
    let totalGameStartTime = Date.now();

    console.log("Loading Rebirth Manager ...");
    Globals.rebirthManager = new RebirthManager();
    await Globals.rebirthManager.load();
    console.log("Rebirth Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    syncStartWith = Date.now();
    console.log("Loading Areas...");
    Globals.areasManager = new AreasManager();
    await Globals.areasManager.loadAreasManager();
    console.log("Areas loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    syncStartWith = Date.now();
    console.log("Loading Events Manager ...");
    Globals.eventsManager = new EventsManager();
    await Globals.eventsManager.load();
    console.log("Events Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    syncStartWith = Date.now();
    console.log("Loading Fight Manager...");
    Globals.fightManager = new FightManager();
    console.log("Fight Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    syncStartWith = Date.now();
    Globals.pstreenodes = new PSTreeNodes();
    await Globals.pstreenodes.load();
    console.log("Passives/Skills Tree Nodes loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    console.time("All Possible Appearances Load");
    await Appearance.loadAllPossibleAppearances();
    await Appearance.loadAllPossibleBodyTypes();
    await ItemAppearance.loadItemsAppearances();
    console.timeEnd("All Possible Appearances Load");


    let wbs = new WorldBossSpawner();
    await wbs.load();


    var connectedUsers = {};
    var connectedGuilds = {};

    Globals.connectedUsers = connectedUsers;
    Globals.connectedGuilds = connectedGuilds;


    console.log("Game World loaded, took : " + ((Date.now() - totalGameStartTime) / 1000) + " seconds");



    // Load api after all 
    const mHandler = new ModuleHandler(app);


};


module.exports = startUp;