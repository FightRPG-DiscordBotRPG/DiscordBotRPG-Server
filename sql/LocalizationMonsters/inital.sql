-- MySQL Workbench Synchronization
-- Generated: 2018-08-22 14:56
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationmonsters` (
  `idMonstre` INT(10) UNSIGNED NOT NULL,
  `lang` VARCHAR(3) NOT NULL,
  `nameMonster` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idMonstre`, `lang`),
  INDEX `fk_LocalizationMonsters_Languages1_idx` (`lang` ASC),
  CONSTRAINT `fk_LocalizationMonsters_Monstres1`
    FOREIGN KEY (`idMonstre`)
    REFERENCES `discord_bot_rpg`.`monstres` (`idMonstre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationMonsters_Languages1`
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

INSERT INTO `discord_bot_rpg`.`localizationmonsters` SELECT idMonstre, "fr", name as nameMonster FROM monstres;

INSERT INTO `discord_bot_rpg`.`localizationmonsters` VALUES
(1, "en", "Wisp"),
(2, "en", "Slime"),
(3, "en", "Poisonous Slime"),
(4, "en", "Tree Spider"),
(5, "en", "Wolf"),
(6, "en", "Earth Golem"),
(7, "en", "Stone Golem"),
(8, "en", "Magma Golem"),
(9, "en", "Water Golem"),
(10, "en", "Air Golem"),
(11, "en", "Storm Golem"),
(12, "en", "Arcanic Golem"),
(13, "en", "Rock Snake"),
(14, "en", "Stone Basil"),
(15, "en", "Drilling Worm"),
(16, "en", "Blood-stained Vulture"),
(17, "en", "Hyena"),
(18, "en", "Harpy"),
(19, "en", "Tortured Giant"),
(20, "en", "Monstrous Ghoul"),
(21, "en", "Jungle Snake"),
(22, "en", "Fierce Tiger"),
(23, "en", "Lonely Raptor"),
(24, "en", "Dominant Gorilla"),
(25, "en", "Scarred Bear"),
(26, "en", "Large Alligator"),
(27, "en", "Maatan Warrior"),
(28, "en", "Maatan Hunter"),
(29, "en", "Balrog, fire spirit"),
(30, "en", "Ardent Bogeyman");

-- MySQL Workbench Synchronization
-- Generated: 2018-08-22 15:11
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`monstres` 
DROP COLUMN `name`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
