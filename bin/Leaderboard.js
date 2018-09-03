'use strict';
const conn = require("../conf/mysql.js");

class Leaderboard {

    static playerLeaderboardToStr(id) {
        let str = "`";
        let usernameMaxLength = 34;
        let honorMaxLength = 13;
        let idMaxLength = 6;
        let levelMaxLength = 13;
        let rankMaxLength = 6;

        let idLength;
        let usernameLength;
        let honorLength;
        let levelLength;
        let rankLength;

        let actualRank = Leaderboard.getPlayerRank(id);
        let maximumRank = Leaderboard.getMaximumRank();
        let offset = actualRank - 6;

        if(actualRank <= 5) {
            offset = 0;
        } 
        if(maximumRank - actualRank < 5) {
            offset -= 6 - (maximumRank - actualRank);
        }

        offset = offset >= 0 ? offset : 0;


        str += "| rank |  id  |             username             |    honor    |    level    |\n" +
               "|______|______|__________________________________|_____________|_____________|\n";
        let res = conn.query("SELECT DISTINCT charactershonor.idCharacter, charactershonor.Honor, users.userName, levels.actualLevel FROM charactershonor INNER JOIN levels ON levels.idCharacter = charactershonor.idCharacter INNER JOIN users ON users.idCharacter = charactershonor.idCharacter ORDER BY Honor DESC, charactershonor.idCharacter LIMIT ?, 11", [offset]);

        //console.log("offset : " + offset + " | rank : " + actualRank + " | max rank : " + maximumRank + " | nb affiche : " + res.length);
        offset++;
        for (let i of res) {
            rankLength = offset.toString().length;
            rankLength = (rankMaxLength - rankLength) / 2;

            idLength = i.idCharacter.toString().length;
            idLength = (idMaxLength - idLength) / 2;

            usernameLength = i.userName.length;
            usernameLength = (usernameMaxLength - usernameLength) / 2;

            honorLength = i.Honor.toString().length;
            honorLength = (honorMaxLength - honorLength) / 2;

            levelLength = i.actualLevel.toString().length;
            levelLength = (levelMaxLength - levelLength) / 2;

            str += "|" + " ".repeat(Math.floor(rankLength)) + offset + " ".repeat(Math.ceil(rankLength)) + "|"
                + " ".repeat(Math.floor(idLength)) + i.idCharacter + " ".repeat(Math.ceil(idLength)) + "|"
                + " ".repeat(Math.floor(usernameLength)) + i.userName + " ".repeat(Math.ceil(usernameLength)) + "|"
                + " ".repeat(Math.floor(honorLength)) + i.Honor + " ".repeat(Math.ceil(honorLength)) + "|"
                + " ".repeat(Math.floor(levelLength)) + i.actualLevel + " ".repeat(Math.ceil(levelLength)) + "|\n";

                offset++;
        }
        str += "`";
        return str;
    }

    static idOf(idCharacter) {
        let res = conn.query("SELECT users.idUser FROM users WHERE users.idCharacter = " + idCharacter + ";");
        if (res.length > 0) {
            return res[0]["idUser"];
        }
        return -1;
    }

    static getPlayerRank(id) {
        let res = conn.query("SELECT DISTINCT * FROM (SELECT @rn:=@rn+1 as rank, charactershonor.idCharacter, charactershonor.Honor FROM charactershonor, (select @rn:=0) row_nums GROUP BY charactershonor.idCharacter ORDER BY charactershonor.Honor DESC) user_ranks WHERE idCharacter = ?;", [id]);
        
        return res != null && res[0] ? res[0].rank : 1;
    }

    static getMaximumRank() {
        let res = conn.query("SELECT COUNT(*) as count FROM charactershonor");
        return res != null && res[0] ? res[0].count : 1;
    }
    


}

module.exports = Leaderboard;
