'use strict';
const conn = require("../conf/mysql.js");
const Character = require("./Character.js");
const Discord = require("discord.js");
const ProgressBar = require("./ProgressBar.js");
const Globals = require("./Globals.js");
const Crypto = require("crypto");

class User {
    // Discord User Info
    constructor(id, username) {
        this.id = id;
        this.character = new Character();
        this.avatar = "";
        this.username = username;
    }

    // Init for new user
    init() {
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
            this.username = res[0]["userName"];
            this.character.name = this.username;
        }

    }

    static getUserId(token) {
        let res = conn.query("SELECT idUser FROM users WHERE token = ?;", [token]);
        if (res[0]) {
            return res[0]["idUser"];
        }
        return undefined;
    }

    getToken() {
        return conn.query("SELECT token FROM users WHERE idUser = " + this.id + ";")[0]["token"];
    }

    saveUser() {
        this.character.saveCharacter();
    }

    //Affichage
    infoPanel() {
        let statPointsPlur = this.character.statPoints > 1 ? "s" : "";
        let xpProgressBar = new ProgressBar();
        let xpBar = "";
        let xpOn = "";
        if (this.character.getLevel() === Globals.maxLevel) {
            xpOn = "Niveau Max";
            xpBar = xpProgressBar.draw(1, 1);
        } else {
            xpOn = this.character.levelSystem.actualXP + " / " + this.character.levelSystem.expToNextLevel;
            xpBar = xpProgressBar.draw(this.character.levelSystem.actualXP, this.character.levelSystem.expToNextLevel);
        }

        let embed = new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.character.name, this.avatar)
            .addField("Attributes | " + this.character.statPoints + " point" + statPointsPlur + " à répartir (Prix du reset : " + this.character.getResetStatsValue() + "G)", this.character.getStatsStr())
            .addField("Level : " + this.character.getLevel() + "    |    " + xpOn, xpBar, true)
            .addField("Money", this.character.money + " G", true)
            .addField("Honor", this.character.honorPoints + " Pts", true);

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
