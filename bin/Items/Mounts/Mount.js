const Item = require("../Item");

class Mount extends Item {
    constructor(id) {
        super(id);
        this.reductionPerRarity = 0.1;
        this.climateModifiers = {
            "tempered": 1,
            "desert": 1,
            "hills": 1,
            "frozen": 1,
        }
    }

    getTravelReductionModifier() {
        let reduction = 1 - (this.reductionPerRarity * this.getIdRarity());
        return reduction < 0 ? 0 : reduction;
    }
}

module.exports = Mount;