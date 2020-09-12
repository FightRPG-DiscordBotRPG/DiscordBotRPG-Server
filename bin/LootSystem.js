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
     */
    async loot(character, totalLuck = 0, level = 1) {
        let possibleLoots = await conn.query("SELECT areasitems.idBaseItem, areasitems.percentage, areasitems.min, areasitems.max, itemsbase.idRarity, equipable FROM areasitems INNER JOIN itemsbase ON itemsbase.idBaseItem = areasitems.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idArea = ?;", [character.getIdArea()]);
        let luckModifier = totalLuck / 1000 + 1;
        let jsonLoot = {};
        let promises = [];
        for (let itemPossible of possibleLoots) {

            let dropRate = 0;
            if (itemPossible.percentage > 0) {
                dropRate = itemPossible.percentage;
            } else {
                dropRate = this.getRarityBaseChances(itemPossible.idRarity);
            }
            dropRate = dropRate * luckModifier;

            if (Math.random() < dropRate) {
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

                promises.push(this.giveToPlayer(character, itemPossible.idBaseItem, level, number));
                PStatistics.incrStat(character.id, "items_" + Globals.getRarityName(itemPossible.idRarity) + "_loot", number);

            }
        }
        await Promise.all(promises);
        return jsonLoot;

    }

    async adminGetItem(character, idBase, number) {
        return await this.giveToPlayer(character, idBase, character.getLevel(), number);
    }


    /**
     * Don't use of classes, for more efficent processing (Need to be changed if soemthing about the database is changed)
     * @param {*} idCharacter 
     * @param {*} idBase 
     * @param {*} level 
     * @param {*} number 
     */
    async giveToPlayerDatabase(idCharacter, idBase = 0, level = 1, number = 1) {
        number = Number.parseInt(number);
        number = number > 0 ? number : 1;
        let res = await conn.query("SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idBaseItem = ?", [idBase]);
        let idToAdd;

        if (res[0]) {
            res = res[0];
            level = LootSystem.isModularLevelPossible(res.nomType) ? level : 1;
            if (res.stackable == true) {
                // C'est un objet stackable
                idToAdd = await CharacterInventory.getIdOfThisIdBase(idCharacter, idBase, level);
                if (idToAdd == null) {
                    idToAdd = await this.newItem(idBase, level);
                }
                await CharacterInventory.addToInventory(idCharacter, idToAdd, number);
            } else {
                // C'est autre chose
                for (let i = 0; i < number; i++) {
                    idToAdd = await this.newItem(idBase, level);
                    await CharacterInventory.addToInventory(idCharacter, idToAdd, 1);
                }

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
    async giveToPlayer(character, idBase = 0, level = 1, number = 1) {
        number = Number.parseInt(number);
        number = number > 0 ? number : 1;
        let res = await conn.query("SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idBaseItem = ?", [idBase]);

        if (res[0]) {
            res = res[0];
            level = LootSystem.isModularLevelPossible(res.nomType) ? level : 1;
            if (res.stackable == true) {
                // C'est un objet stackable
                let idToAdd = await character.getIdOfThisIdBase(idBase, level);
                if (idToAdd == null) {
                    idToAdd = await this.newItem(idBase, level);
                }
                await character.inv.addToInventory(idToAdd, number);

            } else {
                let promises = [];
                // C'est autre chose
                for (let i = 0; i < number; i++) {
                    promises.push((async () => {
                        let idToAdd = await this.newItem(idBase, level);

                        await character.inv.addToInventory(idToAdd, 1);
                    })());

                }

                await Promise.all(promises);
            }
            return true;
        }
        return false;
    }

    /**
     * 
     * @param {string} objectSubtype
     * @param {string} statName
     * @param {number} level
     * @param {number} ratio
     */
    getStatValue(objectSubtype, statName, level, ratio) {

        let baseValue;

        switch (statName) {
            case Stats.possibleStats.Armor:
                baseValue = Math.ceil((8 * (Math.pow(level, 2)) / 7) * ratio / 4.5);
                break;
            default:
                baseValue = Math.ceil(level * ratio * 2);
                break;

        }

        let multiplier = Stats.ratiosBasedOnSubtype[statName] && Stats.ratiosBasedOnSubtype[statName][objectSubtype] ? Stats.ratiosBasedOnSubtype[statName][objectSubtype] : 1;

        return baseValue * multiplier;

    }

    /**
     * 
     * @param {string} secondaryStatName
     * @param {number} level
     * @param {number} ratio
     */
    getSecondaryStatValue(secondaryStatName, level, ratio) {

        let baseValue;

        switch (secondaryStatName) {
            case SecondaryStats.possibleStats.CriticalRate:
            case SecondaryStats.possibleStats.EvadeRate:
            case SecondaryStats.possibleStats.HitRate:
            case SecondaryStats.possibleStats.MagicalCriticalEvadeRate:
            case SecondaryStats.possibleStats.PhysicalCritcalEvadeRate:
                baseValue = Utils.randRangeInt(3, 5) * ratio;
                break;
            case SecondaryStats.possibleStats.RegenEnergy:
                baseValue = Utils.randRangeInt(2, 10) * ratio;
                break;
            case SecondaryStats.possibleStats.RegenHp:
            case SecondaryStats.possibleStats.RegenMp:
                baseValue = Utils.randRangeInt(1, level*1.25) * ratio;
                break;
            case SecondaryStats.possibleStats.SkillEnergyCost:
            case SecondaryStats.possibleStats.SkillManaCost:
                baseValue = Utils.randRangeInt(2, 5) * ratio;
                break;
            case SecondaryStats.possibleStats.Threat:
                baseValue = Utils.randRangeInt(1, level / 2);
                break;
            case SecondaryStats.possibleElementalResists.Air:
            case SecondaryStats.possibleElementalResists.Dark:
            case SecondaryStats.possibleElementalResists.Earth:
            case SecondaryStats.possibleElementalResists.Fire:
            case SecondaryStats.possibleElementalResists.Water:
            case SecondaryStats.possibleElementalResists.Light:
                baseValue = Utils.randRangeInt(1, 5) * ratio;
                break;
            default:
                baseValue = 1;
                break;

        }


        return Math.ceil(baseValue);

    }

    // Return id of new item if created
    async newItem(idBase, level, maxStatsPercentage = 100) {
        let res = await conn.query(`SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType WHERE itemsbase.idBaseItem = ?`, [idBase]);
        if (res[0]) {
            let rarity = res[0].idRarity;
            let stats = new Stats(0);
            let secondaryStats = new SecondaryStats(0);

            let statsPossible = Object.keys(Globals.statsIdsByName);
            let secondaryStatsPossible = [...Globals.allSecondaryStatsNames];
            let numberOfStats = this.getStatsNumber(rarity);
            let numberOfSecondaryStats = this.getStatsNumber(rarity);
            let objectType = res[0]["nomType"];
            let objectSubtype = res[0]["nomSousType"];
            let equipable = res[0]["equipable"];
            maxStatsPercentage = maxStatsPercentage >= 50 ? maxStatsPercentage : 100;

            if (equipable == true && LootSystem.canHaveStats(objectType)) {
                let ratio = this.getRandomStatRatio(rarity, maxStatsPercentage);

                if (objectType == "weapon") {
                    //Une arme
                    stats.strength = this.getStatValue(objectSubtype, Stats.possibleStats.Strength, level, ratio);
                    statsPossible.splice(statsPossible.indexOf("strength"), 1);
                } else {
                    stats.armor = this.getStatValue(objectSubtype, Stats.possibleStats.Armor, level, ratio);
                    statsPossible.splice(statsPossible.indexOf("armor"), 1);
                }

                while (numberOfStats > 0 && statsPossible.length > 0) {
                    ratio = this.getRandomStatRatio(rarity, maxStatsPercentage);
                    let r = statsPossible[Math.floor(Math.random() * statsPossible.length)];

                    stats[r] = this.getStatValue(objectSubtype, r, level, ratio);

                    statsPossible.splice(statsPossible.indexOf(r), 1);
                    numberOfStats--;
                }

                while (numberOfSecondaryStats > 0 && secondaryStatsPossible.length > 0) {
                    ratio = this.getRandomStatRatio(rarity, maxStatsPercentage);

                    let r = secondaryStatsPossible[Math.floor(Math.random() * secondaryStatsPossible.length)];

                    secondaryStats[r] = this.getSecondaryStatValue(r, level, ratio);

                    // Not a bonus then
                    if (Math.random() <= 0.2) {
                        secondaryStats[r] = -secondaryStats[r];

                        if (Math.random() <= 0.4 && secondaryStatsPossible.length - 1 > 0) {

                            if (Math.random() <= 0.1 && secondaryStatsPossible.length - 2 > 0) {
                                numberOfSecondaryStats++;
                            }

                            numberOfSecondaryStats++;
                        }
                    }

                    secondaryStatsPossible.splice(statsPossible.indexOf(r), 1);
                    numberOfSecondaryStats--;
                }
            }


            // Here stats have exactly the same architechture of a stats object
            // So we can calculate power
            let idInsert = await Item.lightInsert(idBase, level, Item.calculPower(stats, secondaryStats));
            let statsValues = [];
            let secondaryStatsValues = [];
            let secondaryStatsElementalValues = [];

            // Preparing Stats
            for (let i in Globals.statsIdsByName) {
                statsValues.push([idInsert, parseInt(Globals.statsIdsByName[i]), stats[i]]);
            }

            // Preparing Secondary Stats
            for (let i in Globals.secondaryStatsIdsByName) {
                secondaryStatsValues.push([idInsert, parseInt(Globals.secondaryStatsIdsByName[i]), secondaryStats[i]]);
            }

            // Preparing Elemental Resists
            for (let i in Globals.elementsTypesIdsByName) {
                secondaryStatsElementalValues.push([idInsert, parseInt(Globals.elementsTypesIdsByName[i]), secondaryStats[i + "Resist"]]);
            }

            await Promise.all([
                conn.query("INSERT INTO itemsstats VALUES ?;", [statsValues]),
                conn.query("INSERT INTO itemssecondarystats VALUES ?;", [secondaryStatsValues]),
                secondaryStatsElementalValues.length > 0 ? conn.query("INSERT INTO itemssecondarystatselementalresists VALUES ?;", [secondaryStatsElementalValues]) : null,
            ]);

            return idInsert;

        }
        return -1;
    }

    /**
     * 
     * @param {string} type 
     */
    static isModularLevelPossible(type) {
        switch (type) {
            case "resource":
                return false;
            case "mount":
                return false;
            default:
                return true;
        }
    }

    static canHaveStats(type) {
        switch (type) {
            case "resource":
                return false;
            case "mount":
                return false;
            default:
                return true;
        }
    }

    getStatsNumber(rarity) {
        if (rarity < 6) {
            return rarity - 1 + this.numberOfStatsBonus(rarity);
        } else {
            return Object.keys(Globals.statsIdsByName).length;
        }
    }

    getSecondaryStatsNumber(rarity) {
        return rarity + this.numberOfStatsBonus(rarity);
    }

    numberOfStatsBonus(rarity) {
        let maxPossible = 5 - rarity;
        maxPossible = maxPossible < 0 ? 0 : maxPossible;
        let maxStats = 0;
        while (maxPossible > 0) {
            if (Math.random() < 0.1) {
                maxStats++;
            }
            maxPossible--;
        }
        return maxStats;
    }

    getRandomStatRatio(rarity, maxToPerfection = 100) {
        if (rarity < 6) {
            let min = (rarity - 1) / 5;
            let max = rarity / 5;
            return Math.random() * (max - min) + min;
        } else {
            return 1;
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