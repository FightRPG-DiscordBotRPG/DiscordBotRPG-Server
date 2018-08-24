'use strict';
const conn = require("../../conf/mysql.js");
const Translator = require("../Translator/Translator");
const MonstreGroupe = require("../MonstreGroupe");
const AreaTournament = require("../AreaTournament/AreaTournament");
const Discord = require("discord.js");
const AreaBonus = require("./AreaBonus");

class Area {

    constructor(id) {
        this.id = id;
        this.image = "";
        this.levels = "";
        this.areaType = "";
        this.idRegion = 0;
        //this.nbrPlayers = 0;
        this.owner = 0;
        this.fightPossible = false;

        this.resources = [];
        /**
         * @type {Array<MonstreGroupe>}
         */
        this.monsters = [];
        /**
         * @type {AreaBonus}
         */
        this.bonuses = [];
        this.maxItemRarity = "";
        this.timeBeforeNextClaim = 0;
        this.players = [];
        this.services = {};
        this.authorizedBonuses = ["xp_fight", "xp_collect", "xp_craft", "gold_drop", "item_drop", "collect_drop"];
        this.loadArea(id);
    }

    loadArea(id) {
        let res = conn.query("SELECT idRegion, AreaImage, AreaLevels, NomAreaType FROM areas INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType INNER JOIN areasregions ON areasregions.idArea = areas.idArea WHERE areas.idArea = ?", [id])[0];
        this.idRegion = res["idRegion"];
        this.image = res["AreaImage"];
        this.levels = res["AreaLevels"];
        this.areaType = res["NomAreaType"];
        //this.nbrPlayers = conn.query("SELECT COUNT(*) FROM characters WHERE characters.idArea = " + id + ";")[0]["COUNT(*)"];

        res = conn.query("SELECT DISTINCT itemsbase.idBaseItem, itemstypes.nomType, itemsrarities.nomRarity, itemssoustypes.nomSousType, areasresources.requiredLevel, itemsbase.idRarity " +
            "FROM itemsbase INNER JOIN areasresources ON areasresources.idBaseItem = itemsbase.idBaseItem " +
            "INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType " +
            "INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType " +
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

        res = conn.query("SELECT monstresgroupes.idMonstreGroupe, monstresgroupes.number, monstres.idMonstre, monstres.avglevel, monstrestypes.nom FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType INNER JOIN monstresgroupes ON monstres.idMonstre = monstresgroupes.idMonstre INNER JOIN areasmonsters ON areasmonsters.idMonstre = monstresgroupes.idMonstre AND areasmonsters.idArea = ?;", [this.id]);
        //res = conn.query("SELECT DISTINCT monstres.idMonstre, monstres.name, monstres.avglevel, monstrestypes.nom FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType INNER JOIN areasmonsters ON areasmonsters.idMonstre = monstres.idMonstre AND areasmonsters.idArea = " + this.id + ";");
        let arrOfMonstersGroup = {};
        for (let i in res) {
            let monsterLight = {
                id: res[i]["idMonstre"],
                avglevel: res[i]["avglevel"],
                type: res[i]["nom"],
                number: res[i]["number"]
            }

            let idToString = res[i]["idMonstreGroupe"].toString();
            if (Object.keys(arrOfMonstersGroup).indexOf(idToString) == -1) {
                arrOfMonstersGroup[idToString] = [];
            }

            arrOfMonstersGroup[idToString].push(monsterLight);
        }

        for (let i in arrOfMonstersGroup) {
            let grpMonster = new MonstreGroupe();
            grpMonster.setMonsters(arrOfMonstersGroup[i]);

            this.monsters.push(grpMonster);

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

    /**
     * 
     * @param {string} lang 
     */
    getMonsters(lang) {
        let str = "```";
        for (let i in this.monsters) {
            if (this.monsters[i].numberOfMonsters > 1) {
                str += Translator.getString(lang, "area", "monster_group", [i, this.monsters[i].getName(lang), this.monsters[i].numberOfMonsters - 1, this.monsters[i].avglevel, Translator.getString(lang, "monsters_types", this.monsters[i].type)]) + "\n\n";
            } else {
                str += Translator.getString(lang, "area", "monster", [i, this.monsters[i].getName(lang), this.monsters[i].avglevel, Translator.getString(lang, "monsters_types", this.monsters[i].type)]) + "\n\n";
            }
        }
        str += "```";
        return str;
    }

    /**
     * 
     * @param {string} lang 
     */
    getResources(lang) {
        let strWoodsHeader = Translator.getString(lang, "resources", "woods") + "\n";
        let strWoods = "";

        let strStonesHeader = Translator.getString(lang, "resources", "ores") + "\n";
        let strStones = "";

        let strHerbsHeader = Translator.getString(lang, "resources", "plants") + "\n";
        let strHerbs = "";

        let str = "```" + Translator.getString(lang, "area", "resources") + "\n";
        let tempString = "";
        //let id = 0;

        for (let i = 0; i < this.resources.length; i++) {
            // On créer d'abord la vue de l'objet
            //tempString = "- ID : " + (i + 1) + " | " + this.resources[i]["nomItem"] + " | " + this.resources[i]["nomRarity"] + "\n";
            tempString = Translator.getString(lang, "area", "resource", [i + 1, Translator.getString(lang, "itemsNames", this.resources[i].idBaseItem), Translator.getString(lang, "rarities", this.resources[i]["nomRarity"])]) + "\n\n";

            switch (this.resources[i]["nomSousType"]) {
                case "wood":
                    strWoods += tempString;
                    break;
                case "ore":
                    strStones += tempString;
                    break;
                case "plant":
                    strHerbs += tempString;
                    break;
                
            }
        }
        if (this.resources.length === 0) {
            str += Translator.getString(lang, "resources", "noresources");
        } else {
            str += strWoods.length > 0 ? strWoodsHeader + strWoods : "" + strStones.length > 0 ? strStonesHeader + strStones : "" + strHerbs.length > 0 ? strHerbsHeader + strHerbs : "";
        }
         
        return str + "```";
    }

    /**
     * 
     * @param {number} idEmplacementMonstre 
     * @returns {MonstreGroupe} Returns null if no monsters
     */
    getMonsterId(idEmplacementMonstre) {
        if (idEmplacementMonstre < this.monsters.length && idEmplacementMonstre >= 0) {
            //return this.monsters[idEmplacementMonstre].getMonstersIDs()[0];
            //return idEmplacementMonstre;
            return this.monsters[idEmplacementMonstre].getMonsters();
        } else {
            return null;
        }
    }

    /**
     * 
     * @param {number} notThisEnemy 
     */
    getRandomMonster(notThisEnemy) {
        let index = Math.floor(Math.random() * this.monsters.length);
        if (this.monsters.length > 1) {
            while (index == notThisEnemy) {
                index = Math.floor(Math.random() * this.monsters.length);
            }
        }
        return this.monsters[index].getMonsters();
    }

    getMaxItemQuality() {
        return this.maxItemRarity;
    }

    /**
     * 
     * @param {number} page 
     * @param {string} lang 
     */
    getPlayers(page, lang) {
        page = page;
        let perPage = 10;
        let str = "```";
        str += Translator.getString(lang, "area", "list_of_players_in_area", [this.getName(lang)]) + "\n\n";
        let maxPage = Math.ceil(conn.query("SELECT COUNT(*) FROM characters INNER JOIN users ON users.idCharacter = characters.idCharacter WHERE users.isConnected = true AND characters.idArea = ?", [this.id])[0]["COUNT(*)"] / perPage);;

        page = page > maxPage || page <= 0 ? 1 : page;

        
        let indexPage = (page - 1) * perPage;

        let players = conn.query("SELECT characters.idCharacter, users.userName, levels.actualLevel FROM characters INNER JOIN users ON users.idCharacter = characters.idCharacter INNER JOIN levels ON levels.idCharacter = characters.idCharacter WHERE users.isConnected = true AND characters.idArea = ? ORDER BY actualLevel DESC LIMIT ? OFFSET ?;", [this.id, perPage, indexPage]);

        if (players.length > indexPage) {
            for (let player of players) {
                str += Translator.getString(lang, "area", "player", [player.idCharacter, player.userName, player.actualLevel]) + "\n\n";
            }
        } else {
            str += Translator.getString(lang, "general", "nothing_at_this_page") + "\n";
        }

        str += "\n"+ Translator.getString(lang, "general", "page") + " : " + page + " / " + maxPage;
        str += "```";
        return str;
    }

    /**
     * 
     * @param {string} bonusName 
     */
    isBonusAvailable(bonusName) {
        return this.authorizedBonuses.indexOf(bonusName) >= 0;
    }

    /**
     * 
     * @param {string} lang 
     */
    bonusesToStr(lang) {
        let str = "```\n";
        let res = conn.query("SELECT * FROM areasbonuses WHERE idArea = ?;", [this.id]);
        let empty = true;
        for(let o of res) {
            if(o.value > 0) {
                let bonus = new AreaBonus(o.idBonusTypes);
                bonus.setValue(o.value);
                str += bonus.toStr(lang) + "\n";
                empty = false;
            }
        }

        if(empty) {
            str += Translator.getString(lang, "bonuses", "no_bonuses");
        }
        str += "```";

        return str;
    }

    /**
     * @returns {Array<AreaBonus>} More like an object with name of bonus as key
     */
    getAllBonuses() {
        let bonuses = {};
        let res = conn.query("SELECT * FROM areasbonuses WHERE idArea = ? AND idBonusTypes;", [this.id]);;
        for(let o of res) {
            let bonus = new AreaBonus(o.idBonusTypes);
            bonus.setValue(o.value);
            bonuses[bonus.name] = bonus;
        }
        return bonuses;
    }

    resetBonuses() {
        conn.query("UPDATE areasbonuses SET value = 0 WHERE idArea = ?", [this.id]);
        conn.query("UPDATE areas SET areas.statPoints = 5 * areas.AreaLevel WHERE idArea = ?", [this.id]);
    }

    static resetBonuses(idArea) {
        conn.query("UPDATE areasbonuses SET value = 0 WHERE idArea = ?", [idArea]);
        conn.query("UPDATE areas SET areas.statPoints = 5 * areas.AreaLevel WHERE idArea = ?", [idArea]);
    }

    static oneLessLevel(idArea) {
        conn.query("UPDATE areas SET areas.AreaLevel = IF(areas.AreaLevel > 1, areas.AreaLevel - 1, 1) WHERE areas.idArea = ?;", [idArea]);
    }

    /**
     * @return {number}
     */
    getLevel() {
        return conn.query("SELECT AreaLevel as level FROM areas WHERE idArea = ?;", [this.id])[0].level;
    }

    levelUp() {
        conn.query("UPDATE areas SET AreaLevel = IF(areas.AreaLevel < (SELECT MAX(idAreaLevel) FROM areaslevels), AreaLevel + 1, AreaLevel), statPoints = statPoints + 5 WHERE areas.idArea = ?", [this.id]);
    }

    getPriceNextLevel() {
        return conn.query("SELECT price FROM areaslevels INNER JOIN areas ON areas.AreaLevel = areaslevels.idAreaLevel WHERE areas.idArea = ?;", [this.id])[0].price;
    }

    isMaxLevel() {
        let maxLevel = conn.query("SELECT MAX(idAreaLevel) as maxLevel FROM areaslevels")[0].maxLevel;
        return maxLevel <= this.getLevel();
    }

    haveThisAmountOfStatPoints(number) {
        let statPoints = conn.query("SELECT statPoints FROM areas WHERE idArea = ?;", [this.id])[0].statPoints;
        return number <= statPoints;
    }

    /**
     * 
     * @param {string} statName 
     * @param {number} number 
     */
    upStat(statName, number) {
        conn.query("UPDATE areasbonuses INNER JOIN bonustypes ON bonustypes.idBonusTypes = areasbonuses.idBonusTypes SET areasbonuses.value = areasbonuses.value + ? WHERE bonustypes.nom = ? AND areasbonuses.idArea = ?", [number, statName, this.id]);
        conn.query("UPDATE areas SET statPoints = statPoints - ? WHERE idArea = ?;", [number, this.id]);
    }

    /**
     * 
     * @param {string} lang 
     */
    listOfBonusesToStr(lang) {
        let str = "```\n";
        str += Translator.getString(lang, "area", "bonus_list_header") + "\n\n";
        for(let bonus of this.authorizedBonuses) {
            str += bonus + " => " + Translator.getString(lang, "bonuses", bonus) + "\n";
        }
        str += "```";
        return str;
    }

    statsAndLevelToStr() {
        let str = "```\n";
        let res = conn.query("SELECT areas.AreaLevel as level, statPoints, price FROM areas INNER JOIN areaslevels ON areaslevels.idAreaLevel = areas.AreaLevel WHERE idArea = ?;", [this.id])[0];
        str += "- Actual level : " + res.level + "\n";
        str += "- Points to distribute : " + res.statPoints + "\n";
        str += "- Price to next level : " + res.price + "\n";
        str += "```";

        return str;
    }

    getName(lang="en") {
        return Translator.getString(lang, "areasNames", this.id);
    }

    getDesc(lang="en") {
        let desc = Translator.getString(lang, "areasDesc", this.id, [], true);
        return desc != null ? desc : Translator.getString(lang, "areas", "no_description");
    }

    getIDRegion() {
        return this.idRegion;
    }

    getID() {
        return this.id;
    }

    /**
     * 
     * @param {number} indexResource 
     */
    getResource(indexResource) {
        //console.log(this.resources[indexResource]);
        return this.resources[indexResource - 1] ? this.resources[indexResource - 1] : null;
    }

    canIFightHere() {
        return this.fightPossible;
    }

    /**
     * 
     * @param {string} serviceName 
     * @returns {Object} Service
     */
    getService(serviceName) {
        return this.services[serviceName];
    }

    /**
     * @returns {number} Null if no guilds
     */
    getOwnerID() {
        let res = conn.query("SELECT idGuild FROM areasowners WHERE idArea = ?;", [this.id]);
        if(res[0]) {
            return res[0].idGuild;
        }
        return null;
    }

    static staticGetOwnerID(idArea) {
        let res = conn.query("SELECT idGuild FROM areasowners WHERE idArea = ?;", [idArea]);
        if(res[0]) {
            return res[0].idGuild;
        }
        return null;
    }

    /**
     * 
     * @param {string} lang 
     * @returns {string}
     */
    getOwner(lang) {
        let res = conn.query("SELECT idGuild FROM areasowners WHERE idArea = " + this.id);
        if (res.length > 0) {
            return conn.query("SELECT nom FROM guilds WHERE idGuild = ?", [res[0].idGuild])[0].nom;
        }
        return Translator.getString(lang, "general", "nobody");
    }

    haveOwner() {
        return conn.query("SELECT idGuild FROM areasowners WHERE idArea = " + this.id)[0] != null;
    }

    saveOwner() {
        if (this.owner === 0) {
            conn.query("DELETE FROM areasowners WHERE idArea = " + this.id);
        } else {
            conn.query("INSERT INTO areasowners VALUES(" + this.id + ", " + this.owner + ")");
        }
        
    }


    /**
     * @deprecated
     * @param {number} idGuild 
     * @param {string} lang 
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

    /**
     * 
     * @param {number} idGuild 
     */
    setOwner(idGuild) {
        this.owner = 0;
        this.saveOwner();
        this.owner = idGuild;
        this.saveOwner();
    }

    /**
     * 
     * @param {number} idArea 
     * @param {number} idGuild 
     */
    static staticSetOwner(idArea, idGuild) {
        conn.query("DELETE FROM areasowners WHERE idArea = ?", [idArea]);
        conn.query("INSERT INTO areasowners VALUES(?, ?)", [idArea, idGuild]);
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
            nbrPlayers: this.players.length,
        }
    }

    toApiFull() {
        return this;
    }

    /**
     * 
     * @param {string} lang 
     */
    conquestToStr(lang) {
        return new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.getName(lang) + " | " + this.levels + " | " + Translator.getString(lang, "area", "owned_by") + " : " + this.getOwner(lang), this.image)
            .addField(Translator.getString(lang, "area", "conquest"), "```" + AreaTournament.toDiscordEmbed(this.id, lang) + "```")
            .addField(Translator.getString(lang, "bonuses", "bonuses"), this.bonusesToStr(lang))
            .addField(Translator.getString(lang, "area", "area_progression"), this.statsAndLevelToStr(lang))
            ;
    }

    /**
     * @param {string} lang 
     */
    toStr(lang) {
        return new Discord.RichEmbed();
    }

}

module.exports = Area;
