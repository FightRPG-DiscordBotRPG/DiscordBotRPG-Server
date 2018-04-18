const Stats = require("./Stats/Stats");

class WorldEntity {

    constructor() {
        this.id = 0;
        this.name = "";
        this._type = "Entity";
        this.actualHP = 0;
        this.maxHP = 0;
        this.level = 0;
        this.stats = {};
    }

    updateStats() {
        if (this === WorldEntity) {
            // Error Type 2. Abstract methods can not be called directly.
            throw new TypeError("Can not call static abstract method foo.");
        } else if (this.updateStats === WorldEntity.foo) {
            // Error Type 3. The child has not implemented this method.
            throw new TypeError("Please implement static abstract method foo.");
        } else {
            // Error Type 5. The child has implemented this method but also called `super.foo()`.
            throw new TypeError("Do not call static abstract method foo from child.");
        }
    }

    damageCalcul() {
        if (this === WorldEntity) {
            // Error Type 2. Abstract methods can not be called directly.
            throw new TypeError("Can not call static abstract method foo.");
        } else if (this.damageCalcul === WorldEntity.foo) {
            // Error Type 3. The child has not implemented this method.
            throw new TypeError("Please implement static abstract method foo.");
        } else {
            // Error Type 5. The child has implemented this method but also called `super.foo()`.
            throw new TypeError("Do not call static abstract method foo from child.");
        }
    }

    damageDefenceReduction() {
        if (this === WorldEntity) {
            // Error Type 2. Abstract methods can not be called directly.
            throw new TypeError("Can not call static abstract method foo.");
        } else if (this.damageDefenceReduction === WorldEntity.foo) {
            // Error Type 3. The child has not implemented this method.
            throw new TypeError("Please implement static abstract method foo.");
        } else {
            // Error Type 5. The child has implemented this method but also called `super.foo()`.
            throw new TypeError("Do not call static abstract method foo from child.");
        }
    }

    getLevel() {
        if (this === WorldEntity) {
            // Error Type 2. Abstract methods can not be called directly.
            throw new TypeError("Can not call static abstract method foo.");
        } else if (this.getLevel === WorldEntity.foo) {
            // Error Type 3. The child has not implemented this method.
            throw new TypeError("Please implement static abstract method foo.");
        } else {
            // Error Type 5. The child has implemented this method but also called `super.foo()`.
            throw new TypeError("Do not call static abstract method foo from child.");
        }
    }

    isThisACriticalHit() {
        if (this === WorldEntity) {
            // Error Type 2. Abstract methods can not be called directly.
            throw new TypeError("Can not call static abstract method foo.");
        } else if (this.isThisACriticalHit === WorldEntity.foo) {
            // Error Type 3. The child has not implemented this method.
            throw new TypeError("Please implement static abstract method foo.");
        } else {
            // Error Type 5. The child has implemented this method but also called `super.foo()`.
            throw new TypeError("Do not call static abstract method foo from child.");
        }
    }

    getStat(statName) {
        if (this === WorldEntity) {
            // Error Type 2. Abstract methods can not be called directly.
            throw new TypeError("Can not call static abstract method foo.");
        } else if (this.getStat === WorldEntity.foo) {
            // Error Type 3. The child has not implemented this method.
            throw new TypeError("Please implement static abstract method foo.");
        } else {
            // Error Type 5. The child has implemented this method but also called `super.foo()`.
            throw new TypeError("Do not call static abstract method foo from child.");
        }
    }


    stun(advWill) {
        if (this === WorldEntity) {
            // Error Type 2. Abstract methods can not be called directly.
            throw new TypeError("Can not call static abstract method foo.");
        } else if (this.stun === WorldEntity.foo) {
            // Error Type 3. The child has not implemented this method.
            throw new TypeError("Please implement static abstract method foo.");
        } else {
            // Error Type 5. The child has implemented this method but also called `super.foo()`.
            throw new TypeError("Do not call static abstract method foo from child.");
        }
    }

}

module.exports = WorldEntity;