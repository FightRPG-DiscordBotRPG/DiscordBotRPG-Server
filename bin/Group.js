'use strict';
const User = require("./User");
const Globals = require("./Globals.js");
const Translator = require("./Translator/Translator");
const conn = require("../conf/mysql");

class Group {

    constructor() {
        /**
         * @type {Object<string, User>}
         */
        this.players = {};
        /**
         * @type {Object<string, User>}
         */
        this.pendingPlayers = {};
        /**
         * @type {User}
         */
        this.leader = null;
        this.doingSomething = false;
        this.exists = false;
    }

    /**
     * 
     * @param {string} idUser
     */
    async load(idUser, asPending=false) {

        const idUserLeader = await Group.getIdGroupLeader(idUser, asPending);
        if (idUserLeader === null) {
            return;
        }

        const res = await conn.query("SELECT * FROM groupsdata WHERE idUserLeader = ?;", [idUserLeader]);

        this.doingSomething = res[0].isDoingSomething;
        this.exists = true;

        if (idUserLeader == idUser) {
            this.leader = Globals.connectedUsers[idUser];
        } else {
            this.leader = new User(idUserLeader);
            this.leader.loadUser();
        }

        await Promise.all([this.loadMembers(), this.loadPending()]);

    }

    async loadMembers() {
        this.players = await Group.getPlayers(await conn.query("SELECT idUser FROM groupsplayers WHERE idUserLeader = ?;", [this.leader.id]));
    }

    async loadPending() {
        this.pendingPlayers = await Group.getPlayers(await conn.query("SELECT idUser FROM groupspendingplayers WHERE idUserLeader = ?;", [this.leader.id]));
    }

    async create(idUser) {
        await conn.query("REPLACE INTO groupsdata VALUES (?, false)", [idUser]);
    }

    static async getPlayers(arr) {
        const promises = [];
        const users = {};
        for (let item of arr) {
            let user = new User(item.idUser);
            users[user.id] = user;
            promises.push(user.loadUser());
        }

        await Promise.all(promises);
        return users;
    }


    static async getIdGroupLeader(idUser, asPending = false) {

        if (!asPending) {
            const res = await conn.query("SELECT * FROM groupsdata WHERE idUserLeader = ?;", [idUser]);
            if (res[0]) {
                return idUser;
            }
        }

        const resAsMember = asPending ? await conn.query("SELECT idUserLeader FROM groupspendingplayers WHERE idUser = ?;", [idUser]) : await conn.query("SELECT idUserLeader FROM groupsplayers WHERE idUser = ?;", [idUser]);
        if (resAsMember[0]) {
            return resAsMember[0].idUserLeader;
        }

        return null;
    }

    async allInSameArea() {
        for (let i in this.players) {
            if (await this.players[i].character.getArea() != await this.leader.character.getArea()) {
                return false;
            }
        }
        return true;
    }

    getTotalStat(statName = "strength") {
        return this.getArrayOfCharacters().reduce((acc, char) => {
            return acc + char.getStat(statName);
        }, 0);
    }

    getAverageTotalStat(statName = "strength") {
        return this.getTotalStat(statName) / this.nbOfPlayers();
    }

    getArrayOfPlayers() {
        let arrPlayers = [];
        arrPlayers.push(this.leader);
        for (let i in this.players) {
            arrPlayers.push(this.players[i]);
        }
        return arrPlayers;
    }

    getArrayOfCharacters() {
        let arrCharacters = [];
        arrCharacters.push(this.leader.character);
        for (let i in this.players) {
            arrCharacters.push(this.players[i].character);
        }
        return arrCharacters;
    }

    getUsersIDsExceptLeader() {
        let arr = [];
        for (let i in this.players) {
            arr.push(this.players[i].id);
        }
        return arr;
    }

    async invite(player) {
        await conn.query("REPLACE INTO groupspendingplayers VALUES (?,?);", [this.leader.id, player.id])
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

    getHighestRebirthLevel() {
        let rebirthLevel = this.leader.character.getRebirthLevel();
        for (let user in this.players) {
            if (this.players[user].character.getRebirthLevel() > rebirthLevel) {
                rebirthLevel = this.players[user].character.getRebirthLevel();
            }
        }
        return rebirthLevel;
    }

    async getAveragePower() {
        let avgPower = await this.leader.character.getPower();
        for (let user in this.players) {
            avgPower += await this.players[user].character.getPower();
        }
        return Math.round(avgPower / this.nbOfPlayers());
    }

    /**
     * 
     * @param {User} player
     */
    async addPlayer(player) {
        this.playerJoinedBroadcast(player);
        player.character.pendingPartyInvite = null;

        await Promise.all([
            conn.query("DELETE FROM groupspendingplayers WHERE idUser = ?;", [player.id]),
            conn.query("REPLACE INTO groupsplayers VALUES (?, ?);", [this.leader.id, player.id])
        ]);

        this.players[player.id] = player;
    }


    async kick(playername) {
        for (let idUser in this.players) {
            const user = this.players[idUser];
            if (user.username == playername) {
                // Make sure it leaves the group
                this.playerKickedBroadcast(user);
                await conn.query("DELETE FROM groupsplayers WHERE idUser = ?;", [user.id]);
                return true;
            }
        }
        return false;
    }

    async cancelInvite(playername) {
        for (let idUser in this.pendingPlayers) {
            const user = this.pendingPlayers[idUser];
            if (user.username == playername) {
                await conn.query("DELETE FROM groupspendingplayers WHERE idUser = ?;", [user.id]);
                return true;
            }
        }
        return false;
    }

    async disband() {
        await conn.query("DELETE FROM groupsplayers WHERE idUserLeader = ?;DELETE FROM groupspendingplayers WHERE idUserLeader = ?;DELETE FROM groupsdata WHERE idUserLeader = ?;", [this.leader.id, this.leader.id, this.leader.id]);
    }

    async swap(playername) {
        if (playername != this.leader.getUsername()) {
            for (let user in this.players) {
                if (playername == this.players[user].getUsername()) {

                    const newLeader = this.players[user];
                    const oldLeader = this.leader;

                    await conn.query(`
                        REPLACE INTO groupsdata VALUES (?, ?);
                        UPDATE groupsplayers SET idUserLeader = ? WHERE idUserLeader = ?;
                        UPDATE groupspendingplayers SET idUserLeader = ? WHERE idUserLeader = ?;
                        DELETE FROM groupsplayers WHERE idUser = ?;
                        DELETE FROM groupsdata WHERE idUserLeader = ?;
                        REPLACE INTO groupsplayers VALUES (?, ?);
                        `,
                        [
                            newLeader.id, false,
                            newLeader.id, oldLeader.id,
                            newLeader.id, oldLeader.id,
                            newLeader.id,
                            oldLeader.id,
                            newLeader.id, oldLeader.id,
                        ]
                    );
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
    async playerLeave(player) {
        if (this.nbOfPlayers() > 1) {
            // Make character leave group
            //console.log(this.players);
            if (player === this.leader) {
                // Set new leader and remvoe from list of players

                const newLeader = this.players[Object.keys(this.players)[0]];
                // Delete for broadcast and add
                delete this.players[newLeader];

                await this.swap(newLeader.username);

                this.leader = newLeader;

            } else {
                // Delete from list of players
            }
            await conn.query("DELETE FROM groupsplayers WHERE idUser = ?;", [player.id]);


            this.playerLeaveBroadcast(player);
        } else {
            await this.disband();
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

    /**
     * 
     * @param {User} player
     */
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

    // Function that checks if everyone is in the same map and make them travel to the same area if they are not
    //travelToGroupLeaderPosiiton() {
    //    let leader = this.leader;
    //    for (let id in this.players) {
    //        let user = this.players[id];
    //        if (user.character.getArea() != leader.character.getArea()) {
    //            user.character.travel(leader.character.getArea().id);
    //        }
    //    }
    //        //this.players[i].character.getArea() != this.leader.character.getArea()
    //}

    /**
     * 
     * @param {string} lang
     */
    async toApi(lang = "en") {
        let members = [];
        for (let user in this.players) {
            members.push(await this.players[user].character.toApiSimple(lang));
        }

        let invitedPlayers = [];
        for (let user in this.pendingPlayers) {
            invitedPlayers.push(await this.pendingPlayers[user].character.toApiSimple(lang))
        }

        return {
            leader: await this.leader.character.toApiSimple(lang),
            members: members,
            invitedPlayers: invitedPlayers,
            avgPower: await this.getAveragePower(),
            avgLevel: this.getAverageLevel(),
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


