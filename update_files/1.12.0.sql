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
(1, 2, "https://freesvg.org/img/nicubunu_Chocolate_birthday_cake.png", "https://cdn.fight-rpg.com/images/events/anniversary_icon.png", 525600, 10080, "2021-06-11 00:00:00", null),
(2, 3, "", "", 99999, 7200, "2021-05-17 00:00:00", "2021-05-21 00:00:00");

REPLACE INTO eventsglobalmodifiers VALUES
(1, 1, 20), (1, 2, 20), (1, 3, 20), (1, 4, 20), (1, 5, 20), (1, 6, 20),
(2, 2, 25), (2, 3, 25), (2, 6, 25);

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
(1, "fr", "Fight RPG - Anniversaire !", "Un an de plus pour FightRPG ! Ah, que le temps passe vite. C�l�brons �a ensemble !"),
(2, "fr", "A vos marques, pr�ts, collectez !", "Un bonus � la r�colte est n�cessaire au vu des changements apport�s aux ingr�dients n�cessaires pour fabriquer les objets."),
(2, "en", "Update 1.12 - On your marks, set, collect!", "A harvest bonus is required due to changes in the ingredients needed to make items");

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
(135, "fr", "Fer Ensabl�", ""),
(136, "fr", "Fer Br�lant", ""),
(137, "fr", "Fer Glacial", ""),
(138, "fr", "Lin", ""),
(139, "fr", "Lin Jaune", ""),
(140, "fr", "Lin Rouge", ""),
(141, "fr", "Lin Crystalis�", ""),
(142, "fr", "Bois de Ch�ne", ""),
(143, "fr", "Bois Brul�", ""),
(144, "fr", "Bois Glacial", ""),
(145, "fr", "Cuir Simple", ""),
(146, "fr", "Cuir Ensabl�", ""),
(147, "fr", "Cuir Allum�", ""),
(148, "fr", "Cuir Glacial", ""),
(149, "fr", "Or Sablonneux", ""),
(150, "fr", "Or en fusion", ""),
(151, "fr", "Or Gel�", ""),
(152, "fr", "Coton", ""),
(153, "fr", "Coton Aride", ""),
(154, "fr", "Coton Br�lant", ""),
(155, "fr", "Coton Glac�", ""),
(156, "fr", "Cactus � Branches", ""),
(157, "fr", "Bois Vitrifi�", ""),
(158, "fr", "Branche de Glace", ""),
(159, "fr", "Cuir Resistant", ""),
(160, "fr", "Cuir � Rayures", ""),
(161, "fr", "Cuir � Ecailles Rouges", ""),
(162, "fr", "Glace Flexible", ""),
(163, "fr", "Mithril Abim�", ""),
(164, "fr", "Mithril Ensabl�", ""),
(165, "fr", "Mithril D�form� par la Chaleur", ""),
(166, "fr", "Laine Magnifique", ""),
(167, "fr", "Laine Aride", ""),
(168, "fr", "Laine Chaude", ""),
(169, "fr", "Laine Froide", ""),
(170, "fr", "Bois Noble", ""),
(171, "fr", "Cactus Royal", ""),
(172, "fr", "Bois de Neige", ""),
(173, "fr", "Cuir de Loup G�ant", ""),
(174, "fr", "Cuir de Chameau � Dents de Sabre", ""),
(175, "fr", "Cuir Cuirass�", ""),
(176, "fr", "Cuir de Y�ti", ""),
(177, "fr", "Fil � Coudre", ""),
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


-- New crafting receipes
DELETE FROM craftitemsneeded WHERE idCraftItem < 21 OR  idCraftItem > 34;
DELETE FROM craftitem WHERE idCraftItem < 21 OR idCraftItem > 34;

REPLACE INTO craftitem VALUES
(1, 40, 1, 3, 0, 0),
(2, 60, 41, 3, 0, 0),
(3, 80, 61, 3, 0, 0),
(4, 100, 81, 3, 0, 0),
(5, 40, 1, 4, 0, 0),
(6, 60, 41, 4, 0, 0),
(7, 80, 61, 4, 0, 0),
(8, 100, 81, 4, 0, 0),
(9, 40, 1, 5, 0, 0),
(10, 60, 41, 5, 0, 0),
(11, 80, 61, 5, 0, 0),
(12, 100, 81, 5, 0, 0),
(13, 40, 1, 8, 0, 0),
(14, 60, 41, 8, 0, 0),
(15, 80, 61, 8, 0, 0),
(16, 100, 81, 8, 0, 0),
(17, 40, 1, 9, 0, 0),
(18, 60, 41, 9, 0, 0),
(19, 80, 61, 9, 0, 0),
(20, 100, 81, 9, 0, 0),
(35, 40, 1, 10, 0, 0),
(36, 60, 41, 10, 0, 0),
(37, 80, 61, 10, 0, 0),
(38, 100, 81, 10, 0, 0),
(39, 40, 1, 13, 0, 0),
(40, 60, 41, 13, 0, 0),
(41, 80, 61, 13, 0, 0),
(42, 100, 81, 13, 0, 0),
(43, 40, 1, 14, 0, 0),
(44, 60, 41, 14, 0, 0),
(45, 80, 61, 14, 0, 0),
(46, 100, 81, 14, 0, 0),
(47, 40, 1, 15, 0, 0),
(48, 60, 41, 15, 0, 0),
(49, 80, 61, 15, 0, 0),
(50, 100, 81, 15, 0, 0),
(51, 40, 1, 18, 0, 0),
(52, 60, 41, 18, 0, 0),
(53, 80, 61, 18, 0, 0),
(54, 100, 81, 18, 0, 0),
(55, 40, 1, 19, 0, 0),
(56, 60, 41, 19, 0, 0),
(57, 80, 61, 19, 0, 0),
(58, 100, 81, 19, 0, 0),
(59, 40, 1, 20, 0, 0),
(60, 60, 41, 20, 0, 0),
(61, 80, 61, 20, 0, 0),
(62, 100, 81, 20, 0, 0),
(63, 40, 1, 77, 0, 0),
(64, 60, 41, 77, 0, 0),
(65, 80, 61, 77, 0, 0),
(66, 100, 81, 77, 0, 0),
(67, 40, 1, 78, 0, 0),
(68, 60, 41, 78, 0, 0),
(69, 80, 61, 78, 0, 0),
(70, 100, 81, 78, 0, 0),
(71, 40, 1, 79, 0, 0),
(72, 60, 41, 79, 0, 0),
(73, 80, 61, 79, 0, 0),
(74, 100, 81, 79, 0, 0),
(75, 40, 1, 83, 0, 0),
(76, 60, 41, 83, 0, 0),
(77, 80, 61, 83, 0, 0),
(78, 100, 81, 83, 0, 0),
(79, 40, 1, 84, 0, 0),
(80, 60, 41, 84, 0, 0),
(81, 80, 61, 84, 0, 0),
(82, 100, 81, 84, 0, 0),
(83, 40, 1, 85, 0, 0),
(84, 60, 41, 85, 0, 0),
(85, 80, 61, 85, 0, 0),
(86, 100, 81, 85, 0, 0),
(87, 40, 1, 89, 0, 0),
(88, 60, 41, 89, 0, 0),
(89, 80, 61, 89, 0, 0),
(90, 100, 81, 89, 0, 0),
(91, 40, 1, 90, 0, 0),
(92, 60, 41, 90, 0, 0),
(93, 80, 61, 90, 0, 0),
(94, 100, 81, 90, 0, 0),
(95, 40, 1, 91, 0, 0),
(96, 60, 41, 91, 0, 0),
(97, 80, 61, 91, 0, 0),
(98, 100, 81, 91, 0, 0),
(99, 40, 1, 95, 0, 0),
(100, 60, 41, 95, 0, 0),
(101, 80, 61, 95, 0, 0),
(102, 100, 81, 95, 0, 0),
(103, 40, 1, 96, 0, 0),
(104, 60, 41, 96, 0, 0),
(105, 80, 61, 96, 0, 0),
(106, 100, 81, 96, 0, 0),
(107, 40, 1, 97, 0, 0),
(108, 60, 41, 97, 0, 0),
(109, 80, 61, 97, 0, 0),
(110, 100, 81, 97, 0, 0),
(111, 40, 1, 101, 0, 0),
(112, 60, 41, 101, 0, 0),
(113, 80, 61, 101, 0, 0),
(114, 100, 81, 101, 0, 0),
(115, 40, 1, 102, 0, 0),
(116, 60, 41, 102, 0, 0),
(117, 80, 61, 102, 0, 0),
(118, 100, 81, 102, 0, 0),
(119, 40, 1, 103, 0, 0),
(120, 60, 41, 103, 0, 0),
(121, 80, 61, 103, 0, 0),
(122, 100, 81, 103, 0, 0),
(123, 40, 1, 107, 0, 0),
(124, 60, 41, 107, 0, 0),
(125, 80, 61, 107, 0, 0),
(126, 100, 81, 107, 0, 0),
(127, 40, 1, 108, 0, 0),
(128, 60, 41, 108, 0, 0),
(129, 80, 61, 108, 0, 0),
(130, 100, 81, 108, 0, 0),
(131, 40, 1, 109, 0, 0),
(132, 60, 41, 109, 0, 0),
(133, 80, 61, 109, 0, 0),
(134, 100, 81, 109, 0, 0),
(135, 40, 1, 113, 0, 0),
(136, 60, 41, 113, 0, 0),
(137, 80, 61, 113, 0, 0),
(138, 100, 81, 113, 0, 0),
(139, 40, 1, 114, 0, 0),
(140, 60, 41, 114, 0, 0),
(141, 80, 61, 114, 0, 0),
(142, 100, 81, 114, 0, 0),
(143, 40, 1, 115, 0, 0),
(144, 60, 41, 115, 0, 0),
(145, 80, 61, 115, 0, 0),
(146, 100, 81, 115, 0, 0),
(147, 40, 1, 119, 0, 0),
(148, 60, 41, 119, 0, 0),
(149, 80, 61, 119, 0, 0),
(150, 100, 81, 119, 0, 0),
(151, 40, 1, 120, 0, 0),
(152, 60, 41, 120, 0, 0),
(153, 80, 61, 120, 0, 0),
(154, 100, 81, 120, 0, 0),
(155, 40, 1, 121, 0, 0),
(156, 60, 41, 121, 0, 0),
(157, 80, 61, 121, 0, 0),
(158, 100, 81, 121, 0, 0),
(159, 40, 1, 125, 0, 0),
(160, 60, 41, 125, 0, 0),
(161, 80, 61, 125, 0, 0),
(162, 100, 81, 125, 0, 0),
(163, 40, 1, 126, 0, 0),
(164, 60, 41, 126, 0, 0),
(165, 80, 61, 126, 0, 0),
(166, 100, 81, 126, 0, 0),
(167, 40, 1, 127, 0, 0),
(168, 60, 41, 127, 0, 0),
(169, 80, 61, 127, 0, 0),
(170, 100, 81, 127, 0, 0),
(171, 40, 1, 131, 0, 0),
(172, 60, 41, 131, 0, 0),
(173, 80, 61, 131, 0, 0),
(174, 100, 81, 131, 0, 0),
(175, 40, 1, 132, 0, 0),
(176, 60, 41, 132, 0, 0),
(177, 80, 61, 132, 0, 0),
(178, 100, 81, 132, 0, 0),
(179, 40, 1, 133, 0, 0),
(180, 60, 41, 133, 0, 0),
(181, 80, 61, 133, 0, 0),
(182, 100, 81, 133, 0, 0);
REPLACE INTO craftitemsneeded
VALUES (1, 23, 1, 0),
(2, 135, 1, 0),
(3, 136, 1, 0),
(4, 137, 1, 0),
(5, 24, 1, 0),
(5, 23, 1, 0),
(5, 142, 1, 0),
(6, 149, 1, 0),
(6, 135, 1, 0),
(6, 33, 1, 0),
(7, 150, 1, 0),
(7, 136, 1, 0),
(7, 143, 1, 0),
(8, 151, 1, 0),
(8, 137, 1, 0),
(8, 144, 1, 0),
(9, 163, 2, 0),
(9, 24, 2, 0),
(9, 23, 1, 0),
(9, 142, 1, 0),
(9, 145, 1, 0),
(10, 164, 2, 0),
(10, 149, 2, 0),
(10, 135, 1, 0),
(10, 33, 1, 0),
(10, 146, 1, 0),
(11, 165, 2, 0),
(11, 150, 2, 0),
(11, 136, 1, 0),
(11, 143, 1, 0),
(11, 147, 1, 0),
(12, 25, 2, 0),
(12, 151, 2, 0),
(12, 137, 1, 0),
(12, 144, 1, 0),
(12, 148, 1, 0),
(13, 23, 1, 0),
(14, 135, 1, 0),
(15, 136, 1, 0),
(16, 137, 1, 0),
(17, 24, 1, 0),
(17, 23, 2, 0),
(18, 149, 1, 0),
(18, 135, 2, 0),
(19, 150, 1, 0),
(19, 136, 2, 0),
(20, 151, 1, 0),
(20, 137, 2, 0),
(35, 163, 2, 0),
(35, 24, 2, 0),
(35, 23, 2, 0),
(35, 138, 1, 0),
(36, 164, 2, 0),
(36, 149, 2, 0),
(36, 135, 2, 0),
(36, 139, 1, 0),
(37, 165, 2, 0),
(37, 150, 2, 0),
(37, 136, 2, 0),
(37, 140, 1, 0),
(38, 25, 2, 0),
(38, 151, 2, 0),
(38, 137, 2, 0),
(38, 141, 1, 0),
(39, 23, 1, 0),
(40, 135, 1, 0),
(41, 136, 1, 0),
(42, 137, 1, 0),
(43, 24, 1, 0),
(43, 23, 2, 0),
(44, 149, 1, 0),
(44, 135, 2, 0),
(45, 150, 1, 0),
(45, 136, 2, 0),
(46, 151, 1, 0),
(46, 137, 2, 0),
(47, 163, 2, 0),
(47, 24, 2, 0),
(47, 23, 2, 0),
(47, 138, 1, 0),
(48, 164, 2, 0),
(48, 149, 2, 0),
(48, 135, 2, 0),
(48, 139, 1, 0),
(49, 165, 2, 0),
(49, 150, 2, 0),
(49, 136, 2, 0),
(49, 140, 1, 0),
(50, 25, 2, 0),
(50, 151, 2, 0),
(50, 137, 2, 0),
(50, 141, 1, 0),
(51, 23, 1, 0),
(52, 135, 1, 0),
(53, 136, 1, 0),
(54, 137, 1, 0),
(55, 24, 1, 0),
(55, 23, 2, 0),
(56, 149, 1, 0),
(56, 135, 2, 0),
(57, 150, 1, 0),
(57, 136, 2, 0),
(58, 151, 1, 0),
(58, 137, 2, 0),
(59, 163, 2, 0),
(59, 24, 2, 0),
(59, 23, 2, 0),
(59, 138, 1, 0),
(60, 164, 2, 0),
(60, 149, 2, 0),
(60, 135, 2, 0),
(60, 139, 1, 0),
(61, 165, 2, 0),
(61, 150, 2, 0),
(61, 136, 2, 0),
(61, 140, 1, 0),
(62, 25, 2, 0),
(62, 151, 2, 0),
(62, 137, 2, 0),
(62, 141, 1, 0),
(63, 142, 1, 0),
(64, 33, 1, 0),
(65, 143, 1, 0),
(66, 144, 1, 0),
(67, 34, 1, 0),
(67, 142, 2, 0),
(68, 156, 1, 0),
(68, 33, 2, 0),
(69, 157, 1, 0),
(69, 143, 2, 0),
(70, 158, 1, 0),
(70, 144, 2, 0),
(71, 170, 2, 0),
(71, 34, 2, 0),
(71, 142, 2, 0),
(71, 138, 1, 0),
(72, 171, 2, 0),
(72, 156, 2, 0),
(72, 33, 2, 0),
(72, 139, 1, 0),
(73, 35, 2, 0),
(73, 157, 2, 0),
(73, 143, 2, 0),
(73, 140, 1, 0),
(74, 172, 2, 0),
(74, 158, 2, 0),
(74, 144, 2, 0),
(74, 141, 1, 0),
(75, 23, 1, 0),
(76, 135, 1, 0),
(77, 136, 1, 0),
(78, 137, 1, 0),
(79, 24, 1, 0),
(79, 23, 1, 0),
(79, 142, 1, 0),
(80, 149, 1, 0),
(80, 135, 1, 0),
(80, 33, 1, 0),
(81, 150, 1, 0),
(81, 136, 1, 0),
(81, 143, 1, 0),
(82, 151, 1, 0),
(82, 137, 1, 0),
(82, 144, 1, 0),
(83, 163, 2, 0),
(83, 24, 2, 0),
(83, 142, 1, 0),
(83, 145, 1, 0),
(84, 164, 2, 0),
(84, 149, 2, 0),
(84, 33, 1, 0),
(84, 146, 1, 0),
(85, 165, 2, 0),
(85, 150, 2, 0),
(85, 143, 1, 0),
(85, 147, 1, 0),
(86, 25, 2, 0),
(86, 151, 2, 0),
(86, 144, 1, 0),
(86, 148, 1, 0),
(87, 142, 1, 0),
(88, 33, 1, 0),
(89, 143, 1, 0),
(90, 144, 1, 0),
(91, 34, 1, 0),
(91, 142, 2, 0),
(92, 156, 1, 0),
(92, 33, 2, 0),
(93, 157, 1, 0),
(93, 143, 2, 0),
(94, 158, 1, 0),
(94, 144, 2, 0),
(95, 170, 2, 0),
(95, 34, 2, 0),
(95, 142, 3, 0),
(96, 171, 2, 0),
(96, 156, 2, 0),
(96, 33, 3, 0),
(97, 35, 2, 0),
(97, 157, 2, 0),
(97, 143, 3, 0),
(98, 172, 2, 0),
(98, 158, 2, 0),
(98, 144, 3, 0),
(99, 142, 1, 0),
(99, 23, 1, 0),
(100, 33, 1, 0),
(100, 135, 1, 0),
(101, 143, 1, 0),
(101, 136, 1, 0),
(102, 144, 1, 0),
(102, 137, 1, 0),
(103, 34, 1, 0),
(103, 142, 2, 0),
(103, 23, 2, 0),
(104, 156, 1, 0),
(104, 33, 2, 0),
(104, 135, 2, 0),
(105, 157, 1, 0),
(105, 143, 2, 0),
(105, 136, 2, 0),
(106, 158, 1, 0),
(106, 144, 2, 0),
(106, 137, 2, 0),
(107, 170, 2, 0),
(107, 34, 2, 0),
(107, 142, 3, 0),
(107, 23, 3, 0),
(108, 171, 2, 0),
(108, 156, 2, 0),
(108, 33, 3, 0),
(108, 135, 3, 0),
(109, 35, 2, 0),
(109, 157, 2, 0),
(109, 143, 3, 0),
(109, 136, 3, 0),
(110, 172, 2, 0),
(110, 158, 2, 0),
(110, 144, 3, 0),
(110, 137, 3, 0),
(111, 138, 1, 0),
(112, 139, 1, 0),
(113, 140, 1, 0),
(114, 141, 1, 0),
(115, 152, 1, 0),
(115, 138, 2, 0),
(116, 153, 1, 0),
(116, 139, 2, 0),
(117, 154, 1, 0),
(117, 140, 2, 0),
(118, 155, 1, 0),
(118, 141, 2, 0),
(119, 166, 2, 0),
(119, 152, 2, 0),
(119, 138, 3, 0),
(120, 167, 2, 0),
(120, 153, 2, 0),
(120, 139, 3, 0),
(121, 168, 2, 0),
(121, 154, 2, 0),
(121, 140, 3, 0),
(122, 169, 2, 0),
(122, 155, 2, 0),
(122, 141, 3, 0),
(123, 145, 1, 0),
(123, 138, 1, 0),
(124, 146, 1, 0),
(124, 139, 1, 0),
(125, 147, 1, 0),
(125, 140, 1, 0),
(126, 148, 1, 0),
(126, 141, 1, 0),
(127, 159, 1, 0),
(127, 145, 2, 0),
(127, 138, 2, 0),
(128, 160, 1, 0),
(128, 146, 2, 0),
(128, 139, 2, 0),
(129, 161, 1, 0),
(129, 147, 2, 0),
(129, 140, 2, 0),
(130, 162, 1, 0),
(130, 148, 2, 0),
(130, 141, 2, 0),
(131, 173, 2, 0),
(131, 159, 2, 0),
(131, 145, 3, 0),
(131, 138, 3, 0),
(132, 174, 2, 0),
(132, 160, 2, 0),
(132, 146, 3, 0),
(132, 139, 3, 0),
(133, 175, 2, 0),
(133, 161, 2, 0),
(133, 147, 3, 0),
(133, 140, 3, 0),
(134, 176, 2, 0),
(134, 162, 2, 0),
(134, 148, 3, 0),
(134, 141, 3, 0),
(135, 138, 1, 0),
(136, 139, 1, 0),
(137, 140, 1, 0),
(138, 141, 1, 0),
(139, 152, 1, 0),
(139, 138, 2, 0),
(140, 153, 1, 0),
(140, 139, 2, 0),
(141, 154, 1, 0),
(141, 140, 2, 0),
(142, 155, 1, 0),
(142, 141, 2, 0),
(143, 166, 2, 0),
(143, 152, 2, 0),
(143, 138, 3, 0),
(144, 167, 2, 0),
(144, 153, 2, 0),
(144, 139, 3, 0),
(145, 168, 2, 0),
(145, 154, 2, 0),
(145, 140, 3, 0),
(146, 169, 2, 0),
(146, 155, 2, 0),
(146, 141, 3, 0),
(147, 145, 1, 0),
(147, 138, 1, 0),
(148, 146, 1, 0),
(148, 139, 1, 0),
(149, 147, 1, 0),
(149, 140, 1, 0),
(150, 148, 1, 0),
(150, 141, 1, 0),
(151, 159, 1, 0),
(151, 145, 2, 0),
(151, 138, 2, 0),
(152, 160, 1, 0),
(152, 146, 2, 0),
(152, 139, 2, 0),
(153, 161, 1, 0),
(153, 147, 2, 0),
(153, 140, 2, 0),
(154, 162, 1, 0),
(154, 148, 2, 0),
(154, 141, 2, 0),
(155, 173, 2, 0),
(155, 159, 2, 0),
(155, 145, 3, 0),
(155, 138, 3, 0),
(156, 174, 2, 0),
(156, 160, 2, 0),
(156, 146, 3, 0),
(156, 139, 3, 0),
(157, 175, 2, 0),
(157, 161, 2, 0),
(157, 147, 3, 0),
(157, 140, 3, 0),
(158, 176, 2, 0),
(158, 162, 2, 0),
(158, 148, 3, 0),
(158, 141, 3, 0),
(159, 138, 1, 0),
(160, 139, 1, 0),
(161, 140, 1, 0),
(162, 141, 1, 0),
(163, 152, 1, 0),
(163, 138, 2, 0),
(164, 153, 1, 0),
(164, 139, 2, 0),
(165, 154, 1, 0),
(165, 140, 2, 0),
(166, 155, 1, 0),
(166, 141, 2, 0),
(167, 166, 2, 0),
(167, 152, 2, 0),
(167, 138, 3, 0),
(168, 167, 2, 0),
(168, 153, 2, 0),
(168, 139, 3, 0),
(169, 168, 2, 0),
(169, 154, 2, 0),
(169, 140, 3, 0),
(170, 169, 2, 0),
(170, 155, 2, 0),
(170, 141, 3, 0),
(171, 145, 1, 0),
(171, 138, 1, 0),
(172, 146, 1, 0),
(172, 139, 1, 0),
(173, 147, 1, 0),
(173, 140, 1, 0),
(174, 148, 1, 0),
(174, 141, 1, 0),
(175, 159, 1, 0),
(175, 145, 2, 0),
(175, 138, 2, 0),
(176, 160, 1, 0),
(176, 146, 2, 0),
(176, 139, 2, 0),
(177, 161, 1, 0),
(177, 147, 2, 0),
(177, 140, 2, 0),
(178, 162, 1, 0),
(178, 148, 2, 0),
(178, 141, 2, 0),
(179, 173, 2, 0),
(179, 159, 2, 0),
(179, 145, 3, 0),
(179, 138, 3, 0),
(180, 174, 2, 0),
(180, 160, 2, 0),
(180, 146, 3, 0),
(180, 139, 3, 0),
(181, 175, 2, 0),
(181, 161, 2, 0),
(181, 147, 3, 0),
(181, 140, 3, 0),
(182, 176, 2, 0),
(182, 162, 2, 0),
(182, 148, 3, 0),
(182, 141, 3, 0);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
