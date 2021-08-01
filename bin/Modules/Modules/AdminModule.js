const GModule = require("../GModule");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
const Guild = require("../../Guild");
const Group = require("../../Group");
const Fight = require("../../Fight/Fight");
const Monster = require("../../Entities/Monster");
const Translator = require("../../Translator/Translator");
const CraftSystem = require("../../CraftSystem/CraftSystem");
const AreaTournament = require("../../AreaTournament/AreaTournament");
const PStatistics = require("../../Achievement/PStatistics");
const Craft = require("../../CraftSystem/Craft");
const Item = require("../../Items/Item");
const Emojis = require("../../Emojis");
const express = require("express");
const State = require("../../SkillsAndStatus/State");
const Skill = require("../../SkillsAndStatus/Skill");
const Effect = require("../../SkillsAndStatus/Effect");
const Utils = require("../../Utilities/Utils");
const Character = require("../../Character");

class AdminModule extends GModule {
    constructor() {
        super();
        this.commands = ["updatepresence", "giveme", "active", "mutefor", "xp", "gold", "resetfight", "reload_translations", "reload_emojis", "ldadmin", "reload_leaderboard", "debug", "last_command", "giveto", "active_players", "debug"];
        this.startLoading("Admin");
        this.init();
        this.endLoading("Admin");
    }

    init() {
        super.init();
        this.router.use(this.isAdmin);
    }

    loadRoutes() {
        this.router.post("/give/item/me", async (req, res, next) => {
            let data = {};
            req.body.idItem = parseInt(req.body.idItem);
            if (req.body.idItem && Number.isInteger(req.body.idItem)) {
                if (await res.locals.tLootSystem.adminGetItem(Globals.connectedUsers[res.locals.id].character, req.body.idItem, req.body.number, req.body.level, req.body.rebirthLevel)) {
                    data.success = "Done";
                } else {
                    data.error = "Something goes wrong !";
                }
            }
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/give/item/to", async (req, res, next) => {
            let data = {};
            req.body.idItem = parseInt(req.body.idItem); // idItem
            req.body.level = parseInt(req.body.level); // level
            req.body.number = parseInt(req.body.number); // nbr
            req.body.rebirthLevel = parseInt(req.body.rebirthLevel); // nbr
            if (req.body.idUser && Globals.connectedUsers[req.body.idUser] != null) {
                if (await res.locals.tLootSystem.giveToPlayer(Globals.connectedUsers[req.body.idUser].character, req.body.idItem, isNaN(req.body.level) ? 1 : req.body.level, req.body.number, false, isNaN(req.body.rebirthLevel) ? 1 : req.body.rebirthLevel)) {
                    data.success = "Done";
                } else {
                    data.error = "Something goes wrong !";
                }
            } else {
                data.error = "User must be connected !";
            }
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/active_players/:hours?", async (req, res, next) => {
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

            let mres = await conn.query('SELECT HOUR(FROM_UNIXTIME(commandslogs.timestamp/1000)) as "hr", COUNT(DISTINCT commandslogs.idUser) as "activePlayers" FROM `commandslogs` WHERE commandslogs.timestamp BETWEEN ? AND ? GROUP BY HOUR(FROM_UNIXTIME(commandslogs.timestamp/1000))', [beforeTimeTimeStamp, nowTimeStamp]);
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

            mres = await conn.query("SELECT COUNT(DISTINCT idUser) as uniqueUsers FROM `commandslogs` WHERE commandslogs.timestamp > ?;", [beforeTimeTimeStamp]);


            data.hourlyActivePlayers = hourlyActivePlayers;
            data.uniqueUsers = mres[0].uniqueUsers;
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        // active - req.body
        this.router.post("/bot/activate", async (req, res, next) => {
            let data = {};
            if (req.body.active === "true") {
                Globals.activated = true;
                Globals.maintenance_message = null;
                data.success = "Bot activated";
            } else if (req.body.active === "false") {
                Globals.activated = false;
                Globals.maintenance_message = req.body.reason;
                data.success = "Bot deactivated"
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/user/mute", async (req, res, next) => {
            let data = {};
            if (req.body.idUser != null) {
                let muteTime = 100;
                if (req.body.time != null) {
                    muteTime = req.body.time;
                }

                if (Globals.connectedUsers[req.body.idUser]) {
                    await Globals.connectedUsers[req.body.idUser].character.waitForNextFight(muteTime * 1000);
                    data.success = "User muted for " + muteTime + " seconds";
                } else {
                    data.error = "User is not connected!";
                }
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/give/xp", async (req, res, next) => {
            let data = {};

            let value = parseInt(req.body.xp, 10);
            if (!value && !Number.isInteger(value)) {
                value = 1;
            }

            if (Globals.connectedUsers[res.locals.id].character.getLevel() < Globals.maxLevel) {
                let str = "Tenez c'est le bon dieu qui vous l'offre ! \n" + value + " XP tombent du ciel rien que pour vous !\n";
                let actualLevel = Globals.connectedUsers[res.locals.id].character.getLevel();
                await Globals.connectedUsers[res.locals.id].character.addExp(value);
                let diffLevel = Globals.connectedUsers[res.locals.id].character.getLevel() - actualLevel;
                if (diffLevel > 0) {
                    let plur = diffLevel > 1 ? "x" : "";
                    str += "<:levelup:403456740139728906> Bravo ! Vous avez gagné : " + diffLevel + " niveau" + plur + ". Vous êtes desormais niveau : " + Globals.connectedUsers[res.locals.id].character.getLevel() + " !\n";
                }
                data.success = str;
            } else {
                data.error = "Vous êtes déjà au niveau maximum !";
            }

            if (res.locals.character.getCraftLevel() < Globals.maxLevel) {
                await res.locals.character.addCraftXP(value);
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/give/gold", async (req, res, next) => {
            let data = {};

            if (req.body.idUser != null) {
                let value = parseInt(req.body.amount, 10);
                if (!value && !Number.isInteger(value)) {
                    value = 1;
                }
                if (Globals.connectedUsers[req.body.idUser] != null) {
                    await Globals.connectedUsers[req.body.idUser].character.addMoney(value);
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
                await Globals.connectedUsers[res.locals.id].character.addMoney(value);
                data.success += "<:treasure:403457812535181313> Vous avez désormais : " + (await Globals.connectedUsers[res.locals.id].character.getMoney()) + " Argent !";
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/resetfight", async (req, res, next) => {
            let data = {};

            await Promise.all([Globals.connectedUsers[res.locals.id].character.setWaitTime(0), Globals.connectedUsers[res.locals.id].character.setWaitTimePvP(0)]);
            data.success = "Reset Done";

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/translations/reload", async (req, res, next) => {
            let data = {};

            await Translator.load();
            data.success = "Translations reloaded";

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/emojis/reload", async (req, res, next) => {
            let data = {};

            delete require.cache[require.resolve("../../Emojis.js")];
            require("../../Emojis.js");
            data.success = "Emojis reloaded";

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/last_command", async (req, res, next) => {
            let data = {};

            let lcommand = await conn.query("SELECT * FROM commandslogs WHERE commandslogs.idUser != ? ORDER BY commandslogs.idCommandsLogs DESC LIMIT 1;", [res.locals.id]);
            data.success = "The last command used is: " + lcommand[0]?.command;
            data.success += "\nUsed " + ((Date.now() - lcommand[0]?.timestamp) / 1000) + " seconds ago.";

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/debug/", async (req, res, next) => {

            //console.log(await Globals.connectedUsers[res.locals.id].character.achievements.hasEveryAchievements([1,4,5]));
            //let s = new Skill();
            //await s.loadWithID(6);
            //console.log(s);
            //let st = new State();
            //await st.loadWithID(4);
            //console.log(await Effect.newEffect(1));
            //await Globals.connectedUsers[res.locals.id].tell("Test");
            //await Globals.connectedUsers[res.locals.id].character.loadSkills()
            //console.log(Globals.connectedUsers[res.locals.id].character.skills);
            //console.log(Globals.connectedUsers[res.locals.id].character.getElementalResist(Globals.elementsTypesNameById[0] + "Resist"));
            //console.log(Globals);
            //let guild = new Guild();
            //await guild.loadGuild(33);

            //let guild2 = new Guild();
            //await guild2.loadGuild(55);
            //console.time("Test");
            //await guild.getCharacters();
            //await guild2.getCharacters();
            //console.timeEnd("Test");

            //console.time("Test Promise All");
            //await Promise.all([
            //    guild.getCharacters(),
            //    guild2.getCharacters()
            //]);
            //console.timeEnd("Test Promise All");

            //let mst = new Monster(1);
            //mst.loadMonster(100);
            //mst.secondaryStats.airResist = -10;
            //console.log(mst.getElementalResistMultiplier("airResist"));
            //mst.secondaryStats.airResist = 10;
            //console.log(mst.getElementalResistMultiplier("airResist"));

            //console.log("user");
            //console.log(Globals.connectedUsers[res.locals.id].character.getElementalResistMultiplier("darkResist"));
            //console.log(Globals.connectedUsers[res.locals.id].character.getElementalResistMultiplier("fireResist"));
            //if (res.locals.currentArea.areaType === "dungeon") {
            //    console.log("start debug");
            //    console.time("getEntrance");
            //    await res.locals.currentArea.getEntrance();
            //    console.timeEnd("getEntrance");

            //    console.time("getNextFloorOrExit");
            //    await res.locals.currentArea.getNextFloorOrExit();
            //    console.timeEnd("getNextFloorOrExit");
            //}

            //await res.locals.character.addStatPoints(10);

            //let data = {};
            //for (let item of Object.values(Globals.eventsManager.ongoingEvents)) {
            //    data[item.id] = await item.toApi(res.locals.lang);
            //}
            //console.log(data);

            await new Promise(resolve => setTimeout(resolve, 5000));

            await next();
            return res.json({ succes: "done" });
        });
    }

    async debugDungeonTest(req, res, next) {
        if (Globals.connectedUsers[res.locals.id].character.group == null) {
            Globals.connectedUsers[res.locals.id].character.group = new Group(Globals.connectedUsers[res.locals.id]);
        }

        // Load users for dungeon
        let dungeonToTest = Number.parseInt(req.query.p2);

        for (let user of req.query.p1.split(",")) {
            user = await User.getIDByIDCharacter(user);
            await this.debugCreateUser(user);
            await Globals.connectedUsers[user].character.changeArea(Globals.areasManager.getArea(dungeonToTest));
            await Globals.connectedUsers[res.locals.id].character.group.addPlayer(Globals.connectedUsers[user]);
        }

        await next();
        return res.json({ success: "done" });
    }
}

module.exports = AdminModule;