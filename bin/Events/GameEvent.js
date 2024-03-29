const conn = require("../../conf/mysql");
const ItemLootData = require("../Loots/ItemLootData");
const moment = require("moment");
const EventEmitter = require("events");
const AreaBonus = require("../Areas/AreaBonus");
const Translator = require("../Translator/Translator");
const Timers = require("../Utilities/Timers");
const Globals = require("../Globals");
const LootTables = require("../Loots/LootTables");
const Area = require("../Areas/Area");
const setTimeout = Timers.setTimeout;

class GameEvent {
    constructor(id) {
        this.id = id;
        this.idType = 0;
        this.typeName = "";
        this.backgroundImage = "";
        this.iconImage = "";
        this.occurence = 0;
        this.length = 0;
        /**
         * @type moment.Moment 
         **/
        this.startDate = null;
        /**
         * @type moment.Moment
         **/
        this.endDate = null;

        /** 
         *  idArea
         * @type Object<string, LootTables>
         **/
        this.areasSpecificDrops = {};

        /**
         *  idAreaType
         * @type Object<string, LootTables>
         **/
        this.areasTypesDrops = {};

        /**
         * @type Object<string, AreaBonus>
         **/
        this.globalModifiers = {};

        /**
         * @type Timers.Timeout
         **/
        this.nextStartTimeout = null;

        /**
         * @type Timers.Timeout
         **/
        this.endTimeout = null;

        this.eventEmitter = new EventEmitter.EventEmitter();
        this.start = this.start.bind(this);
        this.end = this.end.bind(this);

        this.willFireAgain = true;
    }

    async load() {
        let res = (await conn.query(`SELECT * FROM events
            INNER JOIN eventstypes USING(idEventType)
            WHERE idEvent = ?`, [this.id]))[0];

        this.idType = res.idEventType;
        this.typeName = res.name;
        this.backgroundImage = res.backgroundImage;
        this.iconImage = res.iconImage;
        this.occurence = res.occurence;
        this.length = res.length;
        this.startDate = moment(res.startDate);
        this.endDate = res.endDate != null ? moment(res.endDate) : null;


        // Specific areas drops
        await Promise.all([
            this.loadSpecificAreasDrops(),
            this.loadTypesAreasDrops(),
            this.loadGlobalModifiers()
        ]);
    }

    async loadSpecificAreasDrops() {
        let res = await conn.query(`SELECT idArea, eventspecificdrops.idBaseItem, eventspecificdrops.percentage, eventspecificdrops.min, eventspecificdrops.max, itemsbase.idRarity, equipable 
                                    FROM eventsareasdrops
                                    INNER JOIN eventspecificdrops USING(idEvent, idBaseItem)
                                    INNER JOIN itemsbase ON eventspecificdrops.idBaseItem = itemsbase.idBaseItem
                                    INNER JOIN itemstypes USING(idType)
                                    WHERE idEvent = ?;`, [this.id]);

        this.areasSpecificDrops = this.pGetLootTable(res, "idArea");
    }

    async loadTypesAreasDrops() {
        let res = await conn.query(`SELECT idAreaType, eventspecificdrops.idBaseItem, eventspecificdrops.percentage, eventspecificdrops.min, eventspecificdrops.max, itemsbase.idRarity, equipable 
                                    FROM eventsareastypesdrops
                                    INNER JOIN eventspecificdrops USING(idEvent, idBaseItem)
                                    INNER JOIN itemsbase ON eventspecificdrops.idBaseItem = itemsbase.idBaseItem
                                    INNER JOIN itemstypes USING(idType)
                                    WHERE idEvent = ?;`, [this.id]);
        this.areasTypesDrops = this.pGetLootTable(res, "idAreaType");
    }

    async loadGlobalModifiers() {
        let res = await conn.query(`SELECT idBonusTypes, value FROM eventsglobalmodifiers WHERE idEvent = ?;`, [this.id]);
        let promises = [];
        for (let item of res) {
            // Prevent async wrong value
            let itemAsync = item;
            promises.push((async () => {
                let areaBonus = new AreaBonus(itemAsync.idBonusTypes);
                areaBonus.value = itemAsync.value;
                await areaBonus.load();
                this.globalModifiers[areaBonus.name] = areaBonus;
            })());
        }
        await Promise.all(promises);
    }


    pGetLootTable(res, firstIndexName) {
        let lootTables = {};

        for (let item of res) {

            if (!lootTables[item[firstIndexName]]) {
                lootTables[item[firstIndexName]] = new LootTables();
            }

            let lootData = this.pGetLootDataFromResItem(item);
            /**
             * @type {ItemLootData}
             **/
            let lootTableToAdd;

            if (lootData.percentage > 0) {
                if (!lootTables[item[firstIndexName]].tables["others"]) {
                    lootTables[item[firstIndexName]].tables["others"] = [];
                }

                lootTableToAdd = lootTables[item[firstIndexName]].tables["others"];

            } else {
                if (!lootTables[item[firstIndexName]].tables[item.idRarity]) {
                    lootTables[item[firstIndexName]].tables[item.idRarity] = [];
                }

                lootTableToAdd = lootTables[item[firstIndexName]].tables[item.idRarity];
            }

            lootTableToAdd.push(lootData);
        }

        return lootTables;
    }

    pGetLootDataFromResItem(item) {
        let loot = new ItemLootData();
        loot.idBaseItem = item.idBaseItem;
        loot.percentage = item.percentage;
        loot.min = item.min;
        loot.max = item.max;
        loot.idRarity = item.idRarity;
        loot.equipable = item.equipable;
        return loot;
    }

    /**
     * Should only be used once when loading
     */
    prepareStart() {
        let currentDate = moment();
        let diffStart = (currentDate - this.startDate) % (this.occurence * 60000);

        // Leap years
        let diffDays = this.getDiffLeapBetweenDates(this.startDate, currentDate);
        diffStart += diffDays * 24 * 60 * 60 * 1000;

        let nextExecution = this.startDate;

        if (diffStart > 0) {
            let momentWhenItShouldHaveStart = currentDate.clone().subtract(diffStart).add(diffDays, "days");

            let momentWhenItShouldEnd = momentWhenItShouldHaveStart.clone().add(this.length, "minutes");

            if (momentWhenItShouldEnd > currentDate) {
                // The event isn't finished yet so we start it for the amount of time remaining
                this.start((momentWhenItShouldEnd - currentDate) / 60000);
                this.nextStartTimeout = { timestamp: momentWhenItShouldHaveStart.valueOf() }
                return;
            }


            nextExecution = momentWhenItShouldHaveStart.clone().add(this.occurence, "minutes").add(diffDays, "days");

            if (nextExecution.isLeapYear && moment(nextExecution.year() + '-02-29') <= nextExecution) {
                nextExecution.add(1, "days");
            }

        }

        if (this.endDate != null && nextExecution > this.endDate) {
            // Date is past including length of the event
            // It won't trigger again
            this.willFireAgain = false;
            return
        }

        // Directly using moment so it start at the precise date
        // And starting the timeout before the event is executed
        this.nextStartTimeout = setTimeout(this.start, nextExecution - currentDate);
    }

    /**
     * 
     * @param {number} length Minutes
     */
    start(length = null) {
        if (!length) {
            length = this.length;
        }
        let lengthInMs = length * 60000;
        this.endTimeout = setTimeout(this.end, lengthInMs);
        this.eventEmitter.emit("started", this);
    }

    end() {
        this.prepareStart();
        this.eventEmitter.emit("ended", this);
    }

    async toApi(lang = "en") {
        return {
            id: this.id,
            type: this.typeName,
            backgroundImage: this.backgroundImage,
            iconImage: this.iconImage,
            occurence: this.occurence,
            length: this.length,
            startDate: this.nextStartTimeout?.timestamp,
            endDate: this.endTimeout?.timestamp,
            areasSpecificDrops: await this.getLootTableLocalized(this.areasSpecificDrops, (i, l) => { return Area.getName(i, l) }, lang),
            areasTypesDrops: await this.getLootTableLocalized(this.areasTypesDrops, (i, l) => { return Globals.areasTypes[i - 1] }, lang),
            globalModifiers: this.getBonusesLocalized(lang),
            title: Translator.getString(lang, "eventsTitle", this.id),
            desc: Translator.getString(lang, "eventsDesc", this.id),
            ongoing: Globals.eventsManager.ongoingEvents[this.id] ? true : false,
            willFireAgain: this.willFireAgain
        }
    }

    /**
     * 
     * @param {Object<string, LootTables>} lootTables
     * @param {function(oldIndex: number, lang:string) : string} indexGetNameCallback
     * @param {string} lang
     */
    async getLootTableLocalized(lootTables, indexGetNameCallback, lang = "en") {
        let data = {};
        let allPromises = [];
        for (let i in lootTables) {
            allPromises.push((async () => {
                data[indexGetNameCallback(i, lang)] = await lootTables[i].toApi(lang);
            })()
            );
        }
        await Promise.all(allPromises);
        return data;
    }

    getBonusesLocalized(lang = "en") {
        let arr = [];
        for (let bonus of Object.values(this.globalModifiers)) {
            arr.push(bonus.toApi(lang));
        }
        return arr;
    }

    /**
     * 
     * @param {moment.Moment} startDate
     * @param {moment.Moment} endDate
     */
    getDiffLeapBetweenDates(startDate, endDate) {
        var diff = 0;
        for (var year = startDate.year(); year <= endDate.year(); year++) {
            var date = moment(year + '-02-29');
            if (date.isBetween(startDate, endDate) && date.isLeapYear()) {
                diff++;
            }
        }
        return diff;
    }

    /**
     * 
     * @param {moment.Moment} date 
     */
    isComingBefore(date) {
        return this.nextStartTimeout?.timestamp < date.valueOf();
    }
}

module.exports = GameEvent;