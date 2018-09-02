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

class AdminModule extends GModule {
    constructor() {
        super();
        this.commands = ["updatepresence", "giveme", "active", "mutefor", "xp", "gold", "resetfight", "reload_translations", "reload_emojis"];
        this.startLoading("Admin");
        this.init();
        this.endLoading("Admin");
    }

    async run(message, command, args) {
        let isAdmin = Globals.admins.indexOf(message.author.id) > -1;
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
        if (!isAdmin) return;

        switch (command) {
            case "updatepresence":
                try {
                    await message.client.user.setPresence({
                        game: {
                            name: "On " + message.client.guilds.size + " guilds !",
                        },
                    });
                    msg = "Présence mise à jour.";
                } catch (e) {
                    msg = e;
                }
                break;

            case "giveme":
                args[0] = parseInt(args[0]);
                if (args[0] && Number.isInteger(args[0])) {
                    if (tLootSystem.adminGetItem(Globals.connectedUsers[authorIdentifier].character, args[0], args[1])) {
                        msg = "Done";
                    } else {
                        msg = "Something goes wrong !";
                    }
                }
                break;

            case "active":
                if (args[0] === "true") {
                    Globals.activated = true;
                    msg = "Bot activated";
                } else if (args[0] === "false") {
                    Globals.activated = false;
                    msg = "Bot deactivated"
                }
                break;

            case "mutefor":
                if (args[0] != null) {
                    let muteTime = 100;
                    if (args[1] != null) {
                        muteTime = args[1];
                    }

                    if (Globals.connectedUsers[args[0]]) {
                        Globals.connectedUsers[args[0]].character.waitForNextFight(muteTime * 1000);
                        msg = "User muted for " + muteTime + " seconds";
                    }
                }
                break;

            case "xp":
                if (Globals.connectedUsers[authorIdentifier].character.getLevel() < Globals.maxLevel) {
                    let value = parseInt(args[0], 10);
                    if (!value && !Number.isInteger(value)) {
                        value = 1;
                    }

                    let str = "Tenez c'est le bon dieu qui vous l'offre ! \n" + value + " XP tombent du ciel rien que pour vous !\n";
                    let actualLevel = Globals.connectedUsers[authorIdentifier].character.getLevel();
                    Globals.connectedUsers[authorIdentifier].character.addExp(value);
                    let diffLevel = Globals.connectedUsers[authorIdentifier].character.getLevel() - actualLevel;
                    if (diffLevel > 0) {
                        let plur = diffLevel > 1 ? "x" : "";
                        str += "<:levelup:403456740139728906> Bravo ! Vous avez gagné : " + diffLevel + " niveau" + plur + ". Vous êtes desormais niveau : " + Globals.connectedUsers[authorIdentifier].character.getLevel() + " !\n";
                    }
                    msg = str;
                } else {
                    msg = "Vous êtes déjà au niveau maximum !";
                }
                break;

            case "gold":
                let value = parseInt(args[0], 10);
                if (!value && !Number.isInteger(value)) {
                    value = 1;
                }

                let str = "Tenez c'est le bon dieu qui vous l'offre ! \n" + value + " Argent tombent du ciel rien que pour vous !\n";
                Globals.connectedUsers[authorIdentifier].character.addMoney(value);
                str += "<:treasure:403457812535181313> Vous avez désormais : " + Globals.connectedUsers[authorIdentifier].character.money + " Argent !";

                msg = str;
                break;

            case "resetfight":
                Globals.connectedUsers[authorIdentifier].character.canFightAt = 0;
                msg = "Reset Done";
                break;
            case "reload_translations":
                Translator.nbOfTranslations = 0;
                Translator.loadSync();
                Translator.loadItemsBases();
                Translator.loadAreasBases();
                Translator.loadRegionsBases();
                Translator.loadMonstersBases();
                msg = "Translations reloaded";
                break;
            case "reload_emojis":
                delete require.cache[require.resolve("../../Emojis.js")];
                require("../../Emojis.js");
                msg = "Emojis reloaded";
                break;
                
        }

        this.sendMessage(message, msg);
    }
}

module.exports = AdminModule;