'use strict';
const Monstre = require("./Entities/Monster.js");
const Globals = require("./Globals");
const LootSystem = require("./LootSystem.js");
const FightPvE = require("./Fight/FightPvE");
const FightPvP = require("./Fight/FightPvP");
const Translator = require("./Translator/Translator");
const conf = require("../conf/conf");

class FightManager {
    constructor() {
        /**
         * @type {Object<string, Fight>}
         */
        this.fights = {};
        this.lootSystem = new LootSystem();
    }

    // Helper
    swapArrayIndexes(text, fight) {
        fight.text[0] = fight.text[1];
        fight.text[1] = fight.text[2];
        fight.text[2] = text;
        return fight;
    }

    // PveFight
    /**
     * 
     * @param {Array<Character>} users
     */
    async timeToFight(users) {
        for (let i in users) {
            if (!await users[i].canDoAction()) {
                return await users[i].getExhaustMillis();
            }
        }
        return -1;
    }

    // PvpFight
    /**
     * 
     * @param {Array<Character>} users
     */
    async timeToFightPvp(users) {
        for (let i in users) {
            if (!await users[i].canDoPvp()) {
                return await users[i].getExhaustMillisPvp();
            }
        }
        return -1;
    }

    /**
     * 
     * @param {Array<{id: number,needToBeMaxLevel: boolean, number: number,level: number}>} monsters
     * @param {Array<Character>} characters 
     */
    async loadMonsters(monsters, characters) {
        let level = 0;
        let rebirthLevel = 0;
        let area = await characters[0].getArea();
        if (characters.length > 1 && characters[0].group != null) {
            level = characters[0].group.getHighestLevel();
            rebirthLevel = characters[0].group.getHighestRebirthLevel();
        } else {
            level = characters[0].getLevel();
            rebirthLevel = characters[0].getRebirthLevel();
        }

        if (area.minLevel > level) {
            level = area.minLevel;
        } else if (area.maxLevel < level) {
            level = area.maxLevel;
        }

        if (area.getMinRebirthLevel() > rebirthLevel) {
            rebirthLevel = area.getMinRebirthLevel();
        } else if (area.getMaxRebirthLevel() < rebirthLevel) {
            rebirthLevel = area.getMaxRebirthLevel();
        }

        /**
         * @type {Monstre[]}
         **/
        let arr = [];
        for (let i in monsters) {
            for (let j = 0; j < monsters[i].number; j++) {
                let realLevel = level;
                if (monsters[i].needToBeMaxLevel) {
                    realLevel = area.maxLevel;
                } else if (monsters[i].level != 0) {
                    realLevel = monsters[i].level;
                }
                let ms = new Monstre(monsters[i].id);
                ms.uuid = i + j + ms.id + "";
                ms.decoratedId = monsters[i].number > 1 ? (j + 1) : null;
                await ms.loadMonster(realLevel, rebirthLevel);
                arr.push(ms);
            }
        }
        return arr;
    }

    fightAlreadyInBattle(userid) {

        if (conf.env == "dev") {
            return false;
        }

        let user = Globals.connectedUsers[userid];
        if (user != null && user.character.group != null) {
            let plrs = user.character.group.getArrayOfPlayers();
            for (let player of plrs) {
                if (this.fights[player.id] !== undefined) {
                    return true;
                }
            }
            return false;
        } else {
            return this.fights[userid] !== undefined;
        }
    }

    /**
     * 
     * @param {Array<Character>} characters
     * @param {Array<{id: number,needToBeMaxLevel: boolean, number: number,level: number}>} monsters
     * @param {string} userid
     * @param {boolean} canIFightTheMonster
     * @param {string} lang
     * @param {boolean} resetFightStats
     */
    async fightPvE(characters, monsters, userid, canIFightTheMonster, lang, resetFightStats = true) {
        let toApi = {
            team1_number: characters.length,
            team2_number: monsters.length,
            summary: new FightPvE([], [], lang).summary,
            beingAttacked: !canIFightTheMonster
        }
        //let alreadyInBattle = characters.length > 1 ? this.fightAlreadyInBattle(userid) : this.fights[userid] !== undefined;
        let timeToFight = await this.timeToFight(characters);
        if (timeToFight < 0) {
            let enemies = await this.loadMonsters(monsters, characters);

            if (toApi.beingAttacked) {
                // Ensure that the monster will attack firt
                enemies[0].secondaryStats.initiative += 2000;
            }

            let fight = new FightPvE(characters, enemies, lang);

            await fight.init(resetFightStats);

            // TODO: stop using this for characters groups
            this.fights[userid] = fight;

            // For each people in the group
            if (characters.length > 1 && Globals.connectedUsers[userid] != null && Globals.connectedUsers[userid].character.group != null) {
                Globals.connectedUsers[userid].character.group.doingSomething = conf.env == "dev" ? false : true;
                let fenters = Globals.connectedUsers[userid].character.group.getUsersIDsExceptLeader();
                for (let i of fenters) {
                    this.fights[i] = fight;
                }
            }

            // Make them wait even if they delete the message
            setTimeout(() => {
                this.deleteFight(userid);
            }, conf.env == "dev" ? 2000 : (fight.summary.rounds.length) * 4000);

            toApi.summary = this.fights[userid].summary;
        } else {
            // erreur
            if (timeToFight >= 0) {
                toApi.error = Translator.getString(lang, "errors", "generic_tired", [Math.ceil(timeToFight / 1000)]);
            }

        }

        return toApi;
    }

    deleteFight(userid) {
        if (this.fights[userid] && this.fights[userid].entities[0].length > 1 && Globals.connectedUsers[userid] && Globals.connectedUsers[userid].character.group != null) {
            Globals.connectedUsers[userid].character.group.fightEndBoardcast(this.fights[userid].summary);
            Globals.connectedUsers[userid].character.group.doingSomething = false;
            let fenters = Globals.connectedUsers[userid].character.group.getUsersIDsExceptLeader();
            for (let i of fenters) {
                delete this.fights[i];
            }
        }
        delete this.fights[userid];
    }

    /**
     * 
     * @param {Array<WolrdEntity>} attackers
     * @param {Array<WolrdEntity>} defenders
     * @param {string} userid
     * @param {string} lang
     */
    async fightPvP(attackers, defenders, userid, lang) {
        let toApi = {
            beingAttacked: false,
            team1_number: attackers.length,
            team2_number: defenders.length,
            summary: new FightPvP([], []).summary
        }

        //let alreadyInBattle = attackers.length > 1 ? this.fightAlreadyInBattle(userid) : this.fights[userid] !== undefined;

        let timeToFight = await this.timeToFightPvp(attackers);

        if (timeToFight < 0) {

            let pvpFight = new FightPvP(attackers, defenders);
            await pvpFight.init(true);
            toApi.summary = pvpFight.summary;
            // TODO: stop using this for characters groups
            this.fights[userid] = pvpFight;
            if (attackers.length > 1 && Globals.connectedUsers[userid] != null && Globals.connectedUsers[userid].character.group != null) {
                Globals.connectedUsers[userid].character.group.doingSomething = true;
                let fenters = Globals.connectedUsers[userid].character.group.getUsersIDsExceptLeader();
                for (let i of fenters) {
                    this.fights[i] = pvpFight;
                }
            }
            //console.log("Fight Initialized");
            setTimeout(() => {
                this.deleteFight(userid);
            }, (pvpFight.summary.rounds.length) * 4000);

        } else {
            // erreur
            if (timeToFight >= 0) {
                //console.log("Can't Initialize Fight : Already in battle");
                toApi.error = Translator.getString(lang, "errors", "generic_tired", [Math.ceil(timeToFight / 1000)]);
            }

        }

        return toApi;
    }



}

module.exports = FightManager;

const Fight = require("./Fight/Fight");
const Character = require("./Character");
const WolrdEntity = require("./Entities/WorldEntity");

