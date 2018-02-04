'use strict';
const conn = require("../conf/mysql.js");
const Discord = require("discord.js");
const Globals = require("./Globals.js");

class Guild {
    // Discord User Info
    constructor() {
        this.id = 0;
        this.members = {};
        this.message = "";
        this.name = "";
        this.nbrMembers = 0;
    }

    // Create guild
    // Return err = array of errors
    createGuild(guildName, idCharacter) {
        // Need to verify if guild name already taken
        let res = [];
        let err = [];

        // Verifcation nom guilde
        if (guildName.length > 60 || guildName.length < 4) {

            err.push("Le nom de la guilde doit ne doit pas dépasser 60 caratères ou être inférieur à 4 caractères.");
            return err;
        }

        // Verification si nom déjà pris
        res = conn.query("SELECT idGuild FROM Guilds WHERE nom = '" + guildName + "';");
        if (res.length > 0) {
            err.push("Ce nom de guilde est déjà pris.");
            return err;
        }

        // Create guild
        res = conn.query("INSERT INTO Guilds VALUES(NULL, '" + guildName + "', '', 1);")["insertId"];

        // Insert guild master
        conn.query("INSERT INTO GuildsMembers VALUES(" + idCharacter + ", " + res + " , 3)")

        this.id = res;
        this.name = guildName;
        // err.length = 0 => pas d'erreurs;
        return err;
    }

    /**
     * @param {Number} idAsk IDSelf
     * @param {Number} idOther ID Of Character to Add
     * @param {Number} rank (optional) rank
     */
    addMember(idAsk, idOther, rank) {
        rank = rank ? rank : 1;
        let err = [];
        let res;
        if (this.members[idAsk].rank > 1) {
            if (!this.isMaxMembersLimitReached()) {
                res = conn.query("SELECT users.userName, users.idUser FROM users " +
                    "WHERE idCharacter = " + idOther + ";")[0];
                this.members[idOther] = {
                    name: res["userName"],
                    rank: rank,
                    idUser: res["idUser"],
                }
                conn.query("INSERT INTO guildsmembers VALUES(" + idOther + ", " + this.id + ", " + rank + " );");
            } else {
                err.push("Vous avez atteint le nombre maximal de membres.");
            }

        } else {
            err.push("Vous n'avez pas la permission d'ajouter des membres.");
        }
        return err;
    }

    removeMember(idAsk, idOther) {
        let err = [];
        if (this.members[idOther]) {
            if (this.members[idAsk].rank > this.members[idOther].rank || idAsk == idOther) {
                delete this.members[idOther];
                conn.query("DELETE FROM guildsmembers WHERE idCharacter = " + idOther + ";");
            } else {
                err.push("Vous n'avez pas les droits pour supprimer ce membre.");
            }
        } else {
            err.push("Ce membre n'existe pas.");
        }

        return err;
    }

    updateMember(idAsk, idOther, rank) {
        let err = [];
        if (this.members[idOther]) {
            if (this.members[idAsk].rank > this.members[idOther].rank && rank < this.members[idAsk].rank) {
                conn.query("UPDATE guildsmembers SET idGuildRank = " + rank + " WHERE idCharacter = " + idOther + ";");
                this.members[idOther].rank = rank;
            } else {
                err.push("Vous ne pouvez pas faire cela.");
            }
        } else {
            err.push("Ce membre n'existe pas.");
        }
        
        return err;
    }

    
    disband(connectedUsers) {
        conn.query("DELETE FROM guildsmembers WHERE idGuild = " + this.id);
        conn.query("DELETE FROM guildsappliances WHERE idGuild = " + this.id);
        conn.query("DELETE FROM guilds WHERE idGuild = " + this.id);
        for (let i in this.members) {
            if (connectedUsers[this.members[i].idUser]) {
                connectedUsers[this.members[i].idUser].character.idGuild = 0;
            }
        }
    }

    canCancelApplies(idCharacter) {
        return this.members[idCharacter].rank > 1 ? true : false;
    }



    // Guild Load
    loadGuild(id) {
        // Info guild
        let res = conn.query("SELECT * FROM Guilds WHERE idGuild = " + id + ";")[0];
        this.message = res["message"];
        this.name = res["nom"];
        this.id = id;
        this.level = res["level"];
        // Members
        res = conn.query("SELECT guildsmembers.idGuildRank, guildsmembers.idCharacter, users.userName, users.idUser FROM guildsmembers " +
            "INNER JOIN users ON users.idCharacter = guildsmembers.idCharacter " +
            "WHERE guildsmembers.idGuild = " + id + ";");

        for (let i in res) {
            this.members[res[i]["idCharacter"]] = {
                name: res[i]["userName"],
                rank: res[i]["idGuildRank"],
                idUser: res[i]["idUser"],
            };
        }

    }

    toStr() {
        let str = "";
        str += this.name + "\n";
        for (let i in this.members) {
            str += i + " | " + this.members[i].name + " | rank : " + this.members[i].rank + "\n";
        }
        return str;
    }

    getIdUserByIdCharacter(idCharacter) {
        return this.members[idCharacter] ? this.members[idCharacter].idUser : null;
    }

    isMaxMembersLimitReached() {
        return Object.keys(this.members).length < (Globals.guilds.baseMembers + (Globals.guilds.membersPerLevels * this.level)) ? false : true;
    }


}

module.exports = Guild;
