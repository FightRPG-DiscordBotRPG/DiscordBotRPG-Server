const conn = require("../../conf/mysql");
const GameEvent = require("./GameEvent");
const moment = require("moment");

class EventsManager {
    constructor() {
        /**
         * @type {Object<number, GameEvent>}
         **/
        this.events = {};
        this.currentlyStartedEvents = {};
        this.currentBonuses = {};
        this.currentDropsPerAreas = {};
        this.currentDropsPerAreasTypes = {};
    }

    reset() {
        this.events = {};
        this.currentBonuses = {};
        this.currentDropsPerAreas = {};
        this.currentDropsPerAreasTypes = {};
    }

    async load() {
        let res = await conn.query("SELECT idEvent FROM events");
        let loadingEvents = [];
        for (let evt of res) {
            this.events[evt.idEvent] = new GameEvent(evt.idEvent);
            loadingEvents.push(this.events[evt.idEvent].load())
        }

        await Promise.all(loadingEvents);
        this.prepareStartEvents();
    }

    async prepareStartEvents() {
        /**
         * @type GameEvent
         */
        let event;
        for (event of Object.values(this.events)) {            
            event.prepareStart();
        }
    }

    getBonusesValue(name) {
        return this.currentBonuses[name] != null ? this.currentBonuses[name] : 0;
    }
}

module.exports = EventsManager;