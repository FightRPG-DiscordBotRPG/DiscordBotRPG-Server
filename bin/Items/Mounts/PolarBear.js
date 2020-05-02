const Mount = require("./Mount");


class PolarBear extends Mount {
    constructor(id) {
        super(id);

        this.reductionPerRarity = 0.075;

        //this.climateModifiers["volcanic_hell"] = 1;
        this.climateModifiers["temperate_oceanic"] = 0.25;
        //this.climateModifiers["hot_desert"] = 0;
        this.climateModifiers["eternal_snow"] = 1;
    }
}

module.exports = PolarBear;