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


class OtherModule extends GModule {
    constructor() {
        super();
        this.commands = ["lang", "help", "settings"];
        this.startLoading("Other");
        this.init();
        this.endLoading("Other");
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

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_other", 1);

        switch (command) {
            case "lang":
                if (args[0]) {
                    if (Translator.isLangExist(args[0])) {
                        Globals.connectedUsers[authorIdentifier].changeLang(args[0]);
                        msg = Translator.getString(args[0], "languages", "lang_changed", [Translator.getString(args[0], "languages", args[0])])
                    } else {
                        msg = Translator.getString(lang, "errors", "languages_lang_dont_exist");
                    }
                } else {
                    msg = Translator.getString(lang, "languages", "list_of_languages") + "\n" + Translator.getAvailableLanguages(lang);
                }
                break;
            case "help":
                msg = this.helpPanel(lang, parseInt(args[0], 10));
                break;
            case "settings":
                let one = Emojis.getString("one");
                let two = Emojis.getString("two");
                let tempMsgContent = "**" + Translator.getString(lang, "settings_menu", "title") + "**\n\n" +
                one + " : " + "`" + Translator.getString(lang, "group", "settings_menu_mute", [(Globals.connectedUsers[authorIdentifier].isGroupMuted() ? Translator.getString(lang, "general", "enable") : Translator.getString(lang, "general", "disable"))]) + "`\n\n" +
                two + " : " + "`" + Translator.getString(lang, "marketplace", "settings_menu_mute", [(Globals.connectedUsers[authorIdentifier].isMarketplaceMuted() ? Translator.getString(lang, "general", "enable") : Translator.getString(lang, "general", "disable"))]) + "`\n\n";
                let tempMsg = await message.channel.send(tempMsgContent).catch(e => null);
                
                await Promise.all([
                    tempMsg.react(one),
                    tempMsg.react(two)
                ]).catch(e => null);

                const filter = (reaction, user) => {
                    return [one, two].includes(reaction.emoji.id || reaction.emoji.name) && user.id === message.author.id;
                };

                const collected = await tempMsg.awaitReactions(filter, {
                    max: 1,
                    time: 20000
                });
                const reaction = collected.first();
                if (reaction != null) {
                    switch (reaction.emoji.id || reaction.emoji.name) {
                        case one:
                            if(Globals.connectedUsers[authorIdentifier].isGroupMuted()) {
                                Globals.connectedUsers[authorIdentifier].muteGroup(false);
                                msg = Translator.getString(lang, "group", "now_unmuted");
                            } else {
                                Globals.connectedUsers[authorIdentifier].muteGroup(true);
                                msg = Translator.getString(lang, "group", "now_muted");
                            }
                            break;
                        case two:
                            if (Globals.connectedUsers[authorIdentifier].isMarketplaceMuted()) {
                                Globals.connectedUsers[authorIdentifier].muteGroup(false);
                                msg = Translator.getString(lang, "marketplace", "now_unmuted");
                            } else {
                                Globals.connectedUsers[authorIdentifier].muteGroup(true);
                                msg = Translator.getString(lang, "marketplace", "now_muted");
                            }
                            break;
                    }
                }
                tempMsg.delete().catch(e => null);
                break;
        }

        this.sendMessage(message, msg);
    }

    helpPanel(lang, page) {
        let str = "";
        let maxPage = 5;
        page = page && page > 0 && page <= maxPage ? page : 1;

        switch (page) {
            case 1:
                str = "```apache\n" +
                    "::" + Translator.getString(lang, "help_panel", "help") + "::\n" +
                    "[" + Translator.getString(lang, "help_panel", "inventory_title") + "]\n" +
                    "::inv/inventory : " + Translator.getString(lang, "help_panel", "inv") + "\n" +
                    "::item <itemID> : " + Translator.getString(lang, "help_panel", "item") + "\n" +
                    "::itemfav <itemID or itemType> : " + Translator.getString(lang, "help_panel", "itemfav") + "\n" +
                    "::itemunfav <itemID or itemType> : " + Translator.getString(lang, "help_panel", "itemunfav") + "\n" +
                    "::sell <itemID> : " + Translator.getString(lang, "help_panel", "sell") + "\n" +
                    "::sellall : " + Translator.getString(lang, "help_panel", "sellall") + "\n" +

                    "[" + Translator.getString(lang, "help_panel", "equipment_title") + "]\n" +
                    "::equipment/equipList : " + Translator.getString(lang, "help_panel", "equipment") + "\n" +
                    "::equip <itemID> : " + Translator.getString(lang, "help_panel", "equip") + "\n" +
                    "::unequip <itemType> : " + Translator.getString(lang, "help_panel", "unequip") + " (chest,head,legs,weapon)" + "\n" +

                    "[" + Translator.getString(lang, "help_panel", "character_title") + "]\n" +
                    "::info : " + Translator.getString(lang, "help_panel", "info") + "\n" +
                    "::up <statName> <number> : " + Translator.getString(lang, "help_panel", "up") + " (str, int, con, dex, cha, will, luck, wis, per)\n" +
                    "::leaderboard : " + Translator.getString(lang, "help_panel", "leaderboard") + "\n" +
                    "::reset : " + Translator.getString(lang, "help_panel", "reset") + "\n" +

                    "[" + Translator.getString(lang, "help_panel", "fight_title") + "]\n" +
                    "::fight <monsterID> : " + Translator.getString(lang, "help_panel", "fight") + "\n" +
                    "::grpfight <monsterID> : " + Translator.getString(lang, "help_panel", "grpfight") + "\n" +
                    "::arena @Someone : " + Translator.getString(lang, "help_panel", "arenaMention") + "\n" +
                    "::arena <playerID> : " + Translator.getString(lang, "help_panel", "arena") + "\n";
                break;
            case 2:
                str = "```apache\n" +
                    "::" + Translator.getString(lang, "help_panel", "help") + "::\n" +
                    "[" + Translator.getString(lang, "help_panel", "areas_title") + "]\n" +
                    "::area : " + Translator.getString(lang, "help_panel", "area") + "\n" +
                    "::areas : " + Translator.getString(lang, "help_panel", "areas") + "\n" +
                    "::areaconquest : " + Translator.getString(lang, "help_panel", "areaconquest") + "\n" +
                    "::arealevelup : " + Translator.getString(lang, "help_panel", "arealevelup") + "\n" +
                    "::areabonuseslist : " + Translator.getString(lang, "help_panel", "areabonuseslist") + "\n" +
                    "::areaplayers <page> : " + Translator.getString(lang, "help_panel", "areaplayers") + "\n" +
                    "::areaupbonus <bonus_identifier> <pts_to_allocate> : " + Translator.getString(lang, "help_panel", "areaupbonus") + "\n" +
                    "::travel <areaID> : " + Translator.getString(lang, "help_panel", "travel") + "\n";
                break;
            case 3:
                str = "```apache\n" +
                    "::" + Translator.getString(lang, "help_panel", "help") + "::\n" +
                    "[" + Translator.getString(lang, "help_panel", "guilds_title") + "]\n" +
                    "::guild : " + Translator.getString(lang, "help_panel", "guild") + "\n" +
                    "::guilds <page> : " + Translator.getString(lang, "help_panel", "guilds") + "\n" +
                    "::gcreate <name> : " + Translator.getString(lang, "help_panel", "gcreate") + "\n" +
                    "::gdisband : " + Translator.getString(lang, "help_panel", "gdisband") + "\n" +
                    "::gapply <guildID> : " + Translator.getString(lang, "help_panel", "gapply") + "\n" +
                    "::gcreate <playerID> : " + Translator.getString(lang, "help_panel", "gaccept") + "\n" +
                    "::gapplies : " + Translator.getString(lang, "help_panel", "gapplies") + "\n" +
                    "::gapplyremove <applyID> : " + Translator.getString(lang, "help_panel", "gapplyremove") + "\n" +
                    "::gappliesremove : " + Translator.getString(lang, "help_panel", "gappliesremove") + "\n" +
                    "::gannounce <message> : " + Translator.getString(lang, "help_panel", "gannounce") + "\n" +
                    "::gaddmoney <amount> : " + Translator.getString(lang, "help_panel", "gaddmoney") + "\n" +
                    "::gremovemoney <message> : " + Translator.getString(lang, "help_panel", "gremovemoney") + "\n" +
                    "::glevelup : " + Translator.getString(lang, "help_panel", "glevelup") + "\n" +
                    "::genroll : " + Translator.getString(lang, "help_panel", "genroll") + "\n" +
                    "::gunenroll : " + Translator.getString(lang, "help_panel", "gunenroll") + "\n" +
                    "::gaccept <playerID> : " + Translator.getString(lang, "help_panel", "gaccept") + "\n" +
                    "::gmod <playerID> <rank> : " + Translator.getString(lang, "help_panel", "gmod") + "\n";
                break;
            case 4:
                str = "```apache\n" +
                    "::" + Translator.getString(lang, "help_panel", "help") + "::\n" +
                    "[" + Translator.getString(lang, "help_panel", "groups_title") + "]\n" +
                    "::grp : " + Translator.getString(lang, "help_panel", "grp") + "\n" +
                    "::grpinvite @mention : " + Translator.getString(lang, "help_panel", "grpinvite_mention") + "\n" +
                    "::grpleave : " + Translator.getString(lang, "help_panel", "grpleave") + "\n" +
                    "::grpaccept : " + Translator.getString(lang, "help_panel", "grpaccept") + "\n" +
                    "::grpdecline : " + Translator.getString(lang, "help_panel", "grpdecline") + "\n" +
                    "::grpkick \"<name#tag>\" : " + Translator.getString(lang, "help_panel", "grpkick") + "\n" +
                    "::grpswap \"<name#tag>\" : " + Translator.getString(lang, "help_panel", "grpswap") + "\n" +
                    "::grpmute : " + Translator.getString(lang, "help_panel", "grpmute") + "\n" +
                    "::grpunmute : " + Translator.getString(lang, "help_panel", "grpunmute") + "\n" +

                    "[" + Translator.getString(lang, "help_panel", "market_title") + "]\n" +
                    "::mkmylist : " + Translator.getString(lang, "help_panel", "mkmylist") + "\n" +
                    "::mkplace <idItemInInventory> <nb> <price> : " + Translator.getString(lang, "help_panel", "mkplace") + "\n" +
                    "::mkcancel <idItem> : " + Translator.getString(lang, "help_panel", "mkcancel") + "\n" +
                    "::mkbuy <idItem> : " + Translator.getString(lang, "help_panel", "mkbuy") + "\n" +
                    "::mksearch \"<itemName>\" <level> <page> : " + Translator.getString(lang, "help_panel", "mksearch") + "\n" +
                    "::mkshow <page> : " + Translator.getString(lang, "help_panel", "mkshow") + "\n" +
                    "::mksee <idItem> : " + Translator.getString(lang, "help_panel", "mksee") + "\n";
                break;

            case 5:
                str = "```apache\n" +
                    "::" + Translator.getString(lang, "help_panel", "help") + "::\n" +
                    "[" + Translator.getString(lang, "help_panel", "craft_title") + "]\n" +
                    "::craftlist <page>: " + Translator.getString(lang, "help_panel", "craftlist") + "\n" +
                    "::craftshow <idCraft> : " + Translator.getString(lang, "help_panel", "craftshow") + "\n" +
                    "::craft <idCraft> : " + Translator.getString(lang, "help_panel", "craft") + "\n" +
                    "::collect <idResource> : " + Translator.getString(lang, "help_panel", "collect") + "\n" +

                    "[" + Translator.getString(lang, "help_panel", "other_title") + "]\n" +
                    "::lang : " + Translator.getString(lang, "help_panel", "lang") + "\n" +
                    "::lang <languageShort> : " + Translator.getString(lang, "help_panel", "lang_param") + "\n" +
                    "::settings : " + Translator.getString(lang, "help_panel", "settings") + "\n";
                break;
        }
        str += "\n" + Translator.getString(lang, "general", "page_out_of_x", [page, maxPage]) + "```";
        return str;
    }
}

module.exports = OtherModule;