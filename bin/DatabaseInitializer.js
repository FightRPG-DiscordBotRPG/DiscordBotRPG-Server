const conn = require("../conf/mysql");

class DatabaseInitializer {
    static async initialize() {
        await DatabaseInitializer.citiesMarketplaces();
        await DatabaseInitializer.citiesCraftBuildings();
        await DatabaseInitializer.areaBonuses();
        await DatabaseInitializer.PStats();
        await DatabaseInitializer.disconnectUsers();
        await DatabaseInitializer.RemoveBuggedCharacters();
    }

    static async RemoveBuggedCharacters() {
        await conn.query("DELETE FROM charactersappearance WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users)")
        await conn.query("DELETE FROM charactersattacks WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users)");
        await conn.query("DELETE FROM charactersachievements WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM guildsmembers WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);")
        await conn.query("DELETE FROM guildsappliances WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM charactersstatistics WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM charactersinventory WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM levels WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM characterscraftlevel WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM statscharacters WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM charactersequipements WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM charactershonor WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM marketplacesorders WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        await conn.query("DELETE FROM characters WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
    }

    static async citiesMarketplaces() {
        await conn.query('INSERT INTO marketplaces (idArea) SELECT idArea FROM areas INNER JOIN areastypes ON areas.idAreaType = areastypes.idAreaType WHERE areastypes.NomAreaType = "city" AND areas.idArea NOT IN (SELECT idArea FROM marketplaces);');
    }

    static async citiesCraftBuildings() {
        await conn.query('INSERT INTO craftbuilding (idArea) SELECT idArea FROM areas INNER JOIN areastypes ON areas.idAreaType = areastypes.idAreaType WHERE areastypes.NomAreaType = "city" AND areas.idArea NOT IN (SELECT idArea FROM craftbuilding);');
    }

    static async areaBonuses() {
        await conn.query("INSERT IGNORE INTO `areasbonuses`(`idArea`, `idBonusTypes`, `value`) SELECT idArea, idBonusTypes, 0 as value FROM areas JOIN bonustypes");
    }

    static async PStats() {
        await conn.query("INSERT IGNORE INTO `charactersstatistics`(`idStatisticBase`, `idCharacter`, `value`) SELECT statisticsbases.idStatisticBase, characters.idCharacter, 0 as value FROM statisticsbases JOIN characters");
    }

    static async disconnectUsers() {
        await conn.query("UPDATE users SET isConnected = false, isDoingSomething = false");
    }
}

module.exports = DatabaseInitializer;