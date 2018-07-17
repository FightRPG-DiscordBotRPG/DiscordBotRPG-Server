'use strict';
const conn = require("../conf/mysql.js");
const Discord = require("discord.js");
const Globals = require("./Globals.js");
const Translator = require("./Translator/Translator");
const AreaTournament = require("./AreaTournament/AreaTournament");

class Guild {
    // Discord User Info
    constructor() {
        this.id = 0;
        this.members = {};
        this.message = "";
        this.name = "";
        this.money = 0;
        this.nbrMembers = 0;
        this.level = 1;
    }

    // Create guild
    // Return err = array of errors
    createGuild(guildName, idCharacter, lang) {
        // Need to verify if guild name already taken
        let res = [];
        let err = [];

        // Verifcation nom guilde
        if (guildName.length > 60 || guildName.length < 4) {
            err.push(Translator.getString(lang, "errors", "guild_name_cant_exceed_x_characters", [60,4]));
            return err;
        }

        // Verification si nom déjà pris
        res = conn.query("SELECT idGuild FROM guilds WHERE nom = ?;", [guildName]);
        if (res.length > 0) {
            err.push(Translator.getString(lang, "errors", "guild_name_taken"));
            return err;
        }

        // Create guild
        res = conn.query("INSERT INTO guilds VALUES(NULL, ?, '', 1, 0);", [guildName])["insertId"];
        this.id = res;

        // Insert guild master
        conn.query("INSERT INTO guildsmembers VALUES(" + idCharacter + ", " + res + " , 3)")

        // Add To MemberList
        res = conn.query("SELECT users.userName, users.idUser FROM users " +
            "WHERE idCharacter = " + idCharacter + ";")[0];
        this.members[idCharacter] = {
            name: res["userName"],
            rank: 3,
            idUser: res["idUser"],
        }
        this.nbrMembers++;

        this.name = guildName;
        // err.length = 0 => pas d'erreurs;
        return err;
    }


    // Conquest area

    /**
     * 
     * @param {number} idArea 
     */
    enroll(idArea) {
        AreaTournament.enrollGuild(this.id, idArea);
    }

    unenroll() {
        AreaTournament.unenrollGuild(this.id);
    }
    
    isRegisterToAnTournament() {
        return conn.query("SELECT * FROM conquesttournamentinscriptions WHERE idGuild = ?", [this.id])[0] != null;
    }

    isTournamentStarted() {
        let res = conn.query("SELECT DISTINCT started FROM conquesttournamentinfo INNER JOIN conquesttournamentinscriptions ON conquesttournamentinscriptions.idGuild = ?", [this.id])[0];
        return res ? res.started : false;
    }

    getTournamentAreaEnrolled() {
        return conn.query("SELECT idArea FROM conquesttournamentinscriptions WHERE idGuild = ?", [this.id])[0].idArea;
    }


    /**
     * @param {Number} idAsk IDSelf
     * @param {Number} idOther ID Of Character to Add
     * @param {Number} rank (optional) rank
     */
    addMember(idAsk, idOther, rank, lang) {
        rank = rank ? rank : 1;
        let err = [];
        let res;
        if (this.members[idAsk].rank > 1) {
            if (!this.isMaxMembersLimitReached()) {
                res = conn.query("SELECT users.userName, users.idUser FROM users " +
                    "WHERE idCharacter = " + idOther + ";")[0];
                this.members[idOther] = {
                    name: res["userName"],
                    rank: 1,
                    idUser: res["idUser"],
                }
                conn.query("INSERT INTO guildsmembers VALUES(" + idOther + ", " + this.id + ", " + rank + " );");
                this.nbrMembers++;
            } else {
                err.push(Translator.getString(lang, "errors", "guild_maximum_members"));
            }

        } else {
            err.push(Translator.getString(lang, "errors", "guild_cant_invite_players"));
        }
        return err;
    }

    removeMember(idAsk, idOther, lang) {
        let err = [];
        if (this.members[idOther]) {
            if (this.members[idAsk].rank > this.members[idOther].rank || idAsk == idOther) {
                if (this.members[idOther].rank < 3) {
                    delete this.members[idOther];
                    conn.query("DELETE FROM guildsmembers WHERE idCharacter = " + idOther + ";");
                    this.nbrMembers--;
                } else {
                    err.push(Translator.getString(lang, "errors", "guild_cant_leave_guild_as_gm"));
                }

            } else {
                err.push(Translator.getString(lang, "errors", "guild_dont_have_right_to_kick"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_member_dont_exist"));
        }

        return err;
    }

    updateMember(idAsk, idOther, rank, lang) {
        let err = [];
        if (this.members[idOther]) {
            if (this.members[idAsk].rank > this.members[idOther].rank && rank < this.members[idAsk].rank) {
                conn.query("UPDATE guildsmembers SET idGuildRank = " + rank + " WHERE idCharacter = " + idOther + ";");
                this.members[idOther].rank = rank;
            } else {
                err.push(Translator.getString(lang, "errors", "generic"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_member_dont_exist"));
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
        let res = conn.query("SELECT * FROM guilds WHERE idGuild = " + id + ";")[0];
        this.message = res["message"];
        this.name = res["nom"];
        this.id = id;
        this.level = res["level"];
        this.money = res["argent"];

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
            this.nbrMembers++;
        }

    }

    toStr(lang) {
        this.loadMoney();
        let membersStr = "```";
        let rmStr = "";
        let roStr = "";
        let rgmStr = "";
        for (let i in this.members) {
            switch (this.members[i].rank) {
                case 1:
                    rmStr += i + " | " + this.members[i].name + " | " + Translator.getString(lang, "guild", "member") + "\n";
                    break;
                case 2:
                    roStr += i + " | " + this.members[i].name + " | " + Translator.getString(lang, "guild", "officer") + "\n";
                    break;
                case 3:
                    rgmStr += i + " | " + this.members[i].name + " | " + Translator.getString(lang, "guild", "guild_master") + "\n";
                    break;
            }
        }

        membersStr += rgmStr + roStr + rmStr + "```";

        let embed = new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.name, "https://upload.wikimedia.org/wikipedia/commons/b/b4/Guild-logo-01_.png")
            .addField(Translator.getString(lang, "guild", "guild_announcement"), (this.message ? this.message : Translator.getString(lang, "guild", "no_guild_announcement")))
            .addField(Translator.getString(lang, "guild", "members_out_of", [this.nbrMembers, (Globals.guilds.baseMembers + (Globals.guilds.membersPerLevels * this.level))]), membersStr)
            .addField(Translator.getString(lang, "guild", "level_out_of", [this.level, Globals.guilds.maxLevel]), Translator.getString(lang, "guild", "required_to_level_up", [this.getNextLevelPrice()]), true)
            .addField(Translator.getString(lang, "guild", "money_available"), Translator.getString(lang, "guild", "money", [this.money]), true);

        return embed;
    }

    getIdUserByIdCharacter(idCharacter) {
        return this.members[idCharacter] ? this.members[idCharacter].idUser : null;
    }

    isMaxMembersLimitReached() {
        return Object.keys(this.members).length < (Globals.guilds.baseMembers + (Globals.guilds.membersPerLevels * this.level)) ? false : true;
    }

    setMessage(idCharacter, message, lang) {
        let err = [];

        if (message.length < 255) {
            if (this.members[idCharacter].rank >= 2) {
                this.message = message;
                this.saveMessage();
            } else {
                err.push(Translator.getString(lang, "errors", "you_dont_have_right_to_change_announcement"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "you_cant_exceed_x_characters", [254]));
        }

        return err;
    }

    saveMessage() {
        conn.query("UPDATE guilds SET message = ? WHERE idGuild = " + this.id, [this.message]);
    }

    saveMoney() {
        conn.query("UPDATE guilds SET argent = " + this.money + " WHERE idGuild = " + this.id);
    }

    saveLevel() {
        conn.query("UPDATE guilds SET level = " + this.level + " WHERE idGuild = " + this.id);
    }

    /**
     * 
     * @param {number} idGuild 
     * @param {number} number 
     */
    static addMoney(idGuild, number) {
        number = number > 0 ? number : -number;
        conn.query("UPDATE guilds SET argent = argent + ? WHERE idGuild = ?", [number, idGuild]);
    }

    /**
     * 
     * @param {number} idGuild 
     * @param {number} number 
     */
    static removeMoney(idGuild, number) {
        number = number > 0 ? number : -number;
        conn.query("UPDATE guilds SET argent = argent - ? WHERE idGuild = ?", [number, idGuild]);
    }

    /**
     * 
     * @param {number} number 
     */
    addMoneyDirect(number) {
        conn.query("UPDATE guilds SET argent = argent + ? WHERE idGuild = ?", [number, this.id]);
    }

    /**
     * 
     * @param {number} number 
     */
    removeMoneyDirect(number) {
        conn.query("UPDATE guilds SET argent = argent - ? WHERE idGuild = ?", [number, this.id]);
    }

    /**
     * 
     * @param {Number} number > 0
     */
    addMoney(number) {
        if (number > 0) {
            /*this.money += number;
            this.saveMoney();*/
            this.addMoneyDirect(number);
            return true;
        }
        return false;

    }

    /**
     * 
     * @param {number} number 
     */
    haveThisMoney(number) {
        this.loadMoney();
        console.log(this.money + " -> " + number);
        return this.money >= number;
    }

    /**
     * Return true if done else false
     * @param {Number} number
     */
    removeMoney(number, idCharacter, lang) {
        let err = [];
        this.loadMoney();
        if (this.money >= number && number > 0) {
            if (this.members[idCharacter].rank == 3) {
                this.money -= number;
                this.saveMoney();
            } else {
                err.push(Translator.getString(lang, "errors", "guild_dont_have_right_to_remove_money"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_guild_dont_have_this_amount_of_money"));
        }

        return err;
    }

    loadMoney() {
        this.money = conn.query("SELECT argent FROM guilds WHERE idGuild = ?;", [this.id])[0].argent;
    }

    /**
     * 
     * @param {number} idCharacter 
     * @param {string} lang 
     * @returns array empty if no errors
     */
    levelUp(idCharacter, lang) {
        let err = [];

        if (this.members[idCharacter].rank >= 2) {
            if (this.level < Globals.guilds.maxLevel) {
                if (this.money >= this.getNextLevelPrice()) {
                    this.money -= this.getNextLevelPrice();
                    this.saveMoney();
                    this.level += 1;
                    this.saveLevel();
                } else {
                    err.push(Translator.getString(lang, "errors", "guild_no_enough_money_to_level_up", [this.getNextLevelPrice()]));
                }
            } else {
                err.push(Translator.getString(lang, "errors", "guild_already_max_level"));
            }
            
        
        } else {
            err.psuh(Translator.getString(lang, "errors", "guild_dont_have_right_to_level_up"));
        }


        return err;
    }

    getNextLevelPrice() {
        return Globals.guilds.basePriceLevel * this.level * Globals.guilds.multBasePricePerLevel;
    }

    /**
     * 
     * @param {number} page 
     * @param {string} lang 
     */
    getGuildAppliances(page, lang) {
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
            "WHERE guildsappliances.idGuild = " + this.id +
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
                    + " ".repeat(Math.floor(userNameLength)) + i.userName + " ".repeat(Math.ceil(userNameLength)) + "|"
                    + " ".repeat(Math.floor(actualLevelLength)) + i.actualLevel + " ".repeat(Math.ceil(actualLevelLength)) + "|\n"
            }
        } else {
            str += Translator.getString(lang, "guild", "nobody_ask_to_join_your_guild");
        }

        str += "```";
        return str;
    }

    /**
     * 
     */
    deleteGuildAppliances() {
        conn.query("DELETE FROM guildsappliances WHERE idGuild = " + this.id);
    }

    /*
     * Static Methods
     * 
     */
    // Apply to a guild
    /**
     * Apply to guild
     * @param {Number} idGuild
     * @param {Number} idCharacter
     * @returns {Array}
     */
    static applyTo(idGuild, idCharacter, lang) {
        let err = [];
        if (this.isGuildExist(idGuild)) {
            if (!this.haveAlreadyApplied(idGuild, idCharacter)) {
                if (!this.haveReachAppliesLimit(idCharacter)) {
                    conn.query("INSERT INTO guildsappliances VALUES(" + idGuild + ", " + idCharacter + ")");
                } else {
                    err.push(Translator.getString(lang, "errors", "guild_player_reach_max_applies", [Globals.guilds.maxApplies]));
                }

            } else {
                err.push(Translator.getString(lang, "errors", "guild_player_already_applied"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_not_exist"));
        }
        return err;
    }


    /**
     * Return if guild exist or not
     * @param {Number} idGuild 
     */
    static isGuildExist(idGuild) {
        let res = conn.query("SELECT idGuild FROM guilds WHERE idGuild = " + idGuild);
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
    static haveAlreadyApplied(idGuild, idCharacter) {
        let res = conn.query("SELECT idGuild FROM guildsappliances WHERE idCharacter = " + idCharacter + " AND idGuild = " + idGuild + ";");
        if (res.length > 0) {
            return true;
        }
        return false;
    }

    /**
     * Static
     * @param {Number} idCharacter
     */
    static haveReachAppliesLimit(idCharacter) {
        return conn.query("SELECT COUNT(*) FROM guildsappliances WHERE idCharacter = " + idCharacter)[0]["COUNT(*)"] >= Globals.guilds.maxApplies ? true : false;
    }

    /**
     * Static
     * 
     */
    /*
    static getStatsOfAllMembers(id) {
        let s = conn.query("SELECT idStat, SUM(value) as total FROM statscharacters WHERE statscharacters.idCharacter IN (SELECT guildsmembers.idCharacter FROM guildsmembers WHERE guildsmembers.idGuild = ?) GROUP BY idStat;", id); 
    }*/


    /**
     * Remove all appliances for a given character
     * @param {Number} idCharacter ID Character
     */
    static deleteUsersAppliances(idCharacter) {
        conn.query("DELETE FROM guildsappliances WHERE idCharacter = " + idCharacter);
    }

    /**
     * 
     * @param {any} idCharacter
     * @param {any} idGuild
     */
    static deleteUserForThisGuildAppliance(idCharacter, idGuild) {
        conn.query("DELETE FROM guildsappliances WHERE idCharacter = " + idCharacter + " AND idGuild = " + idGuild);
    }

    /**
     * 
     * @param {any} idCharacter
     */
    static getAppliances(idCharacter, lang) {
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
            str += Translator.getString(lang, "guild", "guild_no_apply_player");
        }


        str += "```";
        return str;
    }

    static getGuilds(page, lang) {
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
            str += Translator.getString(lang, "guild", "nothing_to_print");
        }

        str +=  Translator.getString(lang, "general", "page_out_of_x", [page, maxPage]);

        str += "```";
        return str;

    }






}

module.exports = Guild;
