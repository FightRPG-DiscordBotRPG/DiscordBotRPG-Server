const conn = require("../../../conf/mysql");
const Stats = require("./SecondaryStats");

class SecondaryStatsEquipement extends Stats {

    constructor(id) {
        super(id, id);
    }

    async update() {
        let res = await conn.query("SELECT secondarystats.name, SUM(itemssecondarystats.value) as value FROM itemssecondarystats INNER JOIN charactersequipements ON charactersequipements.idItem = itemssecondarystats.idItem INNER JOIN secondarystats ON secondarystats.idSecondaryStat = itemssecondarystats.idSecondaryStat WHERE charactersequipements.idCharacter = ? GROUP BY secondarystats.name;", [this.id]);

        // raz des stats
        for (let stat of this.possibleStats) {
            this[stat] = 0;
        }

        // update
        for (let stat in res) {
            this[res[stat].name] = res[stat].value;
        }
    }




}

module.exports = SecondaryStatsEquipement;