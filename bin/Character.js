'use strict';
const conn = require("../conf/mysql.js");
const StatsPlayer = require("./Stats/StatsPlayer.js");
const LevelSystem = require("./LevelSystem.js");
const Globals = require("./Globals.js");
const CharacterInventory = require("./CharacterInventory.js");
const CharacterEquipement = require("./CharacterEquipement.js");
const WorldEntity = require("./WorldEntity.js");
const MarketplaceOrder = require("./Marketplace/MarketplaceOrder");
const Item = require("./Item");
const PlayerCraft = require("./CraftSystem/PlayerCraft");

class Character extends WorldEntity {

    constructor(id) {
        super();
        this._type = "Character";

        this.id = id;
        this.stats = new StatsPlayer();
        this.inv = new CharacterInventory();
        this.equipement = new CharacterEquipement();
        this.maxHP = 0;
        this.actualHP = 0;
        this.levelSystem = new LevelSystem();
        this.craftSystem = new PlayerCraft();
        this.statPoints = 0;
        this.money = 0;
        this.canFightAt = 0;
        this.area = 0;
        this.honorPoints = 0;
        this.idGuild = 0;

        // Party mechanics
        this.pendingPartyInvite = null;
        this.group = null;
    }

    init() {

        var res = conn.query("INSERT INTO characters VALUES (NULL, 5, 100, 1);");
        this.id = res["insertId"];

        //Init level system
        this.levelSystem.init(this.id);
        this.craftSystem.init(this.id);

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
        this.craftSystem.load(this.id);
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

    // Group System
    leaveGroup() {
        this.group = null;
    }

    // Str Stats
    getStatsStr() {
        return this.stats.toStr(this.equipement.stats);
    }

    damageCalcul() {
        let baseDamage = (this.stats.strength + 1 + this.equipement.stats.strength) * 2;
        return Math.ceil(Math.random() * (baseDamage * 1.25 - baseDamage * 0.75) + baseDamage * 0.75);
    }

    // Critical hit
    isThisACriticalHit() {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let critique = (this.stats.dexterity + this.equipement.stats.dexterity) / max;

        // Cap to 50%;
        critique = critique > .5 ? .5 : critique;

        return Math.random() <= critique ? true : false;

    }

    stun(advWill) {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let stun = (this.stats.charisma + this.equipement.stats.charisma) / max;
        let otherResist = (advWill) / max;

        // Cap to 50%;
        stun        = stun > .5 ? .5 : stun;
        otherResist = otherResist > .5 ? .5 : otherResist;
        let chanceToStun = stun >= otherResist ? stun : 0;

        return Math.random() <= chanceToStun ? true : false;
    }

    // percentage reduction
    damageDefenceReduction() {
        let reduction = Math.round((this.stats.armor + this.equipement.stats.armor) / ((8 * (this.level ^ 2)) / 7 + 5));
        return reduction > 0.5 ? 0.5 : 1 - reduction;
    }

    // Get Stat
    getStat(statName) {
        if (this.stats[statName] && this.equipement.stats[statName]) {
            return this.stats[statName] + this.equipement.stats[statName];
        }
        return 0;
    }

    getPower() {
        return this.equipement.getPower();
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
                case "str":
                    this.stats.strength += nbr;
                    stat = "strength";
                    break;
                case "int":
                    this.stats.intellect += nbr;
                    stat = "intellect";
                    break;
                case "con":
                    this.stats.constitution += nbr;
                    stat = "constitution";
                    break;
                case "dex":
                    this.stats.dexterity += nbr;
                    stat = "dexterity";
                    break;

                // Secondaires

                case "cha":
                    this.stats.charisma += nbr;
                    stat = "charisma";
                    break;
                case "wis":
                    this.stats.wisdom += nbr;
                    stat = "wisdom";
                    break;
                case "will":
                    this.stats.will += nbr;
                    stat = "will";
                    break;
                case "per":
                    this.stats.perception += nbr;
                    stat = "perception";
                    break;
                case "luck":
                    this.stats.luck += nbr;
                    stat = "luck";
                    break;
            }
            this.stats.saveThisStat(stat);
            // Remove attributes points

            this.statPoints -= nbr;
            this.saveStatsPoints();
            this.updateStats();
            return true;
        }

        return false;
    }

    // Call for reseting stats
    resetStats() {
        let resetValue = this.getResetStatsValue()
        if (this.doIHaveEnoughMoney(resetValue)) {
            this.removeMoney(resetValue);
            this.stats.reset();
            this.statPoints = this.levelSystem.actualLevel * 5;
            this.saveStatsPoints();
            return true;
        }
        return false;
    }

    getResetStatsValue() {
        let levelMult = this.getLevel() > 2 ? this.getLevel() : 0;
        return Math.round(((levelMult) * Globals.resetStatsPricePerLevel));
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
        //console.log("Add " + this.honorPoints);
        this.saveHonor();
    }

    removeHonorPoints(honorPoints) {
        this.honorPoints -= honorPoints;
        this.honorPoints = this.honorPoints < 0 ? 0 : this.honorPoints;
        //console.log("Remove " + this.honorPoints);
        this.saveHonor();
    }

    // number : Nbr of items to sell
    sellThisItem(IdEmplacement, number) {
        number = number ? number : 1;
        let value = this.inv.objects[IdEmplacement] ? this.inv.objects[IdEmplacement].getCost(number) : 0;
        // Si cost > 0 alors item existe et peut se vendre
        // On fait passer true pour deleteo bject puisque si on delete tout item on doit delete de la bdd
        if (value > 0) {
            this.inv.removeSomeFromInventory(IdEmplacement, number, true);
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

    // Marketplace

    sellToMarketplace(marketplace, idEmplacement, nbr, price) {
        let order;
        let idItem;
        if (this.getAmountOfThisItem(idEmplacement) > nbr) {
            // Je doit créer un nouvel item
            let item = this.inv.getItem(idEmplacement);
            //idItem = Item.createNew(item.idBaseItem, item.level);
            idItem = conn.query("INSERT INTO items VALUES (NULL, ?, ?)", [item.idBaseItem, item.level])["insertId"];
        } else {
            // Là je n'en ai pas besoin puisque c'est le même nombre
            idItem = this.inv.getIdItemOfThisEmplacement(idEmplacement);
        }

        this.inv.removeSomeFromInventory(idEmplacement, nbr, false);
        order = new MarketplaceOrder(marketplace.id, idItem, this.id, nbr, price);
        order.place();
    }

    marketplaceCollectThisItem(order) {
        let item = new Item(order.idItem);
        order.remove();
        if (item.equipable) {
            this.inv.addToInventory(order.idItem, order.number);
        } else {
            let inventoryItemID = this.inv.getIdOfThisIdBase(item.idBaseItem);
            if (inventoryItemID != null) {
                this.inv.addToInventory(inventoryItemID, order.number);
                item.deleteItem();
            } else {
                this.inv.addToInventory(order.idItem, order.number);
            }
        }

    }


    marketplaceBuyThisItem(order, number) {
        if (order.number == number) {
            this.marketplaceCollectThisItem(order);
        } else {
            order.number -= number;
            order.update();
            let item = new Item(order.idItem);
            if (item.equipable) {
                this.inv.addToInventory(order.idItem, order.number);
            } else {
                let inventoryItemID = this.inv.getIdOfThisIdBase(item.idBaseItem);
                if (inventoryItemID != null) {
                    this.inv.addToInventory(inventoryItemID, number);
                } else {
                    let idItem = conn.query("INSERT INTO items VALUES (NULL, ?, ?)", [item.idBaseItem, item.level])["insertId"];
                    this.inv.addToInventory(idItem, number);
                }
            }

        }
        this.removeMoney(order.price * number);  
    }

    // More = time in ms
    waitForNextFight(more = 0) {
        let baseTimeToWait = (Globals.basicWaitTimeBeforeFight - Math.floor(this.stats.constitution / 50)) * 1000;
        //console.log("User : " + this.id + " have to wait " + (baseTimeToWait + more) / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + baseTimeToWait + more;
    }

    waitForNextResource(rarity = 1) {
        let baseTimeToWait = (Globals.basicWaitTimeCollectTravel - Math.floor(this.getCraftLevel() / Globals.maxLevel * Globals.basicWaitTimeCollectTravel / 2)) * 1000 * rarity;
        console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + baseTimeToWait;
    }

    isInGuild() {
        return this.idGuild > 0 ? true : false;
    }


    addCraftXP(xp) {
        let actualLevel = this.getCraftLevel();
        let nextLevel = 0;
        this.craftSystem.addThisExp(xp);
        nextLevel = this.getCraftLevel();
        return nextLevel - actualLevel;
    }

    // GetSpecial
    getLevel() {
        return this.levelSystem.actualLevel;
    }

    getCraftLevel() {
        return this.craftSystem.actualLevel;
    }

    getCratfXP() {
        return this.craftSystem.actualXP;
    }

    getCraftNextLevelXP() {
        return this.craftSystem.expToNextLevel;
    }

    haveThisObject(itemId) {
        return this.inv.doIHaveThisItem(itemId);
    }

    getAmountOfThisItem(idEmplacement) {
        return this.inv.getItem(idEmplacement).number;
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

    toStrSimple() {
        return this.name + " | " + this.getLevel() + " | " + this.getPower() + "%";
    }


}

module.exports = Character;
