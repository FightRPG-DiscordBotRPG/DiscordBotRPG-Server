'use strict';
const conn = require("../conf/mysql.js");
const Globals = require("./Globals.js");
const Translator = require("./Translator/Translator");

var nextID = 0;

class Group {

	constructor(leader) {
		leader.pendingPartyInvite = null;
		this.id = nextID;
		nextID++;
		this.players = {};
		this.leader = leader;
		this.doingSomething = false;
	}

	invite(player) {
		player.character.pendingPartyInvite = this;
	}

	nbOfPlayers() {
		return Object.keys(this.players).length + 1;
	}

	isFull() {
		return Object.keys(this.players).length + 1 >= 5 ? true : false;
	}

	addPlayer(player, discordClient) {
		this.playerJoinedBroadcast(player, discordClient);
		player.character.pendingPartyInvite = null;
		this.players[player.id] = player;
		player.character.group = this;

	}

	disband() {
		this.leader.character.leaveGroup();
		for (let user in this.players) {
			this.players[user].character.leaveGroup();
		}

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

	debug() {
		for (let user in this.players) {
			console.log(user);
		}
	}

	playerLeaveBroadcast(player, discordClient) {
		// Send to leader
		discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.lang, "group", "someone_left_the_group", [player.username]))

		// Send to rest of group
		for (let user in this.players) {
			user = this.players[user];
			discordClient.users.get(user.id).send(Translator.getString(user.lang, "group", "someone_left_the_group", [player.username]))
		}
	}

	playerJoinedBroadcast(player, discordClient) {
		// Send to leader
		discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.lang, "group", "someone_joined_the_group", [player.username]))

		// Send to rest of group
		for (let user in this.players) {
			user = this.players[user];
			discordClient.users.get(user.id).send(Translator.getString(user.lang, "group", "someone_joined_the_group", [player.username]))
		}
	}

	playerDeclinedBroadcast(player, discordClient) {
		discordClient.users.get(this.leader.id).send(Translator.getString(this.leader.lang, "group", "someone_declined_invitation", [player.username]))
	}




}

module.exports = Group;
