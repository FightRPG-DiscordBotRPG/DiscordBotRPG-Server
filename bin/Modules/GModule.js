const Globals = require("../Globals");
const LootSystem = require("../LootSystem");
const axios = require("axios").default;
const Translator = require("../Translator/Translator");


class GModule {
    constructor() {
        this.isReloadable = true;
        this.loadingTime = 0;
        this.isModule = true;
        this.isLoaded = false;
        this.isActive = true;
        this.router = null;
        this.commands = [];
    }

    async run() { }

    init() {

    }

    unStuck(id) {
        if (Globals.lockedMembers[id] == true) {
            Globals.lockedMembers[id] = false;
        }
    }

    startLoading(name = "Generic Module") {
        this.loadingTime = Date.now();
        console.log("Loading module : " + name);
    }

    endLoading(name = "Generic Module") {
        console.log("Module : " + name + " loaded. Took : " + ((Date.now() - this.loadingTime) / 1000) + " seconds.");
        this.isLoaded = true;
    }

    crashHandler() {
        if (this.router != null) {
            this.router.use(async (err, req, res, next) => {
                let errorDate = new Date();
                console.log(errorDate.toUTCString());
                console.log(err);
                if (this.isReloadable) {
                    if (!this.devMode) {
                        this.isActive = false;
                        let msgError = "Due to an error, this module is deactivated. The following commands will be disabled : " + this.commands.toString() + "\n";
                        msgError += "Oops something goes wrong, report the issue here (https://github.com/FightRPG-DiscordBotRPG/FightRPG-Discord-BugTracker/issues)\n";

                        let errorsLines = err.stack.split("\n");
                        let nameAndLine = errorsLines[1].split(" ");
                        nameAndLine = nameAndLine[nameAndLine.length - 1].split("\\");
                        nameAndLine = nameAndLine[nameAndLine.length - 1].split(")")[0];

                        msgError += "```js\n" + errorsLines[0] + "\nat " + nameAndLine + "\n```";

                        let adminTell = "A module has crashed.\n" + this.commands.toString() + "\n" + "User that have crashed the command : " + (Globals.connectedUsers[res.locals.id] ? Globals.connectedUsers[res.locals.id].character.getName() : "Unknown");
                        adminTell += "\nRoute: " + req.url;
                        adminTell += "\nParameters:" + JSON.stringify(req.params);
                        adminTell += "\nBody:" + JSON.stringify(req.body);

                        console.log(adminTell);

                        try {
                            await axios.post("http://127.0.0.1:48921/usr", {
                                id: "241564725870198785",
                                message: adminTell,
                            });
                        } catch (e) {
                            console.log(e);
                        }
                        this.unStuck(res.locals.id);
                        return res.json({
                            error: msgError,
                        });
                    }
                }
                this.unStuck(res.locals.id);
                return res.json({
                    error: "There is something wrong with this module :/",
                });
            });
        }
    }

    reactHandler() {
        this.router.use((req, res, next) => {
            if (this.isActive == true || this.devMode == true) {
                /*if (Globals.lockedMembers[res.locals.id] === true) {
                    return res.json({
                        error: Translator.getString(res.locals.lang, "errors", "already_doing_something_command")
                    })
                } else {
                    Globals.lockedMembers[res.locals.id] = true;
                    next();
                }*/
                next();

            } else {
                return res.json({
                    error: "Due to an error, this module is deactivated. The following commands will be disabled : " + this.commands.toString(),
                });
            }
        });
    }

    freeLockedMembers() {
        this.router.use((req, res) => {
            if (Globals.lockedMembers[res.locals.id] == true) {
                Globals.lockedMembers[res.locals.id] = false;
            }
        })
    }

    loadNeededVariables() {
        this.router.use((req, res, next) => {
            if (Globals.connectedUsers[res.locals.id].isLoaded = true) {
                for (let i in req.body) {
                    try {
                        req.body[i] = decodeURIComponent(req.body[i]);
                    } catch (e) {
                        req.body[i] = encodeURIComponent(req.body[i]);
                        req.body[i] = decodeURIComponent(req.body[i]);
                    }
                }

                for (let i in req.query) {
                    try {
                        req.query[i] = decodeURIComponent(req.query[i]);
                    } catch (e) {
                        req.query[i] = encodeURIComponent(req.query[i]);
                        req.query[i] = decodeURIComponent(req.query[i]);
                    }
                }

                res.locals.group = Globals.connectedUsers[res.locals.id].character.group;
                res.locals.lang = Globals.connectedUsers[res.locals.id].getLang();
                res.locals.pending = Globals.connectedUsers[res.locals.id].character.pendingPartyInvite;
                res.locals.marketplace = Globals.areasManager.getService(Globals.connectedUsers[res.locals.id].character.getIdArea(), "marketplace");
                res.locals.craftingbuilding = Globals.areasManager.getService(Globals.connectedUsers[res.locals.id].character.getIdArea(), "craftingbuilding");
                res.locals.shop = Globals.areasManager.getService(Globals.connectedUsers[res.locals.id].character.getIdArea(), "shop");
                res.locals.currentArea = Globals.connectedUsers[res.locals.id].character.getArea();
                res.locals.tLootSystem = new LootSystem();
                next();
            } else {
                console.log("yep async bullshit !");
                res.json({
                    error: "Your character is loading, you must wait a little."
                });
            }

        });

    }


    getToStrShort(stat, lang) {
        switch (stat) {
            // Principaux
            case "str":
                stat = "strength";
                break;
            case "int":
                stat = "intellect";
                break;
            case "con":
                stat = "constitution";
                break;
            case "dex":
                stat = "dexterity";
                break;

            // Secondaires

            case "cha":
                stat = "charisma";
                break;
            case "wis":
                stat = "wisdom";
                break;
            case "will":
                stat = "will";
                break;
            case "per":
                stat = "perception";
                break;
            case "luck":
                stat = "luck";
                break;
        }
        return stat;
    }

    getEquipableIDType(string) {
        return Globals.equipableCorresponds[string] != null ? Globals.equipableCorresponds[string] : -1;
    }

    async isAdmin(req, res, next) {
        if (res.locals.id && Globals.admins.indexOf(res.locals.id) > -1) {
            next();
        } else {
            return res.status(403).json({
                error: 'Not Authorized!'
            });
        }
    }

    helpPanel(lang, page) {
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
                    "leaderboard <arg>": Translator.getString(lang, "help_panel", "leaderboard"),
                    "reset": Translator.getString(lang, "help_panel", "reset"),
                    "achievements <page>": Translator.getString(lang, "help_panel", "achievements"),
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
                    "rarities": Translator.getString(lang, "help_panel", "rarities"),
                    "types": Translator.getString(lang, "help_panel", "types"),
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
                    "guilds <page>": Translator.getString(lang, "help_panel", "guilds"),
                    "gcreate \"<name>\"": Translator.getString(lang, "help_panel", "gcreate"),
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
                    "gleaderswitch <playerID>": Translator.getString(lang, "help_panel", "gleaderswitch"),
                    "grename \"<name>\"": Translator.getString(lang, "help_panel", "grename", [Globals.guilds.basePriceLevel]),
                    "gterritories": Translator.getString(lang, "help_panel", "gterritories"),
                    "gkick <idCharacter>": Translator.getString(lang, "help_panel", "gkick"),
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
                    "wbleaderboard <type>": Translator.getString(lang, "help_panel", "wbleaderboard"),
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



module.exports = GModule;