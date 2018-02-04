'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");

class AppliancesManager {

    constructor() {
        
    }


    // Apply to a guild
    /**
     * Apply to guild
     * @param {Number} idGuild
     * @param {Number} idCharacter
     * @returns {Array}
     */
    applyTo(idGuild, idCharacter) {
        let err = [];
        if (this.isGuildExist(idGuild)) {
            if (!this.haveAlreadyApplied(idGuild, idCharacter)) {
                if (!this.haveReachAppliesLimit(idCharacter)) {
                    conn.query("INSERT INTO GuildsAppliances VALUES(" + idGuild + ", " + idCharacter + ")");
                } else {
                    err.push("Vous ne pouvez postuler que pour rejoindre " + Globals.guilds.maxApplies + " guildes maximum en même temps");
                }
                
            } else {
                err.push("Vous avez déjà postulé pour rejoindre cette guilde.");
            }
        } else {
            err.push("Cette guilde n'existe pas.");
        }
        return err;
    }


    /**
     * Return if guild exist or not
     * @param {Number} idGuild 
     */
    isGuildExist(idGuild) {
        let res = conn.query("SELECT idGuild FROM Guilds WHERE idGuild = " + idGuild);
        if (res.length > 0) {
            return true;
        }
        return false;
    }

    /**
     * Return if the character have already applied in this guild
     * @param {Number} idGuild
     * @param {Number} idCharacter
     */
    haveAlreadyApplied(idGuild, idCharacter) {
        let res = conn.query("SELECT idGuild FROM GuildsAppliances WHERE idCharacter = " + idCharacter + " AND idGuild = " + idGuild + ";");
        if (res.length > 0) {
            return true;
        } 
        return false;
    }

    haveReachAppliesLimit(idCharacter) {
        return conn.query("SELECT COUNT(*) FROM guildsappliances WHERE idCharacter = " + idCharacter)[0]["COUNT(*)"] >= Globals.guilds.maxApplies ? true : false;
    }


    /**
     * Remove all appliances for a given character
     * @param {Number} idCharacter ID Character
     */
    deleteUsersAppliances(idCharacter) {
        conn.query("DELETE FROM GuildsAppliances WHERE idCharacter = " + idCharacter);
    }

    deleteUserForThisGuildAppliance(idCharacter, idGuild) {
        conn.query("DELETE FROM GuildsAppliances WHERE idCharacter = " + idCharacter + " AND idGuild = " + idGuild);
    }

    deleteGuildAppliances(idGuild) {
        conn.query("DELETE FROM GuildsAppliances WHERE idGuild = " + idGuild);
    }

    getAppliances(idCharacter) {
        let res = conn.query("SELECT guilds.idGuild, nom, level FROM guildsappliances " +
            "INNER JOIN guilds ON guilds.idGuild = guildsappliances.idGuild " +
            "WHERE idCharacter = " + idCharacter);
        let str = "```";
        let idMaxLength = 10;
        let nameMaxLength = 35;
        let levelMaxLength = 11;

        let idLength;
        let nameLength;
        let levelLength;




        if (res.length > 0) {
            str += "|" + "    id    " + "|" + "                nom                " + "|" + "   level   " + "|" + "\n";
            for (let i of res) {
                idLength = i.idGuild.toString().length;
                idLength = (idMaxLength - idLength) / 2;

                nameLength = i.nom.length;
                nameLength = (nameMaxLength - nameLength) / 2;

                levelLength = i.level.toString().length;
                levelLength = (levelMaxLength - levelLength) / 2;

                str += "|" + " ".repeat(Math.floor(idLength)) + i.idGuild + " ".repeat(Math.ceil(idLength)) + "|"
                    + " ".repeat(Math.floor(nameLength)) + i.nom + " ".repeat(Math.ceil(nameLength)) + "|"
                    + " ".repeat(Math.floor(levelLength)) + i.level + " ".repeat(Math.ceil(levelLength)) + "|\n"
            }
        } else {
            str += "Vous ne postulez pas pour rejoindre une guilde.";
        }


        str += "```";
        return str;
    }

    getGuildAppliances(idGuild, page) {
        page = page <= 0 ? 1 : page;
        let idCharacterMaxLength = 10;
        let userNameMaxLength = 35;
        let actualLevelMaxLength = 11;

        let idCharacterLength;
        let userNameLength;
        let actualLevelLength;

        let res = conn.query("SELECT guildsappliances.idCharacter, users.userName, levels.actualLevel FROM guildsappliances " +
                    "INNER JOIN users ON users.idCharacter = guildsappliances.idCharacter " +
                    "INNER JOIN levels ON levels.idCharacter = guildsappliances.idCharacter " +
                    "WHERE guildsappliances.idGuild = " + idGuild +       
                    " ORDER BY users.userName ASC LIMIT 10 OFFSET " + ((page - 1) * 10));

        let str = "```";

        if (res.length > 0) {
            str += "|" + "    id    " + "|" + "                nom                " + "|" + "   level   " + "|" + "\n";
            for (let i of res) {
                idCharacterLength = i.idCharacter.toString().length;
                idCharacterLength = (idCharacterMaxLength - idCharacterLength) / 2;

                userNameLength = i.userName.length;
                userNameLength = (userNameMaxLength - userNameLength) / 2;

                actualLevelLength = i.actualLevel.toString().length;
                actualLevelLength = (actualLevelMaxLength - actualLevelLength) / 2;


                str += "|" + " ".repeat(Math.floor(idCharacterLength)) + i.idCharacter + " ".repeat(Math.ceil(idCharacterLength)) + "|"
                    + " ".repeat(Math.floor(usernameLength)) + i.userName + " ".repeat(Math.ceil(usernameLength)) + "|"
                    + " ".repeat(Math.floor(actualLevelLength)) + i.actualLevel + " ".repeat(Math.ceil(actualLevelLength)) + "|\n"
            }
        } else {
            str += "Personne n'a demandé à rejoindre votre guilde.";
        }

        str += "```";
        return str;
    }

    getGuilds(page) {
        let count = conn.query("SELECT COUNT(*) FROM guilds")[0]["COUNT(*)"];
        let maxPage = Math.ceil(count / 10);

        page = page > maxPage || page <= 0 ? 1 : page;

        let res = conn.query("SELECT idGuild, nom, level FROM guilds ORDER BY level ASC LIMIT 10 OFFSET " + ((page - 1) * 10));

        let str = "```";
        let idMaxLength = 10;
        let nameMaxLength = 35;
        let levelMaxLength = 11;
        let guildmembersMaxLenght = 15;

        let idLength;
        let nameLength;
        let levelLength;
        let guildmembersLenght;

        let maxMembers = 0;

        if (res.length > 0) {
            str += "|" + "    id    " + "|" + "                nom                " + "|" + "   level   " + "|" + "    membres    " + "|" + "\n";
            for (let i of res) {
                count = conn.query("SELECT COUNT(*) FROM guildsmembers WHERE idGuild = " + i.idGuild)[0]["COUNT(*)"];
                maxMembers = (Globals.guilds.baseMembers + (Globals.guilds.membersPerLevels * i.level))

                idLength = i.idGuild.toString().length;
                idLength = (idMaxLength - idLength) / 2;

                nameLength = i.nom.length;
                nameLength = (nameMaxLength - nameLength) / 2;

                levelLength = i.level.toString().length;
                levelLength = (levelMaxLength - levelLength) / 2;

                guildmembersLenght = count.toString().length + 1 + maxMembers.toString().length;
                guildmembersLenght = (guildmembersMaxLenght - guildmembersLenght) / 2;



                str += "|" + " ".repeat(Math.floor(idLength)) + i.idGuild + " ".repeat(Math.ceil(idLength)) + "|"
                    + " ".repeat(Math.floor(nameLength)) + i.nom + " ".repeat(Math.ceil(nameLength)) + "|"
                    + " ".repeat(Math.floor(levelLength)) + i.level + " ".repeat(Math.ceil(levelLength)) + "|"
                    + " ".repeat(Math.floor(guildmembersLenght)) + count + "/" + maxMembers + " ".repeat(Math.ceil(guildmembersLenght)) + "|\n"
            }
        } else {
            str += "Rien à afficher ici.";
        }

        str += "Page " + page + "/" + maxPage;

        str += "```";
        return str;

    }


    


}

module.exports = AppliancesManager;
