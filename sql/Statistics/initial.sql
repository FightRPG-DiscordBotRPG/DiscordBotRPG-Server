-- MySQL Workbench Synchronization
-- Generated: 2018-07-26 11:51
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`statisticsbases` (
  `idStatisticBase` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (`idStatisticBase`),
  UNIQUE INDEX `idStatisticBase_UNIQUE` (`idStatisticBase` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`CharactersStatistics` (
  `idStatisticBase` INT(10) UNSIGNED NOT NULL,
  `idCharacter` INT(10) UNSIGNED NOT NULL,
  `value` BIGINT(19) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idStatisticBase`, `idCharacter`),
  INDEX `fk_CharactersStatistics_Characters1_idx` (`idCharacter` ASC),
  CONSTRAINT `fk_CharactersStatistics_StatisticsBases1`
    FOREIGN KEY (`idStatisticBase`)
    REFERENCES `discord_bot_rpg`.`statisticsbases` (`idStatisticBase`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersStatistics_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- General
INSERT INTO `statisticsbases` (`idStatisticBase`, `name`) VALUES 
(NULL, 'pvefights_victories'), (NULL, 'pvefights_defeats'),

(NULL, 'travels'),

(NULL, 'gold_dropped'), (NULL, 'gold_marketplace'), (NULL, 'gold_sell'),

(NULL, 'damage_done'), (NULL, 'damage_taken'), (NULL, 'gold_spent'),

(NULL, 'pvpfights_victories'), (NULL, 'pvpfights_defeats'),

(NULL, 'normal_defeated'), (NULL, 'boss_defeated'), (NULL, 'elite_defeated'),

(NULL, 'groups_joined'), (NULL, 'groups_created'),

(NULL, 'items_common_loot'), (NULL, 'items_rare_loot'), (NULL, 'items_superior_loot'),
(NULL, 'items_epic_loot'), (NULL, 'items_legendary_loot'),

(NULL, 'guilds_joined'), (NULL, 'guilds_created'),

(NULL, 'items_common_craft'), (NULL, 'items_rare_craft'), (NULL, 'items_superior_craft'),
(NULL, 'items_epic_craft'), (NULL, 'items_legendary_craft'),

(NULL, 'commands_inventory'), (NULL, 'commands_equipment'), (NULL, 'commands_character'),
(NULL, 'commands_fights'), (NULL, 'commands_areas'), (NULL, 'commands_groups'), 
(NULL, 'commands_hdv'), (NULL, 'commands_job'), (NULL, 'commands_other'), (NULL, 'commands_guilds')

(NULL, 'items_common_collected'), (NULL, 'items_rare_collected'), (NULL, 'items_superior_collected'),
(NULL, 'items_epic_collected'), (NULL, 'items_legendary_collected'),
;

