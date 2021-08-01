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
        this.router.use(async (req, res, next) => {
            if (this.isActive == true || this.devMode == true) {


                if (await Globals.connectedUsers[res.locals.id].isDoingSomething() || (Globals.lockedMembers[res.locals.id] == true && !Globals.connectedUsers[res.locals.id].canBeUnstuck())) {
                    return res.json({
                        error: Translator.getString(res.locals.lang, "errors", "already_doing_something_command")
                    })
                } else {
                    Globals.lockedMembers[res.locals.id] = true;
                    Globals.connectedUsers[res.locals.id].lastCommandTime = Date.now();
                    await Globals.connectedUsers[res.locals.id].lockUser();
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
            Globals.connectedUsers[res.locals.id].unlockUser();
        })
    }

    loadNeededVariables() {
        this.router.use(async (req, res, next) => {
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

                const user = Globals.connectedUsers[res.locals.id];
                const character = user.character;

                res.locals.trade = character.trade;
                res.locals.lang = user.getLang();
                res.locals.pendingTrade = character.pendingTradeInvite;
                res.locals.tLootSystem = new LootSystem();
                res.locals.user = user;

                await character.loadCharacter(character.id);
                res.locals.character = character;


                const area = await user.character.getArea();

                await user.loadGroup();
                res.locals.group = character.group;
                res.locals.pending = character.pendingPartyInvite;

                res.locals.currentArea = area;
                res.locals.marketplace = Globals.areasManager.getService(area.getID(), "marketplace");
                res.locals.craftingbuilding = Globals.areasManager.getService(area.getID(), "craftingbuilding");
                res.locals.shop = Globals.areasManager.getService(area.getID(), "shop");
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
        if (Globals.areasManager.canIFightInThisArea(res.locals.currentArea.getID())) {
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
                        canIFightTheMonster = Globals.areasManager.canIFightThisMonster(res.locals.currentArea.getID(), idEnemyGroup, Globals.connectedUsers[res.locals.id].character.getStat(Stats.possibleStats.Perception));
                        grpCharacters = [Globals.connectedUsers[res.locals.id].character];
                        grpUsers = [Globals.connectedUsers[res.locals.id]];
                    } else {
                        canIFightTheMonster = Globals.areasManager.canIFightThisMonster(res.locals.currentArea.getID(), idEnemyGroup, group.getAverageTotalStat(Stats.possibleStats.Perception));
                        grpCharacters = group.getArrayOfCharacters();
                        grpUsers = group.getArrayOfPlayers();
                    }


                    if (!canIFightTheMonster) {
                        grpEnemies = Globals.areasManager.selectRandomMonsterIn(res.locals.currentArea.getID(), idEnemyGroup);
                    } else {
                        grpEnemies = Globals.areasManager.getMonsterIdIn(res.locals.currentArea.getID(), idEnemyGroup);
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
                                character.changeArea(areaToTravel, await character.getExhaust());
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
            rebirth: parseInt(req.body.rebirth != null ? req.body.rebirth : req.query.rebirth),
            rebirth_up: parseInt(req.body.rebirth != null ? req.body.rebirth : req.query.rebirth),
            rebirth_down: parseInt(req.body.rebirth_down != null ? req.body.rebirth_down : req.query.rebirth_down),
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
