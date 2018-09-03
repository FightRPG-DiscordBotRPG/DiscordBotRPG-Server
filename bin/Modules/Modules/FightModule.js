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


class FightModule extends GModule {
    constructor() {
        super();
        this.commands = ["fight", "arena"];
        this.startLoading("Fight");
        this.init();
        this.endLoading("Fight");
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

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_fights", 1);

        switch (command) {
            case "fight":
                //Globals.fightManager.fightPvE(Globals.connectedUsers[authorIdentifier], message, args[0]);
                let idEnemy = parseInt(args[0], 10);
                if (Globals.areasManager.canIFightInThisArea(Globals.connectedUsers[authorIdentifier].character.getIdArea())) {
                    if (idEnemy != null && Number.isInteger(idEnemy)) {
                        let canIFightTheMonster = Globals.areasManager.canIFightThisMonster(Globals.connectedUsers[authorIdentifier].character.getIdArea(), idEnemy, Globals.connectedUsers[authorIdentifier].character.getStat("perception"));
                        let enemies = [];
                        if (!canIFightTheMonster) {
                            enemies = Globals.areasManager.selectRandomMonsterIn(Globals.connectedUsers[authorIdentifier].character.getIdArea(), idEnemy);
                        } else {
                            enemies = Globals.areasManager.getMonsterIdIn(Globals.connectedUsers[authorIdentifier].character.getIdArea(), idEnemy);
                        }
                        Globals.fightManager.fightPvE([Globals.connectedUsers[authorIdentifier].character], enemies, message, canIFightTheMonster, lang);
                        //Globals.fightManager.fightPvE(Globals.connectedUsers[authorIdentifier], message, idEnemy, canIFightTheMonster);

                    } else {
                        // Error Message
                        msg = Translator.getString(lang, "errors", "fight_enter_id_monster");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "fight_impossible_in_town");
                }
                break;


            case "arena":
                firstMention = mentions.first();
                let idOtherPlayerCharacter = 0;
                let mId = -1;
                if (Globals.areasManager.canIFightInThisArea(Globals.connectedUsers[authorIdentifier].character.getIdArea())) {
                    // Ici on récupère l'id
                    if (firstMention) {
                        mId = firstMention.id;
                    } else if (args[0]) {
                        idOtherPlayerCharacter = parseInt(args[0], 10);
                        if (idOtherPlayerCharacter && Number.isInteger(idOtherPlayerCharacter)) {
                            mId = Leaderboard.idOf(idOtherPlayerCharacter);
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "fight_pvp_choose_enemy");
                    }
                    // Ici on lance le combat si possible
                    if (Globals.connectedUsers[mId]) {
                        if (authorIdentifier !== mId) {
                            Globals.fightManager.fightPvP([Globals.connectedUsers[authorIdentifier].character], [Globals.connectedUsers[mId].character], message, lang);
                        } else {
                            msg = Translator.getString(lang, "errors", "fight_pvp_cant_fight_yourself");
                        }

                    } else {
                        if(mId != -1) {
                            if (authorIdentifier !== mId) {
                                if(Globals.connectedUsers[authorIdentifier].character.canDoAction()) {
                                    let notConnectedEnemy = new User(mId);
                                    notConnectedEnemy.loadUser();
                                    notConnectedEnemy.character.setArea(Globals.areasManager.getArea(notConnectedEnemy.character.idArea));
                                    Globals.fightManager.fightPvP([Globals.connectedUsers[authorIdentifier].character], [notConnectedEnemy.character], message, lang);
                                } else {
                                    msg = Translator.getString(lang, "errors", "generic_tired", [Globals.connectedUsers[authorIdentifier].character.getExhaust()]);
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "fight_pvp_cant_fight_yourself");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "fight_pvp_not_same_area");
                        }
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "fight_pvp_cant_fight_here");
                }

                break;
        }

        this.sendMessage(message, msg);
    }
}

module.exports = FightModule;