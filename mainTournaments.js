const Globals = require("./bin/Globals.js");
const Discord = require("discord.js");
const Key = require("./conf/botkey.js");
const FightManager = require("./bin/FightManager");
const crypto = require("crypto");
const AreasManager = require("./bin/Areas/AreasManager.js");
const conf = require("./conf/conf");
const DatabaseInitializer = require("./bin/DatabaseInitializer");
const ModuleHandler = require("./bin/Modules/ModuleHandler");
const AreaTournament = require("./bin/AreaTournament/AreaTournament");
const conn = require("./conf/mysql");

let res = conn.query("SELECT idArea FROM areas");

var tournaments = {};

for(let area of res) {
    tournaments[area.idArea] = new AreaTournament(area.idArea);
    tournaments[area.idArea].scheduleTournament();
}
