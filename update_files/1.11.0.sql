SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `levels` 
ADD COLUMN `rebirthLevel` INT UNSIGNED NOT NULL AFTER `actualLevel`,
ADD INDEX `fk_Levels_RebirthsPossibles1_idx` (`rebirthLevel` ASC) VISIBLE;

ALTER TABLE `items` 
ADD COLUMN `rebirthLevel` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `favorite`,
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ,
ADD INDEX `fk_Items_RebirthsPossibles1_idx` (`rebirthLevel` ASC) VISIBLE;

ALTER TABLE `craftitem` 
ADD COLUMN `minRebirthLevel` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `idBaseItem`,
ADD COLUMN `maxRebirthLevel` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `minRebirthLevel`,
ADD INDEX `fk_CraftItem_RebirthsPossibles1_idx` (`minRebirthLevel` ASC) VISIBLE,
ADD INDEX `fk_CraftItem_RebirthsPossibles2_idx` (`maxRebirthLevel` ASC) VISIBLE;

ALTER TABLE `craftitemsneeded` 
ADD COLUMN `minRebirthLevel` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `number`,
ADD INDEX `fk_CraftItemsNeeded_RebirthsPossibles1_idx` (`minRebirthLevel` ASC) VISIBLE;

ALTER TABLE `characterscraftlevel` 
ADD COLUMN `rebirthLevel` INT UNSIGNED NOT NULL AFTER `actualExp`,
ADD INDEX `fk_CharactersCraftLevel_RebirthsPossibles1_idx` (`rebirthLevel` ASC) VISIBLE;

ALTER TABLE `craftbuilding` 
ADD COLUMN `minRebirthLevel` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `maxLevel`,
ADD COLUMN `maxRebirthLevel` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `minRebirthLevel`,
ADD INDEX `fk_CraftBuilding_RebirthsPossibles1_idx` (`minRebirthLevel` ASC) VISIBLE,
ADD INDEX `fk_CraftBuilding_RebirthsPossibles2_idx` (`maxRebirthLevel` ASC) VISIBLE;

ALTER TABLE `areaslevels` 
CHANGE COLUMN `price` `price` BIGINT UNSIGNED NOT NULL DEFAULT 1000000 ;

ALTER TABLE `areasmonsterslevels` 
ADD COLUMN `minRebirthLevel` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `maxLevel`,
ADD COLUMN `maxRebirthLevel` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `minRebirthLevel`,
ADD INDEX `fk_AreasMonstersLevels_RebirthsPossibles1_idx` (`minRebirthLevel` ASC) VISIBLE,
ADD INDEX `fk_AreasMonstersLevels_RebirthsPossibles2_idx` (`maxRebirthLevel` ASC) VISIBLE;

CREATE TABLE IF NOT EXISTS `rebirthspossibles` (
  `rebirthLevel` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nbrOfStatsPointsPerLevel` INT UNSIGNED NOT NULL DEFAULT 5,
  `nbrOfTalentPointsBonus` INT UNSIGNED NOT NULL DEFAULT 0,
  `percentageBonusToMonstersStats` INT UNSIGNED NOT NULL DEFAULT 0,
  `percentageBonusToItemsStats` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`rebirthLevel`),
  UNIQUE INDEX `rebrithLevel_UNIQUE` (`rebirthLevel` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

REPLACE INTO rebirthspossibles VALUES
(0, 5, 0,   0, 0),
(1, 6, 5,   10, 8),
(2, 7, 10,  20, 16),
(3, 8, 15,  30, 24),
(4, 9, 20,  40, 32),
(5, 10, 25, 50, 40);

ALTER TABLE `levels`
ADD CONSTRAINT `fk_Levels_RebirthsPossibles1`
  FOREIGN KEY (`rebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `items` 
ADD CONSTRAINT `fk_Items_RebirthsPossibles1`
  FOREIGN KEY (`rebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `craftitem`
ADD CONSTRAINT `fk_CraftItem_RebirthsPossibles1`
  FOREIGN KEY (`minRebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_CraftItem_RebirthsPossibles2`
  FOREIGN KEY (`maxRebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `craftitemsneeded`
ADD CONSTRAINT `fk_CraftItemsNeeded_RebirthsPossibles1`
  FOREIGN KEY (`minRebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `characterscraftlevel` 
ADD CONSTRAINT `fk_CharactersCraftLevel_RebirthsPossibles1`
  FOREIGN KEY (`rebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `craftbuilding`
ADD CONSTRAINT `fk_CraftBuilding_RebirthsPossibles1`
  FOREIGN KEY (`minRebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_CraftBuilding_RebirthsPossibles2`
  FOREIGN KEY (`maxRebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `areasmonsterslevels` 
ADD CONSTRAINT `fk_AreasMonstersLevels_RebirthsPossibles1`
  FOREIGN KEY (`minRebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_AreasMonstersLevels_RebirthsPossibles2`
  FOREIGN KEY (`maxRebirthLevel`)
  REFERENCES `rebirthspossibles` (`rebirthLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;