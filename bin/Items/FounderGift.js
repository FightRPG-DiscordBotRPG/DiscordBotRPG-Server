const LootSystem = require("../LootSystem");
const LootBox = require("./LootBox");
const conn = require("../../conf/mysql");
const Globals = require("../Globals");


class FounderGift extends LootBox {
    constructor(id) {
        super(id);
    }

    use(character) {
        let ls = new LootSystem();
        let items = [5, 10, 15, 20, 41];
        let numbers = [1, 1, 1, 1, 10];

        let itemsLevel = character.getLevel();
        itemsLevel = itemsLevel > 20 ? 20 : itemsLevel;
        for (let i in items) {
            if (ls.giveToPlayer(character, items[i], itemsLevel, numbers[i])) {
                this.addItem(items[i], numbers[i]);
            }
        }
        character.addMoney(1000);
        this.addGold(1000);
        return this.openResult;
    }

}

module.exports = FounderGift;