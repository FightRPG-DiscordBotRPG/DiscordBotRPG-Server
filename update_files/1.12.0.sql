-- MySQL Workbench Forward Engineering
-- Every Data here, except the database structure is property of Fight RPG
-- You cannot use it

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema discord_bot_rpg
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema discord_bot_rpg
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `discord_bot_rpg` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `discord_bot_rpg` ;

-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventsTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventstypes` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventstypes` (
  `idEventType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEventType`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`Events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`events` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`events` (
  `idEvent` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idEventType` INT UNSIGNED NOT NULL,
  `backgroundImage` TEXT NOT NULL,
  `iconImage` TEXT NOT NULL,
  `occurence` BIGINT UNSIGNED NOT NULL DEFAULT 86400,
  `length` BIGINT UNSIGNED NOT NULL DEFAULT 43200,
  `startDate` DATETIME NOT NULL,
  `endDate` DATETIME,
  PRIMARY KEY (`idEvent`),
  INDEX `fk_Events_EventsTypes1_idx` (`idEventType` ASC) VISIBLE,
  CONSTRAINT `fk_Events_EventsTypes1`
    FOREIGN KEY (`idEventType`)
    REFERENCES `discord_bot_rpg`.`eventstypes` (`idEventType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventsGlobalModifiers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventsglobalmodifiers` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventsglobalmodifiers` (
  `idEvent` INT UNSIGNED NOT NULL,
  `idBonusTypes` INT UNSIGNED NOT NULL,
  `value` INT NOT NULL,
  PRIMARY KEY (`idEvent`, `idBonusTypes`),
  INDEX `fk_EventsBonuses_BonusTypes1_idx` (`idBonusTypes` ASC) VISIBLE,
  CONSTRAINT `fk_EventsBonuses_Events1`
    FOREIGN KEY (`idEvent`)
    REFERENCES `discord_bot_rpg`.`events` (`idEvent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventsBonuses_BonusTypes1`
    FOREIGN KEY (`idBonusTypes`)
    REFERENCES `discord_bot_rpg`.`bonustypes` (`idBonusTypes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventSpecificDrops`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventspecificdrops` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventspecificdrops` (
  `idEvent` INT UNSIGNED NOT NULL,
  `idBaseItem` INT UNSIGNED NOT NULL,
  `percentage` FLOAT UNSIGNED NOT NULL,
  `min` INT UNSIGNED NOT NULL,
  `max` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idEvent`, `idBaseItem`),
  INDEX `fk_EventSpecificDrops_ItemsBase1_idx` (`idBaseItem` ASC) VISIBLE,
  CONSTRAINT `fk_EventSpecificDrops_Events1`
    FOREIGN KEY (`idEvent`)
    REFERENCES `discord_bot_rpg`.`events` (`idEvent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventSpecificDrops_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventsAreasTypesDrops`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventsareastypesdrops` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventsareastypesdrops` (
  `idAreaType` INT UNSIGNED NOT NULL,
  `idEvent` INT UNSIGNED NOT NULL,
  `idBaseItem` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idAreaType`, `idEvent`, `idBaseItem`),
  INDEX `fk_EventsAreasTypesDrops_EventSpecificDrops1_idx` (`idEvent` ASC, `idBaseItem` ASC) VISIBLE,
  CONSTRAINT `fk_EventsAreasTypesDrops_AreasTypes1`
    FOREIGN KEY (`idAreaType`)
    REFERENCES `discord_bot_rpg`.`areastypes` (`idAreaType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventsAreasTypesDrops_EventSpecificDrops1`
    FOREIGN KEY (`idEvent` , `idBaseItem`)
    REFERENCES `discord_bot_rpg`.`eventspecificdrops` (`idEvent` , `idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventsAreasDrops`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventsareasdrops` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventsareasdrops` (
  `idArea` INT UNSIGNED NOT NULL,
  `idEvent` INT UNSIGNED NOT NULL,
  `idBaseItem` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`, `idEvent`, `idBaseItem`),
  INDEX `fk_EventsAreasDrops_EventSpecificDrops1_idx` (`idEvent` ASC, `idBaseItem` ASC) VISIBLE,
  CONSTRAINT `fk_EventsAreasDrops_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventsAreasDrops_EventSpecificDrops1`
    FOREIGN KEY (`idEvent` , `idBaseItem`)
    REFERENCES `discord_bot_rpg`.`eventspecificdrops` (`idEvent` , `idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

REPLACE INTO eventstypes VALUES
(1, "uncategorized"),
(2, "reccuring"),
(3, "special");

REPLACE INTO events VALUES
(1, 3, "https://freesvg.org/img/nicubunu_Chocolate_birthday_cake.png", "https://cdn.fight-rpg.com/images/events/anniversary_icon.png", 525600, 10080, "2021-06-11 00:00:00", null);

REPLACE INTO eventsglobalmodifiers VALUES
(1, 1, 20), (1, 2, 20), (1, 3, 20), (1, 4, 20), (1, 5, 20), (1, 6, 20);

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationevents` (
  `idEvent` INT(10) UNSIGNED NOT NULL,
  `lang` VARCHAR(5) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `desc` TEXT NOT NULL,
  PRIMARY KEY (`idEvent`, `lang`),
  INDEX `fk_LocalizationEvents_Events1_idx` (`idEvent` ASC) VISIBLE,
  CONSTRAINT `fk_LocalizationEvents_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `discord_bot_rpg`.`languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationEvents_Events1`
    FOREIGN KEY (`idEvent`)
    REFERENCES `discord_bot_rpg`.`events` (`idEvent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

REPLACE INTO localizationevents VALUES
(1, "en", "Fight RPG - Anniversary!", "One more year for FightRPG! Ah, how time flies. Let's celebrate together!"),
(1, "fr", "Fight RPG - Anniversaire !", "Un an de plus pour FightRPG ! Ah, que le temps passe vite. Célébrons ça ensemble !");

ALTER TABLE `discord_bot_rpg`.`itemsbase` 
ADD COLUMN `isInDefaultLootTable` TINYINT(4) NOT NULL DEFAULT 0 AFTER `idSousType`;

UPDATE itemsbase SET isInDefaultLootTable = 1 WHERE idType IN (1,2,3,4) AND idRarity <= 5;


-- Revamp of crafting / resource collect

DELETE FROM `areasresources`;

ALTER TABLE `discord_bot_rpg`.`areasresources` 
DROP FOREIGN KEY `fk_AreasResources_Areas1`,
DROP FOREIGN KEY `fk_AreasResources_ItemsBase1`;

ALTER TABLE `discord_bot_rpg`.`areasresources` 
DROP COLUMN `idBaseItem`,
ADD COLUMN `idCollectableResource` INT NOT NULL AFTER `idArea`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`idArea`, `idCollectableResource`),
ADD INDEX `fk_AreasResources_CollectableResources1_idx` (`idCollectableResource` ASC) VISIBLE,
DROP INDEX `fk_AreasResources_ItemsBase1_idx`;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`collectableresources` (
  `idCollectableResource` INT NOT NULL,
  `idBaseItem` INT UNSIGNED NOT NULL,
  `minLevel` INT UNSIGNED NOT NULL,
  `minRebirthLevel` INT UNSIGNED NOT NULL,
  `percentage` FLOAT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idCollectableResource`),
  INDEX `fk_CollectableResources_ItemsBase1_idx` (`idBaseItem` ASC) VISIBLE,
  INDEX `fk_CollectableResources_LevelsRequire1_idx` (`minLevel` ASC) VISIBLE,
  INDEX `fk_CollectableResources_RebirthsPossibles1_idx` (`minRebirthLevel` ASC) VISIBLE,
  CONSTRAINT `fk_CollectableResources_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CollectableResources_LevelsRequire1`
    FOREIGN KEY (`minLevel`)
    REFERENCES `discord_bot_rpg`.`levelsrequire` (`level`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CollectableResources_RebirthsPossibles1`
    FOREIGN KEY (`minRebirthLevel`)
    REFERENCES `discord_bot_rpg`.`rebirthspossibles` (`rebirthLevel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE `discord_bot_rpg`.`areasresources` 
ADD CONSTRAINT `fk_AreasResources_Areas1`
  FOREIGN KEY (`idArea`)
  REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_AreasResources_CollectableResources1`
  FOREIGN KEY (`idCollectableResource`)
  REFERENCES `discord_bot_rpg`.`collectableresources` (`idCollectableResource`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;



-- subtypes: ore 1, plant 2, wood 3, cloth 18, leather 19, metal 6
REPLACE INTO itemsbase VALUES
(135, 5, 3, 'unknown', 1, 0),
(136, 5, 3, 'unknown', 1, 0),
(137, 5, 3, 'unknown', 1, 0),
(138, 5, 3, 'unknown', 18, 0),
(139, 5, 3, 'unknown', 18, 0),
(140, 5, 3, 'unknown', 18, 0),
(141, 5, 3, 'unknown', 18, 0),
(142, 5, 3, 'unknown', 3, 0),
(143, 5, 3, 'unknown', 3, 0),
(144, 5, 3, 'unknown', 3, 0),
(145, 5, 3, 'unknown', 19, 0),
(146, 5, 3, 'unknown', 19, 0),
(147, 5, 3, 'unknown', 19, 0),
(148, 5, 3, 'unknown', 19, 0),
(149, 5, 4, 'unknown', 1, 0),
(150, 5, 4, 'unknown', 1, 0),
(151, 5, 4, 'unknown', 1, 0),
(152, 5, 4, 'unknown', 18, 0),
(153, 5, 4, 'unknown', 18, 0),
(154, 5, 4, 'unknown', 18, 0),
(155, 5, 4, 'unknown', 18, 0),
(156, 5, 4, 'unknown', 3, 0),
(157, 5, 4, 'unknown', 3, 0),
(158, 5, 4, 'unknown', 3, 0),
(159, 5, 4, 'unknown', 19, 0),
(160, 5, 4, 'unknown', 19, 0),
(161, 5, 4, 'unknown', 19, 0),
(162, 5, 4, 'unknown', 19, 0),
(163, 5, 5, 'unknown', 1, 0),
(164, 5, 5, 'unknown', 1, 0),
(165, 5, 5, 'unknown', 1, 0),
(166, 5, 5, 'unknown', 18, 0),
(167, 5, 5, 'unknown', 18, 0),
(168, 5, 5, 'unknown', 18, 0),
(169, 5, 5, 'unknown', 18, 0),
(170, 5, 5, 'unknown', 3, 0),
(171, 5, 5, 'unknown', 3, 0),
(172, 5, 5, 'unknown', 3, 0),
(173, 5, 5, 'unknown', 19, 0),
(174, 5, 5, 'unknown', 19, 0),
(175, 5, 5, 'unknown', 19, 0),
(176, 5, 5, 'unknown', 19, 0),
(177, 5, 3, 'unknown', 19, 0);

REPLACE INTO localizationitems VALUES
(135, "fr", "Fer Ensablé", ""),
(136, "fr", "Fer Brûlant", ""),
(137, "fr", "Fer Glacial", ""),
(138, "fr", "Lin", ""),
(139, "fr", "Lin Jaune", ""),
(140, "fr", "Lin Rouge", ""),
(141, "fr", "Lin Crystalisé", ""),
(142, "fr", "Bois de Chêne", ""),
(143, "fr", "Bois Brulé", ""),
(144, "fr", "Bois Glacial", ""),
(145, "fr", "Cuir Simple", ""),
(146, "fr", "Cuir Ensablé", ""),
(147, "fr", "Cuir Allumé", ""),
(148, "fr", "Cuir Glacial", ""),
(149, "fr", "Or Sablonneux", ""),
(150, "fr", "Or en fusion", ""),
(151, "fr", "Or Gelé", ""),
(152, "fr", "Coton", ""),
(153, "fr", "Coton Aride", ""),
(154, "fr", "Coton Brûlant", ""),
(155, "fr", "Coton Glacé", ""),
(156, "fr", "Cactus à Branches", ""),
(157, "fr", "Bois Vitrifié", ""),
(158, "fr", "Branche de Glace", ""),
(159, "fr", "Cuir Resistant", ""),
(160, "fr", "Cuir à Rayures", ""),
(161, "fr", "Cuir à Ecailles Rouges", ""),
(162, "fr", "Glace Flexible", ""),
(163, "fr", "Mithril Abimé", ""),
(164, "fr", "Mithril Ensablé", ""),
(165, "fr", "Mithril Déformé par la Chaleur", ""),
(166, "fr", "Laine Magnifique", ""),
(167, "fr", "Laine Aride", ""),
(168, "fr", "Laine Chaude", ""),
(169, "fr", "Laine Froide", ""),
(170, "fr", "Bois Noble", ""),
(171, "fr", "Cactus Royal", ""),
(172, "fr", "Bois de Neige", ""),
(173, "fr", "Cuir de Loup Géant", ""),
(174, "fr", "Cuir de Chameau à Dents de Sabre", ""),
(175, "fr", "Cuir Cuirassé", ""),
(176, "fr", "Cuir de Yéti", ""),
(177, "fr", "Fil à Coudre", ""),
(135, "en", "Sandy Iron"                                ,""),
(136, "en", "Burning Iron"                              ,""),
(137, "en", "Freezing Iron"                             ,""),
(138, "en", "Flax"                                      ,""),
(139, "en", "Yellow Flax"                               ,""),
(140, "en", "Red Flax"                                  ,""),
(141, "en", "Crystallised Flax"                         ,""),
(142, "en", "Oak Wood"                                  ,""),
(143, "en", "Burnt Wood"                                ,""),
(144, "en", "Ice Wood"                                  ,""),
(145, "en", "Leather"                                   ,""),
(146, "en", "Sandy Leather"                             ,""),
(147, "en", "Smoky Leather"                             ,""),
(148, "en", "Frosty Leather"                            ,""),
(149, "en", "Sandy Gold"                                ,""),
(150, "en", "Molten Gold"                               ,""),
(151, "en", "Frozen Gold"                               ,""),
(152, "en", "Cotton"                                    ,""),
(153, "en", "Arid Cotton"                               ,""),
(154, "en", "Burning Cotton"                            ,""),
(155, "en", "Icy Cotton"                                ,""),
(156, "en", "Cactus with Branches"                      ,""),
(157, "en", "Vitrified Wood"                            ,""),
(158, "en", "Ice Branch"                                ,""),
(159, "en", "Resistant Leather"                         ,""),
(160, "en", "Striped Leather"                           ,""),
(161, "en", "Red Scaled Leather"                        ,""),
(162, "en", "Flexible Ice"                              ,""),
(163, "en", "Damaged Mithril"                           ,""),
(164, "en", "Sandy Mithril"                             ,""),
(165, "en", "Heat Deformed Mithril"                     ,""),
(166, "en", "Magnificent Wool"                          ,""),
(167, "en", "Arid Wool"                                 ,""),
(168, "en", "Warm Wool"                                 ,""),
(169, "en", "Cold Wool"                                 ,""),
(170, "en", "Noble Wood"                                ,""),
(171, "en", "Royal Cactus"                              ,""),
(172, "en", "Snow Wood"                                 ,""),
(173, "en", "Giant Wolf Leather"                        ,""),
(174, "en", "Sabre-toothed Camel Leather"               ,""),
(175, "en", "Armored Leather"                           ,""),
(176, "en", "Yeti Leather"                              ,""),
(177, "fr", "Sewing Thread", "");

REPLACE INTO collectableresources VALUES
(1,  23, 1,  0, 0),
(2,  24, 1,  0, 0),
(3,  163, 1, 0, 0),
(4,  142, 1, 0, 0),
(5,  34, 1,  0, 0),
(6,  170, 1, 0, 0),
(7,  138, 1, 0, 0),
(8,  152, 1, 0, 0),
(9,  166, 1, 0, 0),
(10, 145, 1, 0, 0),
(11, 159, 1, 0, 0),
(12, 173, 1, 0, 0),

(13, 135, 40, 0, 0),
(14, 149, 40, 0, 0),
(15, 164, 40, 0, 0),
(16, 33, 40,  0, 0),
(17, 156, 40, 0, 0),
(18, 171, 40, 0, 0),
(19, 139, 40, 0, 0),
(20, 153, 40, 0, 0),
(21, 167, 40, 0, 0),
(22, 146, 40, 0, 0),
(23, 160, 40, 0, 0),
(24, 174, 40, 0, 0),

(25, 136, 60, 0, 0),
(26, 150, 60, 0, 0),
(27, 165, 60, 0, 0),
(28, 143, 60, 0, 0),
(29, 157, 60, 0, 0),
(30, 35, 60, 0, 0),
(31, 140, 60, 0, 0),
(32, 154, 60, 0, 0),
(33, 168, 60, 0, 0),
(34, 147, 60, 0, 0),
(35, 161, 60, 0, 0),
(36, 175, 60, 0, 0),

(37, 137, 80, 0, 0),
(38, 151, 80, 0, 0),
(39, 25, 80, 0, 0),
(40, 144, 80, 0, 0),
(41, 158, 80, 0, 0),
(42, 172, 80, 0, 0),
(43, 141, 80, 0, 0),
(44, 155, 80, 0, 0),
(45, 169, 80, 0, 0),
(46, 148, 80, 0, 0),
(47, 162, 80, 0, 0),
(48, 176, 80, 0, 0),
(49, 30, 0, 0, 0);

REPLACE INTO areasresources VALUES
(1, 5),
(1, 10),
(1, 11),
(1, 12),

(2, 1),
(2, 3),
(2, 7),
(2, 8),
(2, 9),

(3, 2),
(3, 3),
(3, 4),
(3, 6),

(4, 5),
(4, 6),
(4, 10),
(4, 12),

(9, 4),
(9, 5),
(9, 10),
(9, 11),

(10, 3),
(10, 7),
(10, 8),
(10, 9),
(10, 12),

(12, 1),
(12, 2),
(12, 3),
(12, 49),

(13, 4),
(13, 6),
(13, 10),
(13, 11),

(17, 14),
(17, 15),
(17, 23),
(17, 24),

(18, 13),
(18, 15),
(18, 22),
(18, 49),

(19, 16),
(19, 18),
(19, 19),
(19, 20),
(19, 21),

(20, 16),
(20, 17),
(20, 19),
(20, 21),

(23, 25),
(23, 26),
(23, 27),
(23, 49),

(24, 25),
(24, 26),
(24, 27),
(24, 34),
(24, 35),
(24, 36),

(25, 28),
(25, 29),
(25, 30),
(25, 33),

(26, 31),
(26, 32),
(26, 33),
(26, 49),

(28, 37),
(28, 38),
(28, 39),
(28, 41),

(30, 43),
(30, 45),
(30, 46),
(30, 47),

(31, 40),
(31, 42),
(31, 44),
(31, 45),

(32, 41),
(32, 46),
(32, 48),
(32, 49);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
