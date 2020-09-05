const WorldEntity = require("./WorldEntity");
const StatsPlayer = require("../Stats/StatsPlayer");
const LevelSystem = require("../LevelSystem");
const CharacterEquipement = require("../CharacterEquipement");

class CharacterEntity extends WorldEntity {

    /**
     * 
     * @param {number} id 
     */
    constructor() {
        super();
        this.id = null;
        this.stats = new StatsPlayer();
        this.equipement = new CharacterEquipement();
        this.levelSystem = new LevelSystem();
        this._type = "Character";
    }

    /**
     * 
     * @param {number} id Character id
     */
    async loadCharacter(id) {
        this.id = id;
        await Promise.all([
            this.stats.loadStat(id),
            this.levelSystem.loadLevelSystem(id),
            this.equipement.loadEquipements(id)
        ]);
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
        return super.getStat(statName) + (this.equipement.getStat(statName) * this.tempStatsModifiers[statName]);
    }

    /**
    *
    * @param {string} secondaryStatName
    * @returns {number} Secondary stat value
    */
    getSecondaryStat(secondaryStatName) {
        return super.getSecondaryStat(secondaryStatName) + this.equipement.getSecondaryStat(secondaryStatName);
    }

    /**
     * @returns {Promise<Number>} Power in percentage
     */
    async getPower() {
        return await this.equipement.getPower();
    }

}

module.exports = CharacterEntity;