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

CREATE TABLE IF NOT EXISTS `bodytype` (
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

CREATE TABLE IF NOT EXISTS `appearancestype` (
  `idAppearanceType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `propertyName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idAppearanceType`),
  UNIQUE INDEX `idAppearanceType_UNIQUE` (`idAppearanceType` ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `appearances` (
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
    REFERENCES `bodytype` (`idBodyType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appearances_AppearancesType1`
    FOREIGN KEY (`idAppearanceType`)
    REFERENCES `appearancestype` (`idAppearanceType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `linkedappearances` (
  `idAppearance` INT UNSIGNED NOT NULL,
  `idLinkedAppearance` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idAppearance`, `idLinkedAppearance`),
  INDEX `fk_LinkedAppearances_Appearances2_idx` (`idLinkedAppearance` ASC) VISIBLE,
  CONSTRAINT `fk_LinkedAppearances_Appearances1`
    FOREIGN KEY (`idAppearance`)
    REFERENCES `appearances` (`idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LinkedAppearances_Appearances2`
    FOREIGN KEY (`idLinkedAppearance`)
    REFERENCES `appearances` (`idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `itemsappearances` (
  `idBaseItem` INT UNSIGNED NOT NULL,
  `idAppearance` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idBaseItem`, `idAppearance`),
  INDEX `fk_ItemsAppearances_Appearances1_idx` (`idAppearance` ASC) VISIBLE,
  CONSTRAINT `fk_ItemsAppearances_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemsAppearances_Appearances1`
    FOREIGN KEY (`idAppearance`)
    REFERENCES `appearances` (`idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `charactersappearanceparts` (
  `idCharacter` INT UNSIGNED NOT NULL,
  `idAppearance` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`, `idAppearance`),
  INDEX `fk_CharactersAppearanceParts_Appearances1_idx` (`idAppearance` ASC) VISIBLE,
  CONSTRAINT `fk_CharacterAppearance_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersAppearanceParts_Appearances1`
    FOREIGN KEY (`idAppearance`)
    REFERENCES `appearances` (`idAppearance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `charactersappearance` (
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
    REFERENCES `characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharacterAppearance_BodyType1`
    FOREIGN KEY (`idBodyType`)
    REFERENCES `bodytype` (`idBodyType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `itemsappearancesmaskcolors` (
  `idBaseItem` INT UNSIGNED NOT NULL,
  `idAppearance` INT UNSIGNED NOT NULL,
  `sourceColor` VARCHAR(10) NOT NULL,
  `targetColor` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idBaseItem`, `idAppearance`, `sourceColor`),
  CONSTRAINT `fk_table1_ItemsAppearances1`
    FOREIGN KEY (`idBaseItem` , `idAppearance`)
    REFERENCES `itemsappearances` (`idBaseItem` , `idAppearance`)
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

(133, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2000_wrist_left.png", 11, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(134, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2000_hand_left.png", 12, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(135, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2000_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(136, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2000_hand_right.png", 14, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(137, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2001_hand_left.png", 12, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(138, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2001_hand_right.png", 14, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(139, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2002_hand_left.png", 12, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(140, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2002_hand_right.png", 14, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(141, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003%20Mask_wrist_left.png"),
(142, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003%20Mask_hand_left.png"),
(143, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003%20Mask_wrist_right.png"),
(144, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003%20Mask_hand_right.png"),

(145, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004%20Mask_wrist_left.png"),
(146, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004%20Mask_hand_left.png"),
(147, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004%20Mask_wrist_right.png"),
(148, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004%20Mask_hand_right.png"),

(149, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005%20Mask_wrist_left.png"),
(150, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005%20Mask_hand_left.png"),
(151, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005%20Mask_wrist_right.png"),
(152, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005%20Mask_hand_right.png"),

(153, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2006_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2006%20Mask_hand_left.png"),
(154, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2006_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2006%20Mask_hand_right.png"),

(155, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007%20Mask_wrist_left.png"),
(156, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007%20Mask_hand_left.png"),
(157, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007%20Mask_wrist_right.png"),
(158, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007%20Mask_hand_right.png"),

(159, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008%20Mask_wrist_left.png"),
(160, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008%20Mask_hand_left.png"),
(161, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008%20Mask_wrist_right.png"),
(162, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008%20Mask_hand_right.png"),

(163, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009%20Mask_wrist_left.png"),
(164, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009%20Mask_hand_left.png"),
(165, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009%20Mask_wrist_right.png"),
(166, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009%20Mask_hand_right.png"),

(167, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010%20Mask_wrist_left.png"),
(168, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010%20Mask_hand_left.png"),
(169, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010%20Mask_wrist_right.png"),
(170, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010%20Mask_hand_right.png"),

(171, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves%20Mask_wrist_left.png"),
(172, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves%20Mask_hand_left.png"),
(173, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves%20Mask_wrist_right.png"),
(174, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves%20Mask_hand_right.png"),

(175, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves%20Mask_wrist_left.png"),
(176, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves%20Mask_hand_left.png"),
(177, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves%20Mask_wrist_right.png"),
(178, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves%20Mask_hand_right.png"),

(179, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves%20Mask_wrist_left.png"),
(180, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves%20Mask_hand_left.png"),
(181, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves%20Mask_wrist_right.png"),
(182, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves%20Mask_hand_right.png"),

(183, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves%20Mask_wrist_left.png"),
(184, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves%20Mask_hand_left.png"),
(185, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves%20Mask_wrist_right.png"),
(186, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves%20Mask_hand_right.png"),

(187, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves_wrist_left.png", 11, null, 1,  "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves%20Mask_wrist_left.png"),
(188, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves_hand_left.png",   12, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves%20Mask_hand_left.png"),
(189, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves_wrist_right.png", 13, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves%20Mask_wrist_right.png"),
(190, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves_hand_right.png",  14, null, 1, "https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves%20Mask_hand_right.png"),

(191, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2000_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(192, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2001_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(193, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2002_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2002%20Mask_front.png"),

(194, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2003_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2003%20Mask_front.png"),

(195, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2004_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(196, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2005_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2005%20Mask_front.png"),

(197, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2006_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2006%20Mask_front.png"),

(198, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2007_back.png",   15, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(199, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2007_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(200, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2008_back.png",   15, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2008%20Mask_back.png"),
(201, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2008_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2008%20Mask_front.png"),

(202, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2009_back.png",   15, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2009%20Mask_back.png"),
(203, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2009_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2009%20Mask_front.png"),

(204, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2010_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(205, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2011_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(206, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2012_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2012%20Mask_front.png"),

(207, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2013_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2013%20Mask_front.png"),

(208, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2014_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2014%20Mask_front.png"),

(209, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2015_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2015%20Mask_front.png"),

(210, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2016_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2016%20Mask_front.png"),

(211, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2017_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2017%20Mask_front.png"),

(212, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2018_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2018%20Mask_front.png"),

(213, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2019_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2019%20Mask_front.png"),

(214, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2020_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2020%20Mask_front.png"),

(215, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2021_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2021%20Mask_front.png"),

(216, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2001%20Helm_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2001%20Helm%20Mask_front.png"),

(217, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Male_front.png  ",  16, 1, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Male%20Mask_front.png"),

(218, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Female_back.png ",   15, 2, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Female%20Mask_back.png"),
(219, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Female_front.png",  16, 2, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Female%20Mask_front.png"),

(220, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2003%20Helm_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2003%20Helm%20Mask_front.png"),

(221, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2004%20Hood_back.png",   15, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2004%20Hood%20Mask_back.png"),
(222, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2004%20Hood_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2004%20Hood%20Mask_front.png"),

(223, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2005%20Helm_front.png",  16, null, 1, "https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2005%20Helm%20Mask_front.png"),

(224, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female%20Mask_body.png"),
(225, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female%20Mask_upper_left.png"),
(226, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female%20Mask_upper_right.png"),

(227, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male%20Mask_body.png"),
(228, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male%20Mask_upper_left.png"),
(229, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male%20Mask_upper_right.png"),

(230, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female%20Mask_body.png"),
(231, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female%20Mask_upper_left.png"),
(232, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female%20Mask_upper_right.png"),

(233, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male%20Mask_body.png"),
(234, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male%20Mask_upper_left.png"),
(235, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male%20Mask_upper_right.png"),

(236, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female%20Mask_body.png"),
(237, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female%20Mask_upper_left.png"),
(238, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female%20Mask_upper_right.png"),

(239, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_body.png"),
(240, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_lower_left.png"),
(241, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_lower_right.png"),
(242, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_upper_left.png"),
(243, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_upper_right.png"),

(244, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_body.png"),
(245, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_neck.png",  18, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_neck.png"),
(246, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_lower_left.png",  19, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_lower_left.png"),
(247, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_lower_right.png"),
(248, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_upper_left.png"),
(249, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_upper_right.png"),

(250, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_body.png"),
(251, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_lower_left.png"),
(252, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_lower_right.png"),
(253, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_upper_left.png"),
(254, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_upper_right.png"),

(255, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(256, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_neck.png",  18, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(257, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_lower_left.png",  19, 2, 1,  "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(258, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(259, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_upper_left.png",  21, 2, 1,  "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(260, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(261, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_body.png"),
(262, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_lower_left.png"),
(263, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_lower_right.png"),
(264, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_upper_left.png"),
(265, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_upper_right.png"),

(266, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_body.png"),
(267, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_neck.png",  18, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_neck.png"),
(268, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_lower_left.png",  19, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_lower_left.png"),
(269, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_lower_right.png"),
(270, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_upper_left.png"),
(271, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_upper_right.png"),

(272, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_body.png"),
(273, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_lower_left.png"),
(274, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_lower_right.png"),
(275, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_upper_left.png"),
(276, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_upper_right.png"),

(277, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_body.png"),
(278, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_neck.png",  18, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_neck.png"),
(279, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_lower_left.png",  19, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_lower_left.png"),
(280, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_lower_right.png"),
(281, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_upper_left.png"),
(282, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_upper_right.png"),

(283, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_body.png"),
(284, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_neck.png",  18, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_neck.png"),
(285, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_lower_left.png"),
(286, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_lower_right.png"),
(287, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_upper_left.png"),
(288, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_upper_right.png"),

(289, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female%20Mask_body.png"),
(290, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female%20Mask_upper_left.png"),
(291, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female%20Mask_upper_right.png"),

(292, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male%20Mask_body.png"),
(293, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male%20Mask_upper_left.png"),
(294, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male%20Mask_upper_right.png"),

(295, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_body.png"),
(296, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_lower_left.png",  19, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_lower_left.png"),
(297, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_lower_right.png"),
(298, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_upper_left.png"),
(299, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_upper_right.png"),

(300, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_body.png"),
(301, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_lower_left.png"),
(302, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_lower_right.png"),
(303, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_upper_left.png"),
(304, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_upper_right.png"),

(305, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_body.png"),
(306, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_neck.png",  18, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_neck.png"),
(307, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_lower_left.png",  19, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_lower_left.png"),
(308, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_lower_right.png"),
(309, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_upper_left.png"),
(310, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_upper_right.png"),

(311, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_body.png"),
(312, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_lower_left.png"),
(313, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_lower_right.png"),
(314, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_upper_left.png"),
(315, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_upper_right.png"),

(316, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_body.png"),
(317, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_neck.png",  18, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_neck.png"),
(318, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_lower_left.png",  19, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_lower_left.png"),
(319, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_lower_right.png"),
(320, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_upper_left.png"),
(321, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_upper_right.png"),

(322, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_body.png"),
(323, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_neck.png",  18, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_neck.png"),
(324, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_lower_left.png"),
(325, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_lower_right.png"),
(326, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_upper_left.png"),
(327, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_upper_right.png"),

(328, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female%20Mask_body.png"),
(329, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female_neck.png",  18, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female%20Mask_neck.png"),
(330, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female%20Mask_upper_left.png"),

(331, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male%20Mask_body.png"),
(332, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male%20Mask_upper_left.png"),
(333, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male%20Mask_upper_right.png"),

(334, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_body.png"),
(335, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_neck.png",  18, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(336, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_lower_left.png",  19, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_lower_left.png"),
(337, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_lower_right.png"),
(338, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_upper_left.png"),
(339, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_upper_right.png"),

(340, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_body.png"),
(341, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_neck.png",  18, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_neck.png"),
(342, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_lower_left.png"),
(343, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_lower_right.png"),
(344, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_upper_left.png"),
(345, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_upper_right.png"),

(346, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female%20Mask_body.png"),
(347, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female%20Mask_lower_right.png"),
(348, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female%20Mask_upper_left.png"),
(349, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female%20Mask_upper_right.png"),

(350, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_body.png"),
(351, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_lower_left.png"),
(352, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_lower_right.png"),
(353, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_upper_left.png"),
(354, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_upper_right.png"),

(355, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_body.png",  17, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_body.png"),
(356, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_lower_left.png",  19, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_lower_left.png"),
(357, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_lower_right.png",  20, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_lower_right.png"),
(358, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_upper_left.png",  21, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_upper_left.png"),
(359, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_upper_right.png",  22, 2, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_upper_right.png"),

(360, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_body.png",  17, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_body.png"),
(361, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_neck.png",  18, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_neck.png"),
(362, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_lower_left.png",  19, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_lower_left.png"),
(363, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_lower_right.png",  20, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_lower_right.png"),
(364, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_upper_left.png",  21, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_upper_left.png"),
(365, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_upper_right.png",  22, 1, 1, "https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_upper_right.png"),

(366, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(367, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(368, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(369, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(370, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(371, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(372, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(373, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(374, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(375, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(376, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_hip.png"),
(377, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_lower_left.png"),
(378, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_lower_right.png"),
(379, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_upper_left.png"),
(380, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_upper_right.png"),

(381, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_hip.png"),
(382, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_lower_left.png"),
(383, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_lower_right.png"),
(384, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_upper_left.png"),
(385, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_upper_right.png"),

(386, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_hip.png"),
(387, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_lower_left.png"),
(388, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_lower_right.png"),
(389, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_upper_left.png"),
(390, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_upper_right.png"),

(391, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_hip.png"),
(392, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_lower_left.png"),
(393, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_lower_right.png"),
(394, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_upper_left.png"),
(395, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_upper_right.png"),

(396, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_hip.png"),
(397, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_lower_left.png"),
(398, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_lower_right.png"),
(399, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_upper_left.png"),
(400, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_upper_right.png"),

(401, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_hip.png"),
(402, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_lower_left.png"),
(403, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_lower_right.png"),
(404, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_upper_left.png"),
(405, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_upper_right.png"),

(406, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(407, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(408, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(409, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(410, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(411, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_hip.png"),
(412, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_lower_left.png"),
(413, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_lower_right.png"),
(414, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_upper_left.png"),
(415, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_upper_right.png"),

(416, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_hip.png"),
(417, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_lower_left.png"),
(418, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_lower_right.png"),
(419, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_upper_left.png"),
(420, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_upper_right.png"),

(421, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_hip.png"),
(422, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_lower_left.png"),
(423, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_lower_right.png"),
(424, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_upper_left.png"),
(425, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_upper_right.png"),

(426, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_hip.png"),
(427, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_lower_left.png"),
(428, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_lower_right.png"),
(429, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_upper_left.png"),
(430, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_upper_right.png"),

(431, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_hip.png"),
(432, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_lower_left.png"),
(433, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_lower_right.png"),
(434, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_upper_left.png"),
(435, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_upper_right.png"),

(436, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_hip.png"),
(437, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_lower_left.png"),
(438, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_lower_right.png"),
(439, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_upper_left.png"),
(440, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_upper_right.png"),

(441, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_hip.png"),
(442, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_lower_left.png"),
(443, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_lower_right.png"),
(444, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_upper_left.png"),
(445, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_upper_right.png"),

(446, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_hip.png"),
(447, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_lower_left.png"),
(448, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_lower_right.png"),
(449, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_upper_left.png"),
(450, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_upper_right.png"),

(451, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_hip.png"),
(452, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_lower_left.png"),
(453, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_lower_right.png"),
(454, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_upper_left.png"),
(455, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_upper_right.png"),

(456, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_hip.png"),
(457, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_lower_left.png"),
(458, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_lower_right.png"),
(459, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_upper_left.png"),
(460, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_upper_right.png"),

(461, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_hip.png"),
(462, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_lower_left.png"),
(463, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_lower_right.png"),
(464, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_upper_left.png"),
(465, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_upper_right.png"),

(466, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female%20Mask_hip.png"),
(467, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female%20Mask_upper_left.png"),
(468, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female%20Mask_upper_right.png"),

(469, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_hip.png"),
(470, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_lower_left.png"),
(471, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_lower_right.png"),
(472, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_upper_left.png"),
(473, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_upper_right.png"),

(474, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_hip.png"),
(475, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_lower_left.png"),
(476, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_lower_right.png"),
(477, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_upper_left.png"),
(478, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_upper_right.png"),

(479, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_hip.png"),
(480, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_lower_left.png"),
(481, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_lower_right.png"),
(482, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_upper_left.png"),
(483, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_upper_right.png"),

(484, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female%20Mask_hip.png"),
(485, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female%20Mask_upper_left.png"),
(486, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female%20Mask_upper_right.png"),

(487, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male%20Mask_hip.png"),
(488, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male%20Mask_upper_left.png"),
(489, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male%20Mask_upper_right.png"),

(490, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_hip.png"),
(491, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_lower_left.png"),
(492, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_lower_right.png"),
(493, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_upper_left.png"),
(494, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_upper_right.png"),

(495, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_hip.png"),
(496, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_lower_left.png"),
(497, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_lower_right.png"),
(498, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_upper_left.png"),
(499, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_upper_right.png"),

(500, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_hip.png"),
(501, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_lower_left.png"),
(502, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_lower_right.png"),
(503, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_upper_left.png"),
(504, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_upper_right.png"),

(505, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_hip.png"),
(506, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_lower_left.png"),
(507, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_lower_right.png"),
(508, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_upper_left.png"),
(509, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_upper_right.png"),

(510, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_hip.png"),
(511, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_lower_left.png"),
(512, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_lower_right.png"),
(513, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_upper_left.png"),
(514, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_upper_right.png"),

(515, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_hip.png",  23, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_hip.png"),
(516, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_lower_left.png",  24, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_lower_left.png"),
(517, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_lower_right.png",  25, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_lower_right.png"),
(518, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_upper_left.png",  26, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_upper_left.png"),
(519, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_upper_right.png",  27, 1, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_upper_right.png"),

(520, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2000_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(521, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2000_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(522, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2001_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(523, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2001_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(524, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2002_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2002%20Mask_foot_left.png"),
(525, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2002_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2002%20Mask_foot_right.png"),

(526, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003%20Mask_lower_left.png"),
(527, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003%20Mask_lower_right.png"),
(528, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003%20Mask_foot_left.png"),
(529, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003%20Mask_foot_right.png"),

(530, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2004_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(531, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2004_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(532, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2004_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(533, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2004_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),

(534, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005%20Mask_lower_left.png"),
(535, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005%20Mask_lower_right.png"),
(536, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005%20Mask_foot_left.png"),
(537, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005%20Mask_foot_right.png"),

(538, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006%20Mask_lower_left.png"),
(539, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006%20Mask_lower_right.png"),
(540, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006%20Mask_foot_left.png"),
(541, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006%20Mask_foot_right.png"),

(542, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007%20Mask_lower_left.png"),
(543, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007%20Mask_lower_right.png"),
(544, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007%20Mask_foot_left.png"),
(545, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007%20Mask_foot_right.png"),

(546, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008%20Mask_lower_left.png"),
(547, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008%20Mask_lower_right.png"),
(548, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008%20Mask_foot_left.png"),
(549, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008%20Mask_foot_right.png"),

(550, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009%20Mask_lower_left.png"),
(551, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009%20Mask_lower_right.png"),
(552, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009%20Mask_foot_left.png"),
(553, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009%20Mask_foot_right.png"),

(554, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010%20Mask_lower_left.png"),
(555, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010%20Mask_lower_right.png"),
(556, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010%20Mask_foot_left.png"),
(557, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010%20Mask_foot_right.png"),

(558, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2001_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2001%20Mask_foot_left.png"),
(559, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2001_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2001%20Mask_foot_right.png"),

(560, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002%20Mask_lower_left.png"),
(561, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002%20Mask_lower_right.png"),
(562, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002%20Mask_foot_left.png"),
(563, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002%20Mask_foot_right.png"),

(564, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003%20Mask_lower_left.png"),
(565, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003%20Mask_lower_right.png"),
(566, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003%20Mask_foot_left.png"),
(567, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003%20Mask_foot_right.png"),

(568, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004%20Mask_lower_left.png"),
(569, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004%20Mask_lower_right.png"),
(570, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004%20Mask_foot_left.png"),
(571, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004%20Mask_foot_right.png"),

(572, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005_lower_left.png",  28, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005%20Mask_lower_left.png"),
(573, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005_lower_right.png",  29, null, 1,"https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005%20Mask_lower_right.png"),
(574, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005_foot_left.png",  30, null, 1,  "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005%20Mask_foot_left.png"),
(575, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005_foot_right.png",  31, null, 1, "https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005%20Mask_foot_right.png"),

(576, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_hip.png",  23, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_hip.png"),
(577, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_lower_left.png",  24, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_lower_left.png"),
(578, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_lower_right.png",  25, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_lower_right.png"),
(579, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_upper_left.png",  26, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_upper_left.png"),
(580, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_upper_right.png",  27, 2, 1, "https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_upper_right.png"),

(581, "https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2000.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2000%20Mask.png"),
(582, "https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2001.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2001%20Mask.png"),
(583, "https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2002.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2002%20Mask.png"),

(584, "https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2000.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2000%20Mask.png"),
(585, "https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2001.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2001%20Mask.png"),
(586, "https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2002.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2002%20Mask.png"),
(587, "https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2003.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2003%20Mask.png"),

(588, "https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2000.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2000%20Mask.png"),
(589, "https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2001.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2001%20Mask.png"),
(590, "https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2002.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2002%20Mask.png"),
(591, "https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2003.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2003%20Mask.png"),

(592, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2000.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2000%20Mask.png"),
(593, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2001.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2001%20Mask.png"),
(594, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2002.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2002%20Mask.png"),
(595, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2003.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2003%20Mask.png"),
(596, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2004.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2004%20Mask.png"),

(597, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2000.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(598, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2001.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2001%20Mask.png"),
(599, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2002.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2002%20Mask.png"),
(600, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2003.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2003%20Mask.png"),
(601, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2004.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2004%20Mask.png"),

(602, "https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2000.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2000%20Mask.png"),
(603, "https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2001.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2001%20Mask.png"),
(604, "https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2002.png",  32, null, 1, "https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2002%20Mask.png"),

(605, "https://cdn.fight-rpg.com/images/appearances/bows/Bow%2000.png",  35, null, 1, "https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png"),
(606, "https://cdn.fight-rpg.com/images/appearances/bows/Bow%2001.png",  35, null, 1, "https://cdn.fight-rpg.com/images/appearances/bows/Bow%2001%20Mask.png"),
(607, "https://cdn.fight-rpg.com/images/appearances/bows/Bow%2002.png",  35, null, 1, "https://cdn.fight-rpg.com/images/appearances/bows/Bow%2002%20Mask.png"),
(608, "https://cdn.fight-rpg.com/images/appearances/bows/Bow%2003.png",  35, null, 1, "https://cdn.fight-rpg.com/images/appearances/bows/Bow%2003%20Mask.png");




REPLACE INTO itemsappearances VALUES 
(7, 179),
(7, 180),
(7, 181),
(7, 182),

(8, 179),
(8, 180),
(8, 181),
(8, 182),

(9, 179),
(9, 180),
(9, 181),
(9, 182),

(10, 179),
(10, 180),
(10, 181),
(10, 182),

(46, 163),
(46, 164),
(46, 165),
(46, 166),

(100, 145),
(100, 146),
(100, 147),
(100, 148),

(101, 145),
(101, 146),
(101, 147),
(101, 148),

(102, 145),
(102, 146),
(102, 147),
(102, 148),

(103, 145),
(103, 146),
(103, 147),
(103, 148),

(104, 137),
(104, 138),


(105, 183),
(105, 184),
(105, 185),
(105, 186),

(106, 141),
(106, 142),
(106, 143),
(106, 144),

(107, 141),
(107, 142),
(107, 143),
(107, 144),

(108, 141),
(108, 142),
(108, 143),
(108, 144),

(109, 141),
(109, 142),
(109, 143),
(109, 144),

(110, 149),
(110, 150),
(110, 151),
(110, 152),

(16, 204),
(17, 210),
(18, 210),
(19, 210),
(20, 210),
(48, 212),

(123, 192),
(124, 193),
(125, 197),
(126, 197),
(127, 197),
(128, 197),

(129, 191),
(130, 196),
(131, 194),
(132, 196),
(133, 196),
(134, 196),

(6, 230),
(6, 233),

(7, 272),
(7, 266),

(8, 272),
(8, 266),

(9, 272),
(9, 266),

(10, 272),
(10, 266),

(46, 277),
(46, 283),

(99, 230),
(99, 233),

(100, 244),
(100, 250),

(101, 244),
(101, 250),

(102, 244),
(102, 250),

(103, 244),
(103, 250),

(104, 334),
(104, 340),

(105, 289),
(105, 292),

(106, 289),
(106, 292),

(107, 289),
(107, 292),

(108, 289),
(108, 292),

(109, 289),
(109, 292),

(110, 346),
(110, 350),

(11, 366),
(11, 371),
(11, 522),

(12, 446),
(12, 469),
(12, 552),

(13, 446),
(13, 469),
(13, 552),

(14, 446),
(14, 469),
(14, 552),

(15, 446),
(15, 469),
(15, 552),

(47, 446),
(47, 469),
(47, 552),

(111, 366),
(111, 371),
(111, 522),

(112, 461),
(112, 576),
(112, 548),

(113, 461),
(113, 576),
(113, 548),

(114, 461),
(114, 576),
(114, 548),

(115, 461),
(115, 576),
(115, 548),

(116, 386),
(116, 391),
(116, 536),

(117, 436),
(117, 401),
(117, 536),

(118, 436),
(118, 401),
(118, 536),

(119, 436),
(119, 401),
(119, 536),

(120, 436),
(120, 401),
(120, 536),

(121, 436),
(121, 401),
(121, 536),

(122, 500),
(122, 505),
(122, 536),

(1, 588),
(2, 588),
(3, 588),
(4, 588),
(5, 588),
(45, 589),

(75, 605),
(76, 606),
(77, 606),
(78, 606),
(79, 606),
(80,  608),

(81,  584),
(82,  584),
(83,  584),
(84,  584),
(85,  584),
(86,  587),

(87, 592),
(88, 592),
(89, 592),
(90, 592),
(91, 592),
(92, 596),

(93, 597),
(94, 600),
(95, 600),
(96, 600),
(97, 600),
(98, 601);


REPLACE INTO itemsappearancesmaskcolors VALUES 

(1, 588, "#ff0000", "#985717"),
(1, 588, "#00ff00", "#985717"),
(1, 588, "#0000ff", "#624a2e"),

(2, 588, "#ff0000", "#e9ecef"),
(2, 588, "#00ff00", "#c0c0c0"),
(2, 588, "#0000ff", "#624a2e"),

(3, 588, "#ff0000", "#9c9b99"),
(3, 588, "#00ff00", "#a19d94"),
(3, 588, "#0000ff", "#624a2e"),

(4, 588, "#ff0000", "#ffea00"),
(4, 588, "#00ff00", "#e7bd42"),
(4, 588, "#0000ff", "#624a2e"),

(5, 588, "#ff0000", "#b0ceed"),
(5, 588, "#00ff00", "#1773d1"),
(5, 588, "#0000ff", "#624a2e"),

(45, 589, "#ff0000", "#5a189a"),
(45, 589, "#00ff00", "#2f0c50"),
(45, 589, "#0000ff", "#624a2e"),

(75, 605, "#ff0000", "#8b5a2b"),

(76, 606, "#ff0000", "#8b5a2b"),
(76, 606, "#00ff00", "#624a2e"),
(76, 606, "#0000ff", "#c0c0c0"),

(77, 606, "#ff0000", "#8b5a2b"),
(77, 606, "#00ff00", "#624a2e"),
(77, 606, "#0000ff", "#a19d94"),

(78, 606, "#ff0000", "#8b5a2b"),
(78, 606, "#00ff00", "#624a2e"),
(78, 606, "#0000ff", "#e7bd42"),

(79, 606, "#ff0000", "#8b5a2b"),
(79, 606, "#00ff00", "#624a2e"),
(79, 606, "#0000ff", "#1773d1"),

(80, 608, "#ff0000", "#5a189a"),
(80, 608, "#00ff00", "#2f0c50"),


(81, 584, "#ff0000", "#985717"),
(81, 584, "#00ff00", "#985717"),
(81, 584, "#0000ff", "#624a2e"),
    
(82, 584, "#ff0000", "#e9ecef"),
(82, 584, "#00ff00", "#c0c0c0"),
(82, 584, "#0000ff", "#624a2e"),
  
(83, 584, "#ff0000", "#9c9b99"),
(83, 584, "#00ff00", "#a19d94"),
(83, 584, "#0000ff", "#624a2e"),
    
(84, 584, "#ff0000", "#ffea00"),
(84, 584, "#00ff00", "#e7bd42"),
(84, 584, "#0000ff", "#624a2e"),
    
(85, 584, "#ff0000", "#b0ceed"),
(85, 584, "#00ff00", "#1773d1"),
(85, 584, "#0000ff", "#624a2e"),

(86, 587, "#ff0000", "#5a189a"),
(86, 587, "#00ff00", "#2f0c50"),

(87, 592, "#ff0000", "#8b5a2b"),
(87, 592, "#00ff00", "#624a2e"),
(87, 592, "#0000ff", "#c0c0c0"),

(88, 592, "#ff0000", "#8b5a2b"),
(88, 592, "#00ff00", "#624a2e"),
(88, 592, "#0000ff", "#c0c0c0"),

(89, 592, "#ff0000", "#8b5a2b"),
(89, 592, "#00ff00", "#624a2e"),
(89, 592, "#0000ff", "#a19d94"),

(90, 592, "#ff0000", "#8b5a2b"),
(90, 592, "#00ff00", "#624a2e"),
(90, 592, "#0000ff", "#e7bd42"),

(91, 592, "#ff0000", "#8b5a2b"),
(91, 592, "#00ff00", "#624a2e"),
(91, 592, "#0000ff", "#1773d1"),

(92, 596, "#ff0000", "#5a189a"),
(92, 596, "#00ff00", "#2f0c50"),
(92, 596, "#0000ff", "#2f0c50"),


(93, 597, "#ff0000", "#8b5a2b"),
(93, 597, "#00ff00", "#624a2e"),
(93, 597, "#0000ff", "#c0c0c0"),

(94, 600, "#ff0000", "#8b5a2b"),
(94, 600, "#00ff00", "#624a2e"),
(94, 600, "#0000ff", "#c0c0c0"),

(95, 600, "#ff0000", "#8b5a2b"),
(95, 600, "#00ff00", "#624a2e"),
(95, 600, "#0000ff", "#a19d94"),

(96, 600, "#ff0000", "#8b5a2b"),
(96, 600, "#00ff00", "#624a2e"),
(96, 600, "#0000ff", "#e7bd42"),

(97, 600, "#ff0000", "#8b5a2b"),
(97, 600, "#00ff00", "#624a2e"),
(97, 600, "#0000ff", "#1773d1"),
  
(98, 601, "#ff0000", "#5a189a"),
(98, 601, "#00ff00", "#2f0c50"),
(98, 601, "#0000ff", "#2f0c50"),


(6, 230,  "#ff0000", "#d2b48c"),
(6, 230,  "#00ff00", "#624a2e"),

(6, 233,  "#ff0000", "#d2b48c"),
(6, 233,  "#00ff00", "#d2b48c"),
(6, 233,  "#0000ff", "#624a2e"),

(7, 179, "#ff0000", "#624a2e"),
(7, 180, "#ff0000", "#624a2e"),
(7, 181, "#ff0000", "#624a2e"),
(7, 182, "#ff0000", "#624a2e"),

(7, 180, "#00ff00", "#c0c0c0"),
(7, 182, "#00ff00", "#c0c0c0"),

(7, 266,  "#ff0000", "#624a2e"),
(7, 266,  "#00ff00", "#c0c0c0"),
(7, 266,  "#0000ff", "#624a2e"),
 
(7, 272,  "#ff0000", "#624a2e"),
(7, 272,  "#00ff00", "#c0c0c0"),
(7, 272,  "#0000ff", "#624a2e"),

(8, 179, "#ff0000", "#624a2e"),
(8, 180, "#ff0000", "#624a2e"),
(8, 181, "#ff0000", "#624a2e"),
(8, 182, "#ff0000", "#624a2e"),

(8, 180, "#00ff00", "#a19d94"),
(8, 182, "#00ff00", "#a19d94"),

(8, 266,  "#ff0000", "#624a2e"),
(8, 266,  "#00ff00", "#a19d94"),
(8, 266,  "#0000ff", "#624a2e"),
 
(8, 272,  "#ff0000", "#624a2e"),
(8, 272,  "#00ff00", "#a19d94"),
(8, 272,  "#0000ff", "#624a2e"),

(9, 179, "#ff0000", "#624a2e"),
(9, 180, "#ff0000", "#624a2e"),
(9, 181, "#ff0000", "#624a2e"),
(9, 182, "#ff0000", "#624a2e"),

(9, 180, "#00ff00", "#e7bd42"),
(9, 182, "#00ff00", "#e7bd42"),

(9, 266,  "#ff0000", "#624a2e"),
(9, 266,  "#00ff00", "#e7bd42"),
(9, 266,  "#0000ff", "#624a2e"),
 
(9, 272,  "#ff0000", "#624a2e"),
(9, 272,  "#00ff00", "#e7bd42"),
(9, 272,  "#0000ff", "#624a2e"),

(10, 179, "#ff0000", "#624a2e"),
(10, 180, "#ff0000", "#624a2e"),
(10, 181, "#ff0000", "#624a2e"),
(10, 182, "#ff0000", "#624a2e"),

(10, 180, "#00ff00", "#1773d1"),
(10, 182, "#00ff00", "#1773d1"),

(10, 266,  "#ff0000", "#624a2e"),
(10, 266,  "#00ff00", "#1773d1"),
(10, 266,  "#0000ff", "#624a2e"),
 
(10, 272,  "#ff0000", "#624a2e"),
(10, 272,  "#00ff00", "#1773d1"),
(10, 272,  "#0000ff", "#624a2e"),

(46, 163, "#ff0000", "#2f0c50"),
(46, 164, "#ff0000", "#2f0c50"),
(46, 165, "#ff0000", "#2f0c50"),
(46, 166, "#ff0000", "#2f0c50"),

(46, 163, "#00ff00", "#5a189a"),
(46, 164, "#00ff00", "#5a189a"),
(46, 165, "#00ff00", "#5a189a"),
(46, 166, "#00ff00", "#5a189a"),

(46, 163, "#0000ff", "#624a2e"),
(46, 164, "#0000ff", "#624a2e"),
(46, 165, "#0000ff", "#624a2e"),
(46, 166, "#0000ff", "#624a2e"),

(46, 277, "#ff0000", "#2f0c50"),
(46, 277, "#00ff00", "#5a189a"),
(46, 277, "#0000ff", "#624a2e"),

(46, 283, "#ff0000", "#2f0c50"),
(46, 283, "#00ff00", "#5a189a"),
(46, 283, "#0000ff", "#624a2e"),

(99, 230,  "#ff0000", "#d2b48c"),
(99, 230,  "#00ff00", "#624a2e"),

(99, 233,  "#ff0000", "#d2b48c"),
(99, 233,  "#00ff00", "#d2b48c"),
(99, 233,  "#0000ff", "#624a2e"),

(100, 145, "#ff0000", "#d2b48c"),
(100, 145, "#0000ff", "#c0c0c0"),

(100, 146, "#ff0000", "#d2b48c"),
(100, 146, "#0000ff", "#c0c0c0"),
(100, 146, "#00ff00", "#9a9a9a"),

(100, 147, "#ff0000", "#d2b48c"),
(100, 147, "#0000ff", "#c0c0c0"),

(100, 148, "#ff0000", "#d2b48c"),
(100, 148, "#0000ff", "#c0c0c0"),

(100, 244,  "#ff0000", "#d2b48c"),
(100, 244,  "#00ff00", "#9a9a9a"),
(100, 244,  "#0000ff", "#c0c0c0"),

(100, 250,  "#ff0000", "#d2b48c"),
(100, 250,  "#00ff00", "#9a9a9a"),
(100, 250,  "#0000ff", "#c0c0c0"),

(101, 145, "#ff0000", "#d2b48c"),
(101, 145, "#0000ff", "#a19d94"),

(101, 146, "#ff0000", "#d2b48c"),
(101, 146, "#0000ff", "#a19d94"),
(101, 146, "#00ff00", "#9c9b99"),

(101, 147, "#ff0000", "#d2b48c"),
(101, 147, "#0000ff", "#a19d94"),

(101, 148, "#ff0000", "#d2b48c"),
(101, 148, "#0000ff", "#a19d94"),

(101, 244,  "#ff0000", "#d2b48c"),
(101, 244,  "#00ff00", "#9c9b99"),
(101, 244,  "#0000ff", "#a19d94"),
   
(101, 250,  "#ff0000", "#d2b48c"),
(101, 250,  "#00ff00", "#9c9b99"),
(101, 250,  "#0000ff", "#a19d94"),

(102, 145, "#ff0000", "#d2b48c"),
(102, 145, "#0000ff", "#e7bd42"),

(102, 146, "#ff0000", "#d2b48c"),
(102, 146, "#0000ff", "#e7bd42"),
(102, 146, "#00ff00", "#ffea00"),

(102, 147, "#ff0000", "#d2b48c"),
(102, 147, "#0000ff", "#e7bd42"),

(102, 148, "#ff0000", "#d2b48c"),
(102, 148, "#0000ff", "#e7bd42"),

(102, 244,  "#ff0000", "#d2b48c"),
(102, 244,  "#00ff00", "#ffea00"),
(102, 244,  "#0000ff", "#e7bd42"),
   
(102, 250,  "#ff0000", "#d2b48c"),
(102, 250,  "#00ff00", "#ffea00"),
(102, 250,  "#0000ff", "#e7bd42"),

(103, 145, "#ff0000", "#d2b48c"),
(103, 145, "#0000ff", "#1773d1"),

(103, 146, "#ff0000", "#d2b48c"),
(103, 146, "#0000ff", "#1773d1"),
(103, 146, "#00ff00", "#b0ceed"),

(103, 147, "#ff0000", "#d2b48c"),
(103, 147, "#0000ff", "#1773d1"),

(103, 148, "#ff0000", "#d2b48c"),
(103, 148, "#0000ff", "#1773d1"),

(103, 244,  "#ff0000", "#d2b48c"),
(103, 244,  "#00ff00", "#b0ceed"),
(103, 244,  "#0000ff", "#1773d1"),
  
(103, 250,  "#ff0000", "#d2b48c"),
(103, 250,  "#00ff00", "#b0ceed"),
(103, 250,  "#0000ff", "#1773d1"),

(104, 137, "#ff0000", "#5a189a"),

(104, 138, "#ff0000", "#5a189a"),

(104, 334,  "#ff0000", "#5a189a"),
(104, 334,  "#00ff00", "#2f0c50"),
(104, 334,  "#0000ff", "#624a2e"),
  
(104, 340,  "#ff0000", "#5a189a"),
(104, 340,  "#00ff00", "#2f0c50"),
(104, 340,  "#0000ff", "#624a2e"),

(105, 183, "#ff0000", "#624a2e"),
(105, 183, "#00ff00", "#624a2e"),

(105, 184, "#ff0000", "#624a2e"),

(105, 185, "#ff0000", "#624a2e"),
(105, 185, "#00ff00", "#624a2e"),

(105, 186, "#ff0000", "#624a2e"),

(105, 289,  "#ff0000", "#d2b48c"),
(105, 289,  "#00ff00", "#624a2e"),
(105, 289,  "#0000ff", "#624a2e"),
 
(105, 292,  "#ff0000", "#d2b48c"),
(105, 292,  "#00ff00", "#624a2e"),
(105, 292,  "#0000ff", "#624a2e"),

(106, 141, "#ff0000", "#624a2e"),
(106, 141, "#00ff00", "#47632d"),

(106, 142, "#ff0000", "#624a2e"),

(106, 143, "#ff0000", "#624a2e"),
(106, 143, "#00ff00", "#47632d"),

(106, 144, "#ff0000", "#624a2e"),

(106, 289,  "#ff0000", "#47632d"),
(106, 289,  "#00ff00", "#624a2e"),
(106, 289,  "#0000ff", "#624a2e"),
   
(106, 292,  "#ff0000", "#47632d"),
(106, 292,  "#00ff00", "#624a2e"),
(106, 292,  "#0000ff", "#624a2e"),

(107, 141, "#ff0000", "#624a2e"),
(107, 141, "#00ff00", "#a19d94"),

(107, 142, "#ff0000", "#624a2e"),

(107, 143, "#ff0000", "#624a2e"),
(107, 143, "#00ff00", "#a19d94"),

(107, 144, "#ff0000", "#624a2e"),

(107, 289,  "#ff0000", "#a19d94"),
(107, 289,  "#00ff00", "#624a2e"),
(107, 289,  "#0000ff", "#624a2e"),
   
(107, 292,  "#ff0000", "#a19d94"),
(107, 292,  "#00ff00", "#624a2e"),
(107, 292,  "#0000ff", "#624a2e"),

(108, 141, "#ff0000", "#624a2e"),
(108, 141, "#00ff00", "#e7bd42"),

(108, 142, "#ff0000", "#624a2e"),

(108, 143, "#ff0000", "#624a2e"),
(108, 143, "#00ff00", "#e7bd42"),

(108, 144, "#ff0000", "#624a2e"),

(108, 289,  "#ff0000", "#191f22"),
(108, 289,  "#00ff00", "#e7bd42"),
(108, 289,  "#0000ff", "#624a2e"),
   
(108, 292,  "#ff0000", "#191f22"),
(108, 292,  "#00ff00", "#e7bd42"),
(108, 292,  "#0000ff", "#624a2e"),

(109, 141, "#ff0000", "#191f22"),
(109, 141, "#00ff00", "#1773d1"),

(109, 142, "#ff0000", "#191f22"),

(109, 143, "#ff0000", "#191f22"),
(109, 143, "#00ff00", "#1773d1"),

(109, 144, "#ff0000", "#191f22"),

(109, 289,  "#ff0000", "#191f22"),
(109, 289,  "#00ff00", "#1773d1"),
(109, 289,  "#0000ff", "#191f22"),
   
(109, 292,  "#ff0000", "#191f22"),
(109, 292,  "#00ff00", "#1773d1"),
(109, 292,  "#0000ff", "#191f22"),

(110, 149, "#ff0000", "#191f22"),
(110, 149, "#00ff00", "#5a189a"),
(110, 149, "#0000ff", "#191f22"),

(110, 150, "#ff0000", "#191f22"),

(110, 151, "#ff0000", "#191f22"),
(110, 151, "#00ff00", "#5a189a"),
(110, 151, "#0000ff", "#191f22"),

(110, 152, "#ff0000", "#191f22"),

(110, 346,  "#ff0000", "#5a189a"),
(110, 346,  "#00ff00", "#191f22"),
(110, 346,  "#0000ff", "#2f0c50"),
 
(110, 350,  "#ff0000", "#5a189a"),
(110, 350,  "#00ff00", "#191f22"),
(110, 350,  "#0000ff", "#2f0c50"),

(17, 210, "#ff0000", "#c0c0c0"),
(17, 210, "#00ff00", "#c0c0c0"),

(18, 210, "#ff0000", "#a19d94"),
(18, 210, "#00ff00", "#a19d94"),

(19, 210, "#ff0000", "#e7bd42"),
(19, 210, "#00ff00", "#e7bd42"),

(20, 210, "#ff0000", "#1773d1"),
(20, 210, "#00ff00", "#1773d1"),

(48, 212, "#ff0000", "#2f0c50"),
(48, 212, "#00ff00", "#5a189a"),

(123, 192, "#ff0000", "#624a2e"),

(124, 193, "#ff0000", "#d2b48c"),
(124, 193, "#00ff00", "#ffffff"),

(125, 197, "#ff0000", "#d2b48c"),
(125, 197, "#00ff00", "#624a2e"),
(125, 197, "#0000ff", "#9c9b99"),

(126, 197, "#ff0000", "#d2b48c"),
(126, 197, "#00ff00", "#624a2e"),
(126, 197, "#0000ff", "#e7bd42"),

(127, 197, "#ff0000", "#d2b48c"),
(127, 197, "#00ff00", "#624a2e"),
(127, 197, "#0000ff", "#1773d1"),

(128, 197, "#ff0000", "#d2b48c"),
(128, 197, "#00ff00", "#624a2e"),
(128, 197, "#0000ff", "#5a189a"),

(129, 191, "#ff0000", "#624a2e"),

(130, 196, "#ff0000", "#624a2e"),
(130, 196, "#00ff00", "#624a2e"),
(130, 196, "#0000ff", "#a19d94"),

(131, 194, "#ff0000", "#47632d"),
(131, 194, "#00ff00", "#624a2e"),
(131, 194, "#0000ff", "#d2b48c"),

(132, 196, "#ff0000", "#624a2e"),
(132, 196, "#00ff00", "#e7bd42"),
(132, 196, "#0000ff", "#a19d94"),

(133, 196, "#ff0000", "#624a2e"),
(133, 196, "#00ff00", "#1773d1"),
(133, 196, "#0000ff", "#a19d94"),

(134, 196, "#ff0000", "#624a2e"),
(134, 196, "#00ff00", "#5a189a"),
(134, 196, "#0000ff", "#a19d94"),

(11, 366, "#ff0000", "#624a2e"),
(11, 371, "#ff0000", "#624a2e"),
(11, 522, "#ff0000", "#624a2e"),


(12, 446, "#ff0000", "#624a2e"),
(12, 446, "#00ff00", "#c0c0c0"),
(12, 446, "#0000ff", "#c0c0c0"),

(12, 469, "#ff0000", "#624a2e"),
(12, 469, "#00ff00", "#c0c0c0"),
(12, 469, "#0000ff", "#c0c0c0"),

(12, 552, "#ff0000", "#c0c0c0"),
(12, 552, "#00ff00", "#c0c0c0"),
(12, 552, "#0000ff", "#c0c0c0"),

(13, 446, "#ff0000", "#624a2e"),
(13, 446, "#00ff00", "#a19d94"),
(13, 446, "#0000ff", "#a19d94"),

(13, 469, "#ff0000", "#624a2e"),
(13, 469, "#00ff00", "#a19d94"),
(13, 469, "#0000ff", "#a19d94"),

(13, 552, "#ff0000", "#a19d94"),
(13, 552, "#00ff00", "#a19d94"),
(13, 552, "#0000ff", "#a19d94"),

(14, 446, "#ff0000", "#624a2e"),
(14, 446, "#00ff00", "#e7bd42"),
(14, 446, "#0000ff", "#e7bd42"),

(14, 469, "#ff0000", "#624a2e"),
(14, 469, "#00ff00", "#e7bd42"),
(14, 469, "#0000ff", "#e7bd42"),

(14, 552, "#ff0000", "#e7bd42"),
(14, 552, "#00ff00", "#e7bd42"),
(14, 552, "#0000ff", "#e7bd42"),

(15, 446, "#ff0000", "#624a2e"),
(15, 446, "#00ff00", "#1773d1"),
(15, 446, "#0000ff", "#1773d1"),

(15, 469, "#ff0000", "#624a2e"),
(15, 469, "#00ff00", "#1773d1"),
(15, 469, "#0000ff", "#1773d1"),

(15, 552, "#ff0000", "#1773d1"),
(15, 552, "#00ff00", "#1773d1"),
(15, 552, "#0000ff", "#1773d1"),

(47, 446, "#ff0000", "#2f0c50"),
(47, 446, "#00ff00", "#5a189a"),
(47, 446, "#0000ff", "#5a189a"),

(47, 469, "#ff0000", "#2f0c50"),
(47, 469, "#00ff00", "#5a189a"),
(47, 469, "#0000ff", "#5a189a"),

(47, 552, "#ff0000", "#2f0c50"),
(47, 552, "#00ff00", "#5a189a"),
(47, 552, "#0000ff", "#5a189a"),

(111, 366, "#ff0000", "#d2b48c"),
(111, 371, "#ff0000", "#d2b48c"),
(111, 522, "#ff0000", "#d2b48c"),

(112, 461, "#ff0000", "#d2b48c"),
(112, 461, "#00ff00", "#e9ecef"),
(112, 461, "#0000ff", "#c0c0c0"),

(112, 576, "#ff0000", "#d2b48c"),
(112, 576, "#00ff00", "#e9ecef"),
(112, 576, "#0000ff", "#c0c0c0"),

(112, 548, "#ff0000", "#d2b48c"),
(112, 548, "#00ff00", "#e9ecef"),
(112, 548, "#0000ff", "#c0c0c0"),

(113, 461, "#ff0000", "#d2b48c"),
(113, 461, "#00ff00", "#9c9b99"),
(113, 461, "#0000ff", "#a19d94"),

(113, 576, "#ff0000", "#d2b48c"),
(113, 576, "#00ff00", "#9c9b99"),
(113, 576, "#0000ff", "#a19d94"),

(113, 548, "#ff0000", "#d2b48c"),
(113, 548, "#00ff00", "#9c9b99"),
(113, 548, "#0000ff", "#a19d94"),

(114, 461, "#ff0000", "#d2b48c"),
(114, 461, "#00ff00", "#ffea00"),
(114, 461, "#0000ff", "#e7bd42"),

(114, 576, "#ff0000", "#d2b48c"),
(114, 576, "#00ff00", "#ffea00"),
(114, 576, "#0000ff", "#e7bd42"),

(115, 461, "#ff0000", "#d2b48c"),
(115, 461, "#00ff00", "#b0ceed"),
(115, 461, "#0000ff", "#1773d1"),

(115, 548, "#ff0000", "#d2b48c"),
(115, 548, "#00ff00", "#b0ceed"),
(115, 548, "#0000ff", "#1773d1"),

(116, 386, "#ff0000", "#2f0c50"),
(116, 386, "#00ff00", "#5a189a"),

(116, 391, "#ff0000", "#5a189a"),
(116, 391, "#00ff00", "#624a2e"),
(116, 391, "#0000ff", "#a19d94"),

(116, 536, "#ff0000", "#2f0c50"),
(116, 536, "#00ff00", "#5a189a"),

(117, 436, "#ff0000", "#624a2e"),
(117, 436, "#00ff00", "#624a2e"),
(117, 436, "#0000ff", "#624a2e"),

(117, 401, "#ff0000", "#624a2e"),
(117, 401, "#00ff00", "#624a2e"),

(117, 536, "#ff0000", "#624a2e"),
(117, 536, "#00ff00", "#624a2e"),

(118, 436, "#ff0000", "#624a2e"),
(118, 436, "#00ff00", "#47632d"),
(118, 436, "#0000ff", "#47632d"),

(118, 401, "#ff0000", "#624a2e"),
(118, 401, "#00ff00", "#47632d"),

(118, 536, "#ff0000", "#624a2e"),
(118, 536, "#00ff00", "#47632d"),

(119, 436, "#ff0000", "#624a2e"),
(119, 436, "#00ff00", "#a19d94"),
(119, 436, "#0000ff", "#a19d94"),

(119, 401, "#ff0000", "#624a2e"),
(119, 401, "#00ff00", "#a19d94"),

(119, 536, "#ff0000", "#624a2e"),
(119, 536, "#00ff00", "#a19d94"),

(120, 436, "#ff0000", "#624a2e"),
(120, 436, "#00ff00", "#e7bd42"),
(120, 436, "#0000ff", "#e7bd42"),

(120, 401, "#ff0000", "#624a2e"),
(120, 401, "#00ff00", "#e7bd42"),

(120, 536, "#ff0000", "#624a2e"),
(120, 536, "#00ff00", "#e7bd42"),

(121, 436, "#ff0000", "#191f22"),
(121, 436, "#00ff00", "#1773d1"),
(121, 436, "#0000ff", "#1773d1"),
   
(121, 401, "#ff0000", "#191f22"),
(121, 401, "#00ff00", "#1773d1"),

(121, 536, "#ff0000", "#191f22"),
(121, 536, "#00ff00", "#1773d1"),

(122, 500, "#ff0000", "#5a189a"),
(122, 500, "#00ff00", "#2f0c50"),
(122, 500, "#0000ff", "#624a2e"),

(122, 505, "#ff0000", "#5a189a"),
(122, 505, "#00ff00", "#2f0c50"),
(122, 505, "#0000ff", "#624a2e"),

(122, 536, "#ff0000", "#5a189a"),
(122, 536, "#00ff00", "#2f0c50");


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
(118, 126),

(198, 199),
(200, 201),
(202, 203),

(224, 225),
(224, 226),

(227, 228),
(227, 229),

(230, 231),
(230, 232),

(233, 234),
(233, 235),

(236, 237),
(236, 238),

(239, 240),
(239, 241),
(239, 242),
(239, 243),

(244, 245),
(244, 246),
(244, 247),
(244, 248),
(244, 249),

(250, 251),
(250, 252),
(250, 253),
(250, 254),

(255, 256),
(255, 257),
(255, 258),
(255, 259),
(255, 260),

(261, 262),
(261, 263),
(261, 264),
(261, 265),

(266, 267),
(266, 268),
(266, 269),
(266, 270),
(266, 271),

(272, 273),
(272, 274),
(272, 275),
(272, 276),

(277, 278),
(277, 279),
(277, 280),
(277, 281),
(277, 282),

(283, 284),
(283, 285),
(283, 286),
(283, 287),
(283, 288),

(289, 290),
(289, 291),

(292, 293),
(292, 294),

(295, 296),
(295, 297),
(295, 298),
(295, 299),

(300, 301),
(300, 302),
(300, 303),
(300, 304),

(305, 306),
(305, 307),
(305, 308),
(305, 309),
(305, 310),

(311, 312),
(311, 313),
(311, 314),
(311, 315),

(316, 317),
(316, 318),
(316, 319),
(316, 320),
(316, 321),

(322, 323),
(316, 324),
(316, 325),
(316, 326),
(316, 327),

(328, 329),
(328, 330),

(331, 332),
(331, 333),

(334, 335),
(334, 336),
(334, 337),
(334, 338),
(334, 339),

(340, 341),
(340, 342),
(340, 343),
(340, 344),
(340, 345),

(346, 347),
(346, 348),
(346, 349),

(350, 351),
(350, 352),
(350, 353),
(350, 354),

(355, 356),
(355, 357),
(355, 358),
(355, 359),

(360, 361),
(360, 362),
(360, 363),
(360, 364),
(360, 365),

(366, 367),
(366, 368),
(366, 369),
(366, 370),

(371, 372),
(371, 373),
(371, 374),
(371, 375),

(376, 377),
(376, 378),
(376, 379),
(376, 380),

(381, 382),
(381, 383),
(381, 384),
(381, 385),

(386, 387),
(386, 388),
(386, 389),
(386, 390),

(391, 392),
(391, 393),
(391, 394),
(391, 395),

(396, 397),
(396, 398),
(396, 399),
(396, 400),

(401, 402),
(401, 403),
(401, 404),
(401, 405),

(406, 407),
(406, 408),
(406, 409),
(406, 410),

(411, 412),
(411, 413),
(411, 414),
(411, 415),

(416, 417),
(416, 418),
(416, 419),
(416, 420),

(421, 422),
(421, 423),
(421, 424),
(421, 425),

(426, 427),
(426, 428),
(426, 429),
(426, 430),

(431, 432),
(431, 433),
(431, 434),
(431, 435),

(436, 437),
(436, 438),
(436, 439),
(436, 440),

(441, 442),
(441, 443),
(441, 444),
(441, 445),

(446, 447),
(446, 448),
(446, 449),
(446, 450),

(451, 452),
(451, 453),
(451, 454),
(451, 455),

(456, 457),
(456, 458),
(456, 459),
(456, 460),

(461, 462),
(461, 463),
(461, 464),
(461, 465),

(466, 467),
(466, 468),

(469, 470),
(469, 471),
(469, 472),
(469, 473),

(474, 475),
(474, 476),
(474, 477),
(474, 478),

(479, 480),
(479, 481),
(479, 482),
(479, 483),

(484, 485),
(484, 486),

(487, 488),
(487, 489),

(490, 491),
(490, 492),
(490, 493),
(490, 494),

(495, 496),
(495, 497),
(495, 498),
(495, 499),

(500, 501),
(500, 502),
(500, 503),
(500, 504),

(505, 506),
(505, 507),
(505, 508),
(505, 509),

(510, 511),
(510, 512),
(510, 513),
(510, 514),

(515, 516),
(515, 517),
(515, 518),
(515, 519),

(520, 521),

(522, 523),

(524, 525),

(526, 527),
(526, 528),
(526, 529),

(530, 531),
(530, 532),
(530, 533),

(534, 535),
(534, 536),
(534, 537),

(538, 539),
(538, 540),
(538, 541),

(542, 543),
(542, 544),
(542, 545),

(546, 547),
(546, 548),
(546, 549),

(550, 551),
(550, 552),
(550, 553),

(554, 555),
(554, 556),
(554, 557),

(558, 559),

(560, 561),
(560, 562),
(560, 563),

(564, 565),
(564, 566),
(564, 567),

(568, 569),
(568, 570),
(568, 571),

(572, 573),
(572, 574),
(572, 575),

(576, 577),
(576, 578),
(576, 579),
(576, 580);



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
