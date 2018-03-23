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

        let minLeg = 1 - Globals.rarityChances.legendaire * luckModifier;
        let minEpique = minLeg - Globals.rarityChances.epique * luckModifier;
        let minSuperieur = minEpique - Globals.rarityChances.superieur * luckModifier;
        let minRare = minSuperieur - Globals.rarityChances.rare * luckModifier;
        let minCommun = minRare - Globals.rarityChances.commun * luckModifier;




        if (chance >= minCommun && chance < minRare) {
            // Commun
            // 10%
            rarity = 1;
        } else if (chance >= minRare && chance < minSuperieur) {
            // Rare
            // 7.5%
            rarity = 2;
        } else if (chance >= minSuperieur && chance < minEpique) {
            // superieur
            // 4.5%
            rarity = 3;
        } else if (chance >= minEpique && chance < minLeg) {
            // epique
            // 1%
            rarity = 4;
        } else if (chance >= minLeg) {
            // 0.5%
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

    getLoot(character, rarity, level) {
        let res = conn.query("SELECT itemsbase.idBaseItem, itemsbase.idType FROM itemsbase INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem WHERE areasitems.idArea = " + character.area + " AND itemsbase.idRarity = " + rarity + ";");
        let r = Math.floor(Math.random() * res.length);
        let objectType = res[r]["idType"];
        let idItemBase = res[r]["idBaseItem"];
        let stats = {};
        let ratio = Math.floor(Math.random() * (100 - 50 + 1) + 50);
        let statsPossible = Object.keys(Globals.statsIds);
        let alreadyDone = rarity - 1;

        ratio = ratio / 100 * rarity / 5;


        if (objectType === 1) {
            //Une arme
            stats.strength = Math.ceil(level * ratio * 2);
        } else {
            stats.armor = Math.ceil((8 * (Math.pow(level, 2)) / 7) * ratio / 4.5);
        }

        while (alreadyDone > 0) {
            ratio = Math.floor(Math.random() * (100 - 50 + 1) + 50);
            ratio = ratio / 100 * rarity / 5; 
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



        
        let idInsert = conn.query("INSERT INTO items VALUES(NULL, " + idItemBase + ", " + level + ")")["insertId"];
        for (let i in stats) {
            conn.query("INSERT INTO itemsstats VALUES(" + idInsert + ", " + Globals.statsIds[i] + ", " + stats[i] + ")");
        }

        character.inv.addToInventory(idInsert);

    }

}

module.exports = LootSystem;
