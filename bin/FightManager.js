'use strict';
const Discord = require("discord.js");
const Monstre = require("./Monstre.js");
const ProgressBar = require("./ProgressBar");
const Globals = require("./Globals");
const LootSystem = require("./LootSystem.js");
const FightPvE = require("./Fight/FightPvE");
const FightPvP = require("./Fight/FightPvP");
const Translator = require("./Translator/Translator");
const Monster = require("./Monstre");

class FightManager {
    constructor() {
        this.fights = {};
        this.lootSystem = new LootSystem();
    }

    // Helper
    swapArrayIndexes(text, userid) {
        this.fights[userid].text[0] = this.fights[userid].text[1];
        this.fights[userid].text[1] = this.fights[userid].text[2];
        this.fights[userid].text[2] = text;
    }

    // PveFight

    timeToFight(users) {
        let date = Date.now();
        for (let i in users) {
            if (users[i].canFightAt > date) {
                return users[i].canFightAt - date;
            }
        }
        return -1;
    }

    loadMonsters(monsters) {
        let arr = [];
        for (let i in monsters) {
            for (let j = 0; j < monsters[i].number; j++) {
                arr.push(new Monstre(monsters[i].id));
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

    fightPvE(users, monsters, message, canIFightTheMonster, lang) {
        let userid = message.author.id;
        let alreadyInBattle = users.length > 1 ? this.fightAlreadyInBattle(userid) : this.fights[userid] !== undefined;
        let timeToFight = this.timeToFight(users);
        if (timeToFight < 0 && !alreadyInBattle) {
            let enemies = this.loadMonsters(monsters);

            this.fights[message.author.id] = {
                text: ["", "", ""],
                fight: new FightPvE(users, enemies, lang),
                leftName: users.length > 1 ? "Players" : users[0].name,
                rightName: enemies.length > 1 ? "Monsters" : enemies[0].getName(lang),
                summaryIndex: 0,
            };
            if (users.length > 1 && Globals.connectedUsers[userid] != null && Globals.connectedUsers[userid].character.group != null) {
                Globals.connectedUsers[userid].character.group.doingSomething = true;
                let fenters = Globals.connectedUsers[userid].character.group.getUsersIDsExceptLeader();
                for (let i of fenters) {
                    this.fights[i] = this.fights[message.author.id];
                }
            }
            if (!canIFightTheMonster) {
                message.channel.send(Translator.getString(lang, "fight_pve", "ganked_by_monster")).catch((e) => message.author.send(e.message));
                this.fights[userid].text[2] = "<:user:403148210295537664> " + Translator.getString(lang, "fight_pve", "user_get_attacked", [users[0].name, enemies[0].getName(lang)]) + "\n\n";
            } else {
                this.fights[userid].text[2] = "<:user:403148210295537664> " + Translator.getString(lang, "fight_pve", "user_attacked", [users[0].name, enemies[0].getName(lang)]) + "\n\n";
            }
            //console.log("Fight Initialized");
            message.channel.send(this.embedPvE(message.author.id, this.fights[userid].text[0] + this.fights[userid].text[1] + this.fights[userid].text[2], null, lang))
                .then(msg => this.discordFightPvE(msg, userid, lang)).catch(e => message.author.send(e.message));

        } else {
            // erreur
            if (alreadyInBattle) {
                //console.log("Can't Initialize Fight : Already in battle");
                message.channel.send(Translator.getString(lang, "errors", "fight_already_in")).catch(e => message.author.send(e.message));
            } else if (timeToFight >= 0) {
                //console.log("Can't Initialize Fight : Have To Wait");
                message.channel.send(Translator.getString(lang, "errors", "generic_tired", [Math.ceil(timeToFight / 1000)])).catch(e => message.author.send(e.message));
            }

        }
    }

    _apiFightPvE(users, monsters, userid, canIFightTheMonster) {
        let toApi = {
            beingAttacked: false,
        }
        let time = Date.now();
        let alreadyInBattle = this.fights[userid] !== undefined;
        let timeToFight = this.timeToFight(users);
        if (timeToFight < 0 && !alreadyInBattle) {
            let enemies = this.loadMonsters(monsters);
            this.fights[userid] = {
                fight: new FightPvE(users, enemies),
            };
            toApi.summary = this.fights[userid].fight.summary;
            if (!canIFightTheMonster) {
                toApi.beingAttacked = true;
            }

            setTimeout(() => {
                this.deleteFight(userid);
            }, this.fights[userid].fight.summary.rounds.length * 2001);
            

        } else {
            // erreur
            if (alreadyInBattle) {
                //console.log("Can't Initialize Fight : Already in battle");
                toApi.error = "Already in Battle : You can't fight";
            } else if (timeToFight >= 0) {
                //console.log("Can't Initialize Fight : Have To Wait");
                toApi.error = "You are exhausted you have to wait " + Math.ceil(timeToFight / 1000) + " seconds before you can fight again!";
            }

        }

        return toApi;
    }

    discordFightPvE(message, userid, lang) {
        let ind = this.fights[userid].summaryIndex;
        let summary = this.fights[userid].fight.summary;
        if (ind < summary.rounds.length) {

            if (summary.rounds[ind].roundType == "Character") {
                this.swapArrayIndexes("<:user:403148210295537664> " + Translator.getString(lang, "fight_pve", "onfight_user_attack", [summary.rounds[ind].attackerName, Monster.getName(summary.rounds[ind].defenderId, lang), summary.rounds[ind].damage]) +
                    (summary.rounds[ind].critical === true ? " (" + Translator.getString(lang, "fight_general", "critical_hit") + " !) " : "") +
                    (summary.rounds[ind].stun === true ? " (" + Translator.getString(lang, "fight_general", "stun_hit") + " !) " : "") +
                    "\n\n", userid);
            } else if (summary.rounds[ind].roundType == "Monster") {
                this.swapArrayIndexes("<:monstre:403149357387350016> " + Translator.getString(lang, "fight_pve", "onfight_monster_attack", [Monster.getName(summary.rounds[ind].attackerId, lang), summary.rounds[ind].defenderName, summary.rounds[ind].damage]) +
                    (summary.rounds[ind].critical === true ? " (" + Translator.getString(lang, "fight_general", "critical_hit") + " !) " : "") +
                    (summary.rounds[ind].stun === true ? " (" + Translator.getString(lang, "fight_general", "stun_hit") + " !) " : "") +
                    "\n\n", userid);
            }



            message.edit(this.embedPvE(userid, this.fights[userid].text[0] + this.fights[userid].text[1] + this.fights[userid].text[2], null, lang))
                .then(() => {
                    this.fights[userid].summaryIndex++;
                    setTimeout(() => {
                        this.discordFightPvE(message, userid, lang);
                    }, 2000);
                })
                .catch(() => {
                    setTimeout(() => {
                        this.deleteFight(userid)
                    }, (summary.rounds.length - ind) * 2000);
                });


        } else {
            if (summary.winner == 0) {
                this.swapArrayIndexes("<:win:403151177153249281> " + Translator.getString(lang, "fight_general", "win") + "\n\n", userid);

                if (this.fights[userid].fight.entities[0].length == 1) {
                    if (summary.drops.length > 0) {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "drop_item", [Translator.getString(lang, "rarities", summary.drops[0].drop)]) + "\n\n", userid);
                    }
                    if (summary.levelUpped.length > 0) {
                        this.swapArrayIndexes("<:levelup:403456740139728906>  " + Translator.getString(lang, "fight_pve", "level_up", [summary.levelUpped[0].levelGained, summary.levelUpped[0].newLevel]) + "\n", userid);
                    }

                    if (summary.xp === 0) {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "money_gain", [summary.money]) + "\n", userid);
                    } else if (summary.money === 0) {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "xp_gain", [summary.xp]) + "\n", userid);
                    } else if (summary.xp === 0 && summary.money === 0) {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "nothing_gain", [summary.xp]) + "\n", userid);
                    } else {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "both_gain", [summary.xp, summary.money]) + "\n", userid);
                    }

                } else {
                    // TODO For more people participating
                    //this.swapArrayIndexes("<:treasure:403457812535181313> Vous avez gagné un objet (" + rarityName + ") ! Bravo !\n\n", userid);
                    if (summary.drops.length > 0) {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "group_drop_item") + "\n\n", userid);
                    }
                    if (summary.levelUpped.length > 0) {
                        this.swapArrayIndexes("<:levelup:403456740139728906>  " + Translator.getString(lang, "fight_pve", "group_level_up") + "\n", userid);
                    }

                    if (summary.xp === 0) {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "group_money_gain", [summary.money]) + "\n", userid);
                    } else if (summary.money === 0) {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "group_xp_gain", [summary.xp]) + "\n", userid);
                    } else if (summary.xp === 0 && summary.money === 0) {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "group_nothing_gain", [summary.xp]) + "\n", userid);
                    } else {
                        this.swapArrayIndexes("<:treasure:403457812535181313>  " + Translator.getString(lang, "fight_pve", "group_both_gain", [summary.xp, summary.money]) + "\n", userid);
                    }

                }
            } else {
                this.swapArrayIndexes("<:loose:403153660756099073> " + Translator.getString(lang, "fight_general", "loose") + "\n", userid);
            }


            // Color settings
            let color;
            if (summary.winner == 0) {
                color = [0, 255, 0];
            } else {
                color = [255, 0, 0];
            }

            message.edit(this.embedPvE(userid, this.fights[userid].text[0] + this.fights[userid].text[1] + this.fights[userid].text[2], color, lang)).then(this.deleteFight(userid)).catch(() => {this.deleteFight(userid)});

        }


        
    }

    deleteFight(userid) {
        if (this.fights[userid] && this.fights[userid].fight.entities[0].length > 1 && Globals.connectedUsers[userid] && Globals.connectedUsers[userid].character.group != null) {
            Globals.connectedUsers[userid].character.group.fightEndBoardcast(Globals.discordClient, this.fights[userid].fight.summary);
            Globals.connectedUsers[userid].character.group.doingSomething = false;
            let fenters = Globals.connectedUsers[userid].character.group.getUsersIDsExceptLeader();
            for (let i of fenters) {
                delete this.fights[i];
            }
        }
        delete this.fights[userid];
    }

    discordFightPvP(message, userid, lang) {
        let ind = this.fights[userid].summaryIndex;
        let summary = this.fights[userid].fight.summary;
        if (ind < summary.rounds.length) {
            this.swapArrayIndexes("<:user:403148210295537664> " + Translator.getString(lang, "fight_pvp", "onfight_user_attack", [summary.rounds[ind].attackerName, summary.rounds    [ind].defenderName, summary.rounds[ind].damage]) +
                (summary.rounds[ind].critical === true ? " (" + Translator.getString(lang, "fight_general", "critical_hit") + " !) " : "") +
                (summary.rounds[ind].stun === true ? " (" + Translator.getString(lang, "fight_general", "stun_hit") + " !) " : "") +
                "\n\n", userid);

            message.edit(this.embedPvP(userid, this.fights[userid].text[0] + this.fights[userid].text[1] + this.fights[userid].text[2], null, lang))
                .then(() => {
                    this.fights[userid].summaryIndex++;
                    setTimeout(() => {
                        this.discordFightPvP(message, userid, lang);
                    }, 2000);
                })
                .catch(() => {
                    setTimeout(() => {
                        this.deleteFight(userid)
                    }, (summary.rounds.length - ind) * 2000);
                });


        } else {
            if (summary.winner == 0) {
                this.swapArrayIndexes("<:win:403151177153249281> " + Translator.getString(lang, "fight_general", "win") + "\n\n", userid);
                if (this.fights[userid].fight.entities[0].length == 1) {   
                    if(summary.honor > 0) {                        
                        this.swapArrayIndexes("<:honor:403824433837637632> " + Translator.getString(lang, "fight_pvp", "honor_gain", [summary.honor]) + "\n", userid);
                    } else {
                        this.swapArrayIndexes("<:honor:403824433837637632> " + Translator.getString(lang, "fight_pvp", "honor_not_honorable", [-summary.honor]) + "\n", userid);
                    }
                }
            } else {
                this.swapArrayIndexes("<:loose:403153660756099073> " + Translator.getString(lang, "fight_general", "loose") + "\n", userid);
                if (this.fights[userid].fight.entities[0].length == 1) {    
                    if(summary.honor > 0) {
                        this.swapArrayIndexes("<:honor:403824433837637632> " + Translator.getString(lang, "fight_pvp", "honor_lose", [summary.honor]) + "\n", userid);
                    }
                }
            }


            // Color settings
            let color;
            if (summary.winner == 0) {
                color = [0, 255, 0];
            } else {
                color = [255, 0, 0];
            }

            message.edit(this.embedPvP(userid, this.fights[userid].text[0] + this.fights[userid].text[1] + this.fights[userid].text[2], color, lang)).then(this.deleteFight(userid)).catch(() => {this.deleteFight(userid)});

        }


        
    }

    embedPvE(userid, text, color, lang) {
        color = color || [128, 128, 128]
        lang = lang || "en"
        let healthBar = new ProgressBar();
        let ind = this.fights[userid].summaryIndex;
        let summary = this.fights[userid].fight.summary;
        let monsterTitle = "";
        let first, second, firstName, secondName, firstLevel, secondLevel, firstActualHP, secondActualHP, firstMaxHP, secondMaxHP;

        ind = this.fights[userid].summaryIndex < summary.rounds.length ? ind : ind - 1;

        if (summary.rounds[ind].roundEntitiesIndex == 0) {
            first = healthBar.draw(summary.rounds[ind].attackerHP, summary.rounds[ind].attackerMaxHP);
            firstName = summary.rounds[ind].attackerName;
            firstLevel = summary.rounds[ind].attackerLevel;
            firstActualHP = summary.rounds[ind].attackerHP;
            firstMaxHP = summary.rounds[ind].attackerMaxHP;

            second = healthBar.draw(summary.rounds[ind].defenderHP, summary.rounds[ind].defenderMaxHP);
            secondName = Monster.getName(summary.rounds[ind].defenderId, lang);
            secondLevel = summary.rounds[ind].defenderLevel;
            secondActualHP = summary.rounds[ind].defenderHP;
            secondMaxHP = summary.rounds[ind].defenderMaxHP;

        } else {
            first = healthBar.draw(summary.rounds[ind].defenderHP, summary.rounds[ind].defenderMaxHP);
            firstName = summary.rounds[ind].defenderName;
            firstLevel = summary.rounds[ind].defenderLevel;
            firstActualHP = summary.rounds[ind].defenderHP;
            firstMaxHP = summary.rounds[ind].defenderMaxHP;

            second = healthBar.draw(summary.rounds[ind].attackerHP, summary.rounds[ind].attackerMaxHP);
            secondName = Monster.getName(summary.rounds[ind].attackerId, lang);
            secondLevel = summary.rounds[ind].attackerLevel;
            secondActualHP = summary.rounds[ind].attackerHP;
            secondMaxHP = summary.rounds[ind].attackerMaxHP;
        }


        if (summary.rounds[ind].monsterType == "elite") {
            monsterTitle = "<:elite:406090076511141888>";
        } else if (summary.rounds[ind].monsterType == "boss") {
            monsterTitle = "<:boss:456113364687388683>";
        } else {
            monsterTitle = summary.rounds[ind].monsterDifficultyName + " ";
        }


        let embed = new Discord.RichEmbed()
            .setColor(color)
            .addField(Translator.getString(lang, "fight_general", "combat_log"), text)
            .addField(firstName + " | " + Translator.getString(lang, "general", "lvl") + " : " + firstLevel, firstActualHP + "/" + firstMaxHP + "\n" + first, true)
            .addField(monsterTitle + secondName + " | " + Translator.getString(lang, "general", "lvl") + " : " + secondLevel, secondActualHP + "/" + secondMaxHP + "\n" + second, true);
        return embed;
    }

    embedPvP(userid, text, color, lang) {
        color = color || [128, 128, 128]
        lang = lang || "en"
        let healthBar = new ProgressBar();
        let ind = this.fights[userid].summaryIndex;
        let summary = this.fights[userid].fight.summary;
        let first, second, firstName, secondName, firstLevel, secondLevel, firstActualHP, secondActualHP, firstMaxHP, secondMaxHP;

        ind = this.fights[userid].summaryIndex < summary.rounds.length ? ind : ind - 1;

        if (summary.rounds[ind].roundEntitiesIndex == 0) {
            first = healthBar.draw(summary.rounds[ind].attackerHP, summary.rounds[ind].attackerMaxHP);
            firstName = summary.rounds[ind].attackerName;
            firstLevel = summary.rounds[ind].attackerLevel;
            firstActualHP = summary.rounds[ind].attackerHP;
            firstMaxHP = summary.rounds[ind].attackerMaxHP;

            second = healthBar.draw(summary.rounds[ind].defenderHP, summary.rounds[ind].defenderMaxHP);
            secondName = summary.rounds[ind].defenderName;
            secondLevel = summary.rounds[ind].defenderLevel;
            secondActualHP = summary.rounds[ind].defenderHP;
            secondMaxHP = summary.rounds[ind].defenderMaxHP;

        } else {
            first = healthBar.draw(summary.rounds[ind].defenderHP, summary.rounds[ind].defenderMaxHP);
            firstName = summary.rounds[ind].defenderName;
            firstLevel = summary.rounds[ind].defenderLevel;
            firstActualHP = summary.rounds[ind].defenderHP;
            firstMaxHP = summary.rounds[ind].defenderMaxHP;

            second = healthBar.draw(summary.rounds[ind].attackerHP, summary.rounds[ind].attackerMaxHP);
            secondName = summary.rounds[ind].attackerName;
            secondLevel = summary.rounds[ind].attackerLevel;
            secondActualHP = summary.rounds[ind].attackerHP;
            secondMaxHP = summary.rounds[ind].attackerMaxHP;
        }


        let embed = new Discord.RichEmbed()
            .setColor(color)
            .addField(Translator.getString(lang, "fight_general", "combat_log"), text)
            .addField(firstName + " | " + Translator.getString(lang, "general", "lvl") + " : " + firstLevel, firstActualHP + "/" + firstMaxHP + "\n" + first, true)
            .addField(secondName + " | " + Translator.getString(lang, "general", "lvl") + " : " + secondLevel, secondActualHP + "/" + secondMaxHP + "\n" + second, true);
        return embed;
    }

    fightPvP(attackers, defenders, message, lang) {
        let userid = message.author.id;
        let alreadyInBattle = attackers.length > 1 ? this.fightAlreadyInBattle(userid) : this.fights[userid] !== undefined;

        let timeToFight = this.timeToFight(attackers);

        if (timeToFight < 0 && !alreadyInBattle) {

            this.fights[message.author.id] = {
                text: ["", "", ""],
                fight: new FightPvP(attackers, defenders),
                leftName: attackers.length > 1 ? "Team 1" : attackers[0].name,
                rightName: defenders.length > 1 ? "Team 2" : defenders[0].name,
                summaryIndex: 0,
            };
            if (attackers.length > 1 && Globals.connectedUsers[userid] != null && Globals.connectedUsers[userid].character.group != null) {
                Globals.connectedUsers[userid].character.group.doingSomething = true;
                let fenters = Globals.connectedUsers[userid].character.group.getUsersIDsExceptLeader();
                for (let i of fenters) {
                    this.fights[i] = this.fights[message.author.id];
                }
            }
            if (attackers.length == 1) {
                this.fights[userid].text[2] = "<:sword:403148210295537664> " + Translator.getString(lang, "fight_pve", "user_attacked", [attackers[0].name, defenders[0].name]) + "\n\n";
            }
            //console.log("Fight Initialized");
            message.channel.send(this.embedPvP(message.author.id, this.fights[userid].text[0] + this.fights[userid].text[1] + this.fights[userid].text[2], null, lang))
                .then(msg => this.discordFightPvP(msg, userid, lang)).catch(e => message.author.send(e.message));

        } else {
            // erreur
            if (alreadyInBattle) {
                //console.log("Can't Initialize Fight : Already in battle");
                message.channel.send(Translator.getString(lang, "errors", "fight_already_in")).catch(e => message.author.send(e.message));
            } else if (timeToFight >= 0) {
                //console.log("Can't Initialize Fight : Have To Wait");
                message.channel.send(Translator.getString(lang, "errors", "generic_tired", [Math.ceil(timeToFight / 1000)])).catch(e => message.author.send(e.message));
            }

        }
    }



}

module.exports = FightManager;
