const conn = require("../conf/mysql");
const mysql = require("mysql");

class DatabaseInitializer {
    static initialize() {
        DatabaseInitializer.citiesMarketplaces();
        DatabaseInitializer.citiesCraftBuildings();
        DatabaseInitializer.areaBonuses();
        DatabaseInitializer.PStats();
        DatabaseInitializer.disconnectUsers();
        DatabaseInitializer.RemoveBuggedCharacters();
    }

    static RemoveBuggedCharacters() {
        conn.query("DELETE FROM guildsmembers WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);")
        conn.query("DELETE FROM guildsappliances WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM charactersstatistics WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM charactersinventory WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM levels WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM characterscraftlevel WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM statscharacters WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM charactersequipements WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM charactershonor WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM marketplacesorders WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
        conn.query("DELETE FROM characters WHERE idCharacter NOT IN (SELECT users.idCharacter FROM users);");
    }

    static citiesMarketplaces() {
        conn.query('INSERT IGNORE INTO marketplaces (idArea) SELECT idArea FROM areas INNER JOIN areastypes ON areas.idAreaType = areastypes.idAreaType WHERE areastypes.NomAreaType = "city";');
    }

    static citiesCraftBuildings() {
        conn.query('INSERT IGNORE INTO craftbuilding (idArea) SELECT idArea FROM areas INNER JOIN areastypes ON areas.idAreaType = areastypes.idAreaType WHERE areastypes.NomAreaType = "city";');
    }

    static areaBonuses() {
        conn.query("INSERT IGNORE INTO `areasbonuses`(`idArea`, `idBonusTypes`, `value`) SELECT idArea, idBonusTypes, 0 as value FROM areas JOIN bonustypes");
    }

    static PStats() {
        conn.query("INSERT IGNORE INTO `charactersstatistics`(`idStatisticBase`, `idCharacter`, `value`) SELECT statisticsbases.idStatisticBase, characters.idCharacter, 0 as value FROM statisticsbases JOIN characters");
    }

    static disconnectUsers() {
        conn.query("UPDATE users SET isConnected = false");
    }

    static serversStats(guilds) {
        let guildsAddString = "";
        let i = 0;

        guilds.forEach( (guild, snowflake, map) => {
            i++;
            //console.log(guild.id + " " + guild.name + " " + guild.memberCount + " " + guild.region);
            //guildsAddString += "(" + guild.id + "," + "`::`, `" + guild.name + "`," + guild.memberCount + ",`" + guild.region + "`";
            let temp = "(?, '::', ?, ?, ?)";
            temp = mysql.format(temp, [guild.id, guild.name, guild.memberCount, guild.region]);
            if(i < guilds.size) {
                temp += ",";
            } else {
                temp += ";";
            }
            guildsAddString += temp;
        });

        conn.query("INSERT IGNORE INTO serversstats (idServer, serverPrefix, serverName, memberCount, region) VALUES " + guildsAddString);

        // affectedRows => number of rows that was added

    }

    static newGuild(guild) {
        let temp = "(?, '::', ?, ?, ?)";
        temp = mysql.format(temp, [guild.id, guild.name, guild.memberCount, guild.region]);
        conn.query("INSERT IGNORE INTO serversstats (idServer, serverPrefix, serverName, memberCount, region) VALUES " + temp + ";");
    }
}

module.exports = DatabaseInitializer;