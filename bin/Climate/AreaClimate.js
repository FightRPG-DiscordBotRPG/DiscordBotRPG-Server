const conn = require("../../conf/mysql");
const Weather = require("./Weather");
const Climate = require("./Climate");

class AreaClimate {
    constructor(id) {
        this.id = id;
        /**
        * @type {Climate}
        */
        this.climate = null;
        /**
        * @type {Weather}
        */
        this.currentWeather = null;
        this.intensity = 1;
    }

    async load() {
        const res = (await conn.query("SELECT * FROM areasclimates WHERE idArea = ?;", [this.id]))[0];
        this.climate = new Climate(res.idClimate);
        this.currentWeather = new Weather(res.currentWeather);
        this.intensity = res.intensity / 100;

        await Promise.all([this.climate.load(), this.currentWeather.load()]);
    }

}

module.exports = AreaClimate;