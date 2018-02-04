'use strict';
const conn = require("../conf/mysql.js");
const Discord = require("discord.js");

class Leaderboard {

    constructor() {
        this.id = "__LeaderBoard";
    }

    toStr(id) {
        let str = "```";
        let usernameMaxLength = 34;
        let honorMaxLength = 13;
        let idMaxLength = 6;
        let levelMaxLength = 13;

        let idLength;
        let usernameLength;
        let honorLength;
        let levelLength;


        str += "|  id  |             username             |    honor    |    level    |\n" + 
               "|______|__________________________________|_____________|_____________|\n";
        let res = conn.query("SELECT DISTINCT charactershonor.idCharacter, charactershonor.Honor, users.userName, levels.actualLevel " +
            "FROM charactershonor " +
            "INNER JOIN levels ON levels.idCharacter = charactershonor.idCharacter "+
            "INNER JOIN users ON users.idCharacter = charactershonor.idCharacter " +
            "WHERE charactershonor.idCharacter = " + id + " OR charactershonor.idCharacter > " + id + " OR charactershonor.idCharacter < " + id + " " +
            "ORDER BY Honor DESC LIMIT 0, 11");
        for (let i of res) {
            idLength = i.idCharacter.toString().length;
            idLength = (idMaxLength - idLength) / 2;

            usernameLength = i.userName.length;
            usernameLength = (usernameMaxLength - usernameLength) / 2;

            honorLength = i.Honor.toString().length;
            honorLength = (honorMaxLength - honorLength) / 2;

            levelLength = i.actualLevel.toString().length;
            levelLength = (levelMaxLength - levelLength) / 2;

            str += "|" + " ".repeat(Math.floor(idLength)) + i.idCharacter + " ".repeat(Math.ceil(idLength)) + "|"
                + " ".repeat(Math.floor(usernameLength)) + i.userName + " ".repeat(Math.ceil(usernameLength)) + "|"
                + " ".repeat(Math.floor(honorLength)) + i.Honor + " ".repeat(Math.ceil(honorLength)) + "|"
                + " ".repeat(Math.floor(levelLength)) + i.actualLevel + " ".repeat(Math.ceil(levelLength)) + "|\n"
        }
        str += "```";
        return str;
    }

    idOf(idCharacter) {
        let res = conn.query("SELECT users.idUser FROM users WHERE users.idCharacter = " + idCharacter + ";");
        if (res.length > 0) {
            return res[0]["idUser"];
        }
        return -1;
    }
    


}

module.exports = Leaderboard;
