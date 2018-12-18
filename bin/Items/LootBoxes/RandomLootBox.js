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

    async use(character) {
        this.numberOfUse++;
        const LootSystem = require("../../LootSystem");
        let ls = new LootSystem();
        let totalDrop = 0;
        //console.log("Random Loot Box");
        for (let item of this.itemsList) {
            // drop rate specified
            let dropRate;
            if (item.dropRate != null && item.dropRate > 0) {
                dropRate = item.dropRate;
            } else {
                dropRate = Globals.getDropChances(item.rarityDrop);
            }
            // TODO : Luck of player + drop rate
            let luck = Math.random();
            if (luck <= dropRate) {
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
            // TODO: Calcul right amount of money
            let money = Math.ceil(Math.random() * this.getLevel());;
            await character.addMoney(money);
            this.addGold(money);
        }


    }

}

module.exports = RandomLootBox;