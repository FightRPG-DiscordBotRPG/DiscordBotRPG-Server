const WorldEntity = require("../Entities/WorldEntity");
const Globals = require("../Globals");
const Utils = require("../Utilities/Utils");
const Skill = require("../SkillsAndStatus/Skill");

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
        this.initiatives = entities1.concat(entities2);
        this.initiativeIndex = -1;

        this.entitiesStunned = [];
        //this.initiatives[entities1.length + entities2.length - 1] = undefined;
        this.winnerGroup = 0;

        this.summary = {
            type: "generic",
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

        if (this.initiativeIndex >= this.initiatives.length) {
            this.initiativeIndex = 0;
        }


        for (let i in this.entities) {
            let indexOf = this.entities[i].indexOf(this.initiatives[this.initiativeIndex]);
            if (indexOf > -1) {
                let indexOfStun = this.entitiesStunned.indexOf(this.initiatives[this.initiativeIndex]);
                if (indexOfStun == -1) {
                    this.initiative = [i, indexOf];
                    return true;
                } else {
                    this.entitiesStunned.splice(indexOfStun, 1);
                    this.initiativeUpdate();
                }
            }
        }
        return false;
    }

    async init(resetStats = true) {
        //attacker.character.stats.intellect + attacker.character.equipement.stats.intellect) <= (defender.character.stats.intellect + defender.character.equipement.stats.intellect
        this.initiatives.sort((a, b) => {
            return b.getStat("intellect") - a.getStat("intellect");
        });

        for (let i in this.initiatives) {
            this.initiatives[i].updateStats();
            await this.initiatives[i].loadSkills();
            if (resetStats || this.initiatives[i].constructor === Monster) {
                this.initiatives[i].resetFullHp();
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
        let defender = this.getAliveDefenders(1)[0];


        // Clean Status after number of rounds
        let removedStatesAfterRounds = attacker.removeStatesByRounds();
        // TODO: Log removed status
        // TODO: Apply status effects

        // Add skills prep
        attacker.prepareCast();

        // ==> take into account mp and energy cost
        let skillToUse = attacker.getSkillToUse();

        if (skillToUse) {
            skillToUse.resetCast();
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

            attacker.removeSkillCost(skill);
            // TODO: Log costs ? Or log skill used then calculate cost ?

            for (let target of targets) {

                // Hp part
                this.applySkillDamage(skillToUse, attacker, target);

                // TODO: Mp Part

                // TODO: Energy Part

                // TODO: Status Part
            }



        } else {
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
                this.initiatives.splice(this.initiatives.indexOf(defender), 1);
            }

        }

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
     * @param {Skill} skill
     * @param {WorldEntity} attacker
     * @param {WorldEntity} defender
     */
    applySkillDamage(skill, attacker, defender) {
        if (skill.isInflictingDamageHp()) {
            let val = skill.evaluateWithTarget(attacker, target);

            if (this.isCritical(skill, attacker, defender)) {
                // Log critical
                val *= 2;
            }
            
            this.applyDamage(defender, val);
            // TODO: Log damage
        }
    }

    /**
     * Returns the real damage done (if more than hp left)
     * @param {WorldEntity} target
     */
    applyDamage(target, damage) {
        damage = Math.round(damage);
        target.actualHP -= damage;
        damage = target.actualHP < 0 ? damage + target.actualHP : damage;
        target.actualHP = target.actualHP < 0 ? 0 : target.actualHP;
        return damage;
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
        return this.getAliveEntities(this.getAllAliveAttackers);
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

