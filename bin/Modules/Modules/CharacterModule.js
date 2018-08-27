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


class CharacterModule extends GModule {
    constructor() {
        super();
        this.commands = ["reset", "leaderboard", "info", "up"];
        this.startLoading("Character");
        this.init();
        this.endLoading("Character");

        this.authorizedAttributes = ["str", "int", "con", "dex", "cha", "will", "luck", "wis", "per"];
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

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_character", 1);

        switch (command) {

            case "reset":
                if (Globals.connectedUsers[authorIdentifier].character.resetStats()) {
                    msg = Translator.getString(lang, "character", "reset_done");
                } else {
                    msg = Translator.getString(lang, "errors", "character_you_dont_have_enough_to_reset")
                }

                break;

            case "leaderboard":
                msg = Leaderboard.playerLeaderboardToStr(Globals.connectedUsers[authorIdentifier].character.id);
                break;

            case "info":
                msg = Globals.connectedUsers[authorIdentifier].infoPanel();
                break;

            case "up":
                if (this.authorizedAttributes.indexOf(args[0]) !== -1) {
                    let done = Globals.connectedUsers[authorIdentifier].character.upStat(args[0], args[1]);
                    if (done) {
                        msg = Translator.getString(lang, "character", "attribute_up_to", [this.getToStrShort(args[0]), Globals.connectedUsers[authorIdentifier].character.stats[this.getToStrShort(args[0])]]) +
                            "." + (Globals.connectedUsers[authorIdentifier].character.statPoints > 1 ?
                                Translator.getString(lang, "character", "attribute_x_points_available_plural", [Globals.connectedUsers[authorIdentifier].character.statPoints]) :
                                Translator.getString(lang, "character", "attribute_x_points_available", [Globals.connectedUsers[authorIdentifier].character.statPoints]));

                    } else {
                        msg = Translator.getString(lang, "errors", "character_you_cant_distribute_this_amount_of_points");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "character_attribute_dont_exist");
                }
                break;
        }

        this.sendMessage(message, msg);
    }


}

module.exports = CharacterModule;