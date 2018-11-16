const WorldEntity = require("./WorldEntity");
const StatsPlayer = require("../Stats/StatsPlayer");
const LevelSystem = require("../LevelSystem");
const CharacterEquipement = require("../CharacterEquipement");

class CharacterEntity extends WorldEntity {

    /**
     * 
     * @param {number} id 
     */
    constructor(id) {
        super();
        this.id = id;
        this.stats = new StatsPlayer();
        this.equipement = new CharacterEquipement();
        this.levelSystem = new LevelSystem();
        this._type = "Character";
    }

    /**
     * 
     * @param {number} id Character id
     */
    loadCharacter(id) {
        this.id = id;
        this.stats.loadStat(id);
        this.levelSystem.loadLevelSystem(id);
        this.equipement.loadEquipements(id);
    }

    /**
     * @returns {number} level
     */
    getLevel() {
        return this.levelSystem.actualLevel;
    }

    /**
     * 
     * @param {string} statName 
     * @returns {number} Stat value
     */
    getStat(statName) {
        return this.stats.getStat(statName) + this.equipement.getStat(statName);
    }

    /**
     * @returns {number} Power in percentage
     */
    getPower() {
        return this.equipement.getPower();
    }

}

module.exports = CharacterEntity;