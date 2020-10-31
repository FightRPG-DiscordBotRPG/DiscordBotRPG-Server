const Item = require("./Item");

class Consumable extends Item {
    constructor(id) {
        super(id);
        this.numberOfUse = 0;
        this.canBeMultUsed = false;
        this.maxUseInOneTime = 1;
    }

    async use(character, numberOfUse=1) {
        throw "Must Be Implemented";
    }

    resultToString(lang) {
        throw "To Discord must be implemented";
    }

    // Should be call only one time
    // Even if the item is used more than one time
    async prepareToUse() {}
}

module.exports = Consumable;