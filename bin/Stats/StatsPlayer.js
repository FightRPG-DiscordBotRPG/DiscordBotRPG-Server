'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals.js");
const Stats = require("./Stats.js");


class StatsPlayer extends Stats {

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        super(id, id);
    }

    // Reset
    async reset() {
        for (let stat in Globals.statsIds) {
            this[stat] = 0;
            await conn.query("UPDATE statscharacters SET value = ? WHERE idStat = ? AND idCharacter = ?;", [this[stat], Globals.statsIds[stat], this.id]);
        }
    }

    // Save to DB
    async saveStat() {
        for (let stat in Globals.statsIds) {
            await conn.query("UPDATE statscharacters SET value = " + this[stat] + " WHERE idStat = " + Globals.statsIds[stat] + " AND idCharacter = " + this.id);
        }
    }

    async saveThisStat(stat) {
        await conn.query("UPDATE statscharacters SET value = " + this[stat] + " WHERE idStat = " + Globals.statsIds[stat] + " AND idCharacter = " + this.id);
    }

    // Load from DB
    async loadStat(id) {
        this.id = id;
        let res = await conn.query("SELECT DISTINCT value, nom FROM statscharacters INNER JOIN stats ON statscharacters.idStat = stats.idStat WHERE idCharacter = ?;", [this.id]);
        for (let stat in res) {
            this[res[stat].nom] = parseInt(res[stat].value, 10);
        }
    }

    // New Stat if not exist
    async init(id) {
        for (let i = 1; i <= Globals.maxStatsId; ++i) {
            await conn.query("INSERT INTO statscharacters VALUES (" + id + ", " + i + ", 0)");
        }
        await this.loadStat(id);
    }

}

module.exports = StatsPlayer;