SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `discord_bot_rpg`.`statsrepartition` 
CHANGE COLUMN `percentage` `percentage` INT UNSIGNED NOT NULL DEFAULT 0 ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`Climates` (
  `idClimate` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(45) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`idClimate`),
  UNIQUE INDEX `idClimate_UNIQUE` (`idClimate` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`Weathers` (
  `idWeather` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(45) NOT NULL DEFAULT 'none',
  `travelSpeed` INT UNSIGNED NOT NULL DEFAULT 100,
  `collectSpeed` INT UNSIGNED NOT NULL DEFAULT 100,
  `collectChances` INT UNSIGNED NOT NULL DEFAULT 100,
  PRIMARY KEY (`idWeather`),
  UNIQUE INDEX `idWeather_UNIQUE` (`idWeather` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`climatesweathers` (
  `idClimate` INT UNSIGNED NOT NULL,
  `idWeather` INT UNSIGNED NOT NULL,
  `probability` INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idClimate`, `idWeather`),
  INDEX `fk_ClimatesWeathers_Weathers1_idx` (`idWeather` ASC) VISIBLE,
  CONSTRAINT `fk_ClimatesWeathers_Climates1`
    FOREIGN KEY (`idClimate`)
    REFERENCES `discord_bot_rpg`.`climates` (`idClimate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ClimatesWeathers_Weathers1`
    FOREIGN KEY (`idWeather`)
    REFERENCES `discord_bot_rpg`.`weathers` (`idWeather`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`AreasClimates` (
  `idArea` INT UNSIGNED NOT NULL,
  `idClimate` INT UNSIGNED NOT NULL,
  `currentWeather` INT UNSIGNED NOT NULL DEFAULT 1,
  `intensity` INT UNSIGNED NOT NULL DEFAULT 100,
  PRIMARY KEY (`idArea`),
  UNIQUE INDEX `Areas_idArea_UNIQUE` (`idArea` ASC) VISIBLE,
  INDEX `fk_AreasClimates_Climates1_idx` (`idClimate` ASC) VISIBLE,
  INDEX `fk_AreasClimates_Weathers1_idx` (`currentWeather` ASC) VISIBLE,
  CONSTRAINT `fk_AreasClimates_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreasClimates_Climates1`
    FOREIGN KEY (`idClimate`)
    REFERENCES `discord_bot_rpg`.`climates` (`idClimate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreasClimates_Weathers1`
    FOREIGN KEY (`currentWeather`)
    REFERENCES `discord_bot_rpg`.`weathers` (`idWeather`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

REPLACE INTO `discord_bot_rpg`.`climates` VALUES
(1, "temperate_oceanic"),
(2, "volcanic_hell"),
(3, "hot_desert"),
(4, "eternal_snow"),
(5, "interior");

-- Travel Speed | Collect Speed | Collect Chances
REPLACE INTO `discord_bot_rpg`.`weathers` VALUES
(1, "sunny", 100, 100, 100),
(2, "cloudy", 100, 90, 100),
(3, "foggy", 75, 75, 75),
(4, "rainy", 85, 85, 100),
(5, "rainstorm", 60, 80, 100),
(6, "snowy", 70, 85, 100),
(7, "firestorm", 10, 10, 150),
(8, "sandstorm", 30, 25, 70),
(9, "snowstorm", 30, 70, 25);


REPLACE INTO `discord_bot_rpg`.`climatesweathers` VALUES
(1, 1, 60),(1, 2, 25),(1, 3, 8),(1, 4, 5),(1, 5, 2),
(2, 1, 50),(2, 2, 30),(2, 3, 5),(2, 7, 15),
(3, 1, 80),(3, 2, 15),(3, 8, 5),
(4, 1, 60),(4, 2, 20),(4, 3, 15),(4, 9, 5),
(5, 1, 100);

REPLACE INTO `discord_bot_rpg`.`areasclimates` VALUES
(1, 1, 1, 100), (2, 1, 1, 100), (3, 1, 1, 100), (4, 1, 1, 100), (5, 1, 1, 100), (6, 1, 1, 100), (7, 5, 1, 100),
(8, 1, 1, 100), (9, 1, 1, 100), (10, 1, 1, 100), (11, 5, 1, 100), (12, 1, 1, 100), (13, 1, 1, 100), (14, 1, 1, 100),
(15, 3, 1, 100),(16, 3, 1, 100),(17, 3, 1, 100),(18, 3, 1, 100),(19, 3, 1, 100),(20, 3, 1, 100),(21, 5, 1, 100),
(22, 2, 1, 100),(23, 2, 1, 100),(24, 2, 1, 100),(25, 2, 1, 100),(26, 2, 1, 100),(27, 5, 1, 100),
(28, 4, 1, 100),(29, 4, 1, 100),(30, 4, 1, 100),(31, 4, 1, 100),(32, 4, 1, 100),(33, 5, 1, 100),(34, 4, 1, 100);



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
