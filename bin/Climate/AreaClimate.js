const conn = require("../../conf/mysql");
const Weather = require("./Weather");
const Climate = require("./Climate");
const Globals = require("../Globals");

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
        this.dateNextWeatherChange = new Date();
    }

    async load() {
        const res = (await conn.query("SELECT * FROM areasclimates WHERE idArea = ?;", [this.id]))[0];
        this.climate = new Climate(res.idClimate);
        this.currentWeather = new Weather(res.currentWeather);
        this.intensity = res.intensity / 100;

        await Promise.all([this.climate.load(), this.currentWeather.load()]);
        this.scheduleNextWeatherChange();
    }

    changeWeather() {
        this.currentWeather = this.climate.getRandomWeather();
        conn.query("UPDATE areasclimates SET currentWeather = ? WHERE idArea = ?;", [this.currentWeather.id, this.id]);
        //if (this.weather.shorthand != "sunny") {
        //    console.log(this.weather.shorthand);
        //}
    }

    scheduleNextWeatherChange() {
        let delay = (Math.random() * (Globals.weather.maxBeforeChange - Globals.weather.minBeforeChange) + Globals.weather.minBeforeChange) * 60000;
        setTimeout(() => this.changeWeather(), delay);
        this.dateNextWeatherChange = new Date(Date.now() + delay);
    }

}

module.exports = AreaClimate;