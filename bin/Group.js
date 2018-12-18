'use strict';
const Globals = require("./Globals.js");
const Translator = require("./Translator/Translator");
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
        /**
         * @type {User}
         */
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
            avgLevel += this.players[user].character.getLevel();
        }
        return Math.round(avgLevel / this.nbOfPlayers());
    }

    getHighestLevel() {
        let highestLevel = this.leader.character.getLevel();
        for (let user in this.players) {
            if (this.players[user].character.getLevel() > highestLevel) {
                highestLevel = this.players[user].character.getLevel();
            }
        }
        return highestLevel;
    }

    async getAveragePower() {
        let avgPower = await this.leader.character.getPower();
        for (let user in this.players) {
            avgPower = await this.players[user].character.getPower();
        }
        return Math.round(avgPower / this.nbOfPlayers());
    }

    exist() {
        if (this.players == null || this.leader == null) {
            return false;
        }
        return true;
    }

    addPlayer(player) {
        this.playerJoinedBroadcast(player);
        player.character.pendingPartyInvite = null;
        delete this.pendingPlayers[player.id];
        this.players[player.id] = player;
        player.character.group = this;

    }

    kick(playername) {
        for (let user in this.players) {
            user = this.players[user];
            if (user.username == playername) {
                // Make sure it leaves the group
                user.character.leaveGroup();
                this.playerKickedBroadcast(user);
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

    swap(playername) {
        if (playername != this.leader.getUsername()) {
            for (let user in this.players) {
                if (playername == this.players[user].getUsername()) {
                    let oldLeader = this.leader;
                    this.leader = this.players[user];
                    delete this.players[user];
                    this.players[oldLeader.getUserId()] = oldLeader;
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 
     * @param {User} player 
     */
    playerLeave(player) {
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
            this.playerLeaveBroadcast(player);
            //console.log(this);
        } else {
            this.disband();
        }

    }

    playerLeaveBroadcast(player) {
        // Send to leader
        this.leader.groupTell(Translator.getString(this.leader.getLang(), "group", "someone_left_the_group", [player.username]));

        // Send to rest of group
        for (let user in this.players) {
            this.players[user].groupTell(Translator.getString(this.players[user].getLang(), "group", "someone_left_the_group", [player.username]));
        }
    }

    playerJoinedBroadcast(player) {
        // Send to leader
        this.leader.groupTell(Translator.getString(this.leader.getLang(), "group", "someone_joined_the_group", [player.username]));
        // Send to rest of group
        for (let user in this.players) {
            this.players[user].groupTell(Translator.getString(this.players[user].getLang(), "group", "someone_joined_the_group", [player.username]));
        }
    }

    playerDeclinedBroadcast(player) {
        this.leader.groupTell(Translator.getString(this.leader.getLang(), "group", "someone_declined_invitation", [player.username]));
    }

    playerKickedBroadcast(player) {
        for (let user in this.players) {
            user = this.players[user];
            if (user == player) {
                user.groupTell(Translator.getString(user.getLang(), "group", "you_ve_been_kicked"))
            } else {
                user.groupTell(Translator.getString(user.getLang(), "group", "user_kicked", [player.username]));
            }
        }
    }

    async toApi() {
        let members = [];
        for (let user in this.players) {
            members.push(await this.players[user].character.toApiSimple());
        }

        let invitedPlayers = [];
        for (let user in this.pendingPlayers) {
            invitedPlayers.push(await this.pendingPlayers[user].character.toApiSimple())
        }

        return {
            leader: await this.leader.character.toApiSimple(),
            members: members,
            invitedPlayers: invitedPlayers,
            avgPower: await this.getAveragePower(),
            numberOfPlayers: this.nbOfPlayers(),
            numberOfInvitedPlayers: this.nbOfInvitedPlayers(),
        }
    }

    async fightEndBoardcast(summary) {
        if (summary.winner == 0) {
            let str = "";

            //Send to leader
            if (!this.leader.isGroupMuted()) {
                str += Translator.getString(this.leader.getLang(), "fight_pve", "group_pm_won_fight") + "\n";
                str += Translator.getString(this.leader.getLang(), "fight_pve", "group_pm_gain", [summary.xpGained[this.leader.username], summary.goldGained[this.leader.username]]) + "\n";

                let drop_string = "<:treasure:403457812535181313>  ";
                let equipDrop = 0;
                let otherDrop = 0;
                let strEquipments = "";
                let strOthers = "";
                let allDrops = {};
                for (let personLoot of summary.drops) {
                    if (personLoot.name == this.leader.username) {
                        allDrops = personLoot.drop;
                        break;
                    }
                }

                for (let drop in allDrops) {
                    let rname = Translator.getString(this.leader.getLang(), "rarities", Globals.getRarityName(drop));
                    if (allDrops[drop].equipable > 0) {
                        strEquipments += rname + ": " + allDrops[drop].equipable + ", ";
                        equipDrop += allDrops[drop].equipable;
                    }
                    if (allDrops[drop].other > 0) {
                        otherDrop += allDrops[drop].other;
                        strOthers += rname + ": " + allDrops[drop].other + ", ";
                    }
                }

                if (strEquipments != "") {
                    strEquipments = strEquipments.slice(0, -2);
                    drop_string += Translator.getString(this.leader.getLang(), "fight_pve", equipDrop > 1 ? "drop_item_equip_plur" : "drop_item_equip", [strEquipments]) + "\n";
                }
                if (strOthers != "") {
                    strOthers = strOthers.slice(0, -2);
                    drop_string += Translator.getString(this.leader.getLang(), "fight_pve", otherDrop > 1 ? "drop_item_other_plur" : "drop_item_other", [strOthers]) + "\n";
                }

                if (equipDrop > 0 || otherDrop > 0) {
                    str += drop_string;
                }

                this.leader.groupTell(str);

            }

            // Send to rest of group
            for (let user in this.players) {
                user = this.players[user];
                if (!user.isGroupMuted()) {
                    str = "";
                    str += Translator.getString(user.getLang(), "fight_pve", "group_pm_won_fight") + "\n";
                    str += Translator.getString(user.getLang(), "fight_pve", "group_pm_gain", [summary.xpGained[user.username], summary.goldGained[user.username]]) + "\n";

                    let drop_string = "<:treasure:403457812535181313>  ";
                    let equipDrop = 0;
                    let otherDrop = 0;
                    let strEquipments = "";
                    let strOthers = "";
                    let allDrops = {};
                    for (let personLoot of summary.drops) {
                        if (personLoot.name == user.username) {
                            allDrops = personLoot.drop;
                            break;
                        }
                    }

                    for (let drop in allDrops) {
                        let rname = Translator.getString(user.getLang(), "rarities", Globals.getRarityName(drop));
                        if (allDrops[drop].equipable > 0) {
                            strEquipments += rname + ": " + allDrops[drop].equipable + ", ";
                            equipDrop += allDrops[drop].equipable;
                        }
                        if (allDrops[drop].other > 0) {
                            otherDrop += allDrops[drop].other;
                            strOthers += rname + ": " + allDrops[drop].other + ", ";
                        }
                    }

                    if (strEquipments != "") {
                        strEquipments = strEquipments.slice(0, -2);
                        drop_string += Translator.getString(user.getLang(), "fight_pve", equipDrop > 1 ? "drop_item_equip_plur" : "drop_item_equip", [strEquipments]) + "\n";
                    }
                    if (strOthers != "") {
                        strOthers = strOthers.slice(0, -2);
                        drop_string += Translator.getString(user.getLang(), "fight_pve", otherDrop > 1 ? "drop_item_other_plur" : "drop_item_other", [strOthers]) + "\n";
                    }

                    if (equipDrop > 0 || otherDrop > 0) {
                        str += drop_string;
                    }

                    user.groupTell(str);
                }
            }
        } else {
            this.leader.groupTell(Translator.getString(this.leader.getLang(), "fight_pve", "group_pm_lost_fight"));
            // Send to rest of group
            for (let user in this.players) {
                user = this.players[user];
                user.groupTell(Translator.getString(user.getLang(), "fight_pve", "group_pm_lost_fight"));
            }

        }

    }


}

module.exports = Group;