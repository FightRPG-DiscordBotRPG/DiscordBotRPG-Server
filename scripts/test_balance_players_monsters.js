const Globals = require("../bin/Globals");
const Translator = require("../bin/Translator/Translator");
const conn = require("../conf/mysql");

const AreasManager = require("../bin/Areas/AreasManager.js");
const DatabaseInitializer = require("../bin/DatabaseInitializer");

const GModule = require("../bin/Modules/GModule");

//const GModule = require("./GModule");
const Guild = require("../bin/Guild");
const PStatistics = require("../bin/Achievement/PStatistics");
const TournamentViewer = require("../bin/Helper/TournamentViewer");


const User = require("../bin/User");
const LootSystem = require("../bin/LootSystem");
const WorldBossSpawner = require("../bin/WorldBosses/WorldBossSpawner");
const PSTreeNodes = require("../bin/PSTree/PSTreeNodes.js");


const FightManager = require("../bin/FightManager");
const Fight = require("../bin/Fight/Fight");
const Character = require("../bin/Character");
const Monster = require("../bin/Entities/Monster");



async function Start() {
    await Globals.loadGlobals();

    await Translator.load();
    Globals.fightManager = new FightManager();

    Globals.pstreenodes = new PSTreeNodes();
    await Globals.pstreenodes.load();

    await Test();
}

async function Test() {
    let results = {};

    let anthelme = new Character("228787710607753216");
    await anthelme.lightLoad(8);

    let maxId = (await conn.query("SELECT count(*) as max FROM monstres;"))[0].max;


    let promises = [];
    console.time("Combats");

    for (let i = 0; i < 100; i++) {
        for (let i = 1; i <= maxId; i++) {
            let monster = new Monster(i);
            await monster.loadMonster(anthelme.getLevel());

            if (monster.type != "normal") {
                continue;
            }

            let fight = new Fight([anthelme], [monster], "fr");


            promises.push(
                (async () => {
                    await fight.init(true);

                    let idBuild = monster.idStatsProfil + "," + monster.skillBuild.id;
                    if (results[idBuild] == null) {
                        results[idBuild] = { win: 0, lost: 0 };
                    }

                    //if (results[idBuild][monster.type] == null) {
                    //    results[idBuild][monster.type] = ;
                    //}

                    if (fight.winnerGroup === 0) {
                        results[idBuild].win++;
                    } else {
                        results[idBuild].lost++;
                    }

                })()
            )

        }
    }

    await Promise.all(promises);

    for (let id in results) {
        let total = results[id].win + results[id].lost;
        results[id] = Math.round((results[id].win / total * 100)) + "%";
    }

    console.timeEnd("Combats");

    console.log(results);
}

Start();

