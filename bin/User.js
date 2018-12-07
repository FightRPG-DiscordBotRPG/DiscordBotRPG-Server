'use strict';
const conn = require("../conf/mysql.js");
const Character = require("./Character");
const Discord = require("discord.js");
const ProgressBar = require("./ProgressBar.js");
const Globals = require("./Globals.js");
const Crypto = require("crypto");
const DatabaseInitializer = require("./DatabaseInitializer");
const Translator = require("./Translator/Translator");
const axios = require("axios").default;

class User {
    // Discord User Info
    constructor(id, username, avatar) {
        this.id = id;
        this.character = new Character();
        this.avatar = avatar != null ? avatar : "";
        this.username = username; //username.replace(/[\u0800-\uFFFF]/g, '');
        this.isNew = false;

        this.preferences = {
            lang: "en",
            groupmute: false,
            marketplacemute: false,
        };
    }

    // Init for new user
    init() {
        this.isNew = true;
        this.character.init();
        this.character.name = this.username;

        // Token for mobile / website use
        let nToken = Crypto.randomBytes(16).toString('hex');
        let res = conn.query("SELECT * FROM users WHERE token = ?;", [nToken]);
        while (res[0]) {
            nToken = Crypto.randomBytes(16).toString('hex');
            res = conn.query("SELECT * FROM users WHERE token = ?;", [nToken]);
        }
        conn.query("INSERT IGNORE INTO `users` (`idUser`, `idCharacter`, `userName`, `token`, `isConnected`, `avatar`) VALUES (?, ?, ?, ?, true, ?);", [this.id, this.character.id, this.username, nToken, this.avatar]);
        conn.query("INSERT IGNORE INTO `userspreferences` (`idUser`) VALUES (?);", [this.id]);
        DatabaseInitializer.PStats();
    }

    // Load user from DB
    // If not exist create new one
    loadUser() {
        let res = conn.query("SELECT * FROM users WHERE idUser = " + this.id);
        if (res.length === 0) {
            // S'il n'existe pas on le crée
            this.init();
        } else {
            // Sinon on le load
            this.character.loadCharacter(res[0]["idCharacter"]);
            if (this.username != null && this.username != res[0]["userName"]) {
                conn.query("UPDATE users SET userName = ? WHERE idUser = ?", [this.username, this.id]);
            } else {
                this.username = res[0]["userName"];
            }

            if (this.avatar != "" && this.avatar != res[0]["avatar"]) {
                conn.query("UPDATE users SET avatar = ? WHERE idUser = ?", [this.avatar, this.id]);
            } else {
                this.avatar = res[0]["avatar"];
            }

            conn.query("UPDATE users SET isConnected = true WHERE idUser = ?", [this.id]);

            //this.username = res[0]["userName"];
            this.character.name = this.username;

            res = conn.query("SELECT * FROM userspreferences WHERE idUser = ?", [this.id]);

            this.preferences.lang = res[0]["lang"];
            this.preferences.groupmute = res[0]["groupmute"];
            this.preferences.marketplacemute = res[0]["marketplacemute"];
        }

    }

    static getUserId(token) {
        let res = conn.query("SELECT idUser FROM users WHERE token = ?;", [token]);
        if (res[0]) {
            return res[0]["idUser"];
        }
        return undefined;
    }

    static getUserNameByIdCharacter(idCharacter) {
        let res = conn.query("SELECT userName FROM users WHERE idCharacter = ?", [idCharacter]);
        return res[0] ? res[0]["userName"] : null;
    }

    static exist(idUser) {
        let res = conn.query("SELECT * FROM users WHERE idUser = ?;", [idUser]);
        return res[0] != null;
    }

    static getCharacterId(idUser) {
        let res = conn.query("SELECT idCharacter FROM users WHERE idUser = ?;", [idUser]);
        return res[0] != null ? res[0].idCharacter : null;
    }

    static getIdAndLang(idUser) {
        let res = conn.query("SELECT idCharacter, lang FROM users INNER JOIN userspreferences ON userspreferences.idUser = users.idUser WHERE users.idUser = ?;", [idUser]);
        return res[0] != null ? res[0] : null;
    }

    getUsername() {
        return this.username;
    }

    getUserId() {
        return this.id;
    }

    getToken() {
        return conn.query("SELECT token FROM users WHERE idUser = " + this.id + ";")[0]["token"];
    }

    saveUser() {
        this.character.saveCharacter();
    }

    changeLang(lang) {
        this.preferences.lang = lang;
        conn.query("UPDATE userspreferences SET lang = ? WHERE idUser = ?", [lang, this.id]);
    }

    getLang() {
        return this.preferences.lang;
        //return conn.query("SELECT lang FROM userspreferences WHERE idUser = ?", [this.id])[0]["lang"];
    }

    isGroupMuted() {
        return this.preferences.groupmute;
        //return conn.query("SELECT groupmute FROM userspreferences WHERE idUser = ?", [this.id])[0]["groupmute"];
    }

    isMarketplaceMuted() {
        return this.preferences.marketplacemute;
        //return conn.query("SELECT marketplacemute FROM userspreferences WHERE idUser = ?", [this.id])[0]["marketplacemute"];
    }

    muteGroup(bool) {
        this.preferences.groupmute = bool;
        conn.query("UPDATE userspreferences SET groupmute = ? WHERE idUser = ?", [bool, this.id]);
    }

    muteMarketplace(bool) {
        this.preferences.marketplacemute = bool;
        conn.query("UPDATE userspreferences SET marketplacemute = ? WHERE idUser = ?", [bool, this.id]);
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

    async tell(str) {
        try {
            await axios.post("http://127.0.0.1:48921/usr", {
                id: this.id,
                message: str,
            });
        } catch (e) {
            console.log(e);
        }
    }

    static async tell(id, str) {
        try {
            await axios.post("http://127.0.0.1:48921/usr", {
                id: id,
                message: str,
            });
        } catch (e) {
            console.log(e);
        }
    }

    //Affichage
    infoPanel(lang) {
        let statPointsPlur = this.character.getStatPoints() > 1 ? "_plur" : "";
        let xpProgressBar = new ProgressBar();
        let xpBar = "";
        let xpOn = "";

        let xpBarCraft = "";
        let xpOnCraft = "";

        if (this.character.getLevel() === Globals.maxLevel) {
            xpOn = Translator.getString(lang, "character", "maximum_level");
            xpBar = xpProgressBar.draw(1, 1);
        } else {
            xpOn = this.character.levelSystem.actualXP + " / " + this.character.levelSystem.expToNextLevel;
            xpBar = xpProgressBar.draw(this.character.levelSystem.actualXP, this.character.levelSystem.expToNextLevel);
        }

        if (this.character.getCraftLevel() === Globals.maxLevel) {
            xpOnCraft = Translator.getString(lang, "character", "maximum_level");
            xpBarCraft = xpProgressBar.draw(1, 1);
        } else {
            xpOnCraft = this.character.getCratfXP() + " / " + this.character.getCraftNextLevelXP();
            xpBarCraft = xpProgressBar.draw(this.character.getCratfXP(), this.character.getCraftNextLevelXP());
        }


        let authorTitle = this.getUsername() + " | " + Translator.getString(lang, "inventory_equipment", "power") + " : " + this.character.getPower() + "%";
        let statsTitle = Translator.getString(lang, "character", "info_attributes_title" + statPointsPlur, [this.character.getStatPoints(), this.character.getResetStatsValue()]);
        let titleXPFight = Translator.getString(lang, "character", "level") + " : " + this.character.getLevel() + " | " + xpOn + " ";
        let titleXPCraft = Translator.getString(lang, "character", "craft_level") + " : " + this.character.getCraftLevel() + " | " + xpOnCraft + " "


        let embed = new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(authorTitle, this.avatar)
            .addField(statsTitle, this.character.getStatsStr(lang))
            .addField(titleXPFight, xpBar, true)
            .addField(titleXPCraft, xpBarCraft, true)
            .addBlankField(true)
            .addField(Translator.getString(lang, "character", "money"), this.character.getMoney() + " G", true)
            .addField(Translator.getString(lang, "character", "honor"), this.character.getHonor(), true)
            .addBlankField(true);

        return embed;
    }

    // Info pannel API
    apiInfoPanel() {
        let infos = {
            actualXp: this.character.levelSystem.actualXP,
            xpNextLevel: this.character.levelSystem.expToNextLevel,
            username: this.character.name,
            avatar: this.avatar,
            statPoints: this.character.getStatPoints(),
            resetValue: this.character.getResetStatsValue(),
            stats: this.character.stats.toApi(),
            level: this.character.getLevel(),
            money: this.character.getMoney(),
            honor: this.character.getHonor(),
            power: this.character.getPower(),
            maxLevel: Globals.maxLevel,
            statsEquipment: this.character.equipement.stats.toApi(),
            craft: {
                level: this.character.getCraftLevel(),
                xp: this.character.getCratfXP(),
                xpNextLevel: this.character.getCraftNextLevelXP(),
            },
            lang: this.getLang(),

        };
        return infos;
    }


}

module.exports = User;