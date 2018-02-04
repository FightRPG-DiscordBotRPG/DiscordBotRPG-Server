'use strict';
const conn = require("../conf/mysql.js");
const Stats = require("./Stats.js");
const LevelSystem = require("./LevelSystem.js");
const Globals = require("./Globals.js");
const CharacterInventory = require("./CharacterInventory.js");
const CharacterEquipement = require("./CharacterEquipement.js");

class Character {

    constructor(id) {
        this.id = id;
        this.stats = new Stats();
        this.inv = new CharacterInventory();
        this.equipement = new CharacterEquipement();
        this.maxHP = 0;
        this.actualHP = 0;
        this.levelSystem = new LevelSystem();
        this.statPoints = 0;
        this.money = 0;
        this.canFightAt = 0;
        this.area = 0;
        this.honorPoints = 0;
        this.idGuild = 0;
    }

    init() {

        var res = conn.query("INSERT INTO characters VALUES (NULL, 5, 100, 1);");
        this.id = res["insertId"];

        //Init level system
        this.levelSystem.init(this.id);


        // Init Honor
        conn.query("INSERT INTO charactershonor VALUES (" + this.id + ", 0);");


        // Stat Part
        this.stats.init(this.id);
        this.statPoints = 5;
        this.money = 100;
        this.area = 1;

        //Load inv
        this.inv.loadInventory(this.id);

        // Load Equipement
        this.equipement.loadEquipements(this.id);


        //this.updateStats();
    }

    loadCharacter(id) {
        // load from database
        let res = conn.query("SELECT statPoints, money, idArea, honor " +
            "FROM characters " +
            "INNER JOIN charactershonor ON charactershonor.idCharacter = characters.idCharacter " +
            "WHERE characters.idCharacter = " + id)[0];
        this.id = id;
        this.stats.loadStat(id);
        this.levelSystem.loadLevelSystem(this.id);
        this.statPoints = res["statPoints"];
        this.money = res["money"];
        this.area = res["idArea"];
        this.honorPoints = res["honor"];

        //Load inv
        this.inv.loadInventory(id);

        // Load Equipement
        this.equipement.loadEquipements(id);

        res = conn.query("SELECT idGuild FROM guildsmembers WHERE idCharacter = " + id + ";");
        if (res.length > 0) {
            this.idGuild = res[0]["idGuild"];
        }
       
    }

    saveCharacter() {
        this.stats.saveStat();
        this.levelSystem.saveLevelSystem();
        conn.query("UPDATE characters SET statPoints = " + this.statPoints + " WHERE idCharacter = " + this.id);
    }

    saveArea() {
        conn.query("UPDATE characters SET idArea = " + this.area + " WHERE idCharacter = " + this.id);
    }

    changeArea(idArea) {
        let baseTimeToWait = (Globals.basicWaitTimeAfterTravel - Math.floor(this.stats.constitution / 10)) * 1000;
        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + baseTimeToWait;
        this.area = idArea;
        this.saveArea();
    }

    // Str Stats
    getStatsStr() {
        return this.stats.toStr(this.equipement.stats);
    }

    damageCalcul() {
        let baseDamage = (this.stats.force + 1 + this.equipement.stats.force) * 2;
        return Math.ceil(Math.random() * (baseDamage * 1.25 - baseDamage * 0.75) + baseDamage * 0.75);
    }

    // Critical hit
    isThisACriticalHit() {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let critique = (this.stats.dexterite + this.equipement.stats.dexterite) / max;

        // Cap to 50%;
        critique = critique > .5 ? .5 : critique;

        return Math.random() <= critique ? true : false;

    }

    stun(advVolonte) {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let stun = (this.stats.charisme + this.equipement.stats.charisme) / max;
        let otherResist = (advVolonte) / max;

        // Cap to 50%;
        stun        = stun > .5 ? .5 : stun;
        otherResist = otherResist > .5 ? .5 : otherResist;
        let chanceToStun = stun >= otherResist ? stun : 0;

        return Math.random() <= chanceToStun ? true : false;
    }

    // percentage reduction
    damageDefenceReduction() {
        let reduction = Math.round((this.stats.defense + this.equipement.stats.defense) / ((8 * (this.level ^ 2)) / 7 + 5));
        return reduction > 0.5 ? 0.5 : 1 - reduction;
    }

    updateStats() {
        // Partie equipement
        // TODO

        // Partie Stats
        // Con : 1 -> 10HP & Level : 1 -> 10HP
        this.maxHP = 10 + (this.stats.constitution + this.equipement.stats["constitution"]) * 10;
        this.actualHP = this.maxHP;
    }

    upStat(stat, nbr) {
        nbr = parseInt(nbr, 10);
        if (nbr > 0 && nbr <= this.statPoints) {
            switch (stat) {
                // Principaux
                case "force":
                    this.stats.force += nbr;
                    this.stats.saveThisStat(stat);
                    break;
                case "intelligence":
                    this.stats.intelligence += nbr;
                    this.stats.saveThisStat(stat);
                    break;
                case "constitution":
                    this.stats.constitution += nbr;
                    this.stats.saveThisStat(stat);
                    break;
                case "dexterite":
                    this.stats.dexterite += nbr;
                    this.stats.saveThisStat(stat);
                    break;

                /** Primaire non montable
                case "defense":
                    this.stats.defense += nbr;
                    this.stats.saveThisStat(stat);
                    break;
                    **/

                // Secondaires

                case "charisme":
                    this.stats.charisme += nbr;
                    break;
                case "sagesse":
                    this.stats.sagesse += nbr;
                    break;
                case "volonte":
                    this.stats.volonte += nbr;
                    break;
                case "perception":
                    this.stats.perception += nbr;
                    break;
                case "luck":
                    this.stats.luck += nbr;
                    break;
            }

            // Remove attributes points

            this.statPoints -= nbr;
            this.saveStatsPoints();
            this.updateStats();
            return "L'attribut " + stat + " a été augmenté et passe désormais à " + this.stats[stat]
                + ". Il vous reste " + this.statPoints + " point" + (this.statPoints > 1 ? "s" : "") + " à répartir.";
        }

        return "Vous ne pouvez pas distribuer autant de points !";
    }

    // Call for reseting stats
    resetStats() {
        let resetValue = this.getResetStatsValue()
        if (this.doIHaveEnoughMoney(resetValue)) {
            this.removeMoney(resetValue);
            this.stats.reset();
            this.statPoints = this.levelSystem.actualLevel * 5;
            return true;
        }
        return false;
    }

    getResetStatsValue() {
        return Math.round((this.getLevel() * Globals.resetStatsPricePerLevel));
    }

    addExp(exp) {
        let startingLevel = this.levelSystem.actualLevel;
        this.levelSystem.addThisExp(exp);
        if (startingLevel < this.levelSystem.actualLevel) {
            this.statPoints += 5 * (this.levelSystem.actualLevel - startingLevel);
            this.saveStatsPoints();
            this.levelSystem.saveMyLevel();
        } else {
            this.levelSystem.saveMyExp();
        }
    }

    addMoney(money) {
        this.money += money;
        this.saveMoney();
    }

    removeMoney(money) {
        this.money -= money;
        this.saveMoney();
    }

    doIHaveEnoughMoney(money) {
        return (this.money >= money);
    }

    addHonorPoints(honorPoints) {
        this.honorPoints += honorPoints;
        console.log("Add " + this.honorPoints);
        this.saveHonor();
    }

    removeHonorPoints(honorPoints) {
        this.honorPoints -= honorPoints;
        this.honorPoints = this.honorPoints < 0 ? 0 : this.honorPoints;
        console.log("Remove " + this.honorPoints);
        this.saveHonor();
    }

    // number : Nbr of items to sell
    sellThisItem(itemId, number) {
        number = number ? number : 1;
        let value = this.inv.objects[itemId] ? this.inv.objects[itemId].getCost(number) : 0;
        // Si cost > 0 alors item existe et peut se vendre
        // On fait passer true pour deleteo bject puisque si on delete tout item on doit delete de la bdd
        if (value > 0) {
            this.inv.removeSomeFromInventory(itemId, number, true);
            this.addMoney(value);
        }
        return value;
    }

    sellAllInventory() {
        let value = this.inv.getAllInventoryValue();
        this.inv.deleteAllFromInventory();
        this.addMoney(value);
        return value;
    }

    waitForNextFight() {
        let baseTimeToWait = (Globals.basicWaitTimeBeforeFight - Math.floor(this.stats.constitution / 10)) * 1000;
        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + baseTimeToWait;
    }

    waitForNextResource() {
        let baseTimeToWait = (Globals.basicWaitTimeCollectTravel - Math.floor(this.stats.constitution / 10)) * 1000;
        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + baseTimeToWait;
    }

    isInGuild() {
        return this.idGuild > 0 ? true : false;
    }

    // GetSpecial
    getLevel() {
        return this.levelSystem.actualLevel;
    }

    haveThisObject(itemId) {
        return this.inv.doIHaveThisItem(itemId);
    }

    getIdOfThisIdBase(idBaseItem) {
        return this.inv.getIdOfThisIdBase(idBaseItem);
    }

    /**
     * conn.query("SELECT DISTINCT charactershonor.idCharacter, charactershonor.Honor, users.userName FROM charactershonor INNER JOIN users ON users.idCharacter = charactershonor.idCharacter WHERE charactershonor.idCharacter = " + id + " OR charactershonor.idCharacter > " + id +" OR charactershonor.idCharacter < " + id +" ORDER BY Honor DESC LIMIT 0,25");
     */

    // Partie Base De Donn�e
    saveStatsPoints() {
        conn.query("UPDATE characters SET statPoints = " + this.statPoints + " WHERE idCharacter = " + this.id);
    }

    saveMoney() {
        conn.query("UPDATE characters SET money = " + this.money + " WHERE idCharacter = " + this.id);
    }

    saveHonor() {
        conn.query("UPDATE charactershonor SET honor = " + this.honorPoints + " WHERE idCharacter = " + this.id);
    }



}

module.exports = Character;
