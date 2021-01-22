const conn = require("../../conf/mysql.js");
const Translator = require("../Translator/Translator");
const WorldBoss = require("./WorldBoss");
const LootSystem = require("../LootSystem");
const axios = require("axios").default;
const LeaderboardWBAttacks = require("../Leaderboards/LeaderboardWBAttacks");
const LeaderboardWBDamage = require("../Leaderboards/LeaderboardWBDamage");
const User = require("../User");
const Character = require("../Character");
const Skill = require("../SkillsAndStatus/Skill.js");
const Fight = require("../Fight/Fight.js");

class WorldBossSpawner {

    /**
     * @type {WorldBossSpawner}
     */
    static instance = null;

    constructor() {
        /**
         * @type {Skill[]}
         * */
        this.skillsToTest = [];

        if (!WorldBossSpawner.instance) {
            WorldBossSpawner.instance = this;
        }

    }

    async load() {

        let promises = [];

        for (let i = 1; i <= 3; i++) {
            let skill = new Skill();
            this.skillsToTest.push(skill);
            promises.push(skill.loadWithID(i));
        }

        await Promise.all(promises);

    }

    async startUp() {
        let res = await conn.query("SELECT * FROM bossspawninfo");
        if (res[0]) {
            if (res[0].idSpawnedBoss != null) {
                let res2 = await conn.query("SELECT actualHp FROM spawnedbosses WHERE idSpawnedBoss = ?;", [res[0].idSpawnedBoss]);
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
        let randomBossInfo = (await conn.query("SELECT * FROM bosses INNER JOIN regionsbosses ON regionsbosses.idBoss = bosses.idBoss ORDER BY RAND() LIMIT 1"))[0];
        let randomArea = (await conn.query("SELECT areasregions.idArea FROM areasregions INNER JOIN areas ON areas.idArea = areasregions.idArea WHERE areasregions.idRegion = ? AND areas.idAreaType IN (1) ORDER BY RAND() LIMIT 1;", [randomBossInfo.idRegion]))[0].idArea;

        // Date calcul
        let date = await this.getNextBossDate();
        console.log("Next boss schedule for : " + date.toUTCString());
        await conn.query("INSERT INTO bossspawninfo (idBoss, idArea, spawnDate) VALUES (?, ?, ?);", [randomBossInfo.idBoss, randomArea, date.getTime()])
    }

    async reset() {
        await conn.query("DELETE FROM bossspawninfo");
    }

    /**
     * @returns {Promise<Date>}
     */
    async getNextBossDate() {
        let date = new Date();
        date.setUTCMinutes(0);
        date.setUTCSeconds(0);
        date.setUTCHours(0);
        date.setUTCDate(date.getUTCDate() + 1);
        let res = (await conn.query("SELECT spawnDate FROM bossspawninfo;"))[0];
        if (res && res.spawnDate != null) {
            date.setTime(res.spawnDate);
        }
        return date;
    }

    async getBossesInfos(lang = "en") {
        let res = await conn.query("SELECT * FROM bossspawninfo INNER JOIN regionsbosses ON regionsbosses.idBoss = bossspawninfo.idBoss;");
        let toApi = {
            bosses: [],
        }
        for (let info of res) {
            let toReturn = {
                regionName: Translator.getString(lang, "regionsNames", info.idRegion),
                areaName: Translator.getString(lang, "areasNames", info.idArea),
                idArea: info.idArea,
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

    async getStatsFromFight(spawnedBossId) {
        return (await conn.query("SELECT SUM(attackCount) as totalAttacks, MAX(attackCount) as highestAttackCount, ROUND(AVG(attackCount)) as averageAttackCount, MAX(damage) as highestDamages, ROUND(AVG(damage)) as averageDamages, SUM(damage) as totalDamage FROM charactersattacks WHERE idSpawnedBoss = ?;", [spawnedBossId]))[0];
    }

    async spawnBoss() {
        let res = (await conn.query("SELECT idArea, bosses.idBoss, hpBase FROM bossspawninfo INNER JOIN bosses ON bosses.idBoss = bossspawninfo.idBoss;"))[0];
        let idInsert = (await conn.query("INSERT INTO spawnedbosses VALUES (NULL, ?, ?, ?)", [res.hpBase, res.hpBase, res.idBoss]))["insertId"];
        await conn.query("INSERT INTO spawnedbossesareas VALUES (?, ?);", [idInsert, res.idArea]);
        await conn.query("INSERT INTO wbrewardstates VALUES (?, 0)", [idInsert]);
        await conn.query("UPDATE bossspawninfo SET idSpawnedBoss = ? WHERE bossspawninfo.idBoss = ?;", [idInsert, res.idBoss]);
        WorldBossSpawner.instance.announceWorldBossSpawn();
    }

    async announceWorldBossSpawn() {
        let binfo = await WorldBossSpawner.instance.getBossesInfos();
        binfo = binfo.bosses[0];
        let str = "Boss: " + binfo.worldBoss.name + " has spawned!\nRegion: " + binfo.regionName + "\nArea: " + binfo.areaName;
        WorldBossSpawner.wbTell(str);
    }

    async announceNextBoss(oldWorldBossId) {
        let binfo = await WorldBossSpawner.instance.getBossesInfos();
        binfo = binfo.bosses[0];
        let statsFight = await WorldBossSpawner.instance.getStatsFromFight(oldWorldBossId);
        let date = new Date();
        date.setTime(binfo.spawnDate);
        let str = "";

        let damageGap = statsFight.highestDamages / statsFight.totalDamage * 100;
        let dmgImpressive = "";
        if (damageGap >= 2 && damageGap < 4) {
            dmgImpressive = "Wow Nice!";
        } else if (damageGap >= 4 && damageGap < 8) {
            dmgImpressive = "That's someone with a real dedication in killing things!"
        } else if (damageGap >= 8) {
            dmgImpressive = "Well, it's clear that he did all the job! Good job!"
        }

        let attackGap = statsFight.highestAttackCount / statsFight.totalAttacks * 100;
        let atkImpressive = "";
        if (attackGap >= 2 && attackGap < 4) {
            atkImpressive = "Someone really like doing bot commands!";
        } else if (attackGap >= 4 && attackGap < 8) {
            atkImpressive = "I don't even want to count how much commands he must have done!"
        } else if (attackGap >= 8) {
            atkImpressive = "Well, how is this even possible! Well done!"
        }

        str += "Thanks to all participants the current World Boss has been slain! Here are some stats about the great fight against it:\n";
        str += "\\`\\`\\`" +
            "Average damage dealt: " + statsFight.averageDamages + "\n" +
            "The #1 player damage-wise dealt: " + statsFight.highestDamages + " damage points! That's about " + damageGap.toFixed(2) + "% of the total damage inflicted! " + dmgImpressive + "\n\n" +
            "Total attacks dealt: " + statsFight.totalAttacks + "\n" +
            "Average number of attacks: " + statsFight.averageAttackCount + "\n" +
            "The #1 player in attack count dealt: " + statsFight.highestAttackCount + " attacks! That's about " + attackGap.toFixed(2) + "% of the total attack count! " + atkImpressive + "\\`\\`\\`" + "\n";
        str += "Your rewards are being distributed, it may take some time. Due to the time needed to send you your items, we do not recommend you to use anything that can change your inventory. (Don't sell any items, you don't want to sell your rewards inadvertently)\n\n";
        str += "Next boss will arrive soon, here are some details about the next boss spawn:\n";
        str += "\\`\\`\\`" + Translator.getString("en", "world_bosses", "spawn_date", [date.toLocaleString("en-EN") + " UTC"]) + "\\`\\`\\`";
        WorldBossSpawner.wbTell(str);
    }

    async giveRewards(worldBossId) {
        await conn.query("UPDATE wbrewardstates SET state = 1 WHERE idSpawnedBoss = ?;", [worldBossId]);
        // Must be redone to know if players got the rewards
        WorldBossSpawner.tellToUsers(worldBossId);
        await WorldBossSpawner.instance.giveRewardsToTopDamage(worldBossId);
        await WorldBossSpawner.instance.giveRewardsToTopAttackCount(worldBossId);
        await conn.query("UPDATE wbrewardstates SET state = 2 WHERE idSpawnedBoss = ?;", [worldBossId]);
    }

    async giveRewardsToTopDamage(worldBossId) {
        await WorldBossSpawner.giveToRewardsToPlayers(worldBossId, 1);
    }

    async giveRewardsToTopAttackCount(worldBossId) {
        await WorldBossSpawner.giveToRewardsToPlayers(worldBossId, 2);
    }

    static async tellToUsers(worldBossID) {
        let idBaseBoss = (await conn.query("SELECT idBoss FROM spawnedbosses WHERE idSpawnedBoss = ?;", [worldBossID]))[0].idBoss;
        let res = await conn.query("SELECT users.idUser, lang FROM users INNER JOIN charactersattacks ON charactersattacks.idCharacter = users.idCharacter INNER JOIN userspreferences ON userspreferences.idUser = users.idUser WHERE idSpawnedBoss = ? AND userspreferences.worldbossmute = 0;", [worldBossID]);

        for (let user of res) {
            User.tell(user.idUser, Translator.getString(user.lang, "world_bosses", "boss_you_particpate_dead", [Translator.getString(user.lang, "bossesNames", idBaseBoss)]));
        }
    }

    static async giveToRewardsToPlayers(worldBossId, type) {
        let connQueryText;
        if (type == 1) {
            connQueryText = "SELECT charactersattacks.idCharacter, attackCount, levels.actualLevel FROM charactersattacks INNER JOIN levels ON levels.idCharacter = charactersattacks.idCharacter WHERE idSpawnedBoss = ? ORDER BY attackCount DESC, damage DESC";
        } else {
            connQueryText = "SELECT charactersattacks.idCharacter, damage, levels.actualLevel FROM charactersattacks INNER JOIN levels ON levels.idCharacter = charactersattacks.idCharacter WHERE idSpawnedBoss = ? ORDER BY damage DESC, attackCount DESC";
        }

        let res = await conn.query(connQueryText, [worldBossId]);
        let rank = 1
        let lt = new LootSystem();
        for (let info of res) {
            let items = WorldBossSpawner.getRewardsByRank(rank, info.actualLevel);
            for (let item of items) {
                await lt.giveToPlayerDatabase(info.idCharacter, item.id, item.level, item.number, true);
            }
            rank++;
        }
    }

    static getRewardsByRank(rank, level) {
        let crystals = 1;
        let items = [];
        if (rank == 1) {
            crystals = 100;
            items.push({
                id: 44,
                number: 50,
                level: level
            }, {
                id: 41,
                number: 5,
                level: 1
            });
        } else if (rank == 2) {
            crystals = 85;
            items.push({
                id: 44,
                number: 40,
                level: level
            }, {
                id: 55,
                number: 5,
                level: 1
            });
        } else if (rank >= 3 && rank <= 5) {
            crystals = 70;
            items.push({
                id: 44,
                number: 30,
                level: level
            }, {
                id: 54,
                number: 5,
                level: 1
            });
        } else if (rank >= 6 && rank <= 25) {
            crystals = 50;
            items.push({
                id: 44,
                number: 20,
                level: level
            }, {
                id: 53,
                number: 5,
                level: 1
            });
        } else if (rank >= 26 && rank <= 50) {
            crystals = 30;
            items.push({
                id: 44,
                number: 15,
                level: level
            }, {
                id: 52,
                number: 5,
                level: 1
            });
        } else if (rank >= 51 && rank <= 250) {
            crystals = 20;
            items.push({
                id: 44,
                number: 12,
                level: level
            }, {
                id: 51,
                number: 5,
                level: 1
            });
        } else if (rank >= 251 && rank <= 500) {
            crystals = 10;
            items.push({
                id: 43,
                number: 16,
                level: level
            }, {
                id: 50,
                number: 10,
                level: 1
            });
        } else if (rank >= 501 && rank <= 1000) {
            crystals = 8;
            items.push({
                id: 43,
                number: 14,
                level: level
            }, {
                id: 50,
                number: 8,
                level: 1
            });
        } else if (rank >= 1001 && rank <= 2000) {
            crystals = 7;
            items.push({
                id: 43,
                number: 12,
                level: level
            }, {
                id: 50,
                number: 7,
                level: 1
            });
        } else if (rank >= 2001 && rank <= 3000) {
            crystals = 6;
            items.push({
                id: 43,
                number: 10,
                level: level
            }, {
                id: 50,
                number: 6,
                level: 1
            });
        } else if (rank >= 3001 && rank <= 4000) {
            crystals = 5;
            items.push({
                id: 43,
                number: 8,
                level: level
            }, {
                id: 50,
                number: 5,
                level: 1
            });
        } else if (rank >= 4001 && rank <= 5000) {
            crystals = 4;
            items.push({
                id: 43,
                number: 6,
                level: level
            }, {
                id: 50,
                number: 4,
                level: 1
            });
        } else if (rank >= 5001 && rank <= 7500) {
            crystals = 3;
            items.push({
                id: 43,
                number: 4,
                level: level
            }, {
                id: 50,
                number: 3,
                level: 1
            });
        } else if (rank >= 7501 && rank <= 10000) {
            crystals = 2;
            items.push({
                id: 43,
                number: 2,
                level: level
            }, {
                id: 50,
                number: 2,
                level: 1
            });
        } else {
            crystals = 1;
            items.push({
                id: 43,
                number: 1,
                level: level
            }, {
                id: 50,
                number: 1,
                level: 1
            });

        }

        items.push({
            id: 49,
            number: crystals,
            level: 1
        });
        return items;
    }

    /**
     * 
     * @param {Character} character 
     * @param {WorldBoss} wb 
     */
    async userAttack(character, wb, lang="en") {

        let higestEvaluation = null;
        wb.level = character.getLevel();
        this.skillsToTest.forEach((skill) => {
            let evalDamage = Fight.getSkillEvaluation(skill, character, wb);
            if (higestEvaluation === null || higestEvaluation.value < evalDamage.value) {
                higestEvaluation = evalDamage;
                higestEvaluation.skillName = skill.getName(lang);
            }
        });

        let damage = higestEvaluation.value;
        let isCriticalHit = higestEvaluation.isCritical;

        await wb.wound(damage);
        WorldBossSpawner.logDamageUser(character.id, wb.id, damage, 1);
        let wbs = WorldBossSpawner.instance;

        // pourquoi j'ai remove wb.load() ?!
        // actual hp n'était pas à jour du coup.
        // Maintenant .wound mets à jour les pvs.
        if (wb.actualHp <= 0) {
            WorldBossSpawner.instance.giveRewards(wb.id);
            await wbs.reset();
            await wbs.startUp();
            WorldBossSpawner.instance.announceNextBoss(wb.id);
        }
        character.waitForNextPvPFight();
        return {
            damage: damage,
            isCriticalHit: isCriticalHit,
            waitTime: character.getExhaust(),
            skillUsed: higestEvaluation.skillName
        };
    }

    static async logDamageUser(idCharacter, idBoss, damage, nb = 1) {
        let res = await conn.query("SELECT idCharacter FROM charactersattacks WHERE idCharacter = ? AND idSpawnedBoss = ?;", [idCharacter, idBoss]);
        if (res[0] != null) {
            await conn.query("UPDATE charactersattacks SET damage = damage + ?, attackCount = attackCount + ? WHERE idCharacter = ? AND idSpawnedBoss = ?;", [damage, nb, idCharacter, idBoss]);
        } else {
            await conn.query("INSERT INTO charactersattacks VALUES (?, ?, ?, ?)", [idCharacter, idBoss, damage, nb]);
        }
    }

    static async getLastBossCharacterStats(idCharacter, lang = "en") {
        let res = await conn.query("SELECT * FROM charactersattacks WHERE charactersattacks.idCharacter = ? AND charactersattacks.idSpawnedBoss NOT IN (SELECT bossspawninfo.idSpawnedBoss FROM bossspawninfo WHERE bossspawninfo.idSpawnedBoss != NULL) ORDER BY charactersattacks.idSpawnedBoss DESC LIMIT 1;", [idCharacter]);
        if (res[0]) {
            let wb = new WorldBoss(res[0].idSpawnedBoss);
            await wb.load();
            let ldDamage = new LeaderboardWBDamage(idCharacter);
            let ldAttacks = new LeaderboardWBAttacks(idCharacter);
            return {
                damage: res[0].damage,
                attackCount: res[0].attackCount,
                bossName: wb.getName(lang),
                damageRank: await ldDamage.getPlayerRank(),
                attackCountRank: await ldAttacks.getPlayerRank(),
                worldboss: wb,
            }
        }
        return null;
    }

    static async wbTell(msg) {
        try {
            await axios.post("http://127.0.0.1:48921/wb", {
                message: msg,
            });
        } catch (e) {
            console.log(e);
        }
    }
}

module.exports = WorldBossSpawner;
