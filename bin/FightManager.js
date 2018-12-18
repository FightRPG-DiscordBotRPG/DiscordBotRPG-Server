'use strict';
const Monstre = require("./Monstre.js");
const Globals = require("./Globals");
const LootSystem = require("./LootSystem.js");
const FightPvE = require("./Fight/FightPvE");
const FightPvP = require("./Fight/FightPvP");
const Translator = require("./Translator/Translator");

class FightManager {
    constructor() {
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

    timeToFight(users) {
        for (let i in users) {
            if (!users[i].canDoAction()) {
                return users[i].getExhaustMillis();
            }
        }
        return -1;
    }

    /**
     * 
     * @param {Array<Monstre>} monsters 
     * @param {Array<Character>} characters 
     */
    async loadMonsters(monsters, characters) {
        let level = 0;
        let area = characters[0].getArea();
        if (characters[0].group != null) {
            level = characters[0].group.getHighestLevel();
        } else {
            level = characters[0].getLevel();
        }

        if (area.minLevel > level) {
            level = area.minLevel;
        } else if (area.maxLevel < level) {
            level = area.maxLevel;
        }



        let arr = [];
        for (let i in monsters) {
            for (let j = 0; j < monsters[i].number; j++) {
                let realLevel = level;
                if (monsters[i].needToBeMaxLevel == true) {
                    realLevel = area.maxLevel;
                }
                let ms = new Monstre(monsters[i].id);
                await ms.loadMonster(realLevel);
                arr.push(ms);
            }
        }
        return arr;
    }

    fightAlreadyInBattle(userid) {
        let user = Globals.connectedUsers[userid];
        if (user != null && user.character.group != null) {
            let plrs = user.character.group.getArrayOfPlayers();
            for (let i of plrs) {
                if (this.fights[plrs.id] !== undefined) {
                    return true;
                }
            }
            return false;
        } else {
            return this.fights[userid] !== undefined;
        }
    }

    async fightPvE(users, monsters, userid, canIFightTheMonster, lang) {
        let toApi = {
            beingAttacked: false,
            team1_number: users.length,
            team2_number: monsters.length
        }
        let alreadyInBattle = users.length > 1 ? this.fightAlreadyInBattle(userid) : this.fights[userid] !== undefined;
        let timeToFight = this.timeToFight(users);
        if (timeToFight < 0 && !alreadyInBattle) {
            let enemies = await this.loadMonsters(monsters, users);
            let thisPvEFight = {
                fight: new FightPvE(users, enemies, lang),
            };
            await thisPvEFight.fight.init();

            this.fights[userid] = thisPvEFight;

            // For each people in the group
            if (users.length > 1 && Globals.connectedUsers[userid] != null && Globals.connectedUsers[userid].character.group != null) {
                Globals.connectedUsers[userid].character.group.doingSomething = true;
                let fenters = Globals.connectedUsers[userid].character.group.getUsersIDsExceptLeader();
                for (let i of fenters) {
                    this.fights[i] = thisPvEFight;
                }
            }

            // Make them wait even if they delete the message
            setTimeout(() => {
                this.deleteFight(userid);
            }, (thisPvEFight.fight.summary.rounds.length) * 4000);

            toApi.summary = this.fights[userid].fight.summary;
            if (!canIFightTheMonster) {
                toApi.beingAttacked = true;
            }
        } else {
            // erreur
            if (alreadyInBattle) {
                toApi.error = Translator.getString(lang, "errors", "fight_already_in");
            } else if (timeToFight >= 0) {
                toApi.error = Translator.getString(lang, "errors", "generic_tired", [Math.ceil(timeToFight / 1000)]);
            }

        }

        return toApi;
    }

    deleteFight(userid) {
        if (this.fights[userid] && this.fights[userid].fight.entities[0].length > 1 && Globals.connectedUsers[userid] && Globals.connectedUsers[userid].character.group != null) {
            Globals.connectedUsers[userid].character.group.fightEndBoardcast(this.fights[userid].fight.summary);
            Globals.connectedUsers[userid].character.group.doingSomething = false;
            let fenters = Globals.connectedUsers[userid].character.group.getUsersIDsExceptLeader();
            for (let i of fenters) {
                delete this.fights[i];
            }
        }
        delete this.fights[userid];
    }

    async fightPvP(attackers, defenders, userid, lang) {
        let toApi = {
            beingAttacked: false,
            team1_number: attackers.length,
            team2_number: defenders.length
        }

        let alreadyInBattle = attackers.length > 1 ? this.fightAlreadyInBattle(userid) : this.fights[userid] !== undefined;

        let timeToFight = this.timeToFight(attackers);

        if (timeToFight < 0 && !alreadyInBattle) {

            let pvpFight = {
                fight: new FightPvP(attackers, defenders),
            };
            await pvpFight.fight.init();
            toApi.summary = pvpFight.fight.summary;
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
            }, (pvpFight.fight.summary.rounds.length) * 4000);

        } else {
            // erreur
            if (alreadyInBattle) {
                //console.log("Can't Initialize Fight : Already in battle");
                toApi.error = Translator.getString(lang, "errors", "fight_already_in");
            } else if (timeToFight >= 0) {
                //console.log("Can't Initialize Fight : Have To Wait");
                toApi.error = Translator.getString(lang, "errors", "generic_tired", [Math.ceil(timeToFight / 1000)]);
            }

        }

        return toApi;
    }



}

module.exports = FightManager;