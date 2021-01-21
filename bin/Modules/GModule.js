const Globals = require("../Globals");
const LootSystem = require("../LootSystem");
const axios = require("axios").default;
const Translator = require("../Translator/Translator");
const PStatistics = require("../Achievement/PStatistics");
const express = require("express");


class GModule {
    constructor() {
        this.isReloadable = true;
        this.loadingTime = 0;
        this.isModule = true;
        this.isLoaded = false;
        this.isActive = true;

        /**
         * @type {express.Router}
         */
        this.router = null;
        this.commands = [];
    }

    async run() { }

    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.reactHandler();
        this.loadRoutes();
        this.freeLockedMembers();
        this.crashHandler();
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
                if (Globals.lockedMembers[res.locals.id] == true && !Globals.connectedUsers[res.locals.id].canBeUnstuck()) {
                    return res.json({
                        error: Translator.getString(res.locals.lang, "errors", "already_doing_something_command")
                    })
                } else {
                    Globals.lockedMembers[res.locals.id] = true;
                    Globals.connectedUsers[res.locals.id].lastCommandTime = Date.now();
                    next();
                }
                //next();

            } else {
                return res.json({
                    error: "Due to an error, this module is deactivated. The following commands will be disabled : " + this.commands.toString(),
                });
            }
        });
    }

    freeLockedMembers() {
        this.router.use((req, res) => {
            Globals.lockedMembers[res.locals.id] = false;
        })
    }

    loadNeededVariables() {
        this.router.use((req, res, next) => {
            if (Globals.connectedUsers[res.locals.id].isLoaded == true) {
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

                let user = Globals.connectedUsers[res.locals.id];
                let character = user.character;


                res.locals.trade = character.trade;
                res.locals.group = character.group;
                res.locals.lang = user.getLang();
                res.locals.pending = character.pendingPartyInvite;
                res.locals.pendingTrade = character.pendingTradeInvite;
                res.locals.marketplace = Globals.areasManager.getService(character.getIdArea(), "marketplace");
                res.locals.craftingbuilding = Globals.areasManager.getService(character.getIdArea(), "craftingbuilding");
                res.locals.shop = Globals.areasManager.getService(character.getIdArea(), "shop");
                res.locals.currentArea = character.getArea();
                res.locals.tLootSystem = new LootSystem();
                res.locals.user = user;
                res.locals.character = character;
                next();
            } else {
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

    /**
     * 
     * @param {express.Request} req
     * @param {express.Response} res
     * @param {Number} fightType (0 => Solo | 1 => Group)
     */
    async FightPvERoute(req, res, fightType) {
        if (fightType === 1) {
            // It's needed since it's only added on all fight commands, but not on group fight one
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_fights", 1);
        }
        let group = res.locals.group;
        let data = {}
        let idEnemyGroup = parseInt(req.body.idMonster, 10);

        if (Globals.areasManager.canIFightInThisArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
            if (idEnemyGroup != null && Number.isInteger(idEnemyGroup)) {
                if (res.locals.currentArea.getMonsterId(idEnemyGroup) != null) {
                    let canIFightTheMonster = false;
                    /**
                     * @type Array<{id: number,needToBeMaxLevel: boolean, number: number,level: number}>
                     */
                    let grpEnemies = [];
                    /** Typing variables like this to get references in visual studio
                    * @type {Array<Character>}
                    */
                    let grpCharacters = [];
                    // Used for achievements
                    let grpUsers = [];

                    if (fightType === 0) {
                        canIFightTheMonster = Globals.areasManager.canIFightThisMonster(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemyGroup, Globals.connectedUsers[res.locals.id].character.getStat(Stats.possibleStats.Perception));
                        grpCharacters = [Globals.connectedUsers[res.locals.id].character];
                        grpUsers = [Globals.connectedUsers[res.locals.id]];
                    } else {
                        canIFightTheMonster = Globals.areasManager.canIFightThisMonster(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemyGroup, group.getAverageTotalStat(Stats.possibleStats.Perception));
                        grpCharacters = group.getArrayOfCharacters();
                        grpUsers = group.getArrayOfPlayers();
                    }


                    if (!canIFightTheMonster) {
                        grpEnemies = Globals.areasManager.selectRandomMonsterIn(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemyGroup);
                    } else {
                        grpEnemies = Globals.areasManager.getMonsterIdIn(Globals.connectedUsers[res.locals.id].character.getIdArea(), idEnemyGroup);
                    }

                    // Specific to dungeon
                    let response = await Globals.fightManager.fightPvE(grpCharacters, grpEnemies, res.locals.id, canIFightTheMonster, res.locals.lang, await res.locals.currentArea.isFirstFloor());
                    if (response.error) {
                        data.error = response.error;
                    } else {
                        data = response;

                        this.fightAchievement(grpUsers, response.summary, res.locals.currentArea);
                        // Travel to entrance if dungeon and loose
                        if (res.locals.currentArea.areaType === "dungeon") {
                            /**
                             * @type {Area}
                             */
                            let areaToTravel;

                            // 0 means first group aka users
                            if (response.summary.winner === 0) {
                                areaToTravel = await res.locals.currentArea.getNextFloorOrExit();
                            } else {
                                // They lost, so they go to entrance
                                areaToTravel = await res.locals.currentArea.getEntrance();
                            }

                            for (let character of grpCharacters) {
                                // Not wating this since players can't move because of exhaust
                                character.changeArea(areaToTravel, character.getExhaust());
                            }

                            data.playersMovedTo = areaToTravel.getName(res.locals.lang);

                        }

                        let promises = [];
                        for (let char of grpCharacters) {
                            promises.push(char.healIfAreaIsSafe());
                        }
                        await Promise.all(promises);
                    }
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
        data.lang = res.locals.lang;
        return data;
    }

    /**
     * 
     * @param {Array<User>} grpOfUsers
     */
    async fightAchievement(grpOfUsers, fightSummary, currentArea) {
        let achievToUnlock = new AchievementUnlocker(grpOfUsers);

        let toWaitBefore = [];

        if (fightSummary.winner === 0) {

            for (let user of grpOfUsers) {

                let toDo = async () => {
                    let numberOfVictories = await PStatistics.getStat(user.character.id, "pvefights_victories");
                    if (numberOfVictories >= 10000) {
                        achievToUnlock.addAchievement(user, 13);
                    } else if (numberOfVictories >= 1000) {
                        achievToUnlock.addAchievement(user, 12);
                    }
                }

                toWaitBefore.push(toDo());
            }

            if (currentArea.areaType == "dungeon" && await currentArea.isLastFloor()) {
                achievToUnlock.addAchievementToAllUsers(6);
            }

            // Meaning in group
            if (grpOfUsers.length > 1) {
                achievToUnlock.addAchievementToAllUsers(7);
            }

            // For area related achievements
            switch (currentArea.id) {
                case 33:
                    achievToUnlock.addAchievementToAllUsers(2);
                    break;
            }

            // For drop related achievements
            for (let userDrops of fightSummary.drops) {
                if (userDrops.drop["4"] != null && userDrops.drop["4"].equipable > 0) {
                    achievToUnlock.addAchievementByUserName(userDrops.name, 4);
                }

                if (userDrops.drop["5"] != null && userDrops.drop["5"].equipable > 0) {
                    achievToUnlock.addAchievementByUserName(userDrops.name, 5);
                }
            }
        }

        // Waiting to get those async checks done
        await Promise.all(toWaitBefore);

        // No await since we can let this running 'in background'
        // Unlocks all achievements added to it (if there are achievements to unlock)
        achievToUnlock.unlockAchievementsForAll();

    }

    helpPanel(lang, page) {
        let maxPage = 8;
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
                    "info/profile": Translator.getString(lang, "help_panel", "info"),
                    "attributes": Translator.getString(lang, "help_panel", "attributes"),
                    "up <statName> <number>": Translator.getString(lang, "help_panel", "up") + " (str, int, con, dex, cha, will, luck, wis, per)",
                    "leaderboard <arg>": Translator.getString(lang, "help_panel", "leaderboard"),
                    "reset": Translator.getString(lang, "help_panel", "reset"),
                    "resettalents": Translator.getString(lang, "help_panel", "resettalents"),
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
                    "sellall <filter> <filterValue> <page>": Translator.getString(lang, "help_panel", "sellall_filter"),
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
                    "traveldirect <realAreaID>": Translator.getString(lang, "help_panel", "traveldirect"),
                    "arearesetbonuses": Translator.getString(lang, "help_panel", "arearesetbonuses"),
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
                    "mkshow/mksearch <filter> <filterValue> <page>": Translator.getString(lang, "help_panel", "mksearch"),
                    "mksee <idItem>": Translator.getString(lang, "help_panel", "mksee"),
                }
                break;

            case 6:
                commands[Translator.getString(lang, "help_panel", "craft_title")] = {
                    "craftlist <page>": Translator.getString(lang, "help_panel", "craftlist"),
                    "craftshow <idCraft>": Translator.getString(lang, "help_panel", "craftshow"),
                    "craft <idCraft> <?level>": Translator.getString(lang, "help_panel", "craft"),
                    "collect <idResource> <number>": Translator.getString(lang, "help_panel", "collect", [Globals.collectTriesOnce]),
                }

                commands[Translator.getString(lang, "help_panel", "shop_title")] = {
                    "sitems/shop <page>": Translator.getString(lang, "help_panel", "sitems"),
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
                commands[Translator.getString(lang, "help_panel", "trade_title")] = {
                    "tpropose @mention": Translator.getString(lang, "help_panel", "tpropose"),
                    "taccept": Translator.getString(lang, "help_panel", "taccept"),
                    "tcancel": Translator.getString(lang, "help_panel", "tcancel"),
                    "tshow": Translator.getString(lang, "help_panel", "tshow"),
                    "titem <idInTrade>": Translator.getString(lang, "help_panel", "titem"),
                    "tadd <idItemInInventory> <amount>": Translator.getString(lang, "help_panel", "tadd"),
                    "tremove <idInTrade> <amount>": Translator.getString(lang, "help_panel", "tremove"),
                    "tsetmoney <amount>": Translator.getString(lang, "help_panel", "tsetmoney"),
                    "tvalidate": Translator.getString(lang, "help_panel", "tvalidate"),
                }
                break;
            case 8:
                commands[Translator.getString(lang, "help_panel", "other_title")] = {
                    "lang": Translator.getString(lang, "help_panel", "lang"),
                    "lang <languageShort>": Translator.getString(lang, "help_panel", "lang_param"),
                    "settings": Translator.getString(lang, "help_panel", "settings"),
                    "setmobile <arg>": Translator.getString(lang, "help_panel", "setmobile"),
                }

                commands[Translator.getString(lang, "help_panel", "talents_title")] = {
                    "talents": Translator.getString(lang, "help_panel", "talents"),
                    "talentshow <idTalent>": Translator.getString(lang, "help_panel", "talentshow"),
                    "talentup <idTalent>": Translator.getString(lang, "help_panel", "talentup"),
                    "skillshow <idSkill>": Translator.getString(lang, "help_panel", "skillshow"),
                    "buildshow": Translator.getString(lang, "help_panel", "buildshow"),
                    "buildadd <idSkill>": Translator.getString(lang, "help_panel", "buildadd"),
                    "buildremove <idSkill>": Translator.getString(lang, "help_panel", "buildremove"),
                    "buildmove <idSkill> <slotNumber>": Translator.getString(lang, "help_panel", "buildmove"),
                    "buildclear": Translator.getString(lang, "help_panel", "buildclear"),
                    "talentexport": Translator.getString(lang, "help_panel", "talentexport"),
                    "talentimport <importString>": Translator.getString(lang, "help_panel", "talentimport"),
                }
                break;

        }

        data.commands = commands;
        data.page = page;
        data.maxPage = maxPage;
        return data;
    }

    /**
     * 
     * @param {express.Request} req
     */
    getSearchParams(req) {
        return {
            rarity: parseInt(req.body.idRarity != null ? req.body.idRarity : req.query.idRarity),
            type: parseInt(req.body.idType != null ? req.body.idType : req.query.idType),
            subtype: parseInt(req.body.idSousType != null ? req.body.idSousType : req.query.idSousType),
            level: parseInt(req.body.level != null ? req.body.level : req.query.level),
            level_up: parseInt(req.body.level != null ? req.body.level : req.query.level),
            level_down: parseInt(req.body.level_down != null ? req.body.level_down : req.query.level_down),
            power: parseInt(req.body.power != null ? req.body.power : req.query.power),
            power_up: parseInt(req.body.power != null ? req.body.power : req.query.power),
            power_down: parseInt(req.body.power_down != null ? req.body.power_down : req.query.power_down),
            name: req.body.name != null ? req.body.name : req.query.name,
            fav: req.body.fav != null ? req.body.fav : req.query.fav,
        }
    }

    asError(val) {
        return { error: val };
    }

    asSuccess(val) {
        return { success: val };
    }


}

class AchievementUnlocker {
    /**
     * 
     * @param {Array<User>} grpOfUsers
     */
    constructor(grpOfUsers) {
        /**
         * @type {Array<AchievementUnlockStructure>}
         */
        this.listOfPlayerAndRelatedAchievements = {};
        /**
         * @type {Array<User>}
         */
        this.userByName = {};

        for (let user of grpOfUsers) {
            this.listOfPlayerAndRelatedAchievements[user.id] = new AchievementUnlockStructure(user);
            this.userByName[user.getUsername()] = user;
        }
    }

    /**
     * 
     * @param {User} user
     * @param {number} idAchievement
     */
    addAchievement(user, idAchievement) {
        this.listOfPlayerAndRelatedAchievements[user.id].achievements.push(idAchievement);
    }

    /**
    * 
    * @param {string} username
    * @param {number} idAchievement
    */
    addAchievementByUserName(username, idAchievement) {
        if (this.userByName[username] != null) {
            this.listOfPlayerAndRelatedAchievements[this.userByName[username].id].achievements.push(idAchievement);
        }
        
    }

    /**
     * 
     * @param {number} idAchievement
     */
    addAchievementToAllUsers(idAchievement) {
        for (let achievUnlockerStructure of Object.values(this.listOfPlayerAndRelatedAchievements)) {
            achievUnlockerStructure.achievements.push(idAchievement);
        }
    }

    async unlockAchievementsForAll() {
        let promises = [];
        for (let unlockStructure of Object.values(this.listOfPlayerAndRelatedAchievements)) {
            promises.push(unlockStructure.unlockAchievements());
        }
        await Promise.all(promises);
    }

}

class AchievementUnlockStructure {
    /**
     * 
     * @param {User} user
     */
    constructor(user) {
        this.user = user; 

        /**
         * @type {Array<Number>}
         */
        this.achievements = [];
    }

    async unlockAchievements() {
        let promises = [];
        for (let id of this.achievements) {
            promises.push(this.user.character.getAchievements().unlock(id, this.user));
        }
        await Promise.all(promises);
    }
}


module.exports = GModule;

const User = require("../User");
const Character = require("../Character");
const Area = require("../Areas/Area");
const Stats = require("../Stats/Stats");
