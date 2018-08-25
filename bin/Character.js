'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const CharacterInventory = require("./CharacterInventory.js");
const CharacterEntity = require("./Entities/CharacterEntity");
const MarketplaceOrder = require("./Marketplace/MarketplaceOrder");
const Item = require("./Item");
const PlayerCraft = require("./CraftSystem/PlayerCraft");
const LootSystem = require("./LootSystem");
const PStatistics = require("./Achievement/PStatistics");

class Character extends CharacterEntity {

    constructor(id) {
        super();
        this._type = "Character";
        this.id = id;
        this.inv = new CharacterInventory();
        this.craftSystem = new PlayerCraft();
        this.statPoints = 0;
        this.money = 0;
        this.canFightAt = 0;
        this.idArea = 1;
        this.area;
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
        this.idArea = 1;

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
        this.idArea = res["idArea"];
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
        conn.query("UPDATE characters SET idArea = " + this.getIdArea() + " WHERE idCharacter = " + this.id);
    }

    changeArea(area, waitTime=Globals.basicWaitTimeAfterTravel) {
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
        critique = critique > .75 ? .75 : critique;

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

    damageDefenceReduction() {
        let reduction = Math.round((this.stats.armor + this.equipement.stats.armor) / ((8 * (Math.pow(this.level,2))) / 7 + 5) * .5);
        return reduction > 0.5 ? 0.5 : 1 - reduction;
    }

    /**
     * 
     * @param {string} statName 
     * @returns {number} Stat value
     */
    getStat(statName) {
        if (this.stats[statName] != null && this.equipement.stats[statName] != null) {
            return this.stats[statName] + this.equipement.stats[statName];
        }
        return 0;
    }

    /**
     * @returns {number} Power in percentage
     */
    getPower() {
        return this.equipement.getPower();
    }

    /**
     * Prends en compte l'équipement
     */
    updateStats() {
        this.maxHP = 10 + (this.stats.constitution + this.equipement.stats["constitution"]) * 10;
        this.actualHP = this.maxHP;
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
        PStatistics.incrStat(this.id, "gold_sell", value);
        return value;
    }

    setItemFavoriteInv(idEmplacement, fav) {
        this.inv.getItem(idEmplacement).setFavorite(fav ? fav : false);
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
        let items = this.inv.getItemsOfThosesIds(craft.requiredItems.map((e) => e.idBase));
        let gotAllItems = true;
        
        if(items.length === craft.requiredItems.length) {
            // Crack if got all of the required items
            for(let i in items) {
                for(let j in craft.requiredItems) {
                    if(items[i].item.idBaseItem === craft.requiredItems[j].idBase && items[i].item.number < craft.requiredItems[j].number) {
                        gotAllItems = false;
                        break;
                    }
                }
            }

            if(gotAllItems) {

                // On del les objets requis
                for(let i in items) {
                    for(let j in craft.requiredItems) {
                        if(items[i].item.idBaseItem === craft.requiredItems[j].idBase) {
                            this.inv.removeSomeFromInventory(this.inv.getEmplacementOfThisItemIdBase(items[i].item.idBaseItem), craft.requiredItems[j].number, true);
                        }
                    }
                }
                
                let ls = new LootSystem();

                // Create new item
                let newItemID = ls.newItem(craft.itemInfo.idBase, this.itemCraftedLevel(craft.itemInfo.maxLevel));

                // on add 1 à l'inventaire
                this.inv.addToInventory(newItemID);
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
            let item = this.inv.getItem(idEmplacement);
            //idItem = Item.createNew(item.idBaseItem, item.level);
            idItem = conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES (NULL, ?, ?)", [item.idBaseItem, item.level])["insertId"];
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
            let inventoryItemID = this.getIdOfThisIdBase(item.idBaseItem);
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
                let inventoryItemID = this.getIdOfThisIdBase(item.idBaseItem);
                if (inventoryItemID != null) {
                    this.inv.addToInventory(inventoryItemID, number);
                } else {
                    let idItem = conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES (NULL, ?, ?)", [item.idBaseItem, item.level])["insertId"];
                    this.inv.addToInventory(idItem, number);
                }
            }

        }
        this.removeMoney(order.price * number);  
    }

    // More = time in ms
    waitForNextFight(more = 0) {
        let waitTime = this.getWaitTimeFight(more);
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
        return (Globals.basicWaitTimeCollectTravel - Math.floor(this.getCraftLevel() / Globals.maxLevel * Globals.basicWaitTimeCollectTravel / 2)) * 1000 * rarity;
    }

    getWaitTimeFight(more = 0) {
        let conReduction = Math.floor(this.getStat("constitution") / 50);
        conReduction = conReduction > Globals.basicWaitTimeBeforeFight / 2 ? Globals.basicWaitTimeBeforeFight / 2 : conReduction;
        return (Globals.basicWaitTimeBeforeFight - conReduction) * 1000 + more;
    }

    getWaitTimeTravel(waitTime=Globals.basicWaitTimeAfterTravel) {
        let conReduction = Math.floor(this.getStat("constitution") / 20);
        conReduction = conReduction > waitTime / 2 ? waitTime / 2 : conReduction;
        let baseTimeToWait = (waitTime - conReduction) * 1000;
        return baseTimeToWait;
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
    getStatPoints() {
        return this.statPoints;
        //return conn.query("SELECT statPoints FROM characters WHERE idCharacter = ?", [this.id]);
    }

    getHonor() {
        return this.honorPoints;
    }

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

    haveThisObjectEquipped(idEmplacement) {
        return this.equipement.getItem(idEmplacement);
    }

    getAmountOfThisItem(idEmplacement) {
        return this.inv.getItem(idEmplacement).number;
    }

    getIdOfThisIdBase(idBaseItem) {
        return this.inv.getIdOfThisIdBase(idBaseItem);
    }
    
    isItemFavorite(idEmplacement) {
        return this.inv.getItem(idEmplacement).isFavorite;
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
