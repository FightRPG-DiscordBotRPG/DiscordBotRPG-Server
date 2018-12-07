const GModule = require("../GModule");
const Discord = require("discord.js");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
const Leaderboard = require("../../Leaderboard");
const Guild = require("../../Guild");
const Group = require("../../Group");
const Fight = require("../../Fight/Fight");
const Monster = require("../../Monstre");
const Translator = require("../../Translator/Translator");
const CraftSystem = require("../../CraftSystem/CraftSystem");
const AreaTournament = require("../../AreaTournament/AreaTournament");
const PStatistics = require("../../Achievement/PStatistics");
const Craft = require("../../CraftSystem/Craft");
const Item = require("../../Items/Item");
const Emojis = require("../../Emojis");
const express = require("express");

class AdminModule extends GModule {
    constructor() {
        super();
        this.commands = ["updatepresence", "giveme", "active", "mutefor", "xp", "gold", "resetfight", "reload_translations", "reload_emojis", "ldadmin", "reload_leaderboard", "debug", "last_command", "giveto", "active_players"];
        this.startLoading("Admin");
        this.init();
        this.endLoading("Admin");
    }

    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use(this.isAdmin);
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.post("/give/item/me", async (req, res) => {
            let data = {};
            req.body.idItem = parseInt(req.body.idItem);
            if (req.body.idItem && Number.isInteger(req.body.idItem)) {
                if (res.locals.tLootSystem.adminGetItem(Globals.connectedUsers[res.locals.id].character, req.body.idItem, req.body.number)) {
                    data.success = "Done";
                } else {
                    data.error = "Something goes wrong !";
                }
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/give/item/to", async (req, res) => {
            let data = {};
            req.body.idItem = parseInt(req.body.idItem); // idItem
            req.body.level = parseInt(req.body.level); // level
            req.body.number = parseInt(req.body.number); // nbr
            if (req.body.idUser && Globals.connectedUsers[req.body.idUser] != null) {
                if (res.locals.tLootSystem.giveToPlayer(Globals.connectedUsers[req.body.idUser].character, req.body.idItem, isNaN(req.body.level) ? 1 : req.body.level, req.body.number)) {
                    data.success = "Done";
                } else {
                    data.error = "Something goes wrong !";
                }
            } else {
                data.error = "User must be connected !";
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/active_players/:hours?", async (req, res) => {
            let data = {};
            let hourlyActivePlayers = {};
            let h = req.params.hours != null ? parseInt(req.params.hours) : 6;
            h = h - 1;
            h = h < 24 && h >= 0 ? h : 5;
            let actualDate = new Date();
            let nowTimeStamp = actualDate.getTime();
            let beforeTimeTimeStamp = actualDate.getTime() - (3600 * h * 1000);
            let beforeTime = new Date(beforeTimeTimeStamp);
            beforeTime.setMilliseconds(0);
            beforeTime.setSeconds(0);
            beforeTime.setMinutes(0);
            beforeTimeTimeStamp = beforeTime.getTime();

            let mres = conn.query('SELECT HOUR(FROM_UNIXTIME(commandslogs.timestamp/1000)) as "hr", COUNT(DISTINCT commandslogs.idUser) as "activePlayers" FROM `commandslogs` WHERE commandslogs.timestamp BETWEEN ? AND ? GROUP BY HOUR(FROM_UNIXTIME(commandslogs.timestamp/1000))', [beforeTimeTimeStamp, nowTimeStamp]);
            let firstHour = beforeTime.getHours();
            let nToSee = h;
            let n = 0;
            while (n <= nToSee) {
                hourlyActivePlayers[firstHour + "h"] = 0;
                firstHour++;
                n++;
                if (firstHour >= 24) {
                    firstHour = 0;
                }
            }
            for (let result of mres) {
                hourlyActivePlayers[result.hr + "h"] = result.activePlayers;
            }

            mres = conn.query("SELECT COUNT(DISTINCT idUser) as uniqueUsers FROM `commandslogs` WHERE commandslogs.timestamp > ?;", [beforeTimeTimeStamp]);


            data.hourlyActivePlayers = hourlyActivePlayers;
            data.uniqueUsers = mres[0].uniqueUsers;
            data.lang = res.locals.lang;
            return res.json(data);
        });

        // active - req.body
        this.router.post("/bot/activate", async (req, res) => {
            let data = {};
            if (req.body.active === "true") {
                Globals.activated = true;
                data.success = "Bot activated";
            } else if (req.body.active === "false") {
                Globals.activated = false;
                data.success = "Bot deactivated"
            }

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/user/mute", async (req, res) => {
            let data = {};
            if (req.body.idUser != null) {
                let muteTime = 100;
                if (req.body.time != null) {
                    muteTime = req.body.time;
                }

                if (Globals.connectedUsers[req.body.idUser]) {
                    Globals.connectedUsers[req.body.idUser].character.waitForNextFight(muteTime * 1000);
                    data.success = "User muted for " + muteTime + " seconds";
                } else {
                    data.error = "User is not connected!";
                }
            }

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/give/xp", async (req, res) => {
            let data = {};

            if (Globals.connectedUsers[res.locals.id].character.getLevel() < Globals.maxLevel) {
                let value = parseInt(req.body.xp, 10);
                if (!value && !Number.isInteger(value)) {
                    value = 1;
                }

                let str = "Tenez c'est le bon dieu qui vous l'offre ! \n" + value + " XP tombent du ciel rien que pour vous !\n";
                let actualLevel = Globals.connectedUsers[res.locals.id].character.getLevel();
                Globals.connectedUsers[res.locals.id].character.addExp(value);
                let diffLevel = Globals.connectedUsers[res.locals.id].character.getLevel() - actualLevel;
                if (diffLevel > 0) {
                    let plur = diffLevel > 1 ? "x" : "";
                    str += "<:levelup:403456740139728906> Bravo ! Vous avez gagné : " + diffLevel + " niveau" + plur + ". Vous êtes desormais niveau : " + Globals.connectedUsers[res.locals.id].character.getLevel() + " !\n";
                }
                data.success = str;
            } else {
                data.error = "Vous êtes déjà au niveau maximum !";
            }

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/give/gold", async (req, res) => {
            let data = {};

            if (req.body.idUser != null) {
                let value = parseInt(req.body.amount, 10);
                if (!value && !Number.isInteger(value)) {
                    value = 1;
                }
                if (Globals.connectedUsers[req.body.idUser] != null) {
                    Globals.connectedUsers[req.body.idUser].character.addMoney(value);
                    data.success = "C'est bon il a recu l'argent";
                } else {
                    data.error = "Non il existe pas ce mec";
                }
            } else {
                let value = parseInt(req.body.amount, 10);
                if (!value && !Number.isInteger(value)) {
                    value = 1;
                }

                data.success = "Tenez c'est le bon dieu qui vous l'offre ! \n" + value + " Argent tombent du ciel rien que pour vous !\n";
                Globals.connectedUsers[res.locals.id].character.addMoney(value);
                data.success += "<:treasure:403457812535181313> Vous avez désormais : " + Globals.connectedUsers[res.locals.id].character.getMoney() + " Argent !";
            }

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/resetfight", async (req, res) => {
            let data = {};

            Globals.connectedUsers[res.locals.id].character.canFightAt = 0;
            data.success = "Reset Done";

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/translations/reload", async (req, res) => {
            let data = {};

            Translator.nbOfTranslations = 0;
            Translator.loadSync();
            Translator.loadItemsBases();
            Translator.loadAreasBases();
            Translator.loadRegionsBases();
            Translator.loadMonstersBases();
            data.success = "Translations reloaded";

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/emojis/reload", async (req, res) => {
            let data = {};

            delete require.cache[require.resolve("../../Emojis.js")];
            require("../../Emojis.js");
            data.success = "Emojis reloaded";

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/last_command", async (req, res) => {
            let data = {};

            let lcommand = conn.query("SELECT * FROM commandslogs WHERE commandslogs.idUser != ? ORDER BY commandslogs.idCommandsLogs DESC LIMIT 1;", [res.locals.id]);
            data.success = "The last command used is: " + lcommand[0].command;
            data.success += "\nUsed " + ((Date.now() - lcommand[0].timestamp) / 1000) + " seconds ago.";

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/debug", async (req, res) => {
            console.log(User.getIdAndLang(res.locals.id));
        });



    }
}

module.exports = AdminModule;