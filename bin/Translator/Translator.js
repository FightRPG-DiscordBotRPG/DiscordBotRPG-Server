const fs = require("fs");
const util = require("util");
const conn = require("../../conf/mysql");

class Translator {
    
    /**
     * 
     * @param {String} lang 
     * @param {String} type 
     * @param {String} name 
     * @param {Array} args 
     * @returns {String} Translated String / Or null
     */
    static getString(lang, type, name, args, returnNull=false) {
        if (!this.translations[lang]) {
            lang = "en";
        }

        if (this.translations[lang][type] && this.translations[lang][type][name]) {
           
            args = Array.isArray(args) ? args : [];
            args.unshift(this.translations[lang][type][name]);
            return util.format.apply(util, args);
        }


        return returnNull ? null : lang + " | " + type + " | " + name;

    }

    /**
     * 
     * @param {String} lang 
     * @returns {boolean}
     */
    static isLangExist(lang) {
        return this.translations[lang] ? true : false
    }

    /**
     * 
     * @param {string} lang 
     * @returns {string} List of available language Localized
     */
    static getAvailableLanguages(lang) {
        let tr = "";
        let count = 0;
        for (let i in this.translations) {
            count++;
            tr += this.getString(lang, "languages", i) + " (" + i + ")" + (count == this.nbOfTranslations ? "" : ", ");
        }
        return tr;
    }

    static load(callback) {
        var self = this;
        fs.readdir(__dirname + "/locale", (err, filenames) => {
            if (!err) {
                for (let i of filenames) {
                    self.translations[i.split(".")[0]] = JSON.parse(fs.readFileSync(__dirname + "/locale/" + i));
                    self.nbOfTranslations++;
                }
                callback ? callback() : null;
            }
        })  
    }

    static loadSync() {
        var filenames = fs.readdirSync(__dirname + "/locale");
        for (let i of filenames) {
            this.translations[i.split(".")[0]] = JSON.parse(fs.readFileSync(__dirname + "/locale/" + i));
            this.nbOfTranslations++;
        }
    }

    static loadItemsBases() {
        let res = conn.query("SELECT * FROM localizationitems");
        let languages = conn.query("SELECT * FROM languages");
        for(let language of languages) {
            this.translations[language.lang]["itemsNames"] = {};
            this.translations[language.lang]["itemsDesc"] = {};
        }

        for(let trad of res) {
            this.translations[trad.lang]["itemsNames"][trad.idBaseItem] = trad.nameItem;
            this.translations[trad.lang]["itemsDesc"][trad.idBaseItem] = trad.descItem != "" ? trad.descItem : null;
        }
    }
}

Translator.translations = {};
Translator.nbOfTranslations = 0;
Translator.loadSync();
Translator.loadItemsBases();

module.exports = Translator;