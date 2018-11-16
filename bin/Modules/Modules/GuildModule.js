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


class GuildModule extends GModule {
    constructor() {
        super();
        this.commands = ["guild", "gcreate", "gdisband", "gapply", "gaccept", "gapplies", "gapplyremove", "gappliesremove", "guilds", "gremove", "gmod", "gannounce", "gaddmoney", "gremovemoney", "glevelup", "genroll", "gunenroll", "gleave", "gquit"];
        this.startLoading("Guild");
        this.init();
        this.endLoading("Guild");
    }
    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_guilds", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {

        this.router.get("/show", async (req, res) => {
            let data = {};
            if (Globals.connectedUsers[res.locals.id].character.isInGuild()) {
                data = Globals.connectedGuilds[Globals.connectedUsers[res.locals.id].character.idGuild].toApi(res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "guild", "you_dont_have_a_guild");
            }

            data.lang = res.locals.lang;
            return res.json(data);

        });

        this.router.post("/create", async (req, res) => {
            let data = {};
            if (req.body.guildName) {
                // Si le joueur n'a pas de guilde
                if (Globals.connectedUsers[res.locals.id].character.idGuild == 0) {
                    if (Globals.connectedUsers[res.locals.id].character.doIHaveEnoughMoney(Globals.guilds.basePriceLevel)) {
                        let tGuild = new Guild();
                        let err = tGuild.createGuild(req.body.guildName, Globals.connectedUsers[res.locals.id].character.id, res.locals.lang);
                        if (err.length == 0) {
                            Globals.connectedGuilds[tGuild.id] = tGuild;
                            Globals.connectedUsers[res.locals.id].character.idGuild = tGuild.id;
                            // Static delete
                            Guild.deleteUsersAppliances(Globals.connectedUsers[res.locals.id].character.id);

                            Globals.connectedUsers[res.locals.id].character.removeMoney(Globals.guilds.basePriceLevel);

                            data.success = Translator.getString(res.locals.lang, "guild", "guild_x_created", [tGuild.name]);
                        } else {
                            data.error = err[0];
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "guild", "dont_have_enough_to_create", [Globals.guilds.basePriceLevel]);
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "already_in_guild");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_name_empty");
            }

            data.lang = res.locals.lang;
            return res.json(data);

        });

        this.router.post("/disband", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[res.locals.id].character.id].rank === 3) {
                if (Globals.connectedGuilds[tGuildId].isRegisterToAnTournament()) {
                    if (Globals.connectedGuilds[tGuildId].isTournamentStarted() == 1) {
                        data.error = Translator.getString(res.locals.lang, "errors", "guild_tournament_started");
                    } else {
                        Globals.areasManager.unclaimAll(tGuildId);
                        Globals.connectedGuilds[tGuildId].disband(Globals.connectedUsers);
                        delete Globals.connectedGuilds[tGuildId];
                        data.success = Translator.getString(res.locals.lang, "guild", "guild_disband");
                    }

                } else {
                    Globals.areasManager.unclaimAll(tGuildId);
                    Globals.connectedGuilds[tGuildId].disband(Globals.connectedUsers);
                    delete Globals.connectedGuilds[tGuildId];
                    data.success = Translator.getString(res.locals.lang, "guild", "guild_disband");
                }

            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_have_to_be_gm_to_disband");
            }
            data.lang = res.locals.lang;
            return res.json(data);

        });

        this.router.post("/apply", async (req, res) => {
            let data = {};
            req.body.idGuild = parseInt(req.body.idGuild, 10);
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (Number.isInteger(req.body.idGuild)) {
                if (tGuildId == 0) {
                    let err = Guild.applyTo(req.body.idGuild, Globals.connectedUsers[res.locals.id].character.id, res.locals.lang);
                    if (err.length > 0) {
                        data.error = err[0];
                    } else {
                        data.success = Translator.getString(res.locals.lang, "guild", "guild_applied");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "guild_dont_be_in_guild_to_join_a_guild");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_enter_id_to_join");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/accept", async (req, res) => {
            let data = {};
            req.body.idCharacter = parseInt(req.body.idCharacter, 10);
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;

            if (Number.isInteger(req.body.idCharacter)) {
                if (tGuildId > 0) {
                    if (Guild.haveAlreadyApplied(tGuildId, req.body.idCharacter)) {
                        let err = Globals.connectedGuilds[tGuildId].addMember(Globals.connectedUsers[res.locals.id].character.id, req.body.idCharacter, 1, res.locals.lang);
                        if (err.length > 0) {
                            data.error = err[0];
                        } else {
                            data.success = Translator.getString(res.locals.lang, "guild", "character_have_been_accepted");
                            let uIDGuild = Globals.connectedGuilds[tGuildId].getIdUserByIdCharacter(req.body.idCharacter);
                            Guild.deleteUsersAppliances(req.body.idCharacter);
                            if (Globals.connectedUsers[uIDGuild]) {
                                Globals.connectedUsers[uIDGuild].character.idGuild = tGuildId;
                            }
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "guild_character_not_ask_to_join");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "you_have_to_be_in_a_guild");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_enter_id_to_add");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/applies/:page?", async (req, res) => {
            let data = {};
            let apPage = parseInt(req.params.page, 10);
            if (!apPage || !Number.isInteger(apPage)) {
                apPage = 1;
            }
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (tGuildId > 0) {
                data = Globals.connectedGuilds[tGuildId].apiGetGuildAppliances(apPage, res.locals.lang);
            } else {
                data = Guild.getAppliances(Globals.connectedUsers[res.locals.id].character.id, res.locals.lang);
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/apply/cancel", async (req, res) => {
            let data = {};
            req.body.id = parseInt(req.body.id, 10);
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;

            if (tGuildId > 0) {
                if (Number.isInteger(req.body.id)) {
                    if (Globals.connectedGuilds[tGuildId].canCancelApplies(Globals.connectedUsers[res.locals.id].character.id)) {
                        Guild.deleteUserForThisGuildAppliance(req.body.id, tGuildId);
                        data.success = Translator.getString(res.locals.lang, "guild", "you_have_denied_this_apply");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "guild_cant_remove_appliances");
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "guild_have_to_enter_id_to_remove_apply");
                }

            } else {
                if (Number.isInteger(req.body.id)) {
                    Guild.deleteUserForThisGuildAppliance(Globals.connectedUsers[res.locals.id].character.id, req.body.id);
                    data.success = Translator.getString(res.locals.lang, "guild", "you_have_cancel_your_apply");
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "guild_have_to_enter_id_to_remove_apply_playerside");
                }
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/applies/cancel", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (tGuildId > 0) {
                if (Globals.connectedGuilds[tGuildId].canCancelApplies(Globals.connectedUsers[res.locals.id].character.id)) {
                    Globals.connectedGuilds[tGuildId].deleteGuildAppliances();
                    data.success = Translator.getString(res.locals.lang, "guild", "you_have_denied_all_applies");
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "guild_cant_remove_appliances");
                }
            } else {
                Guild.deleteUsersAppliances(Globals.connectedUsers[res.locals.id].character.id);
                data.success = Translator.getString(res.locals.lang, "guild", "you_have_cancel_all_your_applies");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/list/:page?", async (req, res) => {
            let data = {};
            let apPage = parseInt(req.params.page, 10);
            if (!apPage || !Number.isInteger(apPage)) {
                apPage = 1;
            }
            data = Guild.getGuilds(apPage);
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/kick", async (req, res) => {
            let data = {};
            req.body.id = parseInt(req.body.id, 10);
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (tGuildId > 0) {
                let uIDGuild = Globals.connectedGuilds[tGuildId].getIdUserByIdCharacter(req.body.id);
                let err = Globals.connectedGuilds[tGuildId].removeMember(Globals.connectedUsers[res.locals.id].character.id, req.body.id, res.locals.lang);
                if (err.length > 0) {
                    data.error = err[0];
                } else {
                    if (req.body.id == Globals.connectedUsers[res.locals.id].character.id) {
                        data.success = Translator.getString(res.locals.lang, "guild", "you_leaved_guild");
                    } else {
                        data.success = Translator.getString(res.locals.lang, "guild", "member_kicked");
                    }
                    if (Globals.connectedUsers[uIDGuild]) {
                        Globals.connectedUsers[uIDGuild].character.idGuild = 0;
                    }
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_not_in_guild");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/leave", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (tGuildId > 0) {
                let mychaid = Globals.connectedUsers[res.locals.id].character.id;
                let err = Globals.connectedGuilds[tGuildId].removeMember(mychaid, mychaid, res.locals.lang);
                if (err.length > 0) {
                    data.error = err[0];
                } else {
                    data.success = Translator.getString(res.locals.lang, "guild", "you_leaved_guild");
                    Globals.connectedUsers[res.locals.id].character.idGuild = 0;
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_not_in_guild");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/mod", async (req, res) => {
            let data = {};
            req.body.id = parseInt(req.body.id, 10);
            req.body.rank = parseInt(req.body.rank, 10);
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            let err = [];
            if (tGuildId > 0) {
                err = Globals.connectedGuilds[tGuildId].updateMember(Globals.connectedUsers[res.locals.id].character.id, req.body.id, req.body.rank, res.locals.lang);
            } else {
                err.push(Translator.getString(res.locals.lang, "errors", "you_have_to_be_in_a_guild"));
            }

            if (err.length > 0) {
                data.error = err[0];
            } else {
                data.success = Translator.getString(res.locals.lang, "guild", "rank_modified");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/announce", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            let err = [];
            if (tGuildId > 0) {
                err = Globals.connectedGuilds[tGuildId].setMessage(Globals.connectedUsers[res.locals.id].character.id, req.body.message, res.locals.lang);
            } else {
                err.push(Translator.getString(res.locals.lang, "errors", "you_have_to_be_in_a_guild"));
            }

            if (err.length > 0) {
                data.error = err[0];
            } else {
                data.success = Translator.getString(res.locals.lang, "guild", "you_have_updated_guild_announcement");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/money/add", async (req, res) => {
            let data = {};
            req.body.money = parseInt(req.body.money, 10);
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            let err = [];
            if (req.body.money || Number.isInteger(req.body.money)) {
                if (tGuildId > 0) {
                    if (Globals.connectedUsers[res.locals.id].character.doIHaveEnoughMoney(req.body.money)) {
                        if (!Globals.connectedGuilds[tGuildId].addMoney(req.body.money)) {
                            err.push(Translator.getString(res.locals.lang, "errors", "guild_cant_give_this_money"));
                        } else {
                            //Si tout est ok
                            Globals.connectedUsers[res.locals.id].character.removeMoney(req.body.money);
                        }
                    } else {
                        err.push(Translator.getString(res.locals.lang, "errors", "guild_you_dont_have_enough_money"));
                    }
                } else {
                    err.push(Translator.getString(res.locals.lang, "errors", "you_have_to_be_in_a_guild"));
                }
            } else {
                err.push(Translator.getString(res.locals.lang, "errors", "guild_you_have_to_select_amount_money"));
            }

            if (err.length > 0) {
                data.error = err[0];
            } else {
                data.success = Translator.getString(res.locals.lang, "guild", "you_gift_x_g_to_guild", [req.body.money]);
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/money/remove", async (req, res) => {
            let data = {};
            req.body.money = parseInt(req.body.money, 10);
            let err = [];
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (req.body.money || Number.isInteger(req.body.money)) {
                if (tGuildId > 0) {
                    err = Globals.connectedGuilds[tGuildId].removeMoney(req.body.money, Globals.connectedUsers[res.locals.id].character.id, res.locals.lang);
                } else {
                    err.push(Translator.getString(res.locals.lang, "errors", "you_have_to_be_in_a_guild"));
                }
            } else {
                err.push(Translator.getString(res.locals.lang, "errors", "guild_you_have_to_select_amount_to_retrive"));
            }

            if (err.length > 0) {
                data.error = err[0];
            } else {
                data.success = Translator.getString(res.locals.lang, "guild", "you_retrive_x_g_from_guild", [req.body.money]);
                Globals.connectedUsers[res.locals.id].character.addMoney(req.body.money);
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/levelup", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            let err = [];
            if (tGuildId > 0) {
                err = Globals.connectedGuilds[tGuildId].levelUp(Globals.connectedUsers[res.locals.id].character.id, res.locals.lang);
            } else {
                err.push(Translator.getString(res.locals.lang, "errors", "you_have_to_be_in_a_guild"));
            }

            if (err.length > 0) {
                data.error = err[0];
            } else {
                data.success = Translator.getString(res.locals.lang, "guild", "guild_level_up", [Globals.connectedGuilds[tGuildId].level]);
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/enroll", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[res.locals.id].character.id].rank === 3) {
                if (!Globals.connectedGuilds[tGuildId].isRegisterToAnTournament()) {
                    if (!AreaTournament.haveStartedByIdArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                        Globals.connectedGuilds[tGuildId].enroll(Globals.connectedUsers[res.locals.id].character.getIdArea());
                        data.success = Translator.getString(res.locals.lang, "guild", "enroll");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "guild_tournament_started_generic");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "guild_already_enroll_in_tournament");
                }

            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_have_to_be_gm_to_enroll");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/unenroll", async (req, res) => {
            let data = {};
            let tGuildId = Globals.connectedUsers[res.locals.id].character.idGuild;
            if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[res.locals.id].character.id].rank === 3) {
                if (Globals.connectedGuilds[tGuildId].isRegisterToAnTournament()) {
                    if (!AreaTournament.haveStartedByIdArea(Globals.connectedGuilds[tGuildId].getTournamentAreaEnrolled())) {
                        Globals.connectedGuilds[tGuildId].unenroll();
                        data.success = Translator.getString(res.locals.lang, "guild", "unenroll");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "guild_tournament_started_generic");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "guild_not_enrolled_in_tournament");
                }

            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "guild_have_to_be_gm_to_enroll");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });




    }

}

module.exports = GuildModule;