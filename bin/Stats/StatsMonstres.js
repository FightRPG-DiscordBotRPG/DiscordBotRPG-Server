'use strict';
const conn = require("../../conf/mysql.js");
const Stats = require("./Stats.js");

class StatsMonstres extends Stats {

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        // recherche base de donnée
        super(id, id);
    }

    // Load from DB

    loadStat(id, difficulty, level=1) {
        // load from database
        //let res = conn.query("SELECT * FROM stats WHERE idStat = " + id);
        this.id = id;
        let res = conn.query("SELECT * FROM statsmonstres INNER JOIN statsprofil ON statsprofil.idStatsProfil = statsmonstres.idStatsProfil INNER JOIN statsRepartition ON statsRepartition.idStatsProfil = statsprofil.idStatsProfil INNER JOIN stats ON statsRepartition.idStat = stats.idStat WHERE statsmonstres.idMonstre = ?;", [this.id]);

        let totalStats = 5 * level + (level * 2 * 4 * Math.pow(2, difficulty) * 0.17);
        let optimalArmor = Math.round(( 8 * Math.pow(level, 2)) / 7 + 5);

        for (let stat in res) {
            let percentage = parseInt(res[stat].percentage, 10) / 100;

            if (res[stat].nom != "armor") {
                this[res[stat].nom] = Math.ceil(percentage * totalStats);
            } else {
                this[res[stat].nom] = Math.ceil(percentage * optimalArmor);
            }

        }
    }

}

module.exports = StatsMonstres;
