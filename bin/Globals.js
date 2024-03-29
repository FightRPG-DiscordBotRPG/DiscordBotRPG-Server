const conn = require("../conf/mysql.js");
const RebirthManager = require("./Rebirths/RebirthManager.js");

let rarityChances = {
    commun: 30 / 100,
    rare: 25 / 100,
    superieur: 20 / 100,
    epique: 5 / 100,
    legendaire: 1 / 100,
    mythic: 0.1 / 100
}

let collectChances = {
    commun: 50 / 100,
    rare: 14 / 100,
    superieur: 9 / 100,
    epique: 1.25 / 100,
    legendaire: 0.50 / 100,
    mythic: 0.05 / 100
}

/**
 * A song
 * @typedef {Object} Globals
 * @property {Array<User>} connectedUsers - Users
 * @property {Array<Guild>} connectedGuilds - Guilds
 */
var Globals = {
    "maintenance_message": null,
    "maxLevel": null,
    "maxStatsId": null,
    "statsIdsByName": null,
    "secondaryStatsIdsByName": null,
    "statsNameById": null,
    "secondaryStatsNameById": null,
    "elementsTypesIdsByName": null,
    "elementsTypesNameById": null,
    "monstersIds": null,
    "itemsrarities": null,
    "equipableCorresponds": null,
    /**
     * @type PSTreeNodes
     **/
    "pstreenodes": null,
    "allSecondaryStatsNames": [],
    "basicWaitTimeBeforeFight": 40,
    "basicWaitTimeAfterTravel": 120,
    "basicWaitTimeBeforePvPFight": 900,
    "basicWaitTimeCollectTravel": 25,
    "basicWaitTimeCraft": 40,
    "collectTriesOnce": 10,
    "baseTalentPointCost": 1,
    "maximumSkillsPerBuild": 5,
    "admins": ["241564725870198785", "285789367954440194", "228787710607753216", "245858206021058560"],
    "activated": true,
    "mDifficulties": [{
        name: "Weak",
        value: 0.8,
    },
    {
        name: "Young",
        value: 0.9,
    },
    {
        name: "Adult",
        value: 1,
    },
    {
        name: "Alpha",
        value: 1.2,
    }
    ],
    "equipsPossible": null,
    "rarityChances": rarityChances,
    "collectChances": collectChances,
    "areasTypes": null,
    "chanceToFightTheMonsterYouWant": 0.63,
    "resetStatsPricePerLevel": 45,
    "maxConsecutiveStuns": 1,
    "guilds": {
        "maxLevel": 10,
        "basePriceLevel": 20000,
        "multBasePricePerLevel": 5,
        "baseMembers": 5,
        "membersPerLevels": 5,
        "maxApplies": 5,
    },
    "weather": {
        "minBeforeChange": 10,
        "maxBeforeChange": 110,
    },
    /**
     * @type {Object<string, User>}
     */
    "connectedUsers": [],
    /**
     * @type {Object<string, Guild>}
     */
    "connectedGuilds": {},
    /**
     * @type {AreasManager}
     */
    "areasManager": {},
    /**
     * @type {FightManager}
     */
    "fightManager": {},
    "lockedMembers": {},
    /**
    * @type {RebirthManager}
    */
    "rebirthManager": null,
    /**
    * @type {EventsManager}
    */
    eventsManager: null,
    bodiesLinks: {},
    randomInclusive: (min, max) => {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    },
    getRarityName: (idRarity) => {
        idRarity = parseInt(idRarity);
        let rarityName = "";
        switch (idRarity) {
            case 1:
                rarityName = "common";
                break;
            case 2:
                rarityName = "rare";
                break;
            case 3:
                rarityName = "superior";
                break;
            case 4:
                rarityName = "epic";
                break;
            case 5:
                rarityName = "legendary";
                break;
            case 6:
                rarityName = "mythic";
                break;
        }
        return rarityName;
    },
    getDropChances: (idRarity) => {
        idRarity = parseInt(idRarity);
        let drop = 0;
        switch (idRarity) {
            case 1:
                drop = rarityChances.commun;
                break;
            case 2:
                drop = rarityChances.rare;
                break;
            case 3:
                drop = rarityChances.superieur;
                break;
            case 4:
                drop = rarityChances.epique;
                break;
            case 5:
                drop = rarityChances.legendaire;
                break;
            case 6:
                drop = rarityChances.mythic;
                break;
        }
        return drop;
    },
    loadGlobals: async () => {
        let statsIds = {};
        let statsNames = {};
        let secondaryStatsIds = {};
        let secondaryStatsNames = {};
        let elementsTypesIds = {};
        let elementsTypesNames = {};
        let equipsPossible = [];
        let areasTypes = [];
        let monstersTypes = {};
        let itemsrarities = [];
        let equipableCorresponds = {};

        Globals.maxLevel = (await conn.query("SELECT COUNT(*) FROM levelsrequire"))[0]["COUNT(*)"];
        Globals.maxStatsId = (await conn.query("SELECT COUNT(*) FROM stats"))[0]["COUNT(*)"];
        let res;
        res = await conn.query("SELECT * FROM stats");
        for (let i = 0; i < res.length; ++i) {
            statsIds[res[i].nom] = res[i].idStat;
            statsNames[res[i].idStat] = res[i].nom;
        }
        Globals.statsIdsByName = statsIds;
        Globals.statsNameById = statsNames;

        res = await conn.query("SELECT * FROM secondarystats");
        for (let i = 0; i < res.length; ++i) {
            secondaryStatsIds[res[i].name] = res[i].idSecondaryStat;
            secondaryStatsNames[res[i].idStat] = res[i].name;
        }
        Globals.secondaryStatsIdsByName = secondaryStatsIds;
        Globals.secondaryStatsNameById = secondaryStatsNames;


        res = await conn.query("SELECT * FROM elementstypes");
        for (let i = 0; i < res.length; ++i) {
            elementsTypesIds[res[i].shorthand] = res[i].idElementType;
            elementsTypesNames[res[i].idElementType] = res[i].shorthand;
        }

        Globals.elementsTypesIdsByName = elementsTypesIds;
        Globals.elementsTypesNameById = elementsTypesNames;

        Globals.allSecondaryStatsNames = [...Object.keys(Globals.secondaryStatsIdsByName), ...Object.keys(Globals.elementsTypesIdsByName).map(x => x + "Resist")];


        res = await conn.query("SELECT idType FROM itemstypes WHERE equipable = 1");
        for (let i = 0; i < res.length; i++) {
            equipsPossible.push(res[i]["idType"]);
        }
        Globals.equipsPossible = equipsPossible;

        res = await conn.query("SELECT NomAreaType FROM areastypes");
        for (let i = 0; i < res.length; i++) {
            areasTypes.push(res[i]["NomAreaType"]);
        }
        Globals.areasTypes = areasTypes;

        res = await conn.query("SELECT * FROM monstrestypes");
        for (let i in res) {
            monstersTypes[res[i]["nom"]] = res[i]['idType'];
        }
        Globals.monstersIds = monstersTypes;

        res = await conn.query("SELECT * FROM itemsrarities");
        for (let i in res) {
            itemsrarities[res[i].idRarity] = res[i].nomRarity;
        }
        Globals.itemsrarities = itemsrarities;

        res = await conn.query("SELECT * FROM itemstypes WHERE equipable = 1");
        for (let r of res) {
            equipableCorresponds[r.nomType] = r.idType;
        }
        Globals.equipableCorresponds = equipableCorresponds;

        Globals.bodiesLinks = {};
        res = await conn.query("SELECT * FROM bodytype");
        for (let r of res) {
            Globals.bodiesLinks[r.idBodyType] = r;
        }
    },
    getSearchParams: (params, withWhere = true, withAndBefore = false, includeList = null) => {
        let values = [];
        let more = "";

        if (params != null) {
            let equivalent = {
                "name": { name: "nameItem", sign: "LIKE", isString: true, isBool: false },
                "rarity": { name: "idRarity", sign: "=", isString: false, isBool: false },
                "type": { name: "idType", sign: "=", isString: false, isBool: false },
                "subtype": { name: "idSousType", sign: "=", isString: false, isBool: false },

                "level_up": { name: "level", sign: ">=", isString: false, isBool: false },
                "level": { name: "level", sign: ">=", isString: false, isBool: false },
                "level_down": { name: "level", sign: "<=", isString: false, isBool: false },

                "rebirth_up": { name: "rebirthLevel", sign: ">=", isString: false, isBool: false },
                "rebirth": { name: "rebirthLevel", sign: ">=", isString: false, isBool: false },
                "rebirth_down": { name: "rebirthLevel", sign: "<=", isString: false, isBool: false },

                "power": { name: "power", sign: ">=", isString: false, isBool: false },
                "power_up": { name: "power", sign: ">=", isString: false, isBool: false },
                "power_down": { name: "power", sign: "<=", isString: false, isBool: false },

                "fav": { name: "favorite", sign: "=", isString: false, isBool: true },

            };

            for (let param of Object.keys(params)) {
                if (params[param] != null && equivalent[param] != null && (includeList === null || includeList !== null && includeList[param]) && (params[param] >= 0 || equivalent[param].isString || equivalent[param].isBool)) {
                    if (more.length > 0) {
                        more += " AND ";
                    }

                    more += `${equivalent[param].name} ${equivalent[param].sign} ?`;

                    if (equivalent[param].isString) {
                        params[param] = `%${params[param]}%`;
                    }

                    if (equivalent[param].isBool) {
                        params[param] = params[param] == "true" || params[param] == true ? 1 : 0;
                    }

                    values.push(params[param]);
                }
            }

            if (values.length > 0) {
                if (withWhere) {
                    more = "WHERE " + more;
                } else if (withAndBefore) {
                    more = "AND " + more;
                }
            }
        }

        return { sqlQuery: more, values: values };
    }
}


module.exports = Globals;

/**
 * @typedef {import("./Areas/AreasManager")} AreasManager
 * @typedef {import("./User")} User
 * @typedef {import("./Guild")} Guild
 * @typedef {import("./FightManager")} FightManager
 * @typedef {import("./Events/EventsManager")} EventsManager
 * @typedef {import("./PSTree/PSTreeNodes")} PSTreeNodes
 **/