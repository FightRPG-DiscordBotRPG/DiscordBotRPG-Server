'use strict';
const conn = require("../conf/mysql.js");
const Character = require("./Character.js");
const Discord = require("discord.js");
const ProgressBar = require("./ProgressBar.js");
const Globals = require("./Globals.js");

class User {
    // Discord User Info
    constructor(id, username) {
        this.id = id;
        this.character = new Character();
        this.name = "Anonymous";
        this.avatar = "";
        this.username = username;
    }

    // Init for new user
    init() {
        this.character.init();
        conn.query("INSERT INTO `users` (`idUser`, `idCharacter`, `userName`) VALUES ( " + this.id + ", " + this.character.id + ", '" + this.username + "');");
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
        }

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
            .setAuthor(this.username, this.avatar)
            .addField("Attributes | " + this.character.statPoints + " point" + statPointsPlur + " à répartir (Prix du reset : " + this.character.getResetStatsValue() + "G)", this.character.getStatsStr())
            .addField("Level : " + this.character.getLevel() + "    |    " + xpOn, xpBar, true)
            .addField("Money", this.character.money + " G", true)
            .addField("Honor", this.character.honorPoints + " Pts", true);

        return embed;
    }


}

module.exports = User;
