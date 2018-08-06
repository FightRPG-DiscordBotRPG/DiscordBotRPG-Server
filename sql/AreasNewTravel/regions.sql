-- MySQL Workbench Synchronization
-- Generated: 2018-08-06 10:59
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`regions` (
  `idRegions` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (`idRegions`),
  UNIQUE INDEX `idRegions_UNIQUE` (`idRegions` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`areasregions` (
  `idArea` INT(10) UNSIGNED NOT NULL,
  `idRegions` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`),
  INDEX `fk_AreasRegions_Regions1_idx` (`idRegions` ASC),
  CONSTRAINT `fk_AreasRegions_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreasRegions_Regions1`
    FOREIGN KEY (`idRegions`)
    REFERENCES `discord_bot_rpg`.`regions` (`idRegions`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO `regions` (`idRegions`, `name`) VALUES (NULL, 'Île des dépravés');
INSERT INTO `areasregions` (`idArea`, `idRegions`) VALUES ('1', '1'), ('2', '1'), ('3', '1'), ('4', '1'), ('5', '1'), ('6', '1'), ('7', '1');

-- MySQL Workbench Synchronization
-- Generated: 2018-08-06 11:24
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`areasregions` 
DROP FOREIGN KEY `fk_AreasRegions_Regions1`;

ALTER TABLE `discord_bot_rpg`.`regions` 
CHANGE COLUMN `idRegions` `idRegion` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ;

ALTER TABLE `discord_bot_rpg`.`areasregions` 
CHANGE COLUMN `idRegions` `idRegion` INT(10) UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`areasregions` 
ADD CONSTRAINT `fk_AreasRegions_Regions1`
  FOREIGN KEY (`idRegion`)
  REFERENCES `discord_bot_rpg`.`regions` (`idRegion`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`regions` 
ADD COLUMN `image` TEXT NULL DEFAULT NULL AFTER `name`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

UPDATE `regions` SET `image` = 'https://image.ibb.co/nKdAGK/map_base.png' WHERE `regions`.`idRegion` = 1;
