'use strict';
const Commandes = require("./bin/Commandes.js")
const Globals = require("./bin/Globals.js");
const Discord = require("discord.js");
const Key = require("./conf/botkey.js");

var bot = new Discord.Client();

console.log("Bot Starting ...");
bot.on("ready", () => {
    /*bot.user.setPresence({
        game: {
            name: "Aucun Joueur !",
        },
    });*/

    console.log("Bot Ready");
});
bot.login(Key);
var ChatReceiver = new Commandes("::");

ChatReceiver.bot = Globals.bot;
ChatReceiver.fightManager = Globals.fightManager;
ChatReceiver.connectedUsers = Globals.connectedUsers;
ChatReceiver.nbrConnectedUsers = 0;
ChatReceiver.connectedGuilds = Globals.connectedGuilds;
ChatReceiver.areasManager = Globals.areasManager;
Globals.discordClient = bot;



bot.on('message', (message) => {
    try {
        console.log(Globals);
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