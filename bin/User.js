'use strict';
const conn = require("../conf/mysql.js");
const Character = require("./Character");
const Discord = require("discord.js");
const ProgressBar = require("./ProgressBar.js");
const Globals = require("./Globals.js");
const Crypto = require("crypto");
const Translator = require("./Translator/Translator");

class User {
    // Discord User Info
    constructor(id, username) {
        this.id = id;
        this.character = new Character();
        this.avatar = "";
        this.username = username;//username.replace(/[\u0800-\uFFFF]/g, '');
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
        conn.query("INSERT INTO `users` (`idUser`, `idCharacter`, `userName`, `token`) VALUES ( " + this.id + ", " + this.character.id + ", '" + this.username + "', '" + nToken + "');");
        conn.query("INSERT INTO `userspreferences` (`idUser`) VALUES (?);", [this.id]);
    }

    // Load user from DB
    // If not exist create new one
    loadUser() {
        let res = conn.query("SELECT * FROM users WHERE idUser = " + this.id);
        if (res.length === 0) {
            // S'il n'existe pas on le cr�e
            this.init();
        } else {
            // Sinon on le load
            this.character.loadCharacter(res[0]["idCharacter"]);
            conn.query("UPDATE users SET username = ? WHERE idUser = ?", [this.username, this.id]);
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
    }

    isGroupMuted() {
        return this.preferences.groupmute;
    }

    isMarketplaceMuted() {
        return this.preferences.marketplacemute;
    }

    muteGroup(bool) {
        bool == true ? this.preferences.groupmute = true : this.preferences.groupmute = false;
        conn.query("UPDATE userspreferences SET groupmute = ? WHERE idUser = ?", [this.preferences.groupmute, this.id]);
    }

    muteMarketplace(bool) {
        bool == true ? this.preferences.marketplacemute = true : this.preferences.marketplacemute = false;
        conn.query("UPDATE userspreferences SET marketplacemute = ? WHERE idUser = ?", [this.preferences.groupmute, this.id]);
    }

    marketTell(str) {
        if (!this.isMarketplaceMuted()) {
            this.tell(str);
        }
    }

    tell(str) {
        Globals.discordClient.users.get(this.id).send(str);
    }

    //Affichage
    infoPanel() {
        let statPointsPlur = this.character.statPoints > 1 ? "s" : "";
        let xpProgressBar = new ProgressBar();
        let xpBar = "";
        let xpOn = "";

        let xpBarCraft = "";
        let xpOnCraft = "";

        if (this.character.getLevel() === Globals.maxLevel) {
            xpOn = "Niveau Max";
            xpBar = xpProgressBar.draw(1, 1);
        } else {
            xpOn = this.character.levelSystem.actualXP + " / " + this.character.levelSystem.expToNextLevel;
            xpBar = xpProgressBar.draw(this.character.levelSystem.actualXP, this.character.levelSystem.expToNextLevel);
        }

        if(this.character.getCraftLevel() === Globals.maxLevel) {
            xpOnCraft = "Niveau Max";
            xpBarCraft = xpProgressBar.draw(1, 1);
        } else {
            xpOnCraft = this.character.getCratfXP() + " / " + this.character.getCraftNextLevelXP();
            xpBarCraft = xpProgressBar.draw(this.character.getCratfXP(), this.character.getCraftNextLevelXP());
        }



        let embed = new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.character.name + " | Power : " + this.character.getPower() + "%", this.avatar)
            .addField("Attributes | " + this.character.statPoints + " point" + statPointsPlur + " à répartir (Prix du reset : " + this.character.getResetStatsValue() + "G)", this.character.getStatsStr())
            .addField("Level : " + this.character.getLevel() + "    |    " + xpOn, xpBar, true)
            .addField("Craft Level : " + this.character.getCraftLevel() + "    |    " + xpOnCraft, xpBarCraft, true)
            .addBlankField(true)
            .addField("Money", this.character.money + " G",true)
            .addField("Honor", this.character.honorPoints + " Pts", true)
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
            statPoints: this.character.statPoints,
            resetValue: this.character.getResetStatsValue(),
            stats: this.character.stats.toApi(),
            level: this.character.getLevel(),
            money: this.character.money,
            honor: this.character.honorPoints,
            maxLevel: Globals.maxLevel,
            statsEquipment: this.character.equipement.stats.toApi(),

        };
        return infos;
    }


}

module.exports = User;
