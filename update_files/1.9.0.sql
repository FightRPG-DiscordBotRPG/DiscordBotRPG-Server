SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `discord_bot_rpg`.`statsrepartition` 
CHANGE COLUMN `percentage` `percentage` INT UNSIGNED NOT NULL DEFAULT 0 ;

create table if not exists `discord_bot_rpg`.`climates` (
  `idClimate` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(45) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`idClimate`),
  UNIQUE INDEX `idClimate_UNIQUE` (`idClimate` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`weathers` (
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

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`areasclimates` (
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
(7, "firestorm", 25,5, 150),
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


-- Changing database on monstres groupes
DROP TABLE areasmonsters;
DROP TABLE monstresgroupes;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`monstresgroupes` (
  `idMonstresGroupe` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shrothand` VARCHAR(255) NULL,
  PRIMARY KEY (`idMonstresGroupe`),
  UNIQUE INDEX `idMonstresGroupe_UNIQUE` (`idMonstresGroupe` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`areasmonsters` (
  `idArea` INT(10) UNSIGNED NOT NULL,
  `idMonstresGroupe` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`, `idMonstresGroupe`),
  INDEX `fk_AreasMonsters_MonstresGroupes1_idx` (`idMonstresGroupe` ASC) VISIBLE,
  CONSTRAINT `fk_table1_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreasMonsters_MonstresGroupes1`
    FOREIGN KEY (`idMonstresGroupe`)
    REFERENCES `discord_bot_rpg`.`monstresgroupes` (`idMonstresGroupe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`monstresgroupesassoc` (
  `idMonstresGroupe` INT(10) UNSIGNED NOT NULL,
  `idMonstre` INT(10) UNSIGNED NOT NULL,
  `number` INT(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idMonstresGroupe`, `idMonstre`),
  INDEX `fk_MonstresGroupes_Monstres1_idx` (`idMonstre` ASC) VISIBLE,
  INDEX `fk_MonstresGroupesAssoc_MonstresGroupes1_idx` (`idMonstresGroupe` ASC) VISIBLE,
  CONSTRAINT `fk_MonstresGroupes_Monstres1`
    FOREIGN KEY (`idMonstre`)
    REFERENCES `discord_bot_rpg`.`monstres` (`idMonstre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MonstresGroupesAssoc_MonstresGroupes1`
    FOREIGN KEY (`idMonstresGroupe`)
    REFERENCES `discord_bot_rpg`.`monstresgroupes` (`idMonstresGroupe`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

INSERT INTO monstresgroupes
VALUES
(1,""),(2,""),(3,""),(4,""),(5,""),(6,""),(7,""),(8,""),(9,""),
(10,""),(11,""),(12,""),(13,""),(14,""),(15,""),(16,""),
(17,""),(18,""),(19,""),(20,""),(21,""),(22,""),(23,""),
(24,""),(25,""),(26,""),(27,""),(28,""),(29,""),(30,""),
(31,""),(32,""),(33,""),(34,""),(35,""),(36,""),(37,""),
(38,""),(39,""),(40,""),(41,""),(42,""),(43,""),(44,""),
(45,""),(46,""),(47,""),(48,""),(49,""),(50,""),(51,""),
(52,""),(53,""),(54,""),(55,""),(56,""),(57,""),(58,""),
(59,""),(60,""),(61,""),(62,""),(63,""),(64,""),(65,""),
(66,""),(67,""),(68,""),(69,""),(70,""),(71,""),(72,""),
(73,""),(74,""),(75,""),(76,""),(77,"");

INSERT INTO areasmonsters 
VALUES 
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,6),(2,7),(2,8),(2,9),(2,10),(2,11),(2,12),
(3,13),(3,14),(3,15),(3,16),(3,17),(3,18),(3,19),(3,20),
(4,21),(4,22),(4,23),(4,24),(4,25),(4,26),(4,27),(4,28),
(7,29),(9,30),(19,30),(20,30),(9,31),(9,32),(10,33),
(10,34),(12,35),(12,36),(13,37),(13,38),(13,39),(11,40),
(17,41),(17,42),(17,43),(18,43),(17,44),(18,45),(18,46),(18,47),
(19,48),(20,49),(19,50),(20,50),(19,51),(20,52),(21,53),(23,54),
(23,55),(25,55),(23,56),(25,56),(23,57),(24,58),(24,59),(25,59),(24,60),
(24,61),(25,62),(26,63),(26,64),(26,65),(26,66),(27,67),
(28,68),(32,68),(28,69),(31,69),(28,70),(32,70),(28,71),(32,71),(30,72),
(31,72),(30,73),(32,73),(30,74),(31,74),(30,75),(31,76),(33,77);



INSERT INTO monstresgroupesassoc
VALUES
(1,1,1),(2,2,1),(3,3,1),(4,4,1),(5,5,1),(6,6,1),(7,7,1),(8,8,1),(9,9,1),
(10,10,1),(11,11,1),(12,12,1),(13,13,1),(14,14,1),(15,15,1),(16,16,1),
(17,17,1),(18,18,1),(19,19,1),(20,20,1),(21,21,1),(22,22,1),(23,23,1),
(24,24,1),(25,25,1),(26,26,1),(27,27,1),(28,28,1),(29,29,1),(29,30,2),
(30,31,1),(31,32,1),(32,35,1),(33,36,1),(34,37,1),(35,38,1),(36,39,1),
(37,40,1),(38,41,1),(39,42,1),(40,43,2),(40,44,1),(41,45,1),(42,46,1),
(43,47,1),(44,48,1),(45,49,1),(46,50,1),(47,51,1),(48,52,1),(49,53,1),
(50,33,2),(51,34,1),(52,54,1),(53,54,2),(53,55,1),(54,56,1),(55,57,1),
(56,58,1),(57,59,1),(58,60,1),(59,61,1),(60,62,1),(61,63,1),(62,64,1),
(63,65,1),(64,66,1),(65,67,1),(66,68,1),(67,62,2),(67,69,2),(67,70,1),
(68,71,1),(69,72,1),(70,73,1),(71,74,1),(72,75,1),(73,76,1),(74,77,1),
(75,78,1),(76,79,1),(77,80,4),(77,81,1);


-- New Dungeon System Addind new areas...

-- First Region
INSERT INTO areas
VALUES
(35, "https://i.ytimg.com/vi/qTJ8skYIpJc/maxresdefault.jpg", 3, 1, 5);

REPLACE INTO `discord_bot_rpg`.`areasclimates` VALUES
(35, 2, 1, 100);


INSERT INTO areasitems
VALUES
(35, 5, 0, 1, 1),(35, 10, 0, 1, 1),(35, 15, 0, 1, 1),(35, 20, 0, 1, 1);

INSERT INTO areasmonsterslevels
VALUES
(35, 20, 20);

INSERT INTO localizationareas VALUES 
(35, "fr", "Le pont des nappes feu-à-tiques", "Si tu trouve qu'il fait chaud, ne traverse pas ce pont, tu risque de fondre."),
(35, "en", "Groundfire Bridge", "If you think it's hot, don't cross that bridge, you might melt...");


INSERT INTO areasregions
VALUES
(35, 1);

DELETE FROM areaspaths WHERE areaspaths.idArea1 = 7 OR areaspaths.idArea2 = 7;

REPLACE INTO areaspaths
VALUES
(7, 4, 1, 0),
(35, 7, 1, 0),
(4, 35, 30, 0),
(35, 4, 30, 0);

INSERT INTO monstresgroupes
VALUES
(78, "two_monsters_of_region_1");

INSERT INTO monstresgroupesassoc
VALUES
(78,14,2);

INSERT INTO areasmonsters 
VALUES 
(35,78);


-- Tywardreath
INSERT INTO areas
VALUES
(36, "https://image.freepik.com/free-vector/cave-with-entrance_1308-17047.jpg", 3, 1, 5);

REPLACE INTO `discord_bot_rpg`.`areasclimates` VALUES
(36, 5, 1, 100);


INSERT INTO areasitems
VALUES
(36, 5, 0, 1, 1),(36, 10, 0, 1, 1),(36, 15, 0, 1, 1),(36, 20, 0, 1, 1);

INSERT INTO areasmonsterslevels
VALUES
(36, 40, 40);

INSERT INTO localizationareas VALUES 
(36, "fr", "Entrée des grottes de Tywardreath", "Seulement l'entrée d'une grotte froide et humide, des rumeurs racontent qu'un monstre puissant s'y cache."),
(36, "en", "Tywardreath Caves Entrance", "Only the entrance to a cold and humid cave, rumors say a powerful monster is hiding there...");


INSERT INTO areasregions
VALUES
(36, 2);

DELETE FROM areaspaths WHERE areaspaths.idArea1 = 11 OR areaspaths.idArea2 = 11;

REPLACE INTO areaspaths
VALUES
(11, 10, 1, 0),
(36, 11, 1, 0),
(10, 36, 30, 0),
(36, 10, 30, 0);

INSERT INTO monstresgroupes
VALUES
(79, "dungeon_tywardreath_floor_one");

INSERT INTO monstresgroupesassoc
VALUES
(79,36,4);

INSERT INTO areasmonsters 
VALUES 
(36,79);


-- Tjesomunein Desert
INSERT INTO areas
VALUES
(37, "https://cdn.fight-rpg.com/images/areas/TombEntrance.jpg", 3, 1, 5);

REPLACE INTO `discord_bot_rpg`.`areasclimates` VALUES
(37, 5, 1, 100);


INSERT INTO areasitems
VALUES
(37, 5, 0, 1, 1),(37, 10, 0, 1, 1),(37, 15, 0, 1, 1),(37, 20, 0, 1, 1), (37, 39, 0.003, 1, 1);

INSERT INTO areasmonsterslevels
VALUES
(37, 60, 60);

INSERT INTO localizationareas VALUES 
(37, "fr", "Entrée des Tombes Oubliées", "Vous ne savez pas ce qu'il se trouve entre ces murs. En y repensant, vous devriez trouver énormément de sable..."),
(37, "en", "Entrance of The Forgotten Tombs", "You don't know what lies within these walls. Come to think of it, you should find a lot of sand...");


INSERT INTO areasregions
VALUES
(37, 3);

DELETE FROM areaspaths WHERE areaspaths.idArea1 = 21 OR areaspaths.idArea2 = 21;

REPLACE INTO areaspaths
VALUES
(21, 20, 1, 0),
(37, 21, 1, 0),
(20, 37, 20, 0),
(37, 20, 20, 0);

INSERT INTO monstresgroupes
VALUES
(80, "dungeon_tjesomunein_floor_one");

INSERT INTO monstresgroupesassoc
VALUES
(80,50,5);

INSERT INTO areasmonsters 
VALUES 
(37,80);


-- Daemonic Region
INSERT INTO areas
VALUES
(38, "https://pbs.twimg.com/media/ES7MkdgXsAARRjR.jpg", 3, 1, 5);

REPLACE INTO `discord_bot_rpg`.`areasclimates` VALUES
(38, 2, 1, 100);


INSERT INTO areasitems
VALUES
(38, 5, 0, 1, 1),(38, 10, 0, 1, 1),(38, 15, 0, 1, 1),(38, 20, 0, 1, 1), (38, 40, 0.0005, 1, 1);

INSERT INTO areasmonsterslevels
VALUES
(38, 80, 80);

INSERT INTO localizationareas VALUES 
(38, "fr", "Entrée de La Citadelle Démoniaque", "Vous êtes au abords des problèmes. Seuls les plus braves peuvent entrer dans la citadelle et espérer vaincre les hordes démons enragés..."),
(38, "en", "Entrance of The Daemonic Citadel", "You're on the verge of trouble. Only the bravest can enter the citadel and hope to vanquish the raging hordes of demons...");


INSERT INTO areasregions
VALUES
(38, 4);

DELETE FROM areaspaths WHERE areaspaths.idArea1 = 27 OR areaspaths.idArea2 = 27;

REPLACE INTO areaspaths
VALUES
(27, 22, 1, 0),
(38, 27, 1, 0),
(22, 38, 30, 0),
(38, 22, 30, 0);

INSERT INTO monstresgroupes
VALUES
(81, "dungeon_demonic_citadel_floor_one");

INSERT INTO monstresgroupesassoc
VALUES
(81,62,4), (81,69,1);

INSERT INTO areasmonsters 
VALUES 
(38,81);


-- Daemonic Region
INSERT INTO areas
VALUES
(39, "https://cdn.clipart.email/694fdbe27e5c77d81560e5bb593d73fd_ice-cave-doodles-4-4-by-lastkrystaldragon-on-deviantart_1024-682.png", 3, 1, 5);

REPLACE INTO `discord_bot_rpg`.`areasclimates` VALUES
(39, 4, 1, 100);


INSERT INTO areasitems
VALUES
(39, 5, 0, 1, 1),(39, 10, 0, 1, 1),(39, 15, 0, 1, 1),(39, 20, 0, 1, 1), (39, 56, 0.0001, 1, 1),
(33, 49, 0.002, 25, 50);

INSERT INTO areasmonsterslevels
VALUES
(39, 100, 100);

INSERT INTO localizationareas VALUES 
(39, "fr", "Entrée de la Caverne des Miroirs de Glace", "L'entrée de cette grotte n'est pas accueillante. Elle vous fait froid dans le dos. Peut-être découvrirez vous des mystères enfouis dans cet endroit glacé."),
(39, "en", "Entrance of Ice Mirror Cave", "The entrance to this cave is not welcoming. It sends chills down your spine. Perhaps you will discover mysteries buried in this frozen place.");


INSERT INTO areasregions
VALUES
(39, 5);

DELETE FROM areaspaths WHERE areaspaths.idArea1 = 33 OR areaspaths.idArea2 = 33;

REPLACE INTO areaspaths
VALUES
(33, 29, 1, 0),
(39, 33, 1, 0),
(29, 39, 30, 0),
(39, 29, 30, 0);

INSERT INTO monstresgroupes
VALUES
(82, "dungeon_ice_mirror_cave_floor_one");

INSERT INTO monstresgroupesassoc
VALUES
(82,80,4), (82,74,1);

INSERT INTO areasmonsters 
VALUES 
(39,82);





SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
