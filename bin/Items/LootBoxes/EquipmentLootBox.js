const LootBox = require("./LootBox");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");


class EquipmentLootBox extends LootBox {
    constructor(id) {
        super(id);
    }

    async use(character, numberOfUse = 1) {
        const LootSystem = require("../../LootSystem");
        this.numberOfUse += numberOfUse;
        if (Globals.equipsPossible.length > 0) {
            let possibleItems = await conn.query("SELECT * FROM itemsbase WHERE idRarity = ? AND idType IN (" + Globals.equipsPossible.toString() + ");", [this.getIdRarity()]);
            if (possibleItems.length > 0) {
                let ls = new LootSystem();

                let randomIndex = Math.floor(Math.random() * Math.floor(possibleItems.length));
                let promises = [];
                for (let i = 0; i < numberOfUse; i++) {
                    promises.push((async () => {
                        if (await ls.giveToPlayer(character, possibleItems[randomIndex].idBaseItem, this.getLevel(), 1)) {
                            this.addItem(possibleItems[randomIndex].idBaseItem, 1);
                        }
                    })());
                }
                await Promise.all(promises);
            }
        }
        return this.openResult;
    }
}

module.exports = EquipmentLootBox;