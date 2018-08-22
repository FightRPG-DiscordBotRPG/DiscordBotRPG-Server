const conn = require("../../conf/mysql");
const Discord = require("discord.js");
const Translator = require("../Translator/Translator");
const Area = require("../Areas/Area");
const AreaTournamentRound = require("./AreaTournamentRound");


class AreaTournament {
    /**
     * 
     * @param {number} area Area where the tournament is done
     */
    constructor(idArea) {
        this.idArea = idArea;
        this.areasGuildsIncriptions = [];
        this.rounds = {};
        this.isStarted = false;
        this.actualRound = 0;
        this.maxRounds = 0;
        this.initDatabase();
        this.resetTournament();
    }

    initDatabase() {
        let res = conn.query("SELECT * FROM conquesttournamentinfo WHERE idArea = ?;", [this.idArea]);
        if(!res[0]) {
            conn.query("INSERT INTO conquesttournamentinfo VALUES (?, 0, 0, NULL);", [this.idArea]);
        }
    }

    /**
     * @returns {Date} Date of the next tournament
     */
    static getNextTournament(idArea) {
        let date = new Date();
        date.setUTCMinutes(0);
        date.setUTCSeconds(0);
        date.setUTCHours(0);
        date.setUTCDate(date.getUTCDate() + 1);
        let res = conn.query("SELECT nextTournament FROM conquesttournamentinfo WHERE idArea = ?", [idArea])[0];
        if(res && res.nextTournament != null) {
            date.setTime(res.nextTournament);
        }
        return date;
    }


    /**
     * Schedule the tournament for next day/week or whatever
     */
    async scheduleTournament() {
        let actualDate = new Date();
        let date = AreaTournament.getNextTournament(this.idArea);
        console.log("Tournament schedule for : " + date.toUTCString() + " For the area : " + this.idArea);
        /*console.log(date.getTime());
        console.log((date.getTime() > actualDate.getTime() ? date.getTime() - actualDate.getTime() : 1000));*/
        //process.exit();
        conn.query("UPDATE conquesttournamentinfo SET nextTournament = ? WHERE idArea = ?;", [null, this.idArea]);
        setTimeout(() => {            
            this.startTournament(); 
        }, (date.getTime() > actualDate.getTime() ? date.getTime() - actualDate.getTime() : 1000));
    }

    /**
     * Start the tournament if there are enough players
     * And do all fights
     */
    async startTournament() {
        this.isStarted = true;
        let inscriptions = conn.query("SELECT * FROM conquesttournamentinscriptions WHERE idArea = ?", [this.idArea]);
        if(inscriptions.length == 0) {
            console.log("Area : " + this.idArea + ", No guilds registered, mission abort ! ");
            this.scheduleTournament();
            return;
        }

        console.log("Starting tournament for the area : " + this.idArea);
        
        for(let inscription of inscriptions) {
            this.areasGuildsIncriptions.push(inscription.idGuild);
        }
        this.calculMaxRounds(this.areasGuildsIncriptions.length);
        this.actualRound = 1;

        conn.query("UPDATE conquesttournamentinfo SET started = ?, actualRound = ? WHERE idArea = ?;", [this.isStarted, this.actualRound, this.idArea]);

        this.rounds[this.actualRound] = new AreaTournamentRound(this.actualRound, this.areasGuildsIncriptions, this.idArea);

        await this.doFights();
        
        this.endTournament();


        //console.log(this.idArea + " : " + this.areasGuildsIncriptions.length);

    }

    /**
     * End Tournament
     * then reset it
     */
    endTournament() {
        let oldOwner = Area.staticGetOwnerID(this.idArea);
        if(oldOwner != this.rounds[this.maxRounds].winners[0]) {
            Area.resetBonuses(this.idArea);
            Area.oneLessLevel(this.idArea);
        }
        Area.staticSetOwner(this.idArea, this.rounds[this.maxRounds].winners[0]);
        console.log("Winner of the area : " + this.idArea + " is " + conn.query("SELECT nom FROM guilds WHERE idGuild = ?", [this.rounds[this.maxRounds].winners[0]])[0].nom);
        this.resetTournament();
        this.scheduleTournament();
        this.resetInscriptions();
        this.resetTimer();
    }


    /**
     * Reset the tournament
     */
    resetTournament() {
        conn.query("UPDATE conquesttournamentinfo SET started = 0, actualRound = 0 WHERE idArea = ?", [this.idArea]);
        conn.query("DELETE FROM conquesttournamentrounds WHERE idArea = ?", [this.idArea]); 
        this.actualRound = 0;
        this.maxRounds = 0;
        this.rounds = {};
        this.areasGuildsIncriptions = [];
        this.isStarted = false;
    }

    resetInscriptions() {
        conn.query("DELETE FROM conquesttournamentinscriptions WHERE idArea = ?", [this.idArea]);
    }

    resetTimer() {
        conn.query("UPDATE conquesttournamentinfo SET nextTournament = NULL WHERE idArea = ?", [this.idArea]);
    }

    /**
     * Calcul all fights
     */
    async doFights() {
        await this.rounds[this.actualRound].doFights();
        if(this.actualRound < this.maxRounds) {
            this.actualRound++;
            conn.query("UPDATE conquesttournamentinfo SET actualRound = ? WHERE idArea = ?;", [this.actualRound, this.idArea]);
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
        while(n > 0) {
            n = Math.floor(n / 2);
            count++;
        }
        this.maxRounds = count;
    }

    static haveStartedByIdArea(idArea) {
        let res = conn.query("SELECT started FROM conquesttournamentinfo WHERE idArea = ?", [idArea])[0];
        return res ? res.started : false;
    }

    /**
     * 
     * @param {number} idArea 
     * @param {number} idGuild 
     */
    static enrollGuild(idGuild, idArea) {
        conn.query("INSERT INTO conquesttournamentinscriptions VALUES (?, ?);", [idGuild, idArea]);
    }

    /**
     * 
     * @param {number} idGuild 
     */
    static unenrollGuild(idGuild) {
        conn.query("DELETE FROM conquesttournamentinscriptions WHERE idGuild = ?;", [idGuild]);
    }

    /**
     * 
     * @param {number} idArea 
     * @param {string} lang 
     */
    static toDiscordEmbed(idArea, lang) {
        if(AreaTournament.haveStartedByIdArea(idArea)) {
            return Translator.getString(lang, "area", "conquest_ongoing");
        }

        return Translator.getString(lang, "area", "conquest_next", [AreaTournament.getNextTournament(idArea).toLocaleString(lang + "-" + lang.toUpperCase()) + " UTC", AreaTournament.getNumberOfGuildsEnrolled(idArea)]);
    }

    /**
     * 
     * @param {number} idArea 
     * @returns {number}
     */
    static getNumberOfGuildsEnrolled(idArea) {
        return conn.query("SELECT count(*) as total FROM conquesttournamentinscriptions WHERE idArea = ?;", [idArea])[0].total;
    }


}

module.exports = AreaTournament;