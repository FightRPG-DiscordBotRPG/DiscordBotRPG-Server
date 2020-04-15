const axios = require('axios');
const conn = require("../../conf/mysql");

class TournamentViewer {
    async toHtml(lang = "en") {
        let html = `<head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
        <link href='https://fonts.googleapis.com/css?family=Holtwood+One+SC' rel='stylesheet' type='text/css'>
        <link href='https://fonts.googleapis.com/css?family=Kaushan+Script|Herr+Von+Muellerhoff' rel='stylesheet'
            type='text/css'>
        <link href='https://fonts.googleapis.com/css?family=Abel' rel='stylesheet' type='text/css'>
        <link href='https://fonts.googleapis.com/css?family=Istok+Web|Roboto+Condensed:700' rel='stylesheet'
            type='text/css'>
        <link href='http://localhost/cdn/tournament.css' rel='stylesheet' type='text/css'>


        <title>March Madness Stock Matchup</title>
        </head>

        <body>`;

        //let res = await conn.query("SELECT idArea FROM areas");
        //for (let area of res) {
        //    html += this.buildHtmlForThisArea(area.idArea, lang);
        //}

        html += await this.buildHtmlForThisArea(1);


        html += "</body>";

        return html;
    }

    /**
     * 
     * @param {number} idArea
     * @param {string} lang
     */
    async buildHtmlForThisArea(idArea, lang = "en") {
        try {
            let request = await axios.default.get(`https://cdn.fight-rpg.com/frpg-tournaments-datas/${idArea}.json `);
            if (request.status !== 200) return "";
            let data = request.data;
            let rounds = data.rounds;

            let numberOfParticipants = 0;
            let date = new Date(Date.now());
            let errorHtml = "";

            if (Object.keys(rounds).length > 0) {
                numberOfParticipants = rounds[Object.keys(rounds)[0]].initialGuilds.length;
                date = new Date(data.date);
            }

            let html = `<header class="hero">
                            <div class="hero-wrap">
                                <p class="intro" id="intro">Fight RPG</p>
                                <h1 id="headline">Tournament</h1>
                                <p class="year"><i class="fa fa-star"></i> ${date.toLocaleString('en-EN').split(',')[0]} <i class="fa fa-star"></i></p>
                                <p>Participants: ${numberOfParticipants}</p>
                            </div>
                        </header>
                    <div class='tournament'>`

            //let reverseKeys = Object.keys(request.data).reverse();
            //for (let roundIndex in reverseKeys) {
            //    let round = request.data[reverseKeys[roundIndex]];
            //    console.log(round);
            //    for (let index in round.guildsPlacements) {
            //        console.log(index);
            //        html += await this.getHtmlForOneFight(round.guildsPlacements[index], round.winners[index]);
            //    }
            //}

            for (let idRound of Object.keys(rounds)) {
                let round = rounds[idRound];
                html += "<div>";
                for (let indexDuo in round.guildsPlacements) {
                    let duo = round.guildsPlacements[indexDuo];

                    let isFirstWinner = round.winners.includes(duo[0]);
                    let firstColor = isFirstWinner ? "win" : "loose";
                    let secondColor = !isFirstWinner ? "win" : "loose";

                    html += `<div>
                                <ul>
                                    <li class='${firstColor}'>${round.guildsPlacementsNames[indexDuo][0]}</li>
                                    <li class='${secondColor}'>${round.guildsPlacementsNames[indexDuo][1]}</li>
                                </ul>
                            </div>`

                }

                html += "</div>";
             
            }

            return html;
        } catch (e) {
            console.log(e);
            return e;
        }
    }

    async getHtmlForOneRound(round) {

    }
}


module.exports = TournamentViewer