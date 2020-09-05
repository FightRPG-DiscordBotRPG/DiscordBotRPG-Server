const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const RandomLootBox = require("./RandomLootBox");

class EquipmentRandomLootBox extends RandomLootBox {
    constructor(id) {
        super(id);
    }

    async prepareToUse() {
        // Depend on rarity like equipment lootbox
        // Only head,chest,legs,weapon
        if (Globals.equipsPossible.length > 0) {
            // PENDING more automated non selection of mount
            let possibleItems = await conn.query("SELECT idBaseItem FROM itemsbase WHERE idRarity = ? AND idType IN (1,2,3,4)", [this.getIdRarity()]);
            for (let pi of possibleItems) {
                this.itemsList.push({
                    id: pi.idBaseItem,
                    amount: 1,
                    rarityDrop: this.getIdRarity(),
                });
            }
        }
    }
}

module.exports = EquipmentRandomLootBox;