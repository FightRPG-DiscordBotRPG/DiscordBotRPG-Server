const Stats = require("../Stats/Stats");
const Skill = require("../SkillsAndStatus/Skill");
const State = require("../SkillsAndStatus/State");

class WorldEntity {

    constructor() {
        this.id = 0;
        this.name = "";
        this._type = "Entity";
        this.actualHP = 0;
        this.maxHP = 0;
        this.actualMP = 0;
        this.maxMP = 0;
        this.level = 0;
        this.stats = new Stats();
        this.consecutiveStuns = 0;
        /**
        * @type {Array<Skill>}
        */
        this.skills = [];
        /**
        * @type {Array<State>}
        */
        this.states = [];
        this.skillToTestIndex = -1;
    }

    async loadSkills() {
        // TDOO load depending on class / or monsters skills
        let promises = [];
        for (let item of [1, 2, 8]) {
            let s = new Skill();
            this.skills.push(s);
            promises.push(s.loadWithID(item));
        }
        await Promise.all(promises);
        this.skillToTestIndex = 0;
    }

    updateStats() {
        this.maxHP = 10 + this.getStat("constitution") * 10;
        this.consecutiveStuns = 0;
        if (this.actualHP <= (this.maxHP * 0.1)) {
            this.actualHP = Math.ceil(this.maxHP * 0.1);
        }
    }

    resetFullHp() {
        this.actualHP = this.maxHP;
    }

    resetFullMp() {
        this.actualMP = this.maxMP;
    }

    damageCalcul() {
        let baseDamage = this.getStat("strength") + 1;
        return Math.ceil(baseDamage * (1.5 + Math.random()));
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

    prepareCast() {
        if (this.skillToTestIndex > -1) {
            let speed = this.getStat("dexterity") / this.stats.getOptimalCrit(this.getLevel()) * 25;
            this.skills[this.skillToTestIndex].currentCastPreparation += speed;
        }

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

    isAlive() {
        return this.actualHP > 0
    }

    getIdUser() {
        return null;
    }

    recoverAll() {;
        this.clearStatus();
        this.resetFullMp();
        this.resetFullHp();
    }

    clearStatus() {
        this.states = [];
    }

}

module.exports = WorldEntity;
