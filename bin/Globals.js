const conn = require("../conf/mysql.js");

let rarityChances = {
    commun: 40 / 100,
    rare: 7 / 100,
    superieur: 6 / 100,
    epique: 0.9 / 100,
    legendaire: 0.1 / 100,
    mythic: 0.01 / 100
}

let collectChances = {
    commun: 50 / 100,
    rare: 14 / 100,
    superieur: 9 / 100,
    epique: 1.25 / 100,
    legendaire: 0.25 / 100,
    mythic: 0.025 / 100
}

/**
 * A song
 * @typedef {Object} Globals
 * @property {Array<User>} connectedUsers - Users
 */
var Globals = {
    "maintenance_message": null,
    "maxLevel": null,
    "maxStatsId": null,
    "statsIds": null,
    "monstersIds": null,
    "itemsrarities": null,
    "equipableCorresponds": null,
    "basicWaitTimeBeforeFight": 60,
    "basicWaitTimeAfterTravel": 120,
    "basicWaitTimeBeforePvPFight": 900,
    "basicWaitTimeCollectTravel": 25,
    "basicWaitTimeCraft": 40,
    "collectTriesOnce": 10,
    "admins": ["241564725870198785", "285789367954440194", "228787710607753216", "403229406585421834", "245858206021058560"],
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
    "resetStatsPricePerLevel": 60,
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
     * @type {Array<User>}
     */
    "connectedUsers": [],
    /**
     * @type {Array<Guild>}
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
        }
        Globals.statsIds = statsIds;

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
    },
    getSearchParams: (params, withWhere = true, withAndBefore = false) => {
        let values = [];
        let more = "";

        if (params != null) {
            let equivalent = {
                "rarity": { name: "idRarity", sign: "=", isString: false },
                "type": { name: "idType", sign: "=", isString: false },
                "level": { name: "level", sign: ">=", isString: false },
                "power": { name: "power", sign: ">=", isString: false },
                "name": { name: "nameItem", sign: "LIKE", isString: true },
                "subtype": { name: "idSousType", sign: "=", isString: false },
            };

            for (let param of Object.keys(params)) {
                if (params[param] != null && equivalent[param] != null && (params[param] > 0 || equivalent[param].isString)) {
                    if (more.length > 0) {
                        more += " AND ";
                    }

                    more += `${equivalent[param].name} ${equivalent[param].sign} ?`;

                    if (equivalent[param].isString) {
                        params[param] = `%${params[param]}%`;
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
 **/