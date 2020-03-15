#!/usr/bin/env node
const util = require('util');
const { spawn } = require('child_process');
const conf = { env: "dev", discordbotskey: "", webhookkey: "", registerkey: "DEFAULT_KEY", database: { host: "localhost", user: "root", password: "", database: "empty_database", charset: "utf8mb4_unicode_ci", multipleStatements: true } };
const fs = require("fs");

const readline = require('readline');

const question = function (q) {

    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    var response;

    rl.setPrompt(q);
    rl.prompt();

    return new Promise((resolve, reject) => {

        rl.on('line', (userInput) => {
            response = userInput;
            rl.close();
        });

        rl.on('close', () => {
            resolve(response);
        });

    });


};

async function Start() {
    try {
        console.log("Executing npm update. Depending on your connection, this might take some time...");

        //var execNpmUpdate = await execAsync("npm update");
        const execNpmUpdate = spawn(/^win/.test(process.platform) ? "npm.cmd" : "npm", ["update"], { stdio: [process.stdin, process.stdout, process.stderr] });

        await onExit(execNpmUpdate);

        console.log("\n**[Discord-Bot-RPG Setup]**\n");

        console.log("During this setup you will be asked a series of questions.\nAnswer these questions by entering the values corresponding to your local setup.\nThe questions have a default value in brackets, if you press the enter key without answering the question, this default value will be taken.");

        // Env setup
        await EnvironmentSetup();

        // Database
        await DatabaseFIllInformations();

        // Register key for new users
        await RegisterKeySetup();

        // Save to file, then test database connection
        fs.writeFileSync("./conf/conf.js", "const conf=" + JSON.stringify(conf).replace(/"([^"]+)":/g, '$1:') + ";module.exports=conf;");

        await DatabaseSetup();

        await question("Finished...");

    } catch (ex) {
        await question("An error has occurred: " + ex);
    }

    process.exit(0);

}

async function EnvironmentSetup() {
    console.log("\n[Setting up the environment]");
    conf.env = await question("Environment [dev or prod] (dev): ");
    conf.env = conf.env === "" || conf.env !== "prod" ? "dev" : "prod";
}

async function RegisterKeySetup() {
    console.log("\n[Setting up the register key]");
    console.log("The server part interfaces with the bot part via an api. When a new user uses the bot, a message is sent to the api containing a key, it is this key that will allow to create users.\nIt must be the same on the bot side.");
    conf.registerkey = await question("Register Key (DEFAULT_KEY): ");
    conf.registerkey = conf.registerkey === "" ? "DEFAULT_KEY" : conf.registerkey;
}

async function DatabaseFIllInformations() {
    console.log("\n[Setting up the database]");

    conf.database.host = await question("Database host (localhost): ");
    conf.database.host = conf.database.host === "" ? "localhost" : conf.database.host;

    conf.database.user = await question("Database user (discord_bot_rpg): ");
    conf.database.user = conf.database.user === "" ? "discord_bot_rpg" : conf.database.user;

    conf.database.password = await question("Database user password (): ");

    conf.database.database = await question("Database name (discord_bot_rpg): ");
    conf.database.database = conf.database.database === "" ? "discord_bot_rpg" : conf.database.database;
}

async function DatabaseSetup() {
    console.log("Starting database connection test...");
    const mysql = require("./conf/mysql.js");

    if ((await mysql.query("SELECT version()")).length === 0) {
        throw "Unable to connect to database";
    }


    console.log("Test successful.");

    console.log("Executing database first initialization...");

    //console.log(fs.readFileSync("./init.sql", "utf-8"));
    await mysql.query(fs.readFileSync("./init.sql", "utf-8"));

    console.log("Database is set up successfuly!");
}

function onExit(childProcess) {
    return new Promise((resolve, reject) => {
        childProcess.once('exit', (code, signal) => {
            if (code === 0) {
                resolve(undefined);
            } else {
                reject(new Error('Exit with error code: ' + code));
            }
        });
        childProcess.once('error', (err) => {
            reject(err);
        });
    });
}

Start();


