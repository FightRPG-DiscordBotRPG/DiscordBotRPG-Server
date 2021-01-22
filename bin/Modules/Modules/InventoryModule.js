const GModule = require("../GModule");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
const Guild = require("../../Guild");
const Group = require("../../Group");
const Fight = require("../../Fight/Fight");
const Monster = require("../../Entities/Monster");
const Translator = require("../../Translator/Translator");
const CraftSystem = require("../../CraftSystem/CraftSystem");
const AreaTournament = require("../../AreaTournament/AreaTournament");
const PStatistics = require("../../Achievement/PStatistics");
const Craft = require("../../CraftSystem/Craft");
const Item = require("../../Items/Item");
const Emojis = require("../../Emojis");
const express = require("express");


class InventoryModule extends GModule {
    constructor() {
        super();
        this.commands = ["item", "itemfav", "itemunfav", "inv", "inventory", "sell", "sellall", "sendmoney"];
        this.startLoading("Inventory");
        this.init();
        this.endLoading("Inventory");
    }

    init() {
        super.init();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_inventory", 1);
            next();
        });
    }

    loadRoutes() {
        this.router.get("/item/:idItem?", async (req, res, next) => {
            let idItemToSee = parseInt(req.params.idItem, 10);
            let doIHaveThisItem = false;
            let itemToSee;
            let data = {};
            data.lang = res.locals.lang;

            if (req.params.idItem == "last") {
                let idInventory = await Globals.connectedUsers[res.locals.id].character.getInv().getNumberOfItem();
                idItemToSee = idInventory;
            }

            if (idItemToSee != null && Number.isInteger(idItemToSee)) {
                doIHaveThisItem = await Globals.connectedUsers[res.locals.id].character.getInv().doIHaveThisItem(idItemToSee);
                if (doIHaveThisItem) {
                    itemToSee = await Globals.connectedUsers[res.locals.id].character.getInv().getItem(idItemToSee);
                    let equippedItem = await Globals.connectedUsers[res.locals.id].character.getEquipement().getItem(this.getEquipableIDType(itemToSee.typeName));

                    let equippedStats = {};
                    let equippedSecondaryStats = {};

                    if (equippedItem != null) {
                        equippedStats = equippedItem.stats.toApi();
                        equippedSecondaryStats = equippedItem.secondaryStats.toApi();
                    }

                    data.item = await itemToSee.toApi(res.locals.lang);;
                    data.equippedStats = equippedStats;
                    data.equippedSecondaryStats = equippedSecondaryStats;
                    data.idInInventory = idItemToSee;
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                }
            } else {
                data.idInInventory = req.params.idItem;
                idItemToSee = this.getEquipableIDType(req.params.idItem);
                if (idItemToSee > 0) {
                    itemToSee = await Globals.connectedUsers[res.locals.id].character.getEquipement().getItem(idItemToSee);
                    if (itemToSee != null) {
                        data.item = await itemToSee.toApi(res.locals.lang);
                    } else {
                        data.error = Translator.getString(res.locals.lang, "inventory_equipment", "nothing_in_this_slot");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_choose_id_or_equipement");
                }
            }
            await next();
            return res.json(data);

        });

        this.router.post("/itemfav", async (req, res, next) => {
            let data = await this.setFavoriteValueItem(req, res, true);
            await next();
            return res.json(data);
        });

        this.router.post("/itemunfav", async (req, res, next) => {
            let data = await this.setFavoriteValueItem(req, res, false);

            await next();
            return res.json(data);
        });

        this.router.get("/show/:page?", async (req, res, next) => {
            let data = {};
            let params = this.getSearchParams(req);
            let invPage = parseInt(req.params.page, 10);
            if (invPage == null || invPage != null && !Number.isInteger(invPage)) {
                invPage = 0;
            }

            data = await Globals.connectedUsers[res.locals.id].character.inv.toApi(invPage, res.locals.lang, params);

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/sell", async (req, res, next) => {
            let data = {};
            data.lang = res.locals.lang;

            let sellIdItem = parseInt(req.body.idItem, 10);
            let isRealID = req.body.isRealID;
            let numberOfItemsToSell = parseInt(req.body.number, 10);
            numberOfItemsToSell = Number.isInteger(numberOfItemsToSell) ? numberOfItemsToSell : 1;

            if (Globals.areasManager.canISellToThisArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                if (sellIdItem != null && Number.isInteger(sellIdItem)) {
                    if (isRealID == null || isRealID == false) {
                        if (await Globals.connectedUsers[res.locals.id].character.haveThisObject(sellIdItem)) {
                            if (!await Globals.connectedUsers[res.locals.id].character.isItemFavorite(sellIdItem)) {
                                let itemValue = await Globals.connectedUsers[res.locals.id].character.sellThisItem(sellIdItem, numberOfItemsToSell);
                                if (itemValue > 0) {
                                    data.success = numberOfItemsToSell == 1 ? Translator.getString(res.locals.lang, "economic", "sell_for_x", [itemValue]) : Translator.getString(res.locals.lang, "economic", "sell_for_x_plural", [itemValue]);
                                } else {
                                    // N'arrivera jamais normalement mais bon
                                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have");
                                }
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "item_cant_sell_favorite");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have");
                        }
                    } else {
                        let itemToSell = await Globals.connectedUsers[res.locals.id].character.getInv().getItemOfThisIDItem(sellIdItem);
                        if (itemToSell != null) {
                            if (itemToSell.isFavorite == false) {
                                let itemValue = await Globals.connectedUsers[res.locals.id].character.sellThisItemWithItem(itemToSell, numberOfItemsToSell);
                                if (itemValue > 0) {
                                    data.success = numberOfItemsToSell == 1 ? Translator.getString(res.locals.lang, "economic", "sell_for_x", [itemValue]) : Translator.getString(res.locals.lang, "economic", "sell_for_x_plural", [itemValue]);
                                } else {
                                    // N'arrivera jamais normalement mais bon
                                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have");
                                }
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "item_cant_sell_favorite");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have");
                        }
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "economic_enter_id_item_to_sell");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "economic_have_to_be_in_town");
            }

            await next();
            return res.json(data);
        });

        this.router.post("/sellall", async (req, res, next) => {
            let data = await this.commonSellChecks(req, res);

            if (!data.error) {
                let allSelled = await Globals.connectedUsers[res.locals.id].character.sellAllInventory(data.params, data.lang);
                if (allSelled > 0) {
                    data.success = Translator.getString(res.locals.lang, "economic", "sell_all_for_x", [allSelled]);
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "economic_cant_sell_nothing");
                }
            }

            await next();
            return res.json(data);
        });

        this.router.post("/sellall/value", async (req, res, next) => {
            let data = await this.commonSellChecks(req, res);
            if (!data.error) {
                let sellData = await Globals.connectedUsers[res.locals.id].character.getInv().getAllInventoryValue(data.params, data.lang);
                data.value = sellData.value;
                data.isFiltered = sellData.isFiltered;
            }

            await next();
            return res.json(data);
        });

        this.router.post("/sendmoney", async (req, res, next) => {
            let data = {};
            data.lang = res.locals.lang;

            // req.body.id, req.body.isMention, req.body.amount

            let idOtherPlayerCharacter = 0;
            let mId = -1;
            // Ici on récupère l'id
            if (req.body.isMention) {
                mId = req.body.id;
            } else if (req.body.id) {
                idOtherPlayerCharacter = parseInt(req.body.id, 10);
                if (idOtherPlayerCharacter && Number.isInteger(idOtherPlayerCharacter)) {
                    mId = await User.getIDByIDCharacter(idOtherPlayerCharacter);
                }
            }

            let userSendMoney, userReceiveMoney;

            // Si connecté
            if (Globals.connectedUsers[mId]) {
                if (res.locals.id !== mId) {
                    userSendMoney = Globals.connectedUsers[res.locals.id];
                    userReceiveMoney = Globals.connectedUsers[mId];
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "economic_cant_send_money_to_youself");
                }
            } else {
                if (mId != -1 && await User.exist(mId)) {
                    if (res.locals.id !== mId) {
                        userSendMoney = Globals.connectedUsers[res.locals.id];
                        userReceiveMoney = new User(mId);
                        await userReceiveMoney.lightLoad();
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "economic_cant_send_money_to_youself");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "generic_user_dont_exist");
                }
            }

            if (userSendMoney != null && userReceiveMoney != null) {
                req.body.amount = parseInt(req.body.amount, 10);
                if (req.body.amount > 0) {
                    if (await userSendMoney.character.doIHaveEnoughMoney(req.body.amount)) {
                        await Promise.all([
                            userSendMoney.character.removeMoney(req.body.amount),
                            userReceiveMoney.character.addMoney(req.body.amount),
                        ])
                        data.success = Translator.getString(res.locals.lang, "economic", "send_money_to", [req.body.amount, userReceiveMoney.getUsername()]);
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "economic_dont_have_enough_money");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "economic_minimum_send_gold");
                }
            }

            await next();
            return res.json(data);
        });


    }

    /**
     * 
     * @param {any} req
     * @param {any} res
     * @param {boolean} toFavorite True if you fav the item, false if unfav it
     */
    async setFavoriteValueItem(req, res, toFavorite) {

        let data = {};
        data.lang = res.locals.lang;

        let idItemFav = parseInt(req.body.idItem, 10);
        let isRealID = req.body.isRealID;

        let favoriteTextKey = toFavorite === true ? "item_tag_as_favorite" : "item_untag_as_favorite";
        if (idItemFav != null && Number.isInteger(idItemFav)) {
            if (isRealID == null || isRealID == false) {
                if (await Globals.connectedUsers[res.locals.id].character.haveThisObject(idItemFav)) {
                    let item = await Globals.connectedUsers[res.locals.id].character.setItemFavoriteInv(idItemFav, toFavorite);
                    data.success = Translator.getString(res.locals.lang, "inventory_equipment", favoriteTextKey, [item.getName(data.lang)]);
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                }
            } else {
                let itemFav = await Globals.connectedUsers[res.locals.id].character.getItemFromAllInventories(idItemFav);
                if (itemFav != null) {
                    await itemFav.setFavorite(toFavorite);
                    data.success = Translator.getString(res.locals.lang, "inventory_equipment", favoriteTextKey, [itemFav.getName(data.lang)]);
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                }
            }
        } else {
            idItemFav = this.getEquipableIDType(req.body.idItem);
            if (idItemFav > 0) {
                if (await Globals.connectedUsers[res.locals.id].character.haveThisObjectEquipped(idItemFav) != null) {
                    let item = await Globals.connectedUsers[res.locals.id].character.setItemFavoriteEquip(idItemFav, toFavorite);
                    data.success = Translator.getString(res.locals.lang, "inventory_equipment", favoriteTextKey, [item.getName(data.lang)]);
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
            }
        }

        return data;
    }

    async commonSellChecks(req, res) {
        let data = {};
        data.lang = res.locals.lang;

        if (!Globals.areasManager.canISellToThisArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
            data.error = Translator.getString(res.locals.lang, "errors", "economic_have_to_be_in_town");
        } else {
            data.params = this.getSearchParams(req);
        }
        return data;
    }

}

module.exports = InventoryModule;