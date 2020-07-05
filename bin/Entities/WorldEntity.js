const Stats = require("../Stats/Stats");
const Skill = require("../SkillsAndStatus/Skill");
const State = require("../SkillsAndStatus/State");
const Trait = require("../SkillsAndStatus/Trait");
const Effect = require("../SkillsAndStatus/Effect");

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

        // Stats modifiers key => statname, value => traits modifier
        // Reseted each round on fight
        // Only used in fight
        this.tempStatsModifiers = {};

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
        // TODO load depending on class / or monsters skills
        let promises = [];
        let skillsToTest = [1];
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
        this.maxMP = 2 + this.getStat(Stats.possibleStats.Wisdom) * 2
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

    regenerateAll() {
        let regen = {
            hp: 0,
            mp: 0,
            energy: 0
        };

        if (this.isAlive()) {
            regen.hp = this.regenerateHp();
            regen.mp = this.regenerateMp();
            regen.energy = this.regenerateEnergy();
        }

        return regen;
    }

    regenerateHp() {
        return this.healHp(this.getRegenHp());
    }

    regenerateMp() {
        return this.healMp(this.getRegenMp());
    }

    regenerateEnergy() {
        return this.healEnergy(this.getRegenEnergy());
    }

    /**
     * 
     * @param {number} toRecover
     */
    healHp(toRecover) {
        toRecover = Math.round(Math.min(toRecover, this.maxHP - this.actualHP));
        this.actualHP += toRecover;
        return toRecover;
    }

    /**
     * 
     * @param {number} toRecover
     */
    healMp(toRecover) {
        toRecover = Math.round(Math.min(toRecover, this.maxMP - this.actualMP));
        this.actualMP += toRecover;
        return toRecover;
    }

    /**
     * 
     * @param {number} toRecover
     */
    healEnergy(toRecover) {
        toRecover = Math.round(Math.min(toRecover, this.maxEnergy - this.actualEnergy));
        this.actualEnergy += toRecover;
        return toRecover;
    }

    /**
     * 
     * @param {number} damage
     */
    looseHp(damage) {
        damage = Math.round(damage);
        this.actualHP -= damage;
        damage = this.actualHP < 0 ? damage + this.actualHP : damage;
        this.actualHP = this.actualHP < 0 ? 0 : this.actualHP;
        return damage;
    }

    /**
     * 
     * @param {number} damage
     */
    looseMp(damage) {
        damage = Math.round(damage);
        this.actualMP -= damage;
        damage = this.actualMP < 0 ? damage + this.actualMP : damage;
        target.actualMP = this.actualMP < 0 ? 0 : this.actualMP;
        return damage;
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
        let statValue = this.stats.getStat(statName);

        // TODO: Maybe don't implement this on primary stats, but do this on secondary one
        if (!this.tempStatsModifiers[statName]) {
            let modifier = this.getTraitValueSum(Trait.TraitTypesNames.StatsParam, Globals.statsIdsByName[statName], null);

            if (modifier === null) {
                modifier = 1;
            } else {
                // Calcul with debuff
                modifier -= this.getTraitValueSum(Trait.TraitTypesNames.StatsDebuff, Globals.statsIdsByName[statName]);
                modifier = modifier < 1 ? 0 : modifier;
            }

            this.tempStatsModifiers[statName] = modifier;
            
        }

        return statValue * this.tempStatsModifiers[statName];
    }

    resetStatsModifiers() {
        this.tempStatsModifiers = {};
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
        let state = null;
        if (this.isStateAddable(idState)) {
            if (!this.isAffectedByState()) {
                await this.addNewState(idState);
            }

            this.states[idState].resetCounts();
            state = this.states[idState];
        }

        return state;
    }

    /**
     * 
     * @param {number} idState
     */
    async addNewState(idState) {

        let restricted = this.isRestricted();

        let state = new State();
        await state.loadWithID(idState);
        this.states[idState] = state;

        if (!restricted && this.isRestricted()) {
            // TODO: Event?!
            //this.onRestrict();
        }

        return state;
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
        return this.actualEnergy >= this.getSkillEnergyCost(skill) && this.actualMP >= this.getSkillMpCost(skill);
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
        let costs = {
            mp: this.getSkillMpCost(skill),
            energy: this.getSkillEnergyCost(skill)
        }

        this.actualMP -= costs.mp;
        this.actualEnergy -= costs.energy;

        return costs;
    }

    /**
     * 
     * @param {number} idState
     */
    isStateAddable(idState) {
        // TODO: Add states verifications
        return (this.isAlive() && !this.isStateResist(idState) &&
            !this.isAffectedByState(idState) &&
            !this.isStateRestrict(idState));
    }

    isStateRestrict(idState) {
        // TODO: Do this please
        return false;
        //return this.states[idState]?.isRemovedByRestriction() && false;
    }

    isRestricted() {
        return this.getRestrictionsMax() > 0
    }

    getRestrictionsMax() {
        return Math.max.apply(null, this.getStatesArray().map((state) => {
            return state.idStateRestriction;
        }).concat(0));
    }

    getRestrictions() {
        let restrictions = {
            targetEnemy: true,
            targetSelf: true,
            targetAlly: true
        };

        for (let state of this.getStatesArray()) {
            if (state.idStateRestriction === 4) {
                restrictions.targetAlly = false;
                restrictions.targetEnemy = false;
                restrictions.targetSelf = false;

                // Exiting the for loop
                break;
            } else {
                switch (state.idStateRestriction) {
                    case 1:
                        restrictions.targetEnemy = false;
                        break;
                    case 2:
                        restrictions.targetAlly = false;
                        break;
                    case 3:
                        restrictions.targetSelf = false;
                        break;
                }
            }

        }

        return restrictions;
    }

    

    /**
     * 
     * @param {number} value
     */
    filterRestriction(value) {
        return this.getStatesArray().find((state) => {
            return state.idStateRestriction === value;
        });
    }





    /**
     * 
     * @param {number} idState
     */
    isAffectedByState(idState) {
        return this.states[idState] != null;
    }

    /**
     * 
     * @param {number} idState
     */
    isStateResist(idState) {
        return this.getStateResists().includes(idState);
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
            if (state.isExpired()) {
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
        let stateRemoved = this.states[idState];
        delete this.states[idState];
        return stateRemoved;
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

    getPhysicalDefense() {
        let reduction = (this.getStat(Stats.possibleStats.Armor) / this.stats.getOptimalArmor(this.getLevel()) * .4) + (this.getStat(Stats.possibleStats.Constitution) / this.stats.getMaximumStat(this.getLevel()) * 0.1);
        return reduction > 0.5 ? 0.5 : 1 - reduction;
    }

    getMagicalDefense() {
        let reduction = (this.getStat(Stats.possibleStats.Armor) / this.stats.getOptimalArmor(this.getLevel()) * .15) + (this.getStat(Stats.possibleStats.Wisdom) / this.stats.getMaximumStat(this.getLevel()) * 0.35);
        return reduction > 0.5 ? 0.5 : 1 - reduction;
    }

    getPhysicalCriticalRate() {
        let critique = (this.getStat(Stats.possibleStats.Dexterity) / this.stats.getMaximumStat(this.getLevel()) * .40) + (this.getStat(Stats.possibleStats.Luck) / this.stats.getMaximumStat(this.getLevel()) * 0.35);
        return critique > .75 ? .75 : critique;
    }

    getMagicalCriticalRate() {
        let critique = (this.getStat(Stats.possibleStats.Intellect) / this.stats.getMaximumStat(this.getLevel()) * .40) + (this.getStat(Stats.possibleStats.Luck) / this.stats.getMaximumStat(this.getLevel()) * 0.35);
        return critique > .75 ? .75 : critique;
    }

    getRawCriticalRate() {
        return (this.getPhysicalCriticalRate() + this.getMagicalCriticalRate()) / 2;
    }

    getPhysicalCriticalEvasionRate() {
        let critique = (this.getStat(Stats.possibleStats.Will) / this.stats.getMaximumStat(this.getLevel()) * .45) + (this.getStat(Stats.possibleStats.Perception) / this.stats.getMaximumStat(this.getLevel()) * 0.15);
        return critique > .75 ? .75 : critique;
    }

    getMagicalCriticalEvasionRate() {
        let critique = (this.getStat(Stats.possibleStats.Charisma) / this.stats.getMaximumStat(this.getLevel()) * .45) + (this.getStat(Stats.possibleStats.Perception) / this.stats.getMaximumStat(this.getLevel()) * 0.15);
        return critique > .75 ? .75 : critique;
    }

    getRawCriticalEvasionRate() {
        return (this.getPhysicalCriticalEvasionRate() + this.getMagicalCriticalEvasionRate()) / 2;
    }

    /**
     * BALANCING
     * @param {WorldEntity} target
     */
    getLuckEffectRate(target) {
        return Math.max(1.0 + (this.getStat(Stats.possibleStats.Luck) - target.getStat(Stats.possibleStats.Luck)) * 0.001, 0.0);
    }

    // TODO: Make this dream come true
    getRegenHp() {
        return 0;
    }

    getRegenMp() {
        return 0;
    }

    getRegenEnergy() {
        return 0;
    }

    /**
     * @returns {Array<Trait>}
     **/
    getAllTraits() {
        return this.getStatesArray().reduce((r, obj) => {
            return r.concat(obj.traits);
        }, []);
    };

    getTraits(idType) {
        return this.getAllTraits().filter((trait) => {
            return trait.idTraitType === idType;
        });
    };

    /*
     * FIND BY Type And Value Type
     */

    /**
    *
    * @callback conditionCallback
    * @param {Trait} trait
    * @returns {boolean}
    */

    /**
     * 
     * @param {number} idType
     * @param {conditionCallback} condition
     */
    filterByCondition(idType, condition) {
        return this.getAllTraits().filter((trait) => {
            return trait.idTraitType === idType && condition(trait);
        });
    }

    /**
     * 
     * @param {number} idType
     * @param {number} idElementType
     */
    getTraitsWithElementType(idType, idElementType) {
        return this.filterByCondition(idType, (trait) => trait.valueElementType === idElementType);
    };

    /**
     * 
     * @param {number} idType
     * @param {number} idStateType
     */
    getTraitsWithStateType(idType, idStateType) {
        return this.filterByCondition(idType, (trait) => trait.valueState === idStateType);
    };


    /**
     * 
     * @param {number} idType
     * @param {number} idStat
     */
    getTraitsWithIdStat(idType, idStat) {
        return this.filterByCondition(idType, (trait) => trait.valueStat === idStat);
    };

    /**
     * 
     * @param {number} idType
     * @param {number} idSkill
     */
    getTraitsWithIdSkill(idType, idSkill) {
        return this.filterByCondition(idType, (trait) => trait.valueSkill === idSkill);
    };

    /**
     * 
     * @param {number} idType
     * @param {number} idSkillType
     */
    getTraitsWithSkillType(idType, idSkillType) {
        return this.filterByCondition(idType, (trait) => trait.valueSkillType === idSkillType);
    };

    getTraitsWithCode(idType, value) {
        switch (idType) {
            case Trait.TraitTypesNames.ElementAttack:
            case Trait.TraitTypesNames.ElementRate:
                return this.getTraitsWithElementType(idType, value);
            case Trait.TraitTypesNames.StatusCertain:
            case Trait.TraitTypesNames.StatusDebuff:
            case Trait.TraitTypesNames.StatusResist:
                return this.getTraitsWithStateType(idType, value);
            case Trait.TraitTypesNames.StatsParam:
            case Trait.TraitTypesNames.StatsDebuff:
                return this.getTraitsWithIdStat(idType, value);
            case Trait.TraitTypesNames.QuietSkills:
                return this.getTraitsWithSkillType(idType, value);
            case Trait.TraitTypesNames.QuietSpecificSkill:
                return this.getTraitsWithIdSkill(idType, value);
            case Trait.TraitTypesNames.SecondaryStatsDebuff:
                // TODO
                return [];
        }

        return [];
    }


    getTraitsValueMult(idType, value) {
        return this.getTraitsWithCode(idType, value).reduce((r, trait) => {
            return r * trait.getNumericValue();
        }, 1);
    };

    getTraitValueSum(idType, value, defaultValue = 0) {
        return this.getTraitsWithCode(idType, value).reduce((r, trait) => {
            return r + trait.getNumericValue();
        }, defaultValue);
    };

    getTraitValueSumAll(idType) {
        return this.getTraits(idType).reduce((r, trait) => {
            return r + trait.getNumericValue();
        }, 0);
    };

    /**
     * 
     * @param {number} idType
     * @param {number} value
     * @returns {Array}
     */
    getTraitValueSet(idType, value) {
        return this.getTraitsWithCode(idType, value).reduce(function (r, trait) {
            return r.concat(trait.getSingleValue());
        }, []);
    };

    getStateRate(idState) {
        return this.getTraitsValueMult(Trait.TraitTypesNames.StatusDebuff, idState);
    }

    getStatRate(idStat) {
        return this.getTraitsValueMult(Trait.TraitTypesNames.StatsDebuff, idStat);
    }

    /**
     * 
     * @param {number} idState
     * @returns {Array<number>} IDs of resisted states
     */
    getStateResists(idState) {
        return this.getTraitValueSet(Trait.TraitTypesNames.StatusResist, idState);
    }


}

module.exports = WorldEntity;

const Globals = require("../Globals");
