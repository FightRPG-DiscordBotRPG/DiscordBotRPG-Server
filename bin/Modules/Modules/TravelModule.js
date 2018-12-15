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


class TravelModule extends GModule {
    constructor() {
        super();
        this.commands = ["area", "areas", "travel", "travelregion", "areaplayers"];
        this.startLoading("Travel");
        this.init();
        this.endLoading("Travel");
    }

    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_areas", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/area", async (req, res) => {
            let data = {}
            data.area = Globals.areasManager.thisAreaToApi(res.locals.currentArea.id, res.locals.lang);
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/region", async (req, res) => {
            let data = {}
            data.region = Globals.areasManager.thisRegionToApi(res.locals.currentArea, res.locals.lang);
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/info/:idArea?", async (req, res) => {
            let data = {}
            let wantedAreaToTravel = parseInt(req.params.idArea, 10);
            if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
                if (Globals.areasManager.existInRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel)) {
                    let areaObjectTravel = Globals.areasManager.getAreaForThisRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel);
                    if (areaObjectTravel.getID() == Globals.connectedUsers[res.locals.id].character.getIdArea()) {
                        data.error = Translator.getString(res.locals.lang, "errors", "travel_already_here");
                    } else {
                        let costs = Globals.areasManager.getPathCosts(Globals.connectedUsers[res.locals.id].character.getIdArea(), areaObjectTravel.getID());
                        let realWaitTime = Globals.connectedUsers[res.locals.id].character.getWaitTimeTravel(costs.timeToWait) / 1000;
                        data = {
                            from_name: Globals.connectedUsers[res.locals.id].character.getArea().getName(res.locals.lang),
                            to_name: areaObjectTravel.getName(res.locals.lang),
                            realWaitTime: realWaitTime,
                            costs: costs,
                        }
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "travel_area_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "travel_tired_wait_x", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/toarea", async (req, res) => {
            let data = {}
            let wantedAreaToTravel = parseInt(req.body.idArea, 10);
            if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
                if (Globals.areasManager.existInRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel)) {
                    let areaObjectTravel = Globals.areasManager.getAreaForThisRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel);
                    if (areaObjectTravel.getID() == Globals.connectedUsers[res.locals.id].character.getIdArea()) {
                        data.error = Translator.getString(res.locals.lang, "errors", "travel_already_here");
                    } else {
                        let costs = Globals.areasManager.getPathCosts(Globals.connectedUsers[res.locals.id].character.getIdArea(), areaObjectTravel.getID());
                        // Get area to switch
                        wantedAreaToTravel = Globals.areasManager.getArea(areaObjectTravel.getID());
                        // change de zone
                        Globals.connectedUsers[res.locals.id].character.changeArea(wantedAreaToTravel, costs.timeToWait);

                        // Messages
                        data.success = Translator.getString(res.locals.lang, "travel", "travel_to_area", [wantedAreaToTravel.getName(res.locals.lang)]) + "\n" + Translator.getString(res.locals.lang, "travel", "travel_to_area_exhaust", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "travel_area_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "travel_tired_wait_x", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/inforegion/:idArea?", async (req, res) => {
            let data = {}
            let wantedAreaToTravel = parseInt(req.params.idArea, 10);
            if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
                if (Globals.areasManager.isConnectedToRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel)) {
                    let areaObjectTravel = Globals.areasManager.getConnectedAreaForThisRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel);
                    if (areaObjectTravel.getID() == Globals.connectedUsers[res.locals.id].character.getIdArea()) {
                        data.error = Translator.getString(res.locals.lang, "errors", "travel_already_here");
                    } else {
                        let costs = Globals.areasManager.getPathCosts(Globals.connectedUsers[res.locals.id].character.getIdArea(), areaObjectTravel.getID());
                        let realWaitTime = Globals.connectedUsers[res.locals.id].character.getWaitTimeTravel(costs.timeToWait) / 1000;
                        data = {
                            from_name: Globals.connectedUsers[res.locals.id].character.getArea().getName(res.locals.lang),
                            to_name: areaObjectTravel.getName(res.locals.lang),
                            realWaitTime: realWaitTime,
                            costs: costs,
                        }
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "travel_area_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "travel_tired_wait_x", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/toRegion", async (req, res) => {
            let data = {}
            let wantedAreaToTravel = parseInt(req.body.idArea, 10);
            if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
                if (Globals.areasManager.isConnectedToRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel)) {
                    let areaObjectTravel = Globals.areasManager.getConnectedAreaForThisRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel);
                    if (areaObjectTravel.getID() == Globals.connectedUsers[res.locals.id].character.getIdArea()) {
                        data.error = Translator.getString(res.locals.lang, "errors", "travel_already_here");
                    } else {
                        let costs = Globals.areasManager.getPathCosts(Globals.connectedUsers[res.locals.id].character.getIdArea(), areaObjectTravel.getID());
                        if (Globals.connectedUsers[res.locals.id].character.doIHaveEnoughMoney(costs.goldPrice)) {
                            wantedAreaToTravel = Globals.areasManager.getArea(areaObjectTravel.getID());

                            // change de region
                            Globals.connectedUsers[res.locals.id].character.changeArea(wantedAreaToTravel, costs.timeToWait);
                            Globals.connectedUsers[res.locals.id].character.removeMoney(costs.goldPrice);

                            data.success = Translator.getString(res.locals.lang, "travel", "travel_to_area", [wantedAreaToTravel.getName(res.locals.lang)]) + "\n" + Translator.getString(res.locals.lang, "travel", "travel_to_area_exhaust", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "economic_dont_have_enough_money");
                        }
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "travel_area_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "travel_tired_wait_x", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/players/:page?", async (req, res) => {
            let data = {}
            req.params.page = parseInt(req.params.page, 10);
            data = Globals.areasManager.getPlayersOf(Globals.connectedUsers[res.locals.id].character.getIdArea(), req.params.page, res.locals.lang);
            data.lang = res.locals.lang;
            return res.json(data);
        });

    }
}

module.exports = TravelModule;