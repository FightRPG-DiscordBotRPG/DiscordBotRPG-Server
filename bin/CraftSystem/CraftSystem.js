const Globals = require("../Globals");

class CraftSystem {

    static getXP(craftLevel, playerCraftlevel, rarity, collect) {

        let xp = Math.ceil(10* (Math.pow(craftLevel, 2) / 1.5) * (.5 + rarity / 2));

        let diff = playerCraftlevel - craftLevel;
        diff = diff < 0 ? -diff : diff;

        if(collect) {
            xp = xp / 10;
            xp = Math.ceil(xp * (diff > 4 ? 0.35 : 1));
        } else {
            xp = Math.ceil(xp * (diff > 2 ? 1/diff : 1));
        }

        return xp;
    }

    static haveCollectItem(intellect, collectRarity) {
        let chance = Math.random();
        let luckModifier = intellect / 100 + 1;
        //console.log(chance);
        let chanceToGet = 0;

        switch(collectRarity) {
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
}

module.exports = CraftSystem;