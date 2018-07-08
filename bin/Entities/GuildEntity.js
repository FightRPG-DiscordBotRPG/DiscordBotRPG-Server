const Entity = require("../WorldEntity");
const StatsGuild = require("../Stats/StatsGuild");
const conn = require("../../conf/mysql");

class GuildEntity extends Entity {

    /**
     * 
     * @param {number} id ID fo guild
     */
    constructor(id) {
        super();
        this._type = "Guild";
        this.id = id;
        this.name = "";
        this.actualHP = 0;
        this.maxHP = 0;
        this.level = 0;
        this.stats = new StatsGuild(this.id);
        this.loadGuild();

        // Functions
        //this.loadGuild();

    }

    /**
     * Load guild level and name from db
     */
    loadGuild() {
        let res = conn.query("SELECT CEIL(MAX(levels.actualLevel)) as level FROM levels WHERE levels.idCharacter IN (SELECT guildsmembers.idCharacter FROM guildsmembers WHERE guildsmembers.idGuild = ?);", [this.id]);
        this.level = res[0].level;
        this.name = conn.query("SELECT nom FROM guilds WHERE idGuild = ?", [this.id])[0].nom;
        this.stats.loadStats();
        //this.updateStats();
    }

}

module.exports = GuildEntity;