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
        this.actualEnergy = 0;
        this.maxEnergy = 0;
        this.level = 0;
        this.stats = new Stats();
        this.consecutiveStuns = 0;
        /**
        * @type {Object.<number, Skill>}
        */
        this.skills = {};
        /**
        * @type {Object.<number, State>}
        */
        this.states = {};
        this.skillToTestIndex = -1;
    }

    async loadSkills() {
        // TDOO load depending on class / or monsters skills
        let promises = [];
        let skillsToTest = [1, 2, 8];
        //let skillsToTest = [];
        for (let item of skillsToTest) {
            let s = new Skill();
            this.skills[s.id] = s;
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

    resetFullEnergy() {
        this.actualEnergy = this.maxEnergy;
    }

    resetEnergy() {
        this.actualEnergy = 0;
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

        this.getSkillsArray().forEach((skill) => skill.currentCastPreparation += this.getStat(Stats.possibleStats.Dexterity));

        // To Balance ? Every skill vs only one per one
        //if (this.skillToTestIndex > -1) {
        //    let speed = this.getStat("dexterity") / this.stats.getOptimalCrit(this.getLevel()) * 25;
        //    this.skills[this.skillToTestIndex].currentCastPreparation += speed;
        //}
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

    recoverAll() {
        this.clearStatus();
        this.resetFullMp();
        this.resetFullHp();
        this.resetEnergy();
    }

    clearStatus() {
        this.states = {};
    }

    /**
     * 
     * @param {number} idState
     */
    async addState(idState) {
        let state = new State();
        await state.loadWithID(idState);
        this.states[idState] = state;
    }

    /**
     * 
     * @param {Skill} skill
     */
    getSkillMpCost(skill) {
        // TODO: Add passives or status bonuses here
        //for (let state of this.states) {
        //    state.traits.forEach(t => {
        //        // Do something here ?
        //    });
        //}
        return Math.floor(skill.manaCost);
    }

    /**
    *
    * @param {Skill} skill
    */
    getSkillEnergyCost(skill) {
        // TODO: Add passives or status bonuses here
        //for (let state of this.states) {
        //    state.traits.forEach(t => {
        //        // Do something here ?
        //    });
        //}
        return Math.floor(skill.energyCost);
    }

    /**
    *
    * @param {Skill} skill
    */
    canUseSkill(skill) {
        return this.actualEnergy >= this.getSkillEnergyCost(skill) && this.actualMP >= this.getSkillEnergyCost(skill);
    }

    /**
     * Skill to be cast, if the skill isn't in cooldown and entity have enought MP/Energy
     * @returns {Skill} Skill to be cast     
     */
    getSkillToUse() {
        let selectedSkill = this.skills[this.skillToTestIndex];
        if (selectedSkill && selectedSkill.canBeCast() && this.canUseSkill(selectedSkill)) {
            return this.skills[this.skillToTestIndex];
        } else {
            return this.getSkillsArray().find(skill => skill.canBeCast() && this.canUseSkill(skill));
        }
    }

    /**
    *
    * @param {Skill} skill
    */
    removeSkillCost(skill) {
        this.actualMP = this.getSkillMpCost(skill);
        this.actualEnergy = this.getSkillEnergyCost(skill);
    }

    /**
     * 
     * @param {State} state
     */
    isStateAddable(state) {
        // TODO: Add states verifications
        //return (this.isAlive() && !this.isStateResist(stateId) &&
        //    !this._result.isStateRemoved(stateId) &&
        //    !this.isStateRestrict(stateId));
    }

    /**
     * States to be removed after battle 
     */
    removeBattleStates() {
        this.getStatesArray().forEach((state) => {
            if (state.afterFight) {
                this.removeState(state.id);
            }
        });
    }

    /**
     * @returns {Array<State>} removed states
     */
    removeStatesByDamage() {
        let removedStates = [];
        this.getStatesArray().forEach((state) => {
            if (state.afterDamage && Math.random() < state.damageProbability) {
                removedStates.push(state);
                this.removeState(state.id);
            }
        });

        return removedStates;
    }

    /**
     * 
     * @returns {Array<State>}
     */
    removeStatesByRounds() {
        let removedStates = [];
        this.getStatesArray().forEach((state) => {
            if (state.afterRounds && state.currentRound > state.roundEnd) {
                removedStates.push(state);
                this.removeState(state.id);
            }
            state.currentRound++;
        });
        return removedStates;
    }

    /**
     * 
     * @param {number} idState
     */
    removeState(idState) {
        delete this.states[idState];
    }

    /**
     * @returns {Array<State>}
     **/
    getStatesArray() {
        return Object.values(this.states);
    }

    /**
     * @returns {Array<Skill>}
     */
    getSkillsArray() {
        return Object.values(this.skills);
    }

}

module.exports = WorldEntity;
