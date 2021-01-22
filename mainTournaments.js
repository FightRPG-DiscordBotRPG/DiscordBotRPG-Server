const conf = require("./conf/conf");
const conn = require("./conf/mysql");
const Globals = require("./bin/Globals.js");
const FightManager = require("./bin/FightManager");
const crypto = require("crypto");
const AreasManager = require("./bin/Areas/AreasManager.js");
const DatabaseInitializer = require("./bin/DatabaseInitializer");
const User = require("./bin/User");
const LootSystem = require("./bin/LootSystem");
const DBL = require("dblapi.js");
const WorldBossSpawner = require("./bin/WorldBosses/WorldBossSpawner");
const PSTreeNodes = require("./bin/PSTree/PSTreeNodes.js");
const AreaTournament = require("./bin/AreaTournament/AreaTournament");
const Translator = require("./bin/Translator/Translator");

// All imports are useful if you want to avoid circular hell ;)

/**
 * @type {Array<AreaTournament>}
 */
var tournaments = {};




async function startUp() {
    // For debug purpose
    if (conf.env == "dev") {
        await setupDummy();
    }

    console.time("Translator loading");
    await Translator.load();
    console.timeEnd("Translator loading");

    console.time("Global loading");
    await Globals.loadGlobals();
    console.timeEnd("Global loading");

    console.time("PSTree loading");
    Globals.pstreenodes = new PSTreeNodes();
    await Globals.pstreenodes.load();
    console.timeEnd("PSTree loading");


    let res = await conn.query("SELECT idArea FROM areas");
    for (let area of res) {
        tournaments[area.idArea] = new AreaTournament(area.idArea);
        await tournaments[area.idArea].init();
        tournaments[area.idArea].scheduleTournament();
    }
}

async function setupDummy() {
    let guilds = await conn.query("SELECT idGuild FROM guilds");
    let areas = await conn.query("SELECT idArea FROM areas");

    await conn.query("DELETE FROM conquesttournamentrounds");

    for (let guild of guilds) {
        await conn.query("REPLACE INTO conquesttournamentinscriptions VALUES (?,?);", [guild.idGuild, areas[Math.floor(Math.random() * areas.length)].idArea]);
    }
}

startUp();