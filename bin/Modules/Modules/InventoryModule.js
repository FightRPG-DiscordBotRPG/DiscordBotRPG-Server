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


class InventoryModule extends GModule {
    constructor() {
        super();
        this.commands = ["item", "itemfav", "itemunfav", "inv", "inventory", "sell", "sellall"];
        this.startLoading("Inventory");
        this.init();
        this.endLoading("Inventory");
    }

    async run(message, command, args) {
        let msg = "";
        let authorIdentifier = message.author.id;
        let mentions = message.mentions.users;
        let group = Globals.connectedUsers[authorIdentifier].character.group;
        let lang = Globals.connectedUsers[authorIdentifier].getLang();
        let pending = Globals.connectedUsers[authorIdentifier].character.pendingPartyInvite;
        let marketplace = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "marketplace");
        let craftingbuilding = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "craftingbuilding");
        let currentArea = Globals.connectedUsers[authorIdentifier].character.getArea();
        let tLootSystem = new LootSystem();
        let uIDGuild;
        let tGuildId = 0;
        let firstMention;
        let err = [];
        let apPage;
        let nb;
        let temp;
        let doIHaveThisItem = false;

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_inventory", 1);

        switch (command) {
            case "item":
                let idItemToSee = parseInt(args[0], 10);
                doIHaveThisItem = false;
                if (idItemToSee !== undefined && Number.isInteger(idItemToSee)) {
                    doIHaveThisItem = Globals.connectedUsers[authorIdentifier].character.inv.doIHaveThisItem(idItemToSee);
                    if (doIHaveThisItem) {
                        let typeName = Globals.connectedUsers[authorIdentifier].character.inv.objects[idItemToSee].typeName;
                        let oneEquipped = Globals.connectedUsers[authorIdentifier].character.equipement.objects[this.getEquipableIDType(typeName)] ? true : false;
                        let equippedStats;
                        if (oneEquipped)
                            equippedStats = Globals.connectedUsers[authorIdentifier].character.equipement.objects[this.getEquipableIDType(typeName)].stats;
                        msg = Globals.connectedUsers[authorIdentifier].character.inv.seeThisItem(idItemToSee, equippedStats, lang);
                    } else {
                        msg = "```" + Translator.getString(lang, "errors", "item_you_dont_have_this_item") + "```";
                    }

                } else {
                    idItemToSee = this.getEquipableIDType(args[0]);
                    if (idItemToSee > 0) {
                        msg = Globals.connectedUsers[authorIdentifier].character.equipement.seeThisItem(idItemToSee, lang);
                    } else {
                        msg = "```" + Translator.getString(lang, "errors", "item_choose_id_or_equipement") + "```";
                    }

                }
                break;

            case "itemfav":
                let idItemToFav = parseInt(args[0], 10);
                if (idItemToFav !== undefined && Number.isInteger(idItemToFav)) {
                    if (Globals.connectedUsers[authorIdentifier].character.haveThisObject(idItemToFav)) {
                        Globals.connectedUsers[authorIdentifier].character.setItemFavoriteInv(idItemToFav, true);
                        msg = Translator.getString(lang, "inventory_equipment", "item_tag_as_favorite");
                    } else {
                        msg = Translator.getString(lang, "errors", "item_you_dont_have_this_item");
                    }
                } else {
                    idItemToFav = this.getEquipableIDType(args[0]);
                    if (idItemToFav > 0) {
                        if (Globals.connectedUsers[authorIdentifier].character.haveThisObjectEquipped(idItemToFav) != null) {
                            Globals.connectedUsers[authorIdentifier].character.setItemFavoriteEquip(idItemToFav, true);
                            msg = Translator.getString(lang, "inventory_equipment", "item_tag_as_favorite");
                        } else {
                            msg = Translator.getString(lang, "errors", "item_you_dont_have_this_item");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "item_you_dont_have_this_item");
                    }
                }
                break;

            case "itemunfav":
                let idItemToUnFav = parseInt(args[0], 10);
                if (idItemToUnFav !== undefined && Number.isInteger(idItemToUnFav)) {
                    if (Globals.connectedUsers[authorIdentifier].character.haveThisObject(idItemToUnFav)) {
                        Globals.connectedUsers[authorIdentifier].character.setItemFavoriteInv(idItemToUnFav, false);
                        msg = Translator.getString(lang, "inventory_equipment", "item_untag_as_favorite");
                    } else {
                        msg = Translator.getString(lang, "errors", "item_you_dont_have_this_item");
                    }
                } else {
                    idItemToUnFav = this.getEquipableIDType(args[0]);
                    if (idItemToUnFav > 0) {
                        if (Globals.connectedUsers[authorIdentifier].character.haveThisObjectEquipped(idItemToUnFav) != null) {
                            Globals.connectedUsers[authorIdentifier].character.setItemFavoriteEquip(idItemToUnFav, false);
                            msg = Translator.getString(lang, "inventory_equipment", "item_untag_as_favorite");
                        } else {
                            msg = Translator.getString(lang, "errors", "item_you_dont_have_this_item");
                        }

                    } else {
                        msg = Translator.getString(lang, "errors", "item_you_dont_have_this_item");
                    }
                }
                break;

            case "inv":
            case "inventory":
                let invPage = parseInt(args[0], 10);
                msg = "";
                if (invPage && Number.isInteger(invPage)) {
                    //msg = Globals.connectedUsers[authorIdentifier].character.inv.seeThisItem(invIdItem);
                    msg = Globals.connectedUsers[authorIdentifier].character.inv.toStr(invPage, lang);
                } else {
                    msg = Globals.connectedUsers[authorIdentifier].character.inv.toStr(0, lang);
                }
                break;

            case "sell":
                let sellIdItem = parseInt(args[0], 10);
                let numberOfItemsToSell = parseInt(args[1], 10);
                numberOfItemsToSell = Number.isInteger(numberOfItemsToSell) ? numberOfItemsToSell : 1;
                //console.log(numberOfItemsToSell);
                msg = "";
                if (Globals.areasManager.canISellToThisArea(Globals.connectedUsers[authorIdentifier].character.getIdArea())) {
                    if (sellIdItem !== undefined && Number.isInteger(sellIdItem)) {
                        if (Globals.connectedUsers[authorIdentifier].character.haveThisObject(sellIdItem)) {
                            if (!Globals.connectedUsers[authorIdentifier].character.isItemFavorite(sellIdItem)) {
                                let itemValue = Globals.connectedUsers[authorIdentifier].character.sellThisItem(sellIdItem, numberOfItemsToSell);
                                if (itemValue > 0) {
                                    msg = numberOfItemsToSell == 1 ? Translator.getString(lang, "economic", "sell_for_x", [itemValue]) : Translator.getString(lang, "economic", "sell_for_x_plural", [itemValue]);
                                } else {
                                    // N'arrivera jamais normalement mais bon
                                    msg = Translator.getString(lang, "errors", "item_you_dont_have");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "item_cant_sell_favorite");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "item_you_dont_have");
                        }


                    } else {
                        msg = Translator.getString(lang, "errors", "economic_enter_id_item_to_sell");
                    }
                } else {;
                    msg = Translator.getString(lang, "errors", "economic_have_to_be_in_town");
                }
                break;

            case "sellall":
                if (Globals.areasManager.canISellToThisArea(Globals.connectedUsers[authorIdentifier].character.getIdArea())) {
                    let allSelled = Globals.connectedUsers[authorIdentifier].character.sellAllInventory();
                    if (allSelled > 0) {
                        msg = Translator.getString(lang, "economic", "sell_all_for_x", [allSelled]);
                    } else {
                        msg = Translator.getString(lang, "errors", "economic_cant_sell_nothing");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "economic_have_to_be_in_town");
                }
                break;
        }

        this.sendMessage(message, msg);
    }
}

module.exports = InventoryModule;