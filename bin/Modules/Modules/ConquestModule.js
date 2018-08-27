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


class ConquestModule extends GModule {
    constructor() {
        super();
        this.commands = ["arealevelup", "areaupbonus", "areabonuseslist", "areaconquest"];
        this.startLoading("Conquest");
        this.init();
        this.endLoading("Conquest");
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

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_areas", 1);
        switch (command) {
            case "arealevelup":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (currentArea.getOwnerID() === tGuildId) {
                    if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[authorIdentifier].character.id].rank === 3) {
                        if (!AreaTournament.haveStartedByIdArea(Globals.connectedUsers[authorIdentifier].character.getIdArea())) {
                            if (!currentArea.isMaxLevel()) {
                                let toLevelUpArea = currentArea.getPriceNextLevel();
                                if (Globals.connectedGuilds[tGuildId].haveThisMoney(toLevelUpArea)) {
                                    currentArea.levelUp();
                                    Globals.connectedGuilds[tGuildId].removeMoneyDirect(toLevelUpArea);
                                    msg = Translator.getString(lang, "area", "level_up") + "\n";
                                    msg += Translator.getString(lang, "guild", "you_paid_x", [toLevelUpArea]);
                                } else {
                                    msg = Translator.getString(lang, "errors", "guild_you_dont_have_enough_money");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "area_at_max_level");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_tournament_started_generic");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_dont_have_permission_to_levelup_area");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "guild_dont_own_this_area");
                }
                break;

            case "areaupbonus":
                tGuildId = Globals.connectedUsers[authorIdentifier].character.idGuild;
                if (currentArea.getOwnerID() === tGuildId) {
                    if (tGuildId > 0 && Globals.connectedGuilds[tGuildId].members[Globals.connectedUsers[authorIdentifier].character.id].rank === 3) {
                        if (!AreaTournament.haveStartedByIdArea(Globals.connectedUsers[authorIdentifier].character.getIdArea())) {
                            if (currentArea.isBonusAvailable(args[0])) {
                                args[1] = args[1] != null ? Number.parseInt(args[1]) : 1000;
                                args[1] = args[1] > 0 ? args[1] : 1000;
                                if (currentArea.haveThisAmountOfStatPoints(args[1])) {
                                    currentArea.upStat(args[0], args[1]);
                                    msg = Translator.getString(lang, "area", "up_stat", [Translator.getString(lang, "bonuses", args[0]), args[1]]);
                                } else {
                                    msg = Translator.getString(lang, "errors", "area_dont_have_enough_stat_points");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "area_bonus_not_available");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_tournament_started_generic");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "generic_cant_do_that");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "guild_dont_own_this_area");
                }
                break;

            case "areabonuseslist":
                msg = currentArea.listOfBonusesToStr(lang);
                break;

            case "areaconquest":
                msg = Globals.areasManager.seeConquestOfThisArea(Globals.connectedUsers[authorIdentifier].character.getIdArea(), lang);
                break;
        }

        this.sendMessage(message, msg);
    }
}

module.exports = ConquestModule;