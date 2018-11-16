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
        this.crashHandler();
    }

    loadRoutes() {
        this.router.post("/area/levelup", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (res.locals.currentArea.getOwnerID() === tGuildId) {
                if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[res.locals.id].character.id].rank === 3) {
                    if (!AreaTournament.haveStartedByIdArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                        if (!res.locals.currentArea.isMaxLevel()) {
                            let toLevelUpArea = res.locals.currentArea.getPriceNextLevel();
                            if (Globals.connectedGuilds[tGuildId].haveThisMoney(toLevelUpArea)) {
                                res.locals.currentArea.levelUp();
                                Globals.connectedGuilds[tGuildId].removeMoneyDirect(toLevelUpArea);
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
            return res.json(data);
        });

        this.router.post("/area/bonus/up", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (res.locals.currentArea.getOwnerID() === tGuildId) {
                if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[res.locals.id].character.id].rank === 3) {
                    if (!AreaTournament.haveStartedByIdArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                        if (res.locals.currentArea.isBonusAvailable(req.body.bonus_identifier)) {
                            req.body.number = req.body.number != null ? Number.parseInt(req.body.number) : 1000;
                            req.body.number = req.body.number > 0 ? req.body.number : 1000;
                            if (res.locals.currentArea.haveThisAmountOfStatPoints(req.body.number)) {
                                res.locals.currentArea.upStat(req.body.bonus_identifier, req.body.number);
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
            return res.json(data);
        });


        this.router.get("/area/bonuses", async (req, res) => {
            let data = {};
            data = res.locals.currentArea.getListOfBonuses(res.locals.lang);
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/area", async (req, res) => {
            let data = {};
            data = res.locals.currentArea.getConquest(res.locals.lang);
            data.lang = res.locals.lang;
            return res.json(data);
        });




    }
}

module.exports = ConquestModule;