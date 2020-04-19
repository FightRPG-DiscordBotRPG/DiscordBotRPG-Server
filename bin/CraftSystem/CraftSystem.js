const Globals = require("../Globals");
const Weather = require("../Climate/Weather");

class CraftSystem {

    static getXP(craftLevel, playerCraftlevel, rarity, collect) {
        let xp = Math.ceil(9 * (Math.pow(playerCraftlevel, 2) / 1.5) * (1 / 10));
        xp = xp * (1 + (1 / 5));

        let diff = playerCraftlevel - craftLevel;
        diff = diff < 0 ? -diff : diff;

        if (collect) {
            xp = xp / 1.2;
            xp = Math.ceil(xp * (diff > 4 ? 1 / diff : 1));
        } else {
            xp = xp * 2;
            xp = Math.ceil(xp * (diff > 2 ? 1 / diff : 1));
        }

        return xp;
    }

    /**
     * 
     * @param {number} intellect
     * @param {number} collectRarity
     * @param {Weather} weather
     */
    static haveCollectItem(intellect, collectRarity, weather) {
        let chance = Math.random();
        let luckModifier = intellect / (Globals.maxLevel * 6) + 1;
        //console.log(chance);
        let chanceToGet = 0;

        switch (collectRarity) {
            case 1:
                chanceToGet = Globals.collectChances.commun;
                break;
            case 2:
                chanceToGet = Globals.collectChances.rare;
                break;
            case 3:
                chanceToGet = Globals.collectChances.superieur;
                break;
            case 4:
                chanceToGet = Globals.collectChances.epique;
                break;
            case 5:
                chanceToGet = Globals.collectChances.legendaire;
                break;
        }

        chanceToGet *= weather.collectChances;
        //console.log(chance + " < " + chanceToGet * luckModifier);
        return chanceToGet * luckModifier > chance;

    }

    static getNumberOfItemsCollected(intellect, collectRarity, weather, collectTries = Globals.collectTriesOnce) {
        let totalCollected = 0;
        for (let i = 0; i < collectTries; i++) {
            if (this.haveCollectItem(intellect, collectRarity, weather)) {
                totalCollected++;
            }
        }
        return totalCollected;
    }
}

module.exports = CraftSystem;