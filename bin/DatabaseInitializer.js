const conn = require("../conf/mysql");
const mysql = require("mysql");

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