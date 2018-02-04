'use strict';
const conn = require("../conf/mysql.js");

class StatsMonstres {

    // Generic Stats Class
    // Used by All Player/Enemies
    constructor(id) {
        // recherche base de donn�e
        this.id = id;
        this.force = 0;
        this.intelligence = 0;
        this.constitution = 0;
        this.defense = 0;
        this.dexterite = 0;
        this.charisme = 0;
        this.sagesse = 0;
        this.volonte = 0;
        this.perception = 0;
        this.luck = 0;
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
