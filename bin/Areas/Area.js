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
const Globals = require("../Globals.js");
const ItemLootData = require("../Loots/ItemLootData.js");

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
        this.minItemRarityId = 1;
        this.minItemRarityName = "common";
        this.maxItemRarityId = 5;
        this.maxItemRarityName = "legendary";
        /**
         * @type {Object<string,Array<ItemLootData>>}
         */
        this.possibleLoots = {};

        /**
         * @type {Object<string,Array<ItemLootData>>}
         */
        this.possibleLootsWithEvents = {};
        this.timeBeforeNextClaim = 0;
        this.players = [];
        this.services = {};
        this.authorizedBonuses = [AreaBonus.identifiers.xpFight, AreaBonus.identifiers.xpCollect, AreaBonus.identifiers.xpCraft, AreaBonus.identifiers.goldDrop, AreaBonus.identifiers.itemDrop, AreaBonus.identifiers.collectDrop];
        this.requiredAchievements = [];

        // Used to know idAreas from and to
        this.paths = {
            to: [],
            from: []
        }

        // Climate System
        this.areaClimate = new AreaClimate(this.id);

        this.bonusresetCooldown = 0;

        this.isFirstFloorCacheValue = null;
        this.isLastFloorCacheValue = null;
    }

    async loadArea() {
        let res = await conn.query("SELECT idRegion, areas.idAreaType, AreaImage, NomAreaType, minLevel, maxLevel, minRebirthLevel, maxRebirthLevel FROM areas INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType INNER JOIN areasregions ON areasregions.idArea = areas.idArea INNER JOIN areasmonsterslevels ON areasmonsterslevels.idArea = areas.idArea WHERE areas.idArea = ?", [this.id]);
        res = res[0];
        this.idRegion = res["idRegion"];
        this.image = res["AreaImage"];
        this.areaType = res["NomAreaType"];
        this.idAreaType = res["idAreaType"]
        this.minLevel = res["minLevel"];
        this.maxLevel = res["maxLevel"];
        this.minRebirthLevel = res["minRebirthLevel"];
        this.maxRebirthLevel = res["maxRebirthLevel"];

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
            let avgLevel = res[i]["avglevel"];

            // If dungeon type we might want to add monsters with low level here but scale them to area level
            if (this.areaType == "dungeon" && avgLevel < this.minLevel && avgLevel > 0) {
                avgLevel = this.minLevel;
            }

            let monsterLight = {
                id: res[i]["idMonstre"],
                avglevel: avgLevel,
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

        await this.loadItemsLootTable()

        // load required achievments
        res = await conn.query("SELECT * FROM areasrequirements WHERE idArea = ?;", [this.id]);
        for (let i in res) {
            this.requiredAchievements.push(res[i].idAchievement);
        }

        await this.areaClimate.load();
    }

    /**
     * @returns {Object<string,Array<ItemLootData>>}
     **/
    getPossibleLoots() {
        return this.possibleLootsWithEvents;
    }

    getMinRebirthLevel() {
        return this.minRebirthLevel;
    }

    getMaxRebirthLevel() {
        return this.maxRebirthLevel > 0 ? this.maxRebirthLevel : Globals.rebirthManager.maxRebirthLevel;
    }

    async loadItemsLootTable() {     


        // For generic items drop based on default min and max rarity
        let res = await conn.query("SELECT itemsbase.idBaseItem, itemsbase.idRarity, equipable FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE itemsbase.idType IN (1,2,3,4) AND itemsbase.idRarity >= ? AND itemsbase.idRarity <= ?", [this.minItemRarityId, this.maxItemRarityId]);

        this.possibleLoots = {};


        for (let item of res) {
            if (!this.possibleLoots[item.idRarity]) {
                this.possibleLoots[item.idRarity] = [];
            }

            let lootData = new ItemLootData();
            lootData.equipable = item.equipable;
            lootData.idBaseItem = item.idBaseItem;
            lootData.idRarity = item.idRarity;

            this.possibleLoots[item.idRarity].push(lootData);
        }

        // Load real loot table for this area
        res = await conn.query("SELECT areasitems.idBaseItem, areasitems.percentage, areasitems.min, areasitems.max, itemsbase.idRarity, equipable FROM areasitems INNER JOIN itemsbase ON itemsbase.idBaseItem = areasitems.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idArea = ?;", [this.getID()]);


        // Manually added loots
        // Should always be every items checked
        let specificsLoot = [];
        for (let item of res) {
            specificsLoot.push(Object.assign(new ItemLootData(), item));
        }

        this.possibleLoots["others"] = specificsLoot;

        // Take real min/max rarity from database (useful for displays)

        let minQuality = await this.getMinItemQualityFromDatabase();
        let maxQuality = await this.getMaxItemQualityFromDatabase();

        if (minQuality[0] && minQuality[0].idRarity < this.minItemRarityId) {
            this.minItemRarityId = minQuality[0].idRarity;
            this.minItemRarityName = minQuality[0].nomRarity;
        }

        if (maxQuality[0] && maxQuality[0].idRarity > this.maxItemRarityId) {
            this.maxItemRarityId = maxQuality[0].idRarity;
            this.maxItemRarityName = maxQuality[0].nomRarity;
        }

        this.possibleLootsWithEvents = this.possibleLoots;

    }

    async lightLoad() {
        let res = await conn.query("SELECT idRegion, AreaImage, NomAreaType, minLevel, maxLevel, minRebirthLevel, maxRebirthLevel FROM areas INNER JOIN areastypes ON areastypes.idAreaType = areas.idAreaType INNER JOIN areasregions ON areasregions.idArea = areas.idArea INNER JOIN areasmonsterslevels ON areasmonsterslevels.idArea = areas.idArea WHERE areas.idArea = ?", [this.id]);
        res = res[0];
        this.idRegion = res["idRegion"];
        this.image = res["AreaImage"];
        this.areaType = res["NomAreaType"];
        this.minLevel = res["minLevel"];
        this.maxLevel = res["maxLevel"];
        this.minRebirthLevel = res["minRebirthLevel"];
        this.maxRebirthLevel = res["maxRebirthLevel"];
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
     * @returns {Promise<Array<AreaBonus>>} More like an object with name of bonus as key
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
     * @return {Promise<number>}
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

    //returns when area bonus can be reset
    getResetCooldown() {
        return this.bonusresetCooldown;
    }

    getResetCooldownString(lang="en") {
        lang = lang.length > 2 ? lang : lang + "-" + lang.toUpperCase();
        return new Date(this.getResetCooldown()).toLocaleString(lang, { timeZone: 'UTC' }) + " GMT";
    }

    setResetCooldown(cooldown) {
        this.bonusresetCooldown = cooldown;
    }

    setCooldownNextDay() {
        let date = new Date();
        date.setUTCMinutes(0);
        date.setUTCSeconds(0);
        date.setUTCHours(0);
        date.setUTCDate(date.getUTCDate() + 1);
        this.setResetCooldown(date.getTime());
    }

    canResetBonuses() {
        return (this.getResetCooldown() <= Date.now());
    }

    //might or might not work
    async getTotalLevel() {
        let res = await conn.query("SELECT * FROM areasbonuses WHERE idArea = ? AND idBonusTypes;", [this.id]);
        let totalLevel = 0;
        for (let o of res) {
            totalLevel += o.value;
        }
        return totalLevel;
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
     * @returns {Promise<number>} Null if no guilds
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
     * @returns {Promise<string>}
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

    /**
     * @returns {Promise<[{idRarity:number, nomRarity: string}]>}
     **/
    async getMaxItemQualityFromDatabase() {
        return await conn.query(
            "SELECT DISTINCT itemsrarities.idRarity, itemsrarities.nomRarity FROM itemsbase INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem AND areasitems.idArea = ? GROUP BY itemsrarities.idRarity ORDER BY itemsrarities.idRarity DESC LIMIT 1;", [this.id]);
    }

    async getMaxItemQualityName() {
        return this.maxItemRarityName;
    }

    /**
     * @returns {Promise<[{idRarity:number, nomRarity: string}]>}
     **/
    async getMinItemQualityFromDatabase() {
        return await conn.query(
            "SELECT DISTINCT itemsrarities.idRarity, itemsrarities.nomRarity FROM itemsbase INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem AND areasitems.idArea = ? GROUP BY itemsrarities.idRarity ORDER BY itemsrarities.idRarity ASC LIMIT 1;", [this.id]);
    }

    async getMinItemQualityName() {
        return this.minItemRarityName;
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
            minRebirthLevel: this.getMinRebirthLevel(),
            maxRebirthLevel: this.getMaxRebirthLevel(),
            nbrPlayers: this.players.length,
        }
    }

    async toApi(lang) {
        let minimumQuality = await this.getMinItemQualityName();
        let maximumQuality = await this.getMaxItemQualityName();
        return {
            id: this.id,
            name: this.getName(lang),
            levels: this.minMaxLevelToString(),
            minRebirthLevel: this.getMinRebirthLevel(),
            maxRebirthLevel: this.getMaxRebirthLevel(),
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
            tournament_info: await AreaTournament.toApi(this.id)
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

    async canTravelTo() {
        return true;
    }

    async isLastFloor() {
        return true;
    }

    async isFirstFloor() {
        return true;
    }

    async getNextFloorOrExit() {
        throw "Not implemented";
    }

    async getEntrance() {
        throw "Not implemented";
    }

}

module.exports = Area;
