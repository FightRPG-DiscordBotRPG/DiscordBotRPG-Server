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
const Monster = require("../../Entities/Monster");
const Translator = require("../../Translator/Translator");
const CraftSystem = require("../../CraftSystem/CraftSystem");
const AreaTournament = require("../../AreaTournament/AreaTournament");
const PStatistics = require("../../Achievement/PStatistics");
const Craft = require("../../CraftSystem/Craft");
const Item = require("../../Items/Item");
const Emojis = require("../../Emojis");
const express = require("express");


class ShopModule extends GModule {
    constructor() {
        super();
        this.commands = ["sbuy", "sitems"];
        this.startLoading("Shop");
        this.init();
        this.endLoading("Shop");
    }
    init() {
        this.router = express.Router();

        // Add to router needed things
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_shop", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.freeLockedMembers();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/items/:page?", async (req, res, next) => {
            let data = {};

            if (res.locals.shop != null) {
                let toApi = await res.locals.shop.itemsToApi(req.params.page, res.locals.lang);
                if (await res.locals.currentArea.haveOwner()) {
                    toApi.tax = true;
                } else {
                    toApi.tax = false;
                }
                data = toApi;
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "shop_no_building");
            }
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/buy", async (req, res, next) => {
            let data = {};
            data.lang = res.locals.lang;

            let toBuy = parseInt(req.body.idItem, 10);
            let amount = parseInt(req.body.amount, 10);
            amount = amount > 0 ? amount : 1;

            if (res.locals.shop != null) {
                if (!isNaN(toBuy)) {
                    let item = await res.locals.shop.getItem(toBuy);
                    if (item != null) {
                        let totalPrice = item.price * amount;
                        let tax = 0;
                        if (await res.locals.currentArea.haveOwner()) {
                            tax = Math.round(await res.locals.shop.getTax() * totalPrice);
                            totalPrice = totalPrice + tax;
                        }
                        if (await Globals.connectedUsers[res.locals.id].character.doIHaveEnoughMoney(totalPrice)) {
                            if (await res.locals.tLootSystem.giveToPlayer(Globals.connectedUsers[res.locals.id].character, item.idBase, item.level, amount)) {
                                if (tax > 0) {
                                    await Guild.addMoney(await res.locals.currentArea.getOwnerID(), tax);
                                }
                                await Globals.connectedUsers[res.locals.id].character.removeMoney(totalPrice);
                                data.success = Translator.getString(res.locals.lang, "shop", "you_buy", [item.getName(res.locals.lang), amount, totalPrice]);
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "shop_item_dont_exist");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "marketplace_not_enough_money");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "shop_item_dont_exist");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "shop_item_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "shop_no_building");
            }
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

    }

}

module.exports = ShopModule;