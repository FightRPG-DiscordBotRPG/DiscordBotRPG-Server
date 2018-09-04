-- MySQL Workbench Synchronization
-- Generated: 2018-09-04 13:18
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`CraftBuilding` 
ADD COLUMN `minLevel` INT(10) UNSIGNED NOT NULL DEFAULT 1 AFTER `rarityMax`,
ADD COLUMN `maxLevel` INT(10) UNSIGNED NOT NULL DEFAULT 1 AFTER `minLevel`,
ADD INDEX `fk_CraftBuilding_LevelsRequire1_idx` (`minLevel` ASC),
ADD INDEX `fk_CraftBuilding_LevelsRequire2_idx` (`maxLevel` ASC);

ALTER TABLE `discord_bot_rpg`.`CraftBuilding` 
ADD CONSTRAINT `fk_CraftBuilding_LevelsRequire1`
  FOREIGN KEY (`minLevel`)
  REFERENCES `discord_bot_rpg`.`LevelsRequire` (`level`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_CraftBuilding_LevelsRequire2`
  FOREIGN KEY (`maxLevel`)
  REFERENCES `discord_bot_rpg`.`LevelsRequire` (`level`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
