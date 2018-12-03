const conn = require("../conf/mysql.js");

let maxLevel = conn.query("SELECT COUNT(*) FROM levelsrequire")[0]["COUNT(*)"];
let maxStatsId = conn.query("SELECT COUNT(*) FROM stats")[0]["COUNT(*)"];
let statsIds = {};
let equipsPossible = [];
let areasTypes = [];
let monstersTypes = {};
let itemsrarities = [];
let equipableCorresponds = {};
let res;

// All Stats
res = conn.query("SELECT * FROM stats");
for (let i = 0; i < res.length; ++i) {
    statsIds[res[i].nom] = res[i].idStat;
}

res = conn.query("SELECT idType FROM itemstypes WHERE equipable = 1");
for (let i = 0; i < res.length; i++) {
    equipsPossible.push(res[i]["idType"]);
}

res = conn.query("SELECT NomAreaType FROM areastypes");
for (let i = 0; i < res.length; i++) {
    areasTypes.push(res[i]["NomAreaType"]);
}

res = conn.query("SELECT * FROM monstrestypes");
for (let i in res) {
    monstersTypes[res[i]["nom"]] = res[i]['idType'];
}

res = conn.query("SELECT * FROM itemsrarities");
for (let i in res) {
    itemsrarities[res[i].idRarity] = res[i].nomRarity;
}

res = conn.query("SELECT * FROM itemstypes WHERE equipable = 1");
for (let r of res) {
    equipableCorresponds[r.nomType] = r.idType;
}




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

var Globals = {
    "maxLevel": maxLevel,
    "maxStatsId": maxStatsId,
    "statsIds": statsIds,
    "monstersIds": monstersTypes,
    "itemsrarities": itemsrarities,
    "equipableCorresponds": equipableCorresponds,
    "basicWaitTimeBeforeFight": 60,
    "basicWaitTimeAfterTravel": 120,
    "basicWaitTimeBeforePvPFight": 900,
    "basicWaitTimeCollectTravel": 25,
    "basicWaitTimeCraft": 40,
    "collectTriesOnce": 10,
    "admins": ["241564725870198785", "285789367954440194", "228787710607753216"],
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
    "equipsPossible": equipsPossible,
    "rarityChances": rarityChances,
    "collectChances": collectChances,
    "areasTypes": areasTypes,
    "chanceToFightTheMonsterYouWant": 0.63,
    "resetStatsPricePerLevel": 60,
    "guilds": {
        "maxLevel": 10,
        "basePriceLevel": 20000,
        "multBasePricePerLevel": 5,
        "baseMembers": 5,
        "membersPerLevels": 5,
        "maxApplies": 5,
    },
    "addr": "http://azz-tech.no-ip.org:8080/",
    "help": {
        "tutorialLink": "https://docs.google.com/document/d/1ISXdBt5npR7oTjU0nxOkrEc10cd5OAcg-hG-rODmyIQ/edit?usp=sharing"
    },
    "connectedUsers": {},
    "connectedGuilds": {},
    "areasManager": {},
    "fightManager": {},
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
    }
}


module.exports = Globals;