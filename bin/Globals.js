'use strict';
const conn = require("../conf/mysql.js");


let maxLevel = conn.query("SELECT COUNT(*) FROM levelsrequire")[0]["COUNT(*)"];
let maxStatsId = conn.query("SELECT COUNT(*) FROM stats")[0]["COUNT(*)"];
let statsIds = {};
let equipsPossible = [];
let areasTypes = [];
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




let rarityChances = {
    commun: 17 / 100,
    rare: 8 / 100,
    superieur: 5 / 100,
    epique: 1 / 100,
    legendaire: 0.5 / 100,
}

var Globals = {
    "maxLevel": maxLevel,
    "maxStatsId": maxStatsId,
    "statsIds": statsIds,
    "basicWaitTimeBeforeFight": 20,
    "basicWaitTimeAfterTravel": 120,
    "basicWaitTimeCollectTravel" : 30,
    "admins": ["241564725870198785", "285789367954440194"],
    "activated" : true,
    "mDifficulties": [
        {
            name: "Weak",
            value: 0.6,
        },
        {
            name: "Young",
            value: 0.8,
        },
        {
            name: "Adult",
            value: 1,
        },
        {
            name: "Alpha",
            value: 1.5,
        }
    ],
    "equipsPossible": equipsPossible,
    "rarityChances": rarityChances,
    "areasTypes": areasTypes,
    "chanceToFightTheMonsterYouWant": 0.63,
    "resetStatsPricePerLevel": 250,
    "guilds": {
        "maxLevel": 10,
        "basePriceLevel": 100000,
        "multBasePricePerLevel" : 1.5,
        "baseMembers": 5,
        "membersPerLevels": 5,
        "maxApplies" : 5,
    },
    "addr": "http://azz-tech.no-ip.org:8080/",


}

module.exports = Globals;
