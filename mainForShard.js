const Discord = require('discord.js');
const Globals = require("./bin/Globals");
const FightManager = require("./bin/FightManager");
const AreasManager = require("./bin/Areas/AreasManager.js");
const conf = require("./conf/conf");
const DatabaseInitializer = require("./bin/DatabaseInitializer");

let timeStart = Date.now();
let syncStartWith = Date.now();

process.on('unhandledRejection', up => { throw up });

console.log("Initializing Database ...");
DatabaseInitializer.initialize();
console.log("Database initialized, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

syncStartWith = Date.now();
console.log("Loading Areas...");
var areasManager = new AreasManager();
Globals.areasManager = areasManager;
console.log("Areas loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");


syncStartWith = Date.now();
console.log("Loading Fight Manager...");
var fightManager = new FightManager();
Globals.fightManager = fightManager;
console.log("Fight Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

syncStartWith = Date.now();
console.log("Loading Shards...");

const Manager = new Discord.ShardingManager('./shardedMain.js');
Manager.spawn(2).then(() => {
    console.log("Shards loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");
    console.log("The bot and all of his shards are loaded, took : " + ((Date.now() - timeStart) / 1000) + " seconds");
    Manager.on("message", (shard, message) => {
        //console.log(message.type);
    });
}); // This example will spawn 2 shards (5,000 guilds);



const ApiResponder = require("./api/ApiResponder.js");


