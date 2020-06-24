const WorldEntity = require("../Entities/WorldEntity");
const Globals = require("../Globals");
const Utils = require("../Utilities/Utils");
const Skill = require("../SkillsAndStatus/Skill");
const RoundLogger = require("./RoundLogger");
const EntityAffectedLogger = require("./EntityAffectedLogger");

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
                let indexOfStun = this.entitiesStunned.indexOf(this.concatEntities[this.initiativeIndex]);
                let isStunned = this.concatEntities[this.initiativeIndex].isAffectedByState(1);
                if (!isStunned) {
                    this.initiative = [parseInt(i), indexOf];
                    return true;
                } else {
                    //this.entitiesStunned.splice(indexOfStun, 1);
                    this.initiativeUpdate();
                }
            }
        }
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

    // TODO: Add or Update to use skills and states
    log(attacker, defender, critical, stun, damage, indexEntities) {
        this.summary.rounds.push({
            roundType: attacker._type,
            roundEntitiesIndex: indexEntities,
            attackerName: attacker.getName(this.lang),
            defenderName: defender.getName(this.lang),
            attackerId: attacker.id,
            defenderId: defender.id,
            critical: critical,
            stun: stun,
            damage: damage,
            attackerMaxHP: attacker.maxHP,
            attackerHP: attacker.actualHP,
            defenderMaxHP: defender.maxHP,
            defenderHP: defender.actualHP,
            attackerLevel: attacker.getLevel(),
            defenderLevel: defender.getLevel()
        });
        if (attacker._type == "Monster" || defender._type == "Monster") {
            this.summary.rounds[this.summary.rounds.length - 1].monsterType = indexEntities == 1 ? attacker.type : defender.type;
            this.summary.rounds[this.summary.rounds.length - 1].monsterDifficultyName = indexEntities == 1 ? attacker.difficulty.name : defender.difficulty.name;
        }
    }



    async update() {
        let damage = 0;
        let done = 0;
        let critical = false;
        let stun = false;

        let attacker = this.entities[this.initiative[0]][this.initiative[1]];

        let roundLog = this.initNewRoundLog(attacker);

        // Clean Status after number of rounds
        let removedStatesAfterRounds = attacker.removeStatesByRounds();

        // Log removed status
        roundLog.attacker.battle.removedStates = removedStatesAfterRounds;

        // TODO: Apply status effects

        // Add skills prep
        attacker.prepareCast();

        // ==> take into account mp and energy cost
        // TODO: Add default skill (auto attack)
        let autoAttack = new Skill();
        await autoAttack.loadWithID(1);

        let skillToUse = attacker.getSkillToUse() || autoAttack;

        skillToUse.resetCast();
        roundLog.idSkillUsed = skillToUse.id;

        let targets = [];

        let numberOfTarget = skillToUse.getNumberOfTarget();
        if (skillToUse.isTargetingAliveAllies()) {
            targets = this.getAliveAttackers(numberOfTarget);
        } else if (skillToUse.isTargetingAliveEnemies()) {
            targets = this.getAliveDefenders(numberOfTarget);
        } else if (skillToUse.isTargetingDeadAllies()) {
            targets = this.getAllDeadAttackers();
        } else if (skillToUse.isTargetingSelf()) {
            targets.push(attacker);
        }

        let skillCosts = attacker.removeSkillCost(skillToUse);
        // TODO: Log costs ? Or log skill used then calculate cost ?
        roundLog.attacker.logDamageEnergy(skillCosts.energy);
        roundLog.attacker.logDamageMp(skillCosts.mp);


        for (let target of targets) {

            let defenderLogger = this.initNewEntityLogger(target);

            roundLog.defenders.push(defenderLogger);

            // Hp
            if (skillToUse.isAffectingHp()) {
                this.applySkillHpDamage(skillToUse, attacker, target);
            }

            // Mp
            if (skillToUse.isAffectingMp()) {
                this.applySKillMpDamage(skillToUse, attacker, target);
            }

            // TODO: Energy Part *

            // TODO: Effects apply
            skillToUse.effects.forEach(async (effect) => {
                await effect.applyToOne({ entity: target, logger: defenderLogger, attacker: attacker}, skillToUse);
            });

            // Update total entity
            this.updateEntityLogger(defenderLogger, target);

            // Remove from original array since it's dead
            // Should be changed so we can resurrect people
            if (!target.isAlive()) {
                this.concatEntities.splice(this.concatEntities.indexOf(target), 1);
            }
        }

        // Update attacker
        this.updateEntityLogger(this.getCurrentRoundCurrentAttackerLogger(), attacker);

        /*
                    let defender = this.getAliveDefenders(1)[0];
        
                    // Celui qui attaque
                    damage = attacker.damageCalcul();
                    damage = damage * defender.damageDefenceReduction();
        
                    // Critical hit and stun
                    critical = attacker.isThisACriticalHit();
                    if (attacker.consecutiveStuns < Globals.maxConsecutiveStuns) {
                        stun = attacker.stun(defender.getStat("will"));
                    }
        
                    // Crit + stun does 50% more dmg, crit does double, else default
                    if (critical && stun) {
                        damage *= 1.5;
                    } else if (critical) {
                        damage *= 2;
                    }
                    damage = Math.round(damage);
        
                    defender.actualHP -= damage;
                    damage = defender.actualHP < 0 ? damage + defender.actualHP : damage;
                    defender.actualHP = defender.actualHP < 0 ? 0 : defender.actualHP;
        
                    this.log(attacker, defender, critical, stun, damage, this.initiative[0]);
        
                    if (stun && this.entitiesStunned.indexOf(defender) == -1) {
                        this.entitiesStunned.push(defender);
                        attacker.consecutiveStuns += 1;
                    } else {
                        attacker.consecutiveStuns = 0;
                    }
        
                    if (defender.actualHP <= 0) {
                        this.concatEntities.splice(this.concatEntities.indexOf(defender), 1);
                    }
        
                */

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
     * Create a new logger for a new round
     * It adds it to this.summary.rounds
     * @param {WorldEntity} attacker
     */
    initNewRoundLog(attacker) {
        let roundLog = new RoundLogger();
        roundLog.roundType = attacker._type;
        roundLog.roundEntitiesIndex = this.initiative[0];
        roundLog.attacker.entity.name = attacker.getName(this.lang);
        roundLog.attacker.entity.level = attacker.getLevel();


        // Max
        roundLog.attacker.entity.maxEnergy = attacker.maxEnergy;
        roundLog.attacker.entity.maxHP = attacker.maxHP;
        roundLog.attacker.entity.maxMP = attacker.maxMP;


        this.summary.rounds.push(roundLog);

        return roundLog;
    }

    /**
     * 
     * @param {WorldEntity} entity
     */
    initNewEntityLogger(entity) {
        let entityLog = new EntityAffectedLogger();

        // Current
        this.updateEntityLogger(entityLog, entity);

        // Max
        entityLog.entity.maxEnergy = entity.maxEnergy;
        entityLog.entity.maxHP = entity.maxHP;
        entityLog.entity.maxMP = entity.maxMP;

        // General
        entityLog.entity.name = entity.getName(this.lang);
        entityLog.entity.level = entity.getLevel();

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

        console.log(evaluation);

        let defenderLogger = this.getCurrentRoundCurrentDefenderLogger();
        defenderLogger.battle.isCritical = evaluation.isCritical;

        if (skill.isRecover()) {
            let recoverDone = this.applyRecoveryHp(target, evaluation.value);

            // Log recovery
            defenderLogger.logRecoverHp(recoverDone);
        } else {
            let damageDone = this.applyDamage(target, evaluation.value);

            // Log damage
            defenderLogger.logDamageHp(damageDone);

            if (skill.isDrain()) {
                caster.actualHP += damageDone;

                // Log Drain
                this.getCurrentRoundCurrentAttackerLogger().logRecoverHp(damageDone);
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
            defenderLogger.logRecoverMp(recoverDone);
        } else {
            let damageDone = this.applyMpDamage(target, evaluation.value);

            // Log damage
            defenderLogger.logDamageMp(damageDone);

            if (skill.isDrain()) {
                caster.actualMP += damageDone;

                // Log Drain
                this.getCurrentRoundCurrentAttackerLogger().logRecoverMp(damageDone);
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
            criticalChanceAttacker = attacker.getPhysicalCriticalRate();
            criticalChanceEvadeDefender = defender.getPhysicalCriticalEvasionRate();
        } else if (skill.isMagical()) {
            criticalChanceAttacker = attacker.getMagicalCriticalRate();
            criticalChanceEvadeDefender = defender.getMagicalCriticalEvasionRate();
        } else {
            criticalChanceAttacker = attacker.getRawCriticalRate();
            criticalChanceEvadeDefender = defender.getRawCriticalEvasionRate();
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
     * 
     * @param {number} numberToFetch Number of entities to fetch >= 1
     * @returns {Array<WorldEntity>}
     */
    getAliveDefenders(numberToFetch = 1) {
        return Utils.getRandomItemsInArray(this.getAllAliveDefenders(), numberToFetch);
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


}

module.exports = Fight

const Monster = require("../Entities/Monster");

