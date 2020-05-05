const Fight = require("./Fight");
const Globals = require("../Globals");
const LootSystem = require("../LootSystem");
const Guild = require("../Guild");
const PStatistics = require("../Achievement/PStatistics");


class FightPvE extends Fight {

    /**
     * @param {Array<Character>} entities1
     * @param {Array<Monstre>} entities2 
     * @param {string} lang
     */
    constructor(entities1, entities2, lang) {
        super(entities1, entities2, lang);
        this.summary.type = "pve";
    }


    getRawMoneyOfAllEnemies() {
        let money = 0;
        for (let i in this.entities[1]) {
            money += this.entities[1][i].money * this.entities[1][i].difficulty.value;
        }
        return money;
    }

    getRawXpOfAllEnemies() {
        let xp = 0;
        for (let i in this.entities[1]) {
            xp += this.entities[1][i].xp * this.entities[1][i].difficulty.value;
        }
        return xp;
    }

    // 0 joueurs 1 enemies
    getAvgLevelTeam(idTeam) {
        let avg = 0;
        for (let i in this.entities[idTeam]) {
            avg += this.entities[idTeam][i].getLevel();
        }
        return Math.round(avg / this.entities[idTeam].length);
    }

    getAvgLuckBonus() {
        let avg = 0;
        for (let i in this.entities[1]) {
            avg += this.entities[1][i].luckBonus;
        }
        return Math.round(avg / this.entities[1].length);
    }

    async endFight() {
        if (this.winnerGroup == 0) {
            // Need this to know if level up
            let totalXp = 0;
            let totalMoney = 0;
            let rawMoney = this.getRawMoneyOfAllEnemies();
            let rawXp = this.getRawXpOfAllEnemies();
            let avgLevelEnemies = this.getAvgLevelTeam(1);
            /**
             * @type {Area}
             */
            let area = this.entities[0][0].getArea();
            let areaBonuses = await area.getAllBonuses();
            let promises = [];
            for (let i in this.entities[0]) {
                /**
                 * @type {Character}
                 */
                let entity = this.entities[0][i];

                if (area.areaType != "dungeon") {
                    // [Health]
                    entity.resetFullHp();
                }

                entity.waitForNextFight(this.summary.rounds.length * 2500);

                // Stat for statistics system 
                PStatistics.incrStat(entity.id, "pvefights_victories", 1);

                let actualLevel = entity.getLevel();



                // Add exp and money
                let xp = 0;
                let diffLevelEnemy = this.calMultDiffLevel(avgLevelEnemies, actualLevel);

                let money = (rawMoney / this.entities[0].length) * (diffLevelEnemy > 1 ? 1 : diffLevelEnemy);
                money = Math.round(money * (areaBonuses["gold_drop"].getPercentageValue() + 1));
                this.summary.goldGained[entity.name] = money;
                totalMoney += money;

                promises.push(entity.addMoney(money));
                PStatistics.incrStat(entity.id, "gold_dropped", money);


                if (actualLevel < Globals.maxLevel) {
                    diffLevelEnemy = actualLevel - avgLevelEnemies >= -5 ? (diffLevelEnemy > 1.2 ? 1.2 : diffLevelEnemy) : 0.05;
                    xp = (rawXp / this.entities[0].length) * diffLevelEnemy;
                    xp = Math.round(xp * (entity.getStat("wisdom") / 1000 + areaBonuses["xp_fight"].getPercentageValue() + 1));
                    totalXp += xp;
                    this.summary.xpGained[entity.name] = xp;
                    promises.push(entity.addExp(xp));
                } else {
                    this.summary.xpGained[entity.name] = 0;
                }



                //if level up


                let diffLevel = entity.getLevel() - actualLevel;
                if (diffLevel > 0) {
                    // Add to sumary
                    this.summary.levelUpped.push({
                        name: entity.name,
                        levelGained: diffLevel,
                        newLevel: entity.getLevel(),
                    });
                }
                // Loot or Not
                let lootSystem = new LootSystem();
                let totalLuck = entity.getStat("luck") + this.getAvgLuckBonus();
                totalLuck = totalLuck * (1 + areaBonuses["item_drop"].getPercentageValue());

                promises.push((async () => {
                    let loot = await lootSystem.loot(entity, totalLuck, avgLevelEnemies);
                    if (Object.keys(loot).length !== 0 && loot.constructor === Object) {
                        this.summary.drops.push({
                            name: entity.name,
                            drop: loot,
                        });
                    }
                })());

                for (let monster of this.entities[1]) {
                    PStatistics.incrStat(entity.id, monster.type + "_defeated", 1);
                }
            }
            this.summary.xp = totalXp;
            this.summary.money = Math.round(totalMoney * 0.95);

            // Don't need to await this
            (async () => {
                let ownerid = await this.entities[0][0].getArea().getOwnerID();
                if (ownerid != null) {
                    await Guild.addMoney(ownerid, Math.round(totalMoney * 0.05));
                }
            })();

            await Promise.all(promises);
        } else {
            /**
             * @type {Character}
             */
            let entity;
            for (entity of this.entities[0]) {
                // 2.5 Seconds per round * 1000 => ms
                entity.waitForNextFight(this.summary.rounds.length * 2500);
                PStatistics.incrStat(entity.id, "pvefights_defeats", 1);
            }
        }

        this.PStatsDamageDandT();


    }

    async PStatsDamageDandT() {
        for (let round of this.summary.rounds) {
            // 0 = player who attack
            if (round.roundEntitiesIndex == 0) {
                PStatistics.incrStat(round.attackerId, "damage_done", round.damage);
            } else {
                PStatistics.incrStat(round.defenderId, "damage_taken", round.damage);
            }
        }
    }

}

module.exports = FightPvE;

const Character = require("../Character");
const Monstre = require("../Entities/Monster");
const Area = require("../Areas/Area");