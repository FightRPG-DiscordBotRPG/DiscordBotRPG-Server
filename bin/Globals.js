const conn = require("../conf/mysql.js");

let maxLevel = conn.query("SELECT COUNT(*) FROM levelsrequire")[0]["COUNT(*)"];
let maxStatsId = conn.query("SELECT COUNT(*) FROM stats")[0]["COUNT(*)"];
let statsIds = {};
let equipsPossible = [];
let areasTypes = [];
let monstersTypes = {};
let itemsrarities = [];
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




let rarityChances = {
    commun: 15 / 100,
    rare: 10 / 100,
    superieur: 4 / 100,
    epique: 0.5 / 100,
    legendaire: 0.2 / 100,
}

let collectChances = {
    commun: 50 / 100,
    rare: 30 / 100,
    superieur: 9 / 100,
    epique: 1.5 / 100,
    legendaire: 0.8 / 100,
}

var Globals = {
    "maxLevel": maxLevel,
    "maxStatsId": maxStatsId,
    "statsIds": statsIds,
    "monstersIds": monstersTypes,
    "itemsrarities" : itemsrarities,
    "basicWaitTimeBeforeFight": 30,
    "basicWaitTimeAfterTravel": 120,
    "basicWaitTimeCollectTravel" : 10,
    "basicWaitTimeCraft": 30,
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
    "collectChances":collectChances,
    "areasTypes": areasTypes,
    "chanceToFightTheMonsterYouWant": 0.63,
    "resetStatsPricePerLevel": 250,
    "guilds": {
        "maxLevel": 10,
        "basePriceLevel": 20000,
        "multBasePricePerLevel" : 5,
        "baseMembers": 5,
        "membersPerLevels": 5,
        "maxApplies" : 5,
    },
    "addr": "http://azz-tech.no-ip.org:8080/",
    "discordClient": {},
    "help": {
        "tutorialLink": "https://docs.google.com/document/d/1ISXdBt5npR7oTjU0nxOkrEc10cd5OAcg-hG-rODmyIQ/edit?usp=sharing"
    },
    "connectedUsers": {},
    "connectedGuilds": {},
    "areasManager": {},
    "fightManager": {}
}

module.exports = Globals;