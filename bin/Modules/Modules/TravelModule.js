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
        this.freeLockedMembers();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/area", async (req, res, next) => {
            let data = {}
            data.area = await res.locals.currentArea.toApi(res.locals.lang);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/region", async (req, res, next) => {
            let data = {}
            data.region = await Globals.areasManager.thisRegionToApi(res.locals.currentArea, res.locals.lang);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/info/:idArea?", async (req, res, next) => {
            let data = await this.sharedAreaTests(req, res, false);
            if (!data.error) {
                data = await this.getDataTravelCosts(req, res, data.costs, data.areaObjectTravel);
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/toarea", async (req, res, next) => {
            let data = await this.sharedAreaTests(req, res, false);

            if (!data.error) {
                data = await this.travelAndGetData(req, res, data.costs, data.areaObjectTravel);
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/inforegion/:idArea?", async (req, res, next) => {
            let data = await this.sharedAreaTests(req, res, true);
            if (!data.error) {
                data = await this.getDataTravelCosts(req, res, data.costs, data.areaObjectTravel);
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/toRegion", async (req, res, next) => {
            let data = await this.sharedAreaTests(req, res, true);

            if (!data.error) {
                data = await this.travelAndGetData(req, res, data.costs, data.areaObjectTravel);
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/players/:page?", async (req, res, next) => {
            let data = {}
            req.params.page = parseInt(req.params.page, 10);
            data = await Globals.areasManager.getPlayersOf(Globals.connectedUsers[res.locals.id].character.getIdArea(), req.params.page, res.locals.lang);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

    }

    async sharedAreaTests(req, res, isForRegion) {
        let data = {};
        let wantedAreaToTravel = parseInt(req.params.idArea, 10);
        wantedAreaToTravel = isNaN(wantedAreaToTravel) ? parseInt(req.body.idArea, 10) :wantedAreaToTravel;
        let doesAreaExist = isForRegion ? Globals.areasManager.isConnectedToRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel) : Globals.areasManager.existInRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel);

        if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
            if (doesAreaExist) {
                let areaObjectTravel = isForRegion ? Globals.areasManager.getConnectedAreaForThisRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel) : Globals.areasManager.getAreaForThisRegion(Globals.connectedUsers[res.locals.id].character.getIDRegion(), wantedAreaToTravel);
                if (areaObjectTravel.getID() == Globals.connectedUsers[res.locals.id].character.getIdArea()) {
                    data.error = Translator.getString(res.locals.lang, "errors", "travel_already_here");
                } else {
                    let costs = await Globals.areasManager.getPathCosts(Globals.connectedUsers[res.locals.id].character.getIdArea(), areaObjectTravel.getID(), res.locals.lang);

                    let requiredAchievements = costs.neededAchievements;
                    let missingAchievements = [];
                    for (let i in requiredAchievements) {
                        if (!await Globals.connectedUsers[res.locals.id].character.getAchievements().hasAchievement(requiredAchievements[i])) {
                            missingAchievements.push(requiredAchievements[i]);
                        }
                    }

                    if (missingAchievements.length > 0) {
                        let achievementsNames = [];
                        for (let i in missingAchievements) {
                            achievementsNames.push((await Globals.connectedUsers[res.locals.id].character.getAchievements().getSpecificAchievement(missingAchievements[i], res.locals.lang)).nameAchievement);
                        }
                        data.error = Translator.getString(res.locals.lang, "errors", "travel_missing_achievements", [achievementsNames.toString()]);
                    } else {
                        data.costs = costs;
                        data.areaObjectTravel = areaObjectTravel;
                    }
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "travel_area_dont_exist");
            }
        } else {
            data.error = Translator.getString(res.locals.lang, "errors", "travel_tired_wait_x", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
        }
        return data;
    }

    async getDataTravelCosts(req, res, costs, areaObjectTravel) {
        let realWaitTime = (await Globals.connectedUsers[res.locals.id].character.getWaitTimeTravel(costs.timeToWait)) / 1000;
        return {
            from_name: Globals.connectedUsers[res.locals.id].character.getArea().getName(res.locals.lang),
            to_name: areaObjectTravel.getName(res.locals.lang),
            realWaitTime: realWaitTime,
            costs: costs,
        };
    }

    async travelAndGetData(req, res, costs, areaObjectTravel) {
        let data = {};
        if (await Globals.connectedUsers[res.locals.id].character.doIHaveEnoughMoney(costs.goldPrice)) {
            let wantedAreaToTravel = Globals.areasManager.getArea(areaObjectTravel.getID());

            await Promise.all([
                Globals.connectedUsers[res.locals.id].character.changeArea(wantedAreaToTravel, costs.timeToWait),
                Globals.connectedUsers[res.locals.id].character.removeMoney(costs.goldPrice)
            ]);

            // add success
            data.success = Translator.getString(res.locals.lang, "travel", "travel_to_area", [wantedAreaToTravel.getName(res.locals.lang)]) + "\n" + Translator.getString(res.locals.lang, "travel", "travel_to_area_exhaust", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
        } else {
            data.error = Translator.getString(res.locals.lang, "errors", "economic_dont_have_enough_money");
        }
        return data;
    }
}

module.exports = TravelModule;