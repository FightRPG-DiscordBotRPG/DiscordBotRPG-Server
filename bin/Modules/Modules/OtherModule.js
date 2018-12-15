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
const express = require("express");


class OtherModule extends GModule {
    constructor() {
        super();
        this.commands = ["lang", "help", "settings"];
        this.startLoading("Other");
        this.init();
        this.endLoading("Other");
    }
    init() {
        this.router = express.Router();

        // Add to router needed things
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_other", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/lang", async (req, res) => {
            let data = {};
            data.lang = res.locals.lang;
            data.languages = Translator.getAvailableLanguages(res.locals.lang);
            return res.json(data);
        });

        this.router.post("/lang", async (req, res) => {
            let data = {};
            data.lang = res.locals.lang;
            if (req.body.lang) {
                if (Translator.isLangExist(req.body.lang)) {
                    Globals.connectedUsers[res.locals.id].changeLang(req.body.lang);
                    data.lang = req.body.lang;
                    data.success = Translator.getString(req.body.lang, "languages", "lang_changed", [Translator.getString(req.body.lang, "languages", req.body.lang)])
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "languages_lang_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "languages_lang_dont_exist");
            }
            return res.json(data);
        });

        this.router.get("/help/:page?", async (req, res) => {
            let data;
            data = this.helpPanel(res.locals.lang, parseInt(req.params.page, 10));
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/settings", async (req, res) => {
            let data = {
                isGroupMuted: Globals.connectedUsers[res.locals.id].isGroupMuted(),
                isMarketplaceMuted: Globals.connectedUsers[res.locals.id].isMarketplaceMuted()
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });
        // TODO mute not working properly
        this.router.post("/settings", async (req, res) => {
            let data = {};
            let success = "";
            data.lang = res.locals.lang;
            if (req.body.mGroup != null) {
                if (Globals.connectedUsers[res.locals.id].isGroupMuted()) {
                    Globals.connectedUsers[res.locals.id].muteGroup(false);
                    success += Translator.getString(res.locals.lang, "group", "now_unmuted") + "\n";
                } else {
                    Globals.connectedUsers[res.locals.id].muteGroup(true);
                    success += Translator.getString(res.locals.lang, "group", "now_muted") + "\n";
                }
            }
            if (req.body.mMarket != null) {
                if (Globals.connectedUsers[res.locals.id].isMarketplaceMuted()) {
                    Globals.connectedUsers[res.locals.id].muteGroup(false);
                    success += Translator.getString(res.locals.lang, "marketplace", "now_unmuted") + "\n";
                } else {
                    Globals.connectedUsers[res.locals.id].muteGroup(true);
                    success += Translator.getString(res.locals.lang, "marketplace", "now_muted") + "\n";
                }
            }
            if (success != "") {
                data.success = success;
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "generic_cant_do_that");
            }
            return res.json(data);
        });

        this.router.get("/rarities", async (req, res) => {
            let data = {};

            let dbRes = conn.query("SELECT * FROM itemsrarities");
            data.rarities = [];
            for (let result of dbRes) {
                data.rarities.push({
                    idRarity: result.idRarity,
                    rarityName: Translator.getString(res.locals.lang, "rarities", result.nomRarity),
                    rarityColor: result.couleurRarity
                })
            }

            data.lang = res.locals.lang;

            return res.json(data);
        });

        this.router.get("/types", async (req, res) => {
            let data = {};

            let dbRes = conn.query("SELECT * FROM itemstypes");
            data.types = [];
            for (let result of dbRes) {
                data.types.push({
                    idType: result.idType,
                    typeName: Translator.getString(res.locals.lang, "item_types", result.nomType),
                    equipable: result.equipable,
                    stackable: result.stackable,
                    usable: result.usable,
                });
            }

            data.lang = res.locals.lang;

            return res.json(data);
        });
    }

    helpPanel(lang, page) {
        let str = "";
        let maxPage = 7;
        page = page && page > 0 && page <= maxPage ? page : 1;
        let data = {};
        let commands = {};

        switch (page) {
            case 1:
                commands[Translator.getString(lang, "help_panel", "equipment_title")] = {
                    "equipment/equiplist": Translator.getString(lang, "help_panel", "equipment"),
                    "equip <itemID>": Translator.getString(lang, "help_panel", "equip"),
                    "unequip <itemType>": Translator.getString(lang, "help_panel", "unequip") + " (chest, head, legs, weapon, horse)",
                    "use <itemID> <amount>": Translator.getString(lang, "help_panel", "use"),
                };

                commands[Translator.getString(lang, "help_panel", "character_title")] = {
                    "info": Translator.getString(lang, "help_panel", "info"),
                    "up <statName> <number>": Translator.getString(lang, "help_panel", "up") + " (str, int, con, dex, cha, will, luck, wis, per)",
                    "leaderboard": Translator.getString(lang, "help_panel", "leaderboard"),
                    "reset": Translator.getString(lang, "help_panel", "reset"),
                };

                commands[Translator.getString(lang, "help_panel", "fight_title")] = {
                    "fight <monsterID>": Translator.getString(lang, "help_panel", "fight"),
                    "grpfight <monsterID>": Translator.getString(lang, "help_panel", "grpfight"),
                    "arena @Someone": Translator.getString(lang, "help_panel", "arenaMention"),
                    "arena <playerID>": Translator.getString(lang, "help_panel", "arena"),
                }
                break;
            case 2:
                commands[Translator.getString(lang, "help_panel", "inventory_title")] = {
                    "inv/inventory": Translator.getString(lang, "help_panel", "inv"),
                    "inv/inventory <filter> <filterValue>": Translator.getString(lang, "help_panel", "inv_filter"),
                    "item <itemID>": Translator.getString(lang, "help_panel", "item"),
                    "itemfav <itemID or itemType>": Translator.getString(lang, "help_panel", "itemfav"),
                    "itemunfav <itemID or itemType>": Translator.getString(lang, "help_panel", "itemunfav"),
                    "sell <itemID>": Translator.getString(lang, "help_panel", "sell"),
                    "sellall": Translator.getString(lang, "help_panel", "sellall"),
                    "sendmoney <@mention or idCharacter> <value>": Translator.getString(lang, "help_panel", "sendmoney"),
                }

                commands[Translator.getString(lang, "help_panel", "filters_title")] = {
                    "rarities": Translator.getString(lang, "help_panel", "filter_rarities"),
                    "types": Translator.getString(lang, "help_panel", "filter_types"),
                }
                break;
            case 3:
                commands[Translator.getString(lang, "help_panel", "areas_title")] = {
                    "area": Translator.getString(lang, "help_panel", "area"),
                    "areas/regions": Translator.getString(lang, "help_panel", "areas"),
                    "areaconquest": Translator.getString(lang, "help_panel", "areaconquest"),
                    "arealevelup": Translator.getString(lang, "help_panel", "arealevelup"),
                    "areabonuseslist": Translator.getString(lang, "help_panel", "areabonuseslist"),
                    "areaplayers <page>": Translator.getString(lang, "help_panel", "areaplayers"),
                    "areaupbonus <bonus_identifier> <pts_to_allocate>": Translator.getString(lang, "help_panel", "areaupbonus"),
                    "travel <areaID>": Translator.getString(lang, "help_panel", "travel"),
                    "travelregion <regionID>": Translator.getString(lang, "help_panel", "travelregion"),
                }
                break;
            case 4:
                commands[Translator.getString(lang, "help_panel", "guilds_title")] = {
                    "guild": Translator.getString(lang, "help_panel", "guild"),
                    "guild": Translator.getString(lang, "help_panel", "guild"),
                    "guilds <page>": Translator.getString(lang, "help_panel", "guilds"),
                    "gcreate <name>": Translator.getString(lang, "help_panel", "gcreate"),
                    "gdisband": Translator.getString(lang, "help_panel", "gdisband"),
                    "gapply <guildID>": Translator.getString(lang, "help_panel", "gapply"),
                    "gaccept <playerID>": Translator.getString(lang, "help_panel", "gaccept"),
                    "gapplies": Translator.getString(lang, "help_panel", "gapplies"),
                    "gapplyremove <applyID>": Translator.getString(lang, "help_panel", "gapplyremove"),
                    "gappliesremove": Translator.getString(lang, "help_panel", "gappliesremove"),
                    "gannounce <message>": Translator.getString(lang, "help_panel", "gannounce"),
                    "gaddmoney <amount>": Translator.getString(lang, "help_panel", "gaddmoney"),
                    "gremovemoney <message>": Translator.getString(lang, "help_panel", "gremovemoney"),
                    "glevelup": Translator.getString(lang, "help_panel", "glevelup"),
                    "genroll": Translator.getString(lang, "help_panel", "genroll"),
                    "gunenroll": Translator.getString(lang, "help_panel", "gunenroll"),
                    "gleave": Translator.getString(lang, "help_panel", "gleave"),
                    "gmod <playerID> <rank>": Translator.getString(lang, "help_panel", "gmod"),
                }
                break;
            case 5:
                commands[Translator.getString(lang, "help_panel", "groups_title")] = {
                    "grp": Translator.getString(lang, "help_panel", "grp"),
                    "grpinvite @mention": Translator.getString(lang, "help_panel", "grpinvite_mention"),
                    "grpleave": Translator.getString(lang, "help_panel", "grpleave"),
                    "grpaccept": Translator.getString(lang, "help_panel", "grpaccept"),
                    "grpdecline": Translator.getString(lang, "help_panel", "grpdecline"),
                    "grpkick \"<name#tag>\"": Translator.getString(lang, "help_panel", "grpkick"),
                    "grpswap \"<name#tag>\"": Translator.getString(lang, "help_panel", "grpswap"),
                    "grpmute": Translator.getString(lang, "help_panel", "grpmute"),
                    "grpunmute": Translator.getString(lang, "help_panel", "grpunmute"),
                }

                commands[Translator.getString(lang, "help_panel", "market_title")] = {
                    "mkmylist": Translator.getString(lang, "help_panel", "mkmylist"),
                    "mkplace <idItemInInventory> <nb> <price>": Translator.getString(lang, "help_panel", "mkplace"),
                    "mkcancel <idItem>": Translator.getString(lang, "help_panel", "mkcancel"),
                    "mkbuy <idItem>": Translator.getString(lang, "help_panel", "mkbuy"),
                    "mksearch \"<itemName>\" <level> <page>": Translator.getString(lang, "help_panel", "mksearch"),
                    "mkshow <page>": Translator.getString(lang, "help_panel", "mkshow"),
                    "mksee <idItem>": Translator.getString(lang, "help_panel", "mksee"),
                }
                break;

            case 6:
                commands[Translator.getString(lang, "help_panel", "craft_title")] = {
                    "craftlist <page>": Translator.getString(lang, "help_panel", "craftlist"),
                    "craftshow <idCraft>": Translator.getString(lang, "help_panel", "craftshow"),
                    "craft <idCraft>": Translator.getString(lang, "help_panel", "craft"),
                    "collect <idResource>": Translator.getString(lang, "help_panel", "collect"),
                }

                commands[Translator.getString(lang, "help_panel", "shop_title")] = {
                    "sitems <page>": Translator.getString(lang, "help_panel", "sitems"),
                    "sbuy <idItem> <amount>": Translator.getString(lang, "help_panel", "sbuy"),
                }

                commands[Translator.getString(lang, "help_panel", "world_boss_title")] = {
                    "wbfight/wbattack": Translator.getString(lang, "help_panel", "wbfight"),
                    "wbshowall": Translator.getString(lang, "help_panel", "wbshowall"),
                    "wblastinfo": Translator.getString(lang, "help_panel", "wblastinfo"),
                }
                break;
            case 7:
                commands[Translator.getString(lang, "help_panel", "other_title")] = {
                    "lang": Translator.getString(lang, "help_panel", "lang"),
                    "lang <languageShort>": Translator.getString(lang, "help_panel", "lang_param"),
                    "settings": Translator.getString(lang, "help_panel", "settings"),
                }
                break;

        }

        data.commands = commands;
        data.page = page;
        data.maxPage = maxPage;
        return data;
    }
}

module.exports = OtherModule;