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


class GroupModule extends GModule {
    constructor() {
        super();
        this.commands = ["grpmute", "grpunmute", "grpkick", "grpleave", "grpinvite", "grpaccept", "grpdecline", "grp", "grpfight", "grpswap"];
        this.startLoading("Group");
        this.init();
        this.endLoading("Group");
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

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_groups", 1);

        switch (command) {
            case "grpmute":
                Globals.connectedUsers[authorIdentifier].muteGroup(true);
                msg = Translator.getString(lang, "group", "now_muted")
                break;

            case "grpunmute":
                Globals.connectedUsers[authorIdentifier].muteGroup(false);
                msg = Translator.getString(lang, "group", "now_unmuted");
                break;

            case "grpkick":
                if (args[0]) {
                    if (group != null) {
                        if (!group.doingSomething) {
                            if (group.leader == Globals.connectedUsers[authorIdentifier]) {
                                let grptokick = args[0];
                                if (grptokick != Globals.connectedUsers[authorIdentifier].username) {
                                    if (group.kick(grptokick, message.client)) {
                                        msg = Translator.getString(lang, "group", "user_kicked", [grptokick]);
                                    } else {
                                        if (group.cancelInvite(grptokick)) {
                                            msg = Translator.getString(lang, "group", "invite_cancel", [grptokick]);
                                        } else {
                                            msg = Translator.getString(lang, "errors", "group_user_not_in_your_group", [grptokick]);
                                        }
                                    }
                                } else {
                                    msg = Translator.getString(lang, "errors", "group_cant_kick_yourself");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "group_not_leader");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "group_occupied");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "group_not_in_group");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "group_user_kick_empty_name");
                }
                break;
            case "grpswap":
                if (args[0]) {
                    if (group != null) {
                        if (!group.doingSomething) {
                            if (group.leader == Globals.connectedUsers[authorIdentifier]) {
                                let grptoswap = args[0];
                                if (grptoswap != Globals.connectedUsers[authorIdentifier].getUsername()) {
                                    if (group.swap(grptoswap, message.client)) {
                                        msg = Translator.getString(lang, "group", "user_swaped", [grptoswap]);
                                    } else {
                                        msg = Translator.getString(lang, "errors", "group_user_not_in_your_group", [grptoswap]);
                                    }
                                } else {
                                    msg = Translator.getString(lang, "errors", "group_cant_swap_yourself");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "group_not_leader");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "group_occupied");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "group_not_in_group");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "group_user_swap_empty_name");
                }
                break;
            case "grpleave":
                if (group != null) {
                    if (!group.doingSomething) {
                        group.playerLeave(Globals.connectedUsers[authorIdentifier], message.client);
                        msg = Translator.getString(lang, "group", "you_left");
                    } else {
                        msg = Translator.getString(lang, "errors", "group_occupied");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "group_not_in_group");
                }
                break;

            case "grpinvite":
                firstMention = mentions.first();
                // Si pas dans un groupe le créer
                if (group == null) {
                    Globals.connectedUsers[authorIdentifier].character.group = new Group(Globals.connectedUsers[authorIdentifier]);
                }
                group = Globals.connectedUsers[authorIdentifier].character.group;

                if (group.leader === Globals.connectedUsers[authorIdentifier]) {
                    if (!group.doingSomething) {
                        if (group.nbOfInvitedPlayers() < 5) {
                            if (firstMention) {
                                if (firstMention.id != authorIdentifier) {
                                    if (Globals.connectedUsers[firstMention.id]) {
                                        if (Globals.connectedUsers[firstMention.id].character.group === null) {
                                            if (Globals.connectedUsers[firstMention.id].character.pendingPartyInvite == null) {
                                                group.invite(Globals.connectedUsers[firstMention.id]);
                                                firstMention.send(Translator.getString(Globals.connectedUsers[firstMention.id].getLang(), "group", "someone_invited_you", [Globals.connectedUsers[authorIdentifier].username, "::grpaccept", "::grpdecline"])).catch((e) => null);
                                                msg = Translator.getString(lang, "group", "invitation_sent");
                                            } else {
                                                msg = Translator.getString(lang, "errors", "group_invite_waiting");
                                            }
                                        } else {
                                            msg = Translator.getString(lang, "errors", "group_invite_already_in_group");
                                        }
                                    } else {
                                        msg = Translator.getString(lang, "errors", "group_user_not_connected");
                                    }
                                } else {
                                    msg = Translator.getString(lang, "errors", "group_cant_invite_yourself");
                                }
                            } else {
                                // error
                                msg = "Use the command like this \"::grpinvite @someone\"";
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "group_cant_invite_more_than", [5]);
                        }

                    } else {
                        msg = Translator.getString(lang, "errors", "group_occupied");
                    }

                } else {
                    msg = Translator.getString(lang, "errors", "group_not_leader");
                }
                break;

            case "grpaccept":
                if (group == null) {
                    if (pending != null) {
                        if (!pending.doingSomething) {
                            if (!pending.isFull()) {
                                pending.addPlayer(Globals.connectedUsers[authorIdentifier], message.client);
                                msg = Translator.getString(lang, "group", "you_joined");
                            } else {
                                msg = Translator.getString(lang, "errors", "group_full_join");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "group_occupied");
                        }

                    } else {
                        msg = Translator.getString(lang, "errors", "group_you_dont_receive_invitation");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "group_already_in_group");
                }
                break;

            case "grpdecline":
                if (group == null) {
                    if (pending != null) {
                        pending.playerDeclinedBroadcast(Globals.connectedUsers[authorIdentifier], message.client);
                        Globals.connectedUsers[authorIdentifier].character.pendingPartyInvite = null;
                        msg = Translator.getString(lang, "group", "you_declined");
                    } else {
                        msg = Translator.getString(lang, "errors", "group_you_dont_receive_invitation");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "group_already_in_group");
                }
                break;

            case "grp":
                if (group != null) {
                    msg = group.toStr(lang);
                } else {
                    msg = Translator.getString(lang, "errors", "group_not_in_group");
                }
                break;

            case "grpfight":
                PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_fights", 1);
                let idEnemyGroup = parseInt(args[0], 10);
                if (group != null) {
                    if (group.leader === Globals.connectedUsers[authorIdentifier]) {
                        if (!group.doingSomething) {
                            if (group.allInSameArea()) {
                                if (Globals.areasManager.canIFightInThisArea(Globals.connectedUsers[authorIdentifier].character.getIdArea())) {
                                    if (idEnemyGroup != undefined && Number.isInteger(idEnemyGroup)) {
                                        let grpEnemies = [];
                                        grpEnemies = Globals.areasManager.getMonsterIdIn(Globals.connectedUsers[authorIdentifier].character.getIdArea(), idEnemyGroup);
                                        if (grpEnemies == null) {
                                            grpEnemies = Globals.areasManager.selectRandomMonsterIn(Globals.connectedUsers[authorIdentifier].character.getIdArea(), idEnemyGroup);
                                        }
                                        Globals.fightManager.fightPvE(group.getArrayOfCharacters(), grpEnemies, message, true, lang);
                                        //Globals.fightManager.fightPvE(Globals.connectedUsers[authorIdentifier], message, idEnemy, canIFightTheMonster);
                                    } else {
                                        // Error Message
                                        msg = Translator.getString(lang, "errors", "fight_enter_id_monster");
                                    }
                                } else {
                                    msg = Translator.getString(lang, "errors", "fight_impossible_in_town");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "group_not_same_area");
                            }

                        } else {
                            msg = Translator.getString(lang, "errors", "group_occupied");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "group_not_leader");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "group_not_in_group");
                }
                break;
        }

        this.sendMessage(message, msg);
    }
}

module.exports = GroupModule;