const WorldEntity = require("./WorldEntity");
const StatsPlayer = require("../Stats/StatsPlayer");
const LevelSystem = require("../LevelSystem");
const CharacterEquipement = require("../CharacterEquipement");
const CharacterTalents = require("../CharacterTalents");
const SkillBuildCharacter = require("../EntitiesBuilds/SkillBuildCharacter");

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
        this.talents = new CharacterTalents();
        this._type = "Character";
        this.skillBuild = new SkillBuildCharacter();
    }

    /**
     * 
     * @param {number} id Character id
     */
    async loadCharacter(id) {
        this.id = id;
        this.uuid = id.toString();
        await Promise.all([
            this.stats.loadStat(id),
            this.levelSystem.loadLevelSystem(id),
            this.equipement.loadEquipements(id),
            this.talents.load(null, id),
            this.skillBuild.load(id),
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
        return super.getStat(statName) + ((this.equipement.getStat(statName) + this.talents.stats.getStat(statName)) * this.tempStatsModifiers[statName]);
    }

    /**
    *
    * @param {string} secondaryStatName
    * @returns {number} Secondary stat value
    */
    getSecondaryStat(secondaryStatName) {
        return super.getSecondaryStat(secondaryStatName) + ((this.equipement.getSecondaryStat(secondaryStatName) + this.talents.secondaryStats.getStat(secondaryStatName)) * this.tempStatsModifiers[secondaryStatName]);
    }

    /**
     * 
     * @param {string} elementName
     */
    getElementalResistMultiplier(elementName) {
        return (super.getElementalResistMultiplier(elementName) + this.equipement.secondaryStats.getElementalResist(elementName) + this.talents.secondaryStats.getElementalResist(elementName)) - 2;
    }

    /**
     * @returns {Promise<Number>} Power in percentage
     */
    async getPower() {
        return await this.equipement.getPower();
    }

}

module.exports = CharacterEntity;