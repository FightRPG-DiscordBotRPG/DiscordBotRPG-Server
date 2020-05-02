const Mount = require("./Mount");


class Horse extends Mount {
    constructor(id) {
        super(id);
        this.reductionPerRarity = 0.05;

        this.climateModifiers["temperate_oceanic"] = 1;
        this.climateModifiers["volcanic_hell"] = 1;
        this.climateModifiers["hot_desert"] = 1;
        this.climateModifiers["eternal_snow"] = 1;
        /*
        When climate will come this will be useful
        */
    }
}

module.exports = Horse;