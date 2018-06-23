-- MySQL Workbench Synchronization
-- Generated: 2018-06-22 15:27
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`areasresources` 
ADD COLUMN `requiredLevel` INT(10) UNSIGNED NOT NULL DEFAULT 1 AFTER `idBaseItem`,
ADD INDEX `fk_AreasResources_LevelsRequire1_idx` (`requiredLevel` ASC);

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`craftitem` (
  `idBaseItem` INT(10) UNSIGNED NOT NULL,
  `maxLevel` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idBaseItem`),
  INDEX `fk_CraftItem_LevelsRequire1_idx` (`maxLevel` ASC),
  CONSTRAINT `fk_CraftItem_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CraftItem_LevelsRequire1`
    FOREIGN KEY (`maxLevel`)
    REFERENCES `discord_bot_rpg`.`levelsrequire` (`level`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`craftitemsneeded` (
  `idCraftItemsNeeded` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `IdCraftItem` INT(10) UNSIGNED NOT NULL,
  `NeededItem` INT(10) UNSIGNED NOT NULL,
  `number` INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idCraftItemsNeeded`),
  UNIQUE INDEX `idCraftItemsNeeded_UNIQUE` (`idCraftItemsNeeded` ASC),
  INDEX `fk_CraftItemsNeeded_CraftItem1_idx` (`IdCraftItem` ASC),
  INDEX `fk_CraftItemsNeeded_ItemsBase1_idx` (`NeededItem` ASC),
  CONSTRAINT `fk_CraftItemsNeeded_CraftItem1`
    FOREIGN KEY (`IdCraftItem`)
    REFERENCES `discord_bot_rpg`.`craftitem` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CraftItemsNeeded_ItemsBase1`
    FOREIGN KEY (`NeededItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`characterscraftlevel` (
  `idCharacter` INT(10) UNSIGNED NOT NULL,
  `actualLevel` INT(10) UNSIGNED NOT NULL DEFAULT 1,
  `actualExp` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idCharacter`),
  INDEX `fk_CharactersCraftLevel_LevelsRequire1_idx` (`actualLevel` ASC),
  CONSTRAINT `fk_CharactersCraftLevel_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersCraftLevel_LevelsRequire1`
    FOREIGN KEY (`actualLevel`)
    REFERENCES `discord_bot_rpg`.`levelsrequire` (`level`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

ALTER TABLE `discord_bot_rpg`.`areasresources` 
ADD CONSTRAINT `fk_AreasResources_LevelsRequire1`
  FOREIGN KEY (`requiredLevel`)
  REFERENCES `discord_bot_rpg`.`levelsrequire` (`level`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Synchronization
-- Generated: 2018-06-22 17:15
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`craftitem` 
ADD COLUMN `minLevel` INT(10) UNSIGNED NOT NULL AFTER `maxLevel`,
ADD INDEX `fk_CraftItem_LevelsRequire2_idx` (`minLevel` ASC);

ALTER TABLE `discord_bot_rpg`.`craftitem` 
ADD CONSTRAINT `fk_CraftItem_LevelsRequire2`
  FOREIGN KEY (`minLevel`)
  REFERENCES `discord_bot_rpg`.`levelsrequire` (`level`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- Insert for all characters
INSERT INTO characterscraftlevel (idCharacter) SELECT characters.idCharacter FROM characters
