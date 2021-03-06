const GModule = require("../GModule");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
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
        super.init();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_fights", 1);
            next();
        });
    }

    loadRoutes() {
        this.router.post("/monster", async (req, res, next) => {
            let data = await this.FightPvERoute(req, res, 0);
            await next();
            return res.json(data);
        });

        this.router.post("/arena", async (req, res, next) => {
            let data = {}
            let idOtherPlayerCharacter = 0;
            let mId = -1;
            let response;

            // Ici on récupère l'id
            if (req.body.mention) {
                mId = req.body.mention;
            } else if (req.body.idCharacter) {
                idOtherPlayerCharacter = parseInt(req.body.idCharacter, 10);
                if (idOtherPlayerCharacter && Number.isInteger(idOtherPlayerCharacter)) {
                    mId = await User.getIDByIDCharacter(idOtherPlayerCharacter);
                }
            } else {
                // useless
                data.error = Translator.getString(res.locals.lang, "errors", "fight_pvp_choose_enemy");
            }

            if (mId != -1 && await User.exist(mId)) {
                if (res.locals.id !== mId) {
                    if (await Globals.connectedUsers[res.locals.id].character.getArea().isFirstFloor()) {
                        if (Globals.connectedUsers[res.locals.id].character.canDoPvp()) {
                            let userToAttack = new User(mId);
                            await userToAttack.lightLoad();

                            // FIX Bug Arena Spam
                            let userWhoAttack = Globals.connectedUsers[res.locals.id];

                            response = await Globals.fightManager.fightPvP([userWhoAttack.character], [userToAttack.character], res.locals.id, res.locals.lang);

                            if (response.error != null) {
                                data.error = response.error;
                            } else {
                                data = response;
                                userWhoAttack.character.healIfAreaIsSafe();
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "generic_tired", [Globals.connectedUsers[res.locals.id].character.getExhaustPvp()]);
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "fight_pvp_cant_fight_here");
                    }
                    
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "fight_pvp_cant_fight_yourself");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "generic_user_dont_exist");
            }


            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

    }

}

module.exports = FightModule;