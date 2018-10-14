-- MySQL Workbench Synchronization
-- Generated: 2018-10-07 12:59
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `discord_bot_rpg`.`statsmonstres` 
DROP FOREIGN KEY `fk_StatsMonstres_Stats1`;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`statsprofil` (
  `idStatsProfil` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idStatsProfil`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`statsrepartition` (
  `idStatsProfil` INT(10) UNSIGNED NOT NULL,
  `idStat` INT(10) UNSIGNED NOT NULL,
  `percentage` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idStatsProfil`, `idStat`),
  INDEX `fk_StatsRepartition_Stats1_idx` (`idStat` ASC),
  CONSTRAINT `fk_StatsRepartition_StatsProfil1`
    FOREIGN KEY (`idStatsProfil`)
    REFERENCES `discord_bot_rpg`.`statsprofil` (`idStatsProfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StatsRepartition_Stats1`
    FOREIGN KEY (`idStat`)
    REFERENCES `discord_bot_rpg`.`stats` (`idStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

DELETE FROM statsmonstres;

ALTER TABLE `discord_bot_rpg`.`statsmonstres` 
DROP COLUMN `value`,
DROP COLUMN `idStat`,
ADD COLUMN `idStatsProfil` INT(10) UNSIGNED NOT NULL AFTER `idMonstre`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`idMonstre`),
ADD INDEX `fk_StatsMonstres_StatsProfil1_idx` (`idStatsProfil` ASC),
DROP INDEX `fk_StatsMonstres_Stats1_idx` ;

ALTER TABLE `discord_bot_rpg`.`statsmonstres` 
ADD CONSTRAINT `fk_StatsMonstres_StatsProfil1`
  FOREIGN KEY (`idStatsProfil`)
  REFERENCES `discord_bot_rpg`.`statsprofil` (`idStatsProfil`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

INSERT INTO `statsprofil` (`idStatsProfil`, `name`) VALUES (NULL, 'balance_low'), (NULL, 'smorc'), (NULL, 'tank_stun'), (NULL, 'crit'), (NULL, 'tank_armor_stun'), (NULL, 'tank_will'), (NULL, 'damage'), (NULL, 'damage_crit'), (NULL, 'tanky'),;
INSERT INTO `statsrepartition` (`idStatsProfil`, `idStat`, `percentage`) VALUES
('1', '1', '5'), ('1', '3', '5'), ('1', '4', '10'),
('2', '1', '58'), ('2', '3', '30'), ('2', '4', '50'),
('3', '1', '20'), ('3', '3', '40'), ('3', '4', '20'), ('3', '9', '35'),
('4', '1', '25'), ('4', '3', '30'), ('4', '4', '0'), ('4', '9', '0'), ('4', '5', '45'),
('5', '1', '10'), ('5', '3', '35'), ('5', '4', '100'), ('5', '9', '30'), ('5', '5', '0'),
('6', '1', '20'), ('6', '3', '35'), ('6', '4', '100'), ('6', '9', '0'), ('6', '5', '0'), ('6', '7', '20'),
('7', '1', '55'), ('7', '3', '35'), ('7', '4', '40'), ('7', '9', '0'), ('7', '5', '0'), ('7', '7', '0'),
('8', '1', '40'), ('8', '3', '35'), ('8', '4', '40'), ('8', '9', '0'), ('8', '5', '15'), ('8', '7', '0'),
('9', '1', '20'), ('9', '3', '40'), ('9', '4', '100'), ('9', '9', '5'), ('9', '5', '5'), ('9', '2', '5');
INSERT INTO statsmonstres SELECT idMonstre, 1 FROM monstres WHERE idMonstre <= 5;
INSERT INTO statsmonstres SELECT idMonstre, 2 FROM monstres WHERE idMonstre > 5 AND idMonstre <= 8;
INSERT INTO statsmonstres SELECT idMonstre, 3 FROM monstres WHERE idMonstre > 8 AND idMonstre <= 11;
INSERT INTO statsmonstres SELECT idMonstre, 4 FROM monstres WHERE idMonstre > 11 AND idMonstre <= 14;
INSERT INTO statsmonstres SELECT idMonstre, 5 FROM monstres WHERE idMonstre > 14 AND idMonstre <= 17;
INSERT INTO statsmonstres SELECT idMonstre, 6 FROM monstres WHERE idMonstre > 17 AND idMonstre <= 20;
INSERT INTO statsmonstres SELECT idMonstre, 7 FROM monstres WHERE idMonstre > 20 AND idMonstre <= 23;
INSERT INTO statsmonstres SELECT idMonstre, 8 FROM monstres WHERE idMonstre > 23 AND idMonstre <= 26;
INSERT INTO statsmonstres SELECT idMonstre, 9 FROM monstres WHERE idMonstre > 26;