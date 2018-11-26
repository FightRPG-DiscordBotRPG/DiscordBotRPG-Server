const LootSystem = require("../../LootSystem");
const LootBox = require("./LootBox");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");


class EquipmentLootBox extends LootBox {
    constructor(id) {
        super(id);
    }

    use(character) {
        this.numberOfUse++;
        if (Globals.equipsPossible.length > 0) {
            let possibleItems = conn.query("SELECT * FROM itemsbase WHERE idRarity = ? AND idType IN (" + Globals.equipsPossible.toString() + ");", [this.getIdRarity()]);
            if (possibleItems.length > 0) {
                let randomIndex = Math.floor(Math.random() * Math.floor(possibleItems.length));
                let ls = new LootSystem();
                if (ls.giveToPlayer(character, possibleItems[randomIndex].idBaseItem, this.getLevel(), 1)) {
                    this.addItem(possibleItems[randomIndex].idBaseItem, 1);
                }

            }
        }
        return this.openResult;
    }
}

module.exports = EquipmentLootBox;