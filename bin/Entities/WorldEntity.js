const Stats = require("../Stats/Stats");

class WorldEntity {

    constructor() {
        this.id = 0;
        this.name = "";
        this._type = "Entity";
        this.actualHP = 0;
        this.maxHP = 0;
        this.level = 0;
        this.stats = new Stats();
        this.consecutiveStuns = 0;
    }

    updateStats() {
        this.maxHP = 10 + this.getStat("constitution") * 10;
        this.actualHP = this.maxHP;
    }

    damageCalcul() {
        let baseDamage = this.getStat("strength") + 1;
        return Math.ceil(Math.random() * 2.5 * baseDamage);
    }

    getLevel() {
        return this.level;
    }

    getName() {
        return this.name;
    }

    // Critical hit
    isThisACriticalHit() {
        return Math.random() <= this.getCriticalHitChance() ? true : false;
    }

    getCriticalHitChance() {
        let critique = this.getStat("dexterity") / this.stats.getOptimalCrit(this.getLevel());
        return critique > .75 ? .75 : critique;
    }

    damageDefenceReduction() {
        let reduction = this.getStat("armor") / this.stats.getOptimalArmor(this.getLevel()) * .5;
        return reduction > 0.5 ? 0.5 : 1 - reduction;
    }

    getStat(statName) {
        if (this.stats[statName]) {
            return this.stats[statName];
        }
        return 0;
    }



    stun(advWill) {
        let max = this.stats.getOptimalStun(this.getLevel());
        // Calcul of chance
        let stun = this.getStat("charisma") / max;
        let otherResist = (advWill) / max;

        // Cap to 50%;
        stun = stun > .5 ? .5 : stun;
        otherResist = otherResist > .5 ? .5 : otherResist;
        let chanceToStun = stun >= otherResist ? stun : 0;

        return Math.random() <= chanceToStun ? true : false;
    }

}

module.exports = WorldEntity;
