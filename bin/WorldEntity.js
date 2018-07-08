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
        this.maxHP = 10 + this.stats.constitution * 10;
        this.actualHP = this.maxHP;
    }

    damageCalcul() {
        let baseDamage = (this.stats.strength + 1) * 2;
        return Math.ceil(Math.random() * (baseDamage * 1.25 - baseDamage * 0.75) + baseDamage * 0.75);
    }

    damageDefenceReduction() {
        let reduction = this.stats.armor / ((8 * (Math.pow(this.getLevel(), 2))) / 7 + 5) * 0.5;
        return reduction > 0.5 ? 0.5 : 1 - reduction;
    }

    getLevel() {
        return this.level;
    }

    isThisACriticalHit() {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 75%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let critique = this.stats.dexterity / max;

        // Cap to 75%;
        critique = critique > .75 ? .75 : critique;

        return Math.random() <= critique ? true : false;
    }

    getCriticalHitChance() {
        let critique = this.stats.dexterity / (this.getLevel() * 2 * 4);
        return critique > .75 ? .75 : critique;
    }

    getStat(statName) {
        if (this.stats[statName]) {
            return this.stats[statName];
        }
        return 0;
    }


    stun(advWill) {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let stun = (this.stats.charisma) / max;
        let otherResist = (advWill) / max;

        // Cap to 50%;
        stun = stun > .5 ? .5 : stun;
        otherResist = otherResist > .5 ? .5 : otherResist;
        let chanceToStun = stun >= otherResist ? stun : 0;

        return Math.random() <= chanceToStun ? true : false;
    }

}

module.exports = WorldEntity;