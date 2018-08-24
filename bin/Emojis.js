const conf = require("../conf/conf");

class Emojis {
    static getID(emojiName) {
        let em;
        if(conf.env === "prod") {
            em = Emojis.emojisProd[emojiName];
        } else {
            em = Emojis.emojisDev[emojiName];
        }
        return em != null ? em.id : Emojis.general[emojiName];
    }

    static getString(emojiName) {
        let em;
        if(conf.env === "prod") {
            em = Emojis.emojisProd[emojiName];
        } else {
            em = Emojis.emojisDev[emojiName];
        }
        return em != null ? em.string : Emojis.general[emojiName];
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

Emojis.general = {
    "one" : "1⃣",
    "two" : "2⃣",
    "three" : "3⃣",
    "four" : "4⃣",
    "five" : "5⃣",
    "six" : "6⃣",
    "seven" : "7⃣",
    "eight" : "8⃣",
    "nine" : "9⃣",
}

module.exports = Emojis;