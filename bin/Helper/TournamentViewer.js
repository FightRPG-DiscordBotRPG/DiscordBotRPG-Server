const Globals = require("../Globals");

class TournamentViewer {
    toHtml() {
        return `<head>
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
                        <link href='https://cdn.fight-rpg.com/css/tournament.css' rel='stylesheet' type='text/css'>
                        <link rel="icon" href="https://cdn.fight-rpg.com/images/frpg_favicon.ico" />
                        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
                        <script src='https://cdn.fight-rpg.com/js/tournament.js?v=3'></script>
                        <!--<script src='http://localhost/cdn//tournament.js?v=2'></script>-->


                        <title>FightRPG - Tournaments</title>
                    </head>

                    <body>
                        <header class="hero">
                            <div class="hero-wrap">
                                <div class="flex-container flex-space">
                                    <p class="intro" id="intro">Fight RPG</p>
                                    <h1 id="headline">Tournament</h1>
                                    <p class="year"><i class="fa fa-star"></i><span id='date'>00/00/0000</span> <i class="fa fa-star"></i>
                                    </p>
                                </div>
                                <div class="flex-container flex-space">
                                    <p id="area">Lyrial Dead End</p>
                                    <p>Participants: <span id='participants'>0</span></p>
                                </div>

                                <div class='flex-container'>
                                    <button class='button-menu' onclick="showHtmlList()">Main menu</button>
                                    <button class='button-menu' onclick="reload()">Refresh</button>
                                </div>
                            </div>  
                        </header>   
                        <p id='areaslist'>
                            ${Array.from(Globals.areasManager.areas.keys()).join(",")}
                        </p>
                        <main></main></body>`;
    }

}


module.exports = TournamentViewer