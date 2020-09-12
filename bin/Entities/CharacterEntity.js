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
        this.buildSkills = [1, 2, 52, 91, 101, 172];
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
        return super.getSecondaryStat(secondaryStatName) + (this.equipement.getSecondaryStat(secondaryStatName) * this.tempStatsModifiers[secondaryStatName]);
    }

    /**
     * 
     * @param {string} elementName
     */
    getElementalResist(elementName) {
        // super always returns 1 since user is a world entity having empty secondary stats
        return super.getElementalResist(elementName) + (this.equipement.secondaryStats.getElementalResist(elementName) + this.tempStatsModifiers[elementName]) - 1;
    }

    /**
     * @returns {Promise<Number>} Power in percentage
     */
    async getPower() {
        return await this.equipement.getPower();
    }

}

module.exports = CharacterEntity;