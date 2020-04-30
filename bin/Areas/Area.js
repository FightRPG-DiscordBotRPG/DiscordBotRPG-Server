'use strict';
const conn = require("../../conf/mysql.js");
const Translator = require("../Translator/Translator");
const MonstreGroupe = require("../MonstreGroupe");
const AreaTournament = require("../AreaTournament/AreaTournament");
const AreaBonus = require("./AreaBonus");
const WorldBoss = require("../WorldBosses/WorldBoss");
const AreaClimate = require("../Climate/AreaClimate");
const Marketplace = require("../Marketplace/Marketplace");
const CraftingBuilding = require("../CraftSystem/CraftingBuilding");
const Shop = require("../Shops/Shop");

class Area {

    constructor(id) {
        this.id = id;
        this.image = "";
        this.minLevel = 1;
        this.maxLevel = 1;
        /**
         * dungeon, city, wild
         */
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
        this.requiredAchievements = [];

        // Used to know idAreas from and to
        this.paths = {
            to: [],
            from: []
        }

        // Climate System
        this.areaClimate = new AreaClimate(this.id);
    }

    async loadArea() {
        let res = await conn.query("SELECT idRegion, AreaImage, NomAreaType, minLevel, maxLevel FROM areas INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType INNER JOIN areasregions ON areasregions.idArea = areas.idArea INNER JOIN areasmonsterslevels ON areasmonsterslevels.idArea = areas.idArea WHERE areas.idArea = ?", [this.id]);
        res = res[0];
        this.idRegion = res["idRegion"];
        this.image = res["AreaImage"];
        this.areaType = res["NomAreaType"];
        this.minLevel = res["minLevel"];
        this.maxLevel = res["maxLevel"];

        res = await conn.query("SELECT DISTINCT itemsbase.idBaseItem, itemstypes.nomType, itemsrarities.nomRarity, itemssoustypes.nomSousType, itemsbase.idRarity " +
            "FROM itemsbase INNER JOIN areasresources ON areasresources.idBaseItem = itemsbase.idBaseItem " +
            "INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType " +
            "INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType " +
            "INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity WHERE idArea = " + this.id);
        for (let i in res) {
            this.resources.push(res[i]);
        }

        // Load owner
        res = await conn.query("SELECT idGuild FROM areasowners WHERE idArea = " + this.id);
        if (res.length > 0) {
            this.owner = res[0].idGuild;
        }

        // Load monsters

        res = await conn.query("SELECT monstresgroupesassoc.idMonstresGroupe, monstresgroupesassoc.number, monstres.idMonstre, monstres.avglevel, monstrestypes.nom FROM areasmonsters INNER JOIN monstresgroupes ON monstresgroupes.idMonstresGroupe = areasmonsters.idMonstresGroupe INNER JOIN monstresgroupesassoc ON monstresgroupesassoc.idMonstresGroupe = monstresgroupes.idMonstresGroupe INNER JOIN monstres ON monstres.idMonstre = monstresgroupesassoc.idMonstre INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType WHERE areasmonsters.idArea = ?;", [this.id]);
        let arrOfMonstersGroup = new Map();
        for (let i in res) {
            let monsterLight = {
                id: res[i]["idMonstre"],
                avglevel: res[i]["avglevel"],
                type: res[i]["nom"],
                number: res[i]["number"]
            }

            let idToString = res[i]["idMonstresGroupe"].toString();
            if (arrOfMonstersGroup.get(idToString) == null) {
                arrOfMonstersGroup.set(idToString, []);
            }

            arrOfMonstersGroup.get(idToString).push(monsterLight);
        }


        for (let [key, value] of arrOfMonstersGroup) {
            let grpMonster = new MonstreGroupe();
            grpMonster.setMonsters(value);

            this.monsters.push(grpMonster);

        }

        // Load max rarity/quality item
        res = await conn.query(
            `SELECT
                DISTINCT itemsrarities.idRarity, itemsrarities.nomRarity
                FROM
                itemsbase
                INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity
                INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem
                AND areasitems.idArea = ?
                GROUP BY
                itemsrarities.idRarity
                ORDER BY itemsrarities.idRarity DESC
                LIMIT 1`
            , [this.id]);

        if (res[0]) {
            this.maxItemRarity = res[0]["nomRarity"];
        }

        // load required achievments
        res = await conn.query("SELECT * FROM areasrequirements WHERE idArea = ?;", [this.id]);
        for (let i in res) {
            this.requiredAchievements.push(res[i].idAchievement);
        }

        await this.areaClimate.load();

    }

    async lightLoad() {
        let res = await conn.query("SELECT idRegion, AreaImage, NomAreaType, minLevel, maxLevel FROM areas INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType INNER JOIN areasregions ON areasregions.idArea = areas.idArea INNER JOIN areasmonsterslevels ON areasmonsterslevels.idArea = areas.idArea WHERE areas.idArea = ?", [this.id]);
        res = res[0];
        this.idRegion = res["idRegion"];
        this.image = res["AreaImage"];
        this.areaType = res["NomAreaType"];
        this.minLevel = res["minLevel"];
        this.maxLevel = res["maxLevel"];
    }

    getMonstersToApiLight(lang) {
        let monsters = [];
        for (let i in this.monsters) {
            let level = this.monsters[i].avglevel > 0 ? this.monsters[i].avglevel : this.minMaxLevelToString();
            level = this.monsters[i].needToBeMaxLevel() == true ? this.maxLevel : level;
            monsters.push({
                name: this.monsters[i].getName(lang),
                type: Translator.getString(lang, "monsters_types", this.monsters[i].type),
                type_shorthand: this.monsters[i].type,
                level: level,
                number: this.monsters[i].numberOfMonsters,
            });
        }
        return monsters;
    }

    getRequiredAchievements() {
        return this.requiredAchievements;
    }

    getResourcesApiLight(lang) {
        let trees = [],
            ores = [],
            plants = [];
        for (let i = 0; i < this.resources.length; i++) {

            let resource = {
                id: i + 1,
                name: Translator.getString(lang, "itemsNames", this.resources[i].idBaseItem),
                rarity: Translator.getString(lang, "rarities", this.resources[i]["nomRarity"]),
                rarity_shorthand: this.resources[i]["nomRarity"],
            }

            switch (this.resources[i]["nomSousType"]) {
                case "wood":
                    trees.push(resource);
                    break;
                case "ore":
                    ores.push(resource);
                    break;
                case "plant":
                    plants.push(resource);
                    break;

            }
        }
        return {
            trees: trees,
            ores: ores,
            plants: plants,
        }

    }

    /**
     * 
     * @param {number} idEmplacementMonstre 
     * @returns {MonstreGroupe} Returns null if no monsters
     */
    getMonsterId(idEmplacementMonstre) {
        idEmplacementMonstre -= 1;
        if (idEmplacementMonstre < this.monsters.length && idEmplacementMonstre >= 0) {
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

    /**
     * 
     * @param {number} page 
     * @param {string} lang 
     */
    async getPlayers(page, lang) {
        page = page >= 0 ? page : 1;
        let perPage = 10;

        let res = await conn.query("SELECT COUNT(*) FROM characters INNER JOIN users ON users.idCharacter = characters.idCharacter WHERE users.isConnected = true AND characters.idArea = ?", [this.id]);
        let maxPage = Math.ceil(res[0]["COUNT(*)"] / perPage);

        page = page > maxPage || page <= 0 ? 1 : page;
        let indexPage = (page - 1) * perPage;

        let players = await conn.query("SELECT characters.idCharacter, users.userName, levels.actualLevel FROM characters INNER JOIN users ON users.idCharacter = characters.idCharacter INNER JOIN levels ON levels.idCharacter = characters.idCharacter WHERE users.isConnected = true AND characters.idArea = ? ORDER BY actualLevel DESC LIMIT ? OFFSET ?;", [this.id, perPage, indexPage]);
        return {
            area_name: this.getName(lang),
            page: page,
            maxPage: maxPage,
            players: players,
        }

    }

    /**
     * 
     * @param {string} bonusName 
     */
    isBonusAvailable(bonusName) {
        return this.authorizedBonuses.indexOf(bonusName) >= 0;
    }

    async apiGetBonuses(lang) {
        let res = await conn.query("SELECT * FROM areasbonuses WHERE idArea = ?;", [this.id]);
        let bonuses = [];
        for (let o of res) {
            if (o.value > 0) {
                let bonus = new AreaBonus(o.idBonusTypes);
                await bonus.load();
                bonus.setValue(o.value);
                bonuses.push(bonus.toApi(lang));
            }
        }
        return bonuses;
    }

    /**
     * @returns {Array<AreaBonus>} More like an object with name of bonus as key
     */
    async getAllBonuses() {
        let bonuses = {};
        let res = await conn.query("SELECT * FROM areasbonuses WHERE idArea = ? AND idBonusTypes;", [this.id]);
        for (let o of res) {
            let bonus = new AreaBonus(o.idBonusTypes);
            await bonus.load();
            bonus.setValue(o.value);
            bonuses[bonus.name] = bonus;
        }
        return bonuses;
    }

    async resetBonuses() {
        await conn.query("UPDATE areasbonuses SET value = 0 WHERE idArea = ?", [this.id]);
        await conn.query("UPDATE areas SET areas.statPoints = 5 * areas.AreaLevel WHERE idArea = ?", [this.id]);
    }

    static async resetBonuses(idArea) {
        await conn.query("UPDATE areasbonuses SET value = 0 WHERE idArea = ?", [idArea]);
        await conn.query("UPDATE areas SET areas.statPoints = 5 * areas.AreaLevel WHERE idArea = ?", [idArea]);
    }

    static async oneLessLevel(idArea) {
        await conn.query("UPDATE areas SET areas.AreaLevel = IF(areas.AreaLevel > 1, areas.AreaLevel - 1, 1) WHERE areas.idArea = ?;", [idArea]);
    }

    /**
     * @return {number}
     */
    async getLevel() {
        let res = await conn.query("SELECT AreaLevel as level FROM areas WHERE idArea = ?;", [this.id]);
        return res[0].level;
    }

    async levelUp() {
        await conn.query("UPDATE areas SET AreaLevel = IF(areas.AreaLevel < (SELECT MAX(idAreaLevel) FROM areaslevels), AreaLevel + 1, AreaLevel), statPoints = statPoints + 5 WHERE areas.idArea = ?;", [this.id]);
    }

    async getPriceNextLevel() {
        let res = await conn.query("SELECT price FROM areaslevels INNER JOIN areas ON areas.AreaLevel = areaslevels.idAreaLevel WHERE areas.idArea = ?;", [this.id]);
        return res[0].price;
    }

    async isMaxLevel() {
        let res = await conn.query("SELECT MAX(idAreaLevel) as maxLevel FROM areaslevels");
        let maxLevel = res[0].maxLevel;
        return maxLevel <= await this.getLevel();
    }

    async haveThisAmountOfStatPoints(number) {
        let res = await conn.query("SELECT statPoints FROM areas WHERE idArea = ?;", [this.id])
        let statPoints = res[0].statPoints;
        return number <= statPoints;
    }

    /**
     * 
     * @param {string} statName 
     * @param {number} number 
     */
    async upStat(statName, number) {
        await conn.query("UPDATE areasbonuses INNER JOIN bonustypes ON bonustypes.idBonusTypes = areasbonuses.idBonusTypes SET areasbonuses.value = areasbonuses.value + ? WHERE bonustypes.nom = ? AND areasbonuses.idArea = ?", [number, statName, this.id]);
        await conn.query("UPDATE areas SET statPoints = statPoints - ? WHERE idArea = ?;", [number, this.id]);
    }

    getListOfBonuses(lang) {
        let bonuses = {};
        for (let bonus of this.authorizedBonuses) {
            bonuses[bonus] = Translator.getString(lang, "bonuses", bonus);
        }
        return {
            bonuses: bonuses
        };
    }

    async apiGetStatsAndLevel() {
        let res = await conn.query("SELECT areas.AreaLevel as level, statPoints, price FROM areas INNER JOIN areaslevels ON areaslevels.idAreaLevel = areas.AreaLevel WHERE idArea = ?;", [this.id]);
        res = res[0];
        return {
            level: res.level,
            statPoints: res.statPoints,
            price: res.price,
        }
    }

    getName(lang = "en") {
        return Translator.getString(lang, "areasNames", this.id);
    }

    getDesc(lang = "en") {
        let desc = Translator.getString(lang, "areasDesc", this.id, [], true);
        return desc != null ? desc : Translator.getString(lang, "area", "no_description");
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
     * @returns {Marketplace | Shop | CraftingBuilding} Service
     */
    getService(serviceName) {
        return this.services[serviceName];
    }

    /**
     * @returns {number} Null if no guilds
     */
    async getOwnerID() {
        let res = await conn.query("SELECT idGuild FROM areasowners WHERE idArea = ?;", [this.id]);
        if (res[0]) {
            return res[0].idGuild;
        }
        return null;
    }

    static async staticGetOwnerID(idArea) {
        let res = await conn.query("SELECT idGuild FROM areasowners WHERE idArea = ?;", [idArea]);
        if (res[0]) {
            return res[0].idGuild;
        }
        return null;
    }

    /**
     * 
     * @param {string} lang 
     * @returns {string}
     */
    async getOwner(lang) {
        let res = await conn.query("SELECT idGuild FROM areasowners WHERE idArea = ?", [this.id]);
        if (res.length > 0) {
            res = await conn.query("SELECT nom FROM guilds WHERE idGuild = ?", [res[0].idGuild]);
            return res[0].nom;
        }
        return Translator.getString(lang, "general", "nobody");
    }

    async haveOwner() {
        let res = await conn.query("SELECT idGuild FROM areasowners WHERE idArea = ?", [this.id]);
        return res[0] != null;
    }

    async saveOwner() {
        if (this.owner === 0) {
            await conn.query("DELETE FROM areasowners WHERE idArea = ?", [this.id]);
        } else {
            await conn.query("INSERT INTO areasowners VALUES(?, ?)", [this.id, this.owner]);
        }

    }


    /**
     * @deprecated
     * @param {number} idGuild 
     * @param {string} lang 
     */
    async claim(idGuild, lang) {
        let err = [];
        if (this.owner == 0) {
            this.owner = idGuild;
            await this.saveOwner();
        } else {
            err.push(Translator.getString(lang, "errors", "you_cant_claim"));
        }
        return err;
    }

    async unclaim() {
        this.owner = 0;
        await this.saveOwner();
    }

    /**
     * 
     * @param {number} idGuild 
     */
    async setOwner(idGuild) {
        this.owner = idGuild;
        await this.saveOwner();
    }

    /**
     * 
     * @param {number} idArea 
     * @param {number} idGuild 
     */
    static async staticSetOwner(idArea, idGuild) {
        await conn.query("DELETE FROM areasowners WHERE idArea = ?", [idArea]);
        await conn.query("INSERT INTO areasowners VALUES(?, ?)", [idArea, idGuild]);
    }

    async getMaxItemQuality() {
        let res = await conn.query(
            "SELECT DISTINCT itemsrarities.idRarity, itemsrarities.nomRarity FROM itemsbase INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem AND areasitems.idArea = ? GROUP BY itemsrarities.idRarity ORDER BY itemsrarities.idRarity DESC LIMIT 1;", [this.id]);
        return res[0] != null ? res[0]["nomRarity"] : "common";
    }

    async getMinItemQuality() {
        let res = await conn.query(
            "SELECT DISTINCT itemsrarities.idRarity, itemsrarities.nomRarity FROM itemsbase INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem AND areasitems.idArea = ? GROUP BY itemsrarities.idRarity ORDER BY itemsrarities.idRarity ASC LIMIT 1;", [this.id]);
        return res[0] != null ? res[0]["nomRarity"] : "common";
    }


    /*
     *  API
     */
    toApiLight() {
        return {
            id: this.id,
            name: this.name,
            image: this.image,
            levels: this.minMaxLevelToString(),
            nbrPlayers: this.players.length,
        }
    }

    async toApi(lang) {
        let minimumQuality = await this.getMinItemQuality();
        let maximumQuality = await this.getMaxItemQuality();
        return {
            name: this.getName(lang),
            levels: this.minMaxLevelToString(),
            type: this.areaType,
            owner: await this.getOwner(lang),
            haveOwner: await this.haveOwner(),
            image: this.image,
            desc: this.getDesc(lang),
            minimum_quality: Translator.getString(lang, "rarities", minimumQuality),
            minimum_quality_shorthand: minimumQuality,
            maximum_quality: Translator.getString(lang, "rarities", maximumQuality),
            maximum_quality_shorthand: maximumQuality,
            monsters: this.getMonstersToApiLight(lang),
            resources: this.getResourcesApiLight(lang),
            climate: this.areaClimate
        }
    }

    async getConquest(lang) {
        let temp = await this.apiGetStatsAndLevel();
        return {
            name: this.getName(lang),
            image: this.image,
            levels: this.minMaxLevelToString(),
            owner: await this.getOwner(lang),
            bonuses: await this.apiGetBonuses(lang),
            level: temp.level,
            statPoints: temp.statPoints,
            price: temp.price,
            tournament_info: await AreaTournament.toDiscordEmbed(this.id, lang)
        }
    }

    minMaxLevelToString() {
        return this.minLevel !== this.maxLevel ? this.minLevel + "-" + this.maxLevel : this.maxLevel + "";
    }

    /**
     * @returns {WorldBoss}
     */
    async getWorldBoss() {
        let res = await conn.query("SELECT idSpawnedBoss FROM bossspawninfo WHERE idArea = ?;", [this.id]);
        if (res[0] != null && res[0].idSpawnedBoss != null) {
            let wb = new WorldBoss(res[0].idSpawnedBoss);
            await wb.load();
            return wb;
        }
        return null;
    }

    canTravelTo() {
        return true;
    }

}

module.exports = Area;
