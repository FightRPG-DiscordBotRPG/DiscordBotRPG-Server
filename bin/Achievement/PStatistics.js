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

    static async getStat(idCharacter, statName) {
        let val = await conn.query("SELECT value FROM charactersstatistics INNER JOIN statisticsbases ON statisticsbases.idStatisticBase = charactersstatistics.idStatisticBase WHERE idCharacter = ? AND statisticsbases.name = ?;", [idCharacter, statName]);
        return val[0] != null ? val[0].value : 0;
    }

    static async logCommand(userid, command, timestamp) {
        if (timestamp == null) {
            timestamp = Date.now();
        }
        conn.query("INSERT INTO commandslogs VALUES(NULL, ?, ?, ?);", [userid, command == null || command == "" ? "unknown" : command, timestamp]);
    }


}

module.exports = PStatistics;