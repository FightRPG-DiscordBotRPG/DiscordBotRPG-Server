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


-- Insert for all characters
INSERT INTO characterscraftlevel (idCharacter) SELECT characters.idCharacter FROM characters



INSERT IGNORE INTO craftbuilding (idArea)
SELECT idArea
FROM areas
INNER JOIN areastypes
ON areas.idAreaType = areastypes.idAreaType
WHERE areastypes.NomAreaType = "city"

-- MySQL Workbench Synchronization
-- Generated: 2018-06-27 12:50
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`craftitem` (
  `idCraftItem` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `maxLevel` INT(10) UNSIGNED NOT NULL,
  `minLevel` INT(10) UNSIGNED NOT NULL,
  `idBaseItem` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idCraftItem`),
  INDEX `fk_CraftItem_LevelsRequire1_idx` (`maxLevel` ASC),
  INDEX `fk_CraftItem_LevelsRequire2_idx` (`minLevel` ASC),
  UNIQUE INDEX `idCraftItem_UNIQUE` (`idCraftItem` ASC),
  INDEX `fk_CraftItem_ItemsBase1_idx` (`idBaseItem` ASC),
  CONSTRAINT `fk_CraftItem_LevelsRequire1`
    FOREIGN KEY (`maxLevel`)
    REFERENCES `discord_bot_rpg`.`levelsrequire` (`level`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CraftItem_LevelsRequire2`
    FOREIGN KEY (`minLevel`)
    REFERENCES `discord_bot_rpg`.`levelsrequire` (`level`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CraftItem_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`craftitemsneeded` (
  `IdCraftItem` INT(10) UNSIGNED NOT NULL,
  `NeededItem` INT(10) UNSIGNED NOT NULL,
  `number` INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`IdCraftItem`, `NeededItem`),
  INDEX `fk_CraftItemsNeeded_CraftItem1_idx` (`IdCraftItem` ASC),
  CONSTRAINT `fk_CraftItemsNeeded_ItemsBase1`
    FOREIGN KEY (`NeededItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CraftItemsNeeded_CraftItem1`
    FOREIGN KEY (`IdCraftItem`)
    REFERENCES `discord_bot_rpg`.`craftitem` (`idCraftItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`craftbuilding` (
  `idCraftBuilding` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `idArea` INT(10) UNSIGNED NOT NULL,
  `active` TINYINT(4) NOT NULL DEFAULT 1,
  `rarityMax` INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idCraftBuilding`),
  UNIQUE INDEX `idCraftBuilding_UNIQUE` (`idCraftBuilding` ASC),
  INDEX `fk_CraftBuilding_Areas1_idx` (`idArea` ASC),
  UNIQUE INDEX `idArea_UNIQUE` (`idArea` ASC),
  INDEX `fk_CraftBuilding_ItemsRarities1_idx` (`rarityMax` ASC),
  CONSTRAINT `fk_CraftBuilding_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CraftBuilding_ItemsRarities1`
    FOREIGN KEY (`rarityMax`)
    REFERENCES `discord_bot_rpg`.`itemsrarities` (`idRarity`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



--INSERT INTO craftitem VALUES (NULL, 20, 1, 1);
--INSERT INTO craftitemsneeded VALUES (1, 20, 3), (1, 22, 1);

