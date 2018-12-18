'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const PStatistics = require("./Achievement/PStatistics");
const CharacterInventory = require("./CharacterInventory");

class LootSystem {
    // Discord User Info
    constructor() {}

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

                await this.giveToPlayer(character, itemPossible.idBaseItem, level, number);
                PStatistics.incrStat(character.id, "items_" + Globals.getRarityName(itemPossible.idRarity) + "_loot", number);

            }
        }
        return jsonLoot;

    }

    async adminGetItem(character, idBase, number) {
        return await this.giveToPlayer(character, idBase, character.getLevel(), number);
    }

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

    async giveToPlayer(character, idBase = 0, level = 1, number = 1) {
        number = Number.parseInt(number);
        number = number > 0 ? number : 1;
        let res = await conn.query("SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idBaseItem = ?", [idBase]);
        let idToAdd;

        if (res[0]) {
            res = res[0];
            level = LootSystem.isModularLevelPossible(res.nomType) ? level : 1;
            if (res.stackable == true) {
                // C'est un objet stackable
                idToAdd = await character.getIdOfThisIdBase(idBase, level);
                if (idToAdd == null) {
                    idToAdd = await this.newItem(idBase, level);
                }
                await character.inv.addToInventory(idToAdd, number);
            } else {
                // C'est autre chose
                for (let i = 0; i < number; i++) {
                    idToAdd = await this.newItem(idBase, level);
                    await character.inv.addToInventory(idToAdd, 1);
                }

            }
            return true;
        }
        return false;
    }

    // Return id of new item if created
    async newItem(idBase, level, maxStatsPercentage = 100) {
        let res = await conn.query(`SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE itemsbase.idBaseItem = ?`, [idBase]);
        if (res[0]) {
            let rarity = res[0].idRarity;
            let stats = {};
            let statsPossible = Object.keys(Globals.statsIds);
            let alreadyDone = this.getStatsNumber(rarity);
            let objectType = res[0]["nomType"];
            let equipable = res[0]["equipable"];
            maxStatsPercentage = maxStatsPercentage >= 50 ? maxStatsPercentage : 100;

            if (equipable == true && LootSystem.canHaveStats(objectType)) {
                let ratio = this.getRandomStatRatio(rarity, maxStatsPercentage);

                if (objectType == "weapon") {
                    //Une arme
                    stats.strength = Math.ceil(level * ratio * 2);
                    statsPossible.splice(statsPossible.indexOf("strength"), 1);
                } else {
                    stats.armor = Math.ceil((8 * (Math.pow(level, 2)) / 7) * ratio / 4.5);
                    statsPossible.splice(statsPossible.indexOf("armor"), 1);
                }

                while (alreadyDone > 0 && statsPossible.length > 0) {
                    ratio = this.getRandomStatRatio(rarity, maxStatsPercentage);
                    let r = statsPossible[Math.floor(Math.random() * statsPossible.length)];

                    if (r != "armor") {
                        stats[r] = Math.ceil(level * ratio * 2);
                    } else {
                        stats[r] = Math.ceil((8 * (Math.pow(level, 2)) / 7) * ratio / 4.5);
                    }

                    statsPossible.splice(statsPossible.indexOf(r), 1);
                    alreadyDone--;
                }
            }


            let idInsert = (await conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES(NULL, " + idBase + ", " + level + ")"))["insertId"];
            let promises = [];
            for (let i in stats) {
                promises.push(conn.query("INSERT INTO itemsstats VALUES(" + idInsert + ", " + Globals.statsIds[i] + ", " + stats[i] + ")"));
            }

            await Promise.all(promises);

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
            return Object.keys(Globals.statsIds).length;
        }
    }

    numberOfStatsBonus(rarity) {
        let maxPossible = 5 - rarity;
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