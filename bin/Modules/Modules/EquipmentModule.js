const GModule = require("../GModule");
const Discord = require("discord.js");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
const Leaderboard = require("../../Leaderboard");
const Guild = require("../../Guild");
const Group = require("../../Group");
const Fight = require("../../Fight/Fight");
const Monster = require("../../Monstre");
const Translator = require("../../Translator/Translator");
const CraftSystem = require("../../CraftSystem/CraftSystem");
const AreaTournament = require("../../AreaTournament/AreaTournament");
const PStatistics = require("../../Achievement/PStatistics");
const Craft = require("../../CraftSystem/Craft");
const Item = require("../../Item");
const Emojis = require("../../Emojis");


class EquipmentModule extends GModule {
    constructor() {
        super();
        this.commands = ["equip", "unequip", "equiplist", "equipment"];
        this.startLoading("Equipment");
        this.init();
        this.endLoading("Equipment");
    }

    async run(message, command, args) {
        let msg = "";
        let authorIdentifier = message.author.id;
        let mentions = message.mentions.users;
        let group = Globals.connectedUsers[authorIdentifier].character.group;
        let lang = Globals.connectedUsers[authorIdentifier].getLang();
        let pending = Globals.connectedUsers[authorIdentifier].character.pendingPartyInvite;
        let marketplace = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "marketplace");
        let craftingbuilding = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "craftingbuilding");
        let currentArea = Globals.connectedUsers[authorIdentifier].character.getArea();
        let tLootSystem = new LootSystem();
        let uIDGuild;
        let tGuildId = 0;
        let firstMention;
        let err = [];
        let apPage;
        let nb;
        let temp;
        let doIHaveThisItem = false;

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_equipment", 1);

        switch (command) {
            case "equip":
                let toEquip = parseInt(args[0], 10);
                msg = "";
                //console.log((toEquip));
                if (toEquip != null && Number.isInteger(toEquip)) {
                    if (Globals.connectedUsers[authorIdentifier].character.inv.doIHaveThisItem(toEquip)) {
                        if (Globals.connectedUsers[authorIdentifier].character.inv.isEquipable(toEquip)) {
                            if (Globals.connectedUsers[authorIdentifier].character.getLevel() >= Globals.connectedUsers[authorIdentifier].character.inv.objects[toEquip].level) {
                                let swapItem = Globals.connectedUsers[authorIdentifier].character.equipement.equip(Globals.connectedUsers[authorIdentifier].character.inv.objects[toEquip].id);
                                Globals.connectedUsers[authorIdentifier].character.inv.deleteFromInventory(toEquip);
                                if (swapItem > 0) {
                                    Globals.connectedUsers[authorIdentifier].character.inv.addToInventory(swapItem);
                                }
                                msg = Translator.getString(lang, "inventory_equipment", "item_equiped");
                            } else {
                                msg = Translator.getString(lang, "errors", "item_cant_equip_higher_level", [Globals.connectedUsers[authorIdentifier].character.inv.objects[toEquip].level]);
                            }

                        } else {
                            msg = Translator.getString(lang, "errors", "item_you_cant_equip");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "item_you_dont_have");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "item_enter_id_to_equip");
                }
                break;

            case "unequip":
                let toUnequip = this.getEquipableIDType(args[0]);
                msg = "";
                if (toUnequip != -1 && Number.isInteger(toUnequip)) {
                    //let swapItem = Globals.connectedUsers[authorIdentifier].character.equ
                    let itemToInventory = Globals.connectedUsers[authorIdentifier].character.equipement.unEquip(toUnequip);
                    if (itemToInventory > 0) {
                        Globals.connectedUsers[authorIdentifier].character.inv.addToInventory(itemToInventory);
                        msg = Translator.getString(lang, "inventory_equipment", "item_unequiped");
                    } else {
                        msg = Translator.getString(lang, "errors", "item_you_dont_have_item_equiped_here");
                    }

                } else {
                    msg = Translator.getString(lang, "errors", "item_you_have_to_choose_type_to_unequip");
                }
                break;

            case "equiplist":
            case "equipment":
                msg = "```" + Globals.connectedUsers[authorIdentifier].character.equipement.toStr(lang) + "```";
                break;
        }

        this.sendMessage(message, msg);
    }
}

module.exports = EquipmentModule;