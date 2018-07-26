const conn = require("../conf/mysql");


class DatabaseInitializer {
    static initialize() {
        DatabaseInitializer.citiesMarketplaces();
        DatabaseInitializer.areaBonuses();
        DatabaseInitializer.PStats();
    }

    static citiesMarketplaces() {
        conn.query('INSERT IGNORE INTO marketplaces (idArea) SELECT idArea FROM areas INNER JOIN areastypes ON areas.idAreaType = areastypes.idAreaType WHERE areastypes.NomAreaType = "city";');
    }

    static areaBonuses() {
        conn.query("INSERT IGNORE INTO `areasbonuses`(`idArea`, `idBonusTypes`, `value`) SELECT idArea, idBonusTypes, 0 as value FROM areas JOIN bonustypes");
    }

    static PStats() {
        conn.query("INSERT IGNORE INTO `charactersstatistics`(`idStatisticBase`, `idCharacter`, `value`) SELECT statisticsbases.idStatisticBase, characters.idCharacter, 0 as value FROM statisticsbases JOIN characters");
    }
}

module.exports = DatabaseInitializer;