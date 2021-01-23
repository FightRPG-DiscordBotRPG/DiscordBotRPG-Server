'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const PStatistics = require("./Achievement/PStatistics");
const CharacterInventory = require("./CharacterInventory");
const Item = require("./Items/Item");
const Stats = require("./Stats/Stats");
const SecondaryStats = require("./Stats/Secondary/SecondaryStats");
const Utils = require("./Utilities/Utils.js");

class LootSystem {
    // Discord User Info
    constructor() { }

    /**
     * 
     * @param {Character} character 
     * @param {number} totalLuck 
     * @param {number} level 
     * @param {number} rebirthLevel
     */
    async loot(character, totalLuck = 0, level = 1, rebirthLevel = 0) {
        let possibleLoots = character.getArea().getPossibleLoots();

        let luckModifier = Math.min(totalLuck / character.stats.getMaximumStat(level) + 1, 3);
        let jsonLoot = {};
        let promises = [];
        
        for (let rarity in possibleLoots) {
            let dropRate = 0;
            let itemPossibles = possibleLoots[rarity];
            let loots;
            if (rarity !== "others") {
                dropRate = this.getRarityBaseChances(parseInt(rarity)) * luckModifier;
                if (Math.random() <= dropRate) {
                    loots = Utils.getRandomItemsInArray(itemPossibles, 1);
                } else {
                    loots = [];
                }
            } else {
                loots = [];
                for (let item of possibleLoots[rarity]) {
                    if (item.percentage > 0) {
                        dropRate = item.percentage;
                    } else {
                        dropRate = this.getRarityBaseChances(item.idRarity);
                    }
                    dropRate = dropRate * luckModifier;
                    if (Math.random() <= dropRate) {
                        loots.push(item);
                    }
                }
            }

            for (let itemPossible of loots) {
                let number = Globals.randomInclusive(itemPossible.min, itemPossible.max);
                if (jsonLoot[itemPossible.idRarity] == null) {
                    jsonLoot[itemPossible.idRarity] = {
                        equipable: 0,
                        other: 0
                    };
                }
                if (itemPossible.equipable) {
                    jsonLoot[itemPossible.idRarity].equipable += number;
                } else {
                    jsonLoot[itemPossible.idRarity].other += number;
                }

                promises.push(this.giveToPlayer(character, itemPossible.idBaseItem, level, number, false, rebirthLevel));
                PStatistics.incrStat(character.id, "items_" + Globals.getRarityName(itemPossible.idRarity) + "_loot", number);
            }
            
        }

        await Promise.all(promises);
        return jsonLoot;

    }

    /**
     * 
     * @param {Character} character
     * @param {number} idBase
     * @param {number} number
     */
    async adminGetItem(character, idBase, number) {
        return await this.giveToPlayer(character, idBase, character.getLevel(), number, false, character.getRebirthLevel());
    }


    /**
     * Don't use of classes, for more efficent processing (Need to be changed if soemthing about the database is changed)
     * @param {number} idCharacter
     * @param {number} idBase
     * @param {number} level
     * @param {number} number 
     * @param {boolean} makeItFavorite 
     */
    async giveToPlayerDatabase(idCharacter, idBase = 0, level = 1, number = 1, makeItFavorite = false, rebirthLevel = 0) {
        number = Number.parseInt(number);
        number = number > 0 ? number : 1;
        let res = await conn.query("SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType WHERE idBaseItem = ?", [idBase]);
        let idToAdd;
        let idsToFavorites = [];

        if (res[0]) {
            res = res[0];
            if (!LootSystem.isModularLevelPossible(res.nomType, res.nomSousType)) {
                level = 1;
                rebirthLevel = 0;
            }
            if (res.stackable == true) {
                // C'est un objet stackable
                idToAdd = await CharacterInventory.getIdOfThisIdBase(idCharacter, idBase, level);
                if (idToAdd == null) {
                    idToAdd = await this.newItem(idBase, level, rebirthLevel);
                }
                await CharacterInventory.addToInventory(idCharacter, idToAdd, number);
                idsToFavorites.push(idToAdd);
            } else {

                let promises = [];
                // C'est autre chose
                for (let i = 0; i < number; i++) {
                    promises.push((async () => {
                        let idToAdd = await this.newItem(idBase, level, rebirthLevel);
                        await CharacterInventory.addToInventory(idCharacter, idToAdd, 1);
                        idsToFavorites.push(idToAdd);
                    })());

                }

                await Promise.all(promises);
            }
            if (makeItFavorite) {
                await conn.query("UPDATE items SET favorite = true WHERE idItem IN (" + idsToFavorites.join(",") + ");");
            }


            return true;
        }
        return false;
    }

    /**
     * 
     * @param {Character} character
     * @param {number} idBase
     * @param {number} level
     * @param {number} number
     */
    async giveToPlayer(character, idBase = 0, level = 1, number = 1, makeItFavorite = false, rebirthLevel = 0) {
        return await this.giveToPlayerDatabase(character.id, idBase, level, number, makeItFavorite, rebirthLevel);
    }

    

    // Return id of new item if created
    async newItem(idBase, level, rebirthLevel=0) {
        let res = await conn.query(`SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType WHERE itemsbase.idBaseItem = ?`, [idBase]);
        if (res[0]) {
            let rarity = res[0].idRarity;
            let stats = new Stats(0);
            let secondaryStats = new SecondaryStats(0);

            let objectType = res[0]["nomType"];
            let objectSubtype = res[0]["nomSousType"];
            let equipable = res[0]["equipable"];

            if (equipable == true && Item.canHaveStats(objectType)) {
                let newlyGeneratedStats = Item.generateItemsStats(rarity, objectType, objectSubtype, level, 100 + (Globals.rebirthsLevelsModifiers[rebirthLevel].percentageBonusToItemsStats));
                stats = newlyGeneratedStats.stats;
                secondaryStats = newlyGeneratedStats.secondaryStats;
            }


            // Here stats have exactly the same architechture of a stats object
            // So we can calculate power
            let idInsert = await Item.lightInsert(idBase, level, Item.calculPower(stats, secondaryStats), rebirthLevel);
            await Item.replaceAllStats(idInsert, stats, secondaryStats);

            return idInsert;

        }
        return -1;
    }


    /**
     * 
     * @param {string} type 
     */
    static isModularLevelPossible(type, subtype) {

        switch (type) {
            case "resource":
                return false;
            case "mount":
                return false;
            case "potion": {
                switch (subtype) {
                    case "reset_time_potion":
                        return false;
                    default:
                        return true;
                }
            }
            default:
                return true;
        }
    }

    getRarityBaseChances(idRarity) {
        switch (idRarity) {
            case 1:
                return Globals.rarityChances.commun;
            case 2:
                return Globals.rarityChances.rare;
            case 3:
                return Globals.rarityChances.superieur;
            case 4:
                return Globals.rarityChances.epique;
            case 5:
                return Globals.rarityChances.legendaire;
            case 6:
                return Globals.rarityChances.mythic;
            default:
                return 0;
        }
    }

}

module.exports = LootSystem;

/**
 * @typedef {import("./Character")} Character
 **/