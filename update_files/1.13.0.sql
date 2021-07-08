-- MySQL Workbench Synchronization
-- Generated: 2021-05-23 12:40
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos
-- Every Links refers to licenced materials, you do not have the right to use them

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`bodytype` (
  `idBodyType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `body` TEXT NOT NULL,
  `head` TEXT NOT NULL,
  `left` TEXT NOT NULL,
  `right` TEXT NOT NULL,
  `left_leg` TEXT NOT NULL,
  PRIMARY KEY (`idBodyType`),
  UNIQUE INDEX `idBodyType_UNIQUE` (`idBodyType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`appearancesType` (
  `idAppearanceType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `propertyName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idAppearanceType`),
  UNIQUE INDEX `idAppearanceType_UNIQUE` (`idAppearanceType` ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`appearances` (
  `idAppearance` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `link` TEXT NOT NULL,
  `idAppearanceType` INT UNSIGNED NOT NULL,
  `idBodyType` INT UNSIGNED NULL,
  `canBeDisplayedOnTop` TINYINT NOT NULL DEFAULT 1,
  `maskLink` TEXT NULL,
  PRIMARY KEY (`idAppearance`),
  INDEX `fk_Appearances_BodyType1_idx` (`idBodyType` ASC) VISIBLE,
  INDEX `fk_Appearances_AppearancesType1_idx` (`idAppearanceType` ASC) VISIBLE,
  UNIQUE INDEX `idAppearance_UNIQUE` (`idAppearance` ASC) VISIBLE,
  CONSTRAINT `fk_Appearances_BodyType1`
    FOREIGN KEY (`idBodyType`)
    REFERENCES `discord_bot_rpg`.`bodytype` (`idBodyType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appearances_AppearancesType1`
    FOREIGN KEY (`idAppearanceType`)
    REFERENCES `discord_bot_rpg`.`appearancestype` (`idAppearanceType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`linkedappearances` (
  `idAppearance` INT UNSIGNED NOT NULL,
  `idLinkedAppearance` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idAppearance`, `idLinkedAppearance`),
  INDEX `fk_LinkedAppearances_Appearances2_idx` (`idLinkedAppearance` ASC) VISIBLE,
  CONSTRAINT `fk_LinkedAppearances_Appearances1`
    FOREIGN KEY (`idAppearance`)
    REFERENCES `discord_bot_rpg`.`appearances` (`idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LinkedAppearances_Appearances2`
    FOREIGN KEY (`idLinkedAppearance`)
    REFERENCES `discord_bot_rpg`.`appearances` (`idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`itemsappearances` (
  `idBaseItem` INT UNSIGNED NOT NULL,
  `idAppearance` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idBaseItem`, `idAppearance`),
  INDEX `fk_ItemsAppearances_Appearances1_idx` (`idAppearance` ASC) VISIBLE,
  CONSTRAINT `fk_ItemsAppearances_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemsAppearances_Appearances1`
    FOREIGN KEY (`idAppearance`)
    REFERENCES `discord_bot_rpg`.`appearances` (`idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`charactersappearanceparts` (
  `idCharacter` INT UNSIGNED NOT NULL,
  `idAppearance` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`, `idAppearance`),
  INDEX `fk_CharactersAppearanceParts_Appearances1_idx` (`idAppearance` ASC) VISIBLE,
  CONSTRAINT `fk_CharacterAppearance_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersAppearanceParts_Appearances1`
    FOREIGN KEY (`idAppearance`)
    REFERENCES `discord_bot_rpg`.`appearances` (`idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`charactersappearance` (
  `idCharacter` INT UNSIGNED NOT NULL,
  `hairColor` VARCHAR(9) NOT NULL,
  `bodyColor` VARCHAR(9) NOT NULL,
  `eyeColor` VARCHAR(9) NOT NULL,
  `idBodyType` INT UNSIGNED NOT NULL,
  `displayHelmet` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idCharacter`),
  INDEX `fk_CharacterAppearance_BodyType1_idx` (`idBodyType` ASC) VISIBLE,
  CONSTRAINT `fk_CharacterAppearance_Characters2`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharacterAppearance_BodyType1`
    FOREIGN KEY (`idBodyType`)
    REFERENCES `discord_bot_rpg`.`bodytype` (`idBodyType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`itemsappearancesmaskcolors` (
  `idBaseItem` INT UNSIGNED NOT NULL,
  `idAppearance` INT UNSIGNED NOT NULL,
  `sourceColor` VARCHAR(10) NOT NULL,
  `targetColor` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idBaseItem`, `idAppearance`, `sourceColor`),
  CONSTRAINT `fk_table1_ItemsAppearances1`
    FOREIGN KEY (`idBaseItem` , `idAppearance`)
    REFERENCES `discord_bot_rpg`.`itemsappearances` (`idBaseItem` , `idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

REPLACE INTO bodytype VALUES
(1,  
"http://cdn.fight-rpg.com/images/appearances/base/bodies/male_body.png", 
"http://cdn.fight-rpg.com/images/appearances/base/bodies/male_head_full.png", 
"http://cdn.fight-rpg.com/images/appearances/base/bodies/male_left_arm_full.png",
"http://cdn.fight-rpg.com/images/appearances/base/bodies/male_right_arm_full.png",
"http://cdn.fight-rpg.com/images/appearances/base/bodies/male_left_leg_full.png"
),
(2,  
"http://cdn.fight-rpg.com/images/appearances/base/bodies/female_body.png", 
"http://cdn.fight-rpg.com/images/appearances/base/bodies/female_head_full.png", 
"http://cdn.fight-rpg.com/images/appearances/base/bodies/female_left_arm_full.png",
"http://cdn.fight-rpg.com/images/appearances/base/bodies/female_right_arm_full.png",
"http://cdn.fight-rpg.com/images/appearances/base/bodies/female_left_leg_full.png"
);

REPLACE INTO appearancestype VALUES
(1, "ear"),
(2, "eyes.front"),
(3, "eyes.back"),
(4, "eyebrow"),
(5, "nose"),
(6, "facialHair"),
(7, "hair.front"),
(8, "hair.back"),
(9, "mouth.teeths"),
(10, "mouth.lips"),
(11, "gloves.left.wrist"),
(12, "gloves.left.hand"),
(13, "gloves.right.wrist"),
(14, "gloves.right.hand"),
(15, "helmet.back"),
(16, "helmet.front"),
(17, "armor.body"),
(18, "armor.neck"),
(19, "armor.lower_left"),
(20, "armor.lower_right"),
(21, "armor.upper_left"),
(22, "armor.upper_right"),
(23, "pants.hip"),
(24, "pants.lower_left"),
(25, "pants.lower_right"),
(26, "pants.upper_left"),
(27, "pants.upper_right"),
(28, "boots.lower_left"),
(29, "boots.lower_right"),
(30, "boots.foot_left"),
(31, "boots.foot_right"),
(32, "weapon.main"),
(33, "weapon.offhand"),
(34, "weapon.shield"),
(35, "weapon.bow");

REPLACE INTO appearances VALUES
(1, "https://cdn.fight-rpg.com/images/appearances/base/ears/human.png", 1, null, 0, null),
(2, "https://cdn.fight-rpg.com/images/appearances/base/ears/orchish.png", 1, null, 0, null),
(3, "https://cdn.fight-rpg.com/images/appearances/base/ears/elf.png", 1, null, 0, null),

(4, "https://cdn.fight-rpg.com/images/appearances/base/eyes/00_02.png", 2, null, 1, null),
(5, "https://cdn.fight-rpg.com/images/appearances/base/eyes/01_02.png", 2, null, 1, null),
(6, "https://cdn.fight-rpg.com/images/appearances/base/eyes/02_02.png", 2, null, 1, null),
(7, "https://cdn.fight-rpg.com/images/appearances/base/eyes/03_02.png", 2, null, 1, null),
(8, "https://cdn.fight-rpg.com/images/appearances/base/eyes/04_02.png", 2, null, 1, null),
(9, "https://cdn.fight-rpg.com/images/appearances/base/eyes/05_02.png", 2, null, 1, null),
(10, "https://cdn.fight-rpg.com/images/appearances/base/eyes/06_02.png", 2, null, 1, null),
(11, "https://cdn.fight-rpg.com/images/appearances/base/eyes/07_02.png", 2, null, 1, null),
(12, "https://cdn.fight-rpg.com/images/appearances/base/eyes/08_02.png", 2, null, 1, null),
(13, "https://cdn.fight-rpg.com/images/appearances/base/eyes/09_02.png", 2, null, 1, null),
(14, "https://cdn.fight-rpg.com/images/appearances/base/eyes/10_02.png", 2, null, 1, null),
(15, "https://cdn.fight-rpg.com/images/appearances/base/eyes/11_02.png", 2, null, 1, null),
(16, "https://cdn.fight-rpg.com/images/appearances/base/eyes/12_02.png", 2, null, 1, null),
(17, "https://cdn.fight-rpg.com/images/appearances/base/eyes/13_02.png", 2, null, 1, null),
(18, "https://cdn.fight-rpg.com/images/appearances/base/eyes/14_02.png", 2, null, 1, null),
(19, "https://cdn.fight-rpg.com/images/appearances/base/eyes/15_02.png", 2, null, 1, null),

(20, "https://cdn.fight-rpg.com/images/appearances/base/eyes/00_01.png", 3, null, 1, null),
(21, "https://cdn.fight-rpg.com/images/appearances/base/eyes/01_01.png", 3, null, 1, null),
(22, "https://cdn.fight-rpg.com/images/appearances/base/eyes/02_01.png", 3, null, 1, null),
(23, "https://cdn.fight-rpg.com/images/appearances/base/eyes/03_01.png", 3, null, 1, null),
(24, "https://cdn.fight-rpg.com/images/appearances/base/eyes/04_01.png", 3, null, 1, null),
(25, "https://cdn.fight-rpg.com/images/appearances/base/eyes/05_01.png", 3, null, 1, null),
(26, "https://cdn.fight-rpg.com/images/appearances/base/eyes/06_01.png", 3, null, 1, null),
(27, "https://cdn.fight-rpg.com/images/appearances/base/eyes/07_01.png", 3, null, 1, null),
(28, "https://cdn.fight-rpg.com/images/appearances/base/eyes/08_01.png", 3, null, 1, null),
(29, "https://cdn.fight-rpg.com/images/appearances/base/eyes/09_01.png", 3, null, 1, null),
(30, "https://cdn.fight-rpg.com/images/appearances/base/eyes/10_01.png", 3, null, 1, null),
(31, "https://cdn.fight-rpg.com/images/appearances/base/eyes/11_01.png", 3, null, 1, null),
(32, "https://cdn.fight-rpg.com/images/appearances/base/eyes/12_01.png", 3, null, 1, null),
(33, "https://cdn.fight-rpg.com/images/appearances/base/eyes/13_01.png", 3, null, 1, null),
(34, "https://cdn.fight-rpg.com/images/appearances/base/eyes/14_01.png", 3, null, 1, null),
(35, "https://cdn.fight-rpg.com/images/appearances/base/eyes/15_01.png", 3, null, 1, null),

(36, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/00.png", 4, null, 1, null),
(37, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/01.png", 4, null, 1, null),
(38, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/02.png", 4, null, 1, null),
(39, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/03.png", 4, null, 1, null),
(40, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/04.png", 4, null, 1, null),
(41, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/05.png", 4, null, 1, null),
(42, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/06.png", 4, null, 1, null),
(43, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/07.png", 4, null, 1, null),
(44, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/08.png", 4, null, 1, null),
(45, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/09.png", 4, null, 1, null),
(46, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/10.png", 4, null, 1, null),
(47, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/11.png", 4, null, 1, null),
(48, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/12.png", 4, null, 1, null),
(49, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/13.png", 4, null, 1, null),
(50, "https://cdn.fight-rpg.com/images/appearances/base/eyebrows/14.png", 4, null, 1, null),

(51, "https://cdn.fight-rpg.com/images/appearances/base/noses/00.png", 5, null, 1, null),
(52, "https://cdn.fight-rpg.com/images/appearances/base/noses/01.png", 5, null, 1, null),
(53, "https://cdn.fight-rpg.com/images/appearances/base/noses/02.png", 5, null, 1, null),
(54, "https://cdn.fight-rpg.com/images/appearances/base/noses/03.png", 5, null, 1, null),
(55, "https://cdn.fight-rpg.com/images/appearances/base/noses/04.png", 5, null, 1, null),
(56, "https://cdn.fight-rpg.com/images/appearances/base/noses/05.png", 5, null, 1, null),
(57, "https://cdn.fight-rpg.com/images/appearances/base/noses/06.png", 5, null, 1, null),
(58, "https://cdn.fight-rpg.com/images/appearances/base/noses/07.png", 5, null, 1, null),
(59, "https://cdn.fight-rpg.com/images/appearances/base/noses/08.png", 5, null, 1, null),
(60, "https://cdn.fight-rpg.com/images/appearances/base/noses/09.png", 5, null, 1, null),
(61, "https://cdn.fight-rpg.com/images/appearances/base/noses/10.png", 5, null, 1, null),

(62, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/00.png", 6, 1, 1, null),
(63, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/01.png", 6, 1, 1, null),
(64, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/02.png", 6, null, 1, null),
(65, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/03.png", 6, null, 1, null),
(66, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/04.png", 6, 1, 1, null),
(67, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/05.png", 6, 1, 1, null),
(68, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/06.png", 6, 1, 1, null),
(69, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/07.png", 6, 1, 1, null),
(70, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/08.png", 6, null, 1, null),
(71, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/09.png", 6, null, 1, null),
(72, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/10.png", 6, 1, 1, null),
(73, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/11.png", 6, null, 1, null),
(74, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/12.png", 6, null, 1, null),
(75, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/13.png", 6, 1, 1, null),
(76, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/14.png", 6, null, 1, null),
(77, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/15.png", 6, 1, 1, null),
(78, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/16.png", 6, null, 1, null),
(79, "https://cdn.fight-rpg.com/images/appearances/base/facialhairs/17.png", 6, 1, 1, null),

(80, "https://cdn.fight-rpg.com/images/appearances/base/hairs/00.png", 7, null, 1, null),
(81, "https://cdn.fight-rpg.com/images/appearances/base/hairs/01.png", 7, null, 1, null),
(82, "https://cdn.fight-rpg.com/images/appearances/base/hairs/02.png", 7, null, 1, null),
(83, "https://cdn.fight-rpg.com/images/appearances/base/hairs/03.png", 7, null, 1, null),
(84, "https://cdn.fight-rpg.com/images/appearances/base/hairs/04.png", 7, null, 1, null),
(85, "https://cdn.fight-rpg.com/images/appearances/base/hairs/05.png", 7, null, 1, null),
(86, "https://cdn.fight-rpg.com/images/appearances/base/hairs/06.png", 7, null, 1, null),
(87, "https://cdn.fight-rpg.com/images/appearances/base/hairs/07.png", 7, null, 1, null),
(88, "https://cdn.fight-rpg.com/images/appearances/base/hairs/08.png", 7, null, 1, null),
(89, "https://cdn.fight-rpg.com/images/appearances/base/hairs/09.png", 7, null, 1, null),
(90, "https://cdn.fight-rpg.com/images/appearances/base/hairs/10.png", 7, null, 1, null),
(91, "https://cdn.fight-rpg.com/images/appearances/base/hairs/11.png", 7, null, 1, null),
(92, "https://cdn.fight-rpg.com/images/appearances/base/hairs/12.png", 7, null, 1, null),
(93, "https://cdn.fight-rpg.com/images/appearances/base/hairs/13.png", 7, null, 1, null),
(94, "https://cdn.fight-rpg.com/images/appearances/base/hairs/14.png", 7, null, 1, null),
(95, "https://cdn.fight-rpg.com/images/appearances/base/hairs/15.png", 7, null, 1, null),
(96, "https://cdn.fight-rpg.com/images/appearances/base/hairs/16.png", 7, null, 1, null),
(97, "https://cdn.fight-rpg.com/images/appearances/base/hairs/17.png", 7, null, 1, null),
(98, "https://cdn.fight-rpg.com/images/appearances/base/hairs/18.png", 7, null, 1, null),
(99, "https://cdn.fight-rpg.com/images/appearances/base/hairs/19.png", 7, null, 1, null),
(100,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/20.png", 7, null, 1, null),
(101,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/21.png", 7, null, 1, null),
(102,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/22.png", 7, null, 1, null),
(103,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/23.png", 7, null, 1, null),
(104,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/24.png", 7, null, 1, null),
(105,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/25.png", 7, null, 1, null),

(106,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/04_back.png", 8, null, 1, null),
(107,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/05_back.png", 8, null, 1, null),
(108,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/11_back.png", 8, null, 1, null),
(109,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/13_back.png", 8, null, 1, null),
(110,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/14_back.png", 8, null, 1, null),
(111,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/15_back.png", 8, null, 1, null),
(112,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/16_back.png", 8, null, 1, null),
(113,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/17_back.png", 8, null, 1, null),
(114,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/19_back.png", 8, null, 1, null),
(115,  "https://cdn.fight-rpg.com/images/appearances/base/hairs/20_back.png", 8, null, 1, null),

(116,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/03_back.png", 9, null, 1, null),
(117,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/06_back.png", 9, null, 1, null),
(118,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/07_back.png", 9, null, 1, null),

(119,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/00.png", 10, null, 1, null),
(120,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/01.png", 10, null, 1, null),
(121,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/02.png", 10, null, 1, null),
(122,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/03.png", 10, null, 1, null),
(123,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/04.png", 10, null, 1, null),
(124,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/05.png", 10, null, 1, null),
(125,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/06.png", 10, null, 1, null),
(126,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/07.png", 10, null, 1, null),
(127,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/08.png", 10, null, 1, null),
(128,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/09.png", 10, null, 1, null),
(129,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/10.png", 10, null, 1, null),
(130,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/11.png", 10, null, 1, null),
(131,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/12.png", 10, null, 1, null),
(132,  "https://cdn.fight-rpg.com/images/appearances/base/mouths/13.png", 10, null, 1, null),

(133, "https://cdn.fight-rpg.com/images/appearances/armor/Fantasy%2006%20Male_body.png", 16, null, 1, "https://cdn.fight-rpg.com/images/appearances/armor/Fantasy%2006%20Male%20Mask_body.png");

REPLACE INTO linkedappearances VALUES 
(4, 20), 
(5, 21), 
(6, 22), 
(7, 23), 
(8, 24), 
(9, 25), 
(10, 26), 
(11, 27), 
(12, 28), 
(13, 29), 
(14, 30), 
(15, 31), 
(16, 32), 
(17, 33), 
(18, 34), 
(19, 35), 

(84, 106), 
(85, 107), 
(91, 108), 
(93, 109), 
(94, 110), 
(95, 111), 
(96, 112), 
(97, 113), 
(99, 114), 
(100, 115), 

(116, 122), 
(117, 125), 
(118, 126);


REPLACE INTO charactersappearance 
(
    SELECT idCharacter, "#241C11" as hairColor, "#BD804A" as bodyColor, "#634E34" as eyeColor, 1 as idBodyType, 1 as displayHelmet
    FROM characters
);

REPLACE INTO charactersappearanceparts
(
    SELECT idCharacter, idAppearance 
    FROM characters 
    JOIN 
    (
        SELECT idAppearance, idAppearanceType 
        FROM appearances 
        WHERE idAppearanceType IN (1,2,3,4,5,7,9,10)
        GROUP BY idAppearanceType
    ) ap
);




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
