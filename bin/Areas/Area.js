'use strict';
const conn = require("../../conf/mysql.js");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");
const MonstreGroupe = require("../MonstreGroupe");
const AreaTournament = require("../AreaTournament/AreaTournament");
const Discord = require("discord.js");
const Character = require("../Character");
const Item = require("../Item");

class Area {

    constructor(id) {
        this.id = id;
        this.name = "";
        this.desc = "";
        this.image = "";
        this.levels = "";
        this.areaType = "";
        //this.nbrPlayers = 0;
        this.owner = 0;
        this.fightPossible = false;
        /**
         * @type {Array<Item>}
         */
        this.resources = [];
        /**
         * @type {Array<MonstreGroupe>}
         */
        this.monsters = [];
        this.characters = [];
        this.maxItemRarity = "";
        this.timeBeforeNextClaim = 0;
        this.players = [];
        this.services = {};
        //this.tournament = {};
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

        res = conn.query("SELECT DISTINCT itemsbase.idBaseItem, itemsbase.nomItem, itemstypes.nomType, itemsrarities.nomRarity, itemssoustypes.nomSousType, areasresources.requiredLevel, itemsbase.idRarity " +
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

        res = conn.query("SELECT monstresgroupes.idMonstreGroupe, monstresgroupes.number, monstres.idMonstre, monstres.name, monstres.avglevel, monstrestypes.nom FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType INNER JOIN monstresgroupes ON monstres.idMonstre = monstresgroupes.idMonstre INNER JOIN areasmonsters ON areasmonsters.idMonstre = monstresgroupes.idMonstre AND areasmonsters.idArea = ?;", [this.id]);
        //res = conn.query("SELECT DISTINCT monstres.idMonstre, monstres.name, monstres.avglevel, monstrestypes.nom FROM monstres INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType INNER JOIN areasmonsters ON areasmonsters.idMonstre = monstres.idMonstre AND areasmonsters.idArea = " + this.id + ";");
        let arrOfMonstersGroup = {};
        for (let i in res) {
            let monsterLight = {
                id: res[i]["idMonstre"],
                name: res[i]["name"],
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

        /*this.tournament = new AreaTournament(this);
        this.tournament.scheduleTournament();*/
        
    }

    /**
     * 
     * @param {Character} character 
     */
    addOnePlayer(character) {
        this.players.push(character);
        this.players.sort((a, b) => b.getLevel() - a.getLevel());
        //this.players.sort((a, b) => { a.name > b.name ? 1 : (b.name > a.name ? - 1 : 0) })
    }

    /**
     * 
     * @param {Character} character 
     */
    removeOnePlayer(character) {
        this.players.splice(this.players.indexOf(character), 1);
        this.players.sort((a, b) => b.getLevel() - a.getLevel());
        //this.players.sort((a, b) => { a.name > b.name ? 1 : (b.name > a.name ? - 1 : 0) })
    }

    /**
     * 
     * @param {string} lang 
     */
    getMonsters(lang) {
        let str = "```";
        for (let i in this.monsters) {
            //str += "ID : " + i + " | " + this.monsters[i]["name"] + " | Lv : " + this.monsters[i]["avglevel"] + " | Type : " + this.monsters[i]["type"] + "\n\n";
            //str += Translator.getString(lang, "area", "monster", [i, this.monsters[i]["name"], this.monsters[i]["avglevel"], this.monsters[i]["type"]]) + "\n\n";
            if (this.monsters[i].numberOfMonsters > 1) {
                //str += "Groupe de " + this.monsters[i].numberOfMonsters + " montres" + "\n\n";
                str += Translator.getString(lang, "area", "monster_group", [i, this.monsters[i].name, this.monsters[i].numberOfMonsters - 1, this.monsters[i].avglevel, Translator.getString(lang, "monsters_types", this.monsters[i].type)]) + "\n\n";
            } else {
                str += Translator.getString(lang, "area", "monster", [i, this.monsters[i].name, this.monsters[i].avglevel, Translator.getString(lang, "monsters_types", this.monsters[i].type)]) + "\n\n";
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
            tempString = Translator.getString(lang, "area", "resource", [i + 1, this.resources[i]["nomItem"], Translator.getString(lang, "rarities", this.resources[i]["nomRarity"])]) + "\n\n";

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
        str += Translator.getString(lang, "area", "list_of_players_in_area", [this.name]) + "\n\n";
        let maxPage = Math.ceil(this.players.length/perPage);

        page = page > maxPage || page <= 0 ? 1 : page;

        let indexPage = (page - 1) * perPage;
        if (this.players.length > indexPage) {
            for (let i = indexPage; i < ((indexPage + perPage) < this.players.length ? (indexPage + perPage) : this.players.length); i++) {
                let cha = this.players[i];
                str += Translator.getString(lang, "area", "player", [cha.id, cha.name, cha.getLevel()]) + "\n\n";
            }
        } else {
            str += Translator.getString(lang, "general", "nothing_at_this_page");
        }

        str += "\n"+ Translator.getString(lang, "general", "page") + " : " + page + " / " + maxPage;
        str += "```";
        return str;
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
            .setAuthor(this.name + " | " + this.levels + " | " + Translator.getString(lang, "area", "owned_by") + " : " + this.getOwner(lang), this.image)
            .addField(Translator.getString(lang, "area", "conquest"), "```" + AreaTournament.toDiscordEmbed(this.id, lang) + "```");
    }

    /**
     * @param {string} lang 
     */
    toStr(lang) {
        return new Discord.RichEmbed();
    }

}

module.exports = Area;
