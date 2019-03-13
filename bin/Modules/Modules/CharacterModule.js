const GModule = require("../GModule");
const Discord = require("discord.js");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
const LeaderboardPvP = require("../../Leaderboards/LeaderboardPvP");
const LeaderboardGold = require("../../Leaderboards/LeaderboardGold");
const LeaderboardLevel = require("../../Leaderboards/LeaderboardLevel");
const LeaderboardCraftLevel = require("../../Leaderboards/LeaderboardCraftLevel");
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



class CharacterModule extends GModule {
    constructor() {
        super();
        this.commands = ["reset", "leaderboard", "info", "up"];
        this.startLoading("Character");
        this.init();
        this.endLoading("Character");

        this.authorizedAttributes = ["str", "int", "con", "dex", "cha", "will", "luck", "wis", "per"];
    }

    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_character", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.freeLockedMembers();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/leaderboard/arena", async (req, res, next) => {
            let ld = new LeaderboardPvP(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard();
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            )
        });

        this.router.get("/leaderboard/gold", async (req, res, next) => {
            let ld = new LeaderboardGold(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard();
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            )
        });

        this.router.get("/leaderboard/level", async (req, res, next) => {
            let ld = new LeaderboardLevel(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard();
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            )
        });

        this.router.get("/leaderboard/craft/level", async (req, res, next) => {
            let ld = new LeaderboardCraftLevel(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard();
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            )
        });

        this.router.get("/reset", async (req, res, next) => {
            if (await Globals.connectedUsers[res.locals.id].character.resetStats()) {
                await next();
                return res.json({
                    success: Translator.getString(res.locals.lang, "character", "reset_done"),
                    lang: res.locals.lang,
                });
            } else {
                await next();
                return res.json({
                    error: Translator.getString(res.locals.lang, "errors", "character_you_dont_have_enough_to_reset"),
                    lang: res.locals.lang,
                });
            }

        });

        this.router.post("/update", async (req, res, next) => {
            if (req.body.username != null) {
                if (req.body.username.length <= 37) {
                    conn.query("UPDATE users SET userName = ? WHERE idUser = ?;", [req.body.username, res.locals.id]);
                    if (Globals.connectedUsers[res.locals.id]) {
                        Globals.connectedUsers[res.locals.id].updateInMemmoryUsername(req.bod.username);
                    }
                }
            }
        });

        this.router.get("/info", async (req, res, next) => {
            let data = await Globals.connectedUsers[res.locals.id].apiInfoPanel(res.locals.lang);
            await next();
            return res.json(
                data
            );
        });

        this.router.post("/up", async (req, res, next) => {
            let err;
            if (this.authorizedAttributes.indexOf(req.body.attr) !== -1) {
                let done = await Globals.connectedUsers[res.locals.id].character.upStat(req.body.attr, parseInt(req.body.number));
                if (done) {
                    await next();
                    return res.json({
                        value: Globals.connectedUsers[res.locals.id].character.stats[this.getToStrShort(req.body.attr)],
                        pointsLeft: Globals.connectedUsers[res.locals.id].character.statPoints,
                        lang: res.locals.lang
                    });
                } else {
                    err = Translator.getString(res.locals.lang, "errors", "character_you_cant_distribute_this_amount_of_points");
                }
            } else {
                err = Translator.getString(res.locals.lang, "errors", "character_attribute_dont_exist");
            }
            await next();
            return res.json({
                error: err,
                lang: res.locals.lang,
            });
        });

        this.router.get("/achievements/:page?", async (req, res, next) => {
            let data = {};
            let achPage = parseInt(req.params.page, 10);
            if (achPage == null || achPage != null && !Number.isInteger(achPage)) {
                achPage = 0;
            }

            data = await Globals.connectedUsers[res.locals.id].character.getAchievements().getAchievementList(data.page, res.locals.lang);

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });


    }

}

module.exports = CharacterModule;