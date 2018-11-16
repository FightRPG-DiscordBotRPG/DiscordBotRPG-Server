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
const Character = require("../../Character");
const express = require("express");


class FightModule extends GModule {
    constructor() {
        super();
        this.commands = ["fight", "arena"];
        this.startLoading("Fight");
        this.init();
        this.endLoading("Fight");
    }

    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_fights", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.post("/monster", async (req, res) => {
            let data = {}
            let idEnemy = parseInt(req.body.idMonster, 10);
            if (Globals.areasManager.canIFightInThisArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                if (idEnemy != null && Number.isInteger(idEnemy)) {
                    let canIFightTheMonster = Globals.areasManager.canIFightThisMonster(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemy, Globals.connectedUsers[res.locals.id].character.getStat("perception"));
                    let enemies = [];
                    if (!canIFightTheMonster) {
                        enemies = Globals.areasManager.selectRandomMonsterIn(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemy);
                    } else {
                        enemies = Globals.areasManager.getMonsterIdIn(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemy);
                    }
                    let response = Globals.fightManager.fightPvE([Globals.connectedUsers[res.locals.id].character], enemies, res.locals.id, canIFightTheMonster, res.locals.lang);
                    if (response.error) {
                        data.error = response.error;
                    } else {
                        data = response;
                    }

                } else {
                    // Error Message
                    data.error = Translator.getString(res.locals.lang, "errors", "fight_enter_id_monster");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "fight_impossible_in_town");
            }

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/arena", async (req, res) => {
            let data = {}
            let idOtherPlayerCharacter = 0;
            let mId = -1;
            let response;
            if (Globals.areasManager.canIFightInThisArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                // Ici on récupère l'id
                if (req.body.mention) {
                    mId = req.body.mention;
                } else if (req.body.idCharacter) {
                    idOtherPlayerCharacter = parseInt(req.body.idCharacter, 10);
                    if (idOtherPlayerCharacter && Number.isInteger(idOtherPlayerCharacter)) {
                        mId = Leaderboard.idOf(idOtherPlayerCharacter);
                    }
                } else {
                    // useless
                    data.error = Translator.getString(res.locals.lang, "errors", "fight_pvp_choose_enemy");
                }
                // Ici on lance le combat si connecté
                if (Globals.connectedUsers[mId]) {
                    if (res.locals.id !== mId) {
                        response = Globals.fightManager.fightPvP([Globals.connectedUsers[res.locals.id].character], [Globals.connectedUsers[mId].character], res.locals.id, res.locals.lang);
                        if (response.error != null) {
                            data.error = response.error;
                        } else {
                            data = response;
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "fight_pvp_cant_fight_yourself");
                    }

                } else {
                    if (mId != -1 && User.exist(mId)) {
                        if (res.locals.id !== mId) {
                            if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
                                let notConnectedEnemy = new User(mId);
                                notConnectedEnemy.loadUser();
                                notConnectedEnemy.character.setArea(Globals.areasManager.getArea(notConnectedEnemy.character.idArea));

                                response = Globals.fightManager.fightPvP([Globals.connectedUsers[res.locals.id].character], [notConnectedEnemy.character], res.locals.id, res.locals.lang);

                                if (response.error != null) {
                                    data.error = response.error;
                                } else {
                                    data = response;
                                }
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "generic_tired", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "fight_pvp_cant_fight_yourself");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "fight_pvp_not_same_area");
                    }
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "fight_pvp_cant_fight_here");
            }


            data.lang = res.locals.lang;
            return res.json(data);
        });

    }

}

module.exports = FightModule;