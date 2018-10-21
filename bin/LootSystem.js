'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");

class LootSystem {
    // Discord User Info
    constructor() {
    }

    // Init for new user
    loot(luck) {
        let chance = Math.random();
        let luckModifier = luck / 100 + 1;
        //console.log(chance);
        let rarity = 0;

        let minLeg = 1 - Globals.rarityChances.legendaire * (luckModifier > 2 ? 2 : luckModifier);
        let minEpique = minLeg - Globals.rarityChances.epique * (luckModifier > 10 ? 10 : luckModifier);
        let minSuperieur = minEpique - Globals.rarityChances.superieur * (luckModifier > 5 ? 5 : luckModifier);
        let minRare = minSuperieur - Globals.rarityChances.rare * (luckModifier > 5 ? 5 : luckModifier);
        let minCommun = minRare - Globals.rarityChances.commun * (luckModifier > 5 ? 5 : luckModifier);




        if (chance >= minCommun && chance < minRare) {
            rarity = 1;
        } else if (chance >= minRare && chance < minSuperieur) {
            rarity = 2;
        } else if (chance >= minSuperieur && chance < minEpique) {
            rarity = 3;
        } else if (chance >= minEpique && chance < minLeg) {
            rarity = 4;
        } else if (chance >= minLeg) {
            rarity = 5;
        }

        // To Add Other types


        //console.log("Someone tried to loot this rarity : " + rarity + " He got : " + chance);
        return rarity;
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

    giveToPlayer(character, idBase=0, level=1, number=1) {
        number = Number.parseInt(number);
        number = number > 0 ? number : 1;
        let res = conn.query("SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE idBaseItem = ?", [idBase]);
        let idToAdd;

        if(res[0]) {
            res = res[0];
            level = LootSystem.isModularLevelPossible(res.nomType) ? level : 1;
            if(res.stackable == true) {
                // C'est un objet stackable
                idToAdd = character.getIdOfThisIdBase(idBase, level);
                if(idToAdd == null) {
                    idToAdd = this.newItem(idBase, level);
                }
                character.inv.addToInventory(idToAdd, number);
            } else {
                // C'est autre chose
                for(let i = 0; i < number; i++) {
                    idToAdd = this.newItem(idBase, character.getLevel());
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
        
        let idItem = this.newItem(idBase, level);
        if(idItem > -1) {
            character.inv.addToInventory(idItem);
        }            
    }

    // Return id of new item if created
    newItem(idBase, level, maxStatsPercentage=100) {
        let res = conn.query(`SELECT * FROM itemsbase INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE itemsbase.idBaseItem = ?`, [idBase]);
        if(res[0]) {
            let rarity = res[0].idRarity;
            let stats = {};
            let statsPossible = Object.keys(Globals.statsIds);
            let alreadyDone = rarity - 1 + this.getNumberOfStatsBonus(rarity);
            let objectType = res[0]["nomType"];
            let equipable = res[0]["equipable"];
            maxStatsPercentage = maxStatsPercentage >= 50 ? maxStatsPercentage : 100;
    
            if(equipable == true) {
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
        switch(type) {
            case "resource":
                return false;
            default:
                return true;
        }
    }

    getNumberOfStatsBonus(rarity) {
        let maxPossible = 5 - rarity;
        let maxStats = 0;
        while(maxPossible > 0) {
            if(Math.random() < 0.1) {
                maxStats++;
            }
            maxPossible--;
        }
        return maxStats;
    }

    getRandomStatRatio(rarity, maxToPerfection=100) {
        let min = (rarity - 1) / 5;
        let max = rarity / 5;
        return Math.random() * (max - min) + min;
    }

}

module.exports = LootSystem;
