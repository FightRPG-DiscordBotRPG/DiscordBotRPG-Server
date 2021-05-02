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


process.on('unhandledRejection', up => {
    throw up;
});



//console.log(Globals);

//let moduleHandler = new ModuleHandler();

let startUp = async () => {
    await Globals.loadGlobals();

    await Translator.load();

    let syncStartWith = Date.now();
    let totalGameStartTime = Date.now();

    console.log("Initializing Database ...");
    await DatabaseInitializer.initialize();
    console.log("Database initialized, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    syncStartWith = Date.now();
    console.log("Loading Rebirth Manager ...");
    Globals.rebirthManager = new RebirthManager();
    await Globals.rebirthManager.load();
    console.log("Rebirth Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    
    syncStartWith = Date.now();
    console.log("Loading Events Manager ...");
    Globals.eventsManager = new EventsManager();
    await Globals.eventsManager.load();
    console.log("Events Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    syncStartWith = Date.now();
    console.log("Loading Areas...");
    Globals.areasManager = new AreasManager();
    await Globals.areasManager.loadAreasManager();
    console.log("Areas loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");


    syncStartWith = Date.now();
    console.log("Loading Fight Manager...");
    Globals.fightManager = new FightManager();
    console.log("Fight Manager loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    syncStartWith = Date.now();
    Globals.pstreenodes = new PSTreeNodes();
    await Globals.pstreenodes.load();
    console.log("Passives/Skills Tree Nodes loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

    let wbs = new WorldBossSpawner();
    await wbs.load();
    await wbs.startUp();


    var connectedUsers = {};
    var connectedGuilds = {};

    Globals.connectedUsers = connectedUsers;
    Globals.connectedGuilds = connectedGuilds;


    console.log("Game World loaded, took : " + ((Date.now() - totalGameStartTime) / 1000) + " seconds");

    // Load api after all 
    const mHandler = new ModuleHandler();
};

startUp();