'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const PStatistics = require("./Achievement/PStatistics");

class LootSystem {
    // Discord User Info
    constructor() {}

    /**
     * 
     * @param {Character} character 
     * @param {number} totalLuck 
     * @param {number} level 
     */
    loot(character, totalLuck = 0, level = 1) {
        let possibleLoots = conn.query("SELECT areasitems.idBaseItem, areasitems.percentage, areasitems.min, areasitems.max, itemsbase.idRarity, equipable FROM areasitems INNER JOIN itemsbase ON itemsbase.idBaseItem = areasitems.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idArea = ?;", [character.getIdArea()]);
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

                this.giveToPlayer(character, itemPossible.idBaseItem, level, number);
                PStatistics.incrStat(character.id, "items_" + Globals.getRarityName(itemPossible.idRarity) + "_loot", number);

            }
        }
        return jsonLoot;

    }

    isTheLootExistForThisArea(idArea, rarity) {
        let res = conn.query("SELECT itemsbase.idBaseItem FROM itemsbase INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem WHERE areasitems.idArea = " + idArea + " AND itemsbase.idRarity = " + rarity + ";");
        if (res.length > 0) {
            return true;
        } else {
            return false;
        }
    }

    adminGetItem(character, idBase, number) {
        return this.giveToPlayer(character, idBase, character.getLevel(), number);
    }

    giveToPlayer(character, idBase = 0, level = 1, number = 1) {
        number = Number.parseInt(number);
        number = number > 0 ? number : 1;
        let res = conn.query("SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idBaseItem = ?", [idBase]);
        let idToAdd;

        if (res[0]) {
            res = res[0];
            level = LootSystem.isModularLevelPossible(res.nomType) ? level : 1;
            if (res.stackable == true) {
                // C'est un objet stackable
                idToAdd = character.getIdOfThisIdBase(idBase, level);
                if (idToAdd == null) {
                    idToAdd = this.newItem(idBase, level);
                }
                character.inv.addToInventory(idToAdd, number);
            } else {
                // C'est autre chose
                for (let i = 0; i < number; i++) {
                    idToAdd = this.newItem(idBase, level);
                    character.inv.addToInventory(idToAdd, 1);
                }

            }
            return true;
        }
        return false;
    }

    getLoot(character, rarity, level) {
        let res = conn.query("SELECT itemsbase.idBaseItem FROM itemsbase INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem WHERE areasitems.idArea = ? AND itemsbase.idRarity = ?;", [character.getIdArea(), rarity]);
        let r = Math.floor(Math.random() * res.length);
        let idBase = res[r]["idBaseItem"];

        this.giveToPlayer(character, idBase, level);

        /*let idItem = this.newItem(idBase, level);
        if (idItem > -1) {
            character.inv.addToInventory(idItem);
        }*/
    }

    // Return id of new item if created
    newItem(idBase, level, maxStatsPercentage = 100) {
        let res = conn.query(`SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE itemsbase.idBaseItem = ?`, [idBase]);
        if (res[0]) {
            let rarity = res[0].idRarity;
            let stats = {};
            let statsPossible = Object.keys(Globals.statsIds);
            let alreadyDone = rarity - 1 + this.berOfStatsBonus(rarity);
            let objectType = res[0]["nomType"];
            let equipable = res[0]["equipable"];
            maxStatsPercentage = maxStatsPercentage >= 50 ? maxStatsPercentage : 100;

            if (equipable == true && LootSystem.canHaveStats(objectType)) {
                let ratio = this.getRandomStatRatio(rarity, maxStatsPercentage);

                if (objectType == "weapon") {
                    //Une arme
                    stats.strength = Math.ceil(level * ratio * 2);
                } else {
                    stats.armor = Math.ceil((8 * (Math.pow(level, 2)) / 7) * ratio / 4.5);
                }

                while (alreadyDone > 0) {
                    ratio = this.getRandomStatRatio(rarity, maxStatsPercentage);
                    let r = statsPossible[Math.floor(Math.random() * statsPossible.length)];
                    while (stats[r]) {
                        r = statsPossible[Math.floor(Math.random() * statsPossible.length)];
                    }

                    if (r != "armor") {
                        stats[r] = Math.ceil(level * ratio * 2);
                    } else {
                        stats[r] = Math.ceil((8 * (Math.pow(level, 2)) / 7) * ratio / 4.5);
                    }


                    alreadyDone--;
                }
            }


            let idInsert = conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES(NULL, " + idBase + ", " + level + ")")["insertId"];
            for (let i in stats) {
                conn.query("INSERT INTO itemsstats VALUES(" + idInsert + ", " + Globals.statsIds[i] + ", " + stats[i] + ")");
            }

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

    berOfStatsBonus(rarity) {
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
        let min = (rarity - 1) / 5;
        let max = rarity / 5;
        return Math.random() * (max - min) + min;
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
            default:
                return 0;
        }
    }

}

module.exports = LootSystem;