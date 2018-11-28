const Mount = require("./Mount");


class Horse extends Mount {
    constructor(id) {
        super(id);
        /*
        When climate will come this will be useful
        this.climateModifiers["tempered"] = 0;
        this.climateModifiers["desert"] = 0;
        this.climateModifiers["hills"] = 0;
        this.climateModifiers["frozen"] = 0;*/
    }
}

module.exports = Horse;