SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP PROCEDURE IF EXISTS `doesPlayerHaveEnoughMatsToCraftThisItem`;
CREATE DEFINER=`discord_bot_rpg`@`%` PROCEDURE `doesPlayerHaveEnoughMatsToCraftThisItem` (IN `idCharacterToLook` INT, IN `idCaftToLook` INT)  BEGIN
	SELECT 
    IF((SELECT 
                COUNT(*)
            FROM
                charactersinventory
                    INNER JOIN
                items ON items.idItem = charactersinventory.idItem
            WHERE
                charactersinventory.idCharacter = idCharacterToLook
                    AND items.idBaseItem IN (SELECT 
                        craftitemsneeded.NeededItem
                    FROM
                        craftitemsneeded
                    WHERE
                        craftitemsneeded.IdCraftItem = idCaftToLook)
                    AND charactersinventory.number >= (SELECT 
                        craftitemsneeded.number
                    FROM
                        craftitemsneeded
                    WHERE
                        craftitemsneeded.IdCraftItem = idCaftToLook
                            AND craftitemsneeded.NeededItem = items.idBaseItem)) = (SELECT 
                COUNT(*)
            FROM
                craftitemsneeded
            WHERE
                craftitemsneeded.IdCraftItem = idCaftToLook),
        'true',
        'false') AS doesPlayerHaveEnoughMats;
END;

DROP TABLE IF EXISTS `achievement`;
CREATE TABLE IF NOT EXISTS `achievement` (
  `idAchievement` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name_identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `points` int(11) NOT NULL DEFAULT '10',
  PRIMARY KEY (`idAchievement`),
  UNIQUE KEY `idAchievement_UNIQUE` (`idAchievement`),
  UNIQUE KEY `name_identifier_UNIQUE` (`name_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `achievement` (`idAchievement`, `name_identifier`, `points`) VALUES
(1, 'founder', 100),
(2, 'last_challenge', 100);

DROP TABLE IF EXISTS `areas`;
CREATE TABLE IF NOT EXISTS `areas` (
  `idArea` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `AreaImage` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'https://cdn.pixabay.com/photo/2013/04/06/11/50/image-editing-101040_960_720.jpg',
  `idAreaType` int(10) UNSIGNED NOT NULL,
  `AreaLevel` int(10) UNSIGNED NOT NULL,
  `statPoints` int(10) UNSIGNED NOT NULL DEFAULT '5',
  PRIMARY KEY (`idArea`),
  UNIQUE KEY `idArea_UNIQUE` (`idArea`),
  KEY `fk_Areas_AreasTypes1_idx` (`idAreaType`),
  KEY `fk_Areas_AreasLevels1_idx` (`AreaLevel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areas` (`idArea`, `AreaImage`, `idAreaType`, `AreaLevel`, `statPoints`) VALUES
(1, 'https://c1.staticflickr.com/6/5082/5260289771_1e133585fb_b.jpg', 1, 1, 5),
(2, 'https://cdn.pixabay.com/photo/2015/10/27/08/53/landscape-1008572_960_720.jpg', 1, 1, 5),
(3, 'https://d2v9y0dukr6mq2.cloudfront.net/video/thumbnail/2czqMab/forest-fire-mountain-tree-destruction-burn-p-hd-0930_vkgzsxlof__F0000.png', 1, 1, 5),
(4, 'http://s1.thingpic.com/images/86/6fS2n1Y7d9S7yHdemFr5Ys6Q.jpeg', 1, 1, 5),
(5, 'https://i.ytimg.com/vi/8yIEOPa9PAs/maxresdefault.jpg', 2, 1, 5),
(6, 'http://i.imgur.com/B7lYXrd.jpg', 2, 1, 5),
(7, 'https://pbs.twimg.com/media/CmOgb8vWEAARI_g.jpg', 3, 1, 0),
(8, 'http://ayay.co.uk/backgrounds/rpg_games/fable/city-canal.jpg', 2, 1, 5),
(9, 'https://serc.carleton.edu/images/NZFires/megafires/burned_forest_1367176225_650.jpg', 1, 1, 5),
(10, 'https://thewallpapers.org/zoom/34407/4-3-2-hills.jpg', 1, 1, 5),
(11, 'https://images.fineartamerica.com/images/artworkimages/mediumlarge/1/luray-caverns--virginia--reflections-at-dream-lake-brendan-reals.jpg', 3, 1, 5),
(12, 'https://www.sunsetbld.com/photos/photos-meteor-crater/meteor-crater-03.jpg', 1, 1, 5),
(13, 'https://cdn.wallpapersafari.com/71/41/R5zTvA.jpg', 1, 1, 5),
(14, 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/intermediary/f/84889e75-a424-4357-838b-7589f64dec2a/d6x7ohy-04a4fdf6-bd50-48b6-9d4d-a395be032703.jpg/v1/fill/w_986,h_810,q_70,strp/desert_outpost_edit_by_fleret_d6x7ohy-pre.jpg', 2, 1, 5),
(15, 'https://vignette.wikia.nocookie.net/planarch-world/images/3/32/Egypt_fantasy_art_1280x800_64840.jpg/revision/latest?cb=20130904022740', 2, 1, 5),
(16, 'https://img00.deviantart.net/197a/i/2012/241/b/0/city_at_sunset_by_vennom07-d5cuzhr.jpg', 2, 1, 5),
(17, 'https://img00.deviantart.net/b5ba/i/2016/117/d/2/cracked_landsape_by_thechrispman-da0ehq0.png', 1, 1, 5),
(18, 'http://fc03.deviantart.net/fs70/i/2013/019/a/2/desert_landscape_by_rambled-d5s0cib.jpg', 1, 1, 5),
(19, 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/intermediary/f/2abc5a8d-58e0-4913-a8a5-1d067c864b26/db6my5y-fd0aad3e-4e85-4cfd-b449-3268ff2acff2.jpg/v1/fill/w_900,h_480,q_70,strp/orc_village_by_veravoyna_db6my5y-fullview.jpg', 1, 1, 5),
(20, 'https://vignette.wikia.nocookie.net/assassinscreed/images/e/e4/ACO_Desert_Ruin_-_Concept_Art.jpg/revision/latest?cb=20171019091305', 1, 1, 5),
(21, 'https://pre00.deviantart.net/7106/th/pre/i/2016/030/a/f/ruins_underground_by_asahisuperdry-d9puru6.jpg', 3, 1, 5),
(22, 'https://image.ibb.co/n2HydV/northernexpedition.png', 2, 1, 5),
(23, 'https://img00.deviantart.net/2238/i/2015/099/9/7/lava_cracks_by_frejagelii-d8p1n1y.jpg', 1, 1, 5),
(24, 'http://orig04.deviantart.net/b9a8/f/2010/153/6/f/lavascape_by_llrobinll.png', 1, 1, 5),
(25, 'https://cdna.artstation.com/p/assets/images/images/004/407/402/large/nicolas-ico-vallee-sp100.jpg?1483483562', 1, 1, 0),
(26, 'https://pre00.deviantart.net/26ae/th/pre/i/2016/179/4/8/ruined_village_by_andanguyen-da2e44f.png', 1, 1, 0),
(27, 'https://images6.alphacoders.com/415/415665.jpg', 3, 1, 0),
(28, 'https://cdn.fight-rpg.com/images/areas/TowerFrozen.png', 1, 2, 0),
(29, 'http://i.imgur.com/28FLw.jpg', 2, 1, 0),
(30, 'https://vignette.wikia.nocookie.net/rsroleplay/images/6/61/Cadderoccourtyard.jpg/', 1, 1, 0),
(31, 'https://cdn.fight-rpg.com/images/areas/HauntedHouse.png', 1, 1, 0),
(32, 'https://cdn.fight-rpg.com/images/areas/HauntedVillage.png', 1, 4, 5),
(33, 'http://img07.deviantart.net/446c/i/2013/158/9/e/ice_cave_by_devin87-d68585o.jpg', 3, 1, 0),
(34, 'https://bnetcmsus-a.akamaihd.net/cms/gallery/A0IFUJNHQ73S1421193822596.jpg', 2, 1, 0);

DROP TABLE IF EXISTS `areasbonuses`;
CREATE TABLE IF NOT EXISTS `areasbonuses` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idBonusTypes` int(10) UNSIGNED NOT NULL,
  `value` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idArea`,`idBonusTypes`),
  KEY `fk_AreasBonuses_BonusTypes1_idx` (`idBonusTypes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areasbonuses` (`idArea`, `idBonusTypes`, `value`) VALUES
(1, 1, 0),
(1, 2, 0),
(1, 3, 0),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(2, 1, 0),
(2, 2, 0),
(2, 3, 0),
(2, 4, 0),
(2, 5, 0),
(2, 6, 0),
(3, 1, 0),
(3, 2, 0),
(3, 3, 0),
(3, 4, 0),
(3, 5, 0),
(3, 6, 0),
(4, 1, 0),
(4, 2, 0),
(4, 3, 0),
(4, 4, 0),
(4, 5, 0),
(4, 6, 0),
(5, 1, 0),
(5, 2, 0),
(5, 3, 0),
(5, 4, 0),
(5, 5, 0),
(5, 6, 0),
(6, 1, 0),
(6, 2, 0),
(6, 3, 0),
(6, 4, 0),
(6, 5, 0),
(6, 6, 0),
(7, 1, 0),
(7, 2, 0),
(7, 3, 0),
(7, 4, 0),
(7, 5, 5),
(7, 6, 0),
(8, 1, 0),
(8, 2, 0),
(8, 3, 0),
(8, 4, 0),
(8, 5, 0),
(8, 6, 0),
(9, 1, 0),
(9, 2, 0),
(9, 3, 0),
(9, 4, 0),
(9, 5, 0),
(9, 6, 0),
(10, 1, 0),
(10, 2, 0),
(10, 3, 0),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(11, 1, 0),
(11, 2, 0),
(11, 3, 0),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(12, 1, 0),
(12, 2, 0),
(12, 3, 0),
(12, 4, 0),
(12, 5, 0),
(12, 6, 0),
(13, 1, 0),
(13, 2, 0),
(13, 3, 0),
(13, 4, 0),
(13, 5, 0),
(13, 6, 0),
(14, 1, 0),
(14, 2, 0),
(14, 3, 0),
(14, 4, 0),
(14, 5, 0),
(14, 6, 0),
(15, 1, 0),
(15, 2, 0),
(15, 3, 0),
(15, 4, 0),
(15, 5, 0),
(15, 6, 0),
(16, 1, 0),
(16, 2, 0),
(16, 3, 0),
(16, 4, 0),
(16, 5, 0),
(16, 6, 0),
(17, 1, 0),
(17, 2, 0),
(17, 3, 0),
(17, 4, 0),
(17, 5, 0),
(17, 6, 0),
(18, 1, 0),
(18, 2, 0),
(18, 3, 0),
(18, 4, 0),
(18, 5, 0),
(18, 6, 0),
(19, 1, 0),
(19, 2, 0),
(19, 3, 0),
(19, 4, 0),
(19, 5, 0),
(19, 6, 0),
(20, 1, 0),
(20, 2, 0),
(20, 3, 0),
(20, 4, 0),
(20, 5, 0),
(20, 6, 0),
(21, 1, 0),
(21, 2, 0),
(21, 3, 0),
(21, 4, 0),
(21, 5, 0),
(21, 6, 0),
(22, 1, 0),
(22, 2, 0),
(22, 3, 0),
(22, 4, 0),
(22, 5, 0),
(22, 6, 0),
(23, 1, 0),
(23, 2, 0),
(23, 3, 0),
(23, 4, 0),
(23, 5, 0),
(23, 6, 0),
(24, 1, 0),
(24, 2, 0),
(24, 3, 0),
(24, 4, 0),
(24, 5, 0),
(24, 6, 0),
(25, 1, 0),
(25, 2, 0),
(25, 3, 0),
(25, 4, 0),
(25, 5, 5),
(25, 6, 0),
(26, 1, 0),
(26, 2, 0),
(26, 3, 0),
(26, 4, 0),
(26, 5, 5),
(26, 6, 0),
(27, 1, 5),
(27, 2, 0),
(27, 3, 0),
(27, 4, 0),
(27, 5, 0),
(27, 6, 0),
(28, 1, 10),
(28, 2, 0),
(28, 3, 0),
(28, 4, 0),
(28, 5, 0),
(28, 6, 0),
(29, 1, 0),
(29, 2, 0),
(29, 3, 5),
(29, 4, 0),
(29, 5, 0),
(29, 6, 0),
(30, 1, 5),
(30, 2, 0),
(30, 3, 0),
(30, 4, 0),
(30, 5, 0),
(30, 6, 0),
(31, 1, 5),
(31, 2, 0),
(31, 3, 0),
(31, 4, 0),
(31, 5, 0),
(31, 6, 0),
(32, 1, 0),
(32, 2, 0),
(32, 3, 0),
(32, 4, 15),
(32, 5, 0),
(32, 6, 0),
(33, 1, 0),
(33, 2, 0),
(33, 3, 0),
(33, 4, 0),
(33, 5, 5),
(33, 6, 0),
(34, 1, 0),
(34, 2, 0),
(34, 3, 5),
(34, 4, 0),
(34, 5, 0),
(34, 6, 0);

DROP TABLE IF EXISTS `areasitems`;
CREATE TABLE IF NOT EXISTS `areasitems` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `percentage` float UNSIGNED NOT NULL DEFAULT '0',
  `min` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `max` int(10) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`idArea`,`idBaseItem`),
  KEY `fk_AreasItems_ItemsBase1_idx` (`idBaseItem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areasitems` (`idArea`, `idBaseItem`, `percentage`, `min`, `max`) VALUES
(1, 1, 0, 1, 1),
(1, 2, 0, 1, 1),
(1, 3, 0, 1, 1),
(1, 4, 0, 1, 1),
(1, 6, 0, 1, 1),
(1, 7, 0, 1, 1),
(1, 8, 0, 1, 1),
(1, 9, 0, 1, 1),
(1, 11, 0, 1, 1),
(1, 12, 0, 1, 1),
(1, 13, 0, 1, 1),
(1, 14, 0, 1, 1),
(1, 15, 0, 1, 1),
(1, 16, 0, 1, 1),
(1, 17, 0, 1, 1),
(1, 18, 0, 1, 1),
(1, 19, 0, 1, 1),
(2, 2, 0, 1, 1),
(2, 3, 0, 1, 1),
(2, 5, 0, 1, 1),
(2, 7, 0, 1, 1),
(2, 8, 0, 1, 1),
(2, 12, 0, 1, 1),
(2, 13, 0, 1, 1),
(2, 17, 0, 1, 1),
(2, 18, 0, 1, 1),
(3, 2, 0, 1, 1),
(3, 3, 0, 1, 1),
(3, 4, 0, 1, 1),
(3, 7, 0, 1, 1),
(3, 8, 0, 1, 1),
(3, 9, 0, 1, 1),
(3, 12, 0, 1, 1),
(3, 13, 0, 1, 1),
(3, 14, 0, 1, 1),
(3, 17, 0, 1, 1),
(3, 18, 0, 1, 1),
(3, 19, 0, 1, 1),
(3, 20, 0, 1, 1),
(4, 3, 0, 1, 1),
(4, 4, 0, 1, 1),
(4, 8, 0, 1, 1),
(4, 9, 0, 1, 1),
(4, 10, 0, 1, 1),
(4, 13, 0, 1, 1),
(4, 14, 0, 1, 1),
(4, 18, 0, 1, 1),
(4, 19, 0, 1, 1),
(7, 5, 0, 1, 1),
(7, 10, 0, 1, 1),
(7, 15, 0, 1, 1),
(7, 20, 0, 1, 1),
(9, 2, 0, 1, 1),
(9, 3, 0, 1, 1),
(9, 4, 0, 1, 1),
(9, 7, 0, 1, 1),
(9, 8, 0, 1, 1),
(9, 9, 0, 1, 1),
(9, 12, 0, 1, 1),
(9, 13, 0, 1, 1),
(9, 14, 0, 1, 1),
(9, 15, 0, 1, 1),
(9, 17, 0, 1, 1),
(9, 18, 0, 1, 1),
(9, 19, 0, 1, 1),
(9, 38, 0.007, 1, 1),
(10, 2, 0, 1, 1),
(10, 3, 0, 1, 1),
(10, 4, 0, 1, 1),
(10, 5, 0, 1, 1),
(10, 7, 0, 1, 1),
(10, 8, 0, 1, 1),
(10, 9, 0, 1, 1),
(10, 12, 0, 1, 1),
(10, 13, 0, 1, 1),
(10, 14, 0, 1, 1),
(10, 17, 0, 1, 1),
(10, 18, 0, 1, 1),
(10, 19, 0, 1, 1),
(10, 38, 0.007, 1, 1),
(11, 5, 0, 1, 1),
(11, 10, 0, 1, 1),
(11, 15, 0, 1, 1),
(11, 20, 0, 1, 1),
(11, 38, 0.007, 1, 1),
(12, 2, 0, 1, 1),
(12, 3, 0, 1, 1),
(12, 4, 0, 1, 1),
(12, 7, 0, 1, 1),
(12, 8, 0, 1, 1),
(12, 9, 0, 1, 1),
(12, 12, 0, 1, 1),
(12, 13, 0, 1, 1),
(12, 14, 0, 1, 1),
(12, 17, 0, 1, 1),
(12, 18, 0, 1, 1),
(12, 19, 0, 1, 1),
(12, 20, 0, 1, 1),
(12, 38, 0.007, 1, 1),
(13, 3, 0, 1, 1),
(13, 4, 0, 1, 1),
(13, 8, 0, 1, 1),
(13, 9, 0, 1, 1),
(13, 10, 0, 1, 1),
(13, 13, 0, 1, 1),
(13, 14, 0, 1, 1),
(13, 18, 0, 1, 1),
(13, 19, 0, 1, 1),
(13, 38, 0.007, 1, 1),
(17, 2, 0, 1, 1),
(17, 3, 0, 1, 1),
(17, 4, 0, 1, 1),
(17, 7, 0, 1, 1),
(17, 8, 0, 1, 1),
(17, 9, 0, 1, 1),
(17, 12, 0, 1, 1),
(17, 13, 0, 1, 1),
(17, 14, 0, 1, 1),
(17, 15, 0, 1, 1),
(17, 17, 0, 1, 1),
(17, 18, 0, 1, 1),
(17, 19, 0, 1, 1),
(17, 39, 0.003, 1, 1),
(18, 2, 0, 1, 1),
(18, 3, 0, 1, 1),
(18, 4, 0, 1, 1),
(18, 5, 0, 1, 1),
(18, 7, 0, 1, 1),
(18, 8, 0, 1, 1),
(18, 9, 0, 1, 1),
(18, 12, 0, 1, 1),
(18, 13, 0, 1, 1),
(18, 14, 0, 1, 1),
(18, 17, 0, 1, 1),
(18, 18, 0, 1, 1),
(18, 19, 0, 1, 1),
(18, 39, 0.003, 1, 1),
(19, 2, 0, 1, 1),
(19, 3, 0, 1, 1),
(19, 4, 0, 1, 1),
(19, 7, 0, 1, 1),
(19, 8, 0, 1, 1),
(19, 9, 0, 1, 1),
(19, 12, 0, 1, 1),
(19, 13, 0, 1, 1),
(19, 14, 0, 1, 1),
(19, 17, 0, 1, 1),
(19, 18, 0, 1, 1),
(19, 19, 0, 1, 1),
(19, 20, 0, 1, 1),
(19, 39, 0.003, 1, 1),
(20, 3, 0, 1, 1),
(20, 4, 0, 1, 1),
(20, 8, 0, 1, 1),
(20, 9, 0, 1, 1),
(20, 10, 0, 1, 1),
(20, 13, 0, 1, 1),
(20, 14, 0, 1, 1),
(20, 18, 0, 1, 1),
(20, 19, 0, 1, 1),
(20, 39, 0.003, 1, 1),
(21, 5, 0, 1, 1),
(21, 10, 0, 1, 1),
(21, 15, 0, 1, 1),
(21, 20, 0, 1, 1),
(21, 39, 0.003, 1, 1),
(23, 2, 0, 1, 1),
(23, 3, 0, 1, 1),
(23, 4, 0, 1, 1),
(23, 7, 0, 1, 1),
(23, 8, 0, 1, 1),
(23, 9, 0, 1, 1),
(23, 12, 0, 1, 1),
(23, 13, 0, 1, 1),
(23, 14, 0, 1, 1),
(23, 15, 0, 1, 1),
(23, 17, 0, 1, 1),
(23, 18, 0, 1, 1),
(23, 19, 0, 1, 1),
(24, 2, 0, 1, 1),
(24, 3, 0, 1, 1),
(24, 4, 0, 1, 1),
(24, 5, 0, 1, 1),
(24, 7, 0, 1, 1),
(24, 8, 0, 1, 1),
(24, 9, 0, 1, 1),
(24, 12, 0, 1, 1),
(24, 13, 0, 1, 1),
(24, 14, 0, 1, 1),
(24, 17, 0, 1, 1),
(24, 18, 0, 1, 1),
(24, 19, 0, 1, 1),
(25, 2, 0, 1, 1),
(25, 3, 0, 1, 1),
(25, 4, 0, 1, 1),
(25, 7, 0, 1, 1),
(25, 8, 0, 1, 1),
(25, 9, 0, 1, 1),
(25, 12, 0, 1, 1),
(25, 13, 0, 1, 1),
(25, 14, 0, 1, 1),
(25, 17, 0, 1, 1),
(25, 18, 0, 1, 1),
(25, 19, 0, 1, 1),
(25, 20, 0, 1, 1),
(26, 3, 0, 1, 1),
(26, 4, 0, 1, 1),
(26, 8, 0, 1, 1),
(26, 9, 0, 1, 1),
(26, 10, 0, 1, 1),
(26, 13, 0, 1, 1),
(26, 14, 0, 1, 1),
(26, 18, 0, 1, 1),
(26, 19, 0, 1, 1),
(27, 5, 0, 1, 1),
(27, 10, 0, 1, 1),
(27, 15, 0, 1, 1),
(27, 20, 0, 1, 1),
(27, 40, 0.0005, 1, 1),
(28, 2, 0, 1, 1),
(28, 3, 0, 1, 1),
(28, 4, 0, 1, 1),
(28, 7, 0, 1, 1),
(28, 8, 0, 1, 1),
(28, 9, 0, 1, 1),
(28, 12, 0, 1, 1),
(28, 13, 0, 1, 1),
(28, 14, 0, 1, 1),
(28, 15, 0, 1, 1),
(28, 17, 0, 1, 1),
(28, 18, 0, 1, 1),
(28, 19, 0, 1, 1),
(30, 2, 0, 1, 1),
(30, 3, 0, 1, 1),
(30, 4, 0, 1, 1),
(30, 5, 0, 1, 1),
(30, 7, 0, 1, 1),
(30, 8, 0, 1, 1),
(30, 9, 0, 1, 1),
(30, 12, 0, 1, 1),
(30, 13, 0, 1, 1),
(30, 14, 0, 1, 1),
(30, 17, 0, 1, 1),
(30, 18, 0, 1, 1),
(30, 19, 0, 1, 1),
(31, 2, 0, 1, 1),
(31, 3, 0, 1, 1),
(31, 4, 0, 1, 1),
(31, 7, 0, 1, 1),
(31, 8, 0, 1, 1),
(31, 9, 0, 1, 1),
(31, 12, 0, 1, 1),
(31, 13, 0, 1, 1),
(31, 14, 0, 1, 1),
(31, 17, 0, 1, 1),
(31, 18, 0, 1, 1),
(31, 19, 0, 1, 1),
(31, 20, 0, 1, 1),
(32, 3, 0, 1, 1),
(32, 4, 0, 1, 1),
(32, 8, 0, 1, 1),
(32, 9, 0, 1, 1),
(32, 10, 0, 1, 1),
(32, 13, 0, 1, 1),
(32, 14, 0, 1, 1),
(32, 18, 0, 1, 1),
(32, 19, 0, 1, 1),
(33, 5, 0, 1, 1),
(33, 10, 0, 1, 1),
(33, 15, 0, 1, 1),
(33, 20, 0, 1, 1),
(33, 56, 0.0001, 1, 1);

DROP TABLE IF EXISTS `areaslevels`;
CREATE TABLE IF NOT EXISTS `areaslevels` (
  `idAreaLevel` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `price` bigint(19) UNSIGNED NOT NULL DEFAULT '1000000',
  PRIMARY KEY (`idAreaLevel`),
  UNIQUE KEY `idAreaLevel_UNIQUE` (`idAreaLevel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areaslevels` (`idAreaLevel`, `price`) VALUES
(1, 250000),
(2, 500000),
(3, 750000),
(4, 1000000);

DROP TABLE IF EXISTS `areasmonsters`;
CREATE TABLE IF NOT EXISTS `areasmonsters` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idMonstreGroupe` int(10) UNSIGNED NOT NULL,
  `idMonstre` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`,`idMonstreGroupe`,`idMonstre`),
  KEY `fk_AreasMonsters_MonstresGroupes1_idx` (`idMonstreGroupe`,`idMonstre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areasmonsters` (`idArea`, `idMonstreGroupe`, `idMonstre`) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(1, 4, 4),
(1, 5, 5),
(2, 6, 6),
(2, 7, 7),
(2, 8, 8),
(2, 9, 9),
(2, 10, 10),
(2, 11, 11),
(2, 12, 12),
(3, 13, 13),
(3, 14, 14),
(3, 15, 15),
(3, 16, 16),
(3, 17, 17),
(3, 18, 18),
(3, 19, 19),
(3, 20, 20),
(4, 21, 21),
(4, 22, 22),
(4, 23, 23),
(4, 24, 24),
(4, 25, 25),
(4, 26, 26),
(4, 27, 27),
(4, 28, 28),
(7, 29, 29),
(7, 29, 30),
(9, 30, 31),
(19, 30, 31),
(20, 30, 31),
(9, 31, 32),
(9, 32, 35),
(10, 33, 36),
(10, 34, 37),
(12, 35, 38),
(12, 36, 39),
(13, 37, 40),
(13, 38, 41),
(13, 39, 42),
(11, 40, 43),
(11, 40, 44),
(17, 41, 45),
(17, 42, 46),
(17, 43, 47),
(18, 43, 47),
(17, 44, 48),
(18, 45, 49),
(18, 46, 50),
(18, 47, 51),
(19, 48, 52),
(20, 49, 53),
(19, 50, 33),
(20, 50, 33),
(19, 51, 34),
(20, 52, 54),
(21, 53, 54),
(21, 53, 55),
(23, 54, 56),
(23, 55, 57),
(25, 55, 57),
(23, 56, 58),
(25, 56, 58),
(23, 57, 59),
(24, 58, 60),
(24, 59, 61),
(25, 59, 61),
(24, 60, 62),
(24, 61, 63),
(25, 62, 64),
(26, 63, 65),
(26, 64, 66),
(26, 65, 67),
(26, 66, 68),
(27, 67, 62),
(27, 67, 69),
(27, 67, 70),
(28, 68, 71),
(32, 68, 71),
(28, 69, 72),
(31, 69, 72),
(28, 70, 73),
(32, 70, 73),
(28, 71, 74),
(32, 71, 74),
(30, 72, 75),
(31, 72, 75),
(30, 73, 76),
(32, 73, 76),
(30, 74, 77),
(31, 74, 77),
(30, 75, 78),
(31, 76, 79),
(33, 77, 80),
(33, 77, 81);

DROP TABLE IF EXISTS `areasmonsterslevels`;
CREATE TABLE IF NOT EXISTS `areasmonsterslevels` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `minLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `maxLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areasmonsterslevels` (`idArea`, `minLevel`, `maxLevel`) VALUES
(1, 1, 5),
(2, 5, 10),
(3, 10, 15),
(4, 15, 20),
(5, 20, 20),
(6, 1, 1),
(7, 20, 20),
(8, 20, 20),
(9, 20, 25),
(10, 25, 30),
(11, 40, 40),
(12, 30, 35),
(13, 35, 40),
(14, 40, 40),
(15, 40, 40),
(16, 60, 60),
(17, 40, 45),
(18, 45, 50),
(19, 55, 60),
(20, 50, 55),
(21, 60, 60),
(22, 80, 80),
(23, 60, 65),
(24, 65, 70),
(25, 70, 75),
(26, 75, 80),
(27, 80, 80),
(28, 80, 85),
(29, 90, 90),
(30, 85, 90),
(31, 90, 95),
(32, 95, 100),
(33, 100, 100),
(34, 100, 100);

DROP TABLE IF EXISTS `areasowners`;
CREATE TABLE IF NOT EXISTS `areasowners` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idGuild` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`,`idGuild`),
  KEY `fk_AreasOwners_Guilds1_idx` (`idGuild`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `areaspaths`;
CREATE TABLE IF NOT EXISTS `areaspaths` (
  `idArea1` int(10) UNSIGNED NOT NULL,
  `idArea2` int(10) UNSIGNED NOT NULL,
  `time` int(10) UNSIGNED NOT NULL DEFAULT '120',
  `goldPrice` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idArea1`,`idArea2`),
  KEY `fk_AreasPaths_Areas2_idx` (`idArea2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areaspaths` (`idArea1`, `idArea2`, `time`, `goldPrice`) VALUES
(1, 2, 45, 0),
(1, 3, 45, 0),
(1, 6, 30, 0),
(2, 1, 45, 0),
(2, 5, 60, 0),
(3, 1, 45, 0),
(3, 4, 45, 0),
(4, 3, 45, 0),
(4, 5, 60, 0),
(4, 7, 30, 0),
(5, 2, 60, 0),
(5, 4, 60, 0),
(6, 1, 30, 0),
(6, 8, 300, 500),
(7, 4, 30, 0),
(8, 6, 300, 0),
(8, 9, 60, 0),
(9, 8, 60, 0),
(9, 10, 40, 0),
(9, 12, 40, 0),
(9, 13, 60, 0),
(10, 9, 40, 0),
(10, 11, 30, 0),
(10, 22, 420, 0),
(11, 10, 30, 0),
(12, 9, 40, 0),
(13, 9, 60, 0),
(13, 14, 30, 0),
(14, 13, 30, 0),
(14, 15, 420, 0),
(14, 20, 380, 0),
(15, 14, 420, 0),
(15, 16, 90, 0),
(15, 17, 30, 0),
(16, 15, 90, 0),
(16, 17, 60, 0),
(17, 15, 30, 0),
(17, 16, 60, 0),
(17, 18, 40, 0),
(17, 19, 30, 0),
(17, 20, 80, 0),
(18, 17, 40, 0),
(19, 17, 30, 0),
(19, 20, 60, 0),
(20, 14, 380, 0),
(20, 17, 80, 0),
(20, 19, 60, 0),
(20, 21, 20, 0),
(21, 20, 20, 0),
(22, 10, 420, 0),
(22, 23, 90, 0),
(22, 25, 30, 0),
(22, 27, 30, 0),
(22, 28, 600, 0),
(23, 22, 90, 0),
(23, 24, 30, 0),
(24, 23, 30, 0),
(25, 22, 30, 0),
(25, 26, 30, 0),
(26, 25, 30, 0),
(27, 22, 30, 0),
(28, 22, 600, 0),
(28, 29, 80, 0),
(28, 31, 100, 0),
(29, 28, 80, 0),
(29, 30, 70, 0),
(29, 33, 120, 0),
(30, 29, 70, 0),
(31, 28, 100, 0),
(31, 32, 60, 0),
(31, 34, 350, 0),
(32, 31, 60, 0),
(33, 29, 120, 0),
(34, 31, 350, 0);

DROP TABLE IF EXISTS `areasregions`;
CREATE TABLE IF NOT EXISTS `areasregions` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idRegion` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`),
  KEY `fk_AreasRegions_Regions1_idx` (`idRegion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areasregions` (`idArea`, `idRegion`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 3),
(16, 3),
(17, 3),
(18, 3),
(19, 3),
(20, 3),
(21, 3),
(22, 4),
(23, 4),
(24, 4),
(25, 4),
(26, 4),
(27, 4),
(28, 5),
(29, 5),
(30, 5),
(31, 5),
(32, 5),
(33, 5),
(34, 5);

DROP TABLE IF EXISTS `areasrequirements`;
CREATE TABLE IF NOT EXISTS `areasrequirements` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idAchievement` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`,`idAchievement`),
  KEY `fk_AreasRequirements_Achievement1_idx` (`idAchievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areasrequirements` (`idArea`, `idAchievement`) VALUES
(34, 2);

DROP TABLE IF EXISTS `areasresources`;
CREATE TABLE IF NOT EXISTS `areasresources` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`,`idBaseItem`),
  KEY `fk_AreasResources_ItemsBase1_idx` (`idBaseItem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areasresources` (`idArea`, `idBaseItem`) VALUES
(2, 21),
(9, 21),
(12, 21),
(13, 21),
(17, 21),
(18, 21),
(20, 21),
(23, 21),
(24, 21),
(26, 21),
(28, 21),
(2, 22),
(10, 22),
(12, 22),
(17, 22),
(23, 22),
(24, 22),
(28, 22),
(2, 23),
(3, 23),
(10, 23),
(12, 23),
(17, 23),
(23, 23),
(24, 23),
(28, 23),
(30, 23),
(3, 24),
(10, 24),
(18, 24),
(23, 24),
(24, 24),
(28, 24),
(30, 24),
(31, 24),
(32, 24),
(3, 25),
(10, 25),
(18, 25),
(23, 25),
(24, 25),
(28, 25),
(30, 25),
(31, 25),
(32, 25),
(1, 26),
(9, 26),
(12, 26),
(20, 26),
(26, 26),
(1, 27),
(9, 27),
(26, 27),
(31, 27),
(1, 28),
(2, 28),
(9, 28),
(10, 28),
(13, 28),
(17, 28),
(18, 28),
(19, 28),
(20, 28),
(23, 28),
(24, 28),
(25, 28),
(26, 28),
(28, 28),
(30, 28),
(31, 28),
(32, 28),
(2, 29),
(3, 29),
(4, 29),
(13, 29),
(23, 29),
(24, 29),
(4, 30),
(13, 30),
(26, 30),
(31, 30),
(1, 31),
(9, 31),
(12, 31),
(13, 31),
(19, 31),
(20, 31),
(25, 31),
(1, 32),
(13, 32),
(1, 33),
(13, 33),
(19, 33),
(20, 33),
(4, 34),
(13, 34),
(25, 34),
(4, 35),
(13, 35),
(25, 35);

DROP TABLE IF EXISTS `areasshops`;
CREATE TABLE IF NOT EXISTS `areasshops` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idShop` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`,`idShop`),
  KEY `fk_AreasShops_Shop1_idx` (`idShop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areasshops` (`idArea`, `idShop`) VALUES
(6, 1),
(5, 2),
(8, 3),
(14, 4),
(15, 5),
(16, 6),
(22, 7),
(29, 8),
(34, 9);

DROP TABLE IF EXISTS `areastypes`;
CREATE TABLE IF NOT EXISTS `areastypes` (
  `idAreaType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `NomAreaType` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idAreaType`),
  UNIQUE KEY `idAreaType_UNIQUE` (`idAreaType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `areastypes` (`idAreaType`, `NomAreaType`) VALUES
(1, 'wild'),
(2, 'city'),
(3, 'dungeon');

DROP TABLE IF EXISTS `bonustypes`;
CREATE TABLE IF NOT EXISTS `bonustypes` (
  `idBonusTypes` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idBonusTypes`),
  UNIQUE KEY `idbonusTypes_UNIQUE` (`idBonusTypes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `bonustypes` (`idBonusTypes`, `nom`) VALUES
(1, 'xp_fight'),
(2, 'xp_collect'),
(3, 'xp_craft'),
(4, 'gold_drop'),
(5, 'item_drop'),
(6, 'collect_drop');

DROP TABLE IF EXISTS `bosses`;
CREATE TABLE IF NOT EXISTS `bosses` (
  `idBoss` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hpBase` bigint(19) UNSIGNED NOT NULL DEFAULT '1000000',
  PRIMARY KEY (`idBoss`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `bosses` (`idBoss`, `hpBase`) VALUES
(1, 100000),
(2, 200000),
(3, 250000),
(4, 500000);

DROP TABLE IF EXISTS `bossspawninfo`;
CREATE TABLE IF NOT EXISTS `bossspawninfo` (
  `idBoss` int(10) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL,
  `spawnDate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idSpawnedBoss` int(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`idBoss`),
  KEY `fk_BossSpawnInfo_Areas1_idx` (`idArea`),
  KEY `fk_BossSpawnInfo_SpawnedBosses1_idx` (`idSpawnedBoss`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `characters`;
CREATE TABLE IF NOT EXISTS `characters` (
  `idCharacter` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `statPoints` int(10) UNSIGNED NOT NULL,
  `money` bigint(19) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`),
  UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`),
  KEY `fk_Characters_Areas1_idx` (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `charactersachievements`;
CREATE TABLE IF NOT EXISTS `charactersachievements` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idAchievement` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`,`idAchievement`),
  KEY `fk_CharactersAchievements_Achievement1_idx` (`idAchievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `charactersattacks`;
CREATE TABLE IF NOT EXISTS `charactersattacks` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idSpawnedBoss` int(10) UNSIGNED NOT NULL,
  `damage` bigint(19) UNSIGNED NOT NULL DEFAULT '0',
  `attackCount` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idCharacter`,`idSpawnedBoss`),
  KEY `fk_CharactersAttacks_SpawnedBosses1_idx` (`idSpawnedBoss`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `characterscraftlevel`;
CREATE TABLE IF NOT EXISTS `characterscraftlevel` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `actualLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `actualExp` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idCharacter`),
  KEY `fk_CharactersCraftLevel_LevelsRequire1_idx` (`actualLevel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `charactersequipements`;
CREATE TABLE IF NOT EXISTS `charactersequipements` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idItem` int(10) UNSIGNED NOT NULL,
  `idType` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`,`idItem`,`idType`),
  UNIQUE KEY `idItem_UNIQUE` (`idItem`),
  KEY `fk_CharactersEquipements_Items1_idx` (`idItem`),
  KEY `fk_CharactersEquipements_ItemsTypes1_idx` (`idType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `charactershonor`;
CREATE TABLE IF NOT EXISTS `charactershonor` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `Honor` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `charactersinventory`;
CREATE TABLE IF NOT EXISTS `charactersinventory` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idItem` int(10) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`idCharacter`,`idItem`),
  UNIQUE KEY `idItem_UNIQUE` (`idItem`),
  KEY `fk_CharactersInventory_Items1_idx` (`idItem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `charactersstatistics`;
CREATE TABLE IF NOT EXISTS `charactersstatistics` (
  `idStatisticBase` int(10) UNSIGNED NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `value` bigint(19) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idStatisticBase`,`idCharacter`),
  KEY `fk_CharactersStatistics_Characters1_idx` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `commandslogs`;
CREATE TABLE IF NOT EXISTS `commandslogs` (
  `idCommandsLogs` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `idUser` varchar(21) COLLATE utf8mb4_unicode_ci NOT NULL,
  `command` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `timestamp` bigint(19) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idCommandsLogs`,`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `conquesttournamentinfo`;
CREATE TABLE IF NOT EXISTS `conquesttournamentinfo` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `actualRound` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `started` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `nextTournament` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `conquesttournamentinscriptions`;
CREATE TABLE IF NOT EXISTS `conquesttournamentinscriptions` (
  `idGuild` int(10) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idGuild`),
  UNIQUE KEY `idGuild_UNIQUE` (`idGuild`),
  KEY `fk_AreaConquestTournament_Guilds1_idx` (`idGuild`),
  KEY `fk_ConquestTournamentIncriptions_Areas1_idx` (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `conquesttournamentrounds`;
CREATE TABLE IF NOT EXISTS `conquesttournamentrounds` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idRound` int(10) UNSIGNED NOT NULL,
  `idGuild_1` int(10) UNSIGNED NOT NULL,
  `idGuild_2` int(10) UNSIGNED DEFAULT NULL,
  `winner` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idArea`,`idRound`,`idGuild_1`),
  KEY `fk_ConquestTournamentRounds_ConquestTournamentInscriptions1_idx` (`idGuild_1`),
  KEY `fk_ConquestTournamentRounds_ConquestTournamentInscriptions2_idx` (`idGuild_2`),
  KEY `fk_ConquestTournamentRounds_Areas1_idx` (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `craftbuilding`;
CREATE TABLE IF NOT EXISTS `craftbuilding` (
  `idCraftBuilding` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `idArea` int(10) UNSIGNED NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  `rarityMin` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `rarityMax` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `minLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `maxLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`idCraftBuilding`),
  UNIQUE KEY `idCraftBuilding_UNIQUE` (`idCraftBuilding`),
  UNIQUE KEY `idArea_UNIQUE` (`idArea`),
  KEY `fk_CraftBuilding_Areas1_idx` (`idArea`),
  KEY `fk_CraftBuilding_ItemsRarities1_idx` (`rarityMax`),
  KEY `fk_CraftBuilding_LevelsRequire1_idx` (`minLevel`),
  KEY `fk_CraftBuilding_LevelsRequire2_idx` (`maxLevel`),
  KEY `fk_CraftBuilding_ItemsRarities2_idx` (`rarityMin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `craftbuilding` (`idCraftBuilding`, `idArea`, `active`, `rarityMin`, `rarityMax`, `minLevel`, `maxLevel`) VALUES
(1, 5, 1, 1, 5, 11, 20),
(2, 6, 1, 1, 5, 1, 10),
(3, 8, 1, 3, 5, 21, 30),
(4, 14, 1, 3, 5, 31, 40),
(5, 15, 1, 3, 5, 41, 50),
(6, 16, 1, 3, 5, 51, 60),
(7, 22, 1, 3, 5, 61, 80),
(8, 29, 1, 3, 5, 81, 100),
(9, 34, 1, 6, 6, 100, 100);

DROP TABLE IF EXISTS `craftitem`;
CREATE TABLE IF NOT EXISTS `craftitem` (
  `idCraftItem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `maxLevel` int(10) UNSIGNED NOT NULL,
  `minLevel` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idCraftItem`),
  KEY `fk_CraftItem_LevelsRequire1_idx` (`maxLevel`),
  KEY `fk_CraftItem_LevelsRequire2_idx` (`minLevel`),
  KEY `fk_CraftItem_ItemsBase1_idx` (`idBaseItem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `craftitem` (`idCraftItem`, `maxLevel`, `minLevel`, `idBaseItem`) VALUES
(1, 100, 1, 1),
(2, 100, 1, 2),
(3, 100, 1, 3),
(4, 100, 1, 4),
(5, 100, 1, 5),
(6, 100, 1, 6),
(7, 100, 1, 7),
(8, 100, 1, 8),
(9, 100, 1, 9),
(10, 100, 1, 10),
(11, 100, 1, 11),
(12, 100, 1, 12),
(13, 100, 1, 13),
(14, 100, 1, 14),
(15, 100, 1, 15),
(16, 100, 1, 16),
(17, 100, 1, 17),
(18, 100, 1, 18),
(19, 100, 1, 19),
(20, 100, 1, 20),
(21, 100, 100, 45),
(22, 100, 100, 46),
(23, 100, 100, 47),
(24, 100, 100, 48);

DROP TABLE IF EXISTS `craftitemsneeded`;
CREATE TABLE IF NOT EXISTS `craftitemsneeded` (
  `IdCraftItem` int(10) UNSIGNED NOT NULL,
  `NeededItem` int(10) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`IdCraftItem`,`NeededItem`),
  KEY `fk_CraftItemsNeeded_CraftItem1_idx` (`IdCraftItem`),
  KEY `fk_CraftItemsNeeded_ItemsBase1` (`NeededItem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `craftitemsneeded` (`IdCraftItem`, `NeededItem`, `number`) VALUES
(1, 31, 1),
(2, 22, 1),
(2, 31, 1),
(3, 23, 1),
(4, 23, 1),
(4, 24, 1),
(4, 33, 1),
(5, 22, 2),
(5, 23, 2),
(5, 24, 1),
(5, 25, 2),
(5, 26, 2),
(5, 31, 1),
(6, 31, 1),
(7, 22, 1),
(7, 26, 1),
(8, 23, 1),
(9, 23, 2),
(9, 24, 1),
(10, 22, 2),
(10, 23, 2),
(10, 24, 1),
(10, 25, 2),
(10, 26, 3),
(11, 31, 1),
(12, 22, 1),
(12, 26, 1),
(13, 23, 1),
(14, 23, 2),
(14, 24, 1),
(15, 22, 2),
(15, 23, 2),
(15, 24, 1),
(15, 25, 2),
(15, 26, 3),
(16, 31, 1),
(17, 22, 1),
(17, 26, 1),
(18, 23, 1),
(19, 23, 2),
(19, 24, 1),
(20, 22, 2),
(20, 23, 2),
(20, 24, 1),
(20, 25, 2),
(20, 26, 3),
(21, 25, 6),
(21, 30, 6),
(21, 35, 6),
(21, 49, 800),
(22, 25, 15),
(22, 49, 1200),
(23, 30, 15),
(23, 49, 1000),
(24, 35, 15),
(24, 49, 1000);

DROP TABLE IF EXISTS `guilds`;
CREATE TABLE IF NOT EXISTS `guilds` (
  `idGuild` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `argent` bigint(19) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idGuild`),
  UNIQUE KEY `idGuild_UNIQUE` (`idGuild`),
  UNIQUE KEY `nom_UNIQUE` (`nom`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `guildsappliances`;
CREATE TABLE IF NOT EXISTS `guildsappliances` (
  `idGuild` int(10) UNSIGNED NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idGuild`,`idCharacter`),
  KEY `fk_table1_Characters1_idx` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `guildsmembers`;
CREATE TABLE IF NOT EXISTS `guildsmembers` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idGuild` int(10) UNSIGNED NOT NULL,
  `idGuildRank` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`,`idGuild`),
  KEY `fk_GuildsMembers_Guilds1_idx` (`idGuild`),
  KEY `fk_GuildsMembers_GuildsRanks1_idx` (`idGuildRank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `guildsranks`;
CREATE TABLE IF NOT EXISTS `guildsranks` (
  `idGuildRank` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idGuildRank`),
  UNIQUE KEY `idGuildRank_UNIQUE` (`idGuildRank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `guildsranks` (`idGuildRank`, `nom`) VALUES
(1, 'member'),
(2, 'officer'),
(3, 'guild_master');

DROP TABLE IF EXISTS `items`;
CREATE TABLE IF NOT EXISTS `items` (
  `idItem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `level` int(10) UNSIGNED NOT NULL,
  `favorite` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idItem`),
  UNIQUE KEY `idItems_UNIQUE` (`idItem`),
  KEY `fk_Items_ItemsBase1_idx` (`idBaseItem`),
  KEY `fk_Items_LevelsRequire1_idx` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `itemsbase`;
CREATE TABLE IF NOT EXISTS `itemsbase` (
  `idBaseItem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `idType` int(10) UNSIGNED NOT NULL,
  `idRarity` int(10) UNSIGNED NOT NULL,
  `imageItem` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `idSousType` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idBaseItem`),
  UNIQUE KEY `idItem_UNIQUE` (`idBaseItem`),
  KEY `fk_Items_ItemsTypes1_idx` (`idType`),
  KEY `fk_ItemsBase_ItemsRarities1_idx` (`idRarity`),
  KEY `fk_ItemsBase_ItemsSousTypes1_idx` (`idSousType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `itemsbase` (`idBaseItem`, `idType`, `idRarity`, `imageItem`, `idSousType`) VALUES
(1, 1, 1, 'unknown', 4),
(2, 1, 2, 'unknown', 4),
(3, 1, 3, 'unknown', 4),
(4, 1, 4, 'unknown', 4),
(5, 1, 5, 'unknown', 4),
(6, 2, 1, 'unknown', 6),
(7, 2, 2, 'unknown', 6),
(8, 2, 3, 'unknown', 6),
(9, 2, 4, 'unknown', 6),
(10, 2, 5, 'unknown', 6),
(11, 3, 1, 'unknown', 6),
(12, 3, 2, 'unknown', 6),
(13, 3, 3, 'unknown', 6),
(14, 3, 4, 'unknown', 6),
(15, 3, 5, 'unknown', 6),
(16, 4, 1, 'unknown', 6),
(17, 4, 2, 'unknown', 6),
(18, 4, 3, 'unknown', 6),
(19, 4, 4, 'unknown', 6),
(20, 4, 5, 'unknown', 6),
(21, 5, 1, 'unknown', 1),
(22, 5, 2, 'unknown', 1),
(23, 5, 3, 'unknown', 1),
(24, 5, 4, 'unknown', 1),
(25, 5, 5, 'unknown', 1),
(26, 5, 1, 'unknown', 2),
(27, 5, 2, 'unknown', 2),
(28, 5, 3, 'unknown', 2),
(29, 5, 4, 'unknown', 2),
(30, 5, 5, 'unknown', 2),
(31, 5, 1, 'unknown', 3),
(32, 5, 2, 'unknown', 3),
(33, 5, 3, 'unknown', 3),
(34, 5, 4, 'unknown', 3),
(35, 5, 5, 'unknown', 3),
(36, 8, 1, 'unknown', 11),
(37, 8, 2, 'unknown', 11),
(38, 8, 3, 'unknown', 11),
(39, 8, 4, 'unknown', 11),
(40, 8, 5, 'unknown', 11),
(41, 6, 1, 'unknown', 9),
(42, 7, 5, 'unknown', 10),
(43, 7, 4, 'unknown', 12),
(44, 7, 5, 'unknown', 12),
(45, 1, 6, 'unknown', 4),
(46, 2, 6, 'unknonw', 6),
(47, 3, 6, 'unknonw', 6),
(48, 4, 6, 'unknonw', 6),
(49, 5, 6, 'unknown', 13),
(50, 6, 1, 'unknown', 14),
(51, 6, 2, 'unknown', 14),
(52, 6, 3, 'unknown', 14),
(53, 6, 4, 'unknown', 14),
(54, 6, 5, 'unknown', 14),
(55, 6, 6, 'unknown', 14),
(56, 8, 5, 'unknown', 11);

DROP TABLE IF EXISTS `itemspower`;
CREATE TABLE IF NOT EXISTS `itemspower` (
  `idItem` int(10) UNSIGNED NOT NULL,
  `power` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idItem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `itemsrarities`;
CREATE TABLE IF NOT EXISTS `itemsrarities` (
  `idRarity` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nomRarity` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `couleurRarity` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idRarity`),
  UNIQUE KEY `idItemRaritie_UNIQUE` (`idRarity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `itemsrarities` (`idRarity`, `nomRarity`, `couleurRarity`) VALUES
(1, 'common', '#FFFFFF'),
(2, 'rare', '#00FF00'),
(3, 'superior', '#0000FF'),
(4, 'epic', '#FF00FF'),
(5, 'legendary', '#C80000'),
(6, 'mythic', '#FFA500');

DROP TABLE IF EXISTS `itemssoustypes`;
CREATE TABLE IF NOT EXISTS `itemssoustypes` (
  `idSousType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nomSousType` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idSousType`),
  UNIQUE KEY `idSousType_UNIQUE` (`idSousType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `itemssoustypes` (`idSousType`, `nomSousType`) VALUES
(1, 'ore'),
(2, 'plant'),
(3, 'wood'),
(4, 'sword'),
(5, 'whip'),
(6, 'armor'),
(7, 'loot_box_equipment'),
(8, 'loot_box_equipment'),
(9, 'reset_time_potion'),
(10, 'founder_box'),
(11, 'horse'),
(12, 'random_loot_box_equipment'),
(13, 'crystal'),
(14, 'energy_potion');

DROP TABLE IF EXISTS `itemsstats`;
CREATE TABLE IF NOT EXISTS `itemsstats` (
  `idItem` int(10) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `value` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idItem`,`idStat`),
  KEY `fk_ItemsStats_Stats1_idx` (`idStat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `itemstypes`;
CREATE TABLE IF NOT EXISTS `itemstypes` (
  `idType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nomType` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `equipable` tinyint(4) NOT NULL DEFAULT '1',
  `stackable` tinyint(4) NOT NULL DEFAULT '0',
  `usable` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idType`),
  UNIQUE KEY `idType_UNIQUE` (`idType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `itemstypes` (`idType`, `nomType`, `equipable`, `stackable`, `usable`) VALUES
(1, 'weapon', 1, 0, 0),
(2, 'chest', 1, 0, 0),
(3, 'legs', 1, 0, 0),
(4, 'head', 1, 0, 0),
(5, 'resource', 0, 1, 0),
(6, 'potion', 0, 1, 1),
(7, 'lootbox', 0, 1, 1),
(8, 'mount', 1, 0, 0);

DROP TABLE IF EXISTS `languages`;
CREATE TABLE IF NOT EXISTS `languages` (
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  PRIMARY KEY (`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `languages` (`lang`) VALUES
('en'),
('es'),
('fr'),
('pt-BR'),
('ru');

DROP TABLE IF EXISTS `levels`;
CREATE TABLE IF NOT EXISTS `levels` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `actualExp` int(10) UNSIGNED NOT NULL,
  `actualLevel` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`),
  UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`),
  KEY `fk_Levels_LevelsRequire1_idx` (`actualLevel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `levelsrequire`;
CREATE TABLE IF NOT EXISTS `levelsrequire` (
  `level` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `expNextLevel` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`level`),
  UNIQUE KEY `level_UNIQUE` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `levelsrequire` (`level`, `expNextLevel`) VALUES
(1, 2),
(2, 16),
(3, 54),
(4, 128),
(5, 250),
(6, 432),
(7, 686),
(8, 1024),
(9, 1458),
(10, 2000),
(11, 2662),
(12, 3456),
(13, 4394),
(14, 5488),
(15, 6750),
(16, 8192),
(17, 9826),
(18, 11664),
(19, 13718),
(20, 16000),
(21, 18522),
(22, 21296),
(23, 24334),
(24, 27648),
(25, 31250),
(26, 35152),
(27, 39366),
(28, 43904),
(29, 48778),
(30, 54000),
(31, 59582),
(32, 65536),
(33, 71874),
(34, 78608),
(35, 85750),
(36, 93312),
(37, 101306),
(38, 109744),
(39, 118638),
(40, 128000),
(41, 137842),
(42, 148176),
(43, 159014),
(44, 170368),
(45, 182250),
(46, 194672),
(47, 207646),
(48, 221184),
(49, 235298),
(50, 250000),
(51, 265302),
(52, 281216),
(53, 297754),
(54, 314928),
(55, 332750),
(56, 351232),
(57, 370386),
(58, 390224),
(59, 410758),
(60, 432000),
(61, 453962),
(62, 476656),
(63, 500094),
(64, 524288),
(65, 549250),
(66, 574992),
(67, 601526),
(68, 628864),
(69, 657018),
(70, 686000),
(71, 715822),
(72, 746496),
(73, 778034),
(74, 810448),
(75, 843750),
(76, 877952),
(77, 913066),
(78, 949104),
(79, 986078),
(80, 1024000),
(81, 1062882),
(82, 1102736),
(83, 1143574),
(84, 1185408),
(85, 1228250),
(86, 1272112),
(87, 1317006),
(88, 1362944),
(89, 1409938),
(90, 1458000),
(91, 1507142),
(92, 1557376),
(93, 1608714),
(94, 1661168),
(95, 1714750),
(96, 1769472),
(97, 1825346),
(98, 1882384),
(99, 1940598),
(100, 2000000);

DROP TABLE IF EXISTS `localizationachievements`;
CREATE TABLE IF NOT EXISTS `localizationachievements` (
  `idAchievement` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameAchievement` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descAchievement` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`idAchievement`,`lang`),
  KEY `fk_LocalizationAchievements_Languages1_idx` (`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `localizationachievements` (`idAchievement`, `lang`, `nameAchievement`, `descAchievement`) VALUES
(1, 'en', 'Founder', 'Available only to players who were there during the beta phase of the game.'),
(1, 'es', 'Fundador', 'Disponible sólo para los jugadores que estuvieron en la fase beta del juego.'),
(1, 'fr', 'Fondateur', 'Disponible uniquement aux joueurs qui étaient là lors de la phase beta du jeu.'),
(1, 'pt-BR', 'Fundador', 'Disponível apenas para jogadores que estavam lá durante a fase beta do jogo.'),
(1, 'ru', 'Основатель', 'Доступен только для игроков, которые были там во время бета-фазе игры.'),
(2, 'en', 'One last challenge', 'Fight the Boss inside the dungeon level 100 and win the battle to unlock access to the Antique Dwarf Forge!'),
(2, 'es', 'Un último desafío', '¡Lucha contra el jefe dentro de la mazmorra nivel 100 y gana la batalla para desbloquear el acceso a la Antigua Fragua Enana!'),
(2, 'fr', 'Un Dernier Défi', 'Combattez le Boss du Donjon niveau 100 et gagnez le combat pour débloquer l\'accès à la forge antique naine !'),
(2, 'pt-BR', 'Um último desafio', 'Lute com o Chefe dentro da masmorra nível 100 e vença a batalha para liberar o acesso à Antiga Forja Anã!'),
(2, 'ru', 'Последний вызов', 'Борьба с боссом внутри подземелья уровня 100 и выиграть битву, чтобы открыть доступ к Антикварной кузнице гномов!');

DROP TABLE IF EXISTS `localizationareas`;
CREATE TABLE IF NOT EXISTS `localizationareas` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameArea` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descArea` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`idArea`,`lang`),
  KEY `fk_LocalizationAreas_Languages1_idx` (`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `localizationareas` (`idArea`, `lang`, `nameArea`, `descArea`) VALUES
(1, 'en', 'Buldaar Forest', 'This forest welcomes a large number of beginners wishing to go on an adventure, unfortunately for them, the adventure is not easy, even here.'),
(1, 'es', 'Bosque Buldaar', 'Este bosque le da la bienvenida a un gran número de principiantes que desean emprender una aventura, desafortunadamente para ellos, la aventura no es fácil, incluso aquí.'),
(1, 'fr', 'Forêt de Buldaar', 'Cette forêt accueille un très grand nombre de débutants souhaitant partir à l\'aventure, malheureusement pour eux, l\'aventure n\'est pas de tout repos, même ici.'),
(1, 'pt-BR', 'Floresta Buldaar', 'Essa floresta dá boas-vindas à um grande número de iniciantes que desejam sair em uma aventura, mas pro azar deles, a aventura não é nada fácil, nem mesmo aqui.'),
(1, 'ru', 'Булдарский Лес', 'Этот лес приветствует большое количество новичков, желающих отправиться в приключение, к сожалению для них, приключение не из легких, даже здесь.'),
(2, 'en', 'Rocky Plains', 'This plain is filled with magic. Golems are born from this magic and since then they wander here.'),
(2, 'es', 'Llanuras Rocosas', 'Esta llanura esta llena de magia. Los golems nacieron de esta magia y desde entonces deambulan por aquí.	'),
(2, 'fr', 'Plaines Rocheuses', 'Cette plaine est remplie de magie, des Golems sont nés de cette magie et depuis ils errent ici.'),
(2, 'pt-BR', 'Planícies Rochosas', 'Essa planície é cheia de magia. Golens nascem dessa magia e então vagam por aqui.'),
(2, 'ru', 'Скалистые Равнины', 'Эта равнина наполнена магией. Големы рождаются из этой магии и с тех пор бродят здесь.'),
(3, 'en', 'Lirayl Dead End', 'Once this dead end buzzed with life, but for years an evil corrupted the place and destroyed everything in its path.'),
(3, 'fr', 'Impasse de Lirayl', 'Autrefois cette impasse bourdonnait de vie, mais depuis des années un mal ronge la terre et détruit tout sur son passage.'),
(3, 'pt-BR', 'Lirayl, O Fim da Linha', 'Este lugar sem saída já zuniu com vida, mas por anos um mal corrompeu-o e destruiu tudo em seu caminho.'),
(3, 'ru', 'Буквальный Тупик', 'Когда-то этот тупик гудел жизнью, но годами зло разлагало место и разрушало все на своем пути.'),
(4, 'en', 'Baanar Jungle', 'It\'s a jungle!'),
(4, 'es', 'Selva Baanar', 'Es una selva!'),
(4, 'fr', 'Jungle de Baanar', 'C\'est une jungle ! '),
(4, 'pt-BR', 'Selva Baanar', 'É uma selva!'),
(4, 'ru', 'Банановые Джунгли', 'Это настоящие джунгли!'),
(5, 'en', 'Bradford', 'Bradford is a very interesting location, and serves as a rest camp for many adventurers.'),
(5, 'es', 'Bradford', 'Bradford es un lugar muy interesante, y sirve como campamento de descanso de muchos aventureros.'),
(5, 'fr', 'Bradford', 'Bradford est un emplacement très intéressant, et sert de camp de repos à bon nombre d\'aventuriers.'),
(5, 'pt-BR', 'Bradford', 'Bradford é um lugar muito interessante, e serve como acampamento de descanso para muitos aventureiros.'),
(5, 'ru', 'Брэдфорд', 'Брэдфорд - очень интересное место и служит лагерем отдыха для многих искателей приключений.'),
(6, 'en', 'Fishford', 'A fishing village, but this one is just waiting to be extended.'),
(6, 'es', 'Fishford', 'Un pueblo de pescadores, pero este está esperando ser ampliado.'),
(6, 'fr', 'Fishford', 'Un village de pêcheur, mais celui-ci n\'attends qu\'à être étendu.'),
(6, 'pt-BR', 'Fishford', 'Uma vila de pesca, mas esta aqui está só esperando ser estendida.'),
(6, 'ru', 'Эшфорд', 'Рыбацкая деревня, она только и ждет своего расширения.'),
(7, 'en', 'Groundfire', 'It\'s hot in here, isn\'t it? Yes, it is.'),
(7, 'es', 'Tierra del fuego', 'Hace calor aquí, ¿no? Si, lo es.'),
(7, 'fr', 'Les nappes feu-à-tiques', 'Il fait chaud non ? Oui il faut chaud.'),
(7, 'pt-BR', 'Groundfire', 'É quente aqui, não é? Sim, é quente.'),
(7, 'ru', 'Низовой пожар', 'Здесь жарко, не правда ли? Да, это так.'),
(8, 'en', 'Tywardreath', 'The port city of Tywardreath is full of life. Indeed, it is the entry point to the new world. It is rich and active, thanks to its market and foreign trade. It also has fertile land, which local leaders do not hesitate to use.'),
(8, 'es', 'Tywardreath', 'La ciudad portuaria de Tywardreath está llena de vida. De hecho, es el punto de entrada al nuevo mundo. Es rico y activo, gracias a su mercado y comercio exterior. También tiene tierra fértil, que los líderes locales no dudan en usar.'),
(8, 'fr', 'Tywardreath', 'La ville portuaire de Tywardreath regorge de vie. En effet celle-ci se place comme le point d\'entrée du nouveau monde. Elle est riche et active, ceci grâce à son marché et à son commerce extérieur. Elle dispose aussi de terres fertiles, que les dirigeants locaux n\'hésitent pas à utiliser.'),
(8, 'pt-BR', 'Tywardreath', 'A cidade portuária de Tywardreath é cheia de vida. De fato, é o ponto de entrada para o novo mundo. É rica e ativa, graças à seu mercado e comércio exterior. Ela também possui terra fértil, a qual os líderes locais não hesitam em usar.'),
(8, 'ru', 'Тумирон', 'Город-порт Тумирон, так полон жизни. Действительно, это точка входа в новый мир. Она богата и активна, благодаря своему рынку и внешней торговле. Здесь также есть плодородные земли, которыми местные лидеры не стесняются пользоваться.'),
(9, 'en', 'Tywardreath Burned Forest', 'Once a lush forest, the Tywardreath Burned Forest is now a shadow of its own. During the first days of colonization, a race of orcs began to attack and try to defeat the ranks of the colonizers. But the colonizers, thanks to their powerful strike force, managed to overcome it. However, this was not to mention the unfailing motivation of the orcs, who had taken a stand in the forest.'),
(9, 'es', 'Bosque Quemado Tywardreath', 'Una vez un bosque exhuberante, el Bosque quemado Tywardreath es ahora una sombra de sí mismo. Durante los primeros días de colonización, una raza de orcos comenzó a atacar e intentar derrotar a las filas de los colonizadores. Pero los colonizadores, gracias a su poderosa fuerza de ataque, lograron superarlo. Sin embargo, esto sin mencionar la motivación inagotable de los orcos, que habían tomado una posición del bosque.'),
(9, 'fr', 'La Forêt Carbonisée de Tywardreath', 'Forêt jadis luxuriante, la Forêt Carbonisée de Tywardreath n\'est plus que l\'ombre d\'elle même. Lors des premiers jours de colonisation une race d\'orcs se mirent à attaquer et à essayer de défaire les rangs des colonisateurs. Mais les colonisateurs grâce à leur puissante force de frappe, en vinrent à bout. Cependant, c\'était sans compter la motivation sans failles des orcs, qui avaient pris position dans la forêt.'),
(9, 'pt-BR', 'Floresta Queimada de Tywardreath', 'O que já foi uma floresta exuberante, a Floresta Queimada de Tywardreath agora é uma sombra do que ja foi. Durante os primeiros dias de colonização, uma raça de orcs começou a atacar e tentar derrotar os ranks dos colonizadores. Mas os colonizadores, graças à força de ataque poderosa deles, conseguiram superar isso. Entretanto, não foram capazes de amansar a inabalável motivação dos orcs, que tomaram para si uma posição na floresta.'),
(9, 'ru', 'Тумиронский Сгоревший Лес', 'Ранее пышный лес, Тумиронский Сгоревший Лес теперь тень своего собственного. В первые дни колонизации раса орков начала атаковать и пытаться победить ряды колонизаторов. Но колонизаторам, благодаря их мощной ударной силе, удалось их преодолеть. Но это ничего не говорит о неизменной мотивации орков, которые заняли позицию в лесу.'),
(10, 'en', 'Tywardreath Hills', 'The hills in the north of Tywardreath are dotted with paths leading to the mountains. Unfortunately it is not an interesting area, it is unbuildable and full of wild animals. But it is however an obligatory passage, for those who want to venture further north, towards the caves.'),
(10, 'es', 'Colinas de Tywardreath', 'Las colinas en el norte de Tywardreath están salpicadas de caminos que conducen a las montañas. Desafortunadamente no es un area interesante, es indestructible y está llena de animales salvajes. Sin embargo, es un paso obligatorio para aquellos que desean aventurarse más al norte, hacia las cuevas.'),
(10, 'fr', 'Les Collines de Tywardreath', 'Les collines au Nord de Tywardreath sont parsemés de chemins menant aux montagnes. Malheureusement ce n\'est pas une zone intéressante, elle est inconstructible et remplie d\'animaux sauvages. Mais c\'est cependant un passage obligé, pour ceux voulant s\'aventurer plus au nord, vers les grottes.'),
(10, 'pt-BR', 'Colinas de Tywardreath', 'As colinas no norte de Tywardreath são pontilhadas com caminhos levando à montanhas. Infelizmente não é uma área interessante, é impossível construir lá e é repleta de animais selvagens. Mas é, porém, uma passagem obrigatória para aqueles que querem aventurar-se mais ao norte, em direção às cavernas.'),
(10, 'ru', 'Тумиронские Холмы', 'Холмы на севере Тумирона усеяны тропинками, ведущими в горы. К сожалению, там не интересно, они неиспользуемы и полны диких животных. Но это, однако, обязательный путь, для тех, кто хочет отправиться дальше на север, к пещерам.'),
(11, 'en', 'Tywardreath Caves', 'No one comes here, this cave is cold, humid and... Ugh, what is this!?'),
(11, 'es', 'Cuevas \nde\nTywardreath', 'Nadie viene aquí, esta cueva esta fría, húmeda y... ¿¡Ugh, que es esto!?'),
(11, 'fr', 'Grottes de Tywardreath', 'Personne ne vient ici, cette grotte est froide, humide et.. Mais qu\'est-ce que cela peut-il bien être !?'),
(11, 'pt-BR', 'Cavernas de Tywardreath', 'Ninguém vem aqui, esta caverna é fria, úmida e... Ugh, o que é isto!?'),
(11, 'ru', 'Пещеры Тумирона', 'Никто не приходит сюда, в этой пещере холодно, влажно и..... Ой, что это!?'),
(12, 'en', 'East Crater', 'Crater resulting from a meteorite fall. No one dares to venture there, it seems that the meteorite has given life to the ground and that it is likely that a monster will wander there.'),
(12, 'es', 'Cráter del Este', 'Cráter resultante de una caída de meteorito. Nadie se atreve a aventurarse allí, Parece que el meteorito le ha dado vida al suelo y es probable que un monstruo deambule allí.'),
(12, 'fr', 'Le Cratère Est', 'Cratère résultant d\'une chute de météorite. Personne n\'ose s\'y aventurer, il parait que la météorite a donnée vie au sol et qu\'il est probable qu\'un monstre s\'y ballade.'),
(12, 'pt-BR', 'Cratera Leste', 'Cratera resultante de uma queda de meteorito. Ninguém ousa aventurar-se aqui, parece que o meteorito deu vida ao chão e é provável que um monstro vagará ali.'),
(12, 'ru', 'Восточный Кратер', 'Кратер образовался в результате падения метеорита. Никто не осмеливается рисковать ходить там, кажется, что метеорит дал жизнь земле и что вполне вероятно, что монстры будут бродить там.'),
(13, 'en', 'Tywardreath Forest', 'This forest has not been destroyed by orcs, it is full of life, both in terms of fauna and flora. It is also where most adventurers go to enjoy the new world.'),
(13, 'es', 'Bosque Tywardreath', 'Este Bosque no ha sido destruido por los Orcos, Está llena de vida, tanto en términos de Flora y Fauna. También es donde la mayoría de los aventureros van a disfrutar el nuevo mundo.'),
(13, 'fr', 'La Forêt de Tywardreath', 'Cette forêt n\'a pas été détruite par les orcs, elle regorge de vie, tant au niveau de la faune que de la flore. C\'est aussi ici que vont la plupart des aventuriers pour profiter du nouveau monde.'),
(13, 'pt-BR', 'Floresta de Tywardreath', 'Esta floresta não foi destruída por orcs, é cheia de vida, tanto em termos de fauna quanto flora. Também é onde a maioria dos aventureiros vai para aproveitar o novo mundo.'),
(13, 'ru', 'Тумиронский Лес', 'Этот лес не был уничтожен орками, он полон жизни, как с точки зрения фауны, так и флоры. Это также место, куда большинство авантюристов идут, чтобы насладиться новым миром.'),
(14, 'en', 'Tywardreath Desert Outpost', 'An important outpost, the Desert Outpost, allows adventurers to prepare for the great journey to the desert.'),
(14, 'es', 'Avanzada del Desierto Tywardreath', 'Una avanzada importante, la Avanzada del desierto, permite a los aventureros prepararse para el gran viaje al desierto.'),
(14, 'fr', 'L\'avant-poste du Désert', 'Avant-poste important, l\'Avant-Poste du Desert, permet aux aventuriers de se préparer au grand voyage vers le désert.'),
(14, 'pt-BR', 'Posto Avançado do Deserto de Tywardreath', 'Um posto avançado importante, o Posto Avançado do Deserto, permite que aventureiros se preparem para a grande jornada ao deserto.'),
(14, 'ru', 'Тумиронский Пустынный Форпост', 'Важный форпост, Пустынный Форпост, позволяет авантюристам подготовиться к великому путешествию в пустыню.'),
(15, 'en', 'Sepsibenu', 'Sebsibenu is the typical desert city. It has been able to take advantage of the waterways of the Western Fountain. It is now the most important point in the region in terms of trade.'),
(15, 'es', 'Sepsibenu', 'Sebsibenu es la típica ciudad del desierto. Ha podido aprovechar las vías fluviales de la Fuente del Oeste. Ahora es el punto más importante de la región en términos de comercio.'),
(15, 'fr', 'Sepsibenu', 'Sebsibenu est la cité typique du désert. Elle a su profiter des cours d\'eaux de la Fontaine Occidentale. Elle est désormais le point le plus important de la région en terme en terme de commerce.'),
(15, 'pt-BR', 'Sepsibenu', 'Sebsibenu é a típica cidade desértica. Ela foi capaz de tirar vantagem dos canais da Fonte Oeste. É agora o ponto mais importante da região em termos de comércio.'),
(15, 'ru', 'Себсибену', 'Сепсибену типичный пустынный город. Он может воспользоваться водными путями Западного Фонтана. Сейчас это самая важная точка в регионе с точки зрения торговли.'),
(16, 'en', 'Western Fountain', 'This city is surrounded by magic, its water sources seem to be inexhaustible. At the time of colonization, this city did not exist, in fact, it was built very soon afterwards.'),
(16, 'es', 'Fuente Occidental', 'Esta ciudad está rodeada de magia, sus fuentes de agua parecen ser inagotables. En el momento de la colonización, esta ciudad no existía, de hecho, se construyó muy poco después.'),
(16, 'fr', 'La Fontaine Occidentale', 'Cette cité est entourée de magie, ses sources d\'eaux semblent être inépuisables. Lors de la colonisation, cette citée n\'existait pas, en effet, elle fût construite très peu de temps après.'),
(16, 'pt-BR', 'Fonte Oeste', 'Esta cidade é rodeada de magia, suas fontes de água parecem ser inesgotáveis. No momento da colonização, esta cidade não existia, em fato, ela foi construída muito breve após tal.'),
(16, 'ru', 'Западный Фонтан', 'Этот город окружен магией, источники воды кажутся неисчерпаемыми. Во времена колонизации этого города не существовало, фактически он был построен очень быстро.'),
(17, 'en', 'Desolated Cracked Desert', 'A piece of the desert filled with giant insects. This area only has interesting minerals. The cracks in it have already killed more than one.'),
(17, 'es', 'Desierto Agrietado Desolado', 'Un pedazo del desierto lleno de insectos gigantes. Esta área solo tiene minerales interesantes. Las grietas en él ya han matado a más de uno.'),
(17, 'fr', 'Le Désert Désolé et Craquelé', 'Un morceau du désert rempli d\'insectes géants. Cette zone n\'a d\'intéressant que ses minerais. Les crevasses qui la composent en ont déjà tué plus d\'un.'),
(17, 'pt-BR', 'Deserto Desolado Rachado', 'Uma parte do deserto cheia de insetos gigantes. Esta área tem apenas minerais interessantes. As rachaduras nela já mataram mais de um.'),
(17, 'ru', 'Опустошенная Треснувшая Пустыня', 'Кусок пустыни с гигантскими насекомыми. Эта область интересна только минералами. Трещины в ней уже убили не одного.'),
(18, 'en', 'The Fire Craters', 'Still the result of meteorites, however this part of the desert has some very interesting minerals and it seems that there is a chance of coming across Sand Golems.'),
(18, 'es', 'Cráteres de Fuego', 'Todavía son el resultado de meteoritos, sin embargo, esta parte del desierto tiene algunos minerales muy interesantes y parece que existe la posibilidad de encontrar Golems de Arena.'),
(18, 'fr', 'Les Cratères en Feu', 'Encore le résultat de météorites, cependant cette partie du désert possède des minerais très intéressants et parait-il qu\'il y aurait chances de tomber sur des Golems de Sable.'),
(18, 'pt-BR', 'As Crateras de Fogo', 'Ainda o resultado de meteoritos, porém esta parte do deserto tem alguns minerais muito interessantes e parece que há uma chance de esbarrar com Golems de Areia.'),
(18, 'ru', 'Огненные Кратеры', 'Всё это результат метеоритов, однако эта часть пустыни имеет некоторые очень интересные минералы, и кажется, что есть шанс встретить Песчаных Големов.'),
(19, 'en', 'Wutgarek Village', 'This village is surely the nerve centre of the Wutgareks. But if you\'re here, it\'s certainly not to appreciate the buildings. Be careful, however, the Wutgarek will not give you any respite.'),
(19, 'es', 'Pueblo Wutgarek', 'Este pueblo es seguramente el centro neurálgico de los Wutgareks. Pero si estás aquí, ciertamente no es para apreciar los edificios. Tenga cuidado, sin embargo, el Wutgarek no le dará ningún respiro.'),
(19, 'fr', 'Village Wutgarek', 'Ce village est sûrement le coeur névralgique des Wutgareks. Mais si vous êtes là ce n\'est sûrement pas pour apprécier les constructions. Faites cependant attention, les Wutgarek ne vous laisserons aucun répit.'),
(19, 'pt-BR', 'Vila Wutgarek', 'Esta vila é com certeza o centro nervoso dos Wutgareks. Mas se você está aqui, com certeza não é para admirar as construções. Seja cauteloso, porém, os Wutgarek não vai te dar nenhum descanso.'),
(19, 'ru', 'Деревня Футгареков', 'В этой деревне наверняка является нервным центром Футгареков. Но если вы здесь, то уж точно не для того, чтобы оценить здания. Будьте осторожны, Разумеется, Футгареки не дадут вам покоя.'),
(20, 'en', 'Acbydet', 'This ancient city is invaded by Wutgareks, insects and mummies. Apart from its graves, this place is probably the worst place in the desert.'),
(20, 'es', 'Acbydet', 'Esta antigua ciudad es invadida por Wutgareks, insectos y momias. Aparte de sus tumbas, este lugar es probablemente el peor lugar en el desierto.'),
(20, 'fr', 'Acbydet', 'Cette ancienne cité est envahie par des Wutgareks, des insectes et des momies. Mis à part ses tombes, cet endroit est un sûrement le pire endroit du désert.'),
(20, 'pt-BR', 'Acbydet', 'Esta cidade antiga está invadida pelos Wutgareks, insetos e múmias. À parte de seus túmulos, este lugar provavelmente é o pior lugar do deserto.'),
(20, 'ru', 'Acbydet', 'Этот древний город захвачен Футгареками, насекомыми и мумиями. Помимо могилы, это место, вероятно, худшее место в пустыне.'),
(21, 'en', 'The Forgotten Tombs', 'These ancient tombs are filled with a dark magic, you seem to hear in the distance, a kind of black mass. What could it be?'),
(21, 'es', 'Las Tumbas Olvidadas', 'Estas tumbas antiguas están llenas de una magia oscura, parece que escuchas a lo lejos, una especie de masa negra. ¿Qué podría ser?'),
(21, 'fr', 'Les Tombes Oubliées', 'Ces anciennes tombes sont remplies d\'une magie sombre, vous semblez entendre au loin, une sorte de messe noire. Qu\'est-ce que cela peut-il bien être ?'),
(21, 'pt-BR', 'As Tumbas Esquecidas', 'Essas tumbas anciãs estão preenchidas com uma magia negra, você parece ouvir ao longe um tipo de missa negra. O que poderia ser?'),
(21, 'ru', 'Забытые Гробницы', 'Эти древние гробницы наполнены темной магией, вы словно слышите вдалеке некую черную мессу. Что бы это могло быть?'),
(22, 'en', 'Northern Expedition Outpost', 'The northern expedition was organized shortly after the beginning of colonization, however, it began its journey to the north only very recently. Nevertheless, the progress made is impressive. An outpost is built and it has all the amenities. Now, the real problem is the demons.'),
(22, 'es', 'Avanzada de la expedición del Norte', 'La expedición del norte se organizó poco después del comienzo de la colonización, sin embargo, comenzó su viaje hacia el norte muy recientemente. Sin embargo, el progreso realizado es impresionante. Se construye un puesto avanzado y tiene todas las comodidades. Ahora, el verdadero problema son los demonios.'),
(22, 'fr', 'Avant-poste de l\'Expédition Nord', 'L\'expédition nord s\'est organisé peu de temps après le début de la colonisation, cependant elle a commencé son voyage vers le nord que très récemment. Malgré tout, les progrès accomplis sont impressionnants. Un avant poste est construit et il dispose de toutes les commodités. Maintenant, le vrai problème ce sont les démons.'),
(22, 'pt-BR', 'Posto Avançado de Expedição do Norte', 'A expedição norte foi organizada pouco depois do começo da colonização, porém, ela começou sua jornada para o norte apenas muito recentemente. Mesmo assim, o progresso feito é incrível. Um posto avançado está construído e tem todas as facilidades. Agora, o verdadeiro problema são os demônios.'),
(22, 'ru', 'Северный Экспедиционный Форпост', 'Северная экспедиция была организована вскоре после начала колонизации, однако свой путь на север она начала лишь совсем недавно. Тем не менее, достигнутый прогресс впечатляет. Построен аванпост со всеми удобствами. Настоящая проблема в демонах.'),
(23, 'en', 'The Lava Cracks', 'These lava cracks are the result of the intense volcanic activity in the region. Elementary beings are born there, go through this region will not be a pleasure.'),
(23, 'es', 'Grietas de Lava', 'Estas grietas de lava son el resultado de la intensa actividad volcánica en la región. Los seres elementales nacen allí, pasar por esta región no será un placer.'),
(23, 'fr', 'Les Fissures de Lave', 'Ces fissures de lave sont la résultante de l\'activité volcanique intense de la région. Des êtres élémentaires y naissent, traverser cette région ne sera pas une partie de plaisir.'),
(23, 'pt-BR', 'As Rachaduras de Lava', 'Essas rachaduras de lava são o resultado de uma intensa atividade vulcânica na região. Seres elementais nascem aqui, ir através dessa região não será um prazer.'),
(23, 'ru', 'Лавовые Трещины', 'Эти лавовые трещины являются результатом интенсивной вулканической активности в регионе. Элементальные существа рождаются там, прогулка через этот регион не доставит удовольствия.'),
(24, 'en', 'Explosive Volcanoes', 'These volcanoes are a concentrate of heat, ash and smoke. In addition to being filled with elementary beings, there are demons. You came here, you must regret it.'),
(24, 'es', 'Volcanes Explosivos', 'Estos volcanes son un concentrado de calor, cenizas y humo. Además de estar lleno de seres elementales, hay demonios. Viniste aquí, debes arrepentirte.'),
(24, 'fr', 'Les Volcans Explosifs', 'Ces volcans sont un concentré de chaleur, de cendres et de fumée. En plus d\'être remplis d\'êtres élémentaires, il y a des démons. Vous devez déjà regretter d\'être venu.'),
(24, 'pt-BR', 'Vulcões Explosivos', 'Esses vulcões são um concentrado de calor, cinzas e fumaça. Além de estarem cheios de seres elementais, há os demônios. Você veio aqui, e deve se arrepender.'),
(24, 'ru', 'Взрывоопасные Вулканы', 'Эти вулканы являются концентратом тепла, пепла и дыма. Помимо наполнения элементальными существами, существуют демоны. Раз вы пришли сюда, вы должны пожалеть об этом.'),
(25, 'en', 'The Lava Burnt Forest', 'Probably an old forest, now it is burned by the lava that gushes out of the ground. But this forest has something alive, you should be on your guard.'),
(25, 'es', 'El Bosque Quemado de Lava', 'Probablemente un bosque viejo, ahora es quemado por la lava que brota del suelo. Pero este bosque tiene algo vivo, deberías estar en guardia.'),
(25, 'fr', 'La Forêt Brûlée par la Lave', 'Sûrement une ancienne forêt, maintenant elle est brûlée par la lave qui jaillit du sol. Mais cette forêt a quelque chose de vivant, vous devriez vous tenir sur vos gardes.'),
(25, 'pt-BR', 'A Floresta Queimada por Lava', 'Provavelmente uma floresta antiga, agora está queimada por lava que jorra do chão. Mas esta floresta tem algo vivo, você deve se manter em guarda.'),
(25, 'ru', 'Лавовый Выжженный Лес', 'Вероятно это старый лес, теперь он сожжен лавой, которая льется из земли. Но в этом лесу есть что-то живое, вы должны быть настороже.'),
(26, 'en', 'Old Dwarf City', 'Remains of an ancient dwarf city. Everything seems quiet, not a sound. As you get closer, you will notice that the city is no longer so deserted...'),
(26, 'es', 'Antigua Ciudad Enana', 'Restos de una antigua ciudad enana. Todo parece tranquilo, ni un sonido. A medida que te acerques, notarás que la ciudad ya no está tan desierta ...'),
(26, 'fr', 'Ancienne Cité Naine', 'Des vestiges d\'une ancienne cité naine. Tout semble calme, pas un bruit. En vous rapprochant de plus près vous remarquer que la ville n\'est plus si déserte que ça...'),
(26, 'pt-BR', 'Antiga Cidade Anã', 'Restos de uma antiga cidade anã. Tudo parece quieto, nem um som. Conforme você se aproximar, você perceberá que esta cidade não está mais tão abandonada...'),
(26, 'ru', 'Старый Город Гномов', 'Остатки древнего города гномов. Все кажется тихим, ни звука. По мере приближения вы заметите, что город уже не так безлюден...'),
(27, 'en', 'The Daemonic Citadel', 'The demonic citadel, the heart of the region. Filled with filth, demons and suffering. If you are here, it is surely to free the region from the yoke of the demon who is staying there.'),
(27, 'es', 'La Ciudadela Demoníaca', 'La ciudadela demoníaca, el corazón de la región. Lleno de suciedad, demonios y sufrimiento. Si estás aquí, seguramente es para liberar a la región del yugo del demonio que se queda allí.'),
(27, 'fr', 'La Citadelle Démoniaque', 'La citadelle démoniaque, coeur de la région. Remplis d\'immondices, de démons et de souffrance. Si vous êtes ici c\'est sûrement pour libérer la région du joug du démon qui y séjourne.'),
(27, 'pt-BR', 'A Cidadela Demoníaca', 'A cidadela demoníaca, o coração da região. Repleta de imundice, demônios e sofrimento. Se você está aqui, certamente é para libertar a região do jugo do demônio que está ficando aqui.'),
(27, 'ru', 'Демоническая Цитадель', 'Демоническая цитадель, сердце региона. Наполненный грязью, демонами и страданиями. Если вы здесь, то, безусловно, для того чтобы освободить регион от гнета демона, который там находится.'),
(28, 'en', 'Horth Ice Tower', 'This antique tower gives you chills and brings you a nostalgic feeling, as if thousands of battles have happened here before. You wonder what\'s waiting for you on the top of it.'),
(28, 'es', 'Torre de Hielo de Horth', 'Esta torre antigua te da escalofríos y te da una sensación de nostalgia, como si miles de batallas hubieran sucedido aquí antes. Te preguntas qué te espera encima.'),
(28, 'fr', 'Tour Glaciale de Horth', 'Cette tour antique vous donne des frissons et vous apporte un sentiment de nostalgie, comme si des milliers de batailles s\'étaient déjà déroulées ici. Vous vous demandez ce qui vous attend au sommet.'),
(28, 'pt-BR', 'Torre de Gelo de Horth', 'Esta torre antiga te dá calafrios e traz uma sensação nostálgica, como se milhares de batalhas tivessem acontecido aqui antes. Você se pergunta o que lhe espera no topo dela.'),
(28, 'ru', 'Ледниковая башня Хорта', 'Эта антикварная башня вызывает у вас озноб и ностальгическое чувство, как будто здесь уже проходили тысячи сражений. Интересно, что ждет тебя наверху.'),
(29, 'en', 'Frozen Wind Village', 'A small village that managed to survive through the intense cold of the region. You would definitely prefer a warm hotel in the Bahamas, but life goes on.'),
(29, 'es', 'Pueblo de Viento Congelado', 'Un pequeño pueblo que logró sobrevivir a través del frío intenso de la región. Definitivamente preferirías un hotel cálido en las Bahamas, pero la vida continúa.'),
(29, 'fr', 'Village du Vent Glacial', 'Un petit village qui a réussi à survivre au froid intense de la région. Vous préféreriez certainement un hôtel chaleureux aux Bahamas, mais la vie est ainsi faite.'),
(29, 'pt-BR', 'Vila do Vento Congelado', 'Uma pequena vila que conseguiu sobreviver em meio ao frio intenso da região. Você definitivamente preferiria um hotel quentinho nas Bahamas, mas a vida segue.'),
(29, 'ru', 'Деревня замороженных ветров', 'Небольшое село, которому удалось выжить в условиях сильного холода в регионе. Вы определенно предпочитаете теплый отель на Багамах, но жизнь продолжается.'),
(30, 'en', 'Cemetery of the Frozen Soul', 'Not just the cold, but you now also have to deal with undead? Great, at least now this will warm you up.'),
(30, 'es', 'Cementerio del Alma Congelada', '¿No solo el frío, sino que ahora también tienes que lidiar con los muertos vivientes? Genial, al menos ahora esto te calentará.'),
(30, 'fr', 'Cimetière de l\'âme givrée', 'Pas seulement le froid, mais aussi les morts-vivants ? Super, au moins maintenant, ça va vous réchauffer.'),
(30, 'pt-BR', 'Cemitério da Alma Congelada', 'Não bastava o frio, mas agora você também tem que lidar com mortos-vivos? Ótimo, pelo menos agora isto vai te aquecer.'),
(31, 'en', 'Great Manor of Baron Galssor', 'This labyrinthic manor was once occupied by a very powerful baron and it\'s servants. Oh, look, it even has a coffee machine! I wonder if it still works.'),
(31, 'es', 'Gran Mansión del Barón Galssor', 'Esta mansión laberíntica fue ocupada por un poderoso barón y sus sirvientes. Oh, mira, ¡incluso tiene una máquina de café! Me pregunto si aún funciona.'),
(31, 'fr', 'Grand Manoir du Baron Galssor', 'Ce manoir labyrinthique était jadis occupé par un baron très puissant et ses serviteurs. Oh, regardez, il y a même une machine à café ! Je me demande si ça marche encore.'),
(31, 'pt-BR', 'Grande Mansão do Barão Galssor', 'Esta mansão labiríntica foi um dia ocupada por um barão muito poderoso e seus serventes. Ei, olha, tem até uma máquina de café! Eu me pergunto se ainda funciona.'),
(32, 'en', 'Haunted Village of Horth', 'As the snow blows in the wind, you see terrible and distorted spectral figures wander through this village, as if they were still live people inhabiting the village. You hope to give a rest to these souls.'),
(32, 'es', 'Pueblo Embrujado de Horth', 'Mientras la nieve sopla en el viento, se ven figuras espectrales terribles y distorsionadas que deambulan por este pueblo, como si todavía fueran personas vivas que habitan el pueblo. Esperas dar un descanso a estas almas.'),
(32, 'fr', 'Village Hanté de Horth', 'Alors que la neige souffle dans le vent, vous voyez des figures spectrales terribles et déformées errer dans ce village, comme s\'il s\'agissait encore de personnes vivantes habitant le village. Vous espérez donner du repos à ces âmes.'),
(32, 'pt-BR', 'Vila Assombrada de Horth', 'Enquanto a neve é soprada ao vento, você vê figuras espectrais terríveis e distorcidas vagando por este lugar, como se ainda fossem pessoas vivas habitando a vila. Você espera dar descanso à essas almas.'),
(33, 'en', 'Ice Mirror Cave', 'The legend says it\'s possible to see the reflection of your very soul in the glass-like ice walls of this cave. You personally only feel a chill, how disappointing.'),
(33, 'es', 'Cueva del Espejo de Hielo', 'La leyenda dice que es posible ver el reflejo de tu alma en las paredes de hielo de esta cueva. Personalmente solo sientes un escalofrío, qué decepcionante.'),
(33, 'fr', 'Caverne des Miroirs de Glace', 'La légende dit qu\'il est possible de voir le reflet de votre âme dans les murs de glace en verre de cette grotte. Personnellement, vous ne ressentez qu\'un frisson, comme c\'est décevant.'),
(33, 'pt-BR', 'Caverna de Gelo Espelhado', 'A lenda diz que é possível ver a reflexão de sua própria alma nas paredes parecidas com vidro desta caverna. Você pessoalmente só sente um calafrio, que decepcionante.'),
(34, 'en', 'Antique Dwarf Forge', 'Once in this dwarf forge, many legendary weapons were crafted by the most skilled dwarves of this region, heated by the fire of this forge. Now many of these weapons are lost, or buried into the snow. Legendary treasury that awaits to be found.'),
(34, 'es', 'Antigua Forja Enana', 'Una vez en esta forja enana, los enanos más hábiles de esta región crearon muchas armas legendarias, calentadas por el fuego de esta forja. Ahora muchas de estas armas están perdidas o enterradas en la nieve. Tesoro legendario que espera ser encontrado.'),
(34, 'fr', 'Forge Antique Naine', 'Une fois dans cette forge naine, de nombreuses armes légendaires furent fabriquées par les nains les plus habiles de la région, chauffées par le feu de cette forge. Aujourd\'hui, beaucoup de ces armes sont perdues ou enterrées dans la neige. Les Trésors légendaires attendent d\'être trouvé.'),
(34, 'pt-BR', 'Antiga Forja Anã', 'Uma vez nesta forja anã, muitas armas lendárias foram criadas pelos anões mais habilidosos desta região, aquecidos pelo fogo desta forja. Agora muitas dessas armas estão perdidas, ou enterradas na neve. Tesouros lendários que aguardam por serem encontrados.');

DROP TABLE IF EXISTS `localizationbosses`;
CREATE TABLE IF NOT EXISTS `localizationbosses` (
  `idBoss` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameBoss` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'generic',
  PRIMARY KEY (`idBoss`,`lang`),
  KEY `fk_LocalizationBosses_Languages1_idx` (`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `localizationbosses` (`idBoss`, `lang`, `nameBoss`) VALUES
(1, 'en', 'Clusters of Spirits of Ancient Adventurers'),
(1, 'es', 'Grupos de espíritus de antiguos aventureros'),
(1, 'fr', 'Amas d\'Esprits d\'Anciens Aventuriers'),
(1, 'pt-BR', 'Aglomerados de Espíritos de Aventureiros Antigos'),
(2, 'en', 'Angry Nature Spirit'),
(2, 'es', 'Espíritu de Naturaleza Enojada'),
(2, 'fr', 'Esprit de la Nature en Colère'),
(2, 'pt-BR', 'Espírito da Natureza Zangado'),
(3, 'en', 'Spirit of an Ancient Desert God'),
(3, 'es', 'Espíritu de un Antiguo Dios del Desierto'),
(3, 'fr', 'Esprit d\'un Ancien Dieu du Désert'),
(3, 'pt-BR', 'Espírito de um Deus Ancião do Deserto'),
(4, 'en', 'Demon World Destroyer'),
(4, 'es', 'Demonio Destructor de Mundos'),
(4, 'fr', 'Démon Destructeur de Mondes'),
(4, 'pt-BR', 'Demônio Destruidor de Mundos');

DROP TABLE IF EXISTS `localizationitems`;
CREATE TABLE IF NOT EXISTS `localizationitems` (
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameItem` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `descItem` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idBaseItem`,`lang`),
  KEY `fk_LocalizationItems_Languages1_idx` (`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `localizationitems` (`idBaseItem`, `lang`, `nameItem`, `descItem`) VALUES
(1, 'en', 'Rudimentary Sword', 'A rudimentary sword, made mainly of wood.'),
(1, 'es', 'Espada Rudimentaria', 'Una Espada Rudimentaria, hecha principalmente de madera.'),
(1, 'fr', 'Épée Rudimentaire', 'Une épée rudimentaire, faite principalement de bois.'),
(1, 'pt-BR', 'Espada Rudimentar', 'Uma espada rudimentar, feita principalmente de madeira.'),
(1, 'ru', 'Рудиментарный Меч', 'Простейший меч, сделанный в основном из дерева.'),
(2, 'en', 'Silver Sword', 'A silver sword, you\'re afraid of werewolves?'),
(2, 'es', 'Espada de Plata', 'Una Espada de Plata, ¿Le temes a los hombres lobo?'),
(2, 'fr', 'Épée en Argent', 'Une épée en argent, vous avez peur des loups-garous ?'),
(2, 'pt-BR', 'Espada de Prata', 'Uma espada de prata, você tem medo de lobisomens?'),
(2, 'ru', 'Серебряный Меч', 'Серебряный меч, ты боишься оборотней?'),
(3, 'en', 'Iron Sword', 'An iron sword, nothing more banal.'),
(3, 'es', 'Espada de Hierro', 'Una Espada de Hierro, Nada más.'),
(3, 'fr', 'Épée en Fer', 'Une épée en fer, rien de plus banal.'),
(3, 'pt-BR', 'Espada de Ferro', 'Uma espada de ferro, nada mais banal.'),
(3, 'ru', 'Железный Меч', 'Железный меч, ничего более банального.'),
(4, 'en', 'Gold Sword', 'A beautiful golden sword, you can see yourself in the reflection.'),
(4, 'es', 'Espada de Oro', 'Una hermosa Espada de Oro, Puedes verte en el reflejo.'),
(4, 'fr', 'Épée en Or', 'Une belle épée en or, vous vous voyez dans le reflet.'),
(4, 'pt-BR', 'Espada de Ouro', 'Uma bela espada de ouro, você pode ver a si mesmo no reflexo dela.'),
(4, 'ru', 'Золотой Меч', 'Красивый золотой меч, вы можете увидеть себя в отражении.'),
(5, 'en', 'Mithril Sword', 'A Mithril sword adorned with some embellishments.'),
(5, 'es', 'Espada de Mitril', 'Una espada de Mitril decorada con algunos adornos'),
(5, 'fr', 'Épée en Mithril', 'Une épée en Mithril ornée de quelques fioritures.'),
(5, 'pt-BR', 'Espada de Mítrio', 'Uma espada de Mítrio adornada com alguns embelezamentos.'),
(5, 'ru', 'Мифриловый Меч', 'Мифриловый меч, украшенный некоторыми украшениями.'),
(6, 'en', 'Rudimentary Chest Armor', 'Do you really think that this can save you?'),
(6, 'es', 'Pechera Rudimentaria', '¿Realmente crees que esto puede salvarte?'),
(6, 'fr', 'Plastron Rudimentaire', 'Vous pensez vraiment que cela peut vous sauver ?'),
(6, 'pt-BR', 'Armadura Peitoral Rudimentar', 'Você realmente acha que isso pode te salvar?'),
(6, 'ru', 'Рудиментарные Доспехи', 'Ты действительно думаешь, что это может спасти тебя?'),
(7, 'en', 'Silver Chest Armor', 'Silver armor, at least the werewolves won\'t touch you.'),
(7, 'es', 'Pechera de Plata', 'Armadura de Plata, Al menos los Hombres Lobo no te tocarán.'),
(7, 'fr', 'Plastron en Argent', 'Une armure en argent, au moins, les loups-garous ne vous toucherons pas.'),
(7, 'pt-BR', 'Armadura Peitoral de Prata', 'Armadura de Prata, pelo menos lobisomens não vão encostar em você.'),
(7, 'ru', 'Серебряные Доспехи', 'Серебряные доспехи, по крайней мере, оборотни тебя не тронут.'),
(8, 'en', 'Iron Chest Armor', 'Iron armor, a little heavy.'),
(8, 'es', 'Pechera de Hierro', 'Armadura de Hierro, un poco pesado.'),
(8, 'fr', 'Plastron en Fer', 'Une armure en fer, un peu lourde.'),
(8, 'pt-BR', 'Armadura Peitoral de Ferro', 'Armadura de Ferro, um pouco pesada.'),
(8, 'ru', 'Железные Доспехи', 'Железные доспехи, немного тяжелые.'),
(9, 'en', 'Gold Chest Armor', 'You can\'t be any less discreet.'),
(9, 'es', 'Pechera de Oro', 'No puedes ser menos discreto.'),
(9, 'fr', 'Plastron en Or', 'Vous ne pouvez pas faire moins discret.'),
(9, 'pt-BR', 'Armadura Peitoral de Ouro', 'Você não pode ser nem um pouco menos discreto.'),
(9, 'ru', 'Золотые Доспехи', 'Ты не можешь быть менее сдержанным.'),
(10, 'en', 'Mithril Chest Armor', 'Mithril armor that will protect you from most attacks.'),
(10, 'es', 'Pechera de Mitril', 'Armadura de mitril que te protegerá de la mayoría de los ataques.'),
(10, 'fr', 'Plastron en Mithril', 'Une armure en Mithril qui vous protègera de la plupart des attaques.'),
(10, 'pt-BR', 'Armadura Peitoral de Mítrio', 'Armadura de Mítrio que vai protegê-lo da maioria dos ataques.'),
(10, 'ru', 'Мифриловые Доспехи', 'Мифриловая броня, которая защитит вас от большинства атак.'),
(11, 'en', 'Rudimentary Armored Leggings', 'Even I wouldn\'t dare wear that.'),
(11, 'es', 'Pantalones Blindados Rudimentarios', 'Incluso yo no me atrevería a usar eso.'),
(11, 'fr', 'Jambières Rudimentaire', 'Même moi je n\'oserai pas porter ça.'),
(11, 'pt-BR', 'Perneiras Reforçadas Rudimentares', 'Nem mesmo eu ousaria vestir isso.'),
(11, 'ru', 'Рудиментарные Поножи', 'Даже я бы не осмелился надеть это.'),
(12, 'en', 'Silver Armored Leggings', 'Another part of the best werewolf hunter set ever.'),
(12, 'es', 'Pantalones Blindados de Plata', 'Otra parte del mejor set de cazadores de Hombres Lobo de la historia.'),
(12, 'fr', 'Jambières en Argent', 'Encore une partie du meilleur set de chasseur de loups-garous.'),
(12, 'pt-BR', 'Perneiras Reforçadas em Prata', 'Mais uma parte do melhor kit de caça-lobisomens de todos os tempos.'),
(12, 'ru', 'Серебряные Поножи', 'Еще одна часть лучшего охотника на оборотней.'),
(13, 'en', 'Iron Armored Leggings', 'At least what is certain is that this part is well protected.'),
(13, 'es', 'Pantalones Blindados de Hierro', 'Al menos lo que es seguro es que esta parte está bien protegida.'),
(13, 'fr', 'Jambières en Fer', 'Au moins ce qui est sûr, c\'est que cette partie est bien protégée.'),
(13, 'pt-BR', 'Perneiras Reforçadas em Ferro', 'Pelo menos o que é certo é que esta parte é bem protegida.'),
(13, 'ru', 'Железные Поножи', 'По крайней мере, очевидно, что эта часть хорошо защищена.'),
(14, 'en', 'Gold Armored Leggings', 'Gold here? After all, why not.'),
(14, 'es', 'Pantalones Blindados de Oro', '¿Oro aquí? Después de todo, por qué no.'),
(14, 'fr', 'Jambières en Or', 'De l\'or ici ? Après tout pourquoi pas.'),
(14, 'pt-BR', 'Perneiras Reforçadas em Ouro', 'Ouro aqui? Afinal, por que não?'),
(14, 'ru', 'Золотые Поножи', 'Золото здесь? В конце концов, почему бы и нет.'),
(15, 'en', 'Mithril Armored Leggings', 'If you hold on to your legs this armor is certainly the best.'),
(15, 'es', 'Pantalones Blindados de Mitril', 'Si te aferras a tus piernas, esta armadura es sin duda la mejor.'),
(15, 'fr', 'Jambières en Mithril', 'Si vous tenez à vos jmabes cette armure est certainement la meilleure.'),
(15, 'pt-BR', 'Perneiras Reforçadas em Mítrio', 'Se você se agarrar nas suas pernas essa armadura é certamente a melhor.'),
(15, 'ru', 'Мифриловые Поножи', 'Если вам дороги ноги, то эта броня, безусловно, лучшая.'),
(16, 'en', 'Rudimentary Helmet', 'Ridiculous, that\'s all I can say.'),
(16, 'es', 'Casco Rudimentario', 'Ridículo, es todo lo que te puedo decir.'),
(16, 'fr', 'Casque Rudimentaire', 'Ridicule, c\'est tout ce que je peux dire.'),
(16, 'pt-BR', 'Capacete Rudimentar', 'Ridículo, isso é tudo que eu posso dizer.'),
(16, 'ru', 'Рудиментарный Шлем', 'Смешно, это все, что я могу сказать.'),
(17, 'en', 'Silver Helmet', 'In general, it\'s true that werewolves like this part.'),
(17, 'es', 'Casco de Plata', 'En general, es cierto que a los Hombres Lobo les gusta esta parte.'),
(17, 'fr', 'Casque en Argent', 'En général, c\'est vrai que les loups-garous aiment bien cette partie.'),
(17, 'pt-BR', 'Capacete de Prata', 'Em geral, é verdade que lobisomens gostam desta parte.'),
(17, 'ru', 'Серебряный Шлем', 'В общем, это правда, что оборотням нравится эта часть.'),
(18, 'en', 'Iron Helmet', 'If you want to look like a soldier, you can\'t do better.'),
(18, 'es', 'Casco de Hierro', 'Si quieres parecer un soldado, no puedes hacerlo mejor.'),
(18, 'fr', 'Casque en Fer', 'Si vous voulez ressembler à un soldat, vous ne pouvez pas faire mieux.'),
(18, 'pt-BR', 'Capacete de Ferro', 'Se você quer parecer com um soldado, você não pode fazer melhor.'),
(18, 'ru', 'Железный Шлем', 'Если хочешь выглядеть солдатом, лучше не придумаешь.'),
(19, 'en', 'Gold Helmet', 'Gold on your head, what is certain is that you will easily attract thieving birds.'),
(19, 'es', 'Casco de Oro', 'Oro en tu cabeza, lo que es seguro es que atraerás fácilmente pájaros ladrones.\n'),
(19, 'fr', 'Casque en Or', 'De l\'or sur la tête, ce qui est sûr c\'est que vous allez facilement attirer des oiseaux voleurs.'),
(19, 'pt-BR', 'Capacete de Ouro', 'Ouro na sua cabeça, o que é certeza é que você vai facilmente atrair pássaros ladrões.'),
(19, 'ru', 'Золотый Шлем', 'Золото на голове, уверен, что вы будете легко привлекать воровских птиц.'),
(20, 'en', 'Mithril Helmet', 'Thanks to this protection, it is impossible for you to be knocked out. I mean, you can always believe that.'),
(20, 'es', 'Casco de Mitril', 'Gracias a esta protección, es imposible que te noqueen. Quiero decir, siempre puedes creer eso.'),
(20, 'fr', 'Casque en Mithril', 'Grâce à cette protection, impossible pour vous d\'être assommé. Enfin, vous pouvez toujours le croire.'),
(20, 'pt-BR', 'Capacete de Mítrio', 'Graças à esta proteção, é impossível que você seja nocauteado. Quer dizer, você sempre pode acreditar nisso.'),
(20, 'ru', 'Мифриловый Шлем', 'Благодаря этой защите, вы не можете быть оглушены. Ты всегда можешь в это поверить.'),
(21, 'en', 'Stone', 'No more than a simple stone.'),
(21, 'es', 'Roca', 'Nada mas que una simple Roca.'),
(21, 'fr', 'Pierre', 'Pas plus qu\'une simple pierre.'),
(21, 'pt-BR', 'Pedra', 'Nada além de uma simples pedra.'),
(21, 'ru', 'Камень', 'Не больше, чем простой камень.'),
(22, 'en', 'Silver', 'Silver, no more than that.'),
(22, 'es', 'Plata', 'Plata, nada mas que eso.'),
(22, 'fr', 'Argent', 'De l\'argent, et je ne parle pas d\'argent.'),
(22, 'pt-BR', 'Prata', 'Prata, nada além disso.'),
(22, 'ru', 'Серебро', 'Серебро, не более того.'),
(23, 'en', 'Iron', 'Iron, one of the most common ores.'),
(23, 'es', 'Hierro', 'Hierro, uno de los minerales mas comunes.'),
(23, 'fr', 'Fer', 'Du fer, un des minerais les plus communs.'),
(23, 'pt-BR', 'Ferro', 'Ferro, um dos minérios mais comuns.'),
(23, 'ru', 'Железо', 'Железо, одна из самых распространенных руд.'),
(24, 'en', 'Gold', 'It\'s... gold! You\'re going to be rich!'),
(24, 'es', 'Oro', '¡Es.. Oro! ¡Te vas a volver rico!'),
(24, 'fr', 'Or', 'Mais, c\'est... de l\'or ! Vous allez devenir riche !'),
(24, 'pt-BR', 'Ouro', 'É... ouro! Você vai ser rico!'),
(24, 'ru', 'Золото', 'Это... золото! Ты будешь богат!'),
(25, 'en', 'Mithril', 'This ore is really hard to get, but you will probably be able to do a lot of things with it.'),
(25, 'es', 'Mitril', 'Este mineral es realmente difícil de obtener, pero probablemente podrás hacer muchas cosas con él.'),
(25, 'fr', 'Mithril', 'Ce minerai est vraiment dur à obtenir, mais vous allez sûrement pouvoir faire beaucoup de choses avec.'),
(25, 'pt-BR', 'Mítrio', 'Este minério é realmente difícil de conseguir, mas você provavelmente vai conseguir fazer um monte de coisas com ele.'),
(25, 'ru', 'Мифрил', 'Эту руду действительно трудно достать, но вы, вероятно, сможешь многое с ней сделать.'),
(26, 'en', 'Roots', 'Roots... Oh, really?'),
(26, 'es', 'Raíces', 'Raíces... ¿Enserio?'),
(26, 'fr', 'Racines', 'Des racines... Vraiment ?'),
(26, 'pt-BR', 'Raízes', 'Raízes... Oh, sério?'),
(26, 'ru', 'Корни', 'Корни... Ох, правда?'),
(27, 'en', 'Ancient Foam', 'A foam that starts to change colour, what is certain is that it is not edible.'),
(27, 'es', 'Espuma Antigua', 'Una espuma que comienza a cambiar de color, lo cierto es que no es comestible.'),
(27, 'fr', 'Mousse Ancienne', 'Une mousse qui commence à changer de couleur, ce qui est sûr c\'est que ce n\'est pas comestible.'),
(27, 'pt-BR', 'Espuma Anciã', 'Uma espuma que muda de cor, a única certeza é que não é comestível.'),
(27, 'ru', 'Древняя Пена', 'Пена, которая начинает менять цвет, уверен, что это не съедобно.'),
(28, 'en', 'Grows-Everywhere', 'This plant is really everywhere, it grows everywhere. Oh, I think I just found it\'s name.'),
(28, 'es', 'Crece-En-Todas-Partes', 'Esta planta realmente está en todos lados, crece en todas partes. Oh, creo que acabo de encontrar su nombre.	'),
(28, 'fr', 'Pousse-Partout', 'Cette plante est vraiment partout, elle pousse partout. Oh je crois que j\'ai trouvé son nom.'),
(28, 'pt-BR', 'Cresce-Em-Todo-Canto', 'Essa planta realmente está em todo lugar, e cresce em todo canto. Oh, acho que acabei de achar o nome dela.'),
(28, 'ru', 'Везде-Растун', 'Это растение действительно везде, оно растет везде. Кажется, я только что нашел его имя.'),
(29, 'en', 'Lava Flower', 'A very strange flower, the inside seems to be filled with lava.'),
(29, 'es', 'Flor de Lava', 'Una flor muy extraña, el interior parece estar lleno de lava.'),
(29, 'fr', 'Fleur de Lave', 'Une fleur très bizarre, l\'intérieur semble être rempli de lave.'),
(29, 'pt-BR', 'Flor de Lava', 'Uma flor muito estranha, seu interior parecer estar preenchido com lava.'),
(29, 'ru', 'Лавовый Цветок', 'Очень странный цветок, внутри, кажется, наполненный лавой.'),
(30, 'en', 'Scathing Creeper', 'These vines are really dangerous, you should avoid rubbing them.'),
(30, 'es', 'Enredadera Mordaz', 'Estas enredaderas son realmente peligrosas, debes evitar frotarlas.'),
(30, 'fr', 'Lianes Cinglantes', 'Ces lianes sont vraiment dangereuses, il faut éviter de s\'y frotter.'),
(30, 'pt-BR', 'Trepadeira Mordaz', 'Essas vinhas são realmente perigosas, você deve evitar esfregá-las.'),
(30, 'ru', 'Хлесткая Лоза', 'Эти лозы действительно опасны, вы должны избегать их касаний.'),
(31, 'en', 'Ash Wood', 'Ash Wood, yes.'),
(31, 'es', 'Ceniza de Madera.', 'sí, ceniza de madera.'),
(31, 'fr', 'Bois de Frêne', 'Du bois, de frêne, oui oui.'),
(31, 'pt-BR', 'Madeira de Cinzas', 'Madeira de Cinzas, sim.'),
(31, 'ru', 'Древесина Ясеня', 'Древесина Ясень, да.'),
(32, 'en', 'Chestnut Wood', 'If you like chestnuts, you shouldn\'t have cut down the tree...'),
(32, 'es', 'Madera de Castaño', 'Si te gustan los castaños, no deberías haber cortado el árbol ...'),
(32, 'fr', 'Bois de Châtaignier', 'Si tu aimes les châtaignes, il ne fallait pas couper l\'arbre...'),
(32, 'pt-BR', 'Madeira de Castanha', 'Se você gosta de castanhas, então não devia ter cortado a árvore...'),
(32, 'ru', 'Древесина Каштана', 'Если ты любишь каштаны, тебе не стоило срубать дерево...'),
(33, 'en', 'Cactus', 'A cactus, soaked with water.'),
(33, 'es', 'Cactus', 'Un cactus, mojado con agua.'),
(33, 'fr', 'Cactus', 'Un cactus, imbibé d\'eau.'),
(33, 'pt-BR', 'Cacto', 'Um cacto, encharcado de água.'),
(33, 'ru', 'Кактус', 'Кактус, пропитанный водой.'),
(34, 'en', 'Ebony Wood', 'Hey Bonnie! Yeah, you\'re not very good at jokes.'),
(34, 'fr', 'Bois d\'ébène', 'Hey Ben ! Oui, les blagues c\'est pas votre fort.'),
(34, 'pt-BR', 'Madeira de Ébano', 'Ei, Albano! É, você não é muito bom com piadas.'),
(34, 'ru', 'Древесина Черного Дерева', 'Эй, Бонни! Да, ты не очень хорошо умеешь шутить.'),
(35, 'en', 'Lava Wood', 'A very strange piece of wood, soaked with lava.'),
(35, 'fr', 'Bois de Lave', 'Un morceau de bois très étrange, imbibé de lave.'),
(35, 'pt-BR', 'Madeira de Lava', 'Um pedaço muito estranho de madeira, encharcado com lava.'),
(35, 'ru', 'Древесина Лавового Дерева', 'Очень странный кусок дерева, пропитанный лавой.'),
(36, 'en', 'Donkey', 'Almost a horse.'),
(36, 'fr', 'Âne', 'Presque un cheval.'),
(36, 'pt-BR', 'Burro', 'Quase um cavalo.'),
(36, 'ru', 'Ослик', 'Почти лошадь.'),
(37, 'en', 'Old Horse', 'A horse with experience, unfortunately it doesn\'t allow him to go faster.'),
(37, 'fr', 'Cheval Âgé', 'Un cheval avec de l\'expérience, malheureusement ça ne lui permet pas d\'aller plus vite.'),
(37, 'pt-BR', 'Cavalo Velho', 'Um cavalo experiente, mas infelizmente isso não o faz andar mais rápido.'),
(37, 'ru', 'Старая Лошадь', 'Лошадь с опытом, который, к сожалению, не позволяет ехать быстрее.'),
(38, 'en', 'Tywardreath Horse', 'A proud Tywardreath horse. Probably one of the best of his generation.'),
(38, 'fr', 'Cheval de Tywardreath', 'Un fier cheval de Tywardreath. Sûrement un des meilleurs de sa génération.'),
(38, 'pt-BR', 'Cavalo de Tywardreath', 'Um orgulhoso cavalo de Tywardreath. Provavelmente um dos melhores de sua geração.'),
(38, 'ru', 'Тумиронская Лощадь', 'Гордый Тумиронский конь. Вероятно, один из лучших в своем поколении.'),
(39, 'en', 'Desert Horse', 'Yes, it\'s a horse that\'s used to be in the desert, isn\'t it crazy?'),
(39, 'fr', 'Cheval du Désert', 'Oui, c\'est bien un cheval qui est habitué au désert, c\'est fou non ?'),
(39, 'pt-BR', 'Cavalo do Deserto', 'Sim, é um cavalo acostumado com deserto, não é doideira?'),
(39, 'ru', 'Пустынная Лошадь', 'Да, это лошадь, которая привыкла к пустыне, разве это не безумие?'),
(40, 'en', 'Fire Palfrey', 'A fire horse, honestly, isn\'t it a dream come true?'),
(40, 'fr', 'Palefroi de Feu', 'Un cheval enflammé, sincèrement est-ce que ce n\'est pas un rêve qui devient réalité ?'),
(40, 'pt-BR', 'Palafrém de Fogo', 'Um cavalo de fogo, honestamente, isto não é um sonho se tornando realidade?'),
(40, 'ru', 'Огненный Палфри', 'Огненная Лошадь, честно говоря, разве это не мечта?'),
(41, 'en', 'Anti-tiredness potion', 'With this potion, in one sip you won\'t be tired anymore!'),
(41, 'fr', 'Potion anti-fatigue', 'Avec cette potion, en une gorgée vous ne serez plus fatigué !'),
(41, 'pt-BR', 'Poção anti-cansaço', 'Com esta poção, em um gole você não vai mais estar cansado!'),
(41, 'ru', 'Зелье против усталости', 'Выпейте одним глотком это зелье и вы больше не устанете!'),
(42, 'en', 'Founder\'s Gift', 'A very rare gift to get you off to a good start! What are you waiting for? Open it! Open it!'),
(42, 'fr', 'Cadeau de Fondateur', 'Un cadeau très rare vous permettant de bien démarrer l\'aventure ! Qu\'est-ce que vous attendez ? Ouvrez-le !'),
(42, 'pt-BR', 'Presente do Fundador', 'Um presente muito raro pra ajudar você a começar com o pé direito! O que você está esperando? Abre! Abre!'),
(42, 'ru', 'Дар Основателя', 'Очень редкий подарок для хорошего начала! Чего же вы ждете? Открой! Открой!'),
(43, 'en', 'Pandrandom & Pic Box', 'A box that should give you a chance to get efficient equipment.'),
(43, 'fr', 'Boite de Pandaleatoire & Pic', 'Une boite qui devrait pouvoir vous laisser une chance d\'obtenir des équipements efficaces. '),
(43, 'pt-BR', 'Pandoraleatória & Caixa Pica', 'Uma caixa que deve dar-lhe uma chance de conseguir equipamento eficiente.'),
(44, 'en', 'Pandrandom Lay Gendary Box', 'An extraordinary box, filled with nothing most of the time. But who can let you see from time to time an exceptional equipment.'),
(44, 'fr', 'Boite de Pandaleatoire Les Gens d\'Air', 'Une boite extraordinaire, remplie de vent la plupart du temps. Mais qui peut laisser entrevoir de temps à autre un équipement exceptionnel !'),
(44, 'pt-BR', 'Caixa Lem Dária Pandoraleatória', 'Uma caixa extraordinária, cheia de nada na maioria das vezes. Mas esta de tempos em tempos pode deixá-lo obter um equipamento excepcional.'),
(45, 'en', 'Chaos Sword', 'This sword is made of magic from chaos shards from another dimension.'),
(45, 'fr', 'Épée du Chaos', 'Cette épée est faite de magie venant d\'éclats du chaos appartenant d\'une autre dimension.'),
(45, 'pt-BR', 'Espada do Caos', 'Esta espada é feita de magia de fragmentos do caos de outra dimensão.'),
(46, 'en', 'Chaos Chest Armor', 'This chest armor is made of magic from chaos shards from another dimension.'),
(46, 'fr', 'Plastron du Chaos', 'Ce plastron est fait de magie venant d\'éclats du chaos appartenant d\'une autre dimension.'),
(46, 'pt-BR', 'Armadura Peitoral do Caos', 'Esta armadura peitoral é feita de magia de fragmentos do caos de outra dimensão.'),
(47, 'en', 'Chaos Leggings', 'Theses leggings are made of magic from chaos shards from another dimension.'),
(47, 'fr', 'Jambières du Chaos', 'Ces jambières sont faites de magie venant d\'éclats du chaos appartenant d\'une autre dimension.'),
(47, 'pt-BR', 'Perneiras do Caos', 'Estas perneiras são feitas de magia de fragmentos do caos de outra dimensão.'),
(48, 'en', 'Chaos Helmet', 'This helmet is made of magic from chaos shards from another dimension.'),
(48, 'fr', 'Casque du Chaos', 'Ce casque est fait de magie venant d\'éclats du chaos appartenant d\'une autre dimension.'),
(48, 'pt-BR', 'Elmo do Caos', 'Este elmo é feito de magia de fragmentos do caos de outra dimensão.'),
(49, 'en', 'Chaos Shard', 'Crystallized chaos from another dimension. As you get closer you can hear screams, cries and a strange and continuous noise from this object.'),
(49, 'fr', 'Éclat de Chaos', 'Du chaos cristallisé venant d\'une autre dimension. En vous approchant de plus près vous pouvez entendre des cris, des pleurs et un bruit étrange et continu provenant de cet objet.'),
(49, 'pt-BR', 'Fragmento do Caos', 'Caos cristalizado de outra dimensão. Conforme você se aproxima você pode ouvir gritos, choros e barulho estranho e contínuo vindo deste objeto.'),
(50, 'en', 'Homemade Energy Drink', 'This drink is probably the least effective that exists, but you will still feel a little less tired.'),
(50, 'fr', 'Boisson Énergisante Artisanale', 'Cette boisson est sûrement la moins efficace qui existe, cependant vous vous sentirez tout de même un peu moins fatigué.'),
(50, 'pt-BR', 'Energético Caseiro', 'Esse drinque é provavelmente o menos efetivo que existe, mas você ainda vai se sentir um pouquinho menos cansado.'),
(51, 'en', 'Energy Drink', 'One of the most popular drinks to avoid sleeping!'),
(51, 'fr', 'Boisson Énergisante', 'Une des boissons les plus répandues pour éviter de dormir !'),
(51, 'pt-BR', 'Energético', 'Um dos drinques mais populares para evitar dormir!'),
(52, 'en', 'Exotic Energy Drink', 'A drink with an extraordinary taste, surely the best on the market.'),
(52, 'fr', 'Boisson Énergisante Exotique', 'Une boisson avec un goût hors du commun, sûrement ce qu\'il y\'a de mieux sur le marché.'),
(52, 'pt-BR', 'Bebida Energética Exótica', 'Um drinque com um gosto extraordinário, com certeza o melhor do mercado.'),
(53, 'en', 'Golden Energy Drink', 'A golden drink is something you\'ve never seen before! It also seems to have a very special taste!'),
(53, 'fr', 'Boisson Énergisante Dorée', 'Une boisson couleur or, c\'est quelque chose de jamais vu ! Elle semble aussi avoir un goût très particulier !'),
(53, 'pt-BR', 'Bebida Energética Dourada', 'Um energético dourado é uma coisa que você nunca viu antes! E ele tem um gosto especialzão!'),
(54, 'en', 'Multicoloured Energy Drink', 'You are facing a magnificent spectacle, this drink is illuminated with colors. Its taste is, like its colour, just as varied.'),
(54, 'fr', 'Boisson Énergisante Multicolore', 'Vous faites face à un spectacle magnifique, cette boisson est illuminée de couleurs. Son goût est, à l\'instar de sa couleur tout aussi varié.'),
(54, 'pt-BR', 'Bebida Energética Multicolorida', 'Você está encarando um espetáculo magnífico, este drinque é iluminado com cores. Seu gosto é, bem como suas cores, tão variado quanto.'),
(55, 'en', 'Divine Energy Drink', 'This drink seems to be a gift from the gods, it shines on all sides and seems to want to be drunk at all costs.'),
(55, 'fr', 'Boisson Énergisante Divine', 'Cette boisson semble être un cadeau des dieux, elle brille de toute part et semble vouloir à tout prix qu\'on la boive.'),
(55, 'pt-BR', 'Bebida Energética Divina', 'Este drinque parece ser um presente dos deuses, ele brilha em todos lados e parece querer ser bebido a todo custo.'),
(56, 'en', 'Frost Horse', 'This horse has lived so long in this cold and lifeless paradise that it is now one with the local climate.'),
(56, 'fr', 'Cheval de Glace', 'Ce cheval a vécu tellement longtemps dans ce paradis froid et sans vie qu\'il ne fait désormais plus qu\'un avec le climat local.'),
(56, 'pt-BR', 'Cavalo Gélido', 'Este cavalo viveu por tanto tempo neste paraíso frio e sem vida que agora ele e o clima local são um só.');

DROP TABLE IF EXISTS `localizationmonsters`;
CREATE TABLE IF NOT EXISTS `localizationmonsters` (
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameMonster` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idMonstre`,`lang`),
  KEY `fk_LocalizationMonsters_Languages1_idx` (`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `localizationmonsters` (`idMonstre`, `lang`, `nameMonster`) VALUES
(1, 'en', 'Wisp'),
(1, 'es', 'Fuego Fatuo'),
(1, 'fr', 'Feu Follet'),
(1, 'pt-BR', 'Fogo-fátuo'),
(1, 'ru', 'Висп'),
(2, 'en', 'Slime'),
(2, 'es', 'Slime'),
(2, 'fr', 'Slime'),
(2, 'pt-BR', 'Gosma'),
(2, 'ru', 'Слизь'),
(3, 'en', 'Poisonous Slime'),
(3, 'es', 'Slime venenoso'),
(3, 'fr', 'Slime Empoisoné'),
(3, 'pt-BR', 'Gosma Venenosa'),
(3, 'ru', 'Ядовитая Слизь'),
(4, 'en', 'Tree Spider'),
(4, 'es', 'Araña de Árbol'),
(4, 'fr', 'Araignée Arboricole'),
(4, 'pt-BR', 'Aranha de Árvore'),
(4, 'ru', 'Древесный Паук'),
(5, 'en', 'Wolf'),
(5, 'es', 'Lobo'),
(5, 'fr', 'Loup'),
(5, 'pt-BR', 'Lobo'),
(5, 'ru', 'Волк'),
(6, 'en', 'Earth Golem'),
(6, 'es', 'Gólem de Tierra'),
(6, 'fr', 'Golem de terre'),
(6, 'pt-BR', 'Golem da Terra'),
(6, 'ru', 'Земляной Голем'),
(7, 'en', 'Stone Golem'),
(7, 'es', 'Gólem de Piedra'),
(7, 'fr', 'Golem de pierre'),
(7, 'pt-BR', 'Golem de Pedra'),
(7, 'ru', 'Каменный Голем'),
(8, 'en', 'Magma Golem'),
(8, 'es', 'Gólem de Magma'),
(8, 'fr', 'Golem de magma'),
(8, 'pt-BR', 'Golem de Magma'),
(8, 'ru', 'Магмовый Голем'),
(9, 'en', 'Water Golem'),
(9, 'es', 'Gólem de Agua'),
(9, 'fr', 'Golem d\'eau'),
(9, 'pt-BR', 'Golem de Água'),
(9, 'ru', 'Водный Голем'),
(10, 'en', 'Air Golem'),
(10, 'es', 'Gólem de Aire'),
(10, 'fr', 'Golem d\'air'),
(10, 'pt-BR', 'Golem de Ar'),
(10, 'ru', 'Воздушный Голем'),
(11, 'en', 'Storm Golem'),
(11, 'es', 'Gólem de Tormenta'),
(11, 'fr', 'Golem des tempêtes'),
(11, 'pt-BR', 'Golem da Tempestade'),
(11, 'ru', 'Штормовой Голем'),
(12, 'en', 'Arcanic Golem'),
(12, 'es', 'Gólem Arcáno'),
(12, 'fr', 'Golem arcanique'),
(12, 'pt-BR', 'Golem Arcano'),
(12, 'ru', 'Тайный Голем'),
(13, 'en', 'Rock Snake'),
(13, 'es', 'Serpiente de Roca'),
(13, 'fr', 'Serpent des roches'),
(13, 'pt-BR', 'Píton'),
(13, 'ru', 'Скалистая Змея'),
(14, 'en', 'Stone Basil'),
(14, 'es', 'Albahaca de Piedra'),
(14, 'fr', 'Basilic de pierre'),
(14, 'pt-BR', 'Basilisco de Pedra'),
(14, 'ru', 'Каменный Базилик'),
(15, 'en', 'Drilling Worm'),
(15, 'es', 'Gusano de perforación'),
(15, 'fr', 'Ver foreur'),
(15, 'pt-BR', 'Minhoca Perfuradora'),
(15, 'ru', 'Копающий Червь'),
(16, 'en', 'Blood-stained Vulture'),
(16, 'es', 'Buitre manchado de sangre'),
(16, 'fr', 'Vautour ensanglanté'),
(16, 'pt-BR', 'Abutre Manchado em Sangue'),
(16, 'ru', 'Окровавленный Стервятник'),
(17, 'en', 'Hyena'),
(17, 'es', 'Hiena'),
(17, 'fr', 'Hyène'),
(17, 'pt-BR', 'Hiena'),
(17, 'ru', 'Гиена'),
(18, 'en', 'Harpy'),
(18, 'es', 'Buitre Harpía'),
(18, 'fr', 'Harpie'),
(18, 'pt-BR', 'Harpia'),
(18, 'ru', 'Гарпия'),
(19, 'en', 'Tortured Giant'),
(19, 'es', 'Gigante Torturado'),
(19, 'fr', 'Géant torturé'),
(19, 'pt-BR', 'Gigante Torturado'),
(19, 'ru', 'Замученный Гигант'),
(20, 'en', 'Monstrous Ghoul'),
(20, 'es', 'Necrófago Monstruoso'),
(20, 'fr', 'Goule monstrueuse'),
(20, 'pt-BR', 'Ghoul Monstruoso'),
(20, 'ru', 'Чудовищный Упырь'),
(21, 'en', 'Jungle Snake'),
(21, 'es', 'Serpiente de Selva'),
(21, 'fr', 'Serpent de la jungle'),
(21, 'pt-BR', 'Cobra da Selva'),
(21, 'ru', 'Змея Джунглей'),
(22, 'en', 'Fierce Tiger'),
(22, 'es', 'Tigre Feroz '),
(22, 'fr', 'Tigre féroce'),
(22, 'pt-BR', 'Tigre Feroz'),
(22, 'ru', 'Свирепый Тигр'),
(23, 'en', 'Lonely Raptor'),
(23, 'es', 'Raptor Solitario'),
(23, 'fr', 'Raptor solitaire'),
(23, 'pt-BR', 'Ave de Rapina Solitária'),
(23, 'ru', 'Одинокий Хищник'),
(24, 'en', 'Dominant Gorilla'),
(24, 'es', 'Gorila Dominante'),
(24, 'fr', 'Gorille dominant'),
(24, 'pt-BR', 'Gorila Dominante'),
(24, 'ru', 'Доминантная Горилла'),
(25, 'en', 'Scarred Bear'),
(25, 'es', 'Oso Cicatrizado'),
(25, 'fr', 'Ours balafré'),
(25, 'pt-BR', 'Urso com Cicatrizes'),
(25, 'ru', 'Медведь Со Шрамами'),
(26, 'en', 'Large Alligator'),
(26, 'es', 'Cocodrilo Grande'),
(26, 'fr', 'Alligator imposant'),
(26, 'pt-BR', 'Jacaré Grande'),
(26, 'ru', 'Большой Аллигатор'),
(27, 'en', 'Maatan Warrior'),
(27, 'es', 'Guerrero Maatán'),
(27, 'fr', 'Guerrier Maatan'),
(27, 'pt-BR', 'Guerreiro Maatan'),
(27, 'ru', 'Маатан-Воин'),
(28, 'en', 'Maatan Hunter'),
(28, 'es', 'Cazador Maatán'),
(28, 'fr', 'Chasseur Maatan'),
(28, 'pt-BR', 'Caçador Maatan'),
(28, 'ru', 'Маатан-Охотник'),
(29, 'en', 'Balrog, fire spirit'),
(29, 'es', 'Balrog, Espíritu de fuego'),
(29, 'fr', 'Bats le Rog, esprit du feu'),
(29, 'pt-BR', 'Balrog, espírito de fogo'),
(29, 'ru', 'Балрог, огненный дух'),
(30, 'en', 'Ardent Bogeyman'),
(30, 'es', 'Hombre de las pesadillas Ardiente'),
(30, 'fr', 'Fouettard ardent'),
(30, 'pt-BR', 'Bicho-papão Ardente'),
(30, 'ru', 'Пылкий Бугимен'),
(31, 'en', 'Wutgarek Warrior'),
(31, 'es', 'Guerrero Wutgarek\n'),
(31, 'fr', 'Guerrier Wutgarek'),
(31, 'pt-BR', 'Guerreiro Wutgarek'),
(31, 'ru', 'Футгарек-Воин'),
(32, 'en', 'Wutgarek Archer'),
(32, 'es', 'Arquero Wutgarek'),
(32, 'fr', 'Archer Wutgarek'),
(32, 'pt-BR', 'Arqueiro Wutgarek'),
(32, 'ru', 'Футгарек-Лучник'),
(33, 'en', 'Wutgarek Berserker'),
(33, 'es', 'Vikingo Wutgarek'),
(33, 'fr', 'Berserker Wutgarek'),
(33, 'pt-BR', 'Berserker Wutgarek'),
(33, 'ru', 'Футгарек-Берсеркер'),
(34, 'en', 'Wutgarek Wizard'),
(34, 'es', 'Mago Wutgarek'),
(34, 'fr', 'Mage Wutgarek'),
(34, 'pt-BR', 'Feiticeiro Wutgarek'),
(34, 'ru', 'Футгарек-Волшебник'),
(35, 'en', 'Wutgarek Sergeant'),
(35, 'es', 'Sargento Wutgarek'),
(35, 'fr', 'Sergent Wutgarek'),
(35, 'pt-BR', 'Sargento Wutgarek'),
(35, 'ru', 'Футгарек-Сержант'),
(36, 'en', 'Bear'),
(36, 'es', 'Oso'),
(36, 'fr', 'Ours'),
(36, 'pt-BR', 'Urso'),
(36, 'ru', 'Медведь'),
(37, 'en', 'Tywardreath Great Bear'),
(37, 'es', 'Gran Oso de Tywardreath'),
(37, 'fr', 'Grand Ours de Tywardreath'),
(37, 'pt-BR', 'Grandioso Urso de Tywardreath'),
(37, 'ru', 'Тумиронский Большой Медведь'),
(38, 'en', 'Stone Golem'),
(38, 'es', 'Golem de Piedra'),
(38, 'fr', 'Golem de Pierre'),
(38, 'pt-BR', 'Golem de Pedra'),
(38, 'ru', 'Каменный Голем'),
(39, 'en', 'Meteorite Golem'),
(39, 'es', 'Golem de Meteorito'),
(39, 'fr', 'Golem Météorite'),
(39, 'pt-BR', 'Golem de Meteorito'),
(39, 'ru', 'Метеоритный Голем'),
(40, 'en', 'Great Wolf'),
(40, 'es', 'Gran Lobo'),
(40, 'fr', 'Grand Loup'),
(40, 'pt-BR', 'Grande Lobo'),
(40, 'ru', 'Большой Волк'),
(41, 'en', 'Great Wild Boar'),
(41, 'es', 'Gran Jabalí salvaje'),
(41, 'fr', 'Grand Sanglier'),
(41, 'pt-BR', 'Grande Javali Selvagem'),
(41, 'ru', 'Большой Дикий Кабан'),
(42, 'en', 'Tywardreath Great Wolf'),
(42, 'es', 'Gran Lobo de Tywardreath'),
(42, 'fr', 'Grand Loup de Tywardreath'),
(42, 'pt-BR', 'Grandioso Lobo de Tywardreath'),
(42, 'ru', 'Тумиронский Большой Волк'),
(43, 'en', 'Tywardreath Flying Snake'),
(43, 'es', 'Serpiente Voladora de Tywardreath'),
(43, 'fr', 'Serpent Volant de Tywardreath'),
(43, 'pt-BR', 'Cobra Voadora de Tywardreath'),
(43, 'ru', 'Тумиронская Летающая Змея'),
(44, 'en', 'Tywardreath Red Eyed Flying Snake'),
(44, 'es', 'Serpiente Voladora de Ojos Rojos de Tywardreath'),
(44, 'fr', 'Serpent Volant aux Yeux Rouge de Tywardreath'),
(44, 'pt-BR', 'Cobra Voadora de Olhos Vermelhos de Tywardreath'),
(44, 'ru', 'Тумиронская Красноглазая Летающая Змея'),
(45, 'en', 'Aggressive Giant Rove Beetle'),
(45, 'es', 'Escarabajo Gigante Agresivo'),
(45, 'fr', 'Staphylin Géant Agressif'),
(45, 'pt-BR', 'Besouro Staphylinidae Agressivo Gigante'),
(45, 'ru', 'Агрессивный Гигантский Блуждающий Жук'),
(46, 'en', 'Giant Praying Mantis'),
(46, 'es', 'Mantis Religiosa Gigante'),
(46, 'fr', 'Mante Religieuse Géante'),
(46, 'pt-BR', 'Louva-Deus Gigante'),
(46, 'ru', 'Гигантский Богомол'),
(47, 'en', 'Giant Rhinoceros Beetle'),
(47, 'es', 'Escarabajo-Rinoceronte Gigante'),
(47, 'fr', 'Scarabée Rhinocéros Géant'),
(47, 'pt-BR', 'Besouro-Rinoceronte Gigante'),
(47, 'ru', 'Гигантский Жук-Носорог'),
(48, 'en', 'Mutant Praying Mantis'),
(48, 'es', 'Mantis Religiosa Mutante'),
(48, 'fr', 'Mante Religieuse Mutante'),
(48, 'pt-BR', 'Louva-Deus Mutante'),
(48, 'ru', 'Богомол-Мутант'),
(49, 'en', 'Small Meteorite Golem'),
(49, 'es', 'Golem de Meteorito Pequeño'),
(49, 'fr', 'Petit Golem de Météorite'),
(49, 'pt-BR', 'Golem de Meteorito Pequeno'),
(49, 'ru', 'Малый Метеоритный Голем'),
(50, 'en', 'Sand Golem'),
(50, 'es', 'Golem de Arena'),
(50, 'fr', 'Golem de Sable'),
(50, 'pt-BR', 'Golem de Areia'),
(50, 'ru', 'Песчаный Голем'),
(51, 'en', 'Giant Sand Golem'),
(51, 'es', 'Golem gigante de Arena'),
(51, 'fr', 'Golem de Sable Géant'),
(51, 'pt-BR', 'Golem de Areia Gigante'),
(51, 'ru', 'Гигантский Песчаный Голем'),
(52, 'en', 'Wutgarek Lieutenant'),
(52, 'es', 'Teniente Wutgarek'),
(52, 'fr', 'Lieutenant Wutgarek'),
(52, 'pt-BR', 'Tenente de Wutgarek'),
(52, 'ru', 'Футгарек-Лейтенант'),
(53, 'en', 'Decomposed Living Mummy'),
(53, 'es', 'Momia Viva Descompuesta'),
(53, 'fr', 'Momie Vivante Décomposée'),
(53, 'pt-BR', 'Múmia Decomposta Viva'),
(53, 'ru', 'Разложившаяся Живая Мумия'),
(54, 'en', 'Servant of the Tombs'),
(54, 'es', 'Siervo de las Tumbas'),
(54, 'fr', 'Serviteur des Tombes'),
(54, 'pt-BR', 'Servo das Tumbas'),
(54, 'ru', 'Слуги из Гробницы'),
(55, 'en', 'Guardian of the Tombs'),
(55, 'es', 'Guardian de las Tumbas'),
(55, 'fr', 'Gardien des Tombes'),
(55, 'pt-BR', 'Guardião das Tumbas'),
(55, 'ru', 'Страж Могил'),
(56, 'en', 'Molten Golem'),
(56, 'es', 'Golem fundido'),
(56, 'fr', 'Golem de Magma en Fusion'),
(56, 'pt-BR', 'Golem Derretido'),
(56, 'ru', 'Расплавленный Голем'),
(57, 'en', 'Lava Elemental'),
(57, 'es', 'Elemental de Lava'),
(57, 'fr', 'Elémentaire de Lave'),
(57, 'pt-BR', 'Elemental de Lava'),
(57, 'ru', 'Элементаль Лавы'),
(58, 'en', 'Fire Elemental'),
(58, 'es', 'Elemental de fuego'),
(58, 'fr', 'Elémentaire de Feu'),
(58, 'pt-BR', 'Elemental de Fogo'),
(58, 'ru', 'Огненный Элементаль'),
(59, 'en', 'Giant Magma Golem'),
(59, 'es', 'Golem Gigante de Magma'),
(59, 'fr', 'Golem de Magma Gigantesque'),
(59, 'pt-BR', 'Golem Gigante de Magma'),
(59, 'ru', 'Гигантский Магмовые Голем'),
(60, 'en', 'Smoke Elemental'),
(60, 'es', 'Elemental de Humo'),
(60, 'fr', 'Elémentaire de Fumée'),
(60, 'pt-BR', 'Elemental de Fumaça'),
(60, 'ru', 'Элементаль Дыма'),
(61, 'en', 'Ash Golem'),
(61, 'es', 'Golem de Ceniza'),
(61, 'fr', 'Golem de Cendre'),
(61, 'pt-BR', 'Golem de Cinzas'),
(61, 'ru', 'Голем из Золы'),
(62, 'en', 'Lava Imp'),
(62, 'es', 'Diablillo de Lava'),
(62, 'fr', 'Diablotin de Lave'),
(62, 'pt-BR', 'Diabrete de Lava'),
(62, 'ru', 'Лавовый Имп'),
(63, 'en', 'Imp Mother'),
(63, 'es', 'Diablillo Madre'),
(63, 'fr', 'Mère des Diablotins'),
(63, 'pt-BR', 'Mãe Diabrete'),
(63, 'ru', 'Мать Импов'),
(64, 'en', 'Ent Wounded by Lava'),
(64, 'es', 'Gigante Herido por Lava'),
(64, 'fr', 'Ent Blessé par la Lave'),
(64, 'pt-BR', 'Ent Ferido por Lava'),
(64, 'ru', 'Энт Раненый Лавой'),
(65, 'en', 'Dwarf Warrior Ghost'),
(65, 'es', 'Guerrero Enano Fantasma'),
(65, 'fr', 'Fantôme de Guerrier Nain'),
(65, 'pt-BR', 'Fantasma de Anão Guerreiro'),
(65, 'ru', 'Призрак Гнома-Воина'),
(66, 'en', 'Dwarf Archer Ghost'),
(66, 'es', 'Arquero Enano Fantasma'),
(66, 'fr', 'Fantôme d\'Archer Nain'),
(66, 'pt-BR', 'Fantasma de Anão Arqueiro'),
(66, 'ru', 'Призрак Гнома-Лучника'),
(67, 'en', 'Dwarf Mage Ghost'),
(67, 'es', 'Mago Enano Fantasma'),
(67, 'fr', 'Fantôme de Mage Nain'),
(67, 'pt-BR', 'Fantasma de Anão Mago'),
(67, 'ru', 'Призрак Гнома-Мага'),
(68, 'en', 'Angry Ghost of a Former Dwarf King'),
(68, 'es', 'Fantasma Enojado de un Antiguo Rey Enano'),
(68, 'fr', 'Fantôme en Colère d\'un Ancien Roi Nain'),
(68, 'pt-BR', 'Fantasma Puto de um Ex-Rei Anão'),
(68, 'ru', 'Злой Призрак Бывшего Короля Гномов'),
(69, 'en', 'Demonic Guard'),
(69, 'es', 'Guardia Demoníaca'),
(69, 'fr', 'Garde Démoniaque'),
(69, 'pt-BR', 'Guarda Demoníaco'),
(69, 'ru', 'Демонический Защитник'),
(70, 'en', 'Demon of Ancient Times'),
(70, 'es', 'Demonio de los Tiempos Antiguos'),
(70, 'fr', 'Démon des Temps Anciens'),
(70, 'pt-BR', 'Demônio dos Tempos Antigos'),
(70, 'ru', 'Демон Древних Времен'),
(71, 'en', 'Warrior Ghost'),
(71, 'es', 'Guerrero Fantasma'),
(71, 'fr', 'Fantôme de Guerrier'),
(71, 'pt-BR', 'Guerreiro Fantasma'),
(72, 'en', 'Archer Ghost'),
(72, 'es', 'Arquero Fantasma'),
(72, 'fr', 'Fantôme d\'archer'),
(72, 'pt-BR', 'Arqueiro Fantasma'),
(73, 'en', 'Mage Ghost'),
(73, 'es', 'Mago Fantasma'),
(73, 'fr', 'Fantôme de Mage'),
(73, 'pt-BR', 'Mago Fantasma'),
(74, 'en', 'Ghost Clusters'),
(74, 'es', 'Grupo de Fantasmas'),
(74, 'fr', 'Amas de Fantômes'),
(74, 'pt-BR', 'Aglomerado de Fantasmas'),
(75, 'en', 'Skeleton Warrior'),
(75, 'es', 'Guerrero Esqueleto'),
(75, 'fr', 'Guerrier Squelette'),
(75, 'pt-BR', 'Guerreiro Esqueleto'),
(76, 'en', 'Skeleton Archer'),
(76, 'es', 'Arquero Esqueleto'),
(76, 'fr', 'Archer Squelette'),
(76, 'pt-BR', 'Arqueiro Esqueleto'),
(77, 'en', 'Skeleton Mage'),
(77, 'es', 'Mago Esqueleto'),
(77, 'fr', 'Mage Squelette'),
(77, 'pt-BR', 'Mago Esqueleto'),
(78, 'en', 'Abomination of Putrid Fleshes'),
(78, 'es', 'Abominación de Carnes Pútridas'),
(78, 'fr', 'Abomination de Chairs Putrides'),
(78, 'pt-BR', 'Abominação de Carnes Pútridas'),
(79, 'en', 'Ghost of Baron Galssor'),
(79, 'es', 'Fantasma del Baron Galssor'),
(79, 'fr', 'Fantôme du Baron Galssor'),
(79, 'pt-BR', 'Fantasma do Barão Galssor'),
(80, 'en', 'Ice Golem'),
(80, 'es', 'Golem de Hielo'),
(80, 'fr', 'Golem de Glace'),
(80, 'pt-BR', 'Golem de Gelo'),
(81, 'en', 'Powerful Ice Elemental'),
(81, 'es', 'Elemental de Hielo Potente'),
(81, 'fr', 'Puissant Elémentaire de Glace'),
(81, 'pt-BR', 'Elemental de Gelo Poderoso');

DROP TABLE IF EXISTS `localizationregions`;
CREATE TABLE IF NOT EXISTS `localizationregions` (
  `idRegion` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameRegion` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imageRegion` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`idRegion`,`lang`),
  KEY `fk_LocalizationRegions_Languages1_idx` (`lang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `localizationregions` (`idRegion`, `lang`, `nameRegion`, `imageRegion`) VALUES
(1, 'en', 'Isle of Depraved', 'https://image.ibb.co/gLjAoL/isle-of-depraved-en.png'),
(1, 'es', 'Isla de Depraved', ''),
(1, 'fr', 'Île des dépravés', 'https://image.ibb.co/ms7kNf/isle-of-depraved-fr.png'),
(1, 'pt-BR', 'Ilha dos Imorais', 'https://image.ibb.co/jKRefA/isle-of-depraved-pt-br.png'),
(1, 'ru', 'Остров Разрушённый', ''),
(2, 'en', 'Tywardreath', 'https://image.ibb.co/i60da0/tywardreath-en.png'),
(2, 'es', 'Tywardreath', ''),
(2, 'fr', 'Tywardreath', 'https://image.ibb.co/hAuPhf/tywardreath-fr.png'),
(2, 'pt-BR', 'Tywardreath', 'https://image.ibb.co/iyLx0A/tywardreath-pt-br.png'),
(2, 'ru', 'Тивардрит', ''),
(3, 'en', 'Tjesomunein Desert', 'https://image.ibb.co/nfW4JV/tjesomunein-desert-en.png'),
(3, 'es', 'Desierto Tjesomunein', ''),
(3, 'fr', 'Désert de Tjesomunein', 'https://image.ibb.co/dHaydV/tjesomunein-desert-fr.png'),
(3, 'pt-BR', 'Tjesomunein', 'https://image.ibb.co/bT7zDV/tjesomunein-desert-pt-br.png'),
(3, 'ru', 'Чесоменская пустыня', ''),
(4, 'en', 'Daemonic Region', 'https://image.ibb.co/eAEKJV/daemonic-region-en.png'),
(4, 'es', 'Región demoníaca', ''),
(4, 'fr', 'Région Démoniaque', 'https://image.ibb.co/bOsmXq/daemonic-region-fr.png'),
(4, 'pt-BR', 'Região Demoníaca', 'https://image.ibb.co/kjWFnq/daemonic-region-pt-br.png'),
(4, 'ru', 'Демонический регион', ''),
(5, 'en', 'Horth\'s Glacial Lands', 'https://cdn.fight-rpg.com/images/regions/horth-glacial-land-en.png'),
(5, 'es', 'Tierras Glaciales de Horth', ''),
(5, 'fr', 'Les Terres Glaciales de Horth', 'https://cdn.fight-rpg.com/images/regions/horth-glacial-land-fr.png'),
(5, 'pt-BR', 'Terras Glaciais de Horth', 'https://cdn.fight-rpg.com/images/regions/horth-glacial-land-en.png'),
(5, 'ru', 'Ледниковые Земли Хорта', '');

DROP TABLE IF EXISTS `marketplaces`;
CREATE TABLE IF NOT EXISTS `marketplaces` (
  `idMarketplace` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tax` float NOT NULL DEFAULT '0.05',
  `idArea` int(10) UNSIGNED NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idMarketplace`),
  UNIQUE KEY `idMarketplace_UNIQUE` (`idMarketplace`),
  UNIQUE KEY `idArea_UNIQUE` (`idArea`),
  KEY `fk_Marketplaces_Areas1_idx` (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `marketplaces` (`idMarketplace`, `tax`, `idArea`, `active`) VALUES
(1, 0.05, 5, 1),
(2, 0.05, 6, 1),
(6, 0.05, 8, 1),
(7, 0.05, 14, 1),
(8, 0.05, 15, 1),
(9, 0.05, 16, 1),
(10, 0.05, 22, 1),
(11, 0.05, 29, 1),
(12, 0.05, 34, 1);

DROP TABLE IF EXISTS `marketplacesorders`;
CREATE TABLE IF NOT EXISTS `marketplacesorders` (
  `idMarketplace` int(10) UNSIGNED NOT NULL,
  `idItem` int(10) UNSIGNED NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `price` bigint(19) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`idMarketplace`,`idItem`,`idCharacter`),
  UNIQUE KEY `idItem_UNIQUE` (`idItem`),
  KEY `fk_MarketplacesOrders_Items1_idx` (`idItem`),
  KEY `fk_MarketplacesOrders_Characters1_idx` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `monstres`;
CREATE TABLE IF NOT EXISTS `monstres` (
  `idMonstre` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `avglevel` int(10) UNSIGNED NOT NULL,
  `idType` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idMonstre`),
  UNIQUE KEY `idMonstre_UNIQUE` (`idMonstre`),
  KEY `fk_Monstres_MonstresTypes1_idx` (`idType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `monstres` (`idMonstre`, `avglevel`, `idType`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 5, 1),
(7, 6, 1),
(8, 7, 1),
(9, 8, 1),
(10, 9, 1),
(11, 10, 1),
(12, 0, 2),
(13, 10, 1),
(14, 11, 1),
(15, 12, 1),
(16, 13, 1),
(17, 14, 1),
(18, 15, 1),
(19, 0, 2),
(20, 0, 2),
(21, 15, 1),
(22, 16, 1),
(23, 17, 1),
(24, 18, 1),
(25, 19, 1),
(26, 20, 1),
(27, 0, 2),
(28, 0, 2),
(29, 0, 3),
(30, 0, 2),
(31, 0, 1),
(32, 0, 1),
(33, 0, 1),
(34, 0, 1),
(35, 0, 2),
(36, 0, 1),
(37, 0, 2),
(38, 0, 1),
(39, 0, 2),
(40, 0, 1),
(41, 0, 1),
(42, 0, 2),
(43, 0, 2),
(44, 0, 3),
(45, 0, 1),
(46, 0, 1),
(47, 0, 1),
(48, 0, 2),
(49, 0, 1),
(50, 0, 1),
(51, 0, 2),
(52, 0, 2),
(53, 0, 1),
(54, 0, 2),
(55, 0, 3),
(56, 0, 1),
(57, 0, 1),
(58, 0, 1),
(59, 0, 2),
(60, 0, 1),
(61, 0, 1),
(62, 0, 1),
(63, 0, 2),
(64, 0, 2),
(65, 0, 1),
(66, 0, 1),
(67, 0, 1),
(68, 0, 2),
(69, 0, 2),
(70, 0, 3),
(71, 0, 1),
(72, 0, 1),
(73, 0, 1),
(74, 0, 2),
(75, 0, 1),
(76, 0, 1),
(77, 0, 1),
(78, 0, 2),
(79, 0, 2),
(80, 0, 1),
(81, 0, 3),
(82, 0, 1);

DROP TABLE IF EXISTS `monstresgroupes`;
CREATE TABLE IF NOT EXISTS `monstresgroupes` (
  `idMonstreGroupe` int(10) UNSIGNED NOT NULL,
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`idMonstreGroupe`,`idMonstre`),
  KEY `fk_MonstresGroupes_Monstres1_idx` (`idMonstre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `monstresgroupes` (`idMonstreGroupe`, `idMonstre`, `number`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1),
(10, 10, 1),
(11, 11, 1),
(12, 12, 1),
(13, 13, 1),
(14, 14, 1),
(15, 15, 1),
(16, 16, 1),
(17, 17, 1),
(18, 18, 1),
(19, 19, 1),
(20, 20, 1),
(21, 21, 1),
(22, 22, 1),
(23, 23, 1),
(24, 24, 1),
(25, 25, 1),
(26, 26, 1),
(27, 27, 1),
(28, 28, 1),
(29, 29, 1),
(29, 30, 2),
(30, 31, 1),
(31, 32, 1),
(32, 35, 1),
(33, 36, 1),
(34, 37, 1),
(35, 38, 1),
(36, 39, 1),
(37, 40, 1),
(38, 41, 1),
(39, 42, 1),
(40, 43, 2),
(40, 44, 1),
(41, 45, 1),
(42, 46, 1),
(43, 47, 1),
(44, 48, 1),
(45, 49, 1),
(46, 50, 1),
(47, 51, 1),
(48, 52, 1),
(49, 53, 1),
(50, 33, 2),
(51, 34, 1),
(52, 54, 1),
(53, 54, 2),
(53, 55, 1),
(54, 56, 1),
(55, 57, 1),
(56, 58, 1),
(57, 59, 1),
(58, 60, 1),
(59, 61, 1),
(60, 62, 1),
(61, 63, 1),
(62, 64, 1),
(63, 65, 1),
(64, 66, 1),
(65, 67, 1),
(66, 68, 1),
(67, 62, 2),
(67, 69, 2),
(67, 70, 1),
(68, 71, 1),
(69, 72, 1),
(70, 73, 1),
(71, 74, 1),
(72, 75, 1),
(73, 76, 1),
(74, 77, 1),
(75, 78, 1),
(76, 79, 1),
(77, 80, 4),
(77, 81, 1);

DROP TABLE IF EXISTS `monstrestypes`;
CREATE TABLE IF NOT EXISTS `monstrestypes` (
  `idType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idType`),
  UNIQUE KEY `idType_UNIQUE` (`idType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `monstrestypes` (`idType`, `nom`) VALUES
(1, 'normal'),
(2, 'elite'),
(3, 'boss'),
(4, 'boss'),
(5, 'boss');

DROP TABLE IF EXISTS `regions`;
CREATE TABLE IF NOT EXISTS `regions` (
  `idRegion` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`idRegion`),
  UNIQUE KEY `idRegions_UNIQUE` (`idRegion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `regions` (`idRegion`) VALUES
(1),
(2),
(3),
(4),
(5);

DROP TABLE IF EXISTS `regionsbosses`;
CREATE TABLE IF NOT EXISTS `regionsbosses` (
  `idBoss` int(10) UNSIGNED NOT NULL,
  `idRegion` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idBoss`,`idRegion`),
  KEY `fk_RegionsBosses_Regions1_idx` (`idRegion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `regionsbosses` (`idBoss`, `idRegion`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

DROP TABLE IF EXISTS `sellableitems`;
CREATE TABLE IF NOT EXISTS `sellableitems` (
  `idSellableItems` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `level` int(11) NOT NULL DEFAULT '1',
  `number` int(11) NOT NULL DEFAULT '1',
  `price` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idSellableItems`),
  KEY `fk_SellableItems_ItemsBase1_idx` (`idBaseItem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `sellableitems` (`idSellableItems`, `idBaseItem`, `level`, `number`, `price`) VALUES
(1, 43, 10, 1, 65),
(2, 43, 20, 1, 130),
(3, 43, 30, 1, 195),
(4, 43, 40, 1, 260),
(5, 43, 50, 1, 320),
(6, 43, 60, 1, 385),
(7, 43, 70, 1, 450),
(8, 43, 80, 1, 510),
(9, 44, 10, 1, 85),
(10, 44, 20, 1, 170),
(11, 44, 30, 1, 260),
(12, 44, 40, 1, 345),
(13, 44, 50, 1, 425),
(14, 44, 60, 1, 510),
(15, 44, 70, 1, 600),
(16, 44, 80, 1, 680),
(17, 36, 1, 1, 3000),
(18, 37, 1, 1, 15000),
(19, 36, 1, 1, 3000),
(20, 37, 1, 1, 15000),
(21, 43, 90, 1, 580),
(22, 43, 100, 1, 650),
(23, 44, 90, 1, 800),
(24, 44, 100, 1, 1000);

DROP TABLE IF EXISTS `serversstats`;
CREATE TABLE IF NOT EXISTS `serversstats` (
  `idServer` varchar(21) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serverPrefix` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serverName` varchar(101) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `memberCount` int(11) NOT NULL DEFAULT '0',
  `region` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idServer`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `shop`;
CREATE TABLE IF NOT EXISTS `shop` (
  `idShop` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tax` float UNSIGNED NOT NULL DEFAULT '0.05',
  `active` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`idShop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `shop` (`idShop`, `tax`, `active`) VALUES
(1, 0.05, 1),
(2, 0.05, 1),
(3, 0.05, 1),
(4, 0.05, 1),
(5, 0.05, 1),
(6, 0.05, 1),
(7, 0.05, 1),
(8, 0.05, 1),
(9, 0.05, 1);

DROP TABLE IF EXISTS `shopitems`;
CREATE TABLE IF NOT EXISTS `shopitems` (
  `idShop` int(10) UNSIGNED NOT NULL,
  `idSellableItems` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idShop`,`idSellableItems`),
  KEY `fk_ShopItems_SellableItems1_idx` (`idSellableItems`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `shopitems` (`idShop`, `idSellableItems`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(7, 8),
(1, 9),
(2, 10),
(3, 11),
(4, 12),
(5, 13),
(6, 14),
(7, 15),
(7, 16),
(1, 17),
(2, 17),
(3, 17),
(4, 17),
(5, 17),
(6, 17),
(7, 17),
(1, 18),
(2, 18),
(3, 18),
(4, 18),
(5, 18),
(6, 18),
(7, 18),
(8, 21),
(9, 22),
(8, 23),
(9, 24);

DROP TABLE IF EXISTS `spawnedbosses`;
CREATE TABLE IF NOT EXISTS `spawnedbosses` (
  `idSpawnedBoss` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `actualHp` bigint(19) UNSIGNED NOT NULL DEFAULT '100',
  `maxHp` bigint(19) UNSIGNED NOT NULL DEFAULT '100',
  `idBoss` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idSpawnedBoss`),
  KEY `fk_SpawnedBosses_Bosses1_idx` (`idBoss`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `spawnedbossesareas`;
CREATE TABLE IF NOT EXISTS `spawnedbossesareas` (
  `idSpawnedBoss` int(10) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idSpawnedBoss`),
  KEY `fk_SpawnedBossesAreas_Areas1_idx` (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `statisticsbases`;
CREATE TABLE IF NOT EXISTS `statisticsbases` (
  `idStatisticBase` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  PRIMARY KEY (`idStatisticBase`),
  UNIQUE KEY `idStatisticBase_UNIQUE` (`idStatisticBase`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `statisticsbases` (`idStatisticBase`, `name`) VALUES
(1, 'pvefights_victories'),
(2, 'pvefights_defeats'),
(3, 'travels'),
(4, 'gold_dropped'),
(5, 'gold_marketplace'),
(6, 'gold_sell'),
(7, 'damage_done'),
(8, 'damage_taken'),
(9, 'gold_spent'),
(10, 'pvpfights_victories'),
(11, 'pvpfights_defeats'),
(12, 'normal_defeated'),
(13, 'boss_defeated'),
(14, 'elite_defeated'),
(15, 'groups_joined'),
(16, 'groups_created'),
(17, 'items_common_loot'),
(18, 'items_rare_loot'),
(19, 'items_superior_loot'),
(20, 'items_epic_loot'),
(21, 'items_legendary_loot'),
(22, 'guilds_joined'),
(23, 'guilds_created'),
(24, 'items_common_craft'),
(25, 'items_rare_craft'),
(26, 'items_superior_craft'),
(27, 'items_epic_craft'),
(28, 'items_legendary_craft'),
(29, 'commands_inventory'),
(30, 'commands_equipment'),
(31, 'commands_character'),
(32, 'commands_fights'),
(33, 'commands_areas'),
(34, 'commands_groups'),
(35, 'commands_hdv'),
(36, 'commands_job'),
(37, 'commands_other'),
(38, 'commands_guilds'),
(39, 'items_common_collected'),
(40, 'items_rare_collected'),
(41, 'items_superior_collected'),
(42, 'items_epic_collected'),
(43, 'items_legendary_collected'),
(44, 'items_mythic_craft'),
(45, 'items_mythic_collected'),
(46, 'items_mythic_loot');

DROP TABLE IF EXISTS `stats`;
CREATE TABLE IF NOT EXISTS `stats` (
  `idStat` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `desc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idStat`),
  UNIQUE KEY `idStat_UNIQUE` (`idStat`),
  UNIQUE KEY `nom_UNIQUE` (`nom`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `stats` (`idStat`, `nom`, `desc`) VALUES
(1, 'strength', NULL),
(2, 'intellect', NULL),
(3, 'constitution', NULL),
(4, 'armor', NULL),
(5, 'dexterity', NULL),
(6, 'wisdom', NULL),
(7, 'will', NULL),
(8, 'perception', NULL),
(9, 'charisma', NULL),
(10, 'luck', NULL);

DROP TABLE IF EXISTS `statscharacters`;
CREATE TABLE IF NOT EXISTS `statscharacters` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `value` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idCharacter`,`idStat`),
  KEY `fk_StatsCharacters_Stats1_idx` (`idStat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `statsmonstres`;
CREATE TABLE IF NOT EXISTS `statsmonstres` (
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `idStatsProfil` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idMonstre`),
  KEY `fk_StatsMonstres_StatsProfil1_idx` (`idStatsProfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `statsmonstres` (`idMonstre`, `idStatsProfil`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(33, 2),
(41, 2),
(52, 2),
(53, 2),
(61, 2),
(65, 2),
(74, 2),
(80, 2),
(11, 3),
(31, 3),
(37, 3),
(47, 3),
(64, 3),
(68, 3),
(71, 3),
(12, 4),
(13, 4),
(14, 4),
(42, 4),
(43, 4),
(46, 4),
(58, 4),
(79, 4),
(15, 5),
(16, 5),
(17, 5),
(50, 5),
(51, 5),
(59, 5),
(69, 5),
(78, 5),
(18, 6),
(19, 6),
(20, 6),
(36, 6),
(49, 6),
(21, 7),
(22, 7),
(23, 7),
(34, 7),
(39, 7),
(48, 7),
(54, 7),
(57, 7),
(62, 7),
(67, 7),
(70, 7),
(72, 7),
(76, 7),
(81, 7),
(24, 8),
(25, 8),
(26, 8),
(32, 8),
(40, 8),
(45, 8),
(60, 8),
(66, 8),
(73, 8),
(77, 8),
(27, 9),
(28, 9),
(29, 9),
(30, 9),
(35, 9),
(38, 9),
(44, 9),
(55, 9),
(56, 9),
(63, 9),
(75, 9);

DROP TABLE IF EXISTS `statsprofil`;
CREATE TABLE IF NOT EXISTS `statsprofil` (
  `idStatsProfil` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idStatsProfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `statsprofil` (`idStatsProfil`, `name`) VALUES
(1, 'balance_low'),
(2, 'smorc'),
(3, 'tank_stun'),
(4, 'crit'),
(5, 'tank_armor_stun'),
(6, 'tank_will'),
(7, 'damage'),
(8, 'damage_crit'),
(9, 'tanky');

DROP TABLE IF EXISTS `statsrepartition`;
CREATE TABLE IF NOT EXISTS `statsrepartition` (
  `idStatsProfil` int(10) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `percentage` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idStatsProfil`,`idStat`),
  KEY `fk_StatsRepartition_Stats1_idx` (`idStat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

REPLACE INTO `statsrepartition` (`idStatsProfil`, `idStat`, `percentage`) VALUES
(1, 1, 5),
(1, 3, 5),
(1, 4, 10),
(2, 1, 61),
(2, 3, 34),
(2, 4, 80),
(3, 1, 20),
(3, 3, 40),
(3, 4, 80),
(3, 9, 35),
(4, 1, 30),
(4, 3, 32),
(4, 4, 50),
(4, 5, 35),
(5, 1, 23),
(5, 3, 35),
(5, 4, 100),
(5, 9, 35),
(6, 1, 28),
(6, 3, 46),
(6, 4, 100),
(6, 7, 20),
(7, 1, 61),
(7, 3, 35),
(7, 4, 60),
(8, 1, 45),
(8, 3, 35),
(8, 4, 70),
(8, 5, 15),
(9, 1, 28),
(9, 2, 5),
(9, 3, 50),
(9, 4, 100),
(9, 5, 5),
(9, 9, 5);

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `idUser` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `userName` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` text COLLATE utf8mb4_unicode_ci,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isConnected` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idUser`),
  UNIQUE KEY `idUsers_UNIQUE` (`idUser`),
  UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`),
  UNIQUE KEY `token_UNIQUE` (`token`),
  KEY `fk_Users_Character_idx` (`idCharacter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `userspreferences`;
CREATE TABLE IF NOT EXISTS `userspreferences` (
  `idUser` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupmute` tinyint(4) NOT NULL DEFAULT '0',
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `marketplacemute` tinyint(4) NOT NULL DEFAULT '0',
  `fightmute` tinyint(4) NOT NULL DEFAULT '0',
  `trademute` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idUser`),
  UNIQUE KEY `idUser_UNIQUE` (`idUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `wbrewardstates`;
CREATE TABLE IF NOT EXISTS `wbrewardstates` (
  `idSpawnedBoss` int(10) UNSIGNED NOT NULL,
  `state` int(10) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`idSpawnedBoss`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


ALTER TABLE `areas`
  ADD CONSTRAINT `fk_Areas_AreasLevels1` FOREIGN KEY (`AreaLevel`) REFERENCES `areaslevels` (`idAreaLevel`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Areas_AreasTypes1` FOREIGN KEY (`idAreaType`) REFERENCES `areastypes` (`idAreaType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasbonuses`
  ADD CONSTRAINT `fk_AreasBonuses_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasBonuses_BonusTypes1` FOREIGN KEY (`idBonusTypes`) REFERENCES `bonustypes` (`idBonusTypes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasitems`
  ADD CONSTRAINT `fk_AreasItems_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasItems_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasmonsters`
  ADD CONSTRAINT `fk_AreasMonsters_MonstresGroupes1` FOREIGN KEY (`idMonstreGroupe`,`idMonstre`) REFERENCES `monstresgroupes` (`idMonstreGroupe`, `idMonstre`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_table1_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasmonsterslevels`
  ADD CONSTRAINT `fk_AreasMonstersLevels_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasowners`
  ADD CONSTRAINT `fk_AreasOwners_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasOwners_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areaspaths`
  ADD CONSTRAINT `fk_AreasPaths_Areas1` FOREIGN KEY (`idArea1`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasPaths_Areas2` FOREIGN KEY (`idArea2`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasregions`
  ADD CONSTRAINT `fk_AreasRegions_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasRegions_Regions1` FOREIGN KEY (`idRegion`) REFERENCES `regions` (`idRegion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasrequirements`
  ADD CONSTRAINT `fk_AreasRequirements_Achievement1` FOREIGN KEY (`idAchievement`) REFERENCES `achievement` (`idAchievement`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasRequirements_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasresources`
  ADD CONSTRAINT `fk_AreasResources_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasResources_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `areasshops`
  ADD CONSTRAINT `fk_AreasShops_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasShops_Shop1` FOREIGN KEY (`idShop`) REFERENCES `shop` (`idShop`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `bossspawninfo`
  ADD CONSTRAINT `fk_BossSpawnInfo_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_BossSpawnInfo_Bosses1` FOREIGN KEY (`idBoss`) REFERENCES `bosses` (`idBoss`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_BossSpawnInfo_SpawnedBosses1` FOREIGN KEY (`idSpawnedBoss`) REFERENCES `spawnedbosses` (`idSpawnedBoss`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `characters`
  ADD CONSTRAINT `fk_Characters_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `charactersachievements`
  ADD CONSTRAINT `fk_CharactersAchievements_Achievement1` FOREIGN KEY (`idAchievement`) REFERENCES `achievement` (`idAchievement`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersAchievements_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `charactersattacks`
  ADD CONSTRAINT `fk_CharactersAttacks_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersAttacks_SpawnedBosses1` FOREIGN KEY (`idSpawnedBoss`) REFERENCES `spawnedbosses` (`idSpawnedBoss`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `characterscraftlevel`
  ADD CONSTRAINT `fk_CharactersCraftLevel_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersCraftLevel_LevelsRequire1` FOREIGN KEY (`actualLevel`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `charactersequipements`
  ADD CONSTRAINT `fk_CharactersEquipements_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersEquipements_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersEquipements_ItemsTypes1` FOREIGN KEY (`idType`) REFERENCES `itemstypes` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `charactershonor`
  ADD CONSTRAINT `fk_CharacterHonor_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `charactersinventory`
  ADD CONSTRAINT `fk_CharactersInventory_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersInventory_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `charactersstatistics`
  ADD CONSTRAINT `fk_CharactersStatistics_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersStatistics_StatisticsBases1` FOREIGN KEY (`idStatisticBase`) REFERENCES `statisticsbases` (`idStatisticBase`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `conquesttournamentinfo`
  ADD CONSTRAINT `fk_ConquestTournamentInfo_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `conquesttournamentinscriptions`
  ADD CONSTRAINT `fk_AreaConquestTournament_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ConquestTournamentIncriptions_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `conquesttournamentrounds`
  ADD CONSTRAINT `fk_ConquestTournamentRounds_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ConquestTournamentRounds_ConquestTournamentInscriptions1` FOREIGN KEY (`idGuild_1`) REFERENCES `conquesttournamentinscriptions` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ConquestTournamentRounds_ConquestTournamentInscriptions2` FOREIGN KEY (`idGuild_2`) REFERENCES `conquesttournamentinscriptions` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `craftbuilding`
  ADD CONSTRAINT `fk_CraftBuilding_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CraftBuilding_ItemsRarities1` FOREIGN KEY (`rarityMax`) REFERENCES `itemsrarities` (`idRarity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CraftBuilding_ItemsRarities2` FOREIGN KEY (`rarityMin`) REFERENCES `itemsrarities` (`idRarity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CraftBuilding_LevelsRequire1` FOREIGN KEY (`minLevel`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CraftBuilding_LevelsRequire2` FOREIGN KEY (`maxLevel`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `craftitem`
  ADD CONSTRAINT `fk_CraftItem_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CraftItem_LevelsRequire1` FOREIGN KEY (`maxLevel`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CraftItem_LevelsRequire2` FOREIGN KEY (`minLevel`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `craftitemsneeded`
  ADD CONSTRAINT `fk_CraftItemsNeeded_CraftItem1` FOREIGN KEY (`IdCraftItem`) REFERENCES `craftitem` (`idCraftItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CraftItemsNeeded_ItemsBase1` FOREIGN KEY (`NeededItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `guildsappliances`
  ADD CONSTRAINT `fk_table1_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_table1_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `guildsmembers`
  ADD CONSTRAINT `fk_GuildsMembers_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_GuildsMembers_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_GuildsMembers_GuildsRanks1` FOREIGN KEY (`idGuildRank`) REFERENCES `guildsranks` (`idGuildRank`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `items`
  ADD CONSTRAINT `fk_Items_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Items_LevelsRequire1` FOREIGN KEY (`level`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `itemsbase`
  ADD CONSTRAINT `fk_ItemsBase_ItemsRarities1` FOREIGN KEY (`idRarity`) REFERENCES `itemsrarities` (`idRarity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ItemsBase_ItemsSousTypes1` FOREIGN KEY (`idSousType`) REFERENCES `itemssoustypes` (`idSousType`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Items_ItemsTypes1` FOREIGN KEY (`idType`) REFERENCES `itemstypes` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `itemspower`
  ADD CONSTRAINT `fk_ItemsPower_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `itemsstats`
  ADD CONSTRAINT `fk_ItemsStats_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ItemsStats_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `levels`
  ADD CONSTRAINT `fk_Levels_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Levels_LevelsRequire1` FOREIGN KEY (`actualLevel`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `localizationachievements`
  ADD CONSTRAINT `fk_LocalizationAchievements_Achievement1` FOREIGN KEY (`idAchievement`) REFERENCES `achievement` (`idAchievement`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_LocalizationAchievements_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `localizationareas`
  ADD CONSTRAINT `fk_LocalizationAreas_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_LocalizationAreas_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `localizationbosses`
  ADD CONSTRAINT `fk_LocalizationBosses_Bosses1` FOREIGN KEY (`idBoss`) REFERENCES `bosses` (`idBoss`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_LocalizationBosses_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `localizationitems`
  ADD CONSTRAINT `fk_LocalizationItems_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_LocalizationItems_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `localizationmonsters`
  ADD CONSTRAINT `fk_LocalizationMonsters_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_LocalizationMonsters_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `localizationregions`
  ADD CONSTRAINT `fk_LocalizationRegions_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_LocalizationRegions_Regions1` FOREIGN KEY (`idRegion`) REFERENCES `regions` (`idRegion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `marketplaces`
  ADD CONSTRAINT `fk_Marketplaces_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `marketplacesorders`
  ADD CONSTRAINT `fk_MarketplacesOrders_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_MarketplacesOrders_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_MarketplacesOrders_Marketplaces1` FOREIGN KEY (`idMarketplace`) REFERENCES `marketplaces` (`idMarketplace`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `monstres`
  ADD CONSTRAINT `fk_Monstres_MonstresTypes1` FOREIGN KEY (`idType`) REFERENCES `monstrestypes` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `monstresgroupes`
  ADD CONSTRAINT `fk_MonstresGroupes_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `regionsbosses`
  ADD CONSTRAINT `fk_RegionsBosses_Bosses1` FOREIGN KEY (`idBoss`) REFERENCES `bosses` (`idBoss`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_RegionsBosses_Regions1` FOREIGN KEY (`idRegion`) REFERENCES `regions` (`idRegion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `sellableitems`
  ADD CONSTRAINT `fk_SellableItems_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `shopitems`
  ADD CONSTRAINT `fk_ShopItems_SellableItems1` FOREIGN KEY (`idSellableItems`) REFERENCES `sellableitems` (`idSellableItems`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ShopItems_Shop1` FOREIGN KEY (`idShop`) REFERENCES `shop` (`idShop`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `spawnedbosses`
  ADD CONSTRAINT `fk_SpawnedBosses_Bosses1` FOREIGN KEY (`idBoss`) REFERENCES `bosses` (`idBoss`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `spawnedbossesareas`
  ADD CONSTRAINT `fk_SpawnedBossesAreas_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_SpawnedBossesAreas_SpawnedBosses1` FOREIGN KEY (`idSpawnedBoss`) REFERENCES `spawnedbosses` (`idSpawnedBoss`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `statscharacters`
  ADD CONSTRAINT `fk_StatsCharacters_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_StatsCharacters_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `statsmonstres`
  ADD CONSTRAINT `fk_StatsMonstres_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_StatsMonstres_StatsProfil1` FOREIGN KEY (`idStatsProfil`) REFERENCES `statsprofil` (`idStatsProfil`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `statsrepartition`
  ADD CONSTRAINT `fk_StatsRepartition_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_StatsRepartition_StatsProfil1` FOREIGN KEY (`idStatsProfil`) REFERENCES `statsprofil` (`idStatsProfil`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `users`
  ADD CONSTRAINT `fk_Users_Character` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `userspreferences`
  ADD CONSTRAINT `fk_UsersPreferences_Users1` FOREIGN KEY (`idUser`) REFERENCES `users` (`idUser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `wbrewardstates`
  ADD CONSTRAINT `fk_WBRewardStates_SpawnedBosses1` FOREIGN KEY (`idSpawnedBoss`) REFERENCES `spawnedbosses` (`idSpawnedBoss`) ON DELETE NO ACTION ON UPDATE NO ACTION;
SET FOREIGN_KEY_CHECKS=1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
