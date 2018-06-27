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



--- Ajout des ressources

-- ORe plant wood
-- id nom desc type rarity image idsoustype

-- Wood | Ore | Plants
INSERT INTO itemsbase VALUES 
(null, "Bois de Châtaignier", "", 5, 2, "unknown", 3),
(null, "Bois d'ébène", "", 5, 3, "unknown", 3),
(null, "Bois de Sapin centenaire", "", 5, 4, "unknown", 3),
(null, "Bois d'Orme enchanté", "", 5, 5, "unknown", 3),

(null, "Fer affiné", "", 5, 2, "unknown", 1),
(null, "Argent scintillante", "", 5, 3, "unknown", 1),
(null, "Adamantium", "", 5, 4, "unknown", 1),
(null, "Crystal éthérien", "", 5, 5, "unknown", 1),

(null, "Roseau solitaire", "", 5, 2, "unknown", 2),
(null, "Coton", "", 5, 3, "unknown", 2),
(null, "Ronces du Chaos", "", 5, 4, "unknown", 2),
(null, "Lianes cinglantes", "", 5, 5, "unknown", 2);



DELETE FROM areasresources

INSERT INTO areasresources VALUES 
(1, 20, 1),
(1, 27, 4),
(1, 28, 7),
(1, 29, 12),

(2, 22, 1),
(2, 35, 4),
(2, 36, 7),
(2, 37, 12),
(2, 38, 15),

(3, 21, 1),
(3, 31, 4),
(3, 32, 7),
(3, 33, 12),
(3, 34, 15),

(4, 30, 15);

-- 1 - 10 
-- Commun
INSERT INTO craftitem VALUES (NULL, 10, 1, 1);
INSERT INTO craftitemsneeded VALUES (1, 20, 2), (1, 22, 1);

INSERT INTO craftitem VALUES (NULL, 10, 1, 4);
INSERT INTO craftitemsneeded VALUES (2, 20, 1), (2, 22, 2);

INSERT INTO craftitem VALUES (NULL, 10, 1, 7);
INSERT INTO craftitemsneeded VALUES (3, 20, 1), (3, 22, 2);

INSERT INTO craftitem VALUES (NULL, 10, 1, 10);
INSERT INTO craftitemsneeded VALUES (4, 20, 1), (4, 22, 2);

-- Rare
INSERT INTO craftitem VALUES (NULL, 10, 1, 2);
INSERT INTO craftitemsneeded VALUES (5, 35, 1), (5, 31, 1);

INSERT INTO craftitem VALUES (NULL, 10, 1, 5);
INSERT INTO craftitemsneeded VALUES (6, 35, 1), (6, 31, 1);

INSERT INTO craftitem VALUES (NULL, 10, 1, 8);
INSERT INTO craftitemsneeded VALUES (7, 35, 1), (7, 31, 1);

INSERT INTO craftitem VALUES (NULL, 10, 1, 11);
INSERT INTO craftitemsneeded VALUES (8, 35, 1), (8, 31, 1);

-- Supérieur
INSERT INTO craftitem VALUES (NULL, 10, 1, 3);
INSERT INTO craftitemsneeded VALUES (9, 36, 1), (9, 32, 1);

INSERT INTO craftitem VALUES (NULL, 10, 1, 6);
INSERT INTO craftitemsneeded VALUES (10, 36, 1), (10, 32, 1);

INSERT INTO craftitem VALUES (NULL, 10, 1, 9);
INSERT INTO craftitemsneeded VALUES (11, 36, 1), (11, 32, 1);

INSERT INTO craftitem VALUES (NULL, 10, 1, 12);
INSERT INTO craftitemsneeded VALUES (12, 36, 1), (12, 32, 1);

-- 10 - 15
-- Supérieur
INSERT INTO craftitem VALUES (NULL, 15, 10, 3);
INSERT INTO craftitemsneeded VALUES (13, 36, 1), (13, 32, 1), (13, 28, 1);

INSERT INTO craftitem VALUES (NULL, 15, 10, 6);
INSERT INTO craftitemsneeded VALUES (14, 36, 2), (14, 32, 1);

INSERT INTO craftitem VALUES (NULL, 15, 10, 9);
INSERT INTO craftitemsneeded VALUES (15, 36, 2), (15, 32, 1);

INSERT INTO craftitem VALUES (NULL, 15, 10, 12);
INSERT INTO craftitemsneeded VALUES (16, 36, 2), (16, 32, 1);

-- Epic
INSERT INTO craftitem VALUES (NULL, 15, 10, 14);
INSERT INTO craftitemsneeded VALUES (17, 35, 1), (17, 33, 1), (17, 29, 1);

INSERT INTO craftitem VALUES (NULL, 15, 10, 15);
INSERT INTO craftitemsneeded VALUES (18, 31, 1), (18, 33, 2);

INSERT INTO craftitem VALUES (NULL, 15, 10, 18);
INSERT INTO craftitemsneeded VALUES (19, 31, 1), (19, 33, 2);

INSERT INTO craftitem VALUES (NULL, 15, 10, 19);
INSERT INTO craftitemsneeded VALUES (20, 31, 1), (20, 33, 2);

-- 15 - 20
-- Epic
INSERT INTO craftitem VALUES (NULL, 15, 10, 14);
INSERT INTO craftitemsneeded VALUES (21, 35, 2), (21, 33, 1), (21, 29, 1);

INSERT INTO craftitem VALUES (NULL, 15, 10, 15);
INSERT INTO craftitemsneeded VALUES (22, 31, 2), (22, 33, 2);

INSERT INTO craftitem VALUES (NULL, 15, 10, 18);
INSERT INTO craftitemsneeded VALUES (23, 31, 2), (23, 33, 2);

INSERT INTO craftitem VALUES (NULL, 15, 10, 19);
INSERT INTO craftitemsneeded VALUES (24, 31, 2), (24, 33, 2);

-- Légendaire
INSERT INTO craftitem VALUES (NULL, 20, 15, 13);
INSERT INTO craftitemsneeded VALUES (25, 29, 1), (25, 37, 1), (25, 34, 1);

INSERT INTO craftitem VALUES (NULL, 20, 15, 16);
INSERT INTO craftitemsneeded VALUES (26, 38, 1), (26, 37, 2);

INSERT INTO craftitem VALUES (NULL, 20, 15, 17);
INSERT INTO craftitemsneeded VALUES (27, 38, 1), (27, 37, 2);

INSERT INTO craftitem VALUES (NULL, 20, 15, 26);
INSERT INTO craftitemsneeded VALUES (28, 38, 1), (28, 37, 2);






