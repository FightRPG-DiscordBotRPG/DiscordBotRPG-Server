const conn = require("../../conf/mysql");
const GameEvent = require("./GameEvent");
const moment = require("moment");
const AreaBonus = require("../Areas/AreaBonus");
const ItemLootData = require("../Loots/ItemLootData");
const Globals = require("../Globals");

class EventsManager {
    constructor() {
        /**
         * @type {Object<number, GameEvent>}
         **/
        this.allEvents = {};
        /**
         * @type {Object<number, GameEvent>}
         **/
        this.ongoingEvents = {};

        /**
         * @type {Object<string, AreaBonus>}
         **/
        this.currentBonuses = {};
        this.currentDropsPerAreas = {};
        this.currentDropsPerAreasTypes = {};
        this.onEventStart = this.onEventStart.bind(this);
        this.onEventEnd = this.onEventEnd.bind(this);
    }

    reset() {
        this.allEvents = {};
        this.currentBonuses = {};
        this.currentDropsPerAreas = {};
        this.currentDropsPerAreasTypes = {};
    }

    async load() {
        let res = await conn.query("SELECT idEvent FROM events");
        let loadingEvents = [];
        for (let evt of res) {
            this.allEvents[evt.idEvent] = new GameEvent(evt.idEvent);
            loadingEvents.push(this.allEvents[evt.idEvent].load())
        }

        await Promise.all(loadingEvents);
        this.prepareStartEvents();
    }

    async prepareStartEvents() {
        /**
         * @type GameEvent
        */

        let event;
        for (event of Object.values(this.allEvents)) {
            event.eventEmitter.addListener("started", this.onEventStart);
            event.eventEmitter.addListener("ended", this.onEventEnd);
            event.prepareStart();
        }

        // console.log("Oui");
    }

    getBonusesValue(name) {
        return this.currentBonuses[name] != null ? this.currentBonuses[name] : 0;
    }

    /**
     * 
     * @param {GameEvent} event
     */
    onEventStart(event) {
        this.ongoingEvents[event.id] = event;
        this.calculateEventsCombinedData();
    }

    /**
     *
     * @param {GameEvent} event
     */
    onEventEnd(event) {
        delete this.ongoingEvents[event.id];
        this.calculateEventsCombinedData();
    }

    calculateEventsCombinedData() {
        let bonuses = {};
        let areasSpecificDrops = {};
        let areasTypesDrops = {};

        /**
         * @type GameEvent 
         */
        let event;
        for (event of Object.values(this.ongoingEvents)) {
            this.calculateEventBonuses(event, bonuses);

            for (let i in event.areasSpecificDrops) {
                if (!areasSpecificDrops[i]) {
                    areasSpecificDrops[i] = {};
                }
                areasSpecificDrops[i] = ItemLootData.mergeLootTables(areasSpecificDrops[i], event.areasSpecificDrops[i]);
            }

            for (let i in event.areasTypesDrops) {
                if (!areasTypesDrops[i]) {
                    areasTypesDrops[i] = {};
                }
                areasTypesDrops[i] = ItemLootData.mergeLootTables(areasTypesDrops[i], event.areasTypesDrops[i]);
            }
        }

        this.currentBonuses = bonuses;
        this.currentDropsPerAreas = areasSpecificDrops;
        this.currentDropsPerAreasTypes = areasTypesDrops;


        // Update Drops for Areas
        for (let area of Globals.areasManager.areas.values()) {
            let lootTablesForThisArea = {};

            // Update loots if id is in list
            if (this.currentDropsPerAreas[area.id]) {
                lootTablesForThisArea = this.currentDropsPerAreas[area.id];
            }

            // Update loots if type is in list
            if (this.currentDropsPerAreasTypes[area.idAreaType]) {
                lootTablesForThisArea = ItemLootData.mergeLootTables(this.currentDropsPerAreasTypes[area.idAreaType], lootTablesForThisArea);
            }

            // Merge only if new loots
            if (Object.keys(lootTablesForThisArea).length > 0) {
                area.possibleLootsWithEvents = ItemLootData.mergeLootTables(area.possibleLoots, lootTablesForThisArea);
            }

        }


    }

    /**
     * Change the original bonuses object
     * @param {GameEvent} event
     * @param {Object} bonuses By Ref
     */
    calculateEventBonuses(event, bonuses) {
        for (let bonus of Object.values(event.globalModifiers)) {
            // When it won't exist we copy the bonus
            if (!bonuses[bonus.name]) {
                bonuses[bonus.name] = Object.assign(new AreaBonus(), bonus);
                continue;
            }

            // Else we adding the values
            bonuses[bonus.name].value += bonus.value;
        }
    }

    async getOngoingEventsToApi(lang = "en") {
        let data = {};
        for (let event of this.getOngoingEventsList()) {
            data[event.id] = await event.toApi(lang);
        }
        return data;
    }

    /**
     * @returns {GameEvent[]}
     **/
    getOngoingEventsList() {
        return Object.values(this.ongoingEvents);
    }
}

module.exports = EventsManager;