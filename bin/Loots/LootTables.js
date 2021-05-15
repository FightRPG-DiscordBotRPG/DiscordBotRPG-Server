const ItemLootData = require("./ItemLootData");

class LootTables {
    constructor() {
        /**
         * @type Object<string, ItemLootData[]>
         **/
        this.tables = {};
    }

    async toApi(lang = "en") {
        let data = {};
        let allPromises = [];
        for (let list of Object.values(this.tables)) {
            for (let lootData of list) {
                if (data[lootData.idRarity] == null) {
                    data[lootData.idRarity] = [];
                }
                allPromises.push(
                    (async () => {
                        data[lootData.idRarity].push(await lootData.toApi());
                    }
                    )()
                )

            }
        }

        await Promise.all(allPromises);

        return data;

    }
}

module.exports = LootTables;