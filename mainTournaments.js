const conf = require("./conf/conf");
const conn = require("./conf/mysql");
const AreaTournament = require("./bin/AreaTournament/AreaTournament");
const Translator = require("./bin/Translator/Translator");



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

    for (let guild of guilds) {
        await conn.query("REPLACE INTO conquesttournamentinscriptions VALUES (?,?);", [guild.idGuild, areas[Math.floor(Math.random() * areas.length)].idArea]);
    }
}

startUp();