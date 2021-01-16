const conn = require("../../conf/mysql.js");
const Translator = require("../Translator/Translator");
const WorldEntity = require("../Entities/WorldEntity.js");

class WorldBoss extends WorldEntity {
    constructor(id) {
        super();
        this.id = id; // Spawned id
        this.idBaseBoss = 0; // This gives boss id base
    }

    async load() {
        let res = await conn.query("SELECT * FROM spawnedbosses WHERE idSpawnedBoss = ?;", [this.id]);
        if (res[0]) {
            this.idBaseBoss = res[0].idBoss;
            this.actualHp = res[0].actualHp;
            this.maxHp = res[0].maxHp;
            return true;
        }
        return false;
    }

    getName(lang = "en") {
        return Translator.getString(lang, "bossesNames", this.idBaseBoss);
    }

    toApi(lang = "en") {
        return {
            name: this.getName(lang),
            actualHP: this.actualHp,
            maxHP: this.maxHp,
        }
    }

    async wound(nb = 0) {
        if (nb > 0) {
            this.actualHp = this.actualHp - nb;
            this.actualHp = this.actualHp > 0 ? this.actualHp : 0;
            await conn.query("UPDATE spawnedbosses SET actualHp = (CASE WHEN actualHp >= ? THEN actualHp - ? ELSE 0 END) WHERE idSpawnedBoss = ?", [nb, nb, this.id]);
        }
    }


}

module.exports = WorldBoss;