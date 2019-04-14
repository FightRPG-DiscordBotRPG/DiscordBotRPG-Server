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
    async createGuild(guildName, idCharacter, lang) {
        // Need to verify if guild name already taken
        let res = [];
        let err = [];

        // Verifcation nom guilde
        if (guildName.length > 60 || guildName.length < 4) {
            err.push(Translator.getString(lang, "errors", "guild_name_cant_exceed_x_characters", [60, 4]));
            return err;
        }

        // Verification si nom déjà pris
        res = await conn.query("SELECT idGuild FROM guilds WHERE nom = ?;", [guildName]);
        if (res.length > 0) {
            err.push(Translator.getString(lang, "errors", "guild_name_taken"));
            return err;
        }

        // Create guild
        res = (await conn.query("INSERT INTO guilds VALUES(NULL, ?, '', 1, 0);", [guildName]))["insertId"];
        this.id = res;

        // Insert guild master
        await conn.query("INSERT INTO guildsmembers VALUES(?, ?, 3)", [idCharacter, res]);

        // Add To MemberList
        res = (await conn.query("SELECT users.userName, users.idUser, levels.actualLevel FROM users INNER JOIN levels ON levels.idCharacter = users.idCharacter WHERE users.idCharacter = ?;", [idCharacter]))[0];
        this.members[idCharacter] = {
            name: res["userName"],
            rank: 3,
            idUser: res["idUser"],
            level: res["actualLevel"],
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
    async enroll(idArea) {
        await AreaTournament.enrollGuild(this.id, idArea);
    }

    async unenroll() {
        await AreaTournament.unenrollGuild(this.id);
    }

    async isRegisterToAnTournament() {
        return (await conn.query("SELECT * FROM conquesttournamentinscriptions WHERE idGuild = ?", [this.id]))[0] != null;
    }

    async isTournamentStarted() {
        let res = (await conn.query("SELECT DISTINCT started FROM conquesttournamentinfo INNER JOIN conquesttournamentinscriptions ON conquesttournamentinscriptions.idGuild = ?", [this.id]))[0];
        return res ? res.started : false;
    }

    async getTournamentAreaEnrolled() {
        return (await conn.query("SELECT idArea FROM conquesttournamentinscriptions WHERE idGuild = ?", [this.id]))[0].idArea;
    }


    /**
     * @param {Number} idAsk IDSelf
     * @param {Number} idOther ID Of Character to Add
     * @param {Number} rank (optional) rank
     */
    async addMember(idAsk, idOther, rank, lang) {
        rank = rank ? rank : 1;
        let err = [];
        if (await this.getRankCharacter(idAsk) > 1) {
            if (!await this.isMaxMembersLimitReached()) {
                await conn.query("INSERT INTO guildsmembers VALUES(?,?,?);", [idOther, this.id, rank]);
            } else {
                err.push(Translator.getString(lang, "errors", "guild_maximum_members"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_cant_invite_players"));
        }
        return err;
    }

    async removeMember(idAsk, idOther, lang) {
        let err = [];
        if (await this.isMember(idOther)) {
            let meRank = await this.getRankCharacter(idAsk);
            let otherRank = await this.getRankCharacter(idOther);
            if (meRank > otherRank || idAsk == idOther) {
                if (otherRank < 3) {
                    await conn.query("DELETE FROM guildsmembers WHERE idCharacter = ?;", [idOther]);
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

    async updateMember(idAsk, idOther, rank, lang) {
        let err = [];
        if (await this.isMember(idOther)) {
            let meRank = await this.getRankCharacter(idAsk);
            let otherRank = await this.getRankCharacter(idOther);
            if (meRank > otherRank && rank < meRank) {
                await conn.query("UPDATE guildsmembers SET idGuildRank = ? WHERE idCharacter = ?;", [rank, idOther]);
            } else {
                err.push(Translator.getString(lang, "errors", "generic"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_member_dont_exist"));
        }
        return err;
    }

    async switchGuildLeader(idAsk, idOther, lang) {
        let err = [];
        if (await this.isMember(idOther)) {
            let meRank = await this.getRankCharacter(idAsk);
            if (meRank == 3) {
                await conn.query("UPDATE guildsmembers SET idGuildRank = 3 WHERE idCharacter = ?;", [idOther]);
                await conn.query("UPDATE guildsmembers SET idGuildRank = 1 WHERE idCharacter = ?;", [idAsk]);
            } else {
                err.push(Translator.getString(lang, "errors", "generic"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_member_dont_exist"));
        }
        return err;
    }


    async disband() {
        await conn.query("DELETE FROM areasowners WHERE idGuild = ?;", [this.id]);
        await conn.query("DELETE FROM conquesttournamentinscriptions WHERE idGuild = ?;", [this.id]);
        await conn.query("DELETE FROM guildsmembers WHERE idGuild = ?;", [this.id]);
        await conn.query("DELETE FROM guildsappliances WHERE idGuild = ?;", [this.id]);
        await conn.query("DELETE FROM guilds WHERE idGuild = ?;", [this.id]);
    }

    async canCancelApplies(idCharacter) {
        return (await this.getRankCharacter(idCharacter)) > 1;
    }

    async canRenameGuild(idCharacter) {
        return (await this.getRankCharacter(idCharacter)) === 3;
    }

    async haveEnoughGoldToRename() {
        return (await this.getMoney()) >= Globals.guilds.basePriceLevel;
    }

    async rename(idCharacter, guildName, lang = "en") {
        let err = [];
        if (await this.canRenameGuild(idCharacter)) {
            if (await this.haveEnoughGoldToRename()) {
                err = await this.guildNameValidity(guildName, lang);
                if (err[0] == null) {
                    //rename
                    await Promise.all([
                        conn.query("UPDATE guilds SET nom = ? WHERE idGuild = ?", [guildName, this.id]), this.removeMoneyDirect(Globals.guilds.basePriceLevel)
                    ]);
                }
            } else {
                err.push(Translator.getString(lang, "errors", "guild_you_dont_have_enough_money"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "generic_cant_do_that"));
        }
        return err;
    }

    async guildNameValidity(guildName, lang = "en") {
        // Verifcation nom guilde
        let err = [];
        if (guildName.length > 60 || guildName.length < 4) {
            err.push(Translator.getString(lang, "errors", "guild_name_cant_exceed_x_characters", [60, 4]));
            return err;
        }

        // Verification si nom déjà pris
        let res = await conn.query("SELECT idGuild FROM guilds WHERE nom = ?;", [guildName]);
        if (res.length > 0) {
            err.push(Translator.getString(lang, "errors", "guild_name_taken"));
            return err;
        }

        return err;
    }


    // Guild Load
    async loadGuild(id) {
        // Info guild
        let res = (await conn.query("SELECT * FROM guilds WHERE idGuild = ?;", [id]))[0];
        this.message = res["message"];
        this.name = res["nom"];
        this.id = id;
        this.level = res["level"];
        this.money = res["argent"];
        this.members = {};
        this.nbrMembers = 0;

        // Members
        res = await conn.query("SELECT guildsmembers.idGuildRank, guildsmembers.idCharacter, users.userName, users.idUser, levels.actualLevel FROM guildsmembers INNER JOIN users ON users.idCharacter = guildsmembers.idCharacter INNER JOIN levels ON levels.idCharacter = guildsmembers.idCharacter WHERE guildsmembers.idGuild = ?;", [id]);

        for (let i in res) {
            this.members[res[i]["idCharacter"]] = {
                name: res[i]["userName"],
                rank: res[i]["idGuildRank"],
                idUser: res[i]["idUser"],
                level: res[i]["actualLevel"],
            };
            this.nbrMembers++;
        }

    }

    async getTerritories(lang = "en") {
        let res = await conn.query("SELECT nameArea, nameRegion FROM areasowners INNER JOIN areasregions ON areasregions.idArea = areasowners.idArea INNER JOIN localizationareas ON localizationareas.idArea = areasowners.idArea INNER JOIN localizationregions ON localizationregions.idRegion = areasregions.idRegion WHERE idGuild = ? AND localizationregions.lang = ? AND localizationareas.lang = ? ORDER BY nameRegion;", [this.id, lang, lang]);

        let territories = {};
        for (let territory of res) {
            if (territories[territory.nameRegion] == null) {
                territories[territory.nameRegion] = [];
            }
            territories[territory.nameRegion].push(territory.nameArea);
        }
        return { totalNumberOfTerritories: res.length, territories: territories };
    }

    async toApi() {
        await this.loadGuild(this.id);
        let toApi = {
            members: this.members,
            id: this.id,
            name: this.name,
            image: "https://upload.wikimedia.org/wikipedia/commons/b/b4/Guild-logo-01_.png",
            message: this.message,
            maxMembers: Globals.guilds.baseMembers + (Globals.guilds.membersPerLevels * this.level),
            level: this.level,
            maxLevel: Globals.guilds.maxLevel,
            nextLevelPrice: await this.getNextLevelPrice(this.level),
            money: this.money,

        }
        return toApi;
    }

    async isMaxMembersLimitReached() {
        let maxMembers = Globals.guilds.baseMembers + (Globals.guilds.membersPerLevels * this.level);
        let actualMembers = (await conn.query("SELECT COUNT(*) as nbrMembers FROM guildsmembers WHERE idGuild = ?;", [this.id]))[0].nbrMembers;
        return actualMembers >= maxMembers;
    }

    async isMember(idCharacter) {
        idCharacter = parseInt(idCharacter);
        if (idCharacter == null || Number.isNaN(idCharacter)) {
            return false;
        }
        return (await conn.query("SELECT idCharacter FROM guildsmembers WHERE idGuild = ? AND idCharacter = ?;", [this.id, idCharacter]))[0] != null;
    }

    async getRankCharacter(idCharacter) {
        idCharacter = parseInt(idCharacter);
        if (idCharacter == null || Number.isNaN(idCharacter)) {
            return 1;
        }
        let crank = await conn.query("SELECT idGuildRank FROM guildsmembers WHERE idCharacter = ?;", [idCharacter]);
        return crank[0] != null ? crank[0].idGuildRank : 1;
    }

    async setMessage(idCharacter, message = "", lang = "en") {
        let err = [];
        if (message != null && message != "" && message.length < 255) {
            if (await this.getRankCharacter(idCharacter) >= 2) {
                await this.saveMessage(message);
            } else {
                err.push(Translator.getString(lang, "errors", "you_dont_have_right_to_change_announcement"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "you_cant_exceed_x_characters", [254]));
        }

        return err;
    }

    async saveMessage(message) {
        await conn.query("UPDATE guilds SET message = ? WHERE idGuild = ?;", [message, this.id]);
    }

    /**
     * 
     * @param {number} idGuild 
     * @param {number} number 
     */
    static async addMoney(idGuild, number) {
        idGuild = parseInt(idGuild, 10);
        if (idGuild != null && Number.isInteger(idGuild)) {
            number = number > 0 ? number : -number;
            await conn.query("UPDATE guilds SET argent = argent + ? WHERE idGuild = ?;", [number, idGuild]);
        }
    }

    /**
     * 
     * @param {number} idGuild 
     * @param {number} number 
     */
    static async removeMoney(idGuild, number) {
        idGuild = parseInt(idGuild, 10);
        if (idGuild != null && Number.isInteger(idGuild)) {
            number = number > 0 ? number : -number;
            await conn.query("UPDATE guilds SET argent = argent - ? WHERE idGuild = ?;", [number, idGuild]);
        }
    }

    /**
     * 
     * @param {number} number 
     */
    async addMoneyDirect(number) {
        await conn.query("UPDATE guilds SET argent = argent + ? WHERE idGuild = ?;", [number, this.id]);
    }

    /**
     * 
     * @param {number} number 
     */
    async removeMoneyDirect(number) {
        await conn.query("UPDATE guilds SET argent = argent - ? WHERE idGuild = ?;", [number, this.id]);
    }

    /**
     * 
     * @param {Number} number > 0
     */
    async addMoney(number) {
        if (number > 0) {
            await this.addMoneyDirect(number);
            return true;
        }
        return false;

    }

    async getMoney() {
        return (await conn.query("SELECT argent FROM guilds WHERE idGuild = ?;", [this.id]))[0].argent;
    }

    /**
     * 
     * @param {number} number 
     */
    async haveThisMoney(number) {
        return await this.getMoney() >= number;
    }

    /**
     * Return true if done else false
     * @param {Number} number
     */
    async removeMoney(number, idCharacter, lang) {
        let err = [];
        if (await this.getMoney() >= number && number > 0) {
            if (await this.getRankCharacter(idCharacter) == 3) {
                await this.removeMoneyDirect(number);
            } else {
                err.push(Translator.getString(lang, "errors", "guild_dont_have_right_to_remove_money"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_guild_dont_have_this_amount_of_money"));
        }

        return err;
    }

    /**
     * 
     * @param {number} idCharacter 
     * @param {string} lang 
     * @returns array empty if no errors
     */
    async levelUp(idCharacter, lang) {
        let err = [];
        if (await this.getRankCharacter(idCharacter) >= 2) {
            let lvl = await this.getLevel();
            if (lvl < Globals.guilds.maxLevel) {
                let priceNextLevel = await this.getNextLevelPrice(lvl);
                let money = await this.getMoney();
                if (money >= priceNextLevel) {
                    await Promise.all([
                        this.removeMoneyDirect(priceNextLevel),
                        this.addLevel(1)
                    ]);
                } else {
                    err.push(Translator.getString(lang, "errors", "guild_no_enough_money_to_level_up", [priceNextLevel - money]));
                }
            } else {
                err.push(Translator.getString(lang, "errors", "guild_already_max_level"));
            }
        } else {
            err.push(Translator.getString(lang, "errors", "guild_dont_have_right_to_level_up"));
        }
        return err;
    }

    async getNextLevelPrice(level) {
        if (level != null) {
            return Globals.guilds.basePriceLevel * level * Globals.guilds.multBasePricePerLevel;
        }
        return Globals.guilds.basePriceLevel * (await this.getLevel()) * Globals.guilds.multBasePricePerLevel;
    }

    /**
     * @returns {number}
     */
    async getLevel() {
        return (await conn.query("SELECT level FROM guilds WHERE idGuild = ?;", [this.id]))[0].level;
    }

    async addLevel(number = 1) {
        await conn.query("UPDATE guilds SET level = level + ? WHERE idGuild = ?;", [number, this.id]);
    }

    async apiGetGuildAppliances(page, lang) {
        let maxPage = (await conn.query("SELECT COUNT(*) as nbr FROM guildsappliances WHERE guildsappliances.idGuild = ?;", [this.id]))[0].nbr;
        maxPage = Math.ceil(maxPage / 10);
        maxPage = maxPage <= 0 ? 1 : maxPage;
        page = page <= maxPage ? page : maxPage;
        let res = await conn.query("SELECT guildsappliances.idCharacter as id, users.userName as name, levels.actualLevel as level FROM guildsappliances INNER JOIN users ON users.idCharacter = guildsappliances.idCharacter INNER JOIN levels ON levels.idCharacter = guildsappliances.idCharacter WHERE guildsappliances.idGuild = ? ORDER BY users.userName ASC LIMIT 10 OFFSET ?;", [this.id, (page - 1) * 10]);
        return {
            appliances: res,
            page: page,
            maxPage: maxPage
        }
    }

    /**
     * 
     */
    async deleteGuildAppliances() {
        await conn.query("DELETE FROM guildsappliances WHERE idGuild = ?;", [this.id]);
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
    static async applyTo(idGuild, idCharacter, lang) {
        let err = [];
        if (await this.isGuildExist(idGuild)) {
            if (!await this.haveAlreadyApplied(idGuild, idCharacter)) {
                if (!await this.haveReachAppliesLimit(idCharacter)) {
                    await conn.query("INSERT INTO guildsappliances VALUES(" + idGuild + ", " + idCharacter + ")");
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
    static async isGuildExist(idGuild) {
        let res = await conn.query("SELECT idGuild FROM guilds WHERE idGuild = ?;", [idGuild]);
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
    static async haveAlreadyApplied(idGuild, idCharacter) {
        let res = await conn.query("SELECT idGuild FROM guildsappliances WHERE idCharacter = ? AND idGuild = ?;", [idCharacter, idGuild]);
        if (res.length > 0) {
            return true;
        }
        return false;
    }

    /**
     * Static
     * @param {Number} idCharacter
     */
    static async haveReachAppliesLimit(idCharacter) {
        return (await conn.query("SELECT COUNT(*) FROM guildsappliances WHERE idCharacter = ?;", [idCharacter]))[0]["COUNT(*)"] >= Globals.guilds.maxApplies ? true : false;
    }

    /**
     * Static
     * 
     */
    /*
    static getStatsOfAllMembers(id) {
        let s = await conn.query("SELECT idStat, SUM(value) as total FROM statscharacters WHERE statscharacters.idCharacter IN (SELECT guildsmembers.idCharacter FROM guildsmembers WHERE guildsmembers.idGuild = ?) GROUP BY idStat;", id); 
    }*/


    /**
     * Remove all appliances for a given character
     * @param {Number} idCharacter ID Character
     */
    static async deleteUsersAppliances(idCharacter) {
        await conn.query("DELETE FROM guildsappliances WHERE idCharacter = ?;", [idCharacter]);
    }

    /**
     * 
     * @param {any} idCharacter
     * @param {any} idGuild
     */
    static async deleteUserForThisGuildAppliance(idCharacter, idGuild) {
        await conn.query("DELETE FROM guildsappliances WHERE idCharacter = ? AND idGuild = ?;", [idCharacter, idGuild]);
    }

    /**
     * 
     * @param {any} idCharacter
     */
    static async getAppliances(idCharacter, lang) {
        let res = await conn.query("SELECT guilds.idGuild as id, nom as name, level FROM guildsappliances INNER JOIN guilds ON guilds.idGuild = guildsappliances.idGuild WHERE idCharacter = ?;", [idCharacter]);

        return {
            appliances: res,
            page: 1,
            maxPage: 1
        };
    }

    static async getGuilds(page, lang) {
        let count = (await conn.query("SELECT COUNT(*) FROM guilds"))[0]["COUNT(*)"];
        let maxPage = Math.ceil(count / 10);

        page = page > maxPage || page <= 0 ? 1 : page;

        let res = await conn.query("SELECT guilds.idGuild as id, guilds.nom as name, guilds.level, count(*) as nbMembers FROM guilds INNER JOIN guildsmembers ON guildsmembers.idGuild = guilds.idGuild GROUP BY guilds.idGuild ORDER BY level DESC LIMIT 10 OFFSET ?;", [((page - 1) * 10)]);

        for (let i in res) {
            res[i].maxMembers = (Globals.guilds.baseMembers + (Globals.guilds.membersPerLevels * res[i].level));
        }
        return {
            guilds: res,
            page: page,
            maxPage: maxPage,
        }
    }


}

module.exports = Guild;