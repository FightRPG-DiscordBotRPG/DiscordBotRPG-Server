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

class CraftinModule extends GModule {
    constructor() {
        super();
        this.commands = ["mkmylist", "mkplace", "mkcancel", "mkbuy", "mksearch", "mkshow", "mksee"];
        this.startLoading("Marketplace");
        this.init();
        this.endLoading("Marketplace");
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

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_hdv", 1);

        switch (command) {
            case "mkmylist":
                if (marketplace != null) {
                    msg = marketplace.showCharacterOrders(Globals.connectedUsers[authorIdentifier].character.id, args[0] ? args[0] : 1, lang);
                } else {
                    msg = Translator.getString(lang, "errors", "marketplace_not_exist");
                }
                break;

            case "mkplace":
                let toPlaceIdItem = parseInt(args[0], 10);
                let nbOfItemsToPlace = parseInt(args[1], 10);
                let priceToPlace = parseInt(args[2], 10);
                // si endroit dispose d'un marché
                if (marketplace != null) {
                    // si param ok
                    if (toPlaceIdItem != null && Number.isInteger(toPlaceIdItem)) {
                        // si il a l'objet
                        if (Globals.connectedUsers[authorIdentifier].character.haveThisObject(toPlaceIdItem)) {
                            // si param ok
                            if (priceToPlace != null && Number.isInteger(priceToPlace) && priceToPlace < 18446744073709551615) {
                                priceToPlace = priceToPlace < 0 ? -priceToPlace : priceToPlace;
                                // si param nb of items
                                if (nbOfItemsToPlace != null && Number.isInteger(nbOfItemsToPlace) && nbOfItemsToPlace >= 1) {
                                    // si il a le nb of item 
                                    // nb = amount of player items
                                    nb = Globals.connectedUsers[authorIdentifier].character.getAmountOfThisItem(toPlaceIdItem);
                                    if (nb >= nbOfItemsToPlace) {
                                        if (!Globals.connectedUsers[authorIdentifier].character.isItemFavorite(toPlaceIdItem)) {
                                            if (currentArea.haveOwner()) {
                                                let marketplaceTax = priceToPlace * marketplace.getTax();
                                                if (Globals.connectedUsers[authorIdentifier].character.doIHaveEnoughMoney(marketplaceTax)) {
                                                    // enlever la taxe
                                                    Globals.connectedUsers[authorIdentifier].character.sellToMarketplace(marketplace, toPlaceIdItem, nbOfItemsToPlace, priceToPlace);
                                                    Globals.connectedUsers[authorIdentifier].character.removeMoney(marketplaceTax);
                                                    Guild.addMoney(currentArea.getOwnerID(), marketplaceTax);
                                                    msg = Translator.getString(lang, "marketplace", (nbOfItemsToPlace > 1 ? "placed_plur" : "placed")) + "\n";
                                                    msg += Translator.getString(lang, "marketplace", "you_paid_tax", [marketplaceTax]);
                                                } else {
                                                    msg = Translator.getString(lang, "errors", "marketplace_not_enough_to_pay_tax");
                                                }
                                            } else {
                                                Globals.connectedUsers[authorIdentifier].character.sellToMarketplace(marketplace, toPlaceIdItem, nbOfItemsToPlace, priceToPlace);
                                                msg = Translator.getString(lang, "marketplace", (nbOfItemsToPlace > 1 ? "placed_plur" : "placed"));
                                            }
                                        } else {
                                            msg = Translator.getString(lang, "errors", "marketplace_favorite_sell_impossible");
                                        }
                                    } else {
                                        msg = Translator.getString(lang, "errors", "marketplace_not_this_number_of_item");
                                    }
                                } else {
                                    msg = Translator.getString(lang, "errors", "marketplace_nb_of_item_not_ok");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "marketplace_price_forgotten");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "marketplace_dont_have_object");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "marketplace_id_item_forgotten");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "marketplace_not_exist");
                }
                break;

            case "mkcancel":
                let idOrderToCancel = parseInt(args[0], 10);
                if (marketplace != null) {
                    if (idOrderToCancel != null && Number.isInteger(idOrderToCancel)) {
                        let orderToCancel = marketplace.getThisOrder(idOrderToCancel);
                        if (orderToCancel != null) {
                            if (orderToCancel.idCharacter === Globals.connectedUsers[authorIdentifier].character.id) {
                                Globals.connectedUsers[authorIdentifier].character.marketplaceCollectThisItem(orderToCancel);
                                msg = Translator.getString(lang, "marketplace", orderToCancel.number > 1 ? "retrieve_plur" : "retrieve");
                            } else {
                                msg = Translator.getString(lang, "errors", "marketplace_order_not_yours");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "marketplace_order_dont_exist");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "marketplace_id_to_cancel_forgotten");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "marketplace_not_exist");
                }
                break;

            case "mkbuy":
                let idOrderToBuy = parseInt(args[0], 10);
                let numberOrderToBuy = parseInt(args[1], 10);
                if (marketplace != null) {
                    if (idOrderToBuy != null && Number.isInteger(idOrderToBuy)) {
                        numberOrderToBuy = numberOrderToBuy != null && Number.isInteger(numberOrderToBuy) ? numberOrderToBuy : 1;
                        let orderToBuy = marketplace.getThisOrder(idOrderToBuy);
                        if (orderToBuy != null) {
                            numberOrderToBuy = numberOrderToBuy <= 0 ? 1 : (numberOrderToBuy <= orderToBuy.number ? numberOrderToBuy : orderToBuy.number);
                            if (orderToBuy.idCharacter !== Globals.connectedUsers[authorIdentifier].character.id) {
                                if (Globals.connectedUsers[authorIdentifier].character.doIHaveEnoughMoney(orderToBuy.price * numberOrderToBuy)) {
                                    temp = conn.query("SELECT idUser FROM users WHERE idCharacter = ?", [orderToBuy.idCharacter])[0]["idUser"];
                                    // Recupération de l'objet
                                    Globals.connectedUsers[authorIdentifier].character.marketplaceBuyThisItem(orderToBuy, numberOrderToBuy);

                                    // Puis donne l'argent au vendeur
                                    if (Globals.connectedUsers[temp]) {
                                        Globals.connectedUsers[temp].character.addMoney(orderToBuy.price * numberOrderToBuy);
                                        Globals.connectedUsers[temp].marketTell(Translator.getString(lang, "marketplace", numberOrderToBuy > 1 ? "you_sold_plur" : "you_sold", [numberOrderToBuy, orderToBuy.price * numberOrderToBuy]));
                                    } else {
                                        conn.query("UPDATE characters SET money = money + ? WHERE idCharacter = ?;", [orderToBuy.price * numberOrderToBuy, orderToBuy.idCharacter]);
                                    }

                                    PStatistics.incrStat(orderToBuy.idCharacter, "gold_marketplace", orderToBuy.price * numberOrderToBuy);

                                    msg = Translator.getString(lang, "marketplace", numberOrderToBuy > 1 ? "you_buy_plur" : "you_buy", [numberOrderToBuy, orderToBuy.price * numberOrderToBuy]);
                                } else {
                                    msg = Translator.getString(lang, "errors", "marketplace_not_enough_money");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "marketplace_order_yours");
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "marketplace_order_dont_exist");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "marketplace_id_to_buy_forgotten");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "marketplace_not_exist");
                }
                break;


            case "mksearch":
                if (marketplace != null) {
                    msg = marketplace.showSearchOrder(args[0] ? args[0] : "", args[1] ? args[1] : 1, args[2] ? args[2] : 1, lang);
                } else {
                    msg = Translator.getString(lang, "errors", "marketplace_not_exist");
                }
                break;

            case "mkshow":
                if (marketplace != null) {
                    msg = marketplace.showAll(args[0], lang);
                } else {
                    msg = Translator.getString(lang, "errors", "marketplace_not_exist");
                }
                break;

            case "mksee":
                if (marketplace != null) {
                    let mkToSeeOrder = marketplace.getThisOrder(args[0]);
                    if (mkToSeeOrder != null) {
                        msg = marketplace.showItemOrder(args[0], Globals.connectedUsers[authorIdentifier].character, lang);
                    } else {
                        msg = Translator.getString(lang, "errors", "marketplace_order_dont_exist");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "marketplace_not_exist");
                }
                break;
        }

        this.sendMessage(message, msg);
    }
}

module.exports = CraftinModule;