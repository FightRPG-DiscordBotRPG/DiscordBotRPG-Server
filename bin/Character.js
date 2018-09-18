'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const CharacterInventory = require("./CharacterInventory.js");
const CharacterEntity = require("./Entities/CharacterEntity.js");
const MarketplaceOrder = require("./Marketplace/MarketplaceOrder.js");
const Item = require("./Items/Item.js");
const Consumable = require("./Items/Consumable.js");
const PlayerCraft = require("./CraftSystem/PlayerCraft.js");
const LootSystem = require("./LootSystem.js");
const PStatistics = require("./Achievement/PStatistics.js");

class Character extends CharacterEntity {

    constructor(id) {
        super(id);
        this._type = "Character";
        this.id = id;
        this.inv = new CharacterInventory();
        this.craftSystem = new PlayerCraft();
        this.statPoints = 0;
        this.money = 0;
        this.canFightAt = 0;
        this.idArea = 1;
        this.area;
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
        this.idArea = 1;

        //Load inv
        this.getInv().loadInventory(this.id);

        // Load Equipement
        this.equipement.loadEquipements(this.id);


        this.updateStats();
    }

    loadCharacter(id) {
        // load from database
        let res = conn.query("SELECT statPoints, money, idArea " +
            "FROM characters " +
            "INNER JOIN charactershonor ON charactershonor.idCharacter = characters.idCharacter " +
            "WHERE characters.idCharacter = ?", [id])[0];
        this.id = id;
        this.stats.loadStat(id);
        this.levelSystem.loadLevelSystem(id);
        this.craftSystem.load(id);
        this.statPoints = res["statPoints"];
        this.money = res["money"];
        this.idArea = res["idArea"];
        //this.honorPoints = res["honor"];

        //Load inv
        this.getInv().loadInventory(id);

        // Load Equipement
        this.equipement.loadEquipements(id);

        res = conn.query("SELECT idGuild FROM guildsmembers WHERE idCharacter = " + id + ";");
        if (res.length > 0) {
            this.idGuild = res[0]["idGuild"];
        }

        this.updateStats();

    }

    saveCharacter() {
        this.stats.saveStat();
        this.levelSystem.saveLevelSystem();
        conn.query("UPDATE characters SET statPoints = " + this.statPoints + " WHERE idCharacter = " + this.id);
    }

    saveArea() {
        conn.query("UPDATE characters SET idArea = " + this.getIdArea() + " WHERE idCharacter = " + this.id);
    }

    changeArea(area, waitTime = Globals.basicWaitTimeAfterTravel) {
        let baseTimeToWait = this.getWaitTimeTravel(waitTime);
        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + baseTimeToWait;
        this.area = area;
        this.saveArea();
        PStatistics.incrStat(this.id, "travels", 1);
    }

    setArea(area) {
        this.area = area;
    }

    getIdArea() {
        return this.area.id;
    }

    getArea() {
        return this.area;
    }

    getIDRegion() {
        return this.area.getIDRegion();
    }

    getEquipement() {
        return this.equipement;
    }

    /**
     * @returns {number} Exhuast time in seconds
     */
    getExhaust() {
        return Math.ceil((this.canFightAt - Date.now()) / 1000);
    }

    canDoAction() {
        return this.canFightAt <= Date.now();
    }

    // Group System
    leaveGroup() {
        this.group = null;
    }

    // Str Stats
    getStatsStr(lang) {
        return this.stats.toStr(this.equipement.stats, lang);
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
        critique = critique > .75 ? .75 : critique;

        return Math.random() <= critique ? true : false;

    }

    /**
     * 
     * @param {string} stat 
     * @param {number} nbr 
     * @returns {boolean} True if no errors False if not
     */
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
        money = money >= 0 ? money : 0;
        conn.query("UPDATE characters SET money = money + ? WHERE idCharacter = ?;", [money, this.id]);
    }

    removeMoney(money) {
        money = money >= 0 ? money : 0;
        conn.query("UPDATE characters SET money = money - ? WHERE idCharacter = ?;", [money, this.id]);
    }

    doIHaveEnoughMoney(money) {
        return (this.getMoney() >= money);
    }

    /**
     * 
     * @param {number} honorPoints 
     */
    addHonorPoints(honorPoints) {
        /*this.honorPoints += honorPoints;
        //console.log("Add " + this.honorPoints);
        this.saveHonor();*/
        if (honorPoints != null) {
            if (honorPoints >= 0) {
                conn.query("UPDATE charactershonor SET Honor = Honor + ? WHERE idCharacter = ?;", [honorPoints, this.id]);
            } else {
                this.removeHonorPoints(honorPoints);
            }
            return true;
        }
        return false;
    }

    removeHonorPoints(honorPoints) {
        let honor = this.getHonor() - honorPoints;
        honor = honor < 0 ? 0 : honor;
        conn.query("UPDATE charactershonor SET Honor = ? WHERE idCharacter = ?;", [honor, this.id]);
    }

    // number : Nbr of items to sell
    sellThisItem(idEmplacement, number) {
        number = number ? number : 1;
        let value = this.getInv().getItem(idEmplacement).getCost(number);
        // Si cost > 0 alors item existe et peut se vendre
        // On fait passer true pour deleteo bject puisque si on delete tout item on doit delete de la bdd
        if (value > 0) {
            this.getInv().removeSomeFromInventory(idEmplacement, number, true);
            this.addMoney(value);
            PStatistics.incrStat(this.id, "gold_sell", value);
        }
        return value;
    }

    sellAllInventory() {
        let value = this.getInv().getAllInventoryValue();
        this.getInv().deleteAllFromInventory();
        this.addMoney(value);
        PStatistics.incrStat(this.id, "gold_sell", value);
        return value;
    }

    setItemFavoriteInv(idEmplacement, fav) {
        this.getInv().getItem(idEmplacement).setFavorite(fav ? fav : false);
    }

    setItemFavoriteEquip(idEquip, fav) {
        this.equipement.getItem(idEquip).setFavorite(fav ? fav : false);
    }

    // Craft
    isCraftable(craft) {
        return craft.itemInfo.minLevel <= this.getCraftLevel();
    }

    itemCraftedLevel(maxLevelItem) {
        return this.getCraftLevel() <= maxLevelItem ? this.getCraftLevel() : maxLevelItem;
    }

    craft(craft) {
        let gotAllItems = true;
        if (craft.id > 0) {
            gotAllItems = conn.query("CALL doesPlayerHaveEnoughMatsToCraftThisItem(?, ?);", [this.id, craft.id])[0][0].doesPlayerHaveEnoughMats;
            if (gotAllItems) {
                for (let i in craft.requiredItems) {
                    this.getInv().removeSomeFromInventoryIdBase(craft.requiredItems[i].idBase, craft.requiredItems[i].number, true);
                }

                let ls = new LootSystem();
                ls.giveToPlayer(this, craft.itemInfo.idBase, this.itemCraftedLevel(craft.itemInfo.maxLevel), 1);
                return true;
            }
        }
        return false;
    }


    // Marketplace

    sellToMarketplace(marketplace, idEmplacement, nbr, price) {
        let order;
        let idItem;
        if (this.getAmountOfThisItem(idEmplacement) > nbr) {
            // Je doit créer un nouvel item
            let item = this.getInv().getItem(idEmplacement);
            //idItem = Item.createNew(item.idBaseItem, item.level);
            idItem = conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES (NULL, ?, ?)", [item.idBaseItem, item.level])["insertId"];
        } else {
            // Là je n'en ai pas besoin puisque c'est le même nombre
            idItem = this.getInv().getIdItemOfThisEmplacement(idEmplacement);
        }

        this.getInv().removeSomeFromInventory(idEmplacement, nbr, false);
        order = new MarketplaceOrder(marketplace.id, idItem, this.id, nbr, price);
        order.place();
    }

    marketplaceCollectThisItem(order) {
        let item = new Item(order.idItem);
        order.remove();
        if (item.equipable) {
            this.getInv().addToInventory(order.idItem, order.number);
        } else {
            let inventoryItemID = this.getIdOfThisIdBase(item.idBaseItem, item.getLevel());
            if (inventoryItemID != null) {
                this.getInv().addToInventory(inventoryItemID, order.number);
                item.deleteItem();
            } else {
                this.getInv().addToInventory(order.idItem, order.number);
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
            if (item.isStackable() == false) {
                this.getInv().addToInventory(order.idItem, order.number);
            } else {
                let inventoryItemID = this.getIdOfThisIdBase(item.idBaseItem, item.getLevel());
                if (inventoryItemID != null) {
                    this.getInv().addToInventory(inventoryItemID, number);
                } else {
                    let idItem = conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES (NULL, ?, ?)", [item.idBaseItem, item.level])["insertId"];
                    this.getInv().addToInventory(idItem, number);
                }
            }

        }
        this.removeMoney(order.price * number);
    }

    /**
     * 
     * @param {Consumable} itemToUse 
     */
    use(itemToUse, idEmplacement) {
        if(this.canUse(itemToUse)) {
            itemToUse.use(this);
            this.getInv().removeSomeFromInventory(idEmplacement, 1, true);
        }
    }

    /**
     * 
     * @param {Item} item 
     */
    canUse(item) {
        if (item != null) {
            return item.isUsable();
        }
        return false;
    }

    // More = time in ms
    waitForNextFight(more = 0) {
        let waitTime = this.getWaitTimeFight(more);
        //console.log("User : " + this.id + " have to wait " + (baseTimeToWait + more) / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + waitTime;
        return waitTime;
    }

    waitForNextPvPFight(more = 0) {
        let waitTime = this.getWaitTimePvPFight(more);
        //console.log("User : " + this.id + " have to wait " + (baseTimeToWait + more) / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + waitTime;
        return waitTime;
    }

    waitForNextResource(rarity = 1) {
        let baseTimeToWait = this.getWaitTimeResource(rarity);
        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + baseTimeToWait;
        return baseTimeToWait;
    }

    waitForNextCraft(rarity = 1) {
        let baseTimeToWait = this.getWaitTimeCraft(rarity);
        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.canFightAt = Date.now() + baseTimeToWait;
        return baseTimeToWait;
    }

    getWaitTimeCraft(rarity = 1) {
        return (Globals.basicWaitTimeCraft - Math.floor(this.getCraftLevel() / Globals.maxLevel * Globals.basicWaitTimeCraft / 2)) * 1000 * rarity;
    }

    getWaitTimeResource(rarity = 1) {
        let waitTime = Globals.collectTriesOnce * Globals.basicWaitTimeCollectTravel;
        return (waitTime - Math.floor(this.getCraftLevel() / Globals.maxLevel * waitTime / 2)) * 1000 * rarity;
    }

    getWaitTimeFight(more = 0) {
        let conReduction = Math.floor(this.getStat("constitution") / 50);
        conReduction = conReduction > Globals.basicWaitTimeBeforeFight / 2 ? Globals.basicWaitTimeBeforeFight / 2 : conReduction;
        return (Globals.basicWaitTimeBeforeFight - conReduction) * 1000 + more;
    }

    getWaitTimePvPFight(more = 0) {
        let conReduction = Math.floor(this.getStat("charisma") / 50);
        conReduction = conReduction > Globals.basicWaitTimeBeforePvPFight / 2 ? Globals.basicWaitTimeBeforePvPFight / 2 : conReduction;
        return (Globals.basicWaitTimeBeforePvPFight - conReduction) * 1000 + more;
    }

    getWaitTimeTravel(waitTime = Globals.basicWaitTimeAfterTravel) {
        this.updateStats();
        let conReduction = Math.floor(this.getStat("constitution") / 20);
        conReduction = conReduction > waitTime / 2 ? waitTime / 2 : conReduction;
        let baseTimeToWait = (waitTime - conReduction) * 1000;
        return baseTimeToWait;
    }

    isInGuild() {
        return this.idGuild > 0;
    }

    addCraftXP(xp) {
        let actualLevel = this.getCraftLevel();
        let nextLevel = 0;
        this.craftSystem.addThisExp(xp);
        nextLevel = this.getCraftLevel();
        return nextLevel - actualLevel;
    }

    // GetSpecial
    getStatPoints() {
        return this.statPoints;
        //return conn.query("SELECT statPoints FROM characters WHERE idCharacter = ?", [this.id]);
    }

    getHonor() {
        return conn.query("SELECT honor FROM charactershonor WHERE idCharacter = ?;", [this.id])[0].honor;
    }

    getMoney() {
        return conn.query("SELECT money FROM characters WHERE idCharacter = ?;", [this.id])[0].money;
    }

    getInv() {
        return this.inv;
    }

    getLevel() {
        return this.levelSystem.actualLevel;
    }

    getCraftLevel() {
        return this.craftSystem.getLevel();
    }

    getCratfXP() {
        return this.craftSystem.actualXP;
    }

    getCraftNextLevelXP() {
        return this.craftSystem.expToNextLevel;
    }

    haveThisObject(itemId) {
        return this.getInv().doIHaveThisItem(itemId);
    }

    haveThisObjectEquipped(idEmplacement) {
        return this.equipement.getItem(idEmplacement);
    }

    getAmountOfThisItem(idEmplacement) {
        return this.getInv().getItem(idEmplacement).number;
    }

    getIdOfThisIdBase(idBaseItem, level=1) {
        return this.getInv().getIdOfThisIdBase(idBaseItem, level);
    }

    isItemFavorite(idEmplacement) {
        return this.getInv().getItem(idEmplacement).isFavorite;
    }

    /**
     * conn.query("SELECT DISTINCT charactershonor.idCharacter, charactershonor.Honor, users.userName FROM charactershonor INNER JOIN users ON users.idCharacter = charactershonor.idCharacter WHERE charactershonor.idCharacter = " + id + " OR charactershonor.idCharacter > " + id +" OR charactershonor.idCharacter < " + id +" ORDER BY Honor DESC LIMIT 0,25");
     */

    // Partie Base De Donn�e
    saveStatsPoints() {
        conn.query("UPDATE characters SET statPoints = " + this.getStatPoints() + " WHERE idCharacter = " + this.id);
    }

    saveMoney() {
        conn.query("UPDATE characters SET money = " + this.getMoney() + " WHERE idCharacter = " + this.id);
    }

    saveHonor() {
        conn.query("UPDATE charactershonor SET honor = " + this.getHonor() + " WHERE idCharacter = " + this.id);
    }

    toStrSimple() {
        return this.name + " | " + this.getLevel() + " | " + this.getPower() + "%";
    }

    static exist(id) {
        if (id > 0) {
            let res = conn.query("SELECT characters.idCharacter FROM characters WHERE characters.idCharacter = ?;", [id]);
            if (res != null && res[0] != null) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }


}

module.exports = Character;
