'use strict';
const conn = require("../../../conf/mysql");
const SecondaryStats = require("./SecondaryStats");

class SecondaryStatsMonsters extends SecondaryStats {

    constructor(id) {
        super(id, id);
    }

    // Load from DB

    async loadStat(id, difficulty, level = 1) {
        // load from database
        //let res = conn.query("SELECT * FROM stats WHERE idStat = " + id);
        this.id = id;
        let res = await conn.query(`SELECT
                *
            FROM
                statsmonstres
            INNER JOIN statsprofil ON statsprofil.idStatsProfil = statsmonstres.idStatsProfil
            INNER JOIN secondarystatsrepartition ON secondarystatsrepartition.idStatsProfil = statsprofil.idStatsProfil
            INNER JOIN secondarystats ON secondarystatsrepartition.idSecondaryStat = secondarystats.idSecondaryStat
            WHERE
                statsmonstres.idMonstre = ?;`, [this.id]);

        for (let stat in res) {
            let mult = 1 + parseFloat(res[stat].multPerLevel) * (level + difficulty);
            this[res[stat].name] = Math.ceil(mult * res[stat].baseValue);
        }

    }

}

module.exports = SecondaryStatsMonsters;