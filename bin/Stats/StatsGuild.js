const conn = require("../../conf/mysql");
const Stats = require("./Stats");
const CharacterEntity = require("../Entities/CharacterEntity");
const Globals = require("../Globals");

class StatsGuild extends Stats{

    constructor(id) {
        super(id, id);
    }

    // Load from DB

    loadStats() {
        let res = conn.query("SELECT guildsmembers.idCharacter FROM guildsmembers WHERE guildsmembers.idGuild = ?", [this.id]);
        let maxLevel = 0;
        for(let r of res) {
            let character = new CharacterEntity(r.idCharacter);
            character.loadCharacter(r.idCharacter);

            
            this.strength += character.getStat("strength");
            this.intellect += character.getStat("intellect");
            this.constitution += character.getStat("constitution");
            this.charisma += character.getStat("charisma");
            this.will += character.getStat("will");


            this.dexterity += character.getCriticalHitChance();
            this.armor += character.damageDefenceReduction();

            if(character.getLevel() > maxLevel) {
                maxLevel = character.getLevel();
            }

        }

        
        this.dexterity = Math.ceil((this.dexterity / res.length) * (2 * 4 * maxLevel));
        this.armor = Math.ceil((1 - (this.armor / res.length)) * 2 * ((8 * (Math.pow(maxLevel,2))) / 7 + 5));

    }



}

module.exports = StatsGuild;