-- MySQL Workbench Synchronization
-- Generated: 2018-08-21 10:50
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`languages` (
  `lang` VARCHAR(3) NOT NULL DEFAULT 'en',
  PRIMARY KEY (`lang`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationitems` (
  `idBaseItem` INT(10) UNSIGNED NOT NULL,
  `lang` VARCHAR(3) NOT NULL,
  `nameItem` VARCHAR(50) NOT NULL DEFAULT 'unknown',
  `descItem` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idBaseItem`, `lang`),
  INDEX `fk_LocalizationItems_Languages1_idx` (`lang` ASC),
  CONSTRAINT `fk_LocalizationItems_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationItems_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `discord_bot_rpg`.`languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO `discord_bot_rpg`.`languages` VALUES ("en"), ("fr");

INSERT INTO `discord_bot_rpg`.`localizationitems` SELECT idBaseItem, "fr", nomItem as nameItem, descItem FROM itemsbase;

INSERT INTO `discord_bot_rpg`.`localizationitems` VALUES
(1, "en", "Wooden Sword", ""),
(2, "en", "Iron Sword", ""),
(3, "en", "Forged Steel Sword", ""),
(4, "en", "Beginner Armor", ""),
(5, "en", "Adventurer Armor", ""),
(6, "en", "Magical Armor", ""),
(7, "en", "Beginner Greaves", ""),
(8, "en", "Adventurer Greaves", ""),
(9, "en", "Magical Greaves", ""),
(10, "en", "Beginner Helmet", ""),
(11, "en", "Adventurer Helmet", ""),
(12, "en", "Magical Helmet", ""),
(13, "en", "Elemental Sword", ""),
(14, "en", "Chaos Sword", ""),
(15, "en", "Evil Knight Helmet's", ""),
(16, "en", "Giant Pant's", ""),
(17, "en", "Sacred Maatan Mask", ""),
(18, "en", "Bones Armor", ""),
(19, "en", "Used Maatan Loincloth", ""),
(20, "en", "Ash Wood", ""),
(21, "en", "Stone", ""),
(22, "en", "Poor Man Lichen's", ""),
(23, "en", "Ardent Whip", ""),
(24, "en", "Fire Horns Helmet", ""),
(25, "en", "Fire Belt", ""),
(26, "en", "Fire Armor", ""),
(27, "en", "Chestnut Wood", ""),
(28, "en", "Ebony Wood", ""),
(29, "en", "Hundred-Year-Old Fir Wood", ""),
(30, "en", "Magical Elm Wood", ""),
(31, "en", "Sharpen Iron", ""),
(32, "en", "Sparkling Silver", ""),
(33, "en", "Adamantium", ""),
(34, "en", "Etheral Crystal", ""),
(35, "en", "Lonely Reed", ""),
(36, "en", "Cotton", ""),
(37, "en", "Chaos Bramble", ""),
(38, "en", "Scathing Creeper", "");


-- MySQL Workbench Synchronization
-- Generated: 2018-08-21 12:07
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`itemsbase` 
DROP COLUMN `descItem`,
DROP COLUMN `nomItem`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
