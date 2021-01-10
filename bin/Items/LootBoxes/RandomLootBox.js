const Globals = require("../../Globals");
const LootBox = require("./LootBox");
const Translator = require("../../Translator/Translator");
const EquipmentRandomLootBox = require("./EquipmentRandomLootBox");
const Item = require("../Item");


class RandomLootBox extends LootBox {

    static descsCacheValues = {};

    constructor(id) {
        super(id);
        /**

         * @type
         {
            [
                {
                    id: number,
                    amount: number,
                    dropRate?: number,
                    rarityDrop?: number,
                }
            ]
         }
         */
        this.itemsList = [];
        this.maxDrop = 1;

    }

    /**
     * 
     * @param {Character} character
     * @param {number} numberOfUse
     */
    async use(character, numberOfUse = 1) {
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
                if (luck <= dropRate * character.getLuckEffectRateRaw()) {
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

    async getDesc(lang = "en") {

        // Return cached value
        if (RandomLootBox.descsCacheValues[this.idBaseItem]) {
            return RandomLootBox.descsCacheValues[this.idBaseItem];
        }


        let desc = await super.getDesc(lang);

        await this.prepareToUse();

        desc += "\n\n" + Translator.getString(lang, "lootbox", "contains", [this.maxDrop]) + "\n";

        /**
         * @type Object<string, string[]>
         */
        let possiblesPerPercentages = {};

        for (let item of this.itemsList) {
            let dropRate = Translator.getFormater(lang).format(item.dropRate * 100);
            if (!possiblesPerPercentages[dropRate]) {
                possiblesPerPercentages[dropRate] = [];
            }

            possiblesPerPercentages[dropRate].push(Item.getName(item.id, lang));
        }

        let arrOfPercentagesString = [];
        for (let i in possiblesPerPercentages) {
            arrOfPercentagesString.push("**" + i + "%** - " + possiblesPerPercentages[i].join(", "));
        }

        desc += arrOfPercentagesString.join("\n");

        // Add to cache
        RandomLootBox.descsCacheValues[this.idBaseItem] = desc;

        return desc;

    }

}

module.exports = RandomLootBox;

// Dev only => auto completion
if (false) {
    const Character = require("../../Character");
}
