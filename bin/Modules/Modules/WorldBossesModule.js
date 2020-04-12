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
const WorldBossSpawner = require("../../WorldBosses/WorldBossSpawner");
const LeaderboardWBDamage = require("../../Leaderboards/LeaderboardWBDamage");
const LeaderboardWBAttacks = require("../../Leaderboards/LeaderboardWBAttacks");


class WorldBosses extends GModule {
    constructor() {
        super();
        this.commands = ["bossshowall", "bossfight"];
        this.startLoading("WorldBosses");
        this.init();
        this.endLoading("WorldBosses");
    }
    init() {
        this.router = express.Router();

        // Add to router needed things
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_worldboss", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.freeLockedMembers();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/display/all", async (req, res, next) => {
            let data = {};

            data = await WorldBossSpawner.getBossesInfos(res.locals.lang);

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/display/myarea", async (req, res, next) => {
            let data = {
                worldBoss: null
            };

            let wb = await res.locals.currentArea.getWorldBoss(res.locals.lang);
            if (wb) {
                data.worldBoss = await wb.toApi(res.locals.lang);
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/fight", async (req, res, next) => {
            let data = {};

            let wb = await res.locals.currentArea.getWorldBoss(res.locals.lang);
            if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
                if (wb != null) {
                    data = await WorldBossSpawner.userAttack(Globals.connectedUsers[res.locals.id].character, wb);
                } else {
                    data.error = Translator.getString(res.locals.lang, "world_bosses", "no_world_boss");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "generic_tired", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/display/lastboss", async (req, res, next) => {
            let data = {
                worldBoss: null
            };

            data.worldBoss = await WorldBossSpawner.getLastBossCharacterStats(Globals.connectedUsers[res.locals.id].character.id, res.locals.lang);

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/leaderboard/damage", async (req, res, next) => {
            let ld = new LeaderboardWBDamage(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard();
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/leaderboard/attacks", async (req, res, next) => {
            let ld = new LeaderboardWBAttacks(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard();
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });


    }

}

module.exports = WorldBosses;