// Alaways add the / at the end of url
const generalConf = require("./conf");

const conf = {
    "cdn_translator_url": generalConf.env === "dev" ? "https://cdn.fight-rpg.com/dev-localization/" : "https://cdn.fight-rpg.com/localization/",
}

module.exports = conf;