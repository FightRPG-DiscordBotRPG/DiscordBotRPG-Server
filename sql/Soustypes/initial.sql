UPDATE itemsbase SET idType = 1 WHERE idType BETWEEN 5 AND 7;
DELETE FROM `itemstypes` WHERE idType BETWEEN 5 AND 7;
ALTER TABLE `itemstypes` auto_increment = 5;
INSERT INTO `itemstypes` (`idType`, `nomType`, `equipable`) VALUES (NULL, 'resource', '0');
UPDATE `itemsbase` SET `idType` = 5 WHERE `idBaseItem` BETWEEN 20 AND 22;

-- MySQL Workbench Synchronization
-- Generated: 2018-06-21 16:57
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`itemsbase`
ADD COLUMN `idSousType` INT(10) UNSIGNED NULL DEFAULT NULL AFTER `imageItem`,
ADD INDEX `fk_ItemsBase_ItemsSousTypes1_idx` (`idSousType` ASC);

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`itemssoustypes` (
  `idSousType` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nomSousType` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idSousType`),
  UNIQUE INDEX `idSousType_UNIQUE` (`idSousType` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

ALTER TABLE `discord_bot_rpg`.`itemsbase`
ADD CONSTRAINT `fk_ItemsBase_ItemsSousTypes1`
  FOREIGN KEY (`idSousType`)
  REFERENCES `discord_bot_rpg`.`itemssoustypes` (`idSousType`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO `itemssoustypes` (`idSousType`, `nomSousType`) VALUES (NULL, 'ore'), (NULL, 'plant'), (NULL, 'wood');
INSERT INTO `itemssoustypes` (`idSousType`, `nomSousType`) VALUES (NULL, 'sword');
INSERT INTO `itemssoustypes` (`idSousType`, `nomSousType`) VALUES (NULL, 'whip');
INSERT INTO `itemssoustypes` (`idSousType`, `nomSousType`) VALUES (NULL, 'armor');

-- Resources
UPDATE `itemsbase` SET `idSousType` = '3' WHERE `itemsbase`.`idBaseItem` = 20;
UPDATE `itemsbase` SET `idSousType` = '1' WHERE `itemsbase`.`idBaseItem` = 21;
UPDATE `itemsbase` SET `idSousType` = '2' WHERE `itemsbase`.`idBaseItem` = 22;

-- Epée
UPDATE `itemsbase` SET `idSousType` = '4' WHERE `itemsbase`.`idBaseItem` = 1;
UPDATE `itemsbase` SET `idSousType` = '4' WHERE `itemsbase`.`idBaseItem` = 2;
UPDATE `itemsbase` SET `idSousType` = '4' WHERE `itemsbase`.`idBaseItem` = 3;
UPDATE `itemsbase` SET `idSousType` = '4' WHERE `itemsbase`.`idBaseItem` = 13;
UPDATE `itemsbase` SET `idSousType` = '4' WHERE `itemsbase`.`idBaseItem` = 14;

-- Whip / Fouet
UPDATE `itemsbase` SET `idSousType` = '5' WHERE `itemsbase`.`idBaseItem` = 23;

-- Armure
UPDATE `itemsbase` SET `idSousType` = '6' WHERE `itemsbase`.`idType` BETWEEN 2 AND 4;

-- MySQL Workbench Synchronization
-- Generated: 2018-06-21 17:40
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`itemsbase`
DROP FOREIGN KEY `fk_ItemsBase_ItemsSousTypes1`;

ALTER TABLE `discord_bot_rpg`.`itemsbase`
CHANGE COLUMN `idSousType` `idSousType` INT(10) UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`itemsbase`
ADD CONSTRAINT `fk_ItemsBase_ItemsSousTypes1`
  FOREIGN KEY (`idSousType`)
  REFERENCES `discord_bot_rpg`.`itemssoustypes` (`idSousType`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
