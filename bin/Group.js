'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Translator = require("./Translator/Translator");
const Discord = require("discord.js");
const User = require("./User");

var nextID = 0;

class Group {

	constructor(leader) {
		leader.pendingPartyInvite = null;
		this.id = nextID;
        nextID++;
        /**
         * @type {Array<User>}
         */
        this.players = {};
        /**
         * @type {Array<User>}
         */
        this.pendingPlayers = {};
		this.leader = leader;
		this.doingSomething = false;
    }

    allInSameArea() {
        for (let i in this.players) {
            if (this.players[i].character.getArea() != this.leader.character.getArea()) {
                return false;
            }
        }
        return true;
    }

    getArrayOfPlayers() {
        let arrPlayers = [];
        for (let i in this.players) {
            arrPlayers.push(this.players[i]);
        }
        arrPlayers.push(this.leader);
        return arrPlayers;
    }

    getArrayOfCharacters() {
        let arrCharacters = [];
        for (let i in this.players) {
            arrCharacters.push(this.players[i].character);
        }
        arrCharacters.push(this.leader.character);
        return arrCharacters;
    }

    getUsersIDsExceptLeader() {
        let arr = [];
        for (let i in this.players) {
            arr.push(this.players[i].id);
        }
        return arr;
    }

	invite(player) {
        player.character.pendingPartyInvite = this;
        this.pendingPlayers[player.id] = player;
	}

	nbOfPlayers() {
		return Object.keys(this.players).length + 1;
    }

    nbOfInvitedPlayers() {
        return Object.keys(this.pendingPlayers).length;
    }

	isFull() {
		return Object.keys(this.players).length + 1 >= 5;
    }

    isMaxInvitationsReached() {
        return Object.keys(this.pendingPlayers).length > 5;
    }

    getAverageLevel() {
        let avgLevel = this.leader.character.getLevel();
        for (let user in this.players) {
            user = this.players[user].character;
            avgLevel += user.getLevel();
        }
        return Math.round(avgLevel / this.nbOfPlayers());
    }

    getAveragePower() {
        let avgPower = this.leader.character.getPower();
        for (let user in this.players) {
            user = this.players[user].character;
            avgPower += user.getPower();
        }
        return Math.round(avgPower / this.nbOfPlayers());
    }

    exist() {
        if (this.players == null || this.leader == null) {
            return false;
        }
        return true;
    }

	addPlayer(player, discordClient) {
		this.playerJoinedBroadcast(player, discordClient);
        player.character.pendingPartyInvite = null;
        delete this.pendingPlayers[player.id];
		this.players[player.id] = player;
		player.character.group = this;

    }

    kick(playername, discordClient) {
        for (let user in this.players) {
            user = this.players[user];
            if (user.username == playername) {
                // Make sure it leaves the group
                user.character.leaveGroup();
                this.playerKickedBroadcast(user, discordClient);
                delete this.players[user.id];
                return true;
            }
        }
        return false;
    }

    cancelInvite(playername) {
        for (let user in this.pendingPlayers) {
            user = this.pendingPlayers[user];
            if (user.username == playername) {
                user.character.pendingPartyInvite = null;
                delete this.pendingPlayers[user.id];
                return true;
            }
        }
        return false;
    }



	disband() {
		this.leader.character.leaveGroup();
		for (let user in this.players) {
            this.players[user].character.leaveGroup();
        }
        for (let user2 in this.pendingPlayers) {
            this.pendingPlayers[user2].character.pendingPartyInvite = null;
        }
        this.pendingPlayers = null;
		this.players = null;
		this.leader = null;
		//console.log(this);
	}

	playerLeave(player, discordClient) {
		if (this.nbOfPlayers() > 1) {
			// Make character leave group
			//console.log(this.players);
			player.character.leaveGroup();
			if (player === this.leader) {
				// Set new leader and remvoe from list of players
				let newLeader = Object.keys(this.players)[0];
				this.leader = this.players[newLeader];
				delete this.players[newLeader];
			} else {
				// Delete from list of players
				delete this.players[player.id];
			}
			this.playerLeaveBroadcast(player, discordClient);
			//console.log(this);
		} else {
			this.disband();
		}

	}

	playerLeaveBroadcast(player, discordClient) {
		// Send to leader
        if (!this.leader.isGroupMuted()) {
            discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.getLang(), "group", "someone_left_the_group", [player.username]));
        }


		// Send to rest of group
		for (let user in this.players) {
            user = this.players[user];
            if (!user.isGroupMuted()) {
                discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "group", "someone_left_the_group", [player.username]));
            }
		}
	}

	playerJoinedBroadcast(player, discordClient) {
		// Send to leader
        if (!this.leader.isGroupMuted()) {;
            discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.getLang(), "group", "someone_joined_the_group", [player.username]));
        }
		// Send to rest of group
		for (let user in this.players) {
            user = this.players[user];
            if (!user.isGroupMuted()) {
                discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "group", "someone_joined_the_group", [player.username]));
            }
		}
	}

    playerDeclinedBroadcast(player, discordClient) {
        if (!this.leader.isGroupMuted()) {
            discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.getLang(), "group", "someone_declined_invitation", [player.username]));
        }
    }

    playerKickedBroadcast(player, discordClient) {
        for (let user in this.players) {
            user = this.players[user];
            if (user == player) {
                discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "group", "you_ve_been_kicked"));
            } else {
                if (!user.isGroupMuted()) {
                    discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "group", "user_kicked", [player.username]));
                }
            }
        }
    }

    toStr(lang) {
        let membersOfGroup = "```diff\n";
        membersOfGroup += "+ " + this.leader.character.toStrSimple() + "\n";
        for (let user in this.players) {
            user = this.players[user];
            membersOfGroup += "+ " + user.character.toStrSimple() + "\n";
        }
        membersOfGroup += "```";

        let invitedPlayers = "```diff\n";
        if (this.nbOfInvitedPlayers() > 0) {
            for (let user in this.pendingPlayers) {
                user = this.pendingPlayers[user];
                invitedPlayers += "+ " + user.character.toStrSimple() + "\n";
            }
        } else {
            invitedPlayers += "- " + Translator.getString(lang, "group", "nobody_was_invited");
        }

        invitedPlayers += "```";



        let embed = new Discord.RichEmbed()
            .setColor([0, 127, 255])
            .setAuthor(Translator.getString(lang, "group", "group") + " | " + Translator.getString(lang, "group", "avg_level", [this.getAverageLevel()]) + " | " + Translator.getString(lang,"group","avg_power", [this.getAveragePower()]), "http://www.cdhh.fr/wp-content/uploads/2012/04/icon_groupe2.jpg")
            .addField(Translator.getString(lang, "group", "members_of_the_group") + " (" + this.nbOfPlayers() + " / 5)", membersOfGroup)
            .addField(Translator.getString(lang, "group", "invited_users") + " (" + this.nbOfInvitedPlayers() + " / 5)", invitedPlayers)
            ;

        return embed;
    }

    fightEndBoardcast(discordClient, summary) {
        if (summary.winner == 0) {
            let str = "";

            //Send to leader
            if (!this.leader.isGroupMuted()) {
                str += Translator.getString(this.leader.getLang(), "fight_pve", "group_pm_won_fight") + "\n";
                str += Translator.getString(this.leader.getLang(), "fight_pve", "group_pm_gain", [summary.xpGained[this.leader.username], summary.goldGained[this.leader.username]]) + "\n";
                let drops = {};
                for (let i in summary.drops) {
                    if (summary.drops[i].name == this.leader.username) {
                        if (drops[summary.drops[i].drop]) {
                            drops[summary.drops[i].drop].number++;
                        } else {
                            drops[summary.drops[i].drop] = { number: 1 };
                        }
                    }
                }

                if (Object.keys(drops).length > 0) {
                    let dropsStr = "";
                    for (let i in drops) {
                        dropsStr += Translator.getString(this.leader.getLang(), "rarities", i) + "(" + drops[i].number + ") ";
                    }
                    str += Translator.getString(this.leader.getLang(), "fight_pve", "group_pm_gain_other", [dropsStr]);
                }


                discordClient.users.get(this.leader.id).send(str);
            }

            // Send to rest of group
            for (let user in this.players) {
                user = this.players[user];
                if (!user.isGroupMuted()) {
                    str = "";
                    str += Translator.getString(user.getLang(), "fight_pve", "group_pm_won_fight") + "\n";
                    str += Translator.getString(user.getLang(), "fight_pve", "group_pm_gain", [summary.xpGained[user.username], summary.goldGained[user.username]]) + "\n";
                    let drops = {};
                    for (let i in summary.drops) {
                        if (summary.drops[i].name == user.username) {
                            if (drops[summary.drops[i].drop]) {
                                drops[summary.drops[i].drop].number++;
                            } else {
                                drops[summary.drops[i].drop] = { number: 1 };
                            }
                        }
                    }

                    if (Object.keys(drops).length > 0) {
                        let dropsStr = "";
                        for (let i in drops) {
                            dropsStr += Translator.getString(user.getLang(), "rarities", i) + "(" + drops[i].number + ") ";
                        }
                        str += Translator.getString(user.getLang(), "fight_pve", "group_pm_gain_other", [dropsStr]);
                    }


                    discordClient.users.get(user.id).send(str);
                }
            }
        } else {
            if (!this.leader.isGroupMuted()) {
                discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.getLang(), "fight_pve", "group_pm_lost_fight"));
            }
            // Send to rest of group
            for (let user in this.players) {
                user = this.players[user];
                if (!user.isGroupMuted()) {
                    discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "fight_pve", "group_pm_lost_fight"));
                }
            }
        }

    }




}

module.exports = Group;
