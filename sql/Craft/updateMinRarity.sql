-- MySQL Workbench Synchronization
-- Generated: 2018-09-18 15:29
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`craftbuilding` 
ADD COLUMN `rarityMin` INT(10) UNSIGNED NOT NULL DEFAULT 1 AFTER `active`,
ADD INDEX `fk_CraftBuilding_ItemsRarities2_idx` (`rarityMin` ASC);

ALTER TABLE `discord_bot_rpg`.`craftbuilding` 
ADD CONSTRAINT `fk_CraftBuilding_ItemsRarities2`
  FOREIGN KEY (`rarityMin`)
  REFERENCES `discord_bot_rpg`.`itemsrarities` (`idRarity`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
