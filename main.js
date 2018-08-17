'use strict';
const Globals = require("./bin/Globals.js");
const Commandes = require("./bin/Commandes.js")
const Discord = require("discord.js");
const Key = require("./conf/botkey.js");
const FightManager = require("./bin/FightManager");
const crypto = require("crypto");
const AreasManager = require("./bin/Areas/AreasManager.js");
const conf = require("./conf/conf");
const DatabaseInitializer = require("./bin/DatabaseInitializer");
const ModuleHandler = require("./bin/Modules/ModuleHandler");


var bot = new Discord.Client();
var prefix = "::";

var timeStart = Date.now();
let syncStartWith = Date.now();
let totalGameStartTime = Date.now();

process.on('unhandledRejection', up => { throw up });

console.log("Initializing Database ...");
DatabaseInitializer.initialize();
console.log("Database initialized, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

console.log("Bot Starting ...");

//console.log(Globals);

bot.on("ready", () => {
    console.log("Bot Connected");
    
    bot.user.setPresence({
        game: {
            name: "On " + bot.guilds.size + " guilds !",
        },
    });

    
    if(conf.env === "prod") {
        const DBL = require("dblapi.js");
        const dbl = new DBL(conf.discordbotskey, bot);

        setInterval(() => {
            console.log("Sending stats to https://discordbots.org/ ...");
            dbl.postStats(bot.guilds.size);
            console.log("Data sent");
        }, 1800000);
    }
    
    console.log("Loading servers stats ...");
    DatabaseInitializer.serversStats(bot.guilds);
    console.log("Servers stats loaded");

    console.log("Bot ready");
    console.log("Bot load finished, took : " + ((Date.now() - timeStart) / 1000) + " seconds");

});

// Key Don't open
bot.login(Key);

let moduleHandler = new ModuleHandler();

// UNDER CONSTRUCTION SUBJECT TO CHANGE
var connectedUsers = {};
var connectedGuilds = {};

Globals.connectedUsers = connectedUsers;
Globals.connectedGuilds = connectedGuilds;

syncStartWith = Date.now();
console.log("Loading Areas...");
Globals.areasManager = new AreasManager();
console.log("Areas loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");


syncStartWith = Date.now();
console.log("Loading Fight Manager...");
Globals.fightManager = new FightManager();
console.log("Fight Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");
Globals.discordClient = bot;

syncStartWith = Date.now();
console.log("Loading Commands module...");
var ChatReceiver = new Commandes(prefix);
console.log("Commands module loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

console.log("Game World loaded, took : " + ((Date.now() - totalGameStartTime) / 1000) + " seconds");

ChatReceiver.bot = bot;
ChatReceiver.fightManager = Globals.fightManager;
ChatReceiver.connectedUsers = connectedUsers;
ChatReceiver.connectedGuilds = connectedGuilds;
ChatReceiver.areasManager = Globals.areasManager;



bot.on('message', async (message) => {
    try {
        //await ChatReceiver.reactTo(message);
        await moduleHandler.run(message);
    } catch (err) {
        let msgError = "Oops something goes wrong, report the issue here (https://github.com/FightRPG-DiscordBotRPG/FightRPG-Discord-BugTracker/issues)\n";

        let errorsLines = err.stack.split("\n");
        let nameAndLine = errorsLines[1].split(" ");
        nameAndLine = nameAndLine[nameAndLine.length - 1].split("\\");
        nameAndLine = nameAndLine[nameAndLine.length - 1].split(")")[0];

        msgError += "```js\n" + errorsLines[0] + "\nat " + nameAndLine + "\n```";

        console.log(err);
        message.channel.send(msgError);
    }
    
});

bot.on('guildCreate', (guild) => {
    bot.user.setPresence({
        game: {
            name: "On " + bot.guilds.size + " guilds !",
        },
    });
    DatabaseInitializer.newGuild(guild);
});

bot.on('guildDelete', () => {
    bot.user.setPresence({
        game: {
            name: "On " + bot.guilds.size + " guilds !",
        },
    });
});



// Load api after all 
//const ApiResponder = require("./api/ApiResponder.js");


