const conn = require("../../conf/mysql");
const Translator = require("../Translator/Translator");
const AreaTournamentRound = require("./AreaTournamentRound");


class AreaTournament {
    /**
     * 
     * @param {number} area Area where the tournament is done
     */
    constructor(idArea) {
        this.idArea = idArea;
        this.areasGuildsIncriptions = [];
        /**
         * @type {Array<AreaTournamentRound>}
         */
        this.rounds = {};
        this.isStarted = false;
        this.actualRound = 0;
        this.maxRounds = 0;
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
     * @returns {Date} Date of the next tournament
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
        let inscriptions = await conn.query("SELECT * FROM conquesttournamentinscriptions WHERE idArea = ?", [this.idArea]);
        if (inscriptions.length == 0) {
            console.log("Area : " + this.idArea + ", No guilds registered, mission abort ! ");
            this.scheduleTournament();
            return;
        }

        console.log("Starting tournament for the area : " + this.idArea);

        for (let inscription of inscriptions) {
            this.areasGuildsIncriptions.push(inscription.idGuild);
        }
        this.calculMaxRounds();
        this.actualRound = 1;

        await conn.query("UPDATE conquesttournamentinfo SET started = ?, actualRound = ? WHERE idArea = ?;", [this.isStarted, this.actualRound, this.idArea]);

        this.rounds[this.actualRound] = new AreaTournamentRound(this.actualRound, this.areasGuildsIncriptions, this.idArea);
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
        this.areasGuildsIncriptions = [];
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
            this.doFights();
        }
        //console.log("Tournament Finished for area : " + this.idArea + " Winner is : " + this.rounds[this.actualRound].winners[0].name);
    }

    /**
     * Update mamximum number of rounds (Basically it's the number of rounds that iwll be played)
     */
    calculMaxRounds() {
        let n = this.areasGuildsIncriptions.length;
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
        await conn.query("INSERT INTO conquesttournamentinscriptions VALUES (?, ?);", [idGuild, idArea]);
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
    static async toDiscordEmbed(idArea, lang) {
        if (await AreaTournament.haveStartedByIdArea(idArea)) {
            return Translator.getString(lang, "area", "conquest_ongoing");
        }

        let langStr = lang.length > 2 ? lang : lang + "-" + lang.toUpperCase();
        return Translator.getString(lang, "area", "conquest_next", [(await AreaTournament.getNextTournament(idArea)).toLocaleString(langStr) + " UTC", await AreaTournament.getNumberOfGuildsEnrolled(idArea)]);
    }

    /**
     * 
     * @param {number} idArea 
     * @returns {number}
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
        if (oldOwner != this.rounds[this.maxRounds].winners[0]) {
            await Area.resetBonuses(this.idArea);
            // TODO: Améliorer le système pour le rendre plus juste
            //await Area.oneLessLevel(this.idArea);
        }
        await Area.staticSetOwner(this.idArea, this.rounds[this.maxRounds].winners[0]);
        console.log("Winner of the area : " + this.idArea + " is " + (await conn.query("SELECT nom FROM guilds WHERE idGuild = ?", [this.rounds[this.maxRounds].winners[0]]))[0].nom);
        await this.resetTournament();
        await this.scheduleTournament();
        await this.resetInscriptions();
    }


}

module.exports = AreaTournament;

// Prevent cyclic bullshit from nodejs
const Area = require("../Areas/Area");