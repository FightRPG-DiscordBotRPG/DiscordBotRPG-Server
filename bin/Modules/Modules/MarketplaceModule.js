const GModule = require("../GModule");
const Discord = require("discord.js");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
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
const express = require("express");

class MarketplaceModule extends GModule {
    constructor() {
        super();
        this.commands = ["mkmylist", "mkplace", "mkcancel", "mkbuy", "mksearch", "mkshow", "mksee"];
        this.startLoading("Marketplace");
        this.init();
        this.endLoading("Marketplace");
    }
    init() {
        this.router = express.Router();

        // Add to router needed things
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_hdv", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/mylist/:page?", async (req, res) => {
            let data = {};
            if (res.locals.marketplace != null) {
                data = await res.locals.marketplace.apiCharacterOrders(Globals.connectedUsers[res.locals.id].character.id, req.params.page ? req.params.page : 1, res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_exist");
            }
            data.lang = res.locals.lang;
            return res.json(data);

        });

        this.router.post("/place", async (req, res) => {
            let data = {};
            data.lang = res.locals.lang;
            let toPlaceIdItem = parseInt(req.body.idItem, 10);
            let nbOfItemsToPlace = parseInt(req.body.number, 10);
            let priceToPlace = parseInt(req.body.price, 10);
            // si endroit dispose d'un marché
            if (res.locals.marketplace != null) {
                // si param ok
                if (toPlaceIdItem != null && Number.isInteger(toPlaceIdItem)) {
                    // si il a l'objet
                    if (await Globals.connectedUsers[res.locals.id].character.haveThisObject(toPlaceIdItem)) {
                        // si param ok
                        if (priceToPlace != null && Number.isInteger(priceToPlace) && priceToPlace < 18446744073709551615) {
                            priceToPlace = priceToPlace < 0 ? -priceToPlace : priceToPlace;
                            // si param nb of items
                            if (nbOfItemsToPlace != null && Number.isInteger(nbOfItemsToPlace) && nbOfItemsToPlace >= 1) {
                                // si il a le nb of item 
                                // nb = amount of player items
                                let nb = await Globals.connectedUsers[res.locals.id].character.getAmountOfThisItem(toPlaceIdItem);
                                if (nb >= nbOfItemsToPlace) {
                                    if (!await Globals.connectedUsers[res.locals.id].character.isItemFavorite(toPlaceIdItem)) {
                                        if (await res.locals.currentArea.haveOwner()) {
                                            let marketplaceTax = Math.round(priceToPlace * await res.locals.marketplace.getTax());
                                            if (await Globals.connectedUsers[res.locals.id].character.doIHaveEnoughMoney(marketplaceTax)) {
                                                // enlever la taxe
                                                await Promise.all([
                                                    Globals.connectedUsers[res.locals.id].character.sellToMarketplace(res.locals.marketplace, toPlaceIdItem, nbOfItemsToPlace, priceToPlace),
                                                    Globals.connectedUsers[res.locals.id].character.removeMoney(marketplaceTax),
                                                    Guild.addMoney(await res.locals.currentArea.getOwnerID(), marketplaceTax)
                                                ])

                                                data.success = Translator.getString(res.locals.lang, "marketplace", (nbOfItemsToPlace > 1 ? "placed_plur" : "placed")) + "\n";
                                                data.success += Translator.getString(res.locals.lang, "marketplace", "you_paid_tax", [marketplaceTax]);
                                            } else {
                                                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_enough_to_pay_tax");
                                            }
                                        } else {
                                            await Globals.connectedUsers[res.locals.id].character.sellToMarketplace(res.locals.marketplace, toPlaceIdItem, nbOfItemsToPlace, priceToPlace);
                                            data.success = Translator.getString(res.locals.lang, "marketplace", (nbOfItemsToPlace > 1 ? "placed_plur" : "placed"));
                                        }
                                    } else {
                                        data.error = Translator.getString(res.locals.lang, "errors", "marketplace_favorite_sell_impossible");
                                    }
                                } else {
                                    data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_this_number_of_item");
                                }
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_nb_of_item_not_ok");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "marketplace_price_forgotten");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "marketplace_dont_have_object");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "marketplace_id_item_forgotten");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_exist");
            }
            return res.json(data);

        });

        this.router.post("/cancel", async (req, res) => {
            let data = {};
            let idOrderToCancel = parseInt(req.body.idItem, 10);
            if (res.locals.marketplace != null) {
                if (idOrderToCancel != null && Number.isInteger(idOrderToCancel)) {
                    let orderToCancel = await res.locals.marketplace.getThisOrder(idOrderToCancel);
                    if (orderToCancel != null) {
                        if (orderToCancel.idCharacter === Globals.connectedUsers[res.locals.id].character.id) {
                            await Globals.connectedUsers[res.locals.id].character.marketplaceCollectThisItem(orderToCancel);
                            data.success = Translator.getString(res.locals.lang, "marketplace", orderToCancel.number > 1 ? "retrieve_plur" : "retrieve");
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "marketplace_order_not_yours");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "marketplace_order_dont_exist");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "marketplace_id_to_cancel_forgotten");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_exist");
            }
            data.lang = res.locals.lang;
            return res.json(data);

        });

        this.router.post("/buy", async (req, res) => {
            let data = {};
            let idOrderToBuy = parseInt(req.body.idItem, 10);
            let numberOrderToBuy = parseInt(req.body.number, 10);
            if (res.locals.marketplace != null) {
                if (idOrderToBuy != null && Number.isInteger(idOrderToBuy)) {
                    numberOrderToBuy = numberOrderToBuy != null && Number.isInteger(numberOrderToBuy) ? numberOrderToBuy : 1;
                    let orderToBuy = await res.locals.marketplace.getThisOrder(idOrderToBuy);
                    if (orderToBuy != null) {
                        numberOrderToBuy = numberOrderToBuy <= 0 ? 1 : (numberOrderToBuy <= orderToBuy.number ? numberOrderToBuy : orderToBuy.number);
                        if (orderToBuy.idCharacter !== Globals.connectedUsers[res.locals.id].character.id) {
                            if (await Globals.connectedUsers[res.locals.id].character.doIHaveEnoughMoney(orderToBuy.price * numberOrderToBuy)) {
                                let temp = (await conn.query("SELECT idUser FROM users WHERE idCharacter = ?", [orderToBuy.idCharacter]))[0]["idUser"];
                                // Recupération de l'objet
                                await Globals.connectedUsers[res.locals.id].character.marketplaceBuyThisItem(orderToBuy, numberOrderToBuy);
                                // Puis donne l'argent au vendeur
                                if (Globals.connectedUsers[temp]) {
                                    await Globals.connectedUsers[temp].character.addMoney(orderToBuy.price * numberOrderToBuy);
                                    Globals.connectedUsers[temp].marketTell(Translator.getString(Globals.connectedUsers[temp].getLang(), "marketplace", numberOrderToBuy > 1 ? "you_sold_plur" : "you_sold", [numberOrderToBuy, orderToBuy.price * numberOrderToBuy]));
                                } else {
                                    await conn.query("UPDATE characters SET money = money + ? WHERE idCharacter = ?;", [orderToBuy.price * numberOrderToBuy, orderToBuy.idCharacter]);
                                }

                                PStatistics.incrStat(orderToBuy.idCharacter, "gold_marketplace", orderToBuy.price * numberOrderToBuy);

                                data.success = Translator.getString(res.locals.lang, "marketplace", numberOrderToBuy > 1 ? "you_buy_plur" : "you_buy", [numberOrderToBuy, orderToBuy.price * numberOrderToBuy]);
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_enough_money");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "marketplace_order_yours");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "marketplace_order_dont_exist");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "marketplace_id_to_buy_forgotten");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_exist");
            }
            data.lang = res.locals.lang;
            return res.json(data);

        });

        this.router.get("/search", async (req, res) => {
            let data = {};
            //itemName, level, page, lang
            if (res.locals.marketplace != null) {
                data = await res.locals.marketplace.apiSearchOrder(req.query.itemName ? req.query.itemName : "", req.query.level ? req.query.level : 1, req.query.page ? req.query.page : 1, res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_exist");
            }

            data.lang = res.locals.lang;
            return res.json(data);

        });

        this.router.get("/show/:page?", async (req, res) => {
            let data = {};
            if (res.locals.marketplace != null) {
                data = await res.locals.marketplace.apiShowAll(req.params.page, res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_exist");
            }

            data.lang = res.locals.lang;
            return res.json(data);

        });

        this.router.get("/show/item/:idItem?", async (req, res) => {
            let data = {};
            if (res.locals.marketplace != null) {
                let mkToSeeOrder = await res.locals.marketplace.getThisOrder(req.params.idItem);
                if (mkToSeeOrder != null) {
                    data = await res.locals.marketplace.apiItemOrder(req.params.idItem, Globals.connectedUsers[res.locals.id].character, res.locals.lang);
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "marketplace_order_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_exist");
            }

            data.lang = res.locals.lang;
            return res.json(data);

        });


    }
}

module.exports = MarketplaceModule;