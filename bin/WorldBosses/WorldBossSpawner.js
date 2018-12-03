const conn = require("../../conf/mysql.js");
const Translator = require("../Translator/Translator");
const WorldBoss = require("./WorldBoss");
const LootSystem = require("../LootSystem");

class WorldBossSpawner {
    async startUp() {
        let res = conn.query("SELECT * FROM bossspawninfo");
        if (res[0]) {
            if (res[0].idSpawnedBoss != null) {
                let res2 = conn.query("SELECT actualHp FROM spawnedbosses WHERE idSpawnedBoss = ?;", [res[0].idSpawnedBoss]);
                if (res2[0].actualHp <= 0) {
                    await this.reset();
                    await this.init();
                    await this.startUp();
                }
            } else {
                let actualDate = new Date();
                setTimeout(async () => {
                    this.spawnBoss();
                }, (res[0].spawnDate > actualDate.getTime() ? res[0].spawnDate - actualDate.getTime() : 1000));
            }
        } else {
            await this.init();
            await this.startUp();
        }
    }

    async init() {
        let randomBossInfo = conn.query("SELECT * FROM bosses INNER JOIN regionsbosses ON regionsbosses.idBoss = bosses.idBoss ORDER BY RAND() LIMIT 1")[0];
        let randomArea = conn.query("SELECT idArea FROM areasregions WHERE areasregions.idRegion = ? ORDER BY RAND() LIMIT 1;", [randomBossInfo.idRegion])[0].idArea;

        // Date calcul
        let actualDate = new Date();
        let date = await WorldBossSpawner.getNextBossDate();
        console.log("Next boss schedule for : " + date.toUTCString());
        conn.query("INSERT INTO bossspawninfo (idBoss, idArea, spawnDate) VALUES (?, ?, ?);", [randomBossInfo.idBoss, randomArea, date.getTime()])
    }

    async reset() {
        conn.query("DELETE FROM bossspawninfo");
    }

    /**
     * @returns {Date}
     */
    static async getNextBossDate() {
        let date = new Date();
        date.setUTCMinutes(0);
        date.setUTCSeconds(0);
        date.setUTCHours(0);
        date.setUTCDate(date.getUTCDate() + 1);
        let res = conn.query("SELECT spawnDate FROM bossspawninfo;")[0];
        if (res && res.spawnDate != null) {
            date.setTime(res.spawnDate);
        }
        return date;
    }

    static async getBossesInfos(lang = "en") {
        let res = conn.query("SELECT * FROM bossspawninfo INNER JOIN regionsbosses ON regionsbosses.idBoss = bossspawninfo.idBoss", [this.id]);
        let toApi = {
            bosses: [],
        }
        for (let info of res) {
            let toReturn = {
                regionName: Translator.getString(lang, "regionsNames", info.idRegion),
                areaName: Translator.getString(lang, "areasNames", info.idArea),
                worldBoss: null,
                spawnDate: info.spawnDate
            }
            if (info.idSpawnedBoss) {
                let wb = new WorldBoss(info.idSpawnedBoss);
                await wb.load();
                toReturn.worldBoss = wb.toApi(lang);
            }
            toApi.bosses.push(toReturn);
        }
        return toApi;
    }

    async spawnBoss() {
        let res = conn.query("SELECT idArea, bosses.idBoss, hpBase FROM bossspawninfo INNER JOIN bosses ON bosses.idBoss = bossspawninfo.idBoss;")[0];
        let hp = 3000;
        let idInsert = conn.query("INSERT INTO spawnedbosses VALUES (NULL, ?, ?, ?)", [hp, hp, res.idBoss])["insertId"];
        conn.query("INSERT INTO spawnedbossesareas VALUES (?, ?);", [idInsert, res.idArea]);
        conn.query("UPDATE bossspawninfo SET idSpawnedBoss = ? WHERE bossspawninfo.idBoss = ?;", [idInsert, res.idBoss]);
    }

    static async giveRewards(worldBossId) {
        WorldBossSpawner.giveRewardsToTopDamage(worldBossId);
        WorldBossSpawner.giveRewardsToTopAttackCount(worldBossId);
    }

    static async giveRewardsToTopDamage(worldBossId) {
        let lt = new LootSystem();
        let res = conn.query("SELECT idCharacter, damage FROM charactersattacks WHERE idSpawnedBoss = ? ORDER BY damage DESC, attackCount DESC", [worldBossId]);
        let i = 1;
        for (let info of res) {
            if (i < 11) {
                lt.giveToPlayerDatabase(info.idCharacter, 49, 1, 10);
            } else if (i >= 11 && i <= 100) {
                lt.giveToPlayerDatabase(info.idCharacter, 49, 1, 5);
            } else {
                lt.giveToPlayerDatabase(info.idCharacter, 49, 1, 1);
            }
        }
    }

    static async giveRewardsToTopAttackCount(worldBossId) {
        let res = conn.query("SELECT idCharacter, attackCount FROM charactersattacks WHERE idSpawnedBoss = ? ORDER BY attackCount DESC, damage DESC", [worldBossId]);
        let i = 1
        let lt = new LootSystem();
        for (let info of res) {
            if (i < 11) {
                lt.giveToPlayerDatabase(info.idCharacter, 49, 1, 10);
            } else if (i >= 11 && i <= 100) {
                lt.giveToPlayerDatabase(info.idCharacter, 49, 1, 5);
            } else {
                lt.giveToPlayerDatabase(info.idCharacter, 49, 1, 1);
            }
        }
    }

    static async getRankDamage(idCharacter, idSpawnedBoss) {
        let res = conn.query("SELECT DISTINCT * FROM (SELECT @rn:=@rn+1 as rank, idCharacter FROM charactersattacks, (select @rn:=0) row_nums WHERE idSpawnedBoss = ? ORDER BY damage DESC, attackCount DESC) user_ranks WHERE idCharacter = ?;", [idSpawnedBoss, idCharacter]);
        return res != null && res[0] ? res[0].rank : 1;
    }

    static async getRankAttackCount(idCharacter, idSpawnedBoss) {
        let res = conn.query("SELECT DISTINCT * FROM (SELECT @rn:=@rn+1 as rank, idCharacter FROM charactersattacks, (select @rn:=0) row_nums WHERE idSpawnedBoss = ? ORDER BY attackCount DESC, damage DESC) user_ranks WHERE idCharacter = ?;", [idSpawnedBoss, idCharacter]);
        return res != null && res[0] ? res[0].rank : 1;
    }

    static async userAttack(character, wb) {
        let damage = character.damageCalcul();
        let isCriticalHit = character.isThisACriticalHit();
        if (isCriticalHit) {
            damage = damage * 2;
        }
        wb.wound(damage);
        WorldBossSpawner.logDamageUser(character.id, wb.id, damage, 1);
        let wbs = new WorldBossSpawner();
        await wb.load();
        if (wb.actualHp <= 0) {
            WorldBossSpawner.giveRewards(wb.id);
            await wbs.reset();
            await wbs.init();
            await wbs.startUp();
        }
        character.waitForNextPvPFight();
        return {
            damage: damage,
            isCriticalHit: isCriticalHit,
            waitTime: character.getExhaust(),
        };
    }

    static async logDamageUser(idCharacter, idBoss, damage, nb = 1) {
        let res = conn.query("SELECT idCharacter FROM charactersattacks WHERE idCharacter = ? AND idSpawnedBoss = ?;", [idCharacter, idBoss]);
        if (res[0] != null) {
            conn.query("UPDATE charactersattacks SET damage = damage + ?, attackCount = attackCount + ? WHERE idCharacter = ? AND idSpawnedBoss = ?;", [damage, nb, idCharacter, idBoss]);
        } else {
            conn.query("INSERT INTO charactersattacks VALUES (?, ?, ?, ?)", [idCharacter, idBoss, damage, nb]);
        }
    }

    static async getLastBossCharacterStats(idCharacter, lang = "en") {
        let res = conn.query("SELECT * FROM charactersattacks WHERE charactersattacks.idCharacter = ? AND charactersattacks.idSpawnedBoss NOT IN (SELECT bossspawninfo.idSpawnedBoss FROM bossspawninfo WHERE bossspawninfo.idSpawnedBoss != NULL) ORDER BY charactersattacks.idSpawnedBoss DESC LIMIT 1;", [idCharacter]);
        if (res[0]) {
            let wb = new WorldBoss(res[0].idSpawnedBoss);
            return {
                damage: res[0].damage,
                attackCount: res[0].attackCount,
                bossName: wb.getName(lang),
                damageRank: await WorldBossSpawner.getRankDamage(idCharacter, res[0].idSpawnedBoss),
                attackCountRank: await WorldBossSpawner.getRankAttackCount(idCharacter, res[0].idSpawnedBoss),
            }
        }
        return null;
    }
}

module.exports = WorldBossSpawner;