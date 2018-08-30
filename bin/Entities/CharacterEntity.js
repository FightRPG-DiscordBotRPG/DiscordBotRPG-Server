const WorldEntity = require("../WorldEntity");
const StatsPlayer = require("../Stats/StatsPlayer");
const LevelSystem = require("../LevelSystem");
const CharacterEquipement = require("../CharacterEquipement");

class CharacterEntity extends WorldEntity{

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
        this.levelSystem.loadLevelSystem(this.id);
        this.equipement.loadEquipements(id);
    }

    /**
     * Prends en compte l'équipement
     */
    updateStats() {
        this.maxHP = 10 + this.getStat("constitution") * 10;
        this.actualHP = this.maxHP;
    }


    damageCalcul() {
        let baseDamage = (this.stats.strength + 1 + this.equipement.stats.strength) * 2;
        return Math.ceil(Math.random() * (baseDamage * 1.25 - baseDamage * 0.75) + baseDamage * 0.75);
    }

    /**
     * @returns {number} level
     */
    getLevel() {
        return this.levelSystem.actualLevel;
    }

    // Critical hit
    isThisACriticalHit() {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let critique = this.getStat("dexterity") / max;

        // Cap to 50%;
        critique = critique > .75 ? .75 : critique;

        return Math.random() <= critique ? true : false;

    }

    getCriticalHitChance() {
        let critique = this.getStat("dexterity") / (this.getLevel() * 2 * 4);
        return critique > .75 ? .75 : critique;
    }

    stun(advWill) {
        // LAST NUMBER = NBR MAX ITEM
        // LIMIT 50%
        // Maximum Stat for this level
        let max = this.getLevel() * 2 * 4;
        // Calcul of chance
        let stun = this.getStat("charisma") / max;
        let otherResist = (advWill) / max;

        // Cap to 50%;
        stun        = stun > .5 ? .5 : stun;
        otherResist = otherResist > .5 ? .5 : otherResist;
        let chanceToStun = stun >= otherResist ? stun : 0;

        return Math.random() <= chanceToStun ? true : false;
    }

    damageDefenceReduction() {
        let reduction = this.getStat("armor") / ((8 * (Math.pow(this.getLevel(),2))) / 7 + 5) * .5;
        return reduction > 0.5 ? 0.5 : 1 - reduction;
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