const conf = require("../conf/conf");

class Emojis {
    static getID(emojiName) {
        if(conf.env === "prod") {
            return Emojis.emojisProd[emojiName].id;
        } else {
            return Emojis.emojisDev[emojiName].id;
        }
    }

    static getString(emojiName) {
        if(conf.env === "prod") {
            return Emojis.emojisProd[emojiName].string;
        } else {
            return Emojis.emojisDev[emojiName].string;
        }
    }
}

Emojis.emojisProd = {
    "vmark" : {id : "314349398811475968", string: "<:check:314349398811475968>"},
    "xmark" : {id : "314349398824058880", string: "<:xmark:314349398824058880>"},
};
Emojis.emojisDev = {
    "vmark" : {id : "403148210295537664", string: ":vmark:"},
    "xmark" : {id : "403149357387350016", string: ":xmark:"},
};


module.exports = Emojis;