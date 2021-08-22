const Globals = require("./bin/Globals.js");
const Translator = require("./bin/Translator/Translator");
const FightManager = require("./bin/FightManager");
const crypto = require("crypto");
const AreasManager = require("./bin/Areas/AreasManager.js");
const conf = require("./conf/conf");
const DatabaseInitializer = require("./bin/DatabaseInitializer");
const ModuleHandler = require("./bin/Modules/ModuleHandler");
const User = require("./bin/User");
const LootSystem = require("./bin/LootSystem");
const DBL = require("dblapi.js");
const WorldBossSpawner = require("./bin/WorldBosses/WorldBossSpawner");
const PSTreeNodes = require("./bin/PSTree/PSTreeNodes.js");
const RebirthManager = require("./bin/Rebirths/RebirthManager.js");
const axios = require("axios").default;
const EventsManager = require("./bin/Events/EventsManager.js");
const CharacterAppearance = require("./bin/Appearance/CharacterAppearance.js");
const Appearance = require("./bin/Appearance/Appearance.js");
const ItemAppearance = require("./bin/Appearance/ItemAppearance.js");
const cluster = require("cluster");
const totalCPUs = require("os").cpus().length;
const mainCluster = require("./mainClustered");
const AreasClusterManager = require("./bin/ClusteringManagers/AreasClusterManager");




//process.on('unhandledRejection', up => {
//    throw up;
//});

function loadDbl() {
    const options = {
        webhookPort: 5000,
        webhookAuth: conf.webhookkey
    };
    const dbl = new DBL(conf.discordbotskey, options);
    dbl.webhook.on('ready', hook => {
        console.log(`Webhook running at http://${hook.hostname}:${hook.port}${hook.path}`);
    });

    if (conf.env === "prod") {

        dbl.webhook.on('vote', async (vote) => {
            let idAndLang = await User.getIdAndLang(vote.user);
            if (idAndLang != null) {
                let ls = new LootSystem();
                await ls.giveToPlayerDatabase(idAndLang.idCharacter, 41, 1, vote.isWeekend ? 2 : 1, true, 0);
                let lang = idAndLang.lang;
                let msg = Translator.getString(lang, "vote_daily", "you_voted");
                if (vote.isWeekend) {
                    msg += Translator.getString(lang, "vote_daily", "vote_week_end");
                } else {
                    msg += Translator.getString(lang, "vote_daily", "vote_no_week_end");
                }
                User.tell(vote.user, msg);
            }

        });
    }
}

//console.log(Globals);

//let moduleHandler = new ModuleHandler();

let startUp = async () => {

    if (cluster.isMaster) {


        console.log(`Number of CPUs is ${totalCPUs}`);
        console.log(`Master ${process.pid} is running`);
        cluster.schedulingPolicy = cluster.SCHED_RR;


        console.time("Loading Clustering Manager for areas");
        await AreasClusterManager.load();
        console.timeEnd("Loading Clustering Manager for areas");



        // Fork workers.
        for (let i = 0; i < 2; i++) {
            cluster.fork();
        }

        cluster.on('exit', (worker, code, signal) => {
            console.log(`worker ${worker.process.pid} died`);
            console.log("Let's fork another worker!");
            cluster.fork();
        });




        let syncStartWith = Date.now();

        console.log("Initializing Database ...");
        await DatabaseInitializer.initialize();
        console.log("Database initialized, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

        //syncStartWith = Date.now();
        //console.log("Loading Events Manager ...");
        //Globals.eventsManager = new EventsManager();
        //await Globals.eventsManager.load();
        //console.log("Events Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

        // Tag mémoire ou quelque chose comme ça pour savoir si une shard est déjà entrain de calculer les dégats?
        let wbs = new WorldBossSpawner();
        await wbs.startUp();


        loadDbl();
    } else {
        const express = require("express");
        const app = express();
        app.listen(conf.port, () => console.log("Starting RESTful api server on: " + conf.port));
        mainCluster(app);
    }


    //const express = require("express");
    //const app = express();
    //app.listen(conf.port, () => console.log("Starting RESTful api server on: " + conf.port));
    //mainCluster(app);

};

startUp();