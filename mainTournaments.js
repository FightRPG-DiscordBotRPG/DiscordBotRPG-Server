const conn = require("./conf/mysql");
const AreaTournament = require("./bin/AreaTournament/AreaTournament");

let res = conn.query("SELECT idArea FROM areas");

var tournaments = {};

for(let area of res) {
    tournaments[area.idArea] = new AreaTournament(area.idArea);
    tournaments[area.idArea].scheduleTournament();
}
