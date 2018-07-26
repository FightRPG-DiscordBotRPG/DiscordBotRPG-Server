const Statistics = require("./Statistics");
const conn = require("../../conf/mysql");

class PStatistics extends Statistics {
    static async incrStat(idCharacter, statName, number) {
        //console.log(idCharacter + " -> " + statName + " add " + number);
        conn.query("UPDATE charactersstatistics INNER JOIN statisticsbases ON statisticsbases.idStatisticBase = charactersstatistics.idStatisticBase SET value = value + ? WHERE idCharacter = ? AND statisticsbases.name = ?;", [number, idCharacter, statName]);
    }

    static async decrStat(idCharacter, statName, number) {
        conn.query("UPDATE charactersstatistics INNER JOIN statisticsbases ON statisticsbases.idStatisticBase = charactersstatistics.idStatisticBase SET value = value - ? WHERE idCharacter = ? AND statisticsbases.name = ?;", [number, idCharacter, statName]);
    }

    static async setStat(idCharacter, statName, number) {
        conn.query("UPDATE charactersstatistics INNER JOIN statisticsbases ON statisticsbases.idStatisticBase = charactersstatistics.idStatisticBase SET value = ? WHERE idCharacter = ? AND statisticsbases.name = ?;", [number, idCharacter, statName]);
    }


}

module.exports = PStatistics;