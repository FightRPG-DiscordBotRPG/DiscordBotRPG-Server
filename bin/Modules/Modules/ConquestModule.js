const GModule = require("../GModule");
const Discord = require("discord.js");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
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


class ConquestModule extends GModule {
    constructor() {
        super();
        this.commands = ["arealevelup", "areaupbonus", "areabonuseslist", "areaconquest"];
        this.startLoading("Conquest");
        this.init();
        this.endLoading("Conquest");
    }
    init() {
        this.router = express.Router();

        // Add to router needed things
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_conquest", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.freeLockedMembers();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.post("/area/levelup", async (req, res, next) => {
            let data = {};
            let tGuildId = await Globals.connectedUsers[res.locals.id].character.getIDGuild();
            if (await res.locals.currentArea.getOwnerID() === tGuildId) {
                if (await Globals.connectedUsers[res.locals.id].character.isInGuild() && Globals.connectedGuilds[tGuildId].getRankCharacter(Globals.connectedUsers[res.locals.id].character.id) === 3) {
                    if (!await AreaTournament.haveStartedByIdArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                        if (!await res.locals.currentArea.isMaxLevel()) {
                            let toLevelUpArea = await res.locals.currentArea.getPriceNextLevel();
                            if (await Globals.connectedGuilds[tGuildId].haveThisMoney(toLevelUpArea)) {
                                await Promise.all([
                                    res.locals.currentArea.levelUp(),
                                    Globals.connectedGuilds[tGuildId].removeMoneyDirect(toLevelUpArea)
                                ])
                                data.success = Translator.getString(res.locals.lang, "area", "level_up") + "\n";
                                data.success += Translator.getString(res.locals.lang, "guild", "you_paid_x", [toLevelUpArea]);
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "guild_you_dont_have_enough_money");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "area_at_max_level");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "guild_tournament_started_generic");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "guild_dont_have_permission_to_levelup_area");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_dont_own_this_area");
            }
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/area/bonus/up", async (req, res, next) => {
            let data = {};
            let tGuildId = await Globals.connectedUsers[res.locals.id].character.getIDGuild();
            if (await res.locals.currentArea.getOwnerID() === tGuildId) {
                if (await Globals.connectedUsers[res.locals.id].character.isInGuild() && Globals.connectedGuilds[tGuildId].getRankCharacter(Globals.connectedUsers[res.locals.id].character.id) === 3) {
                    if (!await AreaTournament.haveStartedByIdArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                        if (res.locals.currentArea.isBonusAvailable(req.body.bonus_identifier)) {
                            req.body.number = req.body.number != null ? Number.parseInt(req.body.number) : 1000;
                            req.body.number = req.body.number > 0 ? req.body.number : 1000;
                            if (await res.locals.currentArea.haveThisAmountOfStatPoints(req.body.number)) {
                                await res.locals.currentArea.upStat(req.body.bonus_identifier, req.body.number);
                                data.success = Translator.getString(res.locals.lang, "area", "up_stat", [Translator.getString(res.locals.lang, "bonuses", req.body.bonus_identifier), req.body.number]);
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "area_dont_have_enough_stat_points");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "area_bonus_not_available");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "guild_tournament_started_generic");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "generic_cant_do_that");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_dont_own_this_area");
            }
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });


        this.router.get("/area/bonuses", async (req, res, next) => {
            let data = {};
            data = res.locals.currentArea.getListOfBonuses(res.locals.lang);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/area", async (req, res, next) => {
            let data = {};
            data = await res.locals.currentArea.getConquest(res.locals.lang);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });




    }
}

module.exports = ConquestModule;