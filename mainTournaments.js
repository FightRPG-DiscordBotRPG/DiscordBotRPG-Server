const conn = require("./conf/mysql");
const AreaTournament = require("./bin/AreaTournament/AreaTournament");



/**
 * @type {Array<AreaTournament>}
 */
var tournaments = {};




async function startUp() {
    let res = await conn.query("SELECT idArea FROM areas");
    for (let area of res) {
        tournaments[area.idArea] = new AreaTournament(area.idArea);
        await tournaments[area.idArea].init();
        tournaments[area.idArea].scheduleTournament();
    }
}

startUp();