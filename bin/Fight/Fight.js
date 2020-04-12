const WorldEntity = require("../Entities/WorldEntity");
const Globals = require("../Globals");

class Fight {
    /**
     * Classe de gestion d'un combat
     * On suppose que le groupe num�ro 1 attaque forc�ment le groupe num�ro 2
     * Ont doit absolument s'assurer que les param�tres soient bien des listes
     * de worldEntities
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

    async init(resetStats=true) {
        //attacker.character.stats.intellect + attacker.character.equipement.stats.intellect) <= (defender.character.stats.intellect + defender.character.equipement.stats.intellect
        for (let i in this.initiatives) {
            this.initiatives.sort((a, b) => {
                return b.getStat("intellect") - a.getStat("intellect");
            });
            this.initiatives[i].updateStats();

            if (resetStats || this.initiatives[i].constructor === Monster) {
                this.initiatives[i].resetFullHp();
            }
        }

        this.initiativeUpdate();
        await this.update();
    }


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
        let defender = this.getDefender(this.entities[this.initiative[0] == 0 ? 1 : 0]);

        // Celui qui attaque
        damage = attacker.damageCalcul();
        damage = damage * defender.damageDefenceReduction();
        let redFlat = this.calMultDiffLevel(attacker.getLevel(), defender.getLevel());
        damage = damage * (redFlat <= 0.2 ? 0.2 : redFlat);

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
            if (this.entities[teamIndex][i].actualHP > 0) {
                return true;
            }
        }
        return false;
    }



    getDefender(arrOfEntities) {
        let possibles = [];
        for (let i in arrOfEntities) {
            if (arrOfEntities[i].actualHP > 0) {
                possibles.push(i);
            }
        }
        return arrOfEntities[possibles[Math.floor(Math.random() * possibles.length)]];
    }


    calMultDiffLevel(lv1, lv2) {
        let diff = lv1 - lv2;
        let mult = 1;
        // Lv 1 est plus faible que 2
        if (diff < 0) {
            mult = mult - 0.10 * -diff;
            return mult < 0 ? 0 : mult;
        } else if (diff > 0) {
            mult = mult + 0.10 * diff;
            return mult < 0 ? 0 : mult;
        }
        return 1;
    }


}

module.exports = Fight

const Monster = require("../Entities/Monster");

