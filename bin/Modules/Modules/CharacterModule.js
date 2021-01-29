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
const Character = require("../../Character");
const RebirthApiData = require("../../Rebirths/RebirthApiData");



class CharacterModule extends GModule {
    constructor() {
        super();
        this.commands = ["reset", "leaderboard", "info", "up", "attributes", "resettalents"];
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

        this.router.get("/talents/reset", async (req, res, next) => {
            if (await Globals.connectedUsers[res.locals.id].character.resetTalents()) {
                let ptsLeft = await Globals.connectedUsers[res.locals.id].character.getTalentPoints();
                let talentPointsPlur = ptsLeft > 1 ? "_plural" : "";
                let ptsLeftStr = Translator.getString(res.locals.lang, "character", "attribute_x_points_available" + talentPointsPlur, [ptsLeft]);
                let output = Translator.getString(res.locals.lang, "character", "reset_done") + " " + ptsLeftStr;
                await next();
                return res.json({
                    success: output,
                    lang: res.locals.lang,
                });
            } else {
                await next();
                return res.json({
                    error: Translator.getString(res.locals.lang, "errors", "character_you_dont_have_enough_to_reset_talents"),
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

            if (req.body.avatar != null) {
                try {
                    await conn.query("UPDATE users SET avatar = ? WHERE idUser = ?;", [req.body.avatar, res.locals.id]);
                } catch (ex) {
                    console.log("Exception on avatar set: " + ex);
                }
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

        this.router.get("/rebirth", async (req, res, next) => {
            let data = await Globals.connectedUsers[res.locals.id].toApiToRebirth(res.locals.lang);
            await next();
            return res.json(
                data
            );
        });

        this.router.post("/rebirth", async (req, res, next) => {

            let data;
            if (req.body.rebirthType === "level") {
                data = await this.rebirthCharacter(res.locals.character, res.locals.lang);
            } else {
                data = await this.rebirthCraft(res.locals.character, res.locals.lang);
            }

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

        this.router.get("/talents/export", async (req, res, next) => {
            let data = Globals.connectedUsers[res.locals.id].character.talents.toExport();
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/talents/import", async (req, res, next) => {
            // Protect this more by limiting the number of characters (or something)
            let allNodesString = req.body.talentsIds == null ? "" : req.body.talentsIds;

            /**
             * @type any[]
             */
            let allNodesIds = allNodesString.split(",");

            //Idiot way Optimize one day pls someone
            //console.time("Idiot Way");
            let somethingWasAdded = true;
            let lastGoodResult = null;
            let lastBadResult = null;

            while (somethingWasAdded) {
                somethingWasAdded = false;
                let newAllNodesIds = [];
                for (let i in allNodesIds) {
                    let lastResult = await this.tryUnlockTalent(res.locals.character, parseInt(allNodesIds[i]), res.locals.lang);
                    if (lastResult.error) {
                        newAllNodesIds.push(allNodesIds[i]);
                        lastBadResult = lastResult;
                    } else {
                        lastGoodResult = lastResult;
                        somethingWasAdded = true;
                    }
                }
                allNodesIds = newAllNodesIds;
            }

            let data;
            if (lastGoodResult) {
                if (lastBadResult && allNodesIds.length > 0) {
                    data = this.asSuccess(Translator.getString(res.locals.lang, "talents", "talents_import_not_totally_successful", [allNodesIds.join(","), lastBadResult.error]));
                } else {
                    data = this.asSuccess(Translator.getString(res.locals.lang, "talents", "talents_import_successful"));
                }
            } else {
                data = lastBadResult;
            }

            //let data = await Globals.connectedUsers[res.locals.id].character.talents.import(allNodes.split(","));
            //data.lang = res.locals.lang;
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
            return res.json(await this.tryUnlockTalent(res.locals.character, parseInt(req.body.idNode), res.locals.lang));
        });

        this.router.get("/skills/show/:idSkill", async (req, res, next) => {
            // Temp
            let err;
            let data;
            let skill = new Skill();
            let idSkill = parseInt(req.params.idSkill, 10);
            if (isNaN(idSkill) || !await skill.loadWithID(idSkill)) {
                err = Translator.getString(res.locals.lang, "errors", "skill_show_dont_exist");
            }

            if (err != null) {
                data = { error: err };
            } else {
                data = {
                    skill: skill.toApi(res.locals.character, res.locals.lang),
                    lang: res.locals.lang
                };
            }


            await next();
            return res.json(data);
        });

        this.router.get("/build/show", async (req, res, next) => {
            await next();
            return res.json(res.locals.character.skillBuild.toApi(res.locals.lang));
        });

        this.router.post("/build/add", async (req, res, next) => {
            await next();
            return res.json(await this.tryAddSkillToBuild(req, res));
        });

        this.router.post("/build/move", async (req, res, next) => {
            await next();
            return res.json(await this.tryMoveSkillBuild(req, res));
        });

        this.router.post("/build/remove", async (req, res, next) => {
            await next();
            return res.json(await this.tryRemoveSkillFromBuild(req, res));
        });

        this.router.post("/build/clear", async (req, res, next) => {
            await next();
            return res.json(await this.tryClearBuild(res));
        });

    }

    async tryClearBuild(res) {
        /**
        * @type {Character}
        */
        let character = res.locals.character;
        await character.skillBuild.reset()
        return this.asSuccess(Translator.getString(res.locals.lang, "skills_builds", "reset_success"));
    }

    async tryRemoveSkillFromBuild(req, res) {
        /**
        * @type {Character}
        */
        let character = res.locals.character;
        let idSkill = parseInt(req.body.idSkill, 10);

        if (isNaN(idSkill) || !await Skill.exists(idSkill)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "skill_show_dont_exist"));
        }

        if (!character.skillBuild.isSkillEquipped(idSkill)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "skill_build_not_equipped"));
        }


        if (await character.skillBuild.removeSkill(idSkill)) {
            return this.asSuccess(Translator.getString(res.locals.lang, "skills_builds", "remove_success", [Skill.getName(idSkill)]));
        } else {
            return this.asError(Translator.getString(res.locals.lang, "errors", "generic"));
        }
    }

    async tryMoveSkillBuild(req, res) {
        /**
        * @type {Character}
        */
        let character = res.locals.character;

        let idSkill = parseInt(req.body.idSkill, 10);
        let priority = parseInt(req.body.priority, 10);

        if (isNaN(idSkill) || !await Skill.exists(idSkill)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "skill_show_dont_exist"));
        }

        if (isNaN(priority) || priority < 0 || priority >= Globals.maximumSkillsPerBuild) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "skill_build_incorrect_priority"));
        }

        if (!character.skillBuild.isSkillEquipped(idSkill)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "skill_build_not_equipped"));
        }

        if (await character.skillBuild.swapSkill(idSkill, priority)) {
            return this.asSuccess(Translator.getString(res.locals.lang, "skills_builds", "swap_succes"));
        } else {
            return this.asError(Translator.getString(res.locals.lang, "errors", "generic"));
        }


    }

    async tryAddSkillToBuild(req, res) {
        /**
        * @type {Character}
        */
        let character = res.locals.character;

        let idSkill = parseInt(req.body.idSkill, 10);

        if (isNaN(idSkill) || !await Skill.exists(idSkill)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "skill_show_dont_exist"));
        }

        let equipErrorString = character.skillBuild.getErrorEquip(idSkill);
        if (equipErrorString !== null) {
            return this.asError(Translator.getString(res.locals.lang, "errors", equipErrorString));
        }

        if (await character.skillBuild.pushSkill(idSkill)) {
            return this.asSuccess(Translator.getString(res.locals.lang, "skills_builds", "add_success", [Skill.getName(idSkill)]));
        } else {
            return this.asError(Translator.getString(res.locals.lang, "errors", "generic"));
        }
    }

    /**
     * 
     * @param {Character} character
     * @param {number} idNode
     * @param {string} lang
     */
    async tryUnlockTalent(character, idNode, lang = "en") {
        if (isNaN(idNode)) {
            return this.asError(Translator.getString(lang, "errors", "talents_show_missing_id"));
        }

        let node = Globals.pstreenodes.getNode(idNode);
        if (node == null) {
            return this.asError(Translator.getString(lang, "errors", "talents_show_node_dont_exist"));
        }

        if (character.talents.isReachable(idNode) == false) {
            return this.asError(Translator.getString(lang, "errors", "talents_node_not_reachable"));
        }

        if (await character.talents.haveEnoughPoints(idNode) == false) {
            return this.asError(Translator.getString(lang, "errors", "talents_not_enough_points"));
        }

        if (character.talents.isTalentUnlocked(idNode)) {
            return this.asError(Translator.getString(lang, "errors", "talents_already_unlocked"));
        }


        if (!await character.talents.unlock(idNode)) {
            // Unknown error or not implemented check maybe
            return this.asError(Translator.getString(lang, "errors", "generic_cant_do_that"));
        }

        return {
            node: await node.toApi(lang),
            pointsLeft: await character.getTalentPoints(),
        };
    }

    /**
     * 
     * @param {Character} character
     * @param {string} lang
     */
    async rebirthCharacter(character, lang = "en") {
        let rebirthData = await character.getRebirthDataCharacterToApi(lang);

        let errors = this.getRebirthErrors(rebirthData, lang);

        if (errors.error) {
            return errors;
        }

        await this.removeRebirthNeedItems(character, rebirthData);
        await character.rebirth();

        return this.asSuccess(Translator.getString(lang, "character", "rebirth_successful"));
    }

    /**
     *
     * @param {Character} character
     * @param {string} lang
     */
    async rebirthCraft(character, lang = "en") {
        let rebirthData = await character.getRebirthDataCraftToApi(lang);
        let errors = this.getRebirthErrors(rebirthData, lang);

        if (errors.error) {
            return errors;
        }

        await this.removeRebirthNeedItems(character, rebirthData);
        await character.rebirthCraft();

        return this.asSuccess(Translator.getString(lang, "character", "rebirth_successful"));
    }

    /**
     * 
     * @param {Character} character
     * @param {RebirthApiData} apiData
     * @param {string} lang
     */
    async removeRebirthNeedItems(character, apiData) {
        let promises = [];
        for (let item of apiData.nextRebirthsLevelsModifiers.requiredItems) {
            console.log(item);
            promises.push(character.getInv().removeSomeFromInventoryIdBase(item.idBase, item.number, true));
        }
        await Promise.all(promises);
    }

    /**
     * 
     * @param {RebirthApiData} data
     */
    getRebirthErrors(data, lang = "en") {
        if (data.rebirthLevel == data.maxRebirthLevel) {
            return this.asError(Translator.getString(lang, "errors", "rebirth_cant_rebirth_max_level"));
        }

        if (data.level < data.maxLevel) {
            return this.asError(Translator.getString(lang, "errors", "rebirth_not_max_level"));
        }

        for (let item of data.nextRebirthsLevelsModifiers.requiredItems) {
            if (item.missing > 0) {
                return this.asError(Translator.getString(lang, "errors", "rebirth_dont_have_required_items"));
            }
        }

        return {};
    }

}

module.exports = CharacterModule;
