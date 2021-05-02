const conn = require("../../conf/mysql");
const ItemLootData = require("../Loots/ItemLootData");
const moment = require("moment");
const EventEmitter = require("events");
const AreaBonus = require("../Areas/AreaBonus");

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
         *  {idArea, {<idRarity, Data[]>}}
         * @type Object<string, Object<string, ItemLootData[]>
         **/
        this.areasSpecificDrops = {};

        /**
         *  {idAreaType, {<idRarity, Data[]>}}
         * @type Object<string, Object<string, ItemLootData[]>
         **/
        this.areasTypesDrops = {};

        /**
         * @type Object<string, AreaBonus>
         **/
        this.globalModifiers = {};

        /**
         * @type NodeJS.Timeout
         **/
        this.nextStartTimeout = null;

        /**
         * @type NodeJS.Timeout
         **/
        this.endTimeout = null;

        this.eventEmitter = new EventEmitter.EventEmitter();
        this.start = this.start.bind(this);
        this.end = this.end.bind(this);
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
            this.globalModifiers[AreaBonus.name] = new AreaBonus(item.idBonusTypes);
            promises.push(this.globalModifiers[AreaBonus.name].load());
        }
        await Promise.all(promises);
    }


    pGetLootTable(res, firstIndexName) {
        let lootTable = {};

        for (let item of res) {

            if (!lootTable[item[firstIndexName]]) {
                lootTable[item[firstIndexName]] = {};
            }

            let lootData = this.pGetLootDataFromResItem(item);
            let lootTableToAdd;

            if (lootData.percentage > 0) {
                if (!lootTable[item[firstIndexName]]["others"]) {
                    lootTable[item[firstIndexName]]["others"] = [];
                }

                lootTableToAdd = lootTable[item[firstIndexName]]["others"];

            } else {
                if (!lootTable[item[firstIndexName]][item.idRarity]) {
                    lootTable[item[firstIndexName]][item.idRarity] = [];
                }

                lootTableToAdd = lootTable[item[firstIndexName]][item.idRarity];
            }

            lootTableToAdd.push(lootData);
        }

        return lootTable;
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

        let nextExecution = this.startDate;

        if (diffStart > 0) {
            let momentWhenItShouldHaveStart = currentDate.clone().subtract(diffStart);

            let momentWhenItShouldEnd = momentWhenItShouldHaveStart.clone().add(this.length, "minutes");

            if (momentWhenItShouldEnd > currentDate) {
                // The event isn't finished yet so we start it for the amount of time remaining
                this.start((momentWhenItShouldEnd - currentDate) / 60000);
                return;
            }

            nextExecution = momentWhenItShouldHaveStart.clone().add(this.occurence, "minutes");
        }

        if (this.endDate != null && nextExecution > this.endDate) {
            // Date is past including length of the event
            // It won't trigger again
            return
        }
        

        // Directly using moment so it start at the precise date
        // And starting the timeout before the event is executed
        this.nextStartTimeout = setTimeout(this.start, nextExecution - moment());
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
}

module.exports = GameEvent;