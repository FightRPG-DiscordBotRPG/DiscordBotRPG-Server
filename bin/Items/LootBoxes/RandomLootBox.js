const Globals = require("../../Globals");
const LootBox = require("./LootBox");


class RandomLootBox extends LootBox {
    constructor(id) {
        super(id);
        /**
         * [
         *  {
         *      id: number,
         *      amount: number,
         *      ?dropRate: number,
         *      ?rarityDrop: number,
         *  } 
         * ]
         */
        this.itemsList = [];
        this.maxDrop = 1;

    }

    /**
     * 
     * @param {Character} character
     * @param {number} numberOfUse
     */
    async use(character, numberOfUse=1) {
        this.numberOfUse += numberOfUse;

        const LootSystem = require("../../LootSystem");
        let ls = new LootSystem();
        let totalDrop = 0;
        //console.log("Random Loot Box");
        for (let i = 0; i < numberOfUse; i++) {
            for (let item of this.itemsList) {
                // drop rate specified
                let dropRate;
                if (item.dropRate != null && item.dropRate > 0) {
                    dropRate = item.dropRate;
                } else {
                    dropRate = Globals.getDropChances(item.rarityDrop);
                }
                let luck = Math.random();
                if (luck <= dropRate * character.getLuckEffectRate()) {
                    //Drop
                    if (await ls.giveToPlayer(character, item.id, this.getLevel(), item.amount)) {
                        this.addItem(item.id, item.amount);
                    }
                    totalDrop++;
                    if (totalDrop >= this.maxDrop) {
                        break;
                    }
                }
            }

            if (totalDrop == 0) {
                let money = Math.ceil(Math.random() * this.getLevel());
                this.addGold(money);
            }
        }
        if (this.openResult.gold > 0) {
            await character.addMoney(this.openResult.gold);
        }


    }

}

module.exports = RandomLootBox;

// Dev only => auto completion
if (false) {
    const Character = require("../../Character");
}
