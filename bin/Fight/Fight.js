const WorldEntity = require("../Entities/WorldEntity");
const Globals = require("../Globals");
const Utils = require("../Utilities/Utils");
const Skill = require("../SkillsAndStatus/Skill");
const RoundLogger = require("./Logger/RoundLogger");
const EntityAffectedLogger = require("./Logger/EntityAffectedLogger");

class Fight {
    /**
     * Classe de gestion d'un combat
     * On suppose que le groupe num�ro 1 attaque forc�ment le groupe num�ro 2
     * Ont doit absolument s'assurer que les param�tres soient bien des listes
     * de worldEntities
     */

    /**
     * 
     * @param {Array<WorldEntity>} entities1
     * @param {Array<WorldEntity>} entities2
     * @param {string} lang
     */
    constructor(entities1, entities2, lang = "en") {
        /**
         * @type {Array<WorldEntity>}
         */
        this.lang = lang;
        this.entities = [
            entities1,
            entities2
        ];

        this.initiative = [0, 0];
        /**
         * @type {Array<WorldEntity>}
         **/
        this.concatEntities = entities1.concat(entities2);
        this.initiativeIndex = -1;

        this.entitiesStunned = [];
        //this.initiatives[entities1.length + entities2.length - 1] = undefined;
        this.winnerGroup = 0;

        this.summary = {
            type: "generic",
            /**
             * @type {Array<RoundLogger>}
             */
            rounds: [],
            drops: [],
            xp: 0,
            money: 0,
            honor: 0,
            levelUpped: [],
            xpGained: {},
            goldGained: {},
            usersIds: [],
            winner: 0
        };

        this.loadUsersIds();
    }

    loadUsersIds() {
        for (let entity of this.entities[0]) {
            if (entity.getIdUser() != null) {
                let entityOwnerID = entity.getIdUser();
                if (Globals.connectedUsers[entityOwnerID] != null && !Globals.connectedUsers[entityOwnerID].isFightMuted()) {
                    this.summary.usersIds.push(entity.getIdUser());
                }
            }
        }
    }

    initiativeUpdate() {
        this.initiativeIndex++;

        if (this.initiativeIndex >= this.concatEntities.length) {
            this.initiativeIndex = 0;
        }

        for (let i in this.entities) {
            let indexOf = this.entities[i].indexOf(this.concatEntities[this.initiativeIndex]);
            if (indexOf > -1) {
                // Even if stunned the turn must be calculated
                this.initiative = [parseInt(i), indexOf];
                return true;
            }
        }

        //for (let i in this.entities) {
        //    let indexOf = this.entities[i].indexOf(this.concatEntities[this.initiativeIndex]);
        //    if (indexOf > -1) {
        //        let isStunned = this.concatEntities[this.initiativeIndex].isRestricted(1);
        //        if (!isStunned) {
        //            this.initiative = [parseInt(i), indexOf];
        //            return true;
        //        } else {
        //            //this.entitiesStunned.splice(indexOfStun, 1);
        //            this.initiativeUpdate();
        //        }
        //    }
        //}
        return false;
    }

    async init(resetStats = true) {
        //attacker.character.stats.intellect + attacker.character.equipement.stats.intellect) <= (defender.character.stats.intellect + defender.character.equipement.stats.intellect
        this.concatEntities.sort((a, b) => {
            return b.getStat("intellect") - a.getStat("intellect");
        });

        for (let i in this.concatEntities) {
            this.concatEntities[i].updateStats();
            await this.concatEntities[i].loadSkills();
            if (resetStats || this.concatEntities[i].constructor === Monster) {
                this.concatEntities[i].resetFullHp();
            }
        }

        this.initiativeUpdate();
        await this.update();
    }



    async update() {
        let done = 0;

        let attacker = this.concatEntities[this.initiativeIndex];

        let roundLog = this.initNewRoundLog(attacker);

        // Clean Status after number of rounds
        let removedStatesAfterRounds = attacker.removeStatesByRounds();

        // Log removed status
        roundLog.attacker.battle.removedStates = removedStatesAfterRounds;

        // Reset stat get modifier
        attacker.resetStatsModifiers();

        // Reload Max HP/MP/Energy (due to states effects)
        attacker.updateMaxStats();

        // Apply status effects on MP/HP/Energy
        roundLog.attacker.logRecovers(attacker.regenerateAll());

        // Default skill based on what restriction the character have
        let attackerRestrictions = attacker.getRestrictions();

        // Log Restrictions
        roundLog.restrictions = attackerRestrictions;

        // Add skills prep
        attacker.prepareCast();

        let skillToUse = attacker.getSkillToUse() || await this.getDefaultSkill(attackerRestrictions);

        if (skillToUse !== null && (attackerRestrictions.targetAlly || attackerRestrictions.targetEnemy || attackerRestrictions.targetSelf)) {

            let alreadyCheckedIds = {};
            // check if can target with skill
            let targets = this.getSkillTargets(skillToUse, attacker);

            while (targets.length === 0) {
                if (!alreadyCheckedIds[skillToUse.id]) {
                    alreadyCheckedIds[skillToUse.id] = true;
                }

                skillToUse = attacker.getSkillToUse();

                if (alreadyCheckedIds[skillToUse.id]) {
                    skillToUse = await this.getDefaultSkill(attackerRestrictions);
                }

                targets = this.getSkillTargets(skillToUse, attacker);
            }

            skillToUse.resetCast();
            roundLog.skillInfo.id = skillToUse.id;
            roundLog.skillInfo.message = skillToUse.getMessage(attacker.getName(), this.lang);




            let skillCosts = attacker.removeSkillCost(skillToUse);
            roundLog.attacker.logSkillDamageEnergy(skillCosts.energy);
            roundLog.attacker.logSkillDamageMp(skillCosts.mp);

            roundLog.attacker.logSkillRecoverEnergy(skillToUse.energyGain);

            for (let target of targets) {

                let wasAlive = target.isAlive();

                let defenderLogger = this.initNewEntityLogger(target);

                roundLog.defenders.push(defenderLogger);

                // States stats modifiers reset
                target.resetStatsModifiers();

                // Apply damage if not evaded by enemy
                if (target === attacker || skillToUse.isRawDamage() || attacker.haveHit(target, skillToUse)) {
                    // Hp
                    if (skillToUse.isAffectingHp()) {
                        this.applySkillHpDamage(skillToUse, attacker, target);
                    }

                    // Mp
                    if (skillToUse.isAffectingMp()) {
                        this.applySkillMpDamage(skillToUse, attacker, target);
                    }

                    // Effects apply
                    for (let effect of skillToUse.effects) {
                        await effect.applyToOne({ entity: target, logger: defenderLogger, attacker: attacker }, skillToUse);
                    }

                    roundLog.success = true;
                } else {
                    // meaning attack is not successful due to evade
                    roundLog.success = false;
                }

                // Update total entity
                this.updateEntityLogger(defenderLogger, target);

                // Remove from original array since it's dead
                if (wasAlive && !target.isAlive()) {
                    this.concatEntities.splice(this.concatEntities.indexOf(target), 1);
                } else if (!wasAlive && target.isAlive()) {
                    // If he is alive and was not at first, then it means that the target is ressurected
                    // Push at the end of entities list
                    this.concatEntities.push(target);
                }
            }
        }



        // Update attacker
        this.updateEntityLogger(this.getCurrentRoundCurrentAttackerLogger(), attacker);

        let isFirstTeamAlive = this.isThisTeamAlive(0);
        let isSecondTeamAlive = this.isThisTeamAlive(1);

        if (isFirstTeamAlive == true && isSecondTeamAlive == true) {
            this.initiativeUpdate();
            await this.update();
        } else if (isFirstTeamAlive == false) {
            this.winnerGroup = 1;
            done = true;
        } else if (isSecondTeamAlive == false) {
            this.winnerGroup = 0;
            done = true;
        }

        if (done) {
            this.summary.winner = this.winnerGroup;
            await this.endFight();
        }



    }

    /**
     * 
     * @param {Skill} skillToUse
     * @param {WorldEntity} attacker
     */
    getSkillTargets(skillToUse, attacker) {
        let numberOfTarget = skillToUse.getNumberOfTarget();
        if (skillToUse.isTargetingAliveAllies()) {
            return this.getAliveAttackers(numberOfTarget);
        } else if (skillToUse.isTargetingAliveEnemies()) {
            return this.getAliveDefenders(numberOfTarget);
        } else if (skillToUse.isTargetingDeadAllies()) {
            return this.getAllDeadAttackers();
        } else if (skillToUse.isTargetingSelf()) {
            return [attacker];
        }
    }

    /**
     * Create a new logger for a new round
     * It adds it to this.summary.rounds
     * @param {WorldEntity} attacker
     */
    initNewRoundLog(attacker) {
        let roundLog = new RoundLogger();
        roundLog.roundType = attacker._type;
        roundLog.roundEntitiesIndex = this.initiative[0];

        roundLog.attacker = this.initNewEntityLogger(attacker);

        this.summary.rounds.push(roundLog);

        return roundLog;
    }

    /**
     * 
     * @param {WorldEntity} entity
     */
    initNewEntityLogger(entity) {
        let entityLog = new EntityAffectedLogger(this.lang);

        // Current
        this.updateEntityLogger(entityLog, entity);

        // Max
        entityLog.entity.maxEnergy = entity.maxEnergy;
        entityLog.entity.maxHP = entity.maxHP;
        entityLog.entity.maxMP = entity.maxMP;

        // General
        entityLog.setEntityIdentity(entity);
        entityLog.entity.level = entity.getLevel();

        // States
        entityLog.entity.states = entity.states;

        return entityLog;

    }

    /**
     * Update hp and energy
     * @param {EntityAffectedLogger} logger
     * @param {WorldEntity} entity
     */
    updateEntityLogger(logger, entity) {
        logger.entity.actualEnergy = entity.actualEnergy;
        logger.entity.actualHP = entity.actualHP;
        logger.entity.actualMP = entity.actualMP;
    }

    /**
     * Get from dictionnary 
     **/
    getCurrentRound() {
        return this.summary.rounds[this.summary.rounds.length - 1];
    }

    /**
     * Should Only be used inside the loop when applying things to targets
     **/
    getCurrentRoundCurrentDefenderLogger() {
        let round = this.getCurrentRound();
        return round.defenders[round.defenders.length - 1];
    }

    /**
    * Should Only be used inside the loop when applying things to targets
    **/
    getCurrentRoundCurrentAttackerLogger() {
        return this.getCurrentRound().attacker;
    }

    /**
     * 
     * @param {Skill} skill
     * @param {WorldEntity} caster
     * @param {WorldEntity} target
     */
    applySkillHpDamage(skill, caster, target) {
        let evaluation = this.getSkillEvaluation(skill, caster, target);

        let defenderLogger = this.getCurrentRoundCurrentDefenderLogger();
        defenderLogger.battle.isCritical = evaluation.isCritical;

        if (skill.isRecover()) {
            let recoverDone = this.applyRecoveryHp(target, evaluation.value);

            // Log recovery
            defenderLogger.logSkillRecoverHp(recoverDone);
        } else {
            let damageDone = this.applyDamage(target, evaluation.value * this.getTimeMultiplier());            
            // Log damage
            defenderLogger.logSkillDamageHp(damageDone);

            if (skill.isDrain()) {
                let drainedDamage = damageDone / this.getTimeMultiplier();
                caster.actualHP += drainedDamage;

                // Log Drain
                this.getCurrentRoundCurrentAttackerLogger().logDrainHp(drainedDamage);
            }
        }

    }

    /**
     * 
     * @param {Skill} skill
     * @param {WorldEntity} caster
     * @param {WorldEntity} target
     */
    applySkillMpDamage(skill, caster, target) {
        let evaluation = this.getSkillEvaluation(skill, caster, target);

        let defenderLogger = this.getCurrentRoundCurrentDefenderLogger();
        defenderLogger.battle.isCritical = evaluation.isCritical;

        if (skill.isRecover()) {
            let recoverDone = this.applyRecoveryMp(target, evaluation.value);

            // Log recovery
            defenderLogger.logSkillRecoverMp(recoverDone);
        } else {
            let damageDone = this.applyMpDamage(target, evaluation.value);

            // Log damage
            defenderLogger.logSkillDamageMp(damageDone);

            if (skill.isDrain()) {
                caster.actualMP += damageDone;

                // Log Drain
                this.getCurrentRoundCurrentAttackerLogger().logDrainMp(damageDone);
            }
        }

    }

    /**
     * 
     * @param {Skill} skill
     * @param {WorldEntity} attacker
     * @param {WorldEntity} defender
     */
    getSkillEvaluation(skill, attacker, defender) {

        let val = skill.evaluateSkill(attacker, defender);
        let isCritical = this.isCritical(skill, attacker, defender);

        if (isCritical) {
            val *= 2;
        }

        return { value: val, isCritical: isCritical };
    }

    /**
     * Returns the real damage done (if more than hp left)
     * @param {WorldEntity} target
     * @param {number} damage
     */
    applyDamage(target, damage) {
        return target.looseHp(damage);
    }

    /**
    * Returns the real damage done (if more than hp left)
    * @param {WorldEntity} target
    * @param {number} toRecover
    */
    applyRecoveryHp(target, toRecover) {
        return target.healHp(toRecover);
    }

    /**
    * Returns the real damage to mp done (if more than mp left)
    * @param {WorldEntity} target
    * @param {number} damage
    */
    applyMpDamage(target, damage) {
        return target.looseMp(damage);
    }

    /**
    * Returns the real damage done (if more than hp left)
    * @param {WorldEntity} target
    * @param {number} toRecover
    */
    applyRecoveryMp(target, toRecover) {
        return target.healMp(toRecover);
    }


    /**
    *
    * @param {Skill} skill
    * @param {WorldEntity} attacker
    * @param {WorldEntity} defender
    */
    isCritical(skill, attacker, defender) {
        let criticalChanceAttacker = 0;
        let criticalChanceEvadeDefender = 0;

        // Based on skill type
        if (skill.isPhysical()) {
            criticalChanceAttacker = attacker.getPhysicalCriticalRate(defender.getLevel());
            criticalChanceEvadeDefender = defender.getPhysicalCriticalEvasionRate(attacker.getLevel());
        } else if (skill.isMagical()) {
            criticalChanceAttacker = attacker.getMagicalCriticalRate(defender.getLevel());
            criticalChanceEvadeDefender = defender.getMagicalCriticalEvasionRate(attacker.getLevel());
        } else {
            criticalChanceAttacker = attacker.getRawCriticalRate(defender.getLevel());
            criticalChanceEvadeDefender = defender.getRawCriticalEvasionRate(attacker.getLevel());
        }

        // No evade if it's recover
        if (skill.isRecover()) {
            criticalChanceEvadeDefender = 0;
        }

        let criticalChance = criticalChanceAttacker - criticalChanceEvadeDefender;

        return Math.random() <= criticalChance;
    }


    async endFight() { };

    getThisTeamLife(teamIndex) {
        let hp = 0;
        for (let i in this.entities[teamIndex]) {
            hp += this.entities[teamIndex][i].actualHP;
        }
        return hp;
    }

    isThisTeamAlive(teamIndex) {
        for (let i in this.entities[teamIndex]) {
            if (this.entities[teamIndex][i].isAlive()) {
                return true;
            }
        }
        return false;
    }

    // Alive

    /**
     * Have an higher chance to return those with highest thread value
     * @param {number} numberToFetch Number of entities to fetch >= 1
     * @returns {Array<WorldEntity>}
     */
    getAliveDefenders(numberToFetch = 1) {
        let defenders = this.getAllAliveDefenders();

        return Utils.getWeightedRandomItemsInArray(
            defenders,
            defenders.map(x => {
                let threat = x.getSecondaryStat(SecondaryStats.possibleStats.Threat);
                return threat > 0 ? threat : 1;
            }),
            numberToFetch
        );

    }

    /**
    *
    * @param {number} numberToFetch Number of entities to fetch >= 1
    * @returns {Array<WorldEntity>}
    */
    getAliveAttackers(numberToFetch = 1) {
        return Utils.getRandomItemsInArray(this.getAllAliveAttackers(), numberToFetch);
    }

    getAllAliveDefenders() {
        return this.getAliveEntities(this.getAllDefenders());
    }

    getAllAliveAttackers() {
        return this.getAliveEntities(this.getAllAttackers());
    }

    // Dead
    /**
    *
    * @param {number} numberToFetch Number of entities to fetch >= 1
    * @returns {Array<WorldEntity>}
    */
    getDeadDefenders(numberToFetch = 1) {
        return Utils.getRandomItemsInArray(this.getAllDeadDefenders(), numberToFetch);
    }

    /**
    *
    * @param {number} numberToFetch Number of entities to fetch >= 1
    * @returns {Array<WorldEntity>}
    */
    getDeadAttackers(numberToFetch = 1) {
        return Utils.getRandomItemsInArray(this.getAllDeadAttackers(), numberToFetch);
    }

    getAllDeadDefenders() {
        return this.getDeadEntities(this.getAllDefenders());
    }

    getAllDeadAttackers() {
        return this.getDeadEntities(this.getAllAttackers());
    }


    // More Global
    getAllDefenders() {
        return this.entities[this.initiative[0] == 0 ? 1 : 0];
    }

    getAllAttackers() {
        return this.entities[this.initiative[0]];
    }

    // 100% more damage each 10 turns
    getTimeMultiplier() {
        return 1 + Math.floor(this.summary.rounds.length / 10);
    }



    /**
     * 
     * @param {Array<WorldEntity>} entities
     */
    getAliveEntities(entities) {
        return entities.filter((entity) => {
            return entity.isAlive();
        });
    }

    /**
    *
    * @param {Array<WorldEntity>} entities
    */
    getDeadEntities(entities) {
        return entities.filter((entity) => {
            return !entity.isAlive();
        });
    }


    calMultDiffLevel(lv1, lv2) {
        let diff = lv1 - lv2;
        let mult = 1;
        // Lv 1 est plus faible que 2
        if (diff < 0) {
            mult = mult - 0.10 * -diff;
        } else if (diff > 0) {
            mult = mult + 0.10 * diff;
        }

        return mult <= 0.25 ? 0.25 : mult
    }

    /**
     * *
     * @param {{targetEnemy: boolean, targetSelf: boolean, targetAlly: boolean}} restrictions
     */
    async getDefaultSkill(restrictions) {
        let defaultSkill = new Skill();
        if (restrictions.targetEnemy === true) {
            // Auto attack
            await defaultSkill.loadWithID(1);
            return defaultSkill;
        } else {
            return null;
        }
    }

}

module.exports = Fight

const Monster = require("../Entities/Monster");
const SecondaryStats = require("../Stats/Secondary/SecondaryStats");
