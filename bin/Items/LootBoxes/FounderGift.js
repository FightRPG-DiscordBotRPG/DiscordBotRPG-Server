const LootBox = require("./LootBox");

class FounderGift extends LootBox {
    constructor(id) {
        super(id);
    }

    async use(character) {
        this.numberOfUse++;
        const LootSystem = require("../../LootSystem");
        let ls = new LootSystem();
        let items = [5, 10, 15, 20, 41];
        let numbers = [1, 1, 1, 1, 10];

        let itemsLevel = character.getLevel();
        itemsLevel = itemsLevel > 20 ? 20 : itemsLevel;
        for (let i in items) {
            if (await ls.giveToPlayer(character, items[i], itemsLevel, numbers[i])) {
                this.addItem(items[i], numbers[i]);
            }
        }
        await character.addMoney(1000);
        this.addGold(1000);
        return this.openResult;
    }

}

module.exports = FounderGift;