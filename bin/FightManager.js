'use strict';
const Discord = require("discord.js");
const Monstre = require("./Monstre.js");
const ProgressBar = require("./ProgressBar");
const Globals = require("./Globals");
const LootSystem = require("./LootSystem.js");

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


    calMultDiffLevel(lv1, lv2) {
        let diff = lv1 - lv2;
        let mult = 1;
        // Lv 1 est plus faible que 2
        if (diff < 0) {
            mult = mult - 0.25 * -diff;
            return mult < 0 ? 0 : mult;
        } else if (diff > 0) {
            mult = mult + 0.25 * diff;
            return mult < 0 ? 0 : mult;
        }
        return 1;
    }


    // PveFight
    fightPvE(user, message, idEnemy, canIFightTheMonster) {
        let time = Date.now();
        let alreadyInBattle = this.fights[user.id] !== undefined;
        let timeToFight = user.character.canFightAt <= time;
        if (!alreadyInBattle && timeToFight) {
            user.character.updateStats();
            let enemy = new Monstre(idEnemy);
            this.fights[user.id] = {
                user: user,
                enemy: enemy,
                initiative: 0,
                text: ["", "", ""],
            };
            if (!canIFightTheMonster) {
                message.channel.send("Vous n'avez pas été assez discret, un autre monstre vous attaque ! (Il vous faut plus de perception)");
                this.fights[user.id].text[2] = "<:user:403148210295537664> Le joueur " + user.username + " se fait attaquer par un monstre : " + this.fights[user.id].enemy.name + " !\n\n";
            } else {
                this.fights[user.id].text[2] = "<:user:403148210295537664> Le joueur " + user.username + " attaque un monstre : " + this.fights[user.id].enemy.name + " !\n\n";
            }
            //console.log("Fight Initialized");
            
            message.channel.send(this.embedPvE(this.fights[user.id].user, this.fights[user.id].enemy, this.fights[user.id].text[0] + this.fights[user.id].text[1] + this.fights[user.id].text[2]))
                .then(
                msg => this.fightPvEUpdate(msg, user.id));

        } else {
            // erreur
            if (alreadyInBattle) {
                //console.log("Can't Initialize Fight : Already in battle");
                message.reply("Already in Battle : You can't fight");
            } else if (!timeToFight) {
                //console.log("Can't Initialize Fight : Have To Wait");
                message.reply("You are exhausted you have to wait " + Math.ceil((user.character.canFightAt - time) / 1000) + " seconds before you can fight again !");
            }

        }
    }

    fightPvEUpdate(message, userid) {

        // TODO : based on stats and weapons - DONE
        //let damage = Math.floor(Math.random() * Math.floor(26));
        let damage = 0;
        let done = 0;
        let critical = false;
        let stun = false;

        // TOUR DU JOUEUR
        if (this.fights[userid].initiative === 0) {
            damage = this.fights[userid].user.character.damageCalcul();
            damage = damage * this.fights[userid].enemy.damageDefenceReduction();
            damage = damage * this.calMultDiffLevel(this.fights[userid].user.character.getLevel(), this.fights[userid].enemy.getLevel());
            damage = Math.round(damage);

            // Calcul des critiques
            critical = this.fights[userid].user.character.isThisACriticalHit();
            damage = critical === true ? damage * 2 : damage;

            // Calcul du stun si pas critique
            if (!critical) {
                stun = this.fights[userid].user.character.stun(this.fights[userid].enemy.stats.will);
            }


            this.fights[userid].enemy.actualHP -= damage;
            this.fights[userid].enemy.actualHP = this.fights[userid].enemy.actualHP < 0 ? 0 : this.fights[userid].enemy.actualHP;
            this.swapArrayIndexes("<:user:403148210295537664> Le joueur attaque " + this.fights[userid].enemy.name +
                " et lui inflige " + damage + " points de degats " +
                (critical === true ? "(Coup Critique !) " : "") +
                (stun === true ? "(Coup Assomant !) " : "") +
                "\n\n", userid);
        } else {
            // TOUR DU MONSTRE
            damage = this.fights[userid].enemy.damageCalcul();
            damage = damage * this.fights[userid].user.character.damageDefenceReduction();
            damage = damage * this.calMultDiffLevel(this.fights[userid].enemy.getLevel(), this.fights[userid].user.character.getLevel());
            damage = Math.round(damage);

            // Critical
            critical = this.fights[userid].enemy.isThisACriticalHit();
            damage = critical === true ? damage * 2 : damage;

            // Stun
            if (!critical) {
                stun = this.fights[userid].enemy.stun(this.fights[userid].user.character.stats.will + this.fights[userid].user.character.equipement.stats.will);
            }

            this.fights[userid].user.character.actualHP -= damage;
            this.fights[userid].user.character.actualHP = this.fights[userid].user.character.actualHP < 0 ? 0 : this.fights[userid].user.character.actualHP;
            this.swapArrayIndexes("<:monstre:403149357387350016> Le monstre attaque " + this.fights[userid].user.username +
                " et lui inflige " + damage + " points de degats " +
                (critical === true ? "(Coup Critique !) " : "") +
                (stun === true ? "(Coup Assomant !) " : "") +
                "\n\n", userid);
        }

        if (!stun) {
            this.fights[userid].initiative = this.fights[userid].initiative === 0 ? 1 : 0;
        }


        if (this.fights[userid].enemy.actualHP <= 0) {
            this.swapArrayIndexes("<:win:403151177153249281> Vous avez gagné le combat !\n\n", userid);

            // Need this to know if level up
            let actualLevel = this.fights[userid].user.character.getLevel();

            // Ad exp and money
            let xp = 0;
            let money = this.fights[userid].enemy.money * this.fights[userid].enemy.difficulty.value * this.calMultDiffLevel(this.fights[userid].enemy.getLevel(), this.fights[userid].user.character.getLevel());
            money = Math.round(money);
            if (this.fights[userid].user.character.getLevel() < Globals.maxLevel) {
                xp = this.fights[userid].enemy.xp * this.fights[userid].enemy.difficulty.value * this.calMultDiffLevel(this.fights[userid].enemy.getLevel(), this.fights[userid].user.character.getLevel());
                xp = Math.round(xp * (1 + this.fights[userid].user.character.stats["wisdom"] / 2));
                this.fights[userid].user.character.addExp(xp);
            }

            this.fights[userid].user.character.addMoney(money);





            //if level up


            let diffLevel = this.fights[userid].user.character.getLevel() - actualLevel;
            if (diffLevel > 0) {
                let plur = diffLevel > 1 ? "x" : "";
                this.swapArrayIndexes("<:levelup:403456740139728906> Bravo ! Vous avez gagné : " + diffLevel + " niveau" + plur + ". Vous êtes desormais niveau : " + this.fights[userid].user.character.getLevel() + " !\n", userid);
            }

            // Loot or Not
            let loot = this.lootSystem.loot(this.fights[userid].user.character.stats.luck + this.fights[userid].enemy.luckBonus);
            let okLoot = this.lootSystem.isTheLootExistForThisArea(this.fights[userid].user.character.area, loot);
            if (okLoot) {
                this.lootSystem.getLoot(this.fights[userid].user.character, loot, this.fights[userid].enemy.getLevel());
                let rarityName = "";
                switch (loot) {
                    case 1:
                        rarityName = "Commun";
                        break;
                    case 2:
                        rarityName = "Rare";
                        break;
                    case 3:
                        rarityName = "Supérieur";
                        break;
                    case 4:
                        rarityName = "Epique";
                        break;
                    case 5:
                        rarityName = "Légendaire";
                        break;
                }


                this.swapArrayIndexes("<:treasure:403457812535181313> Vous avez gagné un objet (" + rarityName +") ! Bravo !\n\n", userid);
            }

            // Affichage
            if (xp === 0) {
                this.swapArrayIndexes("<:treasure:403457812535181313>  Vous gagnez : " + this.fights[userid].enemy.money + " Argent\n", userid);
            } else if (money === 0) {
                this.swapArrayIndexes("<:treasure:403457812535181313>  Vous gagnez : " + xp + " XP\n", userid);
            } else if (xp === 0 && money === 0) {
                this.swapArrayIndexes("<:treasure:403457812535181313>  Vous ne gagnez rien !\n", userid);
            } else {
                this.swapArrayIndexes("<:treasure:403457812535181313>  Vous gagnez : " + xp + " XP et " + this.fights[userid].enemy.money + " Argent\n", userid);
            }
            

            done = true;
        } else if (this.fights[userid].user.character.actualHP <= 0) {
            this.swapArrayIndexes("<:loose:403153660756099073> Vous avez perdu le combat !\n", userid);
            done = true;
        } else {
            setTimeout(() => {
                this.fightPvEUpdate(message, userid);
            }, 2000);
        }

        message.edit(this.embedPvE(this.fights[userid].user, this.fights[userid].enemy, this.fights[userid].text[0] + this.fights[userid].text[1] + this.fights[userid].text[2]));

        if (done) {
            this.fights[userid].user.character.actualHP = this.fights[userid].user.character.maxHP;
            this.fights[userid].user.character.waitForNextFight();
            delete this.fights[userid];
        }

    }

    embedPvE(character1, monster, text) {
        let healthBar = new ProgressBar();
        let first = healthBar.draw(character1.character.actualHP, character1.character.maxHP);
        let second = healthBar.draw(monster.actualHP, monster.maxHP);
        let monsterTitle = "";
        if (monster.type == "Normal") {
            monsterTitle = monster.difficulty.name + " ";
        } else {
            monsterTitle = "<:elite:406090076511141888>";
        }


        let embed = new Discord.RichEmbed()
            .setColor([255, 0, 0])
            .addField("Combat Log", text)
            .addField(character1.username + " | Lv : " + character1.character.getLevel(), character1.character.actualHP + "/" + character1.character.maxHP + "\n" + first, true)
            .addField(monsterTitle + monster.name + " | Lv : " + monster.getLevel(), monster.actualHP + "/" + monster.maxHP + "\n" + second, true);
        return embed;
    }

    // PvP Fight
    fightPvP(attacker, defender, message) {
        let time = Date.now();
        let alreadyInBattle = this.fights[attacker.id] !== undefined;
        let timeToFight = attacker.character.canFightAt <= time;
        if (!alreadyInBattle && timeToFight) {
            if (attacker.character.area == defender.character.area) {
                attacker.character.updateStats();
                defender.character.updateStats();
                let init = (attacker.character.stats.intellect + attacker.character.equipement.stats.intellect) <= (defender.character.stats.intellect + defender.character.equipement.stats.intellect);
                init = init ? 1 : 0;
                // Utilisation de "defenderHp" et "attackerHp"
                // Puisqu'on le defender peut être entrain de combattre un montre
                // Et l'attacker peut se faire attaquer par un autre joueur en même temps
                this.fights[attacker.id] = {
                    attacker: attacker,
                    defender: defender,
                    defenderHP: defender.character.maxHP,
                    attackerHP: attacker.character.maxHP,
                    initiative: init,
                    text: ["", "", ""]
                }

                //console.log("PvP Fight Initialized");

                this.fights[attacker.id].text[2] = "<:sword:403574088389361666> Le joueur " + attacker.username + " attaque un autre joueur : " + defender.username + " !\n\n";
                message.channel.send(this.embedPvP(attacker, defender, this.fights[attacker.id].text[0] + this.fights[attacker.id].text[1] + this.fights[attacker.id].text[2]))
                    .then(
                    msg => this.fightPvPUpdate(msg, attacker.id)
                    );
            } else {
                message.reply("Vous devez être dans la même zone que votre adversaire !");
            }

        } else {
            // erreur
            if (alreadyInBattle) {
                //console.log("Can't Initialize PvP Fight : Already in battle");
                message.reply("Vous combattez déjà, finissez votre combat avant d'en commencer un autre !");
            } else if (!timeToFight) {
                //console.log("Can't Initialize Fight : Have To Wait");
                message.reply("Vous êtes fatigué attendez : " + Math.round((attacker.character.canFightAt - time) / 1000) + " secondes puis recommencez !");
            }

        }
    }

    fightPvPUpdate(message, userid) {

        // TODO : based on stats and weapons
        //let damage = Math.floor(Math.random() * Math.floor(26));
        let damage = 0;
        let done = 0;
        let critical = false;
        let stun = false;

        // Celui qui attaque
        if (this.fights[userid].initiative === 0) {
            damage = this.fights[userid].attacker.character.damageCalcul();
            damage = damage * this.fights[userid].defender.character.damageDefenceReduction();
            damage = damage * this.calMultDiffLevel(this.fights[userid].attacker.character.getLevel(), this.fights[userid].defender.character.getLevel());
            damage = Math.round(damage);

            // Critical hit
            critical = this.fights[userid].attacker.character.isThisACriticalHit();
            damage = critical === true ? damage * 2 : damage;

            // Calcul du stun si pas critique
            if (!critical) {
                stun = this.fights[userid].attacker.character.stun(this.fights[userid].defender.character.stats.will + this.fights[userid].defender.character.equipement.stats.will);
            }

            this.fights[userid].defenderHP -= damage;
            this.fights[userid].defenderHP = this.fights[userid].defenderHP < 0 ? 0 : this.fights[userid].defenderHP;
            this.swapArrayIndexes("<:sword:403574088389361666> Le joueur " + this.fights[userid].attacker.username +
                " attaque " + this.fights[userid].defender.username +
                " et lui inflige " + damage + " points de degats " +
                (critical === true ? "(Coup Critique !) " : "") +
                (stun === true ? "(Coup Assomant !) " : "") +
                "\n\n", userid);
        } else {
            // Celui qui défend
            damage = this.fights[userid].defender.character.damageCalcul();
            damage = damage * this.fights[userid].attacker.character.damageDefenceReduction();
            damage = damage * this.calMultDiffLevel(this.fights[userid].defender.character.getLevel(), this.fights[userid].attacker.character.getLevel());
            damage = Math.round(damage);

            // Critical hit
            critical = this.fights[userid].defender.character.isThisACriticalHit();
            damage = critical === true ? damage * 2 : damage;

            // Calcul du stun si pas critique
            if (!critical) {
                stun = this.fights[userid].defender.character.stun(this.fights[userid].attacker.character.stats.will + this.fights[userid].attacker.character.equipement.stats.will);
            }


            this.fights[userid].attackerHP -= damage;
            this.fights[userid].attackerHP = this.fights[userid].attackerHP < 0 ? 0 : this.fights[userid].attackerHP;
            this.swapArrayIndexes("<:shieldd:403574099143819276> Le joueur " + this.fights[userid].defender.username +
                " attaque " + this.fights[userid].attacker.username +
                " et lui inflige " + damage + " points de degats " +
                (critical === true ? "(Coup Critique !) " : "") +
                (stun === true ? "(Coup Assomant !) " : "") +
                "\n\n", userid);
        }

        if (!stun) {
            this.fights[userid].initiative = this.fights[userid].initiative === 0 ? 1 : 0;
        }
        
        let honor = 0;
        // Si l'attaquant gagne
        if (this.fights[userid].defenderHP <= 0) {


            if (this.fights[userid].attacker.character.honorPoints === this.fights[userid].defender.honorPoints) {
                honor = 10;
            } else if (this.fights[userid].attacker.character.honorPoints > this.fights[userid].defender.honorPoints) {
                honor = Math.round((this.fights[userid].attacker.character.honorPoints - this.fights[userid].defender.character.honorPoints) * .2);
                honor = honor >= 0 ? honor : 0;
            } else {
                honor = Math.round((this.fights[userid].defender.character.honorPoints - this.fights[userid].attacker.character.honorPoints) * .2);
                honor += 10;
            }

            this.fights[userid].attacker.character.addHonorPoints(honor);
            this.fights[userid].defender.character.removeHonorPoints(honor);
            // Affichage
            this.swapArrayIndexes("<:win:403151177153249281> Vous avez gagné le combat !\n\n", userid);
            this.swapArrayIndexes("<:honor:403824433837637632> Vous gagnez : " + honor + " d'honneur !\n", userid);

            done = true;
        } else if (this.fights[userid].attackerHP <= 0) {
            if (this.fights[userid].attacker.character.honorPoints === this.fights[userid].defender.honorPoints) {
                honor = 10;
            } else if (this.fights[userid].defender.honorPoints > this.fights[userid].attacker.character.honorPoints ) {
                honor = Math.round((this.fights[userid].defender.character.honorPoints - this.fights[userid].attacker.character.honorPoints) * .2);
                honor = honor >= 0 ? honor : 0;
            } else {
                honor = Math.round((this.fights[userid].attacker.character.honorPoints - this.fights[userid].defender.character.honorPoints) * .2);
                honor += 10;
            }

            this.fights[userid].defender.character.addHonorPoints(honor);
            this.fights[userid].attacker.character.removeHonorPoints(honor);


            this.swapArrayIndexes("<:loose:403153660756099073> Vous avez perdu le combat !\n", userid);
            this.swapArrayIndexes("<:honor:403824433837637632> Vous avez perdu : " + honor + " d'honneur !\n", userid);
            done = true;
        } else {
            setTimeout(() => {
                this.fightPvPUpdate(message, userid);
            }, 2000);
        }

        message.edit(this.embedPvP(this.fights[userid].attacker, this.fights[userid].defender, this.fights[userid].text[0] + this.fights[userid].text[1] + this.fights[userid].text[2]));

        if (done) {
            this.fights[userid].attacker.character.waitForNextFight();
            delete this.fights[userid];
        }

    }

    embedPvP(attacker, defender, text) {
        let healthBar = new ProgressBar();
        let attackerHealth = healthBar.draw(this.fights[attacker.id].attackerHP, attacker.character.maxHP);
        let defenderHealth = healthBar.draw(this.fights[attacker.id].defenderHP, defender.character.maxHP);

        let embed = new Discord.RichEmbed()
            .setColor([255, 0, 0])
            .addField("Combat Log", text)
            .addField(attacker.username + " | Lv : " + attacker.character.getLevel(), this.fights[attacker.id].attackerHP + "/" + attacker.character.maxHP + "\n" + attackerHealth, true)
            .addField(defender.username + " | Lv : " + defender.character.getLevel(), this.fights[attacker.id].defenderHP + "/" + defender.character.maxHP + "\n" + defenderHealth, true);
        return embed;
    }




}

module.exports = FightManager;
