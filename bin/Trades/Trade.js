const Item = require("../Items/Item.js");
const TradeItem = require("./TradeItem");
const Translator = require("../Translator/Translator");

class Trade {

    /**
     * 
     * @param {User} user 
     */
    constructor(user) {
        this.playerOne = user;
        this.playerTwo = null;

        /**
         * Items should be real ids
        */

        /**
         * @type {Array<TradeItem>}
         */
        this.itemsOne = [];
        /**
         * @type {Array<TradeItem>}
         */
        this.itemsTwo = [];

        // Stocking in 
        this.itemsOneIndexes = {};
        this.itemsTwoIndexes = {};

        this.moneyOne = 0;
        this.moneyTwo = 0;

        this.isValidatedByPlayerOne = false;
        this.isValidatedByPlayerTwo = false;

        /**
         * @type {User}
         */
        this.pendingProposal = null;

    }

    /**
     * 
     * @param {User} user 
     */
    propose(user) {
        user.character.pendingTradeInvite = this;
        this.pendingProposal = user;
    }

    isTradeOpen() {
        return this.playerTwo != null;
    }

    /**
     * 
     * @param {User} user 
     */
    accept(user) {
        this.playerOne.tradeTell(Translator.getString(this.playerOne.getLang(), "trade", "notification_accepted", [user.getUsername()]));
        user.character.pendingTradeInvite = null;
        this.pendingProposal = null;
        this.playerTwo = user;
        user.character.trade = this;
    }

    /**
     * 
     * @param {User} user 
     */
    cancel(user) {
        let userToNotifyWhoDontLeave;
        if (user == this.playerOne) {
            userToNotifyWhoDontLeave = this.playerTwo;
        } else {
            userToNotifyWhoDontLeave = this.playerOne;
        }
        if (userToNotifyWhoDontLeave != null) {
            userToNotifyWhoDontLeave.tradeTell(Translator.getString(userToNotifyWhoDontLeave.getLang(), "trade", "notification_cancelled", [user.getUsername()]));
            userToNotifyWhoDontLeave.character.trade = null;
        }
        if (this.pendingProposal != null) {
            this.pendingProposal.character.pendingTradeInvite = null;
        }
        user.character.trade = null;
    }

    async doTrade(playerNumber) {

        let promisesWait = [];

        /**
         * @type {User}
         */
        let playerLeft;
        /**
        * @type {User}
        */
        let playerRight;
        /**
         * @type {Array<TradeItem>}
         */
        let itemsLeft;

        let moneyLeft;

        if (playerNumber == 1) {
            playerLeft = this.playerOne;
            playerRight = this.playerTwo;
            itemsLeft = this.itemsOne;
            moneyLeft = this.moneyOne;
        } else {
            playerLeft = this.playerTwo;
            playerRight = this.playerOne;
            itemsLeft = this.itemsTwo;
            moneyLeft = this.moneyTwo;
        }


        // Items
        for (let tradeItem of itemsLeft) {
            let tradeOneItem = async () => {
                let leftInventory = playerLeft.character.getInv();
                let rightInventory = playerRight.character.getInv();
                // Get item from inventory of both
                let itemFromLeftPlayer = await leftInventory.getItemOfThisIDItem(tradeItem.id);

                if (itemFromLeftPlayer.isStackable() == false) {
                    // Don't delete the item
                    await leftInventory.removeSomeFromInventoryItem(itemFromLeftPlayer, tradeItem.number);
                    await rightInventory.addToInventory(tradeItem.id, tradeItem.number);
                } else {
                    let rightInventoryItemID = await rightInventory.getIdOfThisIdBase(itemFromLeftPlayer.idBaseItem, itemFromLeftPlayer.getLevel(), itemFromLeftPlayer.getRebirthLevel());
                    if (rightInventoryItemID != null) {
                        // The guy already have a similar item so delete if the left inventory have no more items
                        await leftInventory.removeSomeFromInventoryItem(itemFromLeftPlayer, tradeItem.number, true);
                        await rightInventory.addToInventory(rightInventoryItemID, tradeItem.number);
                    } else {
                        await leftInventory.removeSomeFromInventoryItem(itemFromLeftPlayer, tradeItem.number);
                        let newItemID = await Item.lightInsert(itemFromLeftPlayer.idBaseItem, itemFromLeftPlayer.level, 0, itemFromLeftPlayer.rebirthLevel);
                        await rightInventory.addToInventory(newItemID, tradeItem.number);
                    }
                }
            };
            promisesWait.push(tradeOneItem());
        }

        // Money
        promisesWait.push(playerLeft.character.removeMoney(moneyLeft));
        promisesWait.push(playerRight.character.addMoney(moneyLeft));

        await Promise.all(promisesWait);
    }



    /**
     * 
     * @param {User} user 
     */
    async validate(user) {
        let error, success = "";
        if (this.isTradeOpen()) {
            if (this.playerOne.character.getIdArea() === this.playerTwo.character.getIdArea()) {
                let userToNotifyWhoHaventValidateYet;
                if (user == this.playerOne) {
                    userToNotifyWhoHaventValidateYet = this.playerTwo;
                    this.isValidatedByPlayerOne = true;
                } else {
                    userToNotifyWhoHaventValidateYet = this.playerOne;
                    this.isValidatedByPlayerTwo = true;
                }


                if (this.isValidatedByPlayerOne === true && this.isValidatedByPlayerTwo === true) {

                    // You must check every single items and check if it's possible to do the trade, one missing item lead to invalidate the trade
                    if (await this.integrityCheck() === true) {
                        // Since we are modifying both inventories, to avoid any bugs we must wait the left to right trade, and then the right to left one.
                        await this.doTrade(1);
                        await this.doTrade(2)
                        userToNotifyWhoHaventValidateYet.tradeTell(Translator.getString(userToNotifyWhoHaventValidateYet.getLang(), "trade", "done"));

                        // remove the trade
                        if (this.pendingProposal != null) {
                            this.pendingProposal.character.pendingTradeInvite = null;
                        }
                        user.character.trade = null;
                        userToNotifyWhoHaventValidateYet.character.trade = null;

                        success = Translator.getString(user.getLang(), "trade", "done");
                    } else {
                        userToNotifyWhoHaventValidateYet.tradeTell(Translator.getString(userToNotifyWhoHaventValidateYet.getLang(), "errors", "trade_inventory_changed"));
                        this.isValidatedByPlayerOne = false;
                        this.isValidatedByPlayerTwo = false;
                        error = Translator.getString(user.getLang(), "errors", "trade_inventory_changed");
                    }

                } else {
                    //"The other player have validate the trade, awaiting your validation"
                    userToNotifyWhoHaventValidateYet.tradeTell(Translator.getString(userToNotifyWhoHaventValidateYet.getLang(), "trade", "notification_await_validation"));
                    success = Translator.getString(user.getLang(), "trade", "await_validation");
                }
            } else {
                error = Translator.getString(user.getLang(), "errors", "trade_not_in_same_area");
            }
        } else {
            error = Translator.getString(user.getLang(), "errors", "trade_not_accepted");
        }


        if (error) {
            return { error: error };
        } else {
            return { success: success };
        }


    }

    notifyAll(str) {
        this.playerOne.tradeTell(str);
        if (this.isTradeOpen()) {
            this.playerTwo.tradeTell(str);
        }
    }

    async integrityCheck() {
        if (!this.isTradeOpen()) {
            return false;
        }

        if (await this.playerOne.character.getMoney() < this.moneyOne || await this.playerTwo.character.getMoney() < this.moneyTwo) {
            return false;
        }

        for (let item of this.itemsOne) {
            if (await this.playerOne.character.getInv().isThisItemInInventory(item.id, item.number) === false) {
                return false;
            }
        }

        for (let item of this.itemsTwo) {
            if (await this.playerTwo.character.getInv().isThisItemInInventory(item.id, item.number) === false) {
                return false;
            }
        }

        return true;

    }

    unvalidate() {
        this.isValidatedByPlayerOne = false;
        this.isValidatedByPlayerTwo = false;
    }

    /**
     * 
     * @param {User} userWhoAdd 
     * @param {Integer} idEmplacement
     * This function is called by a player (userWhoAdd) and items is added relative to this player inventory
     * Returning errors or success messages
     */
    async addItem(userWhoAdd, idEmplacement = 0, number = 1) {

        idEmplacement = parseInt(idEmplacement);
        number = parseInt(number);
        number = number > 0 ? number : 1;
        let error = "", success = "";
        let pInv = userWhoAdd.character.getInv();
        if (this.isTradeOpen()) {
            if (await pInv.doIHaveThisItem(idEmplacement) === true) {
                let item = await pInv.getItem(idEmplacement);

                if (item.number >= number) {
                    let tdItem = new TradeItem(item.id, number);
                    if (this.playerOne == userWhoAdd) {
                        if (this.itemsOneIndexes[tdItem.id] != null) {
                            this.itemsOneIndexes[tdItem.id].number = tdItem.number;
                        } else {
                            this.itemsOne.push(tdItem);
                            this.itemsOneIndexes[tdItem.id] = this.itemsOne[this.itemsOne.length - 1];
                        }
                    } else {
                        if (this.itemsTwoIndexes[tdItem.id] != null) {
                            this.itemsTwoIndexes[tdItem.id].number = tdItem.number;
                        } else {
                            this.itemsTwo.push(tdItem);
                            this.itemsTwoIndexes[tdItem.id] = this.itemsTwo[this.itemsTwo.length - 1];
                        }
                    }
                    this.unvalidate();

                    let userToNotify;
                    if (userWhoAdd == this.playerOne) {
                        userToNotify = this.playerTwo;
                    } else {
                        userToNotify = this.playerOne;
                    }

                    userToNotify.tradeTell(Translator.getString(userToNotify.getLang(), "trade", "notification_add_item", [userWhoAdd.getUsername(), item.getName(userToNotify.getLang()), tdItem.number]));
                    success = Translator.getString(userWhoAdd.getLang(), "trade", "add_item", [item.getName(userWhoAdd.getLang()), tdItem.number]);
                } else {
                    error = Translator.getString(userWhoAdd.getLang(), "errors", "trade_dont_have_that_many_items");
                }

            } else {
                error = Translator.getString(userWhoAdd.getLang(), "errors", "trade_dont_have_item");
            }
        } else {
            error = Translator.getString(userWhoAdd.getLang(), "errors", "trade_not_accepted");
        }


        return error.length > 0 ? { error: error } : { success: success };
    }

    async removeItem(userWhoRemove, idEmplacement = 1, number = 1) {
        idEmplacement = parseInt(idEmplacement);
        number = parseInt(number);
        number = number > 0 ? number : 1;
        idEmplacement -= 1;
        let rightInventory;
        let rightInventoryIndexes;
        let error = "";
        let success = "";
        let userToNotify;

        if (this.isTradeOpen()) {
            if (userWhoRemove == this.playerOne) {
                rightInventory = this.itemsOne;
                rightInventoryIndexes = this.itemsOneIndexes;
                userToNotify = this.playerTwo;
            } else {
                rightInventory = this.itemsTwo;
                rightInventoryIndexes = this.itemsTwoIndexes;
                userToNotify = this.playerOne;

                // Here since the display shows ids from 1 to X including the player 2 inventory
                // We must be sure the ids are correct
                // idEmplacement could go lower than 0 then it will show the "item does't exist"
                idEmplacement -= this.itemsOne.length;
            }

            if (rightInventory[idEmplacement] != null) {
                let tradeItem = rightInventory[idEmplacement];
                let item = await userWhoRemove.character.getInv().getItemOfThisIDItem(tradeItem.id);
                if (tradeItem.number > number) {
                    tradeItem.number -= number;
                } else {
                    delete rightInventoryIndexes[tradeItem.id];
                    rightInventory.splice(idEmplacement, 1);
                }

                userToNotify.tradeTell(Translator.getString(userToNotify.getLang(), "trade", "notification_remove_item", [userWhoRemove.getUsername(), item.getName(userToNotify.getLang()), tradeItem.number]));
                success = Translator.getString(userWhoRemove.getLang(), "trade", "remove_item", [item.getName(userWhoRemove.getLang()), tradeItem.number]);
                this.unvalidate();
            } else {
                error = Translator.getString(userWhoRemove.getLang(), "errors", "trade_item_dont_exist");
            }
        } else {
            error = Translator.getString(userWhoRemove.getLang(), "errors", "trade_not_accepted");
        }



        return error.length > 0 ? { error: error } : { success: success };
    }


    /**
     * 
     * @param {User} userWhoAdd 
     * @param {Integer} number 
     */
    async setMoney(userWhoAdd, number) {
        if (this.isTradeOpen()) {
            number = parseInt(number);
            number = number > 0 ? number : 1;
            let userToNotify;
            if (await userWhoAdd.character.getMoney() >= number) {
                if (this.playerOne == userWhoAdd) {
                    this.moneyOne = number;
                    userToNotify = this.playerTwo;
                } else {
                    this.moneyTwo = number;
                    userToNotify = this.playerOne;
                }
                this.unvalidate();
                userToNotify.tradeTell(Translator.getString(userToNotify.getLang(), "trade", "notification_set_money", [userWhoAdd.getUsername(), number]))
                return { success: Translator.getString(userWhoAdd.getLang(), "trade", "set_money", [number]) };
            } else {
                return { error: Translator.getString(userWhoAdd.getLang(), "errors", "trade_not_enough_money") };
            }
        } else {
            return { error: Translator.getString(userWhoAdd.getLang(), "errors", "trade_not_accepted") };
        }

    }

    async itemToApi(idEmplacement = 1, lang = "en") {
        idEmplacement = parseInt(idEmplacement);
        idEmplacement = idEmplacement > 0 ? idEmplacement : 1;
        idEmplacement -= 1;
        let number;
        let item;

        if (this.isTradeOpen()) {
            if (idEmplacement < (this.itemsOne.length + this.itemsTwo.length)) {
                if (idEmplacement < this.itemsOne.length) {
                    item = await this.playerOne.character.getInv().getItemOfThisIDItem(this.itemsOne[idEmplacement].id);
                    number = this.itemsOne[idEmplacement].number <= item.number ? this.itemsOne[idEmplacement].number : item.number;
                } else {
                    idEmplacement -= this.itemsOne.length;
                    item = await this.playerTwo.character.getInv().getItemOfThisIDItem(this.itemsTwo[idEmplacement].id);
                    number = this.itemsTwo[idEmplacement].number <= item.number ? this.itemsTwo[idEmplacement].number : item.number;
                }

                if (item != null) {
                    item.number = number;
                    return { item: await item.toApi(lang) };
                } else {
                    return { error: Translator.getString(lang, "errors", "trade_inventory_changed") };
                }
            } else {
                return { error: Translator.getString(lang, "errors", "trade_unable_find_item") };
            }
        } else {
            return { error: Translator.getString(lang, "errors", "trade_not_accepted") };
        }




    }


    async toApi(lang = "en") {

        if (this.isTradeOpen()) {
            /**
             * We are testing money to be sure is realistic and up to date
             */
            let p1Money = await this.playerOne.character.getMoney();
            this.moneyOne = p1Money >= this.moneyOne ? this.moneyOne : p1Money;

            let p2Money = await this.playerTwo.character.getMoney();
            this.moneyTwo = p2Money >= this.moneyTwo ? this.moneyTwo : p2Money;


            let returnObject = {
                playerOneName: this.playerOne.getUsername(),
                playerOneItemsProposal: [],
                playerOneMoneyProposal: this.moneyOne,
                playerOneIsValidated: this.isValidatedByPlayerOne,

                playerTwoName: this.playerTwo.getUsername(),
                playerTwoItemsProposal: [],
                playerTwoMoneyProposal: this.moneyTwo,
                playerTwoIsValidated: this.isValidatedByPlayerTwo,

            }


            // Will be usefull to trash items (from the trade only) that is no more in player inventory 
            let playerOneToRemoveItems = [];
            let playerTwoToRemoveItems = [];

            /**
             * Using promise for performance reason
             * Wrapping all items loading in one promise all that we wait 
             * to not block the thread
             */

            let playerOneLoadingItems = [];
            for (let tradeItemID in this.itemsOne) {
                let loadingOneItem = async () => {
                    let item = await this.playerOne.character.getInv().getItemOfThisIDItem(this.itemsOne[tradeItemID].id);
                    if (item != null) {
                        if (item.number < this.itemsOne[tradeItemID].number) {
                            this.itemsOne[tradeItemID].number = item.number;
                        }
                        returnObject.playerOneItemsProposal[tradeItemID] = await item.toApiLight(lang);
                        returnObject.playerOneItemsProposal[tradeItemID].number = this.itemsOne[tradeItemID].number;
                    } else {
                        playerOneToRemoveItems.push(tradeItemID);
                    }
                };
                playerOneLoadingItems.push(loadingOneItem());
            }

            let playerTwoLoadingItems = [];
            for (let tradeItemID in this.itemsTwo) {
                let loadingOneItem = async () => {
                    let item = await this.playerTwo.character.getInv().getItemOfThisIDItem(this.itemsTwo[tradeItemID].id);
                    if (item != null) {
                        if (item.number < this.itemsTwo[tradeItemID].number) {
                            this.itemsTwo[tradeItemID].number = item.number;
                        }
                        returnObject.playerTwoItemsProposal[tradeItemID] = await item.toApiLight(lang);
                        returnObject.playerTwoItemsProposal[tradeItemID].number = this.itemsTwo[tradeItemID].number;
                    } else {
                        playerTwoToRemoveItems.push(tradeItemID);
                    }
                };
                playerTwoLoadingItems.push(loadingOneItem());
            }

            await Promise.all([Promise.all(playerOneLoadingItems), Promise.all(playerTwoLoadingItems)]);

            for (let i of playerOneToRemoveItems) {
                this.itemsOne.splice(i, 1);
            }
            for (let i of playerTwoToRemoveItems) {
                this.itemsTwo.splice(i, 1);
            }

            return { trade: returnObject };
        } else {
            return { error: Translator.getString(lang, "errors", "trade_not_accepted") };
        }


    }


}

module.exports = Trade;


const User = require("../User");