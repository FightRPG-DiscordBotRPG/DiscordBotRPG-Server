const Fight = require("./Fight");

class FightPvP extends Fight {

    getAvgHonorTeam(idTeam) {
        let avg = 0;
        for (let i in this.entities[idTeam]) {
            avg += this.entities[idTeam][i].getHonor();
        }
        return Math.round(avg / this.entities[idTeam].length);
    }

    getTotalHonorTeams() {
        let totals = [0,0];
        for(let i in this.entities) {
            for(let character of this.entities[i]) {
                totals[i] += character.getHonor();
            }
        }
        return totals;
    }

    addHonorToThisTeam(idTeam, honor) {
        honor = Math.round(honor / this.entities[idTeam].length);
        for(let character of this.entities[idTeam]) {
            character.addHonorPoints(honor);
        }
    }

    removeHonorToThisTeam(idTeam, honor) {
        honor = Math.round(honor / this.entities[idTeam].length);
        for(let character of this.entities[idTeam]) {
            character.removeHonorPoints(honor);
        }
    }

    endFight() {
        let teamsHonor = this.getTotalHonorTeams();
        let honor = 0;
        let baseHonor = 10;
        if(this.winnerGroup === 0) {
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

        honor = honor * this.entities[this.winnerGroup].length;

        this.addHonorToThisTeam(this.winnerGroup, honor);
        this.removeHonorToThisTeam(this.winnerGroup === 0 ? 1 : 0, honor);
        this.summary.honor = honor;

        for (let entity of this.entities[0]) {
            entity.waitForNextPvPFight(this.summary.rounds.length * 2500);
        }
    }

}

module.exports = FightPvP;