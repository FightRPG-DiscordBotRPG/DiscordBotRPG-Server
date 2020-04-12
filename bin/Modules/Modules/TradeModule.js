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
const Trade = require("../../Trades/Trade");


class TradeModule extends GModule {
    constructor() {
        super();
        this.commands = ["tpropose", "tcancel", "taccept", "tshow", "titem", "tadd", "tremove", "tsetmoney", "tvalidate"];
        this.startLoading("Trade");
        this.init();
        this.endLoading("Trade");
    }
    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_trade", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.freeLockedMembers();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.post("/notifications/mute", async (req, res, next) => {
            let data = {}

            await Globals.connectedUsers[res.locals.id].muteTrade(true);
            data.success = Translator.getString(res.locals.lang, "trade", "now_muted");

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/notifications/unmute", async (req, res, next) => {
            let data = {}

            await Globals.connectedUsers[res.locals.id].muteTrade(false);
            data.success = Translator.getString(res.locals.lang, "trade", "now_unmuted");

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/cancel", async (req, res, next) => {
            let data = {}
            let trade = res.locals.trade;
            if (trade != null) {
                trade.cancel(Globals.connectedUsers[res.locals.id]);
                data.success = Translator.getString(res.locals.lang, "trade", "you_cancelled");
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "trade_not_in_trade");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/propose", async (req, res, next) => {
            let data = {}

            if (req.body.mention) {
                if (req.body.mention != res.locals.id) {
                    if (Globals.connectedUsers[req.body.mention]) {
                        if (Globals.connectedUsers[req.body.mention].character.trade === null) {
                            if (Globals.connectedUsers[req.body.mention].character.pendingTradeInvite == null) {
                                /**
                                 * @type {Trade}
                                 */
                                let trade = res.locals.trade;

                                // Creation d'un trade si pas dans un trade
                                if (trade == null) {
                                    Globals.connectedUsers[res.locals.id].character.trade = new Trade(Globals.connectedUsers[res.locals.id]);
                                }
                                trade = Globals.connectedUsers[res.locals.id].character.trade;

                                if (trade.pendingProposal == null && trade.playerTwo == null) {
                                    trade.propose(Globals.connectedUsers[req.body.mention]);

                                    Globals.connectedUsers[req.body.mention].tradeTell(Translator.getString(Globals.connectedUsers[req.body.mention].getLang(), "trade", "someone_proposed_you", [Globals.connectedUsers[res.locals.id].username, "::tradeaccept", "::tradedecline"]));
                                    data.success = Translator.getString(res.locals.lang, "trade", "proposal_sent");
                                } else {
                                    data.error = Translator.getString(res.locals.lang, "errors", "trade_cant_propose_more");
                                }

                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "trade_proposal_waiting");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "trade_propose_already_in_trade");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "trade_user_not_connected");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "trade_cant_propose_yourself");
                }
            } else {
                // error
                data.error = "Use the command like this \"::tpropose @someone\"";
            }


            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/accept", async (req, res, next) => {
            let data = {}
            let trade = res.locals.trade;
            /**
             * @type {Trade}
             */
            let pending = res.locals.pendingTrade;


            if (trade == null) {
                if (pending != null) {
                    pending.accept(Globals.connectedUsers[res.locals.id]);
                    data.success = Translator.getString(res.locals.lang, "trade", "you_accepted");
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "trade_you_dont_receive_invitation");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "trade_already_in_trade");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/show", async (req, res, next) => {
            let data = {}
            let trade = res.locals.trade;

            if (trade != null) {
                data = await trade.toApi(res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "trade_not_in_trade");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/item/show/:idEmplacement?", async (req, res, next) => {
            let data = {}
            let trade = res.locals.trade;

            if (trade != null) {
                data = await trade.itemToApi(req.params.idEmplacement, res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "trade_not_in_trade");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/money/set", async (req, res, next) => {
            let data = {}
            let trade = res.locals.trade;

            if (trade != null) {
                data = await trade.setMoney(Globals.connectedUsers[res.locals.id], req.body.number);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "trade_not_in_trade");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/item/add", async (req, res, next) => {
            let data = {}
            let trade = res.locals.trade;

            if (trade != null) {
                data = await trade.addItem(Globals.connectedUsers[res.locals.id], req.body.idEmplacement, req.body.number);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "trade_not_in_trade");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/item/remove", async (req, res, next) => {
            let data = {}
            let trade = res.locals.trade;

            if (trade != null) {
                data = await trade.removeItem(Globals.connectedUsers[res.locals.id], req.body.idEmplacement, req.body.number);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "trade_not_in_trade");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/validate", async (req, res, next) => {
            let data = {}
            let trade = res.locals.trade;

            if (trade != null) {
                data = await trade.validate(Globals.connectedUsers[res.locals.id]);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "trade_not_in_trade");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });



    }
}

module.exports = TradeModule;