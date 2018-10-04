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


class GuildModule extends GModule {
    constructor() {
        super();
        this.commands = ["guild", "gcreate", "gdisband", "gapply", "gaccept", "gapplies", "gapplyremove", "gappliesremove", "guilds", "gremove", "gmod", "gannounce", "gaddmoney", "gremovemoney", "glevelup", "genroll", "gunenroll", "gleave", "gquit"];
        this.startLoading("Guild");
        this.init();
        this.endLoading("Guild");
    }

    async run(message, command, args) {
        let msg = "";
        let authorIdentifier = message.author.id;
        let mentions = message.mentions.users;
        let group = Globals.connectedUsers[authorIdentifier].character.group;
        let lang = Globals.connectedUsers[authorIdentifier].getLang();
        let pending = Globals.connectedUsers[authorIdentifier].character.pendingPartyInvite;
        let marketplace = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "marketplace");
        let craftingbuilding = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "craftingbuilding");
        let currentArea = Globals.connectedUsers[authorIdentifier].character.getArea();
        let tLootSystem = new LootSystem();
        let uIDGuild;
        let tGuildId = 0;
        let firstMention;
        let err = [];
        let apPage;
        let nb;
        let temp;
        let doIHaveThisItem = false;

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_guilds", 1);

        switch (command) {
            case "guild":
                if (Globals.connectedUsers[authorIdentifier].character.isInGuild()) {
                    msg = Globals.connectedGuilds[Globals.connectedUsers[authorIdentifier].character.idGuild].toStr(lang);
                } else {
                    msg = Translator.getString(lang, "guild", "you_dont_have_a_guild");
                }
                break;

            case "gcreate":
                if (args[0]) {
                    // Si le joueur n'a pas de guilde
                    if (Globals.connectedUsers[authorIdentifier].character.idGuild == 0) {
                        if (Globals.connectedUsers[authorIdentifier].character.doIHaveEnoughMoney(Globals.guilds.basePriceLevel)) {
                            let tGuild = new Guild();
                            let err = tGuild.createGuild(args[0], Globals.connectedUsers[authorIdentifier].character.id, lang);
                            if (err.length == 0) {
                                Globals.connectedGuilds[tGuild.id] = tGuild;
                                Globals.connectedUsers[authorIdentifier].character.idGuild = tGuild.id;
                                // Static delete
                                Guild.deleteUsersAppliances(Globals.connectedUsers[authorIdentifier].character.id);

                                Globals.connectedUsers[authorIdentifier].character.removeMoney(Globals.guilds.basePriceLevel);

                                msg = Translator.getString(lang, "guild", "guild_x_created", [tGuild.name]);
                            } else {
                                msg = err[0];
                            }
                        } else {
                            msg = Translator.getString(lang, "guild", "dont_have_enough_to_create", [Globals.guilds.basePriceLevel]);
                        }

                    } else {
                        msg = Translator.getString(lang, "errors", "already_in_guild");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "guild_name_empty");
                }
                break;

            case "gdisband":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[authorIdentifier].character.id].rank === 3) {
                    if (Globals.connectedGuilds[tGuildId].isRegisterToAnTournament()) {
                        if (Globals.connectedGuilds[tGuildId].isTournamentStarted() == 1) {
                            msg = Translator.getString(lang, "errors", "guild_tournament_started");
                        } else {
                            Globals.areasManager.unclaimAll(tGuildId);
                            Globals.connectedGuilds[tGuildId].disband(Globals.connectedUsers);
                            delete Globals.connectedGuilds[tGuildId];
                            msg = Translator.getString(lang, "guild", "guild_disband");
                        }

                    } else {
                        Globals.areasManager.unclaimAll(tGuildId);
                        Globals.connectedGuilds[tGuildId].disband(Globals.connectedUsers);
                        delete Globals.connectedGuilds[tGuildId];
                        msg = Translator.getString(lang, "guild", "guild_disband");
                    }

                } else {
                    msg = Translator.getString(lang, "errors", "guild_have_to_be_gm_to_disband");
                }
                break;


            case "gapply":
                args[0] = parseInt(args[0], 10);
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (Number.isInteger(args[0])) {
                    if (tGuildId == 0) {
                        err = Guild.applyTo(args[0], Globals.connectedUsers[authorIdentifier].character.id, lang);
                        if (err.length > 0) {
                            msg = err[0];
                        } else {
                            msg = Translator.getString(lang, "guild", "guild_applied");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_dont_be_in_guild_to_join_a_guild");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "guild_enter_id_to_join");
                }
                break;

            case "gaccept":
                args[0] = parseInt(args[0], 10);
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;

                if (Number.isInteger(args[0])) {
                    if (tGuildId > 0) {
                        if (Guild.haveAlreadyApplied(tGuildId, args[0])) {
                            err = Globals.connectedGuilds[tGuildId].addMember(Globals.connectedUsers[authorIdentifier].character.id, args[0], 1, lang);
                            if (err.length > 0) {
                                msg = err[0];
                            } else {
                                msg = Translator.getString(lang, "guild", "character_have_been_accepted");
                                uIDGuild = Globals.connectedGuilds[tGuildId].getIdUserByIdCharacter(args[0]);
                                Guild.deleteUsersAppliances(args[0]);
                                if (Globals.connectedUsers[uIDGuild]) {
                                    Globals.connectedUsers[uIDGuild].character.idGuild = tGuildId;
                                }
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_character_not_ask_to_join");
                        }
                    } else {
                        err.push(Translator.getString(lang, "errors", "you_have_to_be_in_a_guild"));
                    }

                } else {
                    msg = Translator.getString(lang, "errors", "guild_enter_id_to_add");
                }
                break;

            case "gapplies":
                apPage = parseInt(args[0], 10);
                if (!apPage || !Number.isInteger(apPage)) {
                    apPage = 1;
                }
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (tGuildId > 0) {
                    msg = Globals.connectedGuilds[tGuildId].getGuildAppliances(apPage, lang);
                } else {
                    msg = Guild.getAppliances(Globals.connectedUsers[authorIdentifier].character.id, lang);
                }
                break;

            case "gapplyremove":
                args[0] = parseInt(args[0], 10);
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;

                if (tGuildId > 0) {
                    if (Number.isInteger(args[0])) {
                        if (Globals.connectedGuilds[tGuildId].canCancelApplies(Globals.connectedUsers[authorIdentifier].character.id)) {
                            Guild.deleteUserForThisGuildAppliance(args[0], tGuildId);
                            msg = Translator.getString(lang, "guild", "you_have_denied_this_apply");
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_cant_remove_appliances");
                        }


                    } else {
                        msg = Translator.getString(lang, "errors", "guild_have_to_enter_id_to_remove_apply");
                    }

                } else {
                    if (Number.isInteger(args[0])) {
                        Guild.deleteUserForThisGuildAppliance(Globals.connectedUsers[authorIdentifier].character.id, args[0]);
                        msg = Translator.getString(lang, "guild", "you_have_cancel_your_apply");
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_have_to_enter_id_to_remove_apply_playerside");
                    }
                }
                break;

            case "gappliesremove":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;

                if (tGuildId > 0) {
                    if (Globals.connectedGuilds[tGuildId].canCancelApplies(Globals.connectedUsers[authorIdentifier].character.id)) {
                        Globals.connectedGuilds[tGuildId].deleteGuildAppliances();
                        msg = Translator.getString(lang, "guild", "you_have_denied_all_applies");
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_cant_remove_appliances");
                    }
                } else {
                    Guild.deleteUsersAppliances(Globals.connectedUsers[authorIdentifier].character.id);
                    msg = Translator.getString(lang, "guild", "you_have_cancel_all_your_applies");
                }
                break;

            case "guilds":
                apPage = parseInt(args[0], 10);
                if (!apPage || !Number.isInteger(apPage)) {
                    apPage = 1;
                }
                msg = Guild.getGuilds(apPage);
                break;

            case "gremove":
                args[0] = parseInt(args[0], 10);
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (tGuildId > 0) {
                    uIDGuild = Globals.connectedGuilds[tGuildId].getIdUserByIdCharacter(args[0]);
                    err = Globals.connectedGuilds[tGuildId].removeMember(Globals.connectedUsers[authorIdentifier].character.id, args[0], lang);
                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        if (args[0] == Globals.connectedUsers[authorIdentifier].character.id) {
                            msg = Translator.getString(lang, "guild", "you_leaved_guild");
                        } else {
                            msg = Translator.getString(lang, "guild", "member_kicked");
                        }
                        if (Globals.connectedUsers[uIDGuild]) {
                            Globals.connectedUsers[uIDGuild].character.idGuild = 0;
                        }
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "guild_not_in_guild");
                }
                break;

            case "gleave":
            case "gquit":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (tGuildId > 0) {
                    uIDGuild = authorIdentifier;
                    let mychaid = Globals.connectedUsers[authorIdentifier].character.id;
                    err = Globals.connectedGuilds[tGuildId].removeMember(mychaid, mychaid, lang);
                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = Translator.getString(lang, "guild", "you_leaved_guild");
                        Globals.connectedUsers[authorIdentifier].character.idGuild = 0;
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "guild_not_in_guild");
                }
                break;

            case "gmod":
                // idMembre,rank
                args[0] = parseInt(args[0], 10);
                args[1] = parseInt(args[1], 10);
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;

                if (tGuildId > 0) {
                    uIDGuild = Globals.connectedGuilds[tGuildId].getIdUserByIdCharacter(args[0]);
                    err = Globals.connectedGuilds[tGuildId].updateMember(Globals.connectedUsers[authorIdentifier].character.id, args[0], args[1], lang);
                } else {
                    err.push(Translator.getString(lang, "errors", "you_have_to_be_in_a_guild"));
                }

                if (err.length > 0) {
                    msg = err[0];
                } else {
                    msg = Translator.getString(lang, "guild", "rank_modified");
                }
                break;


            case "gannounce":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (tGuildId > 0) {
                    err = Globals.connectedGuilds[tGuildId].setMessage(Globals.connectedUsers[authorIdentifier].character.id, args[0], lang);
                } else {
                    err.push(Translator.getString(lang, "errors", "you_have_to_be_in_a_guild"));
                }

                if (err.length > 0) {
                    msg = err[0];
                } else {
                    msg = Translator.getString(lang, "guild", "you_have_updated_guild_announcement");
                }
                break;

            case "gaddmoney":
                args[0] = parseInt(args[0], 10);
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (args[0] || Number.isInteger(args[0])) {
                    if (tGuildId > 0) {
                        if (Globals.connectedUsers[authorIdentifier].character.doIHaveEnoughMoney(args[0])) {
                            if (!Globals.connectedGuilds[tGuildId].addMoney(args[0])) {
                                err.push(Translator.getString(lang, "errors", "guild_cant_give_this_money"));
                            } else {
                                //Si tout est ok
                                Globals.connectedUsers[authorIdentifier].character.removeMoney(args[0]);
                            }
                        } else {
                            err.push(Translator.getString(lang, "errors", "guild_you_dont_have_enough_money"));
                        }
                    } else {
                        err.push(Translator.getString(lang, "errors", "you_have_to_be_in_a_guild"));
                    }
                } else {
                    err.push(Translator.getString(lang, "errors", "guild_you_have_to_select_amount_money"));
                }

                if (err.length > 0) {
                    msg = err[0];
                } else {
                    msg = Translator.getString(lang, "guild", "you_gift_x_g_to_guild", [args[0]]);
                }
                break;

            case "gremovemoney":
                args[0] = parseInt(args[0], 10);
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (args[0] || Number.isInteger(args[0])) {
                    if (tGuildId > 0) {
                        err = Globals.connectedGuilds[tGuildId].removeMoney(args[0], Globals.connectedUsers[authorIdentifier].character.id, lang);
                    } else {
                        err.push(Translator.getString(lang, "errors", "you_have_to_be_in_a_guild"));
                    }
                } else {
                    err.push(Translator.getString(lang, "errors", "guild_you_have_to_select_amount_to_retrive"));
                }

                if (err.length > 0) {
                    msg = err[0];
                } else {
                    msg = Translator.getString(lang, "guild", "you_retrive_x_g_from_guild", [args[0]]);
                    Globals.connectedUsers[authorIdentifier].character.addMoney(args[0]);
                }
                break;


            case "glevelup":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (tGuildId > 0) {
                    err = Globals.connectedGuilds[tGuildId].levelUp(Globals.connectedUsers[authorIdentifier].character.id, lang);
                } else {
                    err.push(Translator.getString(lang, "errors", "you_have_to_be_in_a_guild"));
                }

                if (err.length > 0) {
                    msg = err[0];
                } else {
                    msg = Translator.getString(lang, "guild", "guild_level_up", [Globals.connectedGuilds[tGuildId].level]);
                }
                break;

            case "genroll":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[authorIdentifier].character.id].rank === 3) {
                    if (!Globals.connectedGuilds[tGuildId].isRegisterToAnTournament()) {
                        if (!AreaTournament.haveStartedByIdArea(Globals.connectedUsers[authorIdentifier].character.getIdArea())) {
                            Globals.connectedGuilds[tGuildId].enroll(Globals.connectedUsers[authorIdentifier].character.getIdArea());
                            msg = Translator.getString(lang, "guild", "enroll");
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_tournament_started_generic");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_already_enroll_in_tournament");
                    }

                } else {
                    msg = Translator.getString(lang, "errors", "guild_have_to_be_gm_to_enroll");
                }
                break;

            case "gunenroll":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[authorIdentifier].character.id].rank === 3) {
                    if (Globals.connectedGuilds[tGuildId].isRegisterToAnTournament()) {
                        if (!AreaTournament.haveStartedByIdArea(Globals.connectedGuilds[tGuildId].getTournamentAreaEnrolled())) {
                            Globals.connectedGuilds[tGuildId].unenroll();
                            msg = Translator.getString(lang, "guild", "unenroll");
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_tournament_started_generic");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_not_enrolled_in_tournament");
                    }

                } else {
                    msg = Translator.getString(lang, "errors", "guild_have_to_be_gm_to_enroll");
                }
                break;

        }

        this.sendMessage(message, msg);
    }
}

module.exports = GuildModule;