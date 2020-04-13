'use strict';

class Leaderboard {

    constructor(id) {
        this.id = id;
        this.itemsPerPage = 11;
    }

    async getPlayerLeaderboard(page) {

        let maximumRank = await this.getMaximumRank();
        let maxPage = Math.ceil(maximumRank / this.itemsPerPage);
        let playerRank = await this.getPlayerRank(this.id);
        let offset = 0;

        page = page != null ? Number.parseInt(page) : null;
        if (Number.isInteger(page) && page > 0) {
            page = maxPage > 0 && maxPage < page ? maxPage : page;

            offset = (page - 1) * this.itemsPerPage;
        } else {
            let actualRank = playerRank;

            offset = actualRank - Math.ceil(this.itemsPerPage / 2);

            let halfPerPage = Math.floor(this.itemsPerPage / 2)

            if (actualRank <= halfPerPage) {
                offset = 0;
            }
            if (maximumRank - actualRank < halfPerPage) {
                offset -= halfPerPage - (maximumRank - actualRank);
            }

        }


        offset = offset >= 0 ? offset : 0;

        page = offset % this.itemsPerPage;

        let res = await this.dbGetLeaderboard(offset);
        let data = {
            page: page > 0 ? page : 1,
            maxPage: maxPage,
            rankings: res,
            offset: offset,
            playerRank: playerRank,
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