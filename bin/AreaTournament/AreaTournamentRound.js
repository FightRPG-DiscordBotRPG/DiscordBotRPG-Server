const Fight = require("../Fight/Fight");
const GuildEntity = require("../Entities/GuildEntity");
const conn = require("../../conf/mysql");

class AreaTournamentRound {

    /**
     * 
     * @param {number} round Round number
     * @param {Array<number>} selectedGuilds id of guilds 
     * @param {number} idArea
     */
    constructor(round, selectedGuilds, idArea) {
        this.round = round;
        this.idArea = idArea;
        this.initialGuilds = selectedGuilds;
        this.guildsPlacements = [];
        this.winners = [];
        this.guildsPlacementsNames = [];
    }

    async init() {
        await this.pairGuilds()
    }

    /**
     * Pair guilds
     */
    async pairGuilds() {
        //console.log(this.initialGuilds);
        //console.log(this.initialGuilds);        
        for (let i = 0; i < this.initialGuilds.length; i = i + 2) {
            let pair = [this.initialGuilds[i]];
            if (this.initialGuilds[i + 1]) {
                pair.push(this.initialGuilds[i + 1]);
            } else {
                pair.push(0);
            }
            this.guildsPlacements.push(pair);
            await conn.query("INSERT INTO conquesttournamentrounds VALUES (?, ?, ?, ?, 0)", [this.idArea, this.round, pair[0], pair[1] == 0 ? null : pair[1]]);
        }
    }

    /**
     * Do the fight for each guilds if a guild have no opponent the guild is automaticaly qualified
     */
    async doFights() {
        //console.log("Round : " + this.round)
        //console.log(this.guildsPlacements);
        for (let guildsIndex in this.guildsPlacements) {
            let guilds = this.guildsPlacements[guildsIndex]
            if (guilds[1] != 0) {
                let g1 = new GuildEntity(guilds[0]);
                let g2 = new GuildEntity(guilds[1]);

                await Promise.all([g1.loadGuild(), g2.loadGuild()]);

                let fight = new Fight([g1], [g2]);
                await fight.init(true);
                if (fight.summary.winner == 0) {
                    this.winners.push(guilds[0]);
                    await conn.query("UPDATE conquesttournamentrounds SET winner = 1 WHERE idRound = ? AND idGuild_1 = ?", [this.round, guilds[0]]);
                    //console.log(g1.name);
                } else {
                    this.winners.push(guilds[1]);
                    await conn.query("UPDATE conquesttournamentrounds SET winner = 2 WHERE idRound = ? AND idGuild_2 = ?", [this.round, guilds[1]]);
                    //console.log(g2.name);
                }

                this.guildsPlacementsNames[guildsIndex] = [g1.getName(), g2.getName()];

            } else {
                let g0 = new GuildEntity(guilds[0]);
                await g0.loadGuild();
                this.guildsPlacementsNames[guildsIndex] = [g0.getName(), "Not Matched"];
                this.winners.push(guilds[0]);
                await conn.query("UPDATE conquesttournamentrounds SET winner = 1 WHERE idRound = ? AND idGuild_1 = ?", [this.round, guilds[0]]);
            }
        }
        //console.log(this.round + " : ");
        //console.log(this.winners);
    }


}



module.exports = AreaTournamentRound;