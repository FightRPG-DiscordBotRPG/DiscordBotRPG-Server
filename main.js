'use strict';
const Commandes = require("./bin/Commandes.js")
const Discord = require("discord.js");
const Key = require("./conf/botkey.js");
const FightManager = require("./bin/FightManager");
const User = require("./bin/User");
const conn = require("./conf/mysql.js");
const Globals = require("./bin/Globals.js");


var bot = new Discord.Client();
var prefix = "::";
console.log("Bot Starting ...");

console.log(Globals);

bot.on("ready", () => {
    bot.user.setPresence({
        game: {
            name: "Aucun Joueur !",
        },
    });

    console.log("Bot Ready");
});

// Key Don't open
bot.login(Key);

var connectedUsers = {};
var connectedGuilds = {};

var fightManager = new FightManager();
var ChatReceiver = new Commandes(prefix);
ChatReceiver.bot = bot;
ChatReceiver.fightManager = fightManager;
ChatReceiver.connectedUsers = connectedUsers;
ChatReceiver.nbrConnectedUsers = 0;
ChatReceiver.connectedGuilds = connectedGuilds;



bot.on('message', (message) => {
    ChatReceiver.reactTo(message);
});


/* 
 * API HERE
*/

const express = require("express"),
    app = express(),
    port = process.env.PORT || 8080;

app.listen(port, () => console.log("Starting RESTful api server on: " + port));
