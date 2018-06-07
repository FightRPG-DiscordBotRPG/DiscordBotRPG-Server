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
const Fight = require("./Fight/Fight");
const Monster = require("./Monstre");
const Translator = require("./Translator/Translator");

class Commandes {
    constructor(prefix) {
        this.prefix = prefix != undefined ? prefix : "::";
        this.authorizedAttributes = ["str", "int", "con", "dex", "cha", "will", "luck", "wis", "per"];
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

        if (command !== undefined && !message.author.bot && message.content.startsWith(this.prefix)) {
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

                this.areasManager.addOnePlayer(this.connectedUsers[authorIdentifier].character.area);

                this.nbrConnectedUsers++;

                this.bot.user.setPresence({
                    game: {
                        name: this.nbrConnectedUsers + " players connected !",
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

            let lang = this.connectedUsers[authorIdentifier].lang;
            console.log("[" + new Date().toDateString() + "] User : " + message.author.username + " Attemp command : \"" + command + "\"")

            // Detect Commands
            switch (command) {
                /*
                *   CONQUEST
                */

                case "claim":
                    if (this.connectedUsers[authorIdentifier].character.isInGuild()) {
                        err = this.areasManager.claim(this.connectedUsers[authorIdentifier].character.area, this.connectedUsers[authorIdentifier].character.idGuild, lang)
                    } else {
                        err.push(Translator.getString(lang, "errors", "you_have_to_be_in_a_guild"));
                    }

                    if (err[0]) {
                        msg = err[0];
                    } else {
                        msg = Translator.getString(lang, "area", "you_claimed");
                    }

                    message.channel.send(msg);
                    break;

                /*
                *   GUILDS
                */

                case "guild":
                    if (this.connectedUsers[authorIdentifier].character.isInGuild()) {
                        msg = this.connectedGuilds[this.connectedUsers[authorIdentifier].character.idGuild].toStr(lang);
                    } else {
                        msg = Translator.getString(lang, "guild", "you_dont_have_a_guild");
                    }
                    message.channel.send(msg);
                    break;

                case "gcreate":
                    if (messageArray[1]) {
                        // Si le joueur n'a pas de guilde
                        if (this.connectedUsers[authorIdentifier].character.idGuild == 0) {
                            if (this.connectedUsers[authorIdentifier].character.doIHaveEnoughMoney(Globals.guilds.basePriceLevel)) {
                                let tGuild = new Guild();
                                let err = tGuild.createGuild(messageArray[1], this.connectedUsers[authorIdentifier].character.id, lang);
                                if (err.length == 0) {
                                    this.connectedGuilds[tGuild.id] = tGuild;
                                    this.connectedUsers[authorIdentifier].character.idGuild = tGuild.id;
                                    // Static delete
                                    Guild.deleteUsersAppliances(this.connectedUsers[authorIdentifier].character.id);

                                    this.connectedUsers[authorIdentifier].character.removeMoney(Globals.guilds.basePriceLevel);

                                    msg = Translator.getString(lang, "guild", "guild_x_created", [tGuild.name]);
                                } else {
                                    msg = err[0];
                                }
                            } else {
                                msg = Translator.getString(lang, "guild", "dont_have_enough_to_create", [Globals.guilds.basePriceLevel]);
                            }

                        } else {
                            msg = Translator.getString(lang, "errors", "already_in_guild");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_name_empty");
                    }
                    message.reply(msg);
                    break;

                case "gdisband":
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (tGuildId > 0
                        && this.connectedGuilds[tGuildId].members[this.connectedUsers[authorIdentifier].character.id].rank === 3) {
                        this.areasManager.unclaimAll(tGuildId);
                        this.connectedGuilds[tGuildId].disband(this.connectedUsers);
                        delete this.connectedGuilds[tGuildId];
                        msg = Translator.getString(lang, "guild", "guild_disband");
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_have_to_be_gm_to_disband");
                    }
                    message.channel.send(msg);
                    break;
                

                case "gapply":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (Number.isInteger(messageArray[1])) {
                        if (tGuildId == 0) {
                            err = Guild.applyTo(messageArray[1], this.connectedUsers[authorIdentifier].character.id, lang);
                            if (err.length > 0) {
                                msg = err[0];
                            } else {
                                msg = Translator.getString(lang, "guild", "guild_applied");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_dont_be_in_guild_to_join_a_guild");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_enter_id_to_join");
                    }

                    message.reply(msg);

                    break;

                case "gaccept":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;

                    if (Number.isInteger(messageArray[1])) {
                        if (Guild.haveAlreadyApplied(tGuildId, messageArray[1])) {
                            err = this.connectedGuilds[tGuildId].addMember(this.connectedUsers[authorIdentifier].character.id, messageArray[1], lang);
                            if (err.length > 0) {
                                msg = err[0];
                            } else {
                                msg = Translator.getString(lang, "guild", "character_have_been_accepted");
                                uIDGuild = this.connectedGuilds[tGuildId].getIdUserByIdCharacter(messageArray[1]);
                                Guild.deleteUsersAppliances(messageArray[1]);
                                if (this.connectedUsers[uIDGuild]) {
                                    this.connectedUsers[uIDGuild].character.idGuild = tGuildId;
                                }
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_character_not_ask_to_join");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_enter_id_to_add");
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
                        msg = this.connectedGuilds[tGuildId].getGuildAppliances(apPage, lang);
                    } else {
                        msg = Guild.getAppliances(this.connectedUsers[authorIdentifier].character.id, lang);
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
                                msg = Translator.getString(lang, "guild", "you_have_denied_this_apply");
                            } else {
                                msg = Translator.getString(lang, "errors", "guild_cant_remove_appliances");
                            }


                        } else {
                            msg = Translator.getString(lang, "errors", "guild_have_to_enter_id_to_remove_apply");
                        }

                    } else {
                        if (Number.isInteger(messageArray[1])) {
                            Guild.deleteUserForThisGuildAppliance(this.connectedUsers[authorIdentifier].character.id, messageArray[1]);
                            msg = Translator.getString(lang, "guild", "you_have_cancel_your_apply");
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_have_to_enter_id_to_remove_apply_playerside");
                        }
                    }
                    message.reply(msg);
                    break;

                case "gappliesremove":
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;

                    if (tGuildId > 0) {
                        if (this.connectedGuilds[tGuildId].canCancelApplies(this.connectedUsers[authorIdentifier].character.id)) {
                            this.connectedGuilds[tGuildId].deleteGuildAppliances();
                            msg = Translator.getString(lang, "guild", "you_have_denied_all_applies");
                        } else {
                            msg = Translator.getString(lang, "errors", "guild_cant_remove_appliances");
                        }
                    } else {
                        Guild.deleteUsersAppliances(this.connectedUsers[authorIdentifier].character.id);
                        msg = Translator.getString(lang, "guild", "you_have_cancel_all_your_applies");
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
                        err = this.connectedGuilds[tGuildId].removeMember(this.connectedUsers[authorIdentifier].character.id, messageArray[1], lang);
                        if (err.length > 0) {
                            msg = err[0];
                        } else {
                            if (messageArray[1] == this.connectedUsers[authorIdentifier].character.id) {
                                msg = Translator.getString(lang, "guild", "you_leaved_guild");
                            } else {
                                msg = Translator.getString(lang, "guild", "member_kicked");
                            }
                            if (this.connectedUsers[uIDGuild]) {
                                this.connectedUsers[uIDGuild].character.idGuild = 0;
                            }
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "guild_not_in_guild");
                    }

                    message.reply(msg);
                    break;

                case "gmod":
                    // idMembre,rank
                    messageArray[1] = parseInt(messageArray[1], 10);
                    messageArray[2] = parseInt(messageArray[2], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    uIDGuild = this.connectedGuilds[tGuildId].getIdUserByIdCharacter(messageArray[1]);
                    err = this.connectedGuilds[tGuildId].updateMember(this.connectedUsers[authorIdentifier].character.id, messageArray[1], messageArray[2], lang);
                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = Translator.getString(lang, "guild", "rank_modified");
                    }
                    message.reply(msg);
                    break;


                case "gannounce":
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (tGuildId > 0) {
                        err = this.connectedGuilds[tGuildId].setMessage(this.connectedUsers[authorIdentifier].character.id, this.getArgsString(messageArray), lang);
                    } else {
                        err.push(Translator.getString(lang, "errors", "you_have_to_be_in_a_guild"));
                    }

                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = Translator.getString(lang, "guild", "you_have_updated_guild_announcement");
                    }

                    message.channel.send(msg);
                    break;

                case "gaddmoney":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (messageArray[1] || Number.isInteger(messageArray[1])) {
                        if (this.connectedUsers[authorIdentifier].character.doIHaveEnoughMoney(messageArray[1])) {
                            if (!this.connectedGuilds[tGuildId].addMoney(messageArray[1])) {
                                err.push(Translator.getString(lang, "errors", "guild_cant_give_this_money"));
                            } else {
                                //Si tout est ok
                                this.connectedUsers[authorIdentifier].character.removeMoney(messageArray[1]);
                            }
                        } else {
                            err.push(Translator.getString(lang, "errors", "guild_you_dont_have_enough_money"));
                        }

                    } else {
                        err.push(Translator.getString(lang, "errors", "guild_you_have_to_select_amount_money"));
                    }

                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = Translator.getString(lang, "guild", "you_gift_x_g_to_guild", [messageArray[1]]);
                    }

                    message.channel.send(msg);
                    break;

                case "gremovemoney":
                    messageArray[1] = parseInt(messageArray[1], 10);
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    if (messageArray[1] || Number.isInteger(messageArray[1])) {
                        err = this.connectedGuilds[tGuildId].removeMoney(messageArray[1], this.connectedUsers[authorIdentifier].character.id, lang);
                    } else {
                        err.push(Translator.getString(lang, "errors", "guild_you_have_to_select_amount_to_retrive"));
                    }

                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = Translator.getString(lang, "guild", "you_retrive_x_g_from_guild", [messageArray[1]]);
                        this.connectedUsers[authorIdentifier].character.addMoney(messageArray[1]);
                    }

                    message.channel.send(msg);
                    break;


                case "glevelup":
                    tGuildId = this.connectedUsers[authorIdentifier].character.idGuild;
                    err = this.connectedGuilds[tGuildId].levelUp(this.connectedUsers[authorIdentifier].character.id, lang);


                    if (err.length > 0) {
                        msg = err[0];
                    } else {
                        msg = Translator.getString(lang, "guild", "guild_level_up"[this.connectedGuilds[tGuildId].level]);
                    }

                    message.channel.send(msg);
                    break;

                /*
                * OTHER
                */

                case "lang":
                    if (messageArray[1]) {
                        if (Translator.isLangExist(messageArray[1])) {
                            this.connectedUsers[authorIdentifier].changeLang(messageArray[1]);
                            msg = Translator.getString(messageArray[1], "languages", "lang_changed", [Translator.getString(messageArray[1], "languages", messageArray[1])])
                        } else {
                            msg = Translator.getString(lang, "errors", "languages_lang_dont_exist");
                        }
                    } else {
                        msg = Translator.getString(lang, "languages", "list_of_languages") + "\n" + Translator.getAvailableLanguages(lang);
                        console.log(lang);
                    }
                    message.channel.send(msg);
                    break;

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
                    message.reply(this.areasManager.getPlayersOf(this.connectedUsers[authorIdentifier].character.area, apPage, this.connectedUsers, lang));
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
                                msg = Translator.getString(lang, "resources", "collected_x_resource", [1, resourceToCollect.nomItem]);
                            } else {
                                // error object don't exist
                                msg = Translator.getString(lang, "resources", "resource_dont_exist");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "collect_enter_id_to_collect");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "collect_tired_wait_x_seconds", [Math.ceil((this.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000)]);
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
                            let typeName = this.connectedUsers[authorIdentifier].character.inv.objects[idItemToSee].typeName;

                            let oneEquipped = this.connectedUsers[authorIdentifier].character.equipement.objects[this.getEquipableIDType(typeName)] ? true : false;
                            let equippedStats;

                            if (oneEquipped)
                                equippedStats = this.connectedUsers[authorIdentifier].character.equipement.objects[this.getEquipableIDType(typeName)].stats;

                            msg = this.connectedUsers[authorIdentifier].character.inv.seeThisItem(idItemToSee, equippedStats, lang);
                        } else {
                            msg = "```" + Translator.getString(lang, "errors", "item_you_dont_have_this_item") + "```";
                        }

                        /*else {
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
                            msg = this.connectedUsers[authorIdentifier].character.equipement.seeThisItem(idItemToSee, lang);
                        } else {
                            msg = "```" + Translator.getString(lang, "errors", "item_choose_id_or_equipement") + "```";
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
                        msg = this.connectedUsers[authorIdentifier].character.inv.toStr(invPage, lang);
                    } else {
                        msg = this.connectedUsers[authorIdentifier].character.inv.toStr(0, lang);
                    }

                    message.channel.send(msg);

                    break;

                // Equip more than 1 item once
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
                                msg = Translator.getString(lang, "inventory_equipment", "item_equiped");
                            } else {
                                msg = Translator.getString(lang, "errors", "item_you_cant_equip");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "item_you_dont_have");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "item_enter_id_to_equip");
                    }

                    message.channel.send(msg);
                    break;

                case "unequip":
                    let toUnequip = this.getEquipableIDType(messageArray[1]);
                    msg = "";
                    if (toUnequip != -1 && Number.isInteger(toUnequip)) {
                        //let swapItem = this.connectedUsers[authorIdentifier].character.equ
                        let itemToInventory = this.connectedUsers[authorIdentifier].character.equipement.unEquip(toUnequip);
                        if (itemToInventory > 0) {
                            this.connectedUsers[authorIdentifier].character.inv.addToInventory(itemToInventory);
                            msg = Translator.getString(lang, "inventory_equipment", "item_unequiped");
                        } else {
                            msg = Translator.getString(lang, "errors", "item_you_dont_have_item_equiped_here");
                        }

                    } else {
                        msg = Translator.getString(lang, "errors", "item_you_have_to_choose_type_to_unequip");
                    }

                    message.channel.send(msg);
                    break;

                case "equipList":
                case "equipment":
                    message.channel.send("```" + this.connectedUsers[authorIdentifier].character.equipement.toStr(lang) + "```");
                    break;

                case "reset":
                    if (this.connectedUsers[authorIdentifier].character.resetStats()) {
                        message.reply(Translator.getString(lang, "character", "reset_done"));
                    } else {
                        message.reply(Translator.getString(lang, "errors", "character_you_dont_have_enough_to_reset"));
                    }

                    break;

                case "sell":
                    let sellIdItem = parseInt(messageArray[1], 10);
                    let numberOfItemsToSell = parseInt(messageArray[2], 10);
                    numberOfItemsToSell = Number.isInteger(numberOfItemsToSell) ? numberOfItemsToSell : 1;
                    //console.log(numberOfItemsToSell);
                    msg = "";
                    if (this.areasManager.canISellToThisArea(this.connectedUsers[authorIdentifier].character.area)) {
                        if (sellIdItem !== undefined && Number.isInteger(sellIdItem)) {
                            let itemValue = this.connectedUsers[authorIdentifier].character.sellThisItem(sellIdItem, numberOfItemsToSell);
                            if (itemValue > 0) {
                                msg = numberOfItemsToSell == 1 ? Translator.getString(lang, "economic", "sell_for_x", [itemValue]) : Translator.getString(lang, "economic", "sell_for_x_plural", [itemValue]);
                            } else {
                                msg = Translator.getString(lang, "errors", "item_you_dont_have");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "economic_enter_id_item_to_sell");
                        }
                    } else {;
                        msg = Translator.getString(lang, "errors", "economic_have_to_be_in_town");
                    }


                    message.channel.send(msg);
                    break;

                case "sellall":
                    if (this.areasManager.canISellToThisArea(this.connectedUsers[authorIdentifier].character.area)) {
                        let allSelled = this.connectedUsers[authorIdentifier].character.sellAllInventory();
                        if (allSelled > 0) {
                            msg = Translator.getString(lang, "economic", "sell_all_for_x", [allSelled]);
                        } else {
                            msg = Translator.getString(lang, "errors", "economic_cant_sell_nothing");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "economic_have_to_be_in_town");
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
                        message.reply(Translator.getString(lang, "admmin", "no_admin_xp_command"));
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
                            message.reply(this.connectedUsers[messageArray[1]].character.name);
                        } else {
                            message.reply("Non Connecté");
                        }
                    }
                    break;

                case "debug":
                    //this.debug(message);

                    //message.channel.send(msg);
                    //message.channel.send(this.areasManager.getResources(this.connectedUsers[authorIdentifier].character.area));
                    //this.connectedUsers[authorIdentifier].character.inv.addToInventory(1);
                    //this.connectedUsers[authorIdentifier].character.equipement.totalStats();
                    //console.log(this.connectedUsers[authorIdentifier].character.equipement);
                    //console.log(this.connectedUsers[authorIdentifier].character.canFightAt);
                    //console.log(this.connectedUsers[authorIdentifier].character.inv.getAllInventoryValue());
                    if (Globals.admins.indexOf(authorIdentifier) > -1) {
                        /*let monsters1 = [new Monster(20), new Monster(10), new Monster(12)];
                        let monsters2 = [new Monster(19), new Monster(15), new Monster(11)];*/

                        let monsters1 = [new Monster(20)];
                        let monsters2 = [new Monster(20)];

                        monsters1[0].stats.intellect = 0;
                        //monsters1[1].stats.intellect = 4;
                        //monsters1[2].stats.intellect = 2;

                        monsters2[0].stats.intellect = 9;
                        //monsters2[1].stats.intellect = 1;
                        //monsters2[2].stats.intellect = 5;

                        //console.log(monsters2[0].stats);



                        let f = new Fight(monsters1, monsters2);
                        console.log(f.summary);
                    }
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
                    message.channel.send(this.helpPanel(lang, 1));
                    break;

                case "fight":
                    //this.fightManager.fightPvE(this.connectedUsers[authorIdentifier], message, messageArray[1]);
                    let idEnemy = parseInt(messageArray[1], 10);
                    if (this.areasManager.canIFightInThisArea(this.connectedUsers[authorIdentifier].character.area)) {
                        if (idEnemy != undefined && Number.isInteger(idEnemy)) {
                            let canIFightTheMonster = this.areasManager.canIFightThisMonster(this.connectedUsers[authorIdentifier].character.area, idEnemy, this.connectedUsers[authorIdentifier].character.getStat("perception"));

                            if (!canIFightTheMonster) {
                                idEnemy = this.areasManager.selectRandomMonsterIn(this.connectedUsers[authorIdentifier].character.area, idEnemy);
                            } else {
                                idEnemy = this.areasManager.getMonsterIdIn(this.connectedUsers[authorIdentifier].character.area, idEnemy);
                            }
                            this.fightManager._fightPvE([this.connectedUsers[authorIdentifier].character], [{id:idEnemy, number: 1}], message, canIFightTheMonster, lang);
                            //this.fightManager.fightPvE(this.connectedUsers[authorIdentifier], message, idEnemy, canIFightTheMonster);

                        } else {
                            // Error Message
                            message.channel.send(Translator.getString(lang, "errors", "fight_enter_id_monster"));
                        }
                    } else {
                        message.reply(Translator.getString(lang, "errors", "fight_impossible_in_town"));
                    }
                    break;

                case "area":
                    msg = this.areasManager.seeThisArea(this.connectedUsers[authorIdentifier].character.area, lang);
                    message.channel.send(msg);
                    break;

                case "areas":
                    message.channel.send(this.areasManager.seeAllAreas(lang));
                    break;

                case "travel":
                    let wantedAreaToTravel = parseInt(messageArray[1], 10);
                    if (this.connectedUsers[authorIdentifier].character.canFightAt <= Date.now()) {
                        if (this.areasManager.exist(wantedAreaToTravel)) {
                            if (wantedAreaToTravel == this.connectedUsers[authorIdentifier].character.area) {
                                msg = Translator.getString(lang, "errors", "travel_already_here");
                            } else {

                                // Update le compte de joueurs
                                this.areasManager.updateTravel(this.connectedUsers[authorIdentifier].character.area, wantedAreaToTravel);

                                // change de zone
                                this.connectedUsers[authorIdentifier].character.changeArea(wantedAreaToTravel);

                                // Messages
                                msg = Translator.getString(lang, "travel", "travel_to_area", [this.areasManager.getNameOf(wantedAreaToTravel)]);
                                msg += "\n" + Translator.getString(lang, "travel", "travel_to_area_exhaust", [Math.ceil((this.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000)]);
                            }

                        } else {
                            msg = Translator.getString(lang, "errors", "travel_area_dont_exist");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "travel_tired_wait_x", [Math.ceil((this.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000)]);
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
                            message.channel.send(Translator.getString(lang, "errors", "fight_pvp_choose_enemy"));
                        }

                        // Ici on lance le combat si possible
                        if (this.connectedUsers[mId]) {
                            if (authorIdentifier !== mId) {
                                this.fightManager.fightPvP(this.connectedUsers[authorIdentifier], this.connectedUsers[mId], message, lang);
                            } else {
                                message.channel.send(Translator.getString(lang, "errors", "fight_pvp_cant_fight_yourself"));
                            }

                        } else {
                            message.channel.send(Translator.getString(lang, "errors", "fight_pvp_not_same_area"));
                        }
                    } else {
                        message.reply(Translator.getString(lang, "errors", "fight_pvp_cant_fight_here"));
                    }

                    break;

                case "up":
                    if (this.authorizedAttributes.indexOf(messageArray[1]) !== -1) {
                        let done = this.connectedUsers[authorIdentifier].character.upStat(messageArray[1], messageArray[2]);
                        if (done) {
                            msg = Translator.getString(lang, "character", "attribute_up_to", [this.getToStrShort(messageArray[1]), this.connectedUsers[authorIdentifier].character.stats[this.getToStrShort(messageArray[1])]])
                                + "." + (this.connectedUsers[authorIdentifier].character.statPoints > 1 ?
                                    Translator.getString(lang, "character", "attribute_x_points_available_plural", [this.connectedUsers[authorIdentifier].character.statPoints]) :
                                    Translator.getString(lang, "character", "attribute_x_points_available", [this.connectedUsers[authorIdentifier].character.statPoints]));
                            
                        } else {
                            msg = Translator.getString(lang, "errors", "character_you_cant_distribute_this_amount_of_points");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "character_attribute_dont_exist");
                    }

                    message.reply(msg);
                    break;

                case "salty":
                    const saltEmoji = this.bot.emojis.find("name", "saltbae");
                    message.channel.send(`${saltEmoji}`);
                    break;

                case "emojiList" :
                    const emojiList = message.guild.emojis.map(e => e.toString()).join(" ");
                    message.channel.send(emojiList);
                    break;

                /*case "token":
                    msg = "Hi, you have requested your unique token to use our Mobile/Web App.\n Do not share this token with anyone.\n Your token is : " + this.connectedUsers[authorIdentifier].getToken();
                    message.author.send(msg);
                    break;*/
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
    helpPanel(lang, page) {
        /*let str = "```apache\n"
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
            "::up <NomStat> <Nombre> : Ajoute à la caractéristique NomStat Nombre.(str,con,dex,will,cha,int,wis,per,luck)\n" +
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
            + "```";*/
        let str = "```apache\n" +
            "::" + Translator.getString(lang, "help_panel", "help") + "::\n" +
            "[" + Translator.getString(lang, "help_panel", "inventory_title") + "]\n" +
            "::inv/inventory : " + Translator.getString(lang, "help_panel", "inv") + "\n" +
            "::item <itemID> : " + Translator.getString(lang, "help_panel", "item") + "\n" +
            "::sell <itemID> : " + Translator.getString(lang, "help_panel", "sell") + "\n" +
            "::sellall : " + Translator.getString(lang, "help_panel", "sellall") + "\n" +

            "[" + Translator.getString(lang, "help_panel", "equipment_title") + "]\n" +
            "::equipment/equipList : " + Translator.getString(lang, "help_panel", "equipment") + "\n" +
            "::equip <itemID> : " + Translator.getString(lang, "help_panel", "equip") + "\n" +
            "::unequip <itemType> : " + Translator.getString(lang, "help_panel", "unequip") + " (chest,head,legs,weapon)" + "\n" +

            "[" + Translator.getString(lang, "help_panel", "character_title") + "]\n" +
            "::info : " + Translator.getString(lang, "help_panel", "info") + "\n" +
            "::up <statName> <number> : " + Translator.getString(lang, "help_panel", "up") + "\n" +
            "::leaderboard : " + Translator.getString(lang, "help_panel", "leaderboard") + "\n" +
            "::reset : " + Translator.getString(lang, "help_panel", "reset") + "\n" +

            "[" + Translator.getString(lang, "help_panel", "fight_title") + "]\n" +
            "::fight <monsterID> : " + Translator.getString(lang, "help_panel", "fight") + "\n" +
            "::arena @Someone : " + Translator.getString(lang, "help_panel", "arenaMention") + "\n" +
            "::arena <playerID> : " + Translator.getString(lang, "help_panel", "arena") + "\n" +

            "[" + Translator.getString(lang, "help_panel", "areas_title") + "]\n" +
            "::area : " + Translator.getString(lang, "help_panel", "area") + "\n" +
            "::areas : " + Translator.getString(lang, "help_panel", "areas") + "\n" +
            "::areaplayers <page> : " + Translator.getString(lang, "help_panel", "areaplayers") + "\n" +
            "::travel <areaID> : " + Translator.getString(lang, "help_panel", "travel") + "\n" +

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

            "[" + Translator.getString(lang, "help_panel", "other_title") + "]\n" +
            "::lang : " + Translator.getString(lang, "help_panel", "lang") + "\n" +
            "::lang <languageShort> : " + Translator.getString(lang, "help_panel", "lang_param") + "\n" +
            "```";

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
}

module.exports = Commandes;
