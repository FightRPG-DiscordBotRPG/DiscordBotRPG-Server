'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");

class Area {

    constructor(id) {
        this.id = id;
        this.name = "";
        this.desc = "";
        this.image = "";
        this.levels = "";
        this.areaType = "";
        this.nbrPlayers = 0;
        this.owner = 0;
        this.fightPossible = false;
        this.resources = [];
        this.monsters = [];
        this.maxItemRarity = "";
        this.timeBeforeNextClaim = 0;
        this.loadArea(id);

    }

    loadArea(id) {
        let res = conn.query("SELECT AreaName, AreaDesc, AreaImage, AreaLevels, NomAreaType FROM areas " +
            "INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType " +
            "WHERE idArea = " + id)[0];
        this.name = res["AreaName"];
        this.desc = res["AreaDesc"];
        this.image = res["AreaImage"];
        this.levels = res["AreaLevels"];
        this.areaType = res["NomAreaType"];
        //this.nbrPlayers = conn.query("SELECT COUNT(*) FROM characters WHERE characters.idArea = " + id + ";")[0]["COUNT(*)"];

        res = conn.query("SELECT DISTINCT itemsbase.idBaseItem, itemsbase.nomItem, itemstypes.nomType, itemsrarities.nomRarity " +
            "FROM itemsbase INNER JOIN areasresources ON areasresources.idBaseItem = itemsbase.idBaseItem " +
            "INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType " +
            "INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity WHERE idArea = " + this.id);
        for (let i in res) {
            this.resources.push(res[i]);
        }

        // Load owner
        res = conn.query("SELECT idGuild FROM areasowners WHERE idArea = " + this.id);
        if (res.length > 0) {
            this.owner = res[0].idGuild;
        }

        // Load monsters
        res = conn.query("SELECT DISTINCT monstres.idMonstre, monstres.name, monstres.avglevel, monstrestypes.nom FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType INNER JOIN areasmonsters ON areasmonsters.idMonstre = monstres.idMonstre AND areasmonsters.idArea = " + this.id + ";");
        for (let i in res) {
            let monsterLight = {
                id: res[i]["idMonstre"],
                name: res[i]["name"],
                avglevel: res[i]["avglevel"],
                type: res[i]["nom"]
            }
            this.monsters.push(monsterLight);
        }

        // Load max rarity/quality item
        res = conn.query(
            "SELECT DISTINCT itemsrarities.nomRarity " +
            "FROM itemsbase " +
            "INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity " +
            "INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem AND areasitems.idArea = " + this.id + " " +
            "GROUP BY itemsrarities.idRarity DESC LIMIT 1;"
        );
        if (res[0]) {
            this.maxItemRarity = res[0]["nomRarity"];
        }
        
    }

    getMonsters(lang) {
        let str = "```";
        for (let i in this.monsters) {
            //str += "ID : " + i + " | " + this.monsters[i]["name"] + " | Lv : " + this.monsters[i]["avglevel"] + " | Type : " + this.monsters[i]["type"] + "\n\n";
            str += Translator.getString(lang, "area", "monster", [i, this.monsters[i]["name"], this.monsters[i]["avglevel"], this.monsters[i]["type"]]) + "\n\n";
        }
        str += "```";
        return str;
    }

    getResources(lang) {
        let strWoods =  Translator.getString(lang, "resources", "woods") + "\n";
        let strStones = Translator.getString(lang, "resources", "ores") + "\n";
        let strHerbs =  Translator.getString(lang, "resources", "plants") + "\n";
        let str = "```" + Translator.getString(lang, "area", "resources") + "\n";
        let tempString = "";
        //let id = 0;

        for (let i = 0; i < this.resources.length; i++) {
            // On créer d'abord la vue de l'objet
            //tempString = "- ID : " + (i + 1) + " | " + this.resources[i]["nomItem"] + " | " + this.resources[i]["nomRarity"] + "\n";
            tempString = Translator.getString(lang, "area", "resource", [i + 1, this.resources[i]["nomItem"], this.resources[i]["nomRarity"]]) + "\n\n";

            switch (this.resources[i]["nomType"]) {
                case "wood":
                    strWoods += tempString;
                    break;
                case "stone":
                    strStones += tempString;
                    break;
                case "herb":
                    strHerbs += tempString;
                    break;
                
            }
        }
        if (this.resources.length === 0) {
            str += Translator.getString(lang, "resources", "noresources");
        } else {
            str += strWoods + strStones + strHerbs;
        }
         
        return str + "```";
    }

    getMonsterId(idEmplacementMonstre) {
        if (idEmplacementMonstre < this.monsters.length && idEmplacementMonstre >= 0) {
            return this.monsters[idEmplacementMonstre].id;
        } else {
            return null;
        }
    }

    getRandomMonster(notThisEnemy) {
        let toReturn = this.monsters[Math.floor(Math.random() * this.monsters.length)].id;
        if (this.monsters.length > 1) {
            while (toReturn == notThisEnemy) {
                toReturn = this.monsters[Math.floor(Math.random() * this.monsters.length)].id;
            }
        }
        return toReturn;
    }

    getMaxItemQuality() {
        return this.maxItemRarity;
    }

    getPlayers(page, connectedUsers, lang) {
        page = page;
        let str = "```";
        str += Translator.getString(lang, "area", "list_of_players_in_area", [this.name]) + "\n\n";
        let maxPage = Math.ceil(this.nbrPlayers/10);

        page = page > maxPage || page <= 0 ? 1 : page;

        let res = conn.query("SELECT users.idUser FROM users " +
            "INNER JOIN characters ON characters.idCharacter = users.idCharacter " +
            "WHERE characters.idArea = " + this.id + " ORDER BY users.userName ASC LIMIT 10 OFFSET " + ((page - 1) * 10));

        if (res[0]) {
            for (let i in res) {
                if (connectedUsers[res[i].idUser]) {
                    /*str += "ID : " + connectedUsers[res[i].idUser].character.id + " | "
                        + "Nom : " + connectedUsers[res[i].idUser].username + " | "
                        + "Level : " + connectedUsers[res[i].idUser].character.getLevel() + "\n"; */
                    str += Translator.getString(lang, "area", "player", [connectedUsers[res[i].idUser].character.id, connectedUsers[res[i].idUser].username, connectedUsers[res[i].idUser].character.getLevel()]) + "\n\n";
                }

            }
        } else {
            str += Translator.getString(lang, "general", "nothing_at_this_page");
        }
        str += "\n"+ Translator.getString(lang, "general", "page") + " : " + page + " / " + maxPage;
        str += "```";
        return str;
    }

    getResource(indexResource) {
        //console.log(this.resources[indexResource]);
        return this.resources[indexResource - 1] ? this.resources[indexResource - 1] : null;
    }

    canIFightHere() {
        return this.fightPossible;
    }

    /**
     * Return owner name if exist or "None";
     */
    getOwner(lang) {
        if (this.owner > 0) {
            return conn.query("SELECT nom FROM guilds WHERE idGuild = " + this.owner)[0].nom;
        }
        return Translator.getString(lang, "general", "nobody");
    }

    saveOwner() {
        if (this.owner === 0) {
            conn.query("DELETE FROM areasowners WHERE idArea = " + this.id);
        } else {
            conn.query("INSERT INTO areasowners VALUES(" + this.id + ", " + this.owner + ")");
        }
        
    }

    /*
    *   CONQUEST
    */
    claim(idGuild, lang) {
        let err = [];
        if (this.owner == 0) {
            this.owner = idGuild;
            this.saveOwner();
        } else {
            err.push(Translator.getString(lang, "errors", "you_cant_claim"));
        }
        return err;
    }

    unclaim() {
        this.owner = 0;
        this.saveOwner();
    }


    /*
     *  API
     */
    toApiLight() {
        return {
            id: this.id,
            name: this.name,
            image: this.image,
            levels: this.levels,
            nbrPlayers: this.nbrPlayers,
        }
    }

    toApiFull() {
        return this;
    }

}

module.exports = Area;
