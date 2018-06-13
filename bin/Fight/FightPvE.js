const Fight = require("./Fight");
const Globals = require("../Globals");
const LootSystem = require("../LootSystem");
const Translator = require("../Translator/Translator");


class FightPvE extends Fight {

    constructor(entities1, entities2) {
        super(entities1, entities2);
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

    endFight(lang) {
        lang = lang || "fr"
        if (this.winnerGroup == 0) {
            // Need this to know if level up
            let totalXp = 0;
            let totalMoney = 0;
            let rawMoney = this.getRawMoneyOfAllEnemies();
            let rawXp = this.getRawXpOfAllEnemies();
            let avgLevelEnemies = this.getAvgLevelTeam(1);

            for (let i in this.entities[0]) {
                let actualLevel = this.entities[0][i].getLevel();

                // Add exp and money
                let xp = 0;
                let diffLevelEnemy = this.calMultDiffLevel(avgLevelEnemies, actualLevel);

                let money = (rawMoney / this.entities[0].length) * (diffLevelEnemy > 1 ? 1 : diffLevelEnemy);
                money = Math.round(money);
                this.summary.goldGained[this.entities[0][i].name] = money;
                totalMoney += money;

                this.entities[0][i].addMoney(money);

                if (actualLevel < Globals.maxLevel) {
                    xp = (rawXp / this.entities[0].length) * diffLevelEnemy;
                    xp = Math.round(xp * (1 + this.entities[0][i].getStat("wisdom") / 100));
                    totalXp += xp;
                    this.summary.xpGained[this.entities[0][i].name] = xp;
                    this.entities[0][i].addExp(xp);
                } else {
                    this.summary.xpGained[this.entities[0][i].name] = 0;
                }



                //if level up


                let diffLevel = this.entities[0][i].getLevel() - actualLevel;
                if (diffLevel > 0) {
                    /*let plur = diffLevel > 1 ? "x" : "";
                    this.swapArrayIndexes("<:levelup:403456740139728906> Bravo ! Vous avez gagné : " + diffLevel + " niveau" + plur + ". Vous �tes desormais niveau : " + this.fights[userid].user.character.getLevel() + " !\n", userid);*/
                    // Add to sumary
                    this.summary.levelUpped.push({
                        name: this.entities[0][i].name,
                        levelGained: diffLevel,
                        newLevel: this.entities[0][i].getLevel(),
                    });
                }

                // Loot or Not
                let lootSystem = new LootSystem();
                /*console.log(this.entities[0][i].name);
                console.log(this.entities[0][i].getStat("luck") + this.getAvgLuckBonus());*/
                let loot = lootSystem.loot(this.entities[0][i].getStat("luck") + this.getAvgLuckBonus());
                let okLoot = lootSystem.isTheLootExistForThisArea(this.entities[0][i].area, loot);
                if (okLoot) {
                    lootSystem.getLoot(this.entities[0][i], loot, avgLevelEnemies);
                    //add rarity to sumary
                    let rarityName = "";
                    switch (loot) {
                        case 1:
                            rarityName = "common";
                            break;
                        case 2:
                            rarityName = "rare";
                            break;
                        case 3:
                            rarityName = "superior";
                            break;
                        case 4:
                            rarityName = "epic";
                            break;
                        case 5:
                            rarityName = "lengendary";
                            break;
                    }

                    this.summary.drops.push({
                        name: this.entities[0][i].name,
                        drop: rarityName,
                    });
                }

            }

            this.summary.xp = totalXp;
            this.summary.money = totalMoney;


        }

        for (let i in this.entities[0]) {
            // 2.5 Seconds per round * 1000 => ms
            this.entities[0][i].waitForNextFight(this.summary.rounds.length * 2500);
        }

    }

}

module.exports = FightPvE;
