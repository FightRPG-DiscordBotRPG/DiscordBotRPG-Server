const conn = require("../../conf/mysql");
const AreaTournamentRound = require("./AreaTournamentRound");
const fs = require("fs").promises;
const conf = require("../../conf/conf");

class AreaTournament {
    /**
     * 
     * @param {number} area Area where the tournament is done
     */
    constructor(idArea) {
        this.idArea = idArea;
        this.areasGuildsInscriptions = [];
        /**
         * @type {Array<AreaTournamentRound>}
         */
        this.rounds = {};
        this.isStarted = false;
        this.actualRound = 0;
        this.maxRounds = 0;
        this.date = null;
    }

    async init() {
        await this.initDatabase();
        await this.resetTournament();
    }

    async initDatabase() {
        let res = await conn.query("SELECT * FROM conquesttournamentinfo WHERE idArea = ?;", [this.idArea]);
        if (!res[0]) {
            await conn.query("INSERT INTO conquesttournamentinfo VALUES (?, 0, 0, NULL);", [this.idArea]);
        }
    }

    /**
     * @returns {Promise<Date>} Date of the next tournament
     */
    static async getNextTournament(idArea) {
        let date = new Date();
        date.setUTCMinutes(0);
        date.setUTCSeconds(0);
        date.setUTCHours(0);
        date.setUTCDate(date.getUTCDate() + 1);
        let res = (await conn.query("SELECT nextTournament FROM conquesttournamentinfo WHERE idArea = ?", [idArea]))[0];
        if (res && res.nextTournament != null) {
            date.setTime(res.nextTournament);
        }
        if (conf.env == "dev") {
            date = new Date(Date.now() + 20000);
        }
        return date;
    }


    /**
     * Schedule the tournament for next day/week or whatever
     */
    async scheduleTournament() {
        let actualDate = new Date();
        let date = await AreaTournament.getNextTournament(this.idArea);
        console.log("Tournament schedule for : " + date.toUTCString() + " For the area : " + this.idArea);
        await conn.query("UPDATE conquesttournamentinfo SET nextTournament = ? WHERE idArea = ?;", [null, this.idArea]);
        setTimeout(async () => {
            this.startTournament();
        }, (date.getTime() > actualDate.getTime() ? date.getTime() - actualDate.getTime() : 1000));
    }

    /**
     * Start the tournament if there are enough players
     * And do all fights
     */
    async startTournament() {
        this.isStarted = true;
        this.date = Date.now();
        let inscriptions = await conn.query("SELECT * FROM conquesttournamentinscriptions WHERE idArea = ?", [this.idArea]);
        if (inscriptions.length == 0) {
            console.log("Area : " + this.idArea + ", No guilds registered, mission abort ! ");
            await this.clearJsonData();
            this.scheduleTournament();
            return;
        }

        console.log("Starting tournament for the area : " + this.idArea);

        for (let inscription of inscriptions) {
            this.areasGuildsInscriptions.push(inscription.idGuild);
        }
        // Sort here just one time to be real tournamenet like system
        this.areasGuildsInscriptions.sort(() => Math.random() - 0.5);

        this.calculMaxRounds();
        this.actualRound = 1;

        await conn.query("UPDATE conquesttournamentinfo SET started = ?, actualRound = ? WHERE idArea = ?;", [this.isStarted, this.actualRound, this.idArea]);

        this.rounds[this.actualRound] = new AreaTournamentRound(this.actualRound, this.areasGuildsInscriptions, this.idArea);
        await this.rounds[this.actualRound].init()

        // Do all the fights for this area
        await this.doFights();

        // End the tournament and give ownership
        await this.endTournament();
    }




    /**
     * Reset the tournament
     */
    async resetTournament() {
        await conn.query("UPDATE conquesttournamentinfo SET started = 0, actualRound = 0 WHERE idArea = ?", [this.idArea]);
        await conn.query("DELETE FROM conquesttournamentrounds WHERE idArea = ?", [this.idArea]);
        this.actualRound = 0;
        this.maxRounds = 0;
        this.rounds = {};
        this.areasGuildsInscriptions = [];
        this.isStarted = false;
    }

    async resetInscriptions() {
        await conn.query("DELETE FROM conquesttournamentinscriptions WHERE idArea = ?", [this.idArea]);
    }

    async resetTimer() {
        await conn.query("UPDATE conquesttournamentinfo SET nextTournament = NULL WHERE idArea = ?", [this.idArea]);
    }

    /**
     * Calcul all fights
     */
    async doFights() {
        await this.rounds[this.actualRound].doFights();
        if (this.actualRound < this.maxRounds) {
            this.actualRound++;
            await conn.query("UPDATE conquesttournamentinfo SET actualRound = ? WHERE idArea = ?;", [this.actualRound, this.idArea]);
            this.rounds[this.actualRound] = new AreaTournamentRound(this.actualRound, this.rounds[this.actualRound - 1].winners, this.idArea);
            await this.rounds[this.actualRound].init();
            await this.doFights();
        }
        //console.log("Tournament Finished for area : " + this.idArea + " Winner is : " + this.rounds[this.actualRound].winners[0].name);
    }

    /**
     * Update mamximum number of rounds (Basically it's the number of rounds that iwll be played)
     */
    calculMaxRounds() {
        let n = this.areasGuildsInscriptions.length;
        let count = 0;
        while (n > 0) {
            n = Math.floor(n / 2);
            count++;
        }
        this.maxRounds = count;
    }

    static async haveStartedByIdArea(idArea) {
        let res = (await conn.query("SELECT started FROM conquesttournamentinfo WHERE idArea = ?", [idArea]))[0];
        return res ? res.started : false;
    }

    /**
     * 
     * @param {number} idArea 
     * @param {number} idGuild 
     */
    static async enrollGuild(idGuild, idArea) {
        await conn.query("REPLACE INTO conquesttournamentinscriptions VALUES (?, ?);", [idGuild, idArea]);
    }

    /**
     * 
     * @param {number} idGuild 
     */
    static async unenrollGuild(idGuild) {
        await conn.query("DELETE FROM conquesttournamentinscriptions WHERE idGuild = ?;", [idGuild]);
    }

    /**
     * 
     * @param {number} idArea 
     * @param {string} lang 
     */
    static async toApi(idArea) {
        let apiObject = {
            isStarted: false,
            startDate: null,
            numberOfGuildEnrolled: 0
        }
        if (await AreaTournament.haveStartedByIdArea(idArea)) {
            apiObject.isStarted = true;
            return apiObject;
        }

        apiObject.startDate = await AreaTournament.getNextTournament(idArea);
        apiObject.numberOfGuildEnrolled = await AreaTournament.getNumberOfGuildsEnrolled(idArea);

        return apiObject;
    }

    /**
     * 
     * @param {number} idArea 
     * @returns {Promise<number>}
     */
    static async getNumberOfGuildsEnrolled(idArea) {
        return (await conn.query("SELECT count(*) as total FROM conquesttournamentinscriptions WHERE idArea = ?;", [idArea]))[0].total;
    }


    /**
     * End Tournament
     * then reset it
     */
    async endTournament() {
        let oldOwner = await Area.staticGetOwnerID(this.idArea);
        if (oldOwner !== this.rounds[this.maxRounds].winners[0]) {
            // No more resets
            //await Area.resetBonuses(this.idArea);
            // TODO: Améliorer le système pour le rendre plus juste
            //await Area.oneLessLevel(this.idArea);
        }
        await Area.staticSetOwner(this.idArea, this.rounds[this.maxRounds].winners[0]);
        console.log("Winner of the area : " + this.idArea + " is " + (await conn.query("SELECT nom FROM guilds WHERE idGuild = ?", [this.rounds[this.maxRounds].winners[0]]))[0].nom);

        await this.saveToFile();
        await this.resetTournament();
        await this.scheduleTournament();
        await this.resetInscriptions();
    }

    async saveToFile() {
        let area = new Area(this.idArea);
        await area.lightLoad();
        this.areaName = area.getName("en");
        this.areaImage = area.image;
        await this.clearJsonData();
        try {
            await fs.writeFile(conf.tournamentFilesPath + this.idArea + ".json", JSON.stringify(this));
        } catch (e) {
            console.log(e);
        }
    }

    async clearJsonData() {
        try {
            await fs.unlink(conf.tournamentFilesPath + this.idArea + ".json")
        } catch (e) {
            //console.log(e);
            // We do'nt care about errors, the deletion is not important
        }
    }


}

module.exports = AreaTournament;

const Area = require("../Areas/Area");
