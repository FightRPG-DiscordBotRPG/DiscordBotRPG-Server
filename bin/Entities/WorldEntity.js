const Stats = require("../Stats/Stats");
const Skill = require("../SkillsAndStatus/Skill");
const State = require("../SkillsAndStatus/State");
const Trait = require("../SkillsAndStatus/Trait");
const Effect = require("../SkillsAndStatus/Effect");
const SecondaryStats = require("../Stats/Secondary/SecondaryStats");

class WorldEntity {

    constructor() {
        this.id = 0;
        this.uuid = "";
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
        this.secondaryStats = new SecondaryStats();

        // Adding default values to some secondaryStats
        this.secondaryStats.hitRate = 100;
        this.secondaryStats.regenEnergy = 10;

        this.consecutiveStuns = 0;
        this.consecutiveNonAttacks = 0;

        // Stats modifiers key => statname, value => traits modifier
        // Reseted each round on fight
        // Only used in fight
        this.tempStatsModifiers = {};

        /**
        * @type {Object.<number, State>}
        */
        this.states = {};

        /**
         * @type {SkillBuild}
         */
        this.skillBuild = null;
    }

    async loadSkills() {
        await this.skillBuild.loadSkills();
        this.skillToTestIndex = 0;
    }

    updateStats() {
        this.updateMaxStats();
        this.consecutiveStuns = 0;
        this.consecutiveNonAttacks = 0;
        if (this.actualHP <= (this.maxHP * 0.1)) {
            this.actualHP = Math.ceil(this.maxHP * 0.1);
        }
    }

    updateMaxStats() {
        this.maxHP = 10 + this.getStat(Stats.possibleStats.Constitution) * 10;
        this.maxMP = 2 + this.getStat(Stats.possibleStats.Wisdom) * 2;
        this.maxEnergy = 100;

        // Recap to max hp current hp if >
        if (this.actualHP > this.maxHP) {
            this.actualHP = this.maxHP;
        }

        if (this.actualMP > this.maxMP) {
            this.actualMP = this.maxMP;
        }

        if (this.actualEnergy > this.maxEnergy) {
            this.actualEnergy = this.maxEnergy;
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
        toRecover = this.getRecoverValue(toRecover, this.maxHP, this.actualHP);
        this.actualHP += toRecover;
        return toRecover;
    }

    /**
     * 
     * @param {number} toRecover
     */
    healMp(toRecover) {
        toRecover = this.getRecoverValue(toRecover, this.maxMP, this.actualMP);
        this.actualMP += toRecover;
        return toRecover;
    }

    /**
     * 
     * @param {number} toRecover
     */
    healEnergy(toRecover) {
        toRecover = this.getRecoverValue(toRecover, this.maxEnergy, this.actualEnergy);
        this.actualEnergy += toRecover;
        return toRecover;
    }

    getRecoverValue(toRecover, max, current) {
        if (toRecover >= 0) {
            return Math.round(Math.min(toRecover, max - current))
        } else {
            return Math.round(Math.max(toRecover, -current))
        }
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
        this.actualMP = this.actualMP < 0 ? 0 : this.actualMP;
        return damage;
    }

    damageCalcul() {
        let baseDamage = this.getStat("strength") + 1;
        return Math.ceil(baseDamage * (1.5 + Math.random()));
    }

    getLevel() {
        return this.level;
    }

    getName(_lang = "en") {
        return this.name;
    }

    getIdentity(lang = "en") {
        return {
            name: this.getName(lang),
            type: this._type,
            uuid: this.uuid,
        }
    }

    getStat(statName) {
        this.updateStatModifier(statName);
        return this.stats.getStat(statName) * this.tempStatsModifiers[statName];
    }

    updateStatModifier(statName) {
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
    }

    getSecondaryStat(statName) {
        this.updateSecondaryStatModifier(statName);

        let modToAdd;
        switch (statName) {
            case SecondaryStats.possibleStats.RegenHp:
                modToAdd = this.maxHP * this.tempStatsModifiers[statName];
                break;
            case SecondaryStats.possibleStats.RegenMp:
                modToAdd = this.maxMP * this.tempStatsModifiers[statName];
                break;
            case SecondaryStats.possibleStats.RegenEnergy:
                modToAdd = this.maxEnergy * this.tempStatsModifiers[statName];
                break;
            default:
                modToAdd = this.tempStatsModifiers[statName];
                break;
        }

        return this.secondaryStats.getStat(statName) + modToAdd;

    }

    getElementalResistMultiplier(elementalName) {
        this.updateSecondaryStatModifier(elementalName);
        return this.secondaryStats.getElementalResist(elementalName) + this.tempStatsModifiers[elementalName];
    }

    updateSecondaryStatModifier(statName) {
        if (!this.tempStatsModifiers[statName]) {
            // Calcul with debuff
            
            this.tempStatsModifiers[statName] = this.getTraitValueSum(Trait.TraitTypesNames.SecondaryStatsDebuff, Globals.secondaryStatsIdsByName[statName]);
        }
    }

    resetStatsModifiers() {
        this.tempStatsModifiers = {};
    }

    prepareCast() {
        this.getSkillsArray().forEach((skill) => skill.currentCastPreparation += 1 + this.getCastSkillBonus(skill));

        // To Balance ? Every skill vs only one per one
        //if (this.skillToTestIndex > -1) {
        //    let speed = this.getStat("dexterity") / this.stats.getOptimalCrit(this.getLevel()) * 25;
        //    this.skills[this.skillToTestIndex].currentCastPreparation += speed;
        //}
    }

    /**
     * 
     * @param {Skill} skill
     */
    getCastSkillBonus(skill) {
        return this.getStat(skill.isPhysical() || skill.isRawDamage() ? Stats.possibleStats.Dexterity : Stats.possibleStats.Wisdom) / this.stats.getMaximumStat() * 2
    }

    stun(advWill) {
        let max = this.stats.getOptimalStun(this.getLevel());
        let otherResist = (advWill) / max;
        // Cap to 50%;
        let stun = this.getRawStunChance();
        otherResist = otherResist > .5 ? .5 : otherResist;
        let chanceToStun = stun >= otherResist ? stun : 0;

        return Math.random() <= chanceToStun;
    }

    getRawStunChance() {
        let max = this.stats.getOptimalStun(this.getLevel());
        // Calcul of chance
        let stun = this.getStat("charisma") / max;
        // Cap to 50%;
        return stun > .5 ? .5 : stun;
    }

    /**
     * Return if you have hit the enemy
     * Minimum chance = 20%
     * @param {WorldEntity} enemy
     * @param {Skill} skill
     */
    haveHit(enemy, skill) {
        let chance;

        if (skill.isPhysical()) {
            chance = (this.getSecondaryStat(SecondaryStats.possibleStats.HitRate) - enemy.getSecondaryStat(SecondaryStats.possibleStats.EvadeRate)) / 100;
        } else {
            chance = 1 - enemy.getSecondaryStat(SecondaryStats.possibleStats.MagicalEvadeRate) / 100;
        }

        chance = chance < 0.2 ? 0.2 : chance;
        return Math.random() <= chance;
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
        return Math.floor((1 + (this.getSecondaryStat(SecondaryStats.possibleStats.SkillManaCost) / 100)) * skill.manaCost * (1 + this.getLevel() / 20));
    }

    /**
    *
    * @param {Skill} skill
    */
    getSkillEnergyCost(skill) {
        return Math.floor(1 + (this.getSecondaryStat(SecondaryStats.possibleStats.SkillEnergyCost) / 100)) * skill.energyCost;
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
        let selectedSkill = this.skillBuild.getSelectedSkill();

        this.skillBuild.prepareNextSkill();
        // Updating next spell to use


        if (selectedSkill && selectedSkill.canBeCast() && this.canUseSkill(selectedSkill)) {

            if (!selectedSkill.isDamage()) {
                this.consecutiveNonAttacks++;
                if (this.consecutiveNonAttacks >= 5) {
                    this.consecutiveNonAttacks = 0;
                    return null;
                }
            } else {
                this.consecutiveNonAttacks = 0;
            }

            return selectedSkill;
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
        // DODO: Add states verifications
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
    removeStatesByRounds(lang="en") {
        let removedStates = [];
        this.getStatesArray().forEach((state) => {
            if (state.isExpired()) {
                removedStates.push(state.toApi(lang));
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
        return this.skillBuild.skillsObjects;
    }

    /**
     * Give multiplier to apply based on your level vs enemy level
     * @param {number} enemyLevel
     */
    getDiffLevelModifier(enemyLevel) {
        let mult = 1;
        let diff = this.getLevel() - enemyLevel;

        // me < enemy
        if (diff < 0) {
            mult = mult - 0.05 * -diff;
        } else if (diff > 0) {
            mult = mult + 0.05 * diff;
        }

        // cap 20%
        return mult <= 0.20 ? 0.20 : mult
    }

    /**
     * Return modifer 1 => 100% 0.5 => 50%
     * @param {number} enemyLevel
     */
    getPhysicalDefense(enemyLevel = 1) {
        let reduction = (this.getStat(Stats.possibleStats.Armor) / this.stats.getOptimalArmor(this.getLevel()) * .3) + (this.getStat(Stats.possibleStats.Constitution) / this.stats.getMaximumStat(this.getLevel()) * 0.1);
        reduction *= this.getDiffLevelModifier(enemyLevel);
        return reduction > 0.8 ? 0.8 : 1 - reduction;
    }

    /**
     * Return modifer 1 => 100% 0.5 => 50%
     * @param {number} enemyLevel
     */
    getMagicalDefense(enemyLevel = 1) {
        let reduction = (this.getStat(Stats.possibleStats.Armor) / this.stats.getOptimalArmor(this.getLevel()) * .15) + (this.getStat(Stats.possibleStats.Wisdom) / this.stats.getMaximumStat(this.getLevel()) * 0.35);
        reduction *= this.getDiffLevelModifier(enemyLevel);
        return reduction > 0.8 ? 0.8 : 1 - reduction;
    }

    /**
     * 
     * @param {number} enemyLevel
     */
    getPhysicalCriticalRate(enemyLevel = 1) {
        let critique = (this.getStat(Stats.possibleStats.Dexterity) / this.stats.getMaximumStat(this.getLevel()) * .04) + (this.getStat(Stats.possibleStats.Luck) / this.stats.getMaximumStat(this.getLevel()) * 0.035);
        critique += critique * this.getDiffLevelModifier(enemyLevel) + this.getRawCriticalRate(enemyLevel);
        return critique > .75 ? .75 : critique;
    }

    /**
    *
    * @param {number} enemyLevel
    */
    getMagicalCriticalRate(enemyLevel = 1) {
        let critique = (this.getStat(Stats.possibleStats.Intellect) / this.stats.getMaximumStat(this.getLevel()) * .04) + (this.getStat(Stats.possibleStats.Luck) / this.stats.getMaximumStat(this.getLevel()) * 0.035);
        critique += critique * this.getDiffLevelModifier(enemyLevel) + this.getRawCriticalRate(enemyLevel);
        return critique > .75 ? .75 : critique;
    }

    /**
    *
    * @param {number} enemyLevel
    */
    getRawCriticalRate(enemyLevel = 1) {
        return this.getSecondaryStat(SecondaryStats.possibleStats.CriticalRate) / 100 * this.getDiffLevelModifier(enemyLevel);
    }

    /**
     * 
     * @param {number} enemyLevel
     */
    getPhysicalCriticalEvasionRate(enemyLevel = 1) {
        let critique = (this.getStat(Stats.possibleStats.Will) / this.stats.getMaximumStat(this.getLevel()) * .035) + (this.getStat(Stats.possibleStats.Perception) / this.stats.getMaximumStat(this.getLevel()) * 0.015);
        critique += critique * this.getDiffLevelModifier(enemyLevel) + this.getSecondaryStat(SecondaryStats.possibleStats.CritcalEvadeRate) / 100;
        return critique > .75 ? .75 : critique;
    }

    /**
     * 
     * @param {number} enemyLevel
     */
    getMagicalCriticalEvasionRate(enemyLevel = 1) {
        let critique = (this.getStat(Stats.possibleStats.Charisma) / this.stats.getMaximumStat(this.getLevel()) * .035) + (this.getStat(Stats.possibleStats.Perception) / this.stats.getMaximumStat(this.getLevel()) * .015);
        critique += critique * this.getDiffLevelModifier(enemyLevel) + this.getSecondaryStat(SecondaryStats.possibleStats.CritcalEvadeRate) / 100;
        return critique > .75 ? .75 : critique;
    }

    /**
     * 
     * @param {number} enemyLevel
     */
    getRawCriticalEvasionRate(enemyLevel = 1) {
        return this.getSecondaryStat(SecondaryStats.possibleStats.EvadeRate) / 100 * this.getDiffLevelModifier(enemyLevel);
    }

    /**
     * BALANCING
     * @param {WorldEntity} target
     */
    getLuckEffectRate(target) {
        return Math.max(1.0 + (this.getStat(Stats.possibleStats.Luck) - target.getStat(Stats.possibleStats.Luck)) * 0.001, 0.0);
    }

    getLuckEffectRateRaw() {
        return Math.max(1.0 + this.getStat(Stats.possibleStats.Luck) * 0.001, 0.0);
    }

    getRegenHp() {
        return this.getSecondaryStat(SecondaryStats.possibleStats.RegenHp);
    }

    getRegenMp() {
        return this.getSecondaryStat(SecondaryStats.possibleStats.RegenMp);
    }

    getRegenEnergy() {
        return this.getSecondaryStat(SecondaryStats.possibleStats.RegenEnergy);
    }

    /**
     * @returns {Array<Trait>}
     **/
    getAllTraits() {
        return this.getStatesArray().reduce((r, obj) => {
            return r.concat(obj.traits);
        }, []);
    }

    getTraits(idType) {
        return this.getAllTraits().filter((trait) => {
            return trait.idTraitType === idType;
        });
    }

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
    }

    /**
     * 
     * @param {number} idType
     * @param {number} idStateType
     */
    getTraitsWithStateType(idType, idStateType) {
        return this.filterByCondition(idType, (trait) => trait.valueState === idStateType);
    }


    /**
     * 
     * @param {number} idType
     * @param {number} idStat
     */
    getTraitsWithIdStat(idType, idStat) {
        return this.filterByCondition(idType, (trait) => trait.valueStat === idStat);
    }

    getTraitsWithIdSecondaryStats(idType, idSecondaryStat) {
        return this.filterByCondition(idType, (trait) => trait.valueSecondaryStat === idSecondaryStat);
    }

    /**
     * 
     * @param {number} idType
     * @param {number} idSkill
     */
    getTraitsWithIdSkill(idType, idSkill) {
        return this.filterByCondition(idType, (trait) => trait.valueSkill === idSkill);
    }

    /**
     * 
     * @param {number} idType
     * @param {number} idSkillType
     */
    getTraitsWithSkillType(idType, idSkillType) {
        return this.filterByCondition(idType, (trait) => trait.valueSkillType === idSkillType);
    }

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
                return this.getTraitsWithIdSecondaryStats(idType, value);
        }

        return [];
    }


    getTraitsValueMult(idType, value) {
        return this.getTraitsWithCode(idType, value).reduce((r, trait) => {
            return r * trait.getNumericValue();
        }, 1);
    }

    getTraitValueSum(idType, value, defaultValue = 0) {
        return this.getTraitsWithCode(idType, value).reduce((r, trait) => {
            return r + trait.getNumericValue();
        }, defaultValue);
    }

    getTraitValueSumAll(idType) {
        return this.getTraits(idType).reduce((r, trait) => {
            return r + trait.getNumericValue();
        }, 0);
    }

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
    }

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
const SkillBuild = require("../EntitiesBuilds/SkillBuild");
