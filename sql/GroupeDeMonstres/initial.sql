TRUNCATE TABLE areasmonsters;

-- MySQL Workbench Synchronization
-- Generated: 2018-06-12 15:27
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`areasmonsters`
DROP COLUMN `idMonstre`,
ADD COLUMN `idMonstreGroupe` INT(10) UNSIGNED NOT NULL AFTER `idArea`,
ADD COLUMN `idMonstre` INT(10) UNSIGNED NOT NULL AFTER `idMonstreGroupe`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`idArea`, `idMonstreGroupe`, `idMonstre`),
ADD INDEX `fk_AreasMonsters_MonstresGroupes1_idx` (`idMonstreGroupe` ASC, `idMonstre` ASC),
DROP INDEX `fk_AreasMonsters_Monstres1_idx` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`monstresgroupes` (
  `idMonstreGroupe` INT(10) UNSIGNED NOT NULL,
  `idMonstre` INT(10) UNSIGNED NOT NULL,
  `number` INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idMonstreGroupe`, `idMonstre`),
  INDEX `fk_MonstresGroupes_Monstres1_idx` (`idMonstre` ASC),
  CONSTRAINT `fk_MonstresGroupes_Monstres1`
    FOREIGN KEY (`idMonstre`)
    REFERENCES `discord_bot_rpg`.`monstres` (`idMonstre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

ALTER TABLE `discord_bot_rpg`.`areasmonsters`
ADD CONSTRAINT `fk_AreasMonsters_MonstresGroupes1`
  FOREIGN KEY (`idMonstreGroupe` , `idMonstre`)
  REFERENCES `discord_bot_rpg`.`monstresgroupes` (`idMonstreGroupe` , `idMonstre`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (1,1);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (2,2);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (3,3);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (4,4);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (5,5);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (6,6);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (7,7);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (8,8);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (9,9);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (10,10);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (11,11);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (12,12);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (13,13);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (14,14);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (15,15);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (16,16);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (17,17);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (18,18);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (19,19);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (20,20);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (21,21);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (22,22);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (23,23);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (24,24);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (25,25);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (26,26);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (27,27);
INSERT INTO monstresgroupes (idMonstreGroupe, idMonstre) VALUES (28,28);

INSERT INTO areasmonsters VALUES (1,1,1);
INSERT INTO areasmonsters VALUES (1,2,2);
INSERT INTO areasmonsters VALUES (1,3,3);
INSERT INTO areasmonsters VALUES (1,4,4);
INSERT INTO areasmonsters VALUES (1,5,5);
INSERT INTO areasmonsters VALUES (2,6,6);
INSERT INTO areasmonsters VALUES (2,7,7);
INSERT INTO areasmonsters VALUES (2,8,8);
INSERT INTO areasmonsters VALUES (2,9,9);
INSERT INTO areasmonsters VALUES (2,10,10);
INSERT INTO areasmonsters VALUES (2,11,11);
INSERT INTO areasmonsters VALUES (2,12,12);
INSERT INTO areasmonsters VALUES (3,13,13);
INSERT INTO areasmonsters VALUES (3,14,14);
INSERT INTO areasmonsters VALUES (3,15,15);
INSERT INTO areasmonsters VALUES (3,16,16);
INSERT INTO areasmonsters VALUES (3,17,17);
INSERT INTO areasmonsters VALUES (3,18,18);
INSERT INTO areasmonsters VALUES (3,19,19);
INSERT INTO areasmonsters VALUES (3,20,20);
INSERT INTO areasmonsters VALUES (4,21,21);
INSERT INTO areasmonsters VALUES (4,22,22);
INSERT INTO areasmonsters VALUES (4,23,23);
INSERT INTO areasmonsters VALUES (4,24,24);
INSERT INTO areasmonsters VALUES (4,25,25);
INSERT INTO areasmonsters VALUES (4,26,26);
INSERT INTO areasmonsters VALUES (4,27,27);
INSERT INTO areasmonsters VALUES (4,28,28);

UPDATE monstrestypes SET nom = "normal" WHERE idType = 1;
UPDATE monstrestypes SET nom = "elite" WHERE idType = 2;
