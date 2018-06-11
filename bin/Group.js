'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Translator = require("./Translator/Translator");
const Discord = require("discord.js");

var nextID = 0;

class Group {

	constructor(leader) {
		leader.pendingPartyInvite = null;
		this.id = nextID;
		nextID++;
        this.players = {};
        this.pendingPlayers = {};
		this.leader = leader;
		this.doingSomething = false;
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
            discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.getLang(), "group", "someone_left_the_group", [player.username]))
        }


		// Send to rest of group
		for (let user in this.players) {
            user = this.players[user];
            if (!user.isGroupMuted()) {
                discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "group", "someone_left_the_group", [player.username]))
            }
		}
	}

	playerJoinedBroadcast(player, discordClient) {
		// Send to leader
        if (!this.leader.isGroupMuted()) {
            discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.getLang(), "group", "someone_joined_the_group", [player.username]))
        }
		// Send to rest of group
		for (let user in this.players) {
            user = this.players[user];
            if (!user.isGroupMuted()) {
                discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "group", "someone_joined_the_group", [player.username]))
            }
		}
	}

    playerDeclinedBroadcast(player, discordClient) {
        if (!this.leader.isGroupMuted()) {
            discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.getLang(), "group", "someone_declined_invitation", [player.username]))
        }
    }

    playerKickedBroadcast(player, discordClient) {
        for (let user in this.players) {
            user = this.players[user];
            if (user == player) {
                discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "group", "you_ve_been_kicked"));
            } else {
                if (!user.isGroupMuted()) {
                    discordClient.users.get(user.id).send(Translator.getString(user.getLang(), "group", "user_kicked", [player.username]))
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
            invitedPlayers += "- Personne n'a été invité à rejoindre votre groupe";
        }

        invitedPlayers += "```";



        let embed = new Discord.RichEmbed()
            .setColor([0, 127, 255])
            .setAuthor("Groupe | Level moyen : 20 | iLvl moyen : 199", "http://www.cdhh.fr/wp-content/uploads/2012/04/icon_groupe2.jpg")
            .addField("Membres du groupe (" + this.nbOfPlayers() + " / 5)", membersOfGroup)
            .addField("Utilisateurs invités (" + this.nbOfInvitedPlayers() + " / 5)", invitedPlayers)
            ;

        return embed;
    }




}

module.exports = Group;
