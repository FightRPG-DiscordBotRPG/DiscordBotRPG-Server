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


class InventoryModule extends GModule {
    constructor() {
        super();
        this.commands = ["item", "itemfav", "itemunfav", "inv", "inventory", "sell", "sellall", "sendmoney"];
        this.startLoading("Inventory");
        this.init();
        this.endLoading("Inventory");
    }

    init() {
        this.router = express.Router();

        // Add to router needed things
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_inventory", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/item/:idItem?", async (req, res) => {
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
                    let equippedStats = await Globals.connectedUsers[res.locals.id].character.getEquipement().getItem(this.getEquipableIDType(itemToSee.typeName));
                    if (equippedStats != null)
                        equippedStats = equippedStats.stats;
                    else
                        equippedStats = {};
                    data.item = await itemToSee.toApi(res.locals.lang);;
                    data.equippedStats = equippedStats;
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
            return res.json(data);

        });

        this.router.post("/itemfav", async (req, res) => {
            let data = {};
            data.lang = res.locals.lang;

            let idItemToFav = parseInt(req.body.idItem, 10);
            let isRealID = req.body.isRealID;
            if (idItemToFav != null && Number.isInteger(idItemToFav)) {
                if (isRealID == null || isRealID == false) {
                    if (await Globals.connectedUsers[res.locals.id].character.haveThisObject(idItemToFav)) {
                        await Globals.connectedUsers[res.locals.id].character.setItemFavoriteInv(idItemToFav, true);
                        data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_tag_as_favorite");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                    }
                } else {
                    let itemToFav = await Globals.connectedUsers[res.locals.id].character.getItemFromAllInventories(idItemToFav);
                    if (itemToFav != null) {
                        await itemToFav.setFavorite(true);
                        data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_tag_as_favorite");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                    }
                }
            } else {
                idItemToFav = this.getEquipableIDType(req.body.idItem);
                if (idItemToFav > 0) {
                    if (await Globals.connectedUsers[res.locals.id].character.haveThisObjectEquipped(idItemToFav) != null) {
                        await Globals.connectedUsers[res.locals.id].character.setItemFavoriteEquip(idItemToFav, true);
                        data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_tag_as_favorite");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                }
            }
            return res.json(data);
        });

        this.router.post("/itemunfav", async (req, res) => {
            let data = {};
            data.lang = res.locals.lang;

            let idItemToUnFav = parseInt(req.body.idItem, 10);
            let isRealID = req.body.isRealID;
            if (idItemToUnFav != null && Number.isInteger(idItemToUnFav)) {
                if (isRealID == null || isRealID == false) {
                    if (await Globals.connectedUsers[res.locals.id].character.haveThisObject(idItemToUnFav)) {
                        await Globals.connectedUsers[res.locals.id].character.setItemFavoriteInv(idItemToUnFav, false);
                        data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_untag_as_favorite");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                    }
                } else {
                    let itemToUnFav = await Globals.connectedUsers[res.locals.id].character.getItemFromAllInventories(idItemToUnFav);
                    if (itemToUnFav != null) {
                        await itemToUnFav.setFavorite(false);
                        data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_untag_as_favorite");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                    }
                }

            } else {
                idItemToUnFav = this.getEquipableIDType(req.body.idItem);
                if (idItemToUnFav > 0) {
                    if (await Globals.connectedUsers[res.locals.id].character.haveThisObjectEquipped(idItemToUnFav) != null) {
                        await Globals.connectedUsers[res.locals.id].character.setItemFavoriteEquip(idItemToUnFav, false);
                        data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_untag_as_favorite");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_this_item");
                }
            }

            return res.json(data);
        });

        this.router.get("/show/:page?", async (req, res) => {
            let data = {};
            let params = {
                rarity: 0,
                type: 0,
                level: 0
            }
            if (req.query.idRarity != null) {
                params.rarity = parseInt(req.query.idRarity);
            } else if (req.query.idType != null) {
                params.type = parseInt(req.query.idType);
            } else if (req.query.level != null) {
                params.level = parseInt(req.query.level);
            }
            let invPage = parseInt(req.params.page, 10);
            if (invPage == null || invPage != null && !Number.isInteger(invPage)) {
                invPage = 0;
            }

            data = await Globals.connectedUsers[res.locals.id].character.inv.toApi(invPage, res.locals.lang, params);

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/sell", async (req, res) => {
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

            return res.json(data);
        });

        this.router.post("/sellall", async (req, res) => {
            let data = {};
            data.lang = res.locals.lang;
            let params = {
                rarity: 0,
                type: 0,
                level: 0
            }

            if (req.body.idRarity != null) {
                params.rarity = parseInt(req.body.idRarity);
            } else if (req.body.idType != null) {
                params.type = parseInt(req.body.idType);
            } else if (req.body.level != null) {
                params.level = parseInt(req.body.level);
            }

            if (Globals.areasManager.canISellToThisArea(Globals.connectedUsers[res.locals.id].character.getIdArea())) {
                let allSelled = await Globals.connectedUsers[res.locals.id].character.sellAllInventory(params);
                if (allSelled > 0) {
                    data.success = Translator.getString(res.locals.lang, "economic", "sell_all_for_x", [allSelled]);
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "economic_cant_sell_nothing");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "economic_have_to_be_in_town");
            }

            return res.json(data);
        });

        this.router.post("/sendmoney", async (req, res) => {
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
                        await userReceiveMoney.loadUser();
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

            return res.json(data);
        });


    }

}

module.exports = InventoryModule;