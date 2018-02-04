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

        if (res.length > 0) {
            for (let i in res) {
                str += res[i].idGuild + " | " + res[i].nom + " | " + res[i].level + "\n";
            }
        } else {
            str += "Vous ne postulez pas pour rejoindre une guilde.";
        }


        str += "```";
        return str;
    }

    getGuildAppliances(idGuild) {
        let res = conn.query("SELECT guildsappliances.idCharacter, users.userName, levels.actualLevel FROM guildsappliances " +
                    "INNER JOIN users ON users.idCharacter = guildsappliances.idCharacter " +
                    "INNER JOIN levels ON levels.idCharacter = guildsappliances.idCharacter " +
                    "WHERE guildsappliances.idGuild = " + idGuild);

        let str = "```";

        if (res.length > 0) {
            for (let i in res) {
                str += res[i].idCharacter + " | " + res[i].userName + " | " + res[i].actualLevel + "\n";
            }
        } else {
            str += "Personne n'a demandé à rejoindre votre guilde.";
        }

        str += "```";
        return str;
    }


    


}

module.exports = AppliancesManager;
