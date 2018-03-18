'use strict';
const Discord = require("discord.js");
const User = require("./User.js");
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const LootSystem = require("./LootSystem.js");
const AreasManager = require("./Areas/AreasManager.js");
const sizeof = require('object-sizeof');
const Leaderboard = require("./Leaderboard.js");
const Guild = require("./Guild.js");

class Commandes {
    constructor(prefix) {
        this.prefix = prefix != undefined ? prefix : "::";
        this.authorizedAttributes = ["force", "intelligence", "constitution", "dexterite", "intelligence", "charisme", "volonte", "luck", "sagesse"];
        this.areasManager = new AreasManager();
        //this.regex = this.prefix + "[a-zA-Z]+";
    }

    updateConnectedUsers() {
        for (let user in this.connectedUsers) {
            this.connectedUsers[user].saveUser();
        }
    }

    reactTo(message) {
        let messageArray = message.content.split(" ");
        let command = messageArray[0].split(this.prefix)[1];
        let tLootSystem = new LootSystem();
        let uIDGuild;
        let tGuildId = 0;
        let firstMention;
        let err = [];
        let apPage;

        if (command !== undefined && !message.author.bot) {
            if (Globals.activated === false && Globals.admins.indexOf(message.author.id) === -1) {
                return;
            }

            // Message author id local variable
            let authorIdentifier = message.author.id;
            let mentions = message.mentions.users;
            let msg = "";
            // Init connection
            if (!this.connectedUsers[authorIdentifier]) {
                // Load User
                this.connectedUsers[authorIdentifier] = new User(authorIdentifier, message.author.username);
                this.connectedUsers[authorIdentifier].loadUser();
                 
                this.connectedUsers[authorIdentifier].avatar = message.author.avatarURL;
                this.nbrConnectedUsers++;

                this.bot.user.setPresence({
                    game: {
                        name: this.nbrConnectedUsers + " joueurs connectés !",
                    },
                });
                console.log(sizeof(this.connectedUsers));

                // Load Guild
                if (this.connectedUsers[authorIdentifier].character.isInGuild()) {
                    if (!this.connectedGuilds[this.connectedUsers[authorIdentifier].character.idGuild]) {
                        this.connectedGuilds[this.connectedUsers[authorIdentifier].character.idGuild] = new Guild();
                        this.connectedGuilds[this.connectedUsers[authorIdentifier].character.idGuild].loadGuild(this.connectedUsers[authorIdentifier].character.idGuild);
                    }
                }
                

            }

            // Detect Commands
            switch (command) {
                /*
                *   CONQUEST
                */

                case "claim":
                    if (this.connectedUsers[authorIdentifier].character.isInGuild()) {
                        err = this.areasManager.claim(this.connectedUsers[authorIdentifier].character.area, this.connectedUsers[authorIdentifier].character.idGuild)
                    } else {
                        err.push("Vous devez être dans uen guilde.");
                    }

                    if (err[0]) {
                        msg = err[0];
                    } else {
                        msg = "Vous avez claim cette zone.";
                    }

                    message.channel.send(msg);
                    break;

                /*
                *   GUILDS
                */

                case "guild":
                    if (this.connectedUsers[authorIdentifier].character.isInGuild()) {
                        msg = this.connectedGuilds[this.connectedUsers[authorIdentifier].character.idGuild].toStr();
                    } else {
                        msg = "Vous n'avez pas de guilde.";
                    }
                    message.channel.send(msg);
                    break;

                case "gcreate":
                    if (messageArray[1]) {
                        // Si le joueur n'a pas de guilde
                        if (this.connectedUsers[authorIdentifier].character.idGuild == 0) {
                            if (this.connectedUsers[authorIdentifier].character.doIHaveEnoughMoney(Globals.guilds.basePriceLevel)) {
                                let tGuild = new Guild();
                                let err = tGuild.createGuild(messageArray[1], this.connectedUsers[authorIdentifier].character.id);
                                if (err.length == 0) {
                                    this.connectedGuilds[tGuild.id] = tGuild;
                                    this.connectedUsers[authorIdentifier].character.idGuild = tGuild.id;

                                    // Static delete
                                    Guild.deleteUsersAppliances(this.connectedUsers[authorIdentifier].character.id);

                                    this.connectedUsers[authorIdentifier].character.removeMoney(Globals.guilds.basePriceLevel);

                                    msg = "La guilde : " + tGuild.name + " à bien été créée !";
                                } else {
                                    msg = err[0];
                                }
                            } else {
                                msg = "Vous n'avez pas suffisamment d'argent pour créer une guilde (Il vous faut : " + Globals.guilds.basePriceLevel + "G).";
                            }

                        } else {
                            msg = "Vous êtes déjà dans une guilde !";
                        }
                    } else {
                        msg = "Vous devez choisir le nom de votre guilde.";
                    }
                    message.reply(msg);
                    break;

                case "gdisband":
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    console.log(this.connectedGuilds);
                    if (tGuildId > 0
                        && this.connectedGuilds[tGuildId].members[this.connectedUsers[authorIdentifier].character.id].rank === 3) {
                        this.areasManager.unclaimAll(tGuildId);
                        this.connectedGuilds[tGuildId].disband(this.connectedUsers);
                        delete this.connectedGuilds[tGuildId];
                        msg = "Vous avez bien dissous la guilde !";
                        console.log(this.connectedGuilds);
                    } else {
                        msg = "Vous devez être chef de guilde pour pouvoir la disband.";
                    }
                    message.channel.send(msg);
                    break;
                

                case "gapply":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (Number.isInteger(messageArray[1])) {
                        if (tGuildId == 0) {
                            err = Guild.applyTo(messageArray[1], this.connectedUsers[authorIdentifier].character.id);
                            if (err.length > 0) {
                                msg = err[0];
                            } else {
                                msg = "Vous avez postulé pour rejoindre la guilde.";
                            }
                        } else {
                            msg = "Vous ne devez pas être dans une guilde pour demander à en rejoindre une.";
                        }
                    } else {
                        msg = "Vous devez entrer l'identifiant de la guilde que vous voulez rejoindre.";
                    }

                    message.reply(msg);

                    break;

                case "gaccept":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;

                    if (Number.isInteger(messageArray[1])) {
                        if (Guild.haveAlreadyApplied(tGuildId, messageArray[1])) {
                            err = this.connectedGuilds[tGuildId].addMember(this.connectedUsers[authorIdentifier].character.id, messageArray[1]);
                            if (err.length > 0) {
                                msg = err[0];
                            } else {
                                msg = "Le personnage à bien été accepté dans la guilde.";
                                uIDGuild = this.connectedGuilds[tGuildId].getIdUserByIdCharacter(messageArray[1]);
                                Guild.deleteUsersAppliances(messageArray[1]);
                                if (this.connectedUsers[uIDGuild]) {
                                    this.connectedUsers[uIDGuild].character.idGuild = tGuildId;
                                }
                            }
                        } else {
                            msg = "Ce personnage n'a pas demandé à rejoindre votre guilde.";
                        }
                    } else {
                        msg = "Vous devez entrer l'identifiant du personnage à ajouté.";
                    }
                    message.reply(msg);
                    break;

                case "gapplies":
                    apPage = parseInt(messageArray[1], 10);
                    if (!apPage || !Number.isInteger(apPage)) {
                        apPage = 1;
                    }
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (tGuildId > 0) {
                        msg = this.connectedGuilds[tGuildId].getGuildAppliances(apPage);
                    } else {
                        msg = Guild.getAppliances(this.connectedUsers[authorIdentifier].character.id);
                    }
                    message.channel.send(msg);
                    break;

                case "gapplyremove":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;

                    if (tGuildId > 0) {
                        if (Number.isInteger(messageArray[1])) {
                            if (this.connectedGuilds[tGuildId].canCancelApplies(this.connectedUsers[authorIdentifier].character.id)) {
                                Guild.deleteUserForThisGuildAppliance(messageArray[1], tGuildId);
                                msg = "Vous avez bien refusé l'candidatures.";
                            } else {
                                msg = "Vous n'avez pas le droit de faire cela.";
                            }


                        } else {
                            msg = "Vous devez choisir l'identifiant du personnage.";
                        }

                    } else {
                        if (Number.isInteger(messageArray[1])) {
                            Guild.deleteUserForThisGuildAppliance(this.connectedUsers[authorIdentifier].character.id, messageArray[1]);
                            msg = "Vous avez bien annulé l'candidatures.";
                        } else {
                            msg = "Vous devez choisir l'identifiant de la guilde.";
                        }
                    }
                    message.reply(msg);
                    break;

                case "gappliesremove":
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;

                    if (tGuildId > 0) {
                        if (this.connectedGuilds[tGuildId].canCancelApplies(this.connectedUsers[authorIdentifier].character.id)) {
                            this.connectedGuilds[tGuildId].deleteGuildAppliances();
                            msg = "Vous avez bien refusé toutes les candidatures.";
                        } else {
                            msg = "Vous n'avez pas le droit de faire cela.";
                        }
                    } else {
                        Guild.deleteUsersAppliances(this.connectedUsers[authorIdentifier].character.id);
                        msg = "Vous avez bien annulé toutes vos candidatures.";
                    }

                    message.reply(msg);

                    break;

                case "guilds":
                    apPage = parseInt(messageArray[1], 10);
                    if (!apPage || !Number.isInteger(apPage)) {
                        apPage = 1;
                    }
                    msg = Guild.getGuilds(apPage);
                    message.channel.send(msg);
                    break;

                case "gremove":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (tGuildId > 0) {
                        uIDGuild = this.connectedGuilds[tGuildId].getIdUserByIdCharacter(messageArray[1]);
                        err = this.connectedGuilds[tGuildId].removeMember(this.connectedUsers[authorIdentifier].character.id, messageArray[1]);
                        if (err.length > 0) {
                            msg = err[0];
                        } else {
                            if (messageArray[1] == this.connectedUsers[authorIdentifier].character.id) {
                                msg = "Vous avez quitté votre guilde.";
                            } else {
                                msg = "Le membre à bien été supprimé.";
                            }
                            if (this.connectedUsers[uIDGuild]) {
                                this.connectedUsers[uIDGuild].character.idGuild = 0;
                            }
                        }
                    } else {
                        msg = "Vous n'êtes pas dans une guilde.";
                    }

                    message.reply(msg);
                    break;

                case "gmod":
                    // idMembre,rank
                    messageArray[1] = parseInt(messageArray[1], 10);
                    messageArray[2] = parseInt(messageArray[2], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    uIDGuild = this.connectedGuilds[tGuildId].getIdUserByIdCharacter(messageArray[1]);
                    err = this.connectedGuilds[tGuildId].updateMember(this.connectedUsers[authorIdentifier].character.id, messageArray[1], messageArray[2]);
                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = "Le rang de ce membre à bien été modifié.";
                    }
                    message.reply(msg);
                    break;


                case "gmessage":
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (tGuildId > 0) {
                        err = this.connectedGuilds[tGuildId].setMessage(this.connectedUsers[authorIdentifier].character.id, this.getArgsString(messageArray));
                    } else {
                        err.push("Vous devez être dans une guilde pour faire cela.");
                    }

                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = "Vous avez bien modifié le message de guilde.";
                    }

                    message.channel.send(msg);
                    break;

                case "gaddmoney":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (messageArray[1] || Number.isInteger(messageArray[1])) {
                        if (this.connectedUsers[authorIdentifier].character.doIHaveEnoughMoney(messageArray[1])) {
                            if (!this.connectedGuilds[tGuildId].addMoney(messageArray[1])) {
                                err.push("Vous ne pouvez pas donner cette somme à la guilde.");
                            } else {
                                //Si tout est ok
                                this.connectedUsers[authorIdentifier].character.removeMoney(messageArray[1]);
                            }
                        } else {
                            err.push("Vous n'avez pas cette somme.");
                        }

                    } else {
                        err.push("Vous devez choisir la somme à donner à votre guilde.");
                    }

                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = "Vous avez bien donné " + messageArray[1] + "G à votre guilde.";
                    }

                    message.channel.send(msg);
                    break;

                case "gremovemoney":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (messageArray[1] || Number.isInteger(messageArray[1])) {
                        err = this.connectedGuilds[tGuildId].removeMoney(messageArray[1], this.connectedUsers[authorIdentifier].character.id);
                    } else {
                        err.push("Vous devez choisir la somme à donner à votre guilde.");
                    }

                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = "Vous avez retiré " + messageArray[1] + "G de votre guilde.";
                        this.connectedUsers[authorIdentifier].character.addMoney(messageArray[1]);
                    }

                    message.channel.send(msg);
                    break;


                case "glevelup":
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    err = this.connectedGuilds[tGuildId].levelUp(this.connectedUsers[authorIdentifier].character.id);


                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = "Votre guilde est bien monté de niveau, elle passe niveau : " + this.connectedGuilds[tGuildId].level;
                    }

                    message.channel.send(msg);
                    break;

                /*
                * OTHER
                */

                case "giveme":
                    if (Globals.admins.indexOf(authorIdentifier) > -1) {
                        messageArray[1] = parseInt(messageArray[1]);
                        if (messageArray[1] && Number.isInteger(messageArray[1])) {
                            tLootSystem.getLoot(this.connectedUsers[authorIdentifier].character, messageArray[1], this.connectedUsers[authorIdentifier].character.getLevel());
                        }
                    }
                    break;

                case "areaplayers":
                    apPage = parseInt(messageArray[1], 10);
                    if (!apPage || !Number.isInteger(apPage)) {
                        apPage = 1;
                    }
                    message.reply(this.areasManager.getPlayersOf(this.connectedUsers[authorIdentifier].character.area, apPage, this.connectedUsers));
                    break;

                case "active":
                    if (Globals.admins.indexOf(authorIdentifier) > -1) {
                        if (messageArray[1] === "true") {
                            Globals.activated = true;
                            //console.log("bot activated");
                        } else if (messageArray[1] === "false") {
                            Globals.activated = false;
                            //console.log("bot desactivated");
                        }
                    }
                    break;

                case "collect":
                    let idToCollect = parseInt(messageArray[1], 10);
                    if (this.connectedUsers[authorIdentifier].character.canFightAt <= Date.now()) {
                        if (idToCollect && Number.isInteger(idToCollect)) {
                            let resourceToCollect = this.areasManager.getResource(this.connectedUsers[authorIdentifier].character.area, idToCollect);
                            //idToCollect = this.areasManager.getResourceId(this.connectedUsers[authorIdentifier].character.area, idToCollect);
                            if (resourceToCollect) {
                                idToCollect = this.connectedUsers[authorIdentifier].character.getIdOfThisIdBase(resourceToCollect.idBaseItem);
                                this.connectedUsers[authorIdentifier].character.waitForNextResource();
                                if (idToCollect) {
                                    this.connectedUsers[authorIdentifier].character.inv.addToInventory(idToCollect, 1);
                                } else {
                                    let idInsert = conn.query("INSERT INTO items VALUES(NULL, " + resourceToCollect.idBaseItem + ", " + 1 + ")")["insertId"];
                                    this.connectedUsers[authorIdentifier].character.inv.addToInventory(idInsert, 1);
                                }
                                msg = "Vous avez récolté " + 1 + " " + resourceToCollect.nomItem + ".";
                            } else {
                                // error object don't exist
                                msg = "Vous ne voyez cette ressource nulle part.";
                            }
                        } else {
                            msg = "Vous devez entrer l'id de la ressource à récolter.";
                        }
                    } else {
                        msg = "Vous êtes trop fatigué pour récolter des ressources vous devez encore attendre : " + Math.ceil((this.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000) + " secondes.";
                    }

                    message.reply(msg);
                    break;

                case "item":
                    let idItemToSee = parseInt(messageArray[1], 10);
                    let doIHaveThisItem = false;
                    msg = "";
                    if (idItemToSee !== undefined && Number.isInteger(idItemToSee)) {
                        //msg = this.connectedUsers[authorIdentifier].character.inv.seeThisItem(invIdItem);
                        //msg = this.connectedUsers[authorIdentifier].character.inv.toStr(invPage);
                        doIHaveThisItem = this.connectedUsers[authorIdentifier].character.inv.doIHaveThisItem(idItemToSee);
                        if (doIHaveThisItem) {
                            msg = this.connectedUsers[authorIdentifier].character.inv.seeThisItem(idItemToSee)
                        }/* else {
                            idItemToSee = this.connectedUsers[authorIdentifier].character.equipement.doIHaveThisItem(idItemToSee);
                            
                            if (idItemToSee > 0) {
                                msg = this.connectedUsers[authorIdentifier].character.equipement.seeThisItem(idItemToSee);
                            } else {
                                msg = "```Vous n'avez pas cet objet```";
                            }

                        }*/

                    } else {
                        idItemToSee = this.getEquipableIDType(messageArray[1]);
                        if (idItemToSee > 0) {
                            msg = this.connectedUsers[authorIdentifier].character.equipement.seeThisItem(idItemToSee);
                        } else {
                            msg = "```Vous devez entrer l'id de l'emplacement d'inventaire ou bien choisir parmi head,chest,legs,weapon```";
                        }

                    }

                    message.channel.send(msg);

                    break;

                case "inv":
                case "inventory":
                    let invPage = parseInt(messageArray[1], 10);
                    msg = "";
                    if (invPage && Number.isInteger(invPage)) {
                        //msg = this.connectedUsers[authorIdentifier].character.inv.seeThisItem(invIdItem);
                        msg = this.connectedUsers[authorIdentifier].character.inv.toStr(invPage);
                    } else {
                        msg = this.connectedUsers[authorIdentifier].character.inv.toStr();
                    }

                    message.channel.send(msg);

                    break;

                case "equip":
                    let toEquip = parseInt(messageArray[1], 10);
                    msg = "";
                    //console.log((toEquip));
                    if (toEquip !== undefined && Number.isInteger(toEquip)) {
                        if (this.connectedUsers[authorIdentifier].character.inv.doIHaveThisItem(toEquip)) {
                            if (this.connectedUsers[authorIdentifier].character.inv.isEquipable(toEquip)) {
                                let swapItem = this.connectedUsers[authorIdentifier].character.equipement.equip(this.connectedUsers[authorIdentifier].character.inv.objects[toEquip].id);
                                this.connectedUsers[authorIdentifier].character.inv.deleteFromInventory(toEquip);
                                if (swapItem > 0) {
                                    this.connectedUsers[authorIdentifier].character.inv.addToInventory(swapItem);
                                }
                                msg = "Votre item a été équipé.";
                            } else {
                                msg = "Vous ne pouvez pas équiper cet objet.";
                            }
                        } else {
                            msg = "Vous n'avez pas cet objet !";
                        }
                    } else {
                        msg = "Vous devez entrer l'identifiant de l'objet à équiper.";
                    }

                    message.channel.send(msg);
                    break;

                case "unequip":
                    let toUnequip = parseInt(messageArray[1], 10);
                    msg = "";
                    if (toUnequip && Number.isInteger(toUnequip)) {
                        //let swapItem = this.connectedUsers[authorIdentifier].character.equ
                        let itemToInventory = this.connectedUsers[authorIdentifier].character.equipement.unEquip(toUnequip);
                        if (itemToInventory > 0) {
                            this.connectedUsers[authorIdentifier].character.inv.addToInventory(itemToInventory);
                            msg = "L'objet à bien été retiré !";
                        } else {
                            msg = "Vous n'avez pas d'objets d'équipé dans cet emplacement !";
                        }

                    } else {
                        msg = "Vous devez choisir le type à retirer.";
                    }

                    message.channel.send(msg);
                    break;

                case "equipList":
                case "equipment":
                    message.channel.send("```" + this.connectedUsers[authorIdentifier].character.equipement.toStr() + "```");
                    break;

                case "reset":
                    if (this.connectedUsers[authorIdentifier].character.resetStats()) {
                        message.reply("Réinitialisation terminée !");
                    } else {
                        message.reply("Vous n'avez pas assez d'argent pour reset vos stats !");
                    }

                    break;

                case "sell":
                    let sellIdItem = parseInt(messageArray[1], 10);
                    let numberOfItemsToSell = parseInt(messageArray[2], 10)
                    numberOfItemsToSell = Number.isInteger(numberOfItemsToSell) ? numberOfItemsToSell : 1;
                    //console.log(numberOfItemsToSell);
                    msg = "";
                    if (this.areasManager.canISellToThisArea(this.connectedUsers[authorIdentifier].character.area)) {
                        if (sellIdItem !== undefined && Number.isInteger(sellIdItem)) {
                            let itemValue = this.connectedUsers[authorIdentifier].character.sellThisItem(sellIdItem, numberOfItemsToSell);
                            if (itemValue > 0) {
                                msg = "Vous avez vendu ce que vous vouliez pour " + itemValue + "G";
                            } else {
                                msg = "Vous ne possedez pas cet objet.";
                            }
                        } else {
                            msg = "Vous devez entrez l'ID de l'item à vendre !";
                        }
                    } else {
                        msg = "Vous devez être dans une ville pour pouvoir vendre vos objets."
                    }


                    message.channel.send(msg);
                    break;

                case "sellall":
                    if (this.areasManager.canISellToThisArea(this.connectedUsers[authorIdentifier].character.area)) {
                        let allSelled = this.connectedUsers[authorIdentifier].character.sellAllInventory();
                        if (allSelled > 0) {
                            msg = "Vous avez vendu tout les objets de votre inventaire pour " + allSelled + "G";
                        } else {
                            msg = "Le marchand n'accepte pas de vous acheter du vent...";
                        }
                    } else {
                        msg = "Vous devez être dans une ville pour pouvoir vendre vos objets."
                    }

                    message.channel.send(msg);

                    break;

                case "xp":
                    if (Globals.admins.indexOf(authorIdentifier) > -1) {

                        if (this.connectedUsers[authorIdentifier].character.getLevel() < Globals.maxLevel)
                        {
                            let value = parseInt(messageArray[1], 10);
                            if (!value && !Number.isInteger(value)) {
                                value = 1;
                            }

                            let str = "Tenez c'est le bon dieu qui vous l'offre ! \n" + value + " XP tombent du ciel rien que pour vous !\n";
                            let actualLevel = this.connectedUsers[authorIdentifier].character.getLevel();
                            this.connectedUsers[authorIdentifier].character.addExp(value);
                            let diffLevel = this.connectedUsers[authorIdentifier].character.getLevel() - actualLevel;
                            if (diffLevel > 0) {
                                let plur = diffLevel > 1 ? "x" : "";
                                str += "<:levelup:403456740139728906> Bravo ! Vous avez gagné : " + diffLevel + " niveau" + plur + ". Vous êtes desormais niveau : " + this.connectedUsers[authorIdentifier].character.getLevel() + " !\n";
                            }
                            message.reply(str);
                        } else {
                            message.reply("Vous êtes déjà au niveau maximum !");
                        }

                    } else {
                        message.reply("Vous n'êtes pas administrateur, mais vous avez essayé de tricher, malheureusement, dieu n'est pas gentil et il a décidé de vous punir en " +
                            "vous faisant revivre une nouvelle vie (Vous êtes dersormais niveau 1).");
                    }

                    break;

                case "gold":
                    if (Globals.admins.indexOf(authorIdentifier) > -1) {

                        let value = parseInt(messageArray[1], 10);
                        if (!value && !Number.isInteger(value)) {
                            value = 1;
                        }

                        let str = "Tenez c'est le bon dieu qui vous l'offre ! \n" + value + " Argent tombent du ciel rien que pour vous !\n";
                        this.connectedUsers[authorIdentifier].character.addMoney(value);
                        str += "<:treasure:403457812535181313> Vous avez désormais : " + this.connectedUsers[authorIdentifier].character.money + " Argent !";

                        message.reply(str);
                    } else {
                        message.reply("Vous n'êtes pas administrateur, mais vous avez essayé de tricher, malheureusement, dieu n'est pas gentil et il a décidé de vous punir en " +
                            "vous rendant pauvre (Vous n'avez desormais plus que 1 Argent).");
                    }

                    break;

                case "resetfight":
                    if (Globals.admins.indexOf(authorIdentifier) > -1) {
                        this.connectedUsers[authorIdentifier].character.canFightAt = 0;
                        message.channel.send("Reset Done");
                        //console.log("reset fight");
                    }
                    break;

                case "nameOf":
                    if (Globals.admins.indexOf(authorIdentifier) > -1) {
                        if (this.connectedUsers[messageArray[1]]) {
                            message.reply(this.connectedUsers[messageArray[1]].username);
                        } else {
                            message.reply("Non Connecté");
                        }
                    }
                    break;

                case "debug":
                    //this.debug(message);

                    //message.channel.send(msg);
                    message.channel.send(this.areasManager.getResources(this.connectedUsers[authorIdentifier].character.area));
                    //this.connectedUsers[authorIdentifier].character.inv.addToInventory(1);
                    //this.connectedUsers[authorIdentifier].character.equipement.totalStats();
                    //console.log(this.connectedUsers[authorIdentifier].character.equipement);
                    //console.log(this.connectedUsers[authorIdentifier].character.canFightAt);
                    //console.log(this.connectedUsers[authorIdentifier].character.inv.getAllInventoryValue());
                    break;

                case "leaderboard":
                    msg = Leaderboard.playerLeaderboardToStr(this.connectedUsers[authorIdentifier].character.id);
                    message.reply(msg);
                    break;

                case "info":
                    message.channel.send(this.connectedUsers[authorIdentifier].infoPanel());
                    //message.channel.send("XP : " + this.connectedUsers[authorIdentifier].character.levelSystem.actualXP + " | Argent : " + this.connectedUsers[authorIdentifier].character.money + " | Level : " + this.connectedUsers[authorIdentifier].character.levelSystem.actualLevel);
                    break;

                case "help":
                    message.channel.send(this.helpPanel());
                    break;

                case "fight":
                    //this.fightManager.fightPvE(this.connectedUsers[authorIdentifier], message, messageArray[1]);
                    let idEnemy = parseInt(messageArray[1], 10);
                    if (this.areasManager.canIFightInThisArea(this.connectedUsers[authorIdentifier].character.area)) {
                        if (idEnemy && Number.isInteger(idEnemy)) {
                            let canIFightTheMonster = this.areasManager.canIFightThisMonster(this.connectedUsers[authorIdentifier].character.area, idEnemy, this.connectedUsers[authorIdentifier].character.stats.perception);

                            if (!canIFightTheMonster) {
                                idEnemy = this.areasManager.selectRandomMonsterIn(this.connectedUsers[authorIdentifier].character.area, idEnemy);
                            }

                            this.fightManager.fightPvE(this.connectedUsers[authorIdentifier], message, idEnemy, canIFightTheMonster);

                        } else {
                            // Error Message
                            message.channel.send("Vous devez entrer l'identifiant du monstre que vous voulez attaquer.");
                        }
                    } else {
                        message.reply("Vous ne pouvez pas vous battre en ville.");
                    }
                    break;

                case "area":
                    msg = this.areasManager.seeThisArea(this.connectedUsers[authorIdentifier].character.area);
                    message.channel.send(msg);
                    break;

                case "areas":
                    message.channel.send(this.areasManager.seeAllAreas());
                    break;

                case "travel":
                    let wantedAreaToTravel = parseInt(messageArray[1], 10);
                    if (this.connectedUsers[authorIdentifier].character.canFightAt <= Date.now()) {
                        if (this.areasManager.exist(wantedAreaToTravel)) {
                            if (wantedAreaToTravel == this.connectedUsers[authorIdentifier].character.area) {
                                msg = "Vous êtes déjà à cet endroit.";
                            } else {

                                // Update le compte de joueurs
                                this.areasManager.updateTravel(this.connectedUsers[authorIdentifier].character.area, wantedAreaToTravel);

                                // change de zone
                                this.connectedUsers[authorIdentifier].character.changeArea(wantedAreaToTravel);

                                // Messages
                                msg = "Vous avez bien voyagé vers la zone : " + this.areasManager.getNameOf(wantedAreaToTravel) + ".";
                                msg += "\nVous êtes fatigué vous allez devoir attendre " + Math.ceil((this.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000) + " secondes avant de pouvoir refaire une action.";
                            }

                        } else {
                            msg = "Cette zone n'existe pas !";
                        }
                    } else {
                        msg = "Vous êtes trop fatigué pour voyager vous devez encore attendre : " + Math.ceil((this.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000) + " secondes.";
                    }
                    message.channel.send(msg);
                    break;


                case "arena":
                    firstMention = mentions.first();
                    let idOtherPlayerCharacter = 0;
                    let mId = -1;
                    if (this.areasManager.canIFightInThisArea(this.connectedUsers[authorIdentifier].character.area)) {
                        // Ici on récupère l'id
                        if (firstMention) {
                            mId = firstMention.id;
                        } else if (messageArray[1]) {
                            idOtherPlayerCharacter = parseInt(messageArray[1], 10);
                            if (idOtherPlayerCharacter && Number.isInteger(idOtherPlayerCharacter)) {
                                mId = Leaderboard.idOf(idOtherPlayerCharacter);
                            }
                        } else {
                            message.channel.send("Vous devez choisir votre adversaire !");
                        }

                        // Ici on lance le combat si possible
                        if (this.connectedUsers[mId]) {
                            if (authorIdentifier !== mId) {
                                this.fightManager.fightPvP(this.connectedUsers[authorIdentifier], this.connectedUsers[mId], message);
                            } else {
                                message.channel.send("Vous ne pouvez pas vous combattre !");
                            }

                        } else {
                            message.channel.send("Cet adversaire n'est pas connecté !");
                        }
                    } else {
                        message.reply("Vous ne pouvez pas attaquer un autre joueur ici.");
                    }

                    break;

                case "up":
                    // TODO: Change after
                    if (this.authorizedAttributes.indexOf(messageArray[1]) !== -1) {
                        let reply = this.connectedUsers[authorIdentifier].character.upStat(messageArray[1], messageArray[2]);
                        message.reply(reply);
                    } else {
                        message.reply("Cet Attrbiut n'existe pas");
                    }
                    break;

                case "salty":
                    const saltEmoji = this.bot.emojis.find("name", "saltbae");
                    message.channel.send(`${saltEmoji}`);
                    break;

                case "emojiList" :
                    const emojiList = message.guild.emojis.map(e => e.toString()).join(" ");
                    message.channel.send(emojiList);
                    break;
            }
        }


    }

    debug(message) {
        //console.log(Globals);
        //this.updateConnectedUsers();
        //message.channel.send(message.mentions.users);
        //console.log(Object.keys(message.mentions))


        //console.log(message.mentions.users);
    }

    // Return string or embed
    helpPanel() {
        let str = "```apache\n"
            + "::Help::\n"
            + "[Inventaire]\n" +
            "::inv : Affiche l'inventaire.\n" +
            "::inventory : Alias de ::inv.\n" +
            "::item <idItem> : Affiche les informations sur l'objet choisi.\n" +
            "::sell <idItem> <number(Optional)> : Vend l'objet choisi.\n" +
            "::sellall : Vend tout les objets de l'inventaire.\n"
            + "[Equipement]\n" +
            "::equipList : Affiche les objets équipés.\n" +
            "::equipment : Alias de ::equipList.\n" +
            "::equip <idItem> : Equipe l'objet choisi.\n" +
            "::unequip <idTypeEmplacement> : Déséquipe l'objet de l'emplacement choisi.\n"
            + "[Personnage]\n" +
            "::info : Affiche les informations sur votre personnage.\n" +
            "::up <NomStat> <Nombre> : Ajoute à la caractéristique NomStat Nombre.\n" +
            "::leaderboard : Affiche ton rang PvP.\n" +
            "::reset : Te permet de reset tes statistiques.\n"
            + "[Combats]\n" +
            "::fight <idMonstre> : Permet de tenter d'attaquer le monstre idMonstre.\n" +
            "::arena @Mention : Permet d'attaquer le joueur mentionné.\n" +
            "::arena <idCharacter> : Permet d'attaquer le joueur chosi.\n"
            + "[Zones]\n" +
            "::area : Affiche les informations de la zone dans laquelle tu te trouve.\n" +
            "::areas : Affiche toutes les zones.\n" +
            "::areaplayers <page> : Affiche les joueurs de la zone \n" +
            "::travel <idZone> : Permet de voyager à la zone idZone.\n"
            + "[Guildes]\n" +
            "::guild : Affiche les informations de la guilde dans laquelle vous êtes.\n" +
            "::guilds <page> : Affiche les guildes.\n" +
            "::gcreate <name> : Permet de créer une guilde.\n" +
            "::gdisband : Permet de dissoudre la guilde (GM only) \n" +
            "::gapply <idGuild> : Permet de demander à rejoindre une guilde. \n" +
            "::gaccept <idCharacter> : Permet d'accepter quelqu'un dans votre guilde \n" +
            "::gapplies : Afficher les candidatures \n" +
            "::gapplyremove <idApply> : Permet de supprimer la candidature voulue. \n" +
            "::gappliesremove : Supprime toutes les candidatures en cours. \n" +
            "::gmessage <message> : Permet de changer le message de guilde. \n" +
            "::gaddmoney <amount> : Donne de l'argent à la guilde. \n" +
            "::gremovemoney <amount> : Permet de retirer de l'argent de la guilde. \n" +
            "::glevelup : Permet de faire monter de niveau la guilde. \n"
            +"```";



        return str;
    }

    //Temp Solution
    getArgsString(arrayString) {
        let str = "";
        for (let i = 1; i < arrayString.length; i++) {
            str += arrayString[i] + " ";
        }

        return str;
    }

    // 
    getEquipableIDType(string) {
        let r = -1;
        switch (string) {
            case "weapon":
                r = 1;
                break;
            case "chest":
                r = 2;
                break;
            case "legs":
                r = 3;
                break;
            case "head":
                r = 4;
                break;
        }
        return r;
    }
}

module.exports = Commandes;
