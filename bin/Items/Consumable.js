const Item = require("./Item");

class Consumable extends Item {
    constructor(id) {
        super(id);
    }

    use(character) {
        throw "Use must be implemented";
    }
}

module.exports = Consumable;