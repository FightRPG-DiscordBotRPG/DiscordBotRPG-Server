const conn = require("../../conf/mysql");
const Stats = require("./Stats");
const Globals = require("../Globals");

class StatsEquipement extends Stats {

    constructor(id) {
        super(id, id);
    }

    async update() {
        let res = await conn.query("SELECT stats.nom, SUM(itemsstats.value) as value FROM itemsstats INNER JOIN charactersequipements ON charactersequipements.idItem = itemsstats.idItem INNER JOIN stats ON stats.idStat = itemsstats.idStat WHERE charactersequipements.idCharacter = ? GROUP BY stats.nom;", [this.id]);

        // raz des stats
        for (let stat of this.possibleStats) {
            this[stat] = 0;
        }

        // update
        for (let stat in res) {
            this[res[stat].nom] = Number.parseInt(res[stat].value);
        }
    }




}

module.exports = StatsEquipement;