const Fight = require("./Fight");

class FightPvP extends Fight {

    constructor(entities1, entities2, lang) {
        super(entities1, entities2, lang);
        this.summary.type = "pvp";
    }

    async getAvgHonorTeam(idTeam) {
        let avg = 0;
        for (let i in this.entities[idTeam]) {
            avg += await this.entities[idTeam][i].getHonor();
        }
        return Math.round(avg / this.entities[idTeam].length);
    }

    async getTotalHonorTeams() {
        let totals = [0, 0];
        for (let i in this.entities) {
            for (let character of this.entities[i]) {
                totals[i] += await character.getHonor();
            }
        }
        return totals;
    }

    async addHonorToThisTeam(idTeam, honor) {
        honor = Math.round(honor / this.entities[idTeam].length);
        let promises = [];
        for (let character of this.entities[idTeam]) {
            promises.push(character.addHonorPoints(honor));
        }
        await Promise.all(promises);
    }

    async removeHonorToThisTeam(idTeam, honor) {
        honor = Math.round(honor / this.entities[idTeam].length);
        let promises = [];
        for (let character of this.entities[idTeam]) {
            promises.push(character.removeHonorPoints(honor));
        }
        await Promise.all(promises);
    }

    async endFight() {
        let teamsHonor = await this.getTotalHonorTeams();
        let honor = 0;
        let baseHonor = 10;

        // In pvp even if you kill your enemy, he wins
        if (!this.summary.bothLost) {
            if (this.winnerGroup === 0) {
                if (teamsHonor[0] === teamsHonor[1]) {
                    honor = baseHonor;
                } else if (teamsHonor[0] > teamsHonor[1]) {
                    honor = Math.round((teamsHonor[0] - teamsHonor[1]) * .2);
                    honor = baseHonor - honor;
                } else {
                    honor = Math.round((teamsHonor[1] - teamsHonor[0]) * .2);
                    honor += baseHonor;
                }
            } else {
                if (teamsHonor[1] === teamsHonor[0]) {
                    honor = baseHonor;
                } else if (teamsHonor[1] > teamsHonor[0]) {
                    honor = Math.round((teamsHonor[1] - teamsHonor[0]) * .2);
                    honor = baseHonor - honor;
                    honor = honor < 0 ? 0 : honor;
                } else {
                    honor = Math.round((teamsHonor[0] - teamsHonor[1]) * .2);
                    honor += baseHonor;
                }
            }
        } else {
            honor = 0;
        }

       

        honor = honor * this.entities[this.winnerGroup].length;

        await Promise.all([
            this.addHonorToThisTeam(this.winnerGroup, honor),
            this.removeHonorToThisTeam(this.winnerGroup === 0 ? 1 : 0, honor)
        ]);
        this.summary.honor = honor;

        for (let entity of this.entities[0]) {
            entity.waitForNextPvPFight(this.summary.rounds.length * 2500);
        }
    }

}

module.exports = FightPvP;