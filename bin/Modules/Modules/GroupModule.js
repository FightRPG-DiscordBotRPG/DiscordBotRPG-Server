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


class GroupModule extends GModule {
    constructor() {
        super();
        this.commands = ["grpmute", "grpunmute", "grpkick", "grpleave", "grpinvite", "grpaccept", "grpdecline", "grp", "grpfight", "grpswap"];
        this.startLoading("Group");
        this.init();
        this.endLoading("Group");
    }
    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_groups", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.freeLockedMembers();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.post("/notifications/mute", async (req, res, next) => {
            let data = {}

            await Globals.connectedUsers[res.locals.id].muteGroup(true);
            data.success = Translator.getString(res.locals.lang, "group", "now_muted");

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/notifications/unmute", async (req, res, next) => {
            let data = {}

            await Globals.connectedUsers[res.locals.id].muteGroup(false);
            data.success = Translator.getString(res.locals.lang, "group", "now_unmuted");

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/kick", async (req, res, next) => {
            let data = {}
            let group = res.locals.group;
            if (req.body.username) {
                if (group != null) {
                    if (!group.doingSomething) {
                        if (group.leader == Globals.connectedUsers[res.locals.id]) {
                            let grptokick = req.body.username;
                            if (grptokick != Globals.connectedUsers[res.locals.id].getUsername()) {
                                if (group.kick(grptokick, null)) {
                                    data.success = Translator.getString(res.locals.lang, "group", "user_kicked", [grptokick]);
                                } else {
                                    if (group.cancelInvite(grptokick)) {
                                        data.success = Translator.getString(res.locals.lang, "group", "invite_cancel", [grptokick]);
                                    } else {
                                        data.error = Translator.getString(res.locals.lang, "errors", "group_user_not_in_your_group", [grptokick]);
                                    }
                                }
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "group_cant_kick_yourself");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "group_not_leader");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "group_occupied");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "group_not_in_group");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "group_user_kick_empty_name");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/swap", async (req, res, next) => {
            let data = {}
            let group = res.locals.group;
            if (req.body.username) {
                if (group != null) {
                    if (!group.doingSomething) {
                        if (group.leader == Globals.connectedUsers[res.locals.id]) {
                            let grptoswap = req.body.username;
                            if (grptoswap != Globals.connectedUsers[res.locals.id].getUsername()) {
                                if (group.swap(grptoswap, null)) {
                                    data.success = Translator.getString(res.locals.lang, "group", "user_swaped", [grptoswap]);
                                } else {
                                    data.error = Translator.getString(res.locals.lang, "errors", "group_user_not_in_your_group", [grptoswap]);
                                }
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "group_cant_swap_yourself");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "group_not_leader");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "group_occupied");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "group_not_in_group");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "group_user_swap_empty_name");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/leave", async (req, res, next) => {
            let data = {}
            let group = res.locals.group;
            if (group != null) {
                if (!group.doingSomething) {
                    group.playerLeave(Globals.connectedUsers[res.locals.id], null);
                    data.success = Translator.getString(res.locals.lang, "group", "you_left");
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "group_occupied");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "group_not_in_group");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/invite", async (req, res, next) => {
            let data = {}
            let group = res.locals.group;


            // Si pas dans un groupe le créer
            if (group == null) {
                Globals.connectedUsers[res.locals.id].character.group = new Group(Globals.connectedUsers[res.locals.id]);
            }
            group = Globals.connectedUsers[res.locals.id].character.group;

            if (group.leader === Globals.connectedUsers[res.locals.id]) {
                if (!group.doingSomething) {
                    if (group.nbOfInvitedPlayers() < 5) {
                        if (req.body.mention) {
                            if (req.body.mention != res.locals.id) {
                                if (Globals.connectedUsers[req.body.mention]) {
                                    if (Globals.connectedUsers[req.body.mention].character.group === null) {
                                        if (Globals.connectedUsers[req.body.mention].character.pendingPartyInvite == null) {
                                            group.invite(Globals.connectedUsers[req.body.mention]);
                                            Globals.connectedUsers[req.body.mention].groupTell(Translator.getString(Globals.connectedUsers[req.body.mention].getLang(), "group", "someone_invited_you", [Globals.connectedUsers[res.locals.id].username, "::grpaccept", "::grpdecline"]));
                                            data.success = Translator.getString(res.locals.lang, "group", "invitation_sent");
                                        } else {
                                            data.error = Translator.getString(res.locals.lang, "errors", "group_invite_waiting");
                                        }
                                    } else {
                                        data.error = Translator.getString(res.locals.lang, "errors", "group_invite_already_in_group");
                                    }
                                } else {
                                    data.error = Translator.getString(res.locals.lang, "errors", "group_user_not_connected");
                                }
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "group_cant_invite_yourself");
                            }
                        } else {
                            // error
                            data.error = "Use the command like this \"::grpinvite @someone\"";
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "group_cant_invite_more_than", [5]);
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "group_occupied");
                }

            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "group_not_leader");
            }


            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/accept", async (req, res, next) => {
            let data = {}
            let group = res.locals.group;
            let pending = res.locals.pending;


            if (group == null) {
                if (pending != null) {
                    if (!pending.doingSomething) {
                        if (!pending.isFull()) {
                            pending.addPlayer(Globals.connectedUsers[res.locals.id], null);
                            data.success = Translator.getString(res.locals.lang, "group", "you_joined");
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "group_full_join");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "group_occupied");
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "group_you_dont_receive_invitation");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "group_already_in_group");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });


        this.router.post("/decline", async (req, res, next) => {
            let data = {}
            let group = res.locals.group;
            let pending = res.locals.pending;


            if (group == null) {
                if (pending != null) {
                    pending.playerDeclinedBroadcast(Globals.connectedUsers[res.locals.id], null);
                    Globals.connectedUsers[res.locals.id].character.pendingPartyInvite = null;
                    data.success = Translator.getString(res.locals.lang, "group", "you_declined");
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "group_you_dont_receive_invitation");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "group_already_in_group");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/show", async (req, res, next) => {
            let data = {}
            let group = res.locals.group;
            let pending = res.locals.pending;

            if (group != null) {
                data = await group.toApi();
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "group_not_in_group");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/fight/monster", async (req, res, next) => {
            let data = {}
            let group = res.locals.group;
            let pending = res.locals.pending;

            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_fights", 1);
            let idEnemyGroup = parseInt(req.body.idMonster, 10);
            if (group != null) {
                if (group.leader === Globals.connectedUsers[res.locals.id]) {
                    if (!group.doingSomething) {
                        if (group.allInSameArea()) {
                            if (Globals.areasManager.canIFightInThisArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                                if (idEnemyGroup != undefined && Number.isInteger(idEnemyGroup)) {
                                    if (res.locals.currentArea.getMonsterId(idEnemyGroup) != null) {
                                        let grpEnemies = [];
                                        grpEnemies = Globals.areasManager.getMonsterIdIn(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemyGroup);
                                        if (grpEnemies == null) {
                                            grpEnemies = Globals.areasManager.selectRandomMonsterIn(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemyGroup);
                                        }
                                        let response = await Globals.fightManager.fightPvE(group.getArrayOfCharacters(), grpEnemies, res.locals.id, true, res.locals.lang);
                                        if (response.error != null) {
                                            data.error = response.error;
                                        } else {
                                            data = response;
                                        }
                                        //Globals.fightManager.fightPvE(Globals.connectedUsers[res.locals.id], message, idEnemy, canIFightTheMonster);
                                    } else {
                                        data.error = Translator.getString(res.locals.lang, "errors", "fight_monter_dont_exist");
                                    }
                                } else {
                                    // Error Message
                                    data.error = Translator.getString(res.locals.lang, "errors", "fight_enter_id_monster");
                                }
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "fight_impossible_in_town");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "group_not_same_area");
                        }

                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "group_occupied");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "group_not_leader");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "group_not_in_group");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });
    }
}

module.exports = GroupModule;