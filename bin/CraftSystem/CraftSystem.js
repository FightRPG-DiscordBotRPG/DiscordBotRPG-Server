const Globals = require("../Globals");

class CraftSystem {

    static getXP(craftLevel, playerCraftlevel, rarity, collect) {
        let xp = Math.ceil(10 * (Math.pow(playerCraftlevel, 2) / 1.5) * (1 / 10));

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

    static haveCollectItem(intellect, collectRarity) {
        let chance = Math.random();
        let luckModifier = intellect / 200 + 1;
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
        //console.log(chance + " < " + chanceToGet * luckModifier);
        return chanceToGet * luckModifier > chance;

    }

    static getNumberOfItemsCollected(intellect, collectRarity) {
        let totalCollected = 0;
        for (let i = 0; i < Globals.collectTriesOnce; i++) {
            if (this.haveCollectItem(intellect, collectRarity)) {
                totalCollected++;
            }
        }
        return totalCollected;
    }
}

module.exports = CraftSystem;