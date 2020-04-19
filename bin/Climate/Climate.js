const conn = require("../../conf/mysql");
const Weather = require("./Weather");

class Climate {
    constructor(id) {
        this.id = id;
        this.shorthand = "";
        /**
         * @type {Array<ClimateWeather>} 
         */
        this.possibleWeathers = {};
    }


    async load() {
        let res = await conn.query("SELECT * FROM climatesweathers WHERE idClimate = ?;", [this.id])

        for (let item of res) {
            let newWeather = new Weather(item.idWeather);
            await newWeather.load();

            this.possibleWeathers[newWeather.id] = new ClimateWeather(newWeather, item.probability / 100);
        }

        this.shorthand = (await conn.query("SELECT * FROM climates WHERE idClimate = ?;", [this.id]))[0].shorthand;

    }

    /**
     * Get random weather based on probability of this weather occuring
     */
    getRandomWeather() {
        let rand = Math.random();
        /**
         *  @type {ClimateWeather}
         */
        let cWeather;
        for (cWeather of Object.values(this.possibleWeathers)) {
            if (cWeather.probability >= rand) {
                return cWeather.weather;
            } else {
                rand -= cWeather.probability;
            }
        }
    }

}

class ClimateWeather {

    /**
     * 
     * @param {Weather} weather
     * @param {number} probability (0 >= x < 1)
     */
    constructor(weather, probability) {
        this.weather = weather;
        this.probability = probability;
    }
}

module.exports = Climate;