-- MySQL Workbench Synchronization
-- Generated: 2018-08-22 13:14
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationareas` (
  `idArea` INT(10) UNSIGNED NOT NULL,
  `lang` VARCHAR(3) NOT NULL,
  `nameArea` VARCHAR(255) NOT NULL,
  `descArea` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idArea`, `lang`),
  INDEX `fk_LocalizationAreas_Languages1_idx` (`lang` ASC),
  CONSTRAINT `fk_LocalizationAreas_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationAreas_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `discord_bot_rpg`.`languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

---

INSERT INTO `discord_bot_rpg`.`localizationareas` SELECT idArea, "fr", AreaName as nameArea, AreaDesc as descArea FROM areas;

INSERT INTO `discord_bot_rpg`.`localizationareas` VALUES 
(1, "en", "Buldaar Forest", "This forest welcomes a large number of beginners wishing to go on an adventure, unfortunately for them, the adventure is not easy, even here."),
(2, "en", "Rocky Plains", "This plain is filled with magic. Golems are born from this magic and since then they wander here."),
(3, "en", "Lirayl Dead End", "Once this dead end buzzed with life, but for years an evil corrupted the place and destroyed everything in its path."),
(4, "en", "Baanar Jungle", "It's a jungle!"),
(5, "en", "Bradford", "Bradford is a very interesting location, and serves as a rest camp for many adventurers."),
(6, "en", "Fishford", "A fishing village, but this one is just waiting to be extended."),
(7, "en", "Goundfire", "It's hot in here, isn't it? Yes, it is.");

-- MySQL Workbench Synchronization
-- Generated: 2018-08-22 13:41
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`areas` 
DROP COLUMN `AreaDesc`,
DROP COLUMN `AreaName`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Synchronization
-- Generated: 2018-08-22 13:58
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationregions` (
  `idRegion` INT(10) UNSIGNED NOT NULL,
  `lang` VARCHAR(3) NOT NULL,
  `nameRegion` VARCHAR(45) NOT NULL,
  `imageRegion` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idRegion`, `lang`),
  INDEX `fk_LocalizationRegions_Languages1_idx` (`lang` ASC),
  CONSTRAINT `fk_LocalizationRegions_Regions1`
    FOREIGN KEY (`idRegion`)
    REFERENCES `discord_bot_rpg`.`regions` (`idRegion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationRegions_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `discord_bot_rpg`.`languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO `discord_bot_rpg`.`localizationregions` SELECT idRegion, "fr", name as nameRegion, image as imageRegion FROM regions;

INSERT INTO `discord_bot_rpg`.`localizationregions` VALUES
(1, "en", "Isle of Depraved", "https://image.ibb.co/nKdAGK/map_base.png");

-- MySQL Workbench Synchronization
-- Generated: 2018-08-22 15:00
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`regions` 
DROP COLUMN `image`,
DROP COLUMN `name`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
