'use strict';
const Commandes = require("./bin/Commandes.js")
const Discord = require("discord.js");
const Key = require("./conf/botkey.js");
const FightManager = require("./bin/FightManager");
const User = require("./bin/User");
const conn = require("./conf/mysql.js");
const Globals = require("./bin/Globals.js");
const crypto = require("crypto");
const AreasManager = require("./bin/Areas/AreasManager.js");
const Translator = require("./bin/Translator/Translator");


var bot = new Discord.Client();
var prefix = "::";

process.on('unhandledRejection', up => { throw up });

console.log("Bot Starting ...");

console.log(Globals);

bot.on("ready", () => {
    bot.user.setPresence({
        game: {
            name: "On " + bot.guilds.reduce((acc) => acc + 1, 0) + " guilds !",
        },
    });

    console.log("Bot Ready");
});

// Key Don't open
bot.login(Key);


// UNDER CONSTRUCTION SUBJECT TO CHANGE
var connectedUsers = {};
var connectedGuilds = {};

Globals.connectedUsers = connectedUsers;
Globals.connectedGuilds = connectedGuilds;
Globals.areasManager = new AreasManager();
Globals.fightManager = new FightManager();
Globals.discordClient = bot;

var ChatReceiver = new Commandes(prefix);

ChatReceiver.bot = bot;
ChatReceiver.fightManager = Globals.fightManager;
ChatReceiver.connectedUsers = connectedUsers;
ChatReceiver.nbrConnectedUsers = 0;
ChatReceiver.connectedGuilds = connectedGuilds;
ChatReceiver.areasManager = Globals.areasManager;



bot.on('message', (message) => {
    try {
        ChatReceiver.reactTo(message);
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

bot.on('guildCreate', () => {
    bot.user.setPresence({
        game: {
            name: "On " + bot.guilds.reduce((acc) => acc + 1, 0) + " guilds !",
        },
    });
});

bot.on('guildDelete', () => {
    bot.user.setPresence({
        game: {
            name: "On " + bot.guilds.reduce((acc) => acc + 1, 0) + " guilds !",
        },
    });
});



// Load api after all 
const ApiResponder = require("./api/ApiResponder.js");


