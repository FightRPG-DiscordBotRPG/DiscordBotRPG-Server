const GModule = require("../GModule");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
const LeaderboardPvP = require("../../Leaderboards/LeaderboardPvP");
const LeaderboardGold = require("../../Leaderboards/LeaderboardGold");
const LeaderboardLevel = require("../../Leaderboards/LeaderboardLevel");
const LeaderboardCraftLevel = require("../../Leaderboards/LeaderboardCraftLevel");
const LeaderboardPower = require("../../Leaderboards/LeaderboardPower");
const LeaderboardAchievements = require("../../Leaderboards/LeaderboardAchievements");
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
const Skill = require("../../SkillsAndStatus/Skill");



class CharacterModule extends GModule {
    constructor() {
        super();
        this.commands = ["reset", "leaderboard", "info", "up", "attributes"];
        this.startLoading("Character");
        this.init();
        this.endLoading("Character");

        this.authorizedAttributes = ["str", "int", "con", "dex", "cha", "will", "luck", "wis", "per"];
    }

    init() {
        super.init();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_character", 1);
            next();
        });
    }

    loadRoutes() {
        this.router.get("/leaderboard/arena/:page?", async (req, res, next) => {
            let ld = new LeaderboardPvP(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard(req.params.page);
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            );
        });

        this.router.get("/leaderboard/gold/:page?", async (req, res, next) => {
            let ld = new LeaderboardGold(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard(req.params.page);
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            );
        });

        this.router.get("/leaderboard/level/:page?", async (req, res, next) => {
            let ld = new LeaderboardLevel(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard(req.params.page);
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            );
        });

        this.router.get("/leaderboard/craft/level/:page?", async (req, res, next) => {
            let ld = new LeaderboardCraftLevel(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard(req.params.page);
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            );
        });

        this.router.get("/leaderboard/power/:page?", async (req, res, next) => {
            let ld = new LeaderboardPower(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard(req.params.page);
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            );
        });

        this.router.get("/leaderboard/achievements/:page?", async (req, res, next) => {
            let ld = new LeaderboardAchievements(Globals.connectedUsers[res.locals.id].character.id);
            let data = await ld.getPlayerLeaderboard(req.params.page);
            data.lang = res.locals.lang;
            await next();
            return res.json(
                data
            );
        });

        this.router.get("/reset", async (req, res, next) => {
            if (await Globals.connectedUsers[res.locals.id].character.resetStats()) {
                let ptsLeft = await Globals.connectedUsers[res.locals.id].character.getStatPoints();
                let statPointsPlur = ptsLeft > 1 ? "_plural" : "";
                let ptsLeftStr = Translator.getString(res.locals.lang, "character", "attribute_x_points_available" + statPointsPlur, [ptsLeft]);
                let output = Translator.getString(res.locals.lang, "character", "reset_done") + " " + ptsLeftStr;
                await next();
                return res.json({
                    success: output,
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
            let err = null;
            if (req.body.username != null) {
                // Utf8 encoding length can be more than 37...
                if ([...req.body.username].length <= 37) {
                    await conn.query("UPDATE users SET userName = ? WHERE idUser = ?;", [req.body.username, res.locals.id]);
                    if (Globals.connectedUsers[res.locals.id]) {
                        Globals.connectedUsers[res.locals.id].updateInMemmoryUsername(req.body.username);
                    }
                } else {
                    err = "InvalidUsername (Too Long: " + req.body.username.length + " characters)";
                }
            } else {
                err = "InvalidUsername (No username entered)";
            }

            await next();
            return err != null ? res.json({ error: err }) : res.json({ done: true });
        });

        this.router.get("/info", async (req, res, next) => {
            let data = await Globals.connectedUsers[res.locals.id].apiInfoPanel(res.locals.lang);
            await next();
            return res.json(
                data
            );
        });

        this.router.get("/isTrading", async (req, res, next) => {
            let data = {
                isTrading: Globals.connectedUsers[res.locals.id].character.isTrading()
            };
            await next();
            return res.json(
                data
            );
        });

        this.router.post("/up", async (req, res, next) => {
            let err;
            if (this.authorizedAttributes.indexOf(req.body.attr) !== -1) {
                let done = await Globals.connectedUsers[res.locals.id].character.upStat(req.body.attr, parseInt(req.body.number));
                if (!done) {
                    err = Translator.getString(res.locals.lang, "errors", "character_you_cant_distribute_this_amount_of_points");
                }
            } else {
                err = Translator.getString(res.locals.lang, "errors", "character_attribute_dont_exist");
            }


            await next();
            if (err != null) {
                return res.json({
                    error: err,
                    lang: res.locals.lang,
                });
            } else {
                return res.json({
                    value: Globals.connectedUsers[res.locals.id].character.stats[this.getToStrShort(req.body.attr)],
                    pointsLeft: await Globals.connectedUsers[res.locals.id].character.getStatPoints(),
                    lang: res.locals.lang
                });
            }

        });

        this.router.get("/achievements/:page?", async (req, res, next) => {
            let data = await Globals.connectedUsers[res.locals.id].character.getAchievements().getAchievementList(parseInt(req.params.page, 10), res.locals.lang);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/talents", async (req, res, next) => {
            let data = await Globals.connectedUsers[res.locals.id].character.talents.toApi(res.locals.lang);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/talents/show/:idNode", async (req, res, next) => {
            let idNodeToSee = parseInt(req.params.idNode, 10);
            let err = null;
            let data = {};
            if (idNodeToSee != null) {
                let node = Globals.pstreenodes.getNode(idNodeToSee);
                if (node != null) {
                    data.node = await node.toApi(res.locals.lang);
                    data.isAquired = Globals.connectedUsers[res.locals.id].character.talents.talents[idNodeToSee] != null;
                    if (data.isAquired) {
                        data.unlockable = false;
                    } else {
                        data.unlockable = await Globals.connectedUsers[res.locals.id].character.talents.canUnlock(idNodeToSee);
                    }
                } else {
                    err = Translator.getString(res.locals.lang, "errors", "talents_show_node_dont_exist");
                }
            } else {
                err = Translator.getString(res.locals.lang, "errors", "talents_show_missing_id");
            }
            data.lang = res.locals.lang;


            await next();
            return err != null ? res.json({ error: err }) : res.json(data);
        });

        this.router.post("/talents/up", async (req, res, next) => {
            await next();
            return res.json(await this.tryUnlockTalent(req, res));
        });

        this.router.get("/skills/show/:idSkill", async (req, res, next) => {
            // Temp
            let err;
            let skill = new Skill();
            if (!await skill.loadWithID(parseInt(req.params.idSkill, 10))) {
                err = Translator.getString(res.locals.lang, "errors", "skill_show_dont_exist");
            }
            
            await next();
            return err != null ? res.json({ error: err }) : res.json({ skill: skill.toApi(Globals.connectedUsers[res.locals.id].character, res.locals.lang), lang: res.locals.lang});
        });


    }


    async tryUnlockTalent(req, res) {
        let character = Globals.connectedUsers[res.locals.id].character;
        let idNode = parseInt(req.body.idNode);

        if (isNaN(idNode)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "talents_show_missing_id"));
        }

        let node = Globals.pstreenodes.getNode(idNode);
        if (node == null) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "talents_show_node_dont_exist"));
        }

        if (character.talents.isReachable(idNode) == false) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "talents_node_not_reachable"));
        }

        if (await character.talents.haveEnoughPoints(idNode) == false) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "talents_not_enough_points"));
        }

        if (character.talents.isTalentUnlocked(idNode)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "talents_already_unlocked"));
        }


        if (!character.talents.unlock(idNode)) {
            // Unknown error or not implemented check maybe
            return this.asError(Translator.getString(res.locals.lang, "errors", "generic_cant_do_that"));
        }

        return {
            node: await node.toApi(res.locals.lang),
            pointsLeft: await Globals.connectedUsers[res.locals.id].character.getStatPoints(),
        };

    }

}

module.exports = CharacterModule;
