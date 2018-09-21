const Discord = require('discord.js');
const conf = require("./conf/conf");
const DatabaseInitializer = require("./bin/DatabaseInitializer");
const User = require("./bin/User");
const LootSystem = require("./bin/LootSystem");

let timeStart = Date.now();
let syncStartWith = Date.now();

process.on('unhandledRejection', up => {
    throw up
});

console.log("Initializing Database ...");
DatabaseInitializer.initialize();
console.log("Database initialized, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");

if (conf.env === "prod") {
    const options = {
        webhookPort: 5000,
        webhookAuth: conf.webhookkey
    };
    const dbl = new DBL(conf.discordbotskey, options, bot);
    dbl.webhook.on('ready', hook => {
        console.log(`Webhook running at http://${hook.hostname}:${hook.port}${hook.path}`);

    });
    dbl.webhook.on('vote', vote => {
        if (User.exist(vote.user)) {
            let user = new User(vote.user);
            user.loadUser();
            let ls = new LootSystem();
            ls.giveToPlayer(user.character, 41, 1, vote.isWeekend ? 2 : 1);
            let duser = bot.users.get(vote.user);
            if (duser != null) {
                let lang = user.getLang();
                let msg = Translator.getString(lang, "vote_daily", "you_voted");
                if (vote.isWeekend) {
                    msg += Translator.getString(lang, "vote_daily", "vote_week_end");
                } else {
                    msg += Translator.getString(lang, "vote_daily", "vote_no_week_end");
                }
                duser.send(msg);
            }
        }

    });

}

syncStartWith = Date.now();
console.log("Loading Shards...");

const Manager = new Discord.ShardingManager('./shardedMain.js');
Manager.spawn(2).then(() => {
    console.log("Shards loaded, took : " + ((Date.now() - syncStartWith) / 1000) + " seconds");
    console.log("The bot and all of his shards are loaded, took : " + ((Date.now() - timeStart) / 1000) + " seconds");
    Manager.on("message", (shard, message) => {
        console.log(message);
    });
}); // This example will spawn 2 shards (5,000 guilds);



const ApiResponder = require("./api/ApiResponder.js");