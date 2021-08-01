'use strict';
const conn = require("../conf/mysql.js");
const Character = require("./Character");
const ProgressBar = require("./ProgressBar.js");
const Globals = require("./Globals.js");
const Crypto = require("crypto");
const DatabaseInitializer = require("./DatabaseInitializer");
const Translator = require("./Translator/Translator");
const axios = require("axios").default;
const conf = require("../conf/conf");

class User {
    // Discord User Info
    constructor(id, username, avatar) {
        this.id = id;
        this.character = new Character(id);
        this.avatar = avatar != null ? avatar : "";
        this.username = username; //username.replace(/[\u0800-\uFFFF]/g, '');
        this.isNew = false;
        this.lastCommandTime = Date.now();
        this.isConnected = false;

        this.preferences = {
            lang: "en",
            groupmute: false,
            marketplacemute: false,
            fightmute: false,
            trademute: false,
            worldbossmute: false,
        };
    }

    // Init for new user
    async init() {
        this.isNew = true;
        await this.character.init();
        this.character.name = this.username;

        // Token for mobile / website use
        let nToken = Crypto.randomBytes(16).toString('hex');
        let res = await conn.query("SELECT * FROM users WHERE token = ?;", [nToken]);
        while (res[0]) {
            nToken = Crypto.randomBytes(16).toString('hex');
            res = await conn.query("SELECT * FROM users WHERE token = ?;", [nToken]);
        }
        await conn.query("INSERT IGNORE INTO `users` (`idUser`, `idCharacter`, `userName`, `token`, `isConnected`, `avatar`) VALUES (?, ?, ?, ?, true, ?);", [this.id, this.character.id, this.username, nToken, this.avatar]);
        await conn.query("INSERT IGNORE INTO `userspreferences` (`idUser`) VALUES (?);", [this.id]);
        await DatabaseInitializer.PStats();
    }

    updateInMemmoryUsername(username) {
        this.username = username;
        this.character.name = username;
    }

    // Load user from DB
    // If not exist create new one
    async loadUser() {
        let res = await conn.query("SELECT * FROM users WHERE idUser = ?;", [this.id]);
        if (res.length === 0) {
            // S'il n'existe pas on le crée
            await this.init();
        } else {
            // Sinon on le load
            await this.character.loadCharacter(res[0]["idCharacter"]);
            this.isConnected = res[0]["isConnected"];
            if (this.username != null && this.username != res[0]["userName"]) {
                await conn.query("UPDATE users SET userName = ? WHERE idUser = ?", [this.username, this.id]);
            } else {
                this.username = res[0]["userName"];
            }

            if (this.avatar != "" && this.avatar != res[0]["avatar"]) {
                await conn.query("UPDATE users SET avatar = ? WHERE idUser = ?", [this.avatar, this.id]);
            } else {
                this.avatar = res[0]["avatar"];
            }

            await conn.query("UPDATE users SET isConnected = true WHERE idUser = ?", [this.id]);

            //this.username = res[0]["userName"];
            this.character.name = this.username;

            res = await conn.query("SELECT * FROM userspreferences WHERE idUser = ?", [this.id]);

            // TODO verify if load from db or not when asking for it
            this.preferences.lang = res[0]["lang"];
            this.preferences.groupmute = res[0]["groupmute"];
            this.preferences.marketplacemute = res[0]["marketplacemute"];
            this.preferences.fightmute = res[0]["fightmute"];
            this.preferences.trademute = res[0]["trademute"];
            this.preferences.worldbossmute = res[0]["worldbossmute"];
        }

    }

    /**
    * Loads a lighter version of the user (only stats, and equipements)
    * USE WITH CAUTION ONLY FOR PVP FIGHTS (Don't use any non loaded components)
    * ONLY IF THE USER EXIST IF NOT THROW EXCEPTION
    */
    async lightLoad() {
        let res = await conn.query("SELECT * FROM users WHERE idUser = ?;", [this.id]);
        if (res.length === 0) {
            throw "You can't light load a non existing user";
        } else {
            await this.character.lightLoad(res[0]["idCharacter"]);
            this.username = res[0]["userName"];
            this.avatar = res[0]["avatar"];
            this.character.name = this.username;

            // Could be useful if we want to send specific dm to the user
            // Uncomment if so
            //res = await conn.query("SELECT * FROM userspreferences WHERE idUser = ?", [this.id]);

            //this.preferences.lang = res[0]["lang"];
            //this.preferences.groupmute = res[0]["groupmute"];
            //this.preferences.marketplacemute = res[0]["marketplacemute"];
            //this.preferences.fightmute = res[0]["fightmute"];
            //this.preferences.trademute = res[0]["trademute"];
        }
    }

    async loadGroup() {
        this.character.group = new Group();
        this.character.pendingPartyInvite = new Group();

        await Promise.all([
            this.character.group.load(this.id, false),
            this.character.pendingPartyInvite.load(this.id, true),
        ]);
    }

    static async getUserId(token) {
        let res = await conn.query("SELECT idUser FROM users WHERE token = ?;", [token]);
        if (res[0]) {
            return res[0]["idUser"];
        }
        return undefined;
    }

    static async getUserNameByIdCharacter(idCharacter) {
        let res = await conn.query("SELECT userName FROM users WHERE idCharacter = ?", [idCharacter]);
        return res[0] ? res[0]["userName"] : null;
    }

    static async exist(idUser) {
        let res = await conn.query("SELECT * FROM users WHERE idUser = ?;", [idUser]);
        return res[0] != null;
    }

    static async getCharacterId(idUser) {
        let res = await conn.query("SELECT idCharacter FROM users WHERE idUser = ?;", [idUser]);
        return res[0] != null ? res[0].idCharacter : null;
    }

    static async getIdAndLang(idUser) {
        let res = await conn.query("SELECT idCharacter, lang FROM users INNER JOIN userspreferences ON userspreferences.idUser = users.idUser WHERE users.idUser = ?;", [idUser]);
        return res[0] != null ? res[0] : null;
    }

    static async getIDByIDCharacter(idCharacter) {
        let res = await conn.query("SELECT idUser FROM users WHERE idCharacter = ?;", [idCharacter]);
        return res[0] != null ? res[0].idUser : null;
    }

    /**
     * 
     * @param {number} idCharacter
     * @returns {Promise<{idUser:string, lang: string}>}
     */
    static async getIDByIDCharacterAndLang(idCharacter) {
        let res = await conn.query("SELECT users.idUser, lang FROM users INNER JOIN userspreferences ON userspreferences.idUser = users.idUser WHERE idCharacter = ?;", [idCharacter]);
        return res[0];
    }

    getUsername() {
        return this.username;
    }

    getUserId() {
        return this.id;
    }

    async getToken() {
        return (await conn.query("SELECT token FROM users WHERE idUser = " + this.id + ";"))[0]["token"];
    }

    async changeLang(lang) {
        this.preferences.lang = lang;
        await conn.query("UPDATE userspreferences SET lang = ? WHERE idUser = ?", [lang, this.id]);
    }

    getLang() {
        return this.preferences.lang;
        //return conn.query("SELECT lang FROM userspreferences WHERE idUser = ?", [this.id])[0]["lang"];
    }

    isGroupMuted() {
        return this.preferences.groupmute;
        //return conn.query("SELECT groupmute FROM userspreferences WHERE idUser = ?", [this.id])[0]["groupmute"];
    }

    isFightMuted() {
        return this.preferences.fightmute;
    }

    isMarketplaceMuted() {
        return this.preferences.marketplacemute;
        //return conn.query("SELECT marketplacemute FROM userspreferences WHERE idUser = ?", [this.id])[0]["marketplacemute"];
    }

    isTradeMuted() {
        return this.preferences.trademute;
    }

    isWorldBossesMuted() {
        return this.preferences.worldbossmute;
    }

    static async isWorldBossesMuted(idUser) {
        return conn.query("SELECT worldbossmute FROM userspreferences WHERE idUser = ?;", [idUser]);
    }

    isAchievementsMuted() {
        return false;
    }

    async muteWorldBoss(bool) {
        this.preferences.worldbossmute = bool;
        await conn.query("UPDATE userspreferences SET worldbossmute = ? WHERE idUser = ?;", [bool, this.id]);
    }

    async muteGroup(bool) {
        this.preferences.groupmute = bool;
        await conn.query("UPDATE userspreferences SET groupmute = ? WHERE idUser = ?;", [bool, this.id]);
    }

    async muteMarketplace(bool) {
        this.preferences.marketplacemute = bool;
        await conn.query("UPDATE userspreferences SET marketplacemute = ? WHERE idUser = ?;", [bool, this.id]);
    }

    async muteFight(bool) {
        this.preferences.fightmute = bool;
        await conn.query("UPDATE userspreferences SET fightmute = ? WHERE idUser = ?;", [bool, this.id]);
    }

    async muteTrade(bool) {
        this.preferences.trademute = bool;
        await conn.query("UPDATE userspreferences SET trademute = ? WHERE idUser = ?;", [bool, this.id]);
    }

    async worldBossTell(str) {
        if (!this.isWorldBossesMuted()) {
            this.tell(str);
        }
    }

    static async worldBossTell(idUser, str) {
        if (!await User.isWorldBossesMuted(idUser)) {
            User.tell(idUser, str);
        }
    }

    async marketTell(str) {
        if (!this.isMarketplaceMuted()) {
            this.tell(str);
        }
    }

    async groupTell(str) {
        if (!this.isGroupMuted()) {
            this.tell(str);
        }
    }

    async achievementTell(str) {
        if (!this.isAchievementsMuted()) {
            this.tell(str);
        }
    }

    async tradeTell(str) {
        if (!this.isTradeMuted()) {
            this.tell(str);
        }
    }

    async tell(str) {
        User.tell(this.id, str);
    }

    static async tell(id, str) {
        try {
            for (let addr of conf.discordBotAddresses) {
                let res = await axios.post(`http://${addr}/usr`, {
                    id: id,
                    message: str,
                });

                // Well sended user found
                if (res.data.sended === true) {
                    break;
                }
            }
        } catch (e) {
            console.log(e);
        }
    }

    // Info pannel API
    async apiInfoPanel() {

        let allPromises = [this.character.getStatPoints(), this.character.getTalentPoints(), this.character.talents.toApi(), this.character.getMoney(), this.character.getHonor(), this.character.getPower(), this.character.getAchievements().getCountsAchievements(), this.toApiToRebirth()];

        let infos = {
            actualXp: this.character.levelSystem.actualXP,
            xpNextLevel: this.character.levelSystem.expToNextLevel,
            username: this.character.name,
            avatar: this.avatar,

            resetValue: this.character.getResetStatsValue(),
            stats: this.character.stats.toApi(),
            secondaryStats: this.character.secondaryStats.toApi(),

            level: this.character.getLevel(),

            attributesResults: {
                magicalCriticalEvasionRate: this.character.getMagicalCriticalEvasionRate(this.character.getLevel()),
                magicalCriticalRate: this.character.getMagicalCriticalRate(this.character.getLevel()),
                magicalDefense: this.character.getMagicalDefense(this.character.getLevel()),
                physicalCriticalEvasionRate: this.character.getPhysicalCriticalEvasionRate(this.character.getLevel()),
                physicalCriticalRate: this.character.getPhysicalCriticalRate(this.character.getLevel()),
                physicalDefense: this.character.getPhysicalDefense(this.character.getLevel()),
            },
            maxLevel: Globals.maxLevel,
            statsEquipment: this.character.equipement.stats.toApi(),
            secondaryStatsEquipment: this.character.equipement.secondaryStats.toApi(),
            currentHp: this.character.actualHP,
            maxHp: this.character.maxHP,
            currentMp: this.character.actualMP,
            maxMp: this.character.maxMP,
            currentEnergy: this.character.actualEnergy,
            maxEnergy: this.character.maxEnergy,
            lang: this.getLang(),
        };

        allPromises = await Promise.all(allPromises);

        infos.statPoints = allPromises[0];
        infos.talentPoints = allPromises[1];
        infos.talents = allPromises[2];
        infos.money = allPromises[3];
        infos.honor = allPromises[4];
        infos.power = allPromises[5];
        infos.achievements = allPromises[6];

        infos = { ...infos, ...allPromises[7] };

        infos.craft = {
            level: this.character.getCraftLevel(),
            xp: this.character.getCratfXP(),
            xpNextLevel: this.character.getCraftNextLevelXP(),
            ...infos.craft
        }

        return infos;

    }

    async toApiToRebirth(lang = "en") {

        let promises = [this.character.getRebirthDataCharacterToApi(lang), this.character.getRebirthDataCraftToApi(lang)];
        promises = await Promise.all(promises);
        let data = { ...promises[0], craft: promises[1], lang: this.getLang() }

        return data;
    }

    canBeUnstuck() {
        return Date.now() - this.lastCommandTime >= 5000;
    }

    async lockUser() {
        await this.setLockState(true);
    }

    async unlockUser() {
        await this.setLockState(false);
    }

    async setLockState(bool=false) {
        await conn.query("UPDATE users SET isDoingSomething = ? WHERE idUser = ?;", [bool, this.id]);
    }

    async isDoingSomething() {
        const res = await conn.query("SELECT isDoingSomething FROM users WHERE idUser = ?;", [this.id]);
        if (res[0]) {
            return res[0].isDoingSomething;
        }
        return false;
    }



}

module.exports = User;

const Group = require("./Group.js");
