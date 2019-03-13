'use strict';

class Leaderboard {

    constructor(id) {
        this.id = id;
    }

    async getPlayerLeaderboard() {
        let actualRank = await this.getPlayerRank(this.id);
        let maximumRank = await this.getMaximumRank();
        let offset = actualRank - 6;

        if (actualRank <= 5) {
            offset = 0;
        }
        if (maximumRank - actualRank < 5) {
            offset -= 5 - (maximumRank - actualRank);
        }

        offset = offset >= 0 ? offset : 0;

        let res = await this.dbGetLeaderboard(offset);
        let data = {
            rankings: res,
            offset: offset,
            maximumRank: maximumRank,
            sumOfAll: await this.getSumOfAll(),
        }
        return data;
    }

    async getPlayerRank() {
        return 1;
    }

    async getMaximumRank() {
        return 1;
    }

    async dbGetLeaderboard() {
        return {};
    }

    async getSumOfAll() {
        return 1;
    }



}

module.exports = Leaderboard;