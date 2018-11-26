const Item = require("./Item");

class Consumable extends Item {
    constructor(id) {
        super(id);
        this.numberOfUse = 0;
        this.canBeMultUsed = false;
    }

    use(character) {
        throw "Must Be Implemented";
    }

    resultToString(lang) {
        throw "To Discord must be implemented";
    }

    // Should be call only one time
    // Even if the item is used more than one time
    prepareToUse() {}
}

module.exports = Consumable;