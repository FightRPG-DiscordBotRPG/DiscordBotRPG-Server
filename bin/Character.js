'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const CharacterInventory = require("./CharacterInventory.js");
const CharacterEntity = require("./Entities/CharacterEntity.js");
const MarketplaceOrder = require("./Marketplace/MarketplaceOrder.js");
const Item = require("./Items/Item.js");
const Consumable = require("./Items/Consumable.js");
const PlayerCraft = require("./Character/LevelSystem/PlayerCraft.js");
const LootSystem = require("./LootSystem.js");
const PStatistics = require("./Achievement/PStatistics.js");
const conf = require("../conf/conf");
const CharacterAchievement = require("./Achievement/CharacterAchievements");
const Mount = require("./Items/Mounts/Mount");

class Character extends CharacterEntity {
    constructor(idUser) {
        super();
        this._type = "Character";
        this.id = null;
        this.idUser = idUser != null ? idUser : null;
        this.inv = new CharacterInventory();
        this.craftSystem = new PlayerCraft();
        this.achievements = new CharacterAchievement();
        this.statPoints = 0;
        this.money = 0;
        this.talentPoints = 0;
        this.canFightAt = 0;
        this.idArea = 1;
        this.area = new Area();
        this.idGuild = 0;

        // Party mechanics
        /**
        * @type {Group}
        */
        this.pendingPartyInvite = null;
        /**
         * @type {Group}
         */
        this.group = null;

        // Trade mechanic
        /**
         * @type {Trade}
         */
        this.pendingTradeInvite = null;
        /**
         * @type {Trade}
         */
        this.trade = null;
    }

    getIdUser() {
        return this.idUser;
    }

    async init() {

        var res = await conn.query("INSERT INTO characters VALUES (NULL, 5, 100, 1, 1);");
        this.id = res["insertId"];
        this.uuid = this.id.toString();
        //Init level system
        await Promise.all([
            this.levelSystem.init(this.id, this.idUser),
            this.craftSystem.init(this.id, this.idUser),
            this.stats.init(this.id),
            this.getInv().loadInventory(this.id),
            this.equipement.loadEquipements(this.id),
            conn.query("INSERT INTO charactershonor VALUES (" + this.id + ", 0);"),
            this.achievements.load(this.id),
            this.talents.load(this, this.id),
            this.skillBuild.load(this.id),
        ]);

        this.idArea = 1;

        this.updateStats();

        // [Health]
        this.recoverAll()
    }

    async loadCharacter(id) {
        // load from database
        let res = (await conn.query("SELECT statPoints, money, idArea, talentPoints " +
            "FROM characters " +
            "INNER JOIN charactershonor ON charactershonor.idCharacter = characters.idCharacter " +
            "WHERE characters.idCharacter = ?", [id]))[0];
        this.id = id;
        this.uuid = this.id.toString();
        await Promise.all([
            this.stats.loadStat(id),
            this.levelSystem.load(id, this.idUser),
            this.craftSystem.load(id, this.idUser),
            this.getInv().loadInventory(id),
            this.equipement.loadEquipements(id),
            this.achievements.load(id),
            this.talents.load(this, id),
            this.skillBuild.load(id),
        ]);

        this.idArea = res["idArea"];

        res = await conn.query("SELECT idGuild FROM guildsmembers WHERE idCharacter = ?;", [id]);
        if (res.length > 0) {
            this.idGuild = res[0]["idGuild"];
        }

        this.updateStats();

        this.recoverAll()

    }

    /**    
     * Loads a lighter version of the character (only stats, and equipements)
     * USE WITH CAUTION ONLY FOR PVP FIGHTS (Don't use any non loaded components)
     * @param {number} id
     */
    async lightLoad(id) {
        this.id = id;
        this.uuid = this.id.toString();
        await Promise.all([
            this.stats.loadStat(id),
            this.levelSystem.load(id, this.idUser),
            this.equipement.loadEquipements(id),
            this.talents.load(this, id),
            this.skillBuild.load(id),
        ]);

        this.updateStats();

        this.recoverAll();
    }

    async saveArea() {
        await conn.query("UPDATE characters SET idArea = ? WHERE idCharacter = ?;", [this.getIdArea(), this.id]);
    }

    /**
     * Time to wait as seconds
     * @param {Area} area
     * @param {{timeToWait: number, timeChangeDueToWeather: {climatesChanges: Array<number>, weathersChanges: Array<number>, totalTimeAddedDueToWeather: number}, goldPrice:number, neededAchievements: Array<number>} | number} costObject
     */
    async changeArea(area, costObject = 0) {
        let baseTimeToWait = costObject;
        if (!Number.isInteger(costObject)) {
            baseTimeToWait = await this.getWaitTimeTravel(costObject);
        }

        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.setWaitTime(Date.now() + (baseTimeToWait * 1000));
        this.area = area;
        await this.saveArea();
        PStatistics.incrStat(this.id, "travels", 1);
        this.healIfAreaIsSafe();

    }

    async healIfAreaIsSafe() {
        if (await this.area.isFirstFloor()) {
            this.recoverAll();
        } else {
            // Still need to reset energy
            this.resetEnergy();
        }
    }

    /**
     * 
     * @param {Area} area
     */
    setArea(area) {
        this.area = area;
    }

    resetWaitTime() {
        this.setWaitTime(0);
    }

    /**
     * 
     * @param {Number} percentage 
     */
    reduceWaitTime(percentage = 0) {
        percentage = percentage >= 0 && percentage <= 1 ? percentage : 0;
        let reduce = this.getExhaustMillis() * percentage;
        this.setWaitTime(this.getWaitTime() - reduce);
    }

    setWaitTime(time) {
        this.canFightAt = time;
    }

    getWaitTime() {
        return this.canFightAt;
    }

    getIdArea() {
        return this.area.id;
    }

    /**
     * @returns {Area}
     */
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
     * 
     * @param {Item} itemToEquip
     */
    async equipThisItem(itemToEquip) {
        let swapItem = await this.getEquipement().equip(itemToEquip.id);
        await this.getInv().deleteFromInventory(itemToEquip);
        if (swapItem > 0) {
            await this.getInv().addToInventory(swapItem);
        }
        this.checkEquipmentAchievements();
        await this.updateStatsAndHeal();
    }

    /**
     * 
     * @param {Item|number} itemToUnequip Item or IdType
     */
    async unEquipThisItem(itemToUnequip, update = true) {
        itemToUnequip = itemToUnequip.constructor === Number ? itemToUnequip : itemToUnequip.getEquipTypeID();
        let itemToInventory = await this.equipement.unEquip(itemToUnequip);
        if (itemToInventory !== -1) {
            await this.getInv().addToInventory(itemToInventory);
            if (update) {
                await this.updateStatsAndHeal();
            }
        }
    }

    async unEquipAllItems(update = true) {
        let promises = [];
        for (let idType of Globals.equipsPossible) {
            promises.push(this.unEquipThisItem(idType, false));
        }

        await Promise.all(promises);

        if (update) {
            await this.updateStatsAndHeal();
        }
    }

    async rebirth() {
        await this.levelSystem.rebirth();
        await this.unEquipAllItems(false);
        await this.resetStats(true);
        await this.resetTalents(true);
    }

    async rebirthCraft() {
        await this.craftSystem.rebirth();
    }

    /**
     * Exhaust time in seconds
     * @returns {number} Exhuast time in seconds
     */
    getExhaust() {
        return Math.ceil((this.getWaitTime() - Date.now()) / 1000);
    }

    getExhaustMillis() {
        return this.getWaitTime() - Date.now();
    }

    canDoAction() {
        return conf.env == "dev" ? true : (this.getWaitTime() <= Date.now());;
    }

    // Group System
    leaveGroup() {
        this.group = null;
    }

    // Trade system
    cancelTrade() {
        this.trade = null;
    }

    isTrading() {
        return this.trade != null;
    }

    /**
     * 
     * @param {string} stat 
     * @param {number} nbr 
     * @returns {boolean} True if no errors False if not
     */
    async upStat(stat, nbr) {
        nbr = parseInt(nbr, 10);
        if (nbr > 0 && nbr <= await this.getStatPoints()) {
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

            await Promise.all([
                this.stats.saveThisStat(stat),
                this.removeStatPoints(nbr)
            ]);

            this.updateStats();
            this.healIfAreaIsSafe();
            return true;
        }

        return false;
    }

    // Call for reseting stats
    async resetStats(ignoreCost = false) {
        return this.genericReset(async () => {
            await this.stats.reset();
            await this.setStatPoints(this.levelSystem.actualLevel * this.getStatsPointsPerLevel());
        }, ignoreCost);
    }

    async resetTalents(ignoreCost = false) {
        return this.genericReset(async () => {
            await this.setTalentPoints(this.levelSystem.actualLevel + this.getRebirthTalentBonus());
            await this.talents.reset();
            await this.skillBuild.reset();
        }, ignoreCost);
    }

    getStatsPointsPerLevel() {
        return Globals.rebirthManager.rebirthsLevelsModifiers[this.getRebirthLevel()].nbrOfStatsPointsPerLevel;
    }

    getRebirthTalentBonus() {
        return Globals.rebirthManager.rebirthsLevelsModifiers[this.getRebirthLevel()].nbrOfTalentPointsBonus;
    }

    /**
     * Common tests with reset stats/talents
     * @param {Function} resetFunction
     * @param {boolean} ignoreCost
     */
    async genericReset(resetFunction, ignoreCost = false) {

        if (!ignoreCost) {
            let resetValue = this.getResetStatsValue();
            if (await this.doIHaveEnoughMoney(resetValue)) {
                await this.removeMoney(resetValue);
            } else {
                return false;
            }
        }

        await resetFunction();
        await this.updateStatsAndHeal();
        return true;
    }

    async updateStatsAndHeal() {
        this.updateMaxStats();
        await this.healIfAreaIsSafe();
    }

    getResetStatsValue() {
        let levelMult = this.getLevel() > 3 ? this.getLevel() : 0;
        return Math.round(((levelMult) * Globals.resetStatsPricePerLevel));
    }

    async addExp(exp) {
        exp = exp >= 0 ? exp : 0;
        let startingLevel = this.levelSystem.actualLevel;
        await this.levelSystem.addThisExp(exp);
        if (startingLevel < this.levelSystem.actualLevel) {
            await Promise.all([
                this.addStatPoints(this.getStatsPointsPerLevel() * (this.levelSystem.actualLevel - startingLevel)),
                this.addTalentPoints(this.levelSystem.actualLevel - startingLevel),
            ]);
        }
    }

    async addMoney(money) {
        money = money >= 0 ? money : 0;
        await conn.query("UPDATE characters SET money = money + ? WHERE idCharacter = ?;", [money, this.id]);
    }

    async removeMoney(money) {
        money = money >= 0 ? money : 0;
        await conn.query("UPDATE characters SET money = money - ? WHERE idCharacter = ?;", [money, this.id]);
    }

    async addStatPoints(statPoints) {
        statPoints = statPoints >= 0 ? statPoints : 0;
        await conn.query("UPDATE characters SET statPoints = statPoints + ? WHERE idCharacter = ?;", [statPoints, this.id]);
    }

    async removeStatPoints(statPoints) {
        statPoints = statPoints >= 0 ? statPoints : 0;
        await conn.query("UPDATE characters SET statPoints = statPoints - ? WHERE idCharacter = ?;", [statPoints, this.id]);
    }

    async setStatPoints(statPoints) {
        statPoints = statPoints >= 0 ? statPoints : 0;
        await conn.query("UPDATE characters SET statPoints = ? WHERE idCharacter = ?;", [statPoints, this.id]);
    }

    async addTalentPoints(talentPoints) {
        talentPoints = talentPoints >= 0 ? talentPoints : 0;
        await conn.query("UPDATE characters SET talentPoints = talentPoints + ? WHERE idCharacter = ?;", [talentPoints, this.id]);
    }

    async removeTalentPoints(talentPoints) {
        talentPoints = talentPoints >= 0 ? talentPoints : 0;
        await conn.query("UPDATE characters SET talentPoints = talentPoints - ? WHERE idCharacter = ?;", [talentPoints, this.id]);
    }

    async setTalentPoints(talentPoints) {
        talentPoints = talentPoints >= 0 ? talentPoints : 0;
        await conn.query("UPDATE characters SET talentPoints = ? WHERE idCharacter = ?;", [talentPoints, this.id]);
    }

    async doIHaveEnoughMoney(money) {
        return (await this.getMoney() >= money);
    }

    /**
     * 
     * @param {number} honorPoints 
     */
    async addHonorPoints(honorPoints) {
        if (honorPoints != null) {
            if (honorPoints >= 0) {
                await conn.query("UPDATE charactershonor SET Honor = Honor + ? WHERE idCharacter = ?;", [honorPoints, this.id]);
            } else {
                await this.removeHonorPoints(-honorPoints);
            }
            return true;
        }
        return false;
    }

    async removeHonorPoints(honorPoints) {
        let honor = await this.getHonor() - honorPoints;
        honor = honor < 0 ? 0 : honor;
        await conn.query("UPDATE charactershonor SET Honor = ? WHERE idCharacter = ?;", [honor, this.id]);
    }

    // number : Nbr of items to sell
    async sellThisItem(idEmplacement, number) {
        number = number ? number : 1;
        let value = (await (this.getInv()).getItem(idEmplacement)).getCost(number);


        // Si cost > 0 alors item existe et peut se vendre
        // On fait passer true pour deleteo bject puisque si on delete tout item on doit delete de la bdd
        if (value > 0) {
            await Promise.all([
                this.getInv().removeSomeFromInventory(idEmplacement, number, true),
                this.addMoney(value)
            ]);
            PStatistics.incrStat(this.id, "gold_sell", value);
        }
        return value;
    }

    /**
     * 
     * @param {Item} item 
     * @param {*} number 
     */
    async sellThisItemWithItem(item, number) {
        number = number ? number : 1;
        let value = item.getCost(number);
        if (value > 0) {
            await Promise.all([
                this.getInv().removeSomeFromInventoryItem(item, number, true),
                this.addMoney(value)
            ]);
            PStatistics.incrStat(this.id, "gold_sell", value);
        }
        return value;
    }

    async sellAllInventory(params, lang = "en") {
        let value = (await this.getInv().getAllInventoryValue(params, lang)).value;
        await Promise.all([
            this.getInv().deleteAllFromInventory(params, lang),
            this.addMoney(value)
        ]);
        PStatistics.incrStat(this.id, "gold_sell", value);
        return value;
    }

    async setItemFavoriteInv(idEmplacement, fav) {
        let item = await this.getInv().getItem(idEmplacement);
        await item.setFavorite(fav);
        return item;
    }

    async setItemFavoriteEquip(idEquip, fav) {
        let item = await this.equipement.getItem(idEquip);
        await item.setFavorite(fav);
        return item;
    }

    async getItemFromAllInventories(idItem) {
        let item = await this.getInv().getItemOfThisIDItem(idItem);
        if (item == null)
            item = await this.getEquipement().getItemByIDItem(idItem);
        return item;
    }

    /**
     * 
     * @param {Craft} craft
     */
    isCraftable(craft) {
        return craft.itemInfo.minLevel <= this.getCraftLevel() && craft.itemInfo.minRebirthLevel <= this.getCraftRebirthLevel();
    }

    itemCraftedLevel(maxLevelItem) {
        let craftingBuilding = this.getArea().getService("craftingbuilding");
        maxLevelItem = craftingBuilding.getMaxLevel() < maxLevelItem ? craftingBuilding.getMaxLevel() : maxLevelItem;
        return this.getCraftLevel() <= maxLevelItem ? this.getCraftLevel() : maxLevelItem;
    }

    itemCraftRebirthLevel(maxRebirthLevelItem) {
        let craftingBuilding = this.getArea().getService("craftingbuilding");
        maxRebirthLevelItem = craftingBuilding.getMaxRebirthLevel() < maxRebirthLevelItem ? craftingBuilding.getMaxRebirthLevel() : maxRebirthLevelItem;
        return this.getCraftRebirthLevel() <= maxRebirthLevelItem ? this.getCraftRebirthLevel() : maxRebirthLevelItem;
    }

    /**
     * 
     * @param {Craft} craft
     * @param {number} level
     */
    async craft(craft, level = null, rebirthLevel = null) {
        let gotAllItems = true;
        if (craft.id > 0) {
            gotAllItems = (await conn.query(`SELECT 
                                                IF((SELECT 
                                                            COUNT(*)
                                                        FROM
                                                            charactersinventory
                                                                INNER JOIN
                                                            items ON items.idItem = charactersinventory.idItem
                                                        WHERE
                                                            charactersinventory.idCharacter = ?
                                                                AND items.idBaseItem IN (SELECT 
                                                                    craftitemsneeded.NeededItem
                                                                FROM
                                                                    craftitemsneeded
                                                                WHERE
                                                                    craftitemsneeded.IdCraftItem = ?)
                                                                AND charactersinventory.number >= (SELECT 
                                                                    craftitemsneeded.number
                                                                FROM
                                                                    craftitemsneeded
                                                                WHERE
                                                                    craftitemsneeded.IdCraftItem = ?
                                                                        AND craftitemsneeded.NeededItem = items.idBaseItem)) = (SELECT 
                                                            COUNT(*)
                                                        FROM
                                                            craftitemsneeded
                                                        WHERE
                                                            craftitemsneeded.IdCraftItem = ?),
                                                    'true',
                                                    'false') AS doesPlayerHaveEnoughMats;`, [this.id, craft.id, craft.id, craft.id]))[0].doesPlayerHaveEnoughMats;
            if (gotAllItems == "true") {
                let promises = [];
                // Since it's idItem i can promise all without worrying if the right item is deleted
                for (let i in craft.requiredItems) {
                    promises.push(this.getInv().removeSomeFromInventoryIdBase(craft.requiredItems[i].idBase, craft.requiredItems[i].number, true));
                }
                await Promise.all(promises);

                let ls = new LootSystem();
                let maxLevel = this.itemCraftedLevel(craft.itemInfo.maxLevel);
                let levelItem = level != null && level > 0 && level <= maxLevel ? level : maxLevel;

                let maxRebirthLevel = this.itemCraftRebirthLevel(craft.itemInfo.maxRebirthLevel);
                let rebirthLevelItem = rebirthLevel != null && rebirthLevel > 0 && rebirthLevel <= maxRebirthLevel ? rebirthLevel : maxRebirthLevel;

                await ls.giveToPlayer(this, craft.itemInfo.idBase, levelItem, 1, true, rebirthLevelItem);

                // Achiev ---> If other use switch case or what ever
                // This achiev is = craft 1 object
                this.achievements.unlock(10, Globals.connectedUsers[this.idUser]);

                return true;
            }
        }
        return false;
    }


    // Marketplace

    async sellToMarketplace(marketplace, idEmplacement, nbr, price, lang = "en") {
        let order;
        let idItem;
        if (await this.getAmountOfThisItem(idEmplacement) > nbr) {
            // Je doit créer un nouvel item
            let item = await this.getInv().getItem(idEmplacement);
            idItem = await Item.lightInsert(item.idBaseItem, item.level, 0, item.rebirthLevel);
        } else {
            // Là je n'en ai pas besoin puisque c'est le même nombre
            idItem = await this.getInv().getIdItemOfThisEmplacement(idEmplacement);
        }
        await this.getInv().removeSomeFromInventory(idEmplacement, nbr, false);
        order = new MarketplaceOrder(marketplace.id, idItem, this.id, nbr, price);
        await order.place();

        return await order.toApi(lang);
    }


    async marketplaceCollectThisItem(order) {
        let item = new Item(order.idItem);
        await item.loadItem();
        await order.remove();
        if (item.isStackable() == false) {
            await this.getInv().addToInventory(order.idItem, order.number);
        } else {
            let inventoryItemID = await this.getIdOfThisIdBase(item.idBaseItem, item.getLevel());
            if (inventoryItemID != null) {
                await this.getInv().addToInventory(inventoryItemID, order.number);
                await item.deleteItem();
            } else {
                await this.getInv().addToInventory(order.idItem, order.number);
            }
        }

    }


    async marketplaceBuyThisItem(order, number) {
        if (order.number == number) {
            await this.marketplaceCollectThisItem(order);
        } else {
            order.number -= number;
            await order.update();
            let item = new Item(order.idItem);
            await item.loadItem();
            if (item.isStackable() == false) {
                await this.getInv().addToInventory(order.idItem, order.number);
            } else {
                let inventoryItemID = await this.getIdOfThisIdBase(item.idBaseItem, item.getLevel());
                if (inventoryItemID != null) {
                    await this.getInv().addToInventory(inventoryItemID, number);
                } else {
                    let idItem = await Item.lightInsert(item.idBaseItem, item.level, 0, item.rebirthLevel);
                    await this.getInv().addToInventory(idItem, number);
                }
            }

        }
        await this.removeMoney(order.price * number);
    }

    /**
     * 
     * @param {Consumable} itemToUse 
     */
    async use(itemToUse, idEmplacement, amount) {
        if (this.canUse(itemToUse)) {
            amount = amount > 0 ? amount : 1;
            amount = amount > itemToUse.number ? itemToUse.number : (amount < 1 ? 1 : amount);
            if (itemToUse.maxUseInOneTime === 1) {
                amount = 1;
            } else if (amount > itemToUse.maxUseInOneTime) {
                amount = itemToUse.maxUseInOneTime;
            }

            let promises = [];
            promises.push(this.getInv().removeSomeFromInventory(idEmplacement, amount, true));

            await itemToUse.prepareToUse();

            promises.push(itemToUse.use(this, amount));

            await Promise.all(promises);

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
        this.setWaitTime(Date.now() + waitTime);
        return waitTime;
    }

    waitForNextPvPFight(more = 0) {
        let waitTime = this.getWaitTimePvPFight(more);
        //console.log("User : " + this.id + " have to wait " + (baseTimeToWait + more) / 1000 + " seconds to wait before next fight");
        this.setWaitTime(Date.now() + waitTime);
        return waitTime;
    }

    waitForNextResource(rarity = 1, number = Globals.collectTriesOnce) {
        let baseTimeToWait = this.getWaitTimeResource(rarity, number);
        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.setWaitTime(Date.now() + baseTimeToWait);
        return baseTimeToWait;
    }

    waitForNextCraft(rarity = 1) {
        let baseTimeToWait = this.getWaitTimeCraft(rarity);
        //console.log("User : " + this.id + " have to wait " + baseTimeToWait / 1000 + " seconds to wait before next fight");
        this.setWaitTime(Date.now() + baseTimeToWait);
        return baseTimeToWait;
    }

    getWaitTimeCraft(rarity = 1) {
        return (Globals.basicWaitTimeCraft - Math.floor(this.getCraftLevel() / Globals.maxLevel * Globals.basicWaitTimeCraft / 2)) * 1000 * rarity;
    }

    getWaitTimeResource(rarity = 1, number = Globals.collectTriesOnce) {
        let waitTime = number * Globals.basicWaitTimeCollectTravel;
        return (waitTime - Math.floor(this.getCraftLevel() / Globals.maxLevel * waitTime / 2)) * 1000 * (rarity / 2) / this.getArea().areaClimate.currentWeather.collectSpeed;
    }

    getWaitTimeFight(more = 0) {
        let conReduction = Math.floor(this.getStat(Stats.possibleStats.Constitution) / 50);
        conReduction = conReduction > Globals.basicWaitTimeBeforeFight / 2 ? Globals.basicWaitTimeBeforeFight / 2 : conReduction;
        return (Globals.basicWaitTimeBeforeFight - conReduction) * 1000 + more;
    }

    getWaitTimePvPFight(more = 0) {
        let conReduction = Math.floor(this.getStat(Stats.possibleStats.Charisma) / 50);
        conReduction = conReduction > Globals.basicWaitTimeBeforePvPFight / 2 ? Globals.basicWaitTimeBeforePvPFight / 2 : conReduction;
        return (Globals.basicWaitTimeBeforePvPFight - conReduction) * 1000 + more;
    }

    /**
     * 
     * @param {{timeToWait: number, timeChangeDueToWeather: {climatesTotalTravelTime: Array<number>, weathersChanges: Array<number>, totalTimeAddedDueToWeather: number}, goldPrice:number, neededAchievements: Array<number>}} costObject
     */
    async getWaitTimeTravel(costObject) {
        let waitTime = costObject.timeToWait;
        /**
         *  @type {Mount}
         */
        let mount = await this.getEquipement().getItemByTypeName("mount");
        let baseTimeToWait = waitTime;
        if (mount != null) {
            for (let climate in costObject.timeChangeDueToWeather.climatesTotalTravelTime) {
                let timeAdded = Math.round((1 - mount.getTravelReductionModifier(climate)) * costObject.timeChangeDueToWeather.climatesTotalTravelTime[climate]);
                baseTimeToWait -= timeAdded;
            }
        }
        return baseTimeToWait;
    }

    async isInGuild() {
        return await this.getIDGuild() > 0;
    }

    async addCraftXP(xp) {
        let actualLevel = this.getCraftLevel();
        let nextLevel = 0;
        await this.craftSystem.addThisExp(xp);
        nextLevel = this.getCraftLevel();
        return nextLevel - actualLevel;
    }

    async checkEquipmentAchievements() {
        let nbrOfMythics = 0;

        for (let item of await this.equipement.getAllItems()) {
            // test everything except mount
            if (item.type != 8) {
                // Use switch case for every rarity
                if (item.idRarity == 6) {
                    nbrOfMythics++;
                }
            } else {
                // Test equip mount
                if (item.idRarity >= 4) {
                    let idAchiev = null;
                    switch (item.subType) {
                        case 11:
                            idAchiev = 16;
                            break;
                        case 15:
                            idAchiev = 17;
                            break;
                        case 16:
                            idAchiev = 18;
                            break;
                        case 17:
                            idAchiev = 19;
                            break;
                    }

                    if (idAchiev != null) {
                        await this.achievements.unlock(idAchiev, Globals.connectedUsers[this.idUser]);

                        // Now test achiev total
                        if (await this.achievements.hasEveryAchievements([16, 17, 18, 19])) {
                            this.achievements.unlock(20, Globals.connectedUsers[this.idUser]);
                        }
                    }
                }
            }
        }

        if (nbrOfMythics == 4) {
            this.achievements.unlock(3, Globals.connectedUsers[this.idUser]);
        }
    }

    // GetSpecial
    async getStatPoints() {
        return (await conn.query("SELECT statPoints FROM characters WHERE idCharacter = ?", [this.id]))[0].statPoints;
    }

    async getTalentPoints() {
        return (await conn.query("SELECT talentPoints FROM characters WHERE idCharacter = ?", [this.id]))[0].talentPoints;
    }

    async getHonor() {
        return (await conn.query("SELECT honor FROM charactershonor WHERE idCharacter = ?;", [this.id]))[0].honor;
    }

    async getMoney() {
        return (await conn.query("SELECT money FROM characters WHERE idCharacter = ?;", [this.id]))[0].money;
    }

    /**
     * @returns {CharacterInventory}
     */
    getInv() {
        return this.inv;
    }

    getLevel() {
        return this.levelSystem.actualLevel;
    }

    getCraftLevel() {
        return this.craftSystem.getLevel();
    }

    getCraftRebirthLevel() {
        return this.craftSystem.getRebirthLevel();
    }

    getCratfXP() {
        return this.craftSystem.actualXP;
    }

    getCraftNextLevelXP() {
        return this.craftSystem.expToNextLevel;
    }

    getAchievements() {
        return this.achievements;
    }

    async haveThisObject(itemId) {
        return await this.getInv().doIHaveThisItem(itemId);
    }

    async haveThisObjectEquipped(idEmplacement) {
        return await this.equipement.getItem(idEmplacement);
    }

    async getAmountOfThisItem(idEmplacement) {
        let item = await this.getInv().getItem(idEmplacement);
        return item != null ? item.number : 0;
    }

    async getIdOfThisIdBase(idBaseItem, level = 1) {
        return await this.getInv().getIdOfThisIdBase(idBaseItem, level);
    }

    async isItemFavorite(idEmplacement) {
        let item = await this.getInv().getItem(idEmplacement);
        return item != null ? item.isFavorite : false;
    }

    async getIDGuild() {
        let res = await conn.query("SELECT idGuild FROM guildsmembers WHERE idCharacter = ?;", [this.id]);
        return res[0] != null ? res[0].idGuild : 0;
    }

    async getRebirthDataCraftToApi(lang = "en") {
        let currentRebirthCraft = Globals.rebirthManager.rebirthsLevelsModifiers[this.getCraftRebirthLevel()];
        let nexRebirthCraft = Globals.rebirthManager.rebirthsLevelsModifiers[this.getCraftRebirthLevel() + 1];
        return {
            level: this.getCraftLevel(),
            rebirthLevel: this.getCraftRebirthLevel(),
            curentRebirthsLevelsModifiers: await currentRebirthCraft.toApi(this, lang),
            nextRebirthsLevelsModifiers: await nexRebirthCraft?.toApi(this, lang),
            maxLevel: Globals.maxLevel,
        };
    }

    async getRebirthDataCharacterToApi(lang = "en") {

        let currentRebirthLevel = Globals.rebirthManager.rebirthsLevelsModifiers[this.getRebirthLevel()];
        let nextRebirthLevel = Globals.rebirthManager.rebirthsLevelsModifiers[this.getRebirthLevel() + 1];

        return {
            level: this.getLevel(),
            rebirthLevel: this.getRebirthLevel(),
            maxLevel: Globals.maxLevel,
            maxRebirthLevel: Globals.rebirthManager.maxRebirthLevel,
            curentRebirthsLevelsModifiers: await currentRebirthLevel.toApi(this, lang),
            nextRebirthsLevelsModifiers: await nextRebirthLevel?.toApi(this, lang)
        };

    }


    /**
     * 
     * @param {string} lang
     */
    async toApiSimple(lang = "en") {
        return {
            name: this.getName(),
            level: this.getLevel(),
            power: await this.getPower(),
            actualHP: this.actualHP,
            maxHP: this.maxHP,
            actualMP: this.actualMP,
            maxMP: this.maxMP,
            actualEnergy: this.actualEnergy,
            maxEnergy: this.maxEnergy,
            idArea: this.getIdArea(),
            areaName: this.getArea().getName(lang)
        }
    }

    static async exist(id) {
        if (id > 0) {
            let res = await conn.query("SELECT characters.idCharacter FROM characters WHERE characters.idCharacter = ?;", [id]);
            if (res != null && res[0] != null) {
                return true;
            }
        }
        return false;
    }

    static async staticGetIdByUID(uid) {
        if (uid != null) {
            let res = await conn.query("SELECT idCharacter FROM users WHERE idUser = ?;", [uid]);
            if (res[0]) {
                return res[0].idCharacter;
            }
        }
        return null;
    }


}

module.exports = Character;

const Area = require("./Areas/Area");
const Stats = require("./Stats/Stats.js");
const Craft = require("./CraftSystem/Craft.js");

/**
 * @typedef {import("./Trades/Trade")} Trade
 * @typedef {import("./Group")} Group
 **/