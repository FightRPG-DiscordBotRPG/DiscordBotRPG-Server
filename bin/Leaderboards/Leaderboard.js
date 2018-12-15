'use strict';

class Leaderboard {

    constructor(id) {
        this.id = id;
    }

    getPlayerLeaderboard() {
        let actualRank = this.getPlayerRank(this.id);
        let maximumRank = this.getMaximumRank();
        let offset = actualRank - 6;

        if (actualRank <= 5) {
            offset = 0;
        }
        if (maximumRank - actualRank < 5) {
            offset -= 5 - (maximumRank - actualRank);
        }

        offset = offset >= 0 ? offset : 0;

        let res = this.dbGetLeaderboard(offset);
        let data = {
            rankings: res,
            offset: offset,
            maximumRank: maximumRank,
        }
        return data;
    }

    getPlayerRank() {
        return 1;
    }

    getMaximumRank() {
        return 1;
    }

    dbGetLeaderboard() {
        return {};
    }



}

module.exports = Leaderboard;