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

    loadStat(id, difficulty) {
        // load from database
        //let res = conn.query("SELECT * FROM stats WHERE idStat = " + id);
        this.id = id;
        let res = conn.query("SELECT DISTINCT value, nom FROM statsmonstres INNER JOIN stats ON statsmonstres.idStat = stats.idStat WHERE idMonstre = " + this.id);
        for (let stat in res) {
            this[res[stat].nom] = Math.ceil(parseInt(res[stat].value, 10) * difficulty);
        }
    }

}

module.exports = StatsMonstres;
