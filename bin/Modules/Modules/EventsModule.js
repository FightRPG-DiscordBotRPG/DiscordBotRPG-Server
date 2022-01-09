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
const { identifiers } = require("../../Areas/AreaBonus");
const Utils = require("../../Utilities/Utils");

class EventsModule extends GModule {
    constructor() {
        super();
        this.commands = ["showevents"];
        this.startLoading("Events");
        this.init();
        this.endLoading("Events");
    }

    init() {
        super.init();
        this.loadRoutes();
    }

    loadRoutes() {
        this.router.get("/ongoing", async (req, res, next) => {
            let data = {
                events: await Globals.eventsManager.getOngoingEventsToApi(res.locals.lang)
            };
            await next();
            return res.json(data);
        });

        this.router.get("/show/:idEvent?", async (req, res, next) => {
            let data = await this.getShowEvent(req.params.idEvent, res.locals.lang);
            await next();
            return res.json(data);
        });

        this.router.get("/incoming/:months?", async (req, res, next) => {
            let data = {
                events: await Globals.eventsManager.getIncomingEventsToApi(req.params.months, res.locals.lang)
            };
            await next();
            return res.json(data);
        });
    }

    async getShowEvent(idEvent, lang = "en") {
        if (Globals.eventsManager.allEvents[idEvent] == null) {
            return this.asError(Translator.getString(lang, "errors", "events_dont_exist"));
        }
        return { event: await Globals.eventsManager.allEvents[idEvent].toApi(lang) };
    }
}

module.exports = EventsModule;