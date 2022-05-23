-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : lun. 23 mai 2022 à 18:24
-- Version du serveur :  8.0.18
-- Version de PHP : 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------

--
-- Structure de la table `achievement`
--

CREATE TABLE `achievement` (
  `idAchievement` int(10) UNSIGNED NOT NULL,
  `name_identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `points` int(11) NOT NULL DEFAULT '10'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `achievement`
--

INSERT INTO `achievement` (`idAchievement`, `name_identifier`, `points`) VALUES
(1, 'founder', 100),
(2, 'last_challenge', 100),
(3, 'shining_armor', 100),
(4, 'first_epic', 25),
(5, 'first_legendary', 50),
(6, 'finish_dungeon', 30),
(7, 'hangout_with_friends', 10),
(8, 'level_20', 20),
(9, 'level_100', 50),
(10, 'craft_item', 5),
(11, 'social_adventurer', 10),
(12, 'experienced_fight_master', 50),
(13, 'addict_fight_master', 100),
(14, 'craft_level_20', 20),
(15, 'craft_level_100', 50);

-- --------------------------------------------------------

--
-- Structure de la table `appearances`
--

CREATE TABLE `appearances` (
  `idAppearance` int(10) UNSIGNED NOT NULL,
  `link` text NOT NULL,
  `idAppearanceType` int(10) UNSIGNED NOT NULL,
  `idBodyType` int(10) UNSIGNED DEFAULT NULL,
  `canBeDisplayedOnTop` tinyint(4) NOT NULL DEFAULT '1',
  `maskLink` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `appearances`
--

INSERT INTO `appearances` (`idAppearance`, `link`, `idAppearanceType`, `idBodyType`, `canBeDisplayedOnTop`, `maskLink`) VALUES
(1, 'https://cdn.fight-rpg.com/images/appearances/base/ears/human.png', 1, NULL, 0, NULL),
(2, 'https://cdn.fight-rpg.com/images/appearances/base/ears/orchish.png', 1, NULL, 0, NULL),
(3, 'https://cdn.fight-rpg.com/images/appearances/base/ears/elf.png', 1, NULL, 0, NULL),
(4, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/00_02.png', 2, NULL, 1, NULL),
(5, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/01_02.png', 2, NULL, 1, NULL),
(6, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/02_02.png', 2, NULL, 1, NULL),
(7, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/03_02.png', 2, NULL, 1, NULL),
(8, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/04_02.png', 2, NULL, 1, NULL),
(9, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/05_02.png', 2, NULL, 1, NULL),
(10, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/06_02.png', 2, NULL, 1, NULL),
(11, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/07_02.png', 2, NULL, 1, NULL),
(12, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/08_02.png', 2, NULL, 1, NULL),
(13, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/09_02.png', 2, NULL, 1, NULL),
(14, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/10_02.png', 2, NULL, 1, NULL),
(15, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/11_02.png', 2, NULL, 1, NULL),
(16, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/12_02.png', 2, NULL, 1, NULL),
(17, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/13_02.png', 2, NULL, 1, NULL),
(18, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/14_02.png', 2, NULL, 1, NULL),
(19, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/15_02.png', 2, NULL, 1, NULL),
(20, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/00_01.png', 3, NULL, 1, NULL),
(21, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/01_01.png', 3, NULL, 1, NULL),
(22, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/02_01.png', 3, NULL, 1, NULL),
(23, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/03_01.png', 3, NULL, 1, NULL),
(24, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/04_01.png', 3, NULL, 1, NULL),
(25, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/05_01.png', 3, NULL, 1, NULL),
(26, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/06_01.png', 3, NULL, 1, NULL),
(27, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/07_01.png', 3, NULL, 1, NULL),
(28, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/08_01.png', 3, NULL, 1, NULL),
(29, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/09_01.png', 3, NULL, 1, NULL),
(30, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/10_01.png', 3, NULL, 1, NULL),
(31, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/11_01.png', 3, NULL, 1, NULL),
(32, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/12_01.png', 3, NULL, 1, NULL),
(33, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/13_01.png', 3, NULL, 1, NULL),
(34, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/14_01.png', 3, NULL, 1, NULL),
(35, 'https://cdn.fight-rpg.com/images/appearances/base/eyes/15_01.png', 3, NULL, 1, NULL),
(36, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/00.png', 4, NULL, 1, NULL),
(37, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/01.png', 4, NULL, 1, NULL),
(38, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/02.png', 4, NULL, 1, NULL),
(39, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/03.png', 4, NULL, 1, NULL),
(40, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/04.png', 4, NULL, 1, NULL),
(41, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/05.png', 4, NULL, 1, NULL),
(42, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/06.png', 4, NULL, 1, NULL),
(43, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/07.png', 4, NULL, 1, NULL),
(44, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/08.png', 4, NULL, 1, NULL),
(45, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/09.png', 4, NULL, 1, NULL),
(46, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/10.png', 4, NULL, 1, NULL),
(47, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/11.png', 4, NULL, 1, NULL),
(48, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/12.png', 4, NULL, 1, NULL),
(49, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/13.png', 4, NULL, 1, NULL),
(50, 'https://cdn.fight-rpg.com/images/appearances/base/eyebrows/14.png', 4, NULL, 1, NULL),
(51, 'https://cdn.fight-rpg.com/images/appearances/base/noses/00.png', 5, NULL, 1, NULL),
(52, 'https://cdn.fight-rpg.com/images/appearances/base/noses/01.png', 5, NULL, 1, NULL),
(53, 'https://cdn.fight-rpg.com/images/appearances/base/noses/02.png', 5, NULL, 1, NULL),
(54, 'https://cdn.fight-rpg.com/images/appearances/base/noses/03.png', 5, NULL, 1, NULL),
(55, 'https://cdn.fight-rpg.com/images/appearances/base/noses/04.png', 5, NULL, 1, NULL),
(56, 'https://cdn.fight-rpg.com/images/appearances/base/noses/05.png', 5, NULL, 1, NULL),
(57, 'https://cdn.fight-rpg.com/images/appearances/base/noses/06.png', 5, NULL, 1, NULL),
(58, 'https://cdn.fight-rpg.com/images/appearances/base/noses/07.png', 5, NULL, 1, NULL),
(59, 'https://cdn.fight-rpg.com/images/appearances/base/noses/08.png', 5, NULL, 1, NULL),
(60, 'https://cdn.fight-rpg.com/images/appearances/base/noses/09.png', 5, NULL, 1, NULL),
(61, 'https://cdn.fight-rpg.com/images/appearances/base/noses/10.png', 5, NULL, 1, NULL),
(62, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/00.png', 6, 1, 1, NULL),
(63, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/01.png', 6, 1, 1, NULL),
(64, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/02.png', 6, NULL, 1, NULL),
(65, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/03.png', 6, NULL, 1, NULL),
(66, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/04.png', 6, 1, 1, NULL),
(67, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/05.png', 6, 1, 1, NULL),
(68, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/06.png', 6, 1, 1, NULL),
(69, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/07.png', 6, 1, 1, NULL),
(70, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/08.png', 6, NULL, 1, NULL),
(71, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/09.png', 6, NULL, 1, NULL),
(72, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/10.png', 6, 1, 1, NULL),
(73, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/11.png', 6, NULL, 1, NULL),
(74, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/12.png', 6, NULL, 1, NULL),
(75, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/13.png', 6, 1, 1, NULL),
(76, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/14.png', 6, NULL, 1, NULL),
(77, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/15.png', 6, 1, 1, NULL),
(78, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/16.png', 6, NULL, 1, NULL),
(79, 'https://cdn.fight-rpg.com/images/appearances/base/facialhairs/17.png', 6, 1, 1, NULL),
(80, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/00.png', 7, NULL, 1, NULL),
(81, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/01.png', 7, NULL, 1, NULL),
(82, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/02.png', 7, NULL, 1, NULL),
(83, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/03.png', 7, NULL, 1, NULL),
(84, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/04.png', 7, NULL, 1, NULL),
(85, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/05.png', 7, NULL, 1, NULL),
(86, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/06.png', 7, NULL, 1, NULL),
(87, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/07.png', 7, NULL, 1, NULL),
(88, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/08.png', 7, NULL, 1, NULL),
(89, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/09.png', 7, NULL, 1, NULL),
(90, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/10.png', 7, NULL, 1, NULL),
(91, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/11.png', 7, NULL, 1, NULL),
(92, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/12.png', 7, NULL, 1, NULL),
(93, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/13.png', 7, NULL, 1, NULL),
(94, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/14.png', 7, NULL, 1, NULL),
(95, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/15.png', 7, NULL, 1, NULL),
(96, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/16.png', 7, NULL, 1, NULL),
(97, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/17.png', 7, NULL, 1, NULL),
(98, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/18.png', 7, NULL, 1, NULL),
(99, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/19.png', 7, NULL, 1, NULL),
(100, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/20.png', 7, NULL, 1, NULL),
(101, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/21.png', 7, NULL, 1, NULL),
(102, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/22.png', 7, NULL, 1, NULL),
(103, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/23.png', 7, NULL, 1, NULL),
(104, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/24.png', 7, NULL, 1, NULL),
(105, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/25.png', 7, NULL, 1, NULL),
(106, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/04_back.png', 8, NULL, 1, NULL),
(107, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/05_back.png', 8, NULL, 1, NULL),
(108, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/11_back.png', 8, NULL, 1, NULL),
(109, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/13_back.png', 8, NULL, 1, NULL),
(110, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/14_back.png', 8, NULL, 1, NULL),
(111, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/15_back.png', 8, NULL, 1, NULL),
(112, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/16_back.png', 8, NULL, 1, NULL),
(113, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/17_back.png', 8, NULL, 1, NULL),
(114, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/19_back.png', 8, NULL, 1, NULL),
(115, 'https://cdn.fight-rpg.com/images/appearances/base/hairs/20_back.png', 8, NULL, 1, NULL),
(116, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/03_back.png', 9, NULL, 1, NULL),
(117, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/06_back.png', 9, NULL, 1, NULL),
(118, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/07_back.png', 9, NULL, 1, NULL),
(119, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/00.png', 10, NULL, 1, NULL),
(120, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/01.png', 10, NULL, 1, NULL),
(121, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/02.png', 10, NULL, 1, NULL),
(122, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/03.png', 10, NULL, 1, NULL),
(123, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/04.png', 10, NULL, 1, NULL),
(124, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/05.png', 10, NULL, 1, NULL),
(125, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/06.png', 10, NULL, 1, NULL),
(126, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/07.png', 10, NULL, 1, NULL),
(127, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/08.png', 10, NULL, 1, NULL),
(128, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/09.png', 10, NULL, 1, NULL),
(129, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/10.png', 10, NULL, 1, NULL),
(130, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/11.png', 10, NULL, 1, NULL),
(131, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/12.png', 10, NULL, 1, NULL),
(132, 'https://cdn.fight-rpg.com/images/appearances/base/mouths/13.png', 10, NULL, 1, NULL),
(133, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2000_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(134, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2000_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(135, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2000_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(136, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2000_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(137, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2001_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(138, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2001_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(139, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2002_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(140, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2002_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(141, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003%20Mask_wrist_left.png'),
(142, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003%20Mask_hand_left.png'),
(143, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003%20Mask_wrist_right.png'),
(144, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2003%20Mask_hand_right.png'),
(145, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004%20Mask_wrist_left.png'),
(146, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004%20Mask_hand_left.png'),
(147, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004%20Mask_wrist_right.png'),
(148, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2004%20Mask_hand_right.png'),
(149, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005%20Mask_wrist_left.png'),
(150, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005%20Mask_hand_left.png'),
(151, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005%20Mask_wrist_right.png'),
(152, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2005%20Mask_hand_right.png'),
(153, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2006_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2006%20Mask_hand_left.png'),
(154, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2006_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2006%20Mask_hand_right.png'),
(155, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007%20Mask_wrist_left.png'),
(156, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007%20Mask_hand_left.png'),
(157, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007%20Mask_wrist_right.png'),
(158, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2007%20Mask_hand_right.png'),
(159, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008%20Mask_wrist_left.png'),
(160, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008%20Mask_hand_left.png'),
(161, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008%20Mask_wrist_right.png'),
(162, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2008%20Mask_hand_right.png'),
(163, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009%20Mask_wrist_left.png'),
(164, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009%20Mask_hand_left.png'),
(165, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009%20Mask_wrist_right.png'),
(166, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2009%20Mask_hand_right.png'),
(167, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010%20Mask_wrist_left.png'),
(168, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010%20Mask_hand_left.png'),
(169, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010%20Mask_wrist_right.png'),
(170, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%2010%20Mask_hand_right.png'),
(171, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves%20Mask_wrist_left.png'),
(172, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves%20Mask_hand_left.png'),
(173, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves%20Mask_wrist_right.png'),
(174, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2001%20Gloves%20Mask_hand_right.png'),
(175, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves%20Mask_wrist_left.png'),
(176, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves%20Mask_hand_left.png'),
(177, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves%20Mask_wrist_right.png'),
(178, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2002%20Gloves%20Mask_hand_right.png'),
(179, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves%20Mask_wrist_left.png'),
(180, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves%20Mask_hand_left.png'),
(181, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves%20Mask_wrist_right.png'),
(182, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2003%20Gloves%20Mask_hand_right.png'),
(183, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves%20Mask_wrist_left.png'),
(184, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves%20Mask_hand_left.png'),
(185, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves%20Mask_wrist_right.png'),
(186, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2004%20Gloves%20Mask_hand_right.png'),
(187, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves_wrist_left.png', 11, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves%20Mask_wrist_left.png'),
(188, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves_hand_left.png', 12, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves%20Mask_hand_left.png'),
(189, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves_wrist_right.png', 13, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves%20Mask_wrist_right.png'),
(190, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves_hand_right.png', 14, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/gloves/Fantasy%20Set%2005%20Gloves%20Mask_hand_right.png'),
(191, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2000_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(192, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2001_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(193, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2002_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2002%20Mask_front.png'),
(194, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2003_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2003%20Mask_front.png'),
(195, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2004_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(196, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2005_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2005%20Mask_front.png'),
(197, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2006_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2006%20Mask_front.png'),
(198, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2007_back.png', 15, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(199, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2007_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(200, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2008_back.png', 15, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2008%20Mask_back.png'),
(201, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2008_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2008%20Mask_front.png'),
(202, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2009_back.png', 15, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2009%20Mask_back.png'),
(203, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2009_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2009%20Mask_front.png'),
(204, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2010_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(205, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2011_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(206, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2012_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2012%20Mask_front.png'),
(207, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2013_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2013%20Mask_front.png'),
(208, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2014_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2014%20Mask_front.png'),
(209, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2015_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2015%20Mask_front.png'),
(210, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2016_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2016%20Mask_front.png'),
(211, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2017_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2017%20Mask_front.png'),
(212, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2018_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2018%20Mask_front.png'),
(213, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2019_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2019%20Mask_front.png'),
(214, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2020_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2020%20Mask_front.png'),
(215, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2021_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%2021%20Mask_front.png'),
(216, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2001%20Helm_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2001%20Helm%20Mask_front.png'),
(217, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Male_front.png  ', 16, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Male%20Mask_front.png'),
(218, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Female_back.png ', 15, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Female%20Mask_back.png'),
(219, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Female_front.png', 16, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2002%20Helm%20Female%20Mask_front.png'),
(220, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2003%20Helm_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2003%20Helm%20Mask_front.png'),
(221, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2004%20Hood_back.png', 15, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2004%20Hood%20Mask_back.png'),
(222, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2004%20Hood_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2004%20Hood%20Mask_front.png'),
(223, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2005%20Helm_front.png', 16, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/helmets/Fantasy%20Set%2005%20Helm%20Mask_front.png'),
(224, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female%20Mask_body.png'),
(225, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female%20Mask_upper_left.png'),
(226, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Female%20Mask_upper_right.png'),
(227, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male%20Mask_body.png'),
(228, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male%20Mask_upper_left.png'),
(229, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2001%20Male%20Mask_upper_right.png'),
(230, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female%20Mask_body.png'),
(231, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female%20Mask_upper_left.png'),
(232, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Female%20Mask_upper_right.png'),
(233, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male%20Mask_body.png'),
(234, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male%20Mask_upper_left.png'),
(235, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2002%20Male%20Mask_upper_right.png'),
(236, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female%20Mask_body.png'),
(237, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female%20Mask_upper_left.png'),
(238, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Female%20Mask_upper_right.png'),
(239, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_body.png'),
(240, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_lower_left.png'),
(241, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_lower_right.png'),
(242, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_upper_left.png'),
(243, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2003%20Male%20Mask_upper_right.png'),
(244, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_body.png'),
(245, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_neck.png', 18, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_neck.png'),
(246, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_lower_left.png'),
(247, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_lower_right.png'),
(248, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_upper_left.png'),
(249, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Female%20Mask_upper_right.png'),
(250, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_body.png'),
(251, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_lower_left.png'),
(252, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_lower_right.png'),
(253, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_upper_left.png'),
(254, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2004%20Male%20Mask_upper_right.png'),
(255, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(256, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_neck.png', 18, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(257, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(258, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(259, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(260, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(261, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_body.png'),
(262, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_lower_left.png'),
(263, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_lower_right.png'),
(264, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_upper_left.png'),
(265, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2005%20Male%20Mask_upper_right.png'),
(266, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_body.png'),
(267, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_neck.png', 18, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_neck.png'),
(268, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_lower_left.png'),
(269, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_lower_right.png'),
(270, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_upper_left.png'),
(271, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Female%20Mask_upper_right.png'),
(272, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_body.png'),
(273, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_lower_left.png'),
(274, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_lower_right.png'),
(275, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_upper_left.png'),
(276, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2006%20Male%20Mask_upper_right.png'),
(277, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_body.png'),
(278, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_neck.png', 18, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_neck.png'),
(279, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_lower_left.png'),
(280, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_lower_right.png'),
(281, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_upper_left.png'),
(282, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Female%20Mask_upper_right.png'),
(283, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_body.png'),
(284, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_neck.png', 18, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_neck.png'),
(285, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_lower_left.png'),
(286, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_lower_right.png'),
(287, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_upper_left.png'),
(288, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2007%20Male%20Mask_upper_right.png'),
(289, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female%20Mask_body.png'),
(290, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female%20Mask_upper_left.png'),
(291, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Female%20Mask_upper_right.png'),
(292, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male%20Mask_body.png'),
(293, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male%20Mask_upper_left.png'),
(294, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2008%20Male%20Mask_upper_right.png'),
(295, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_body.png'),
(296, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_lower_left.png'),
(297, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_lower_right.png'),
(298, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_upper_left.png'),
(299, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Female%20Mask_upper_right.png'),
(300, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_body.png'),
(301, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_lower_left.png'),
(302, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_lower_right.png'),
(303, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_upper_left.png'),
(304, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2009%20Male%20Mask_upper_right.png'),
(305, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_body.png'),
(306, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_neck.png', 18, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_neck.png'),
(307, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_lower_left.png'),
(308, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_lower_right.png'),
(309, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_upper_left.png'),
(310, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Female%20Mask_upper_right.png'),
(311, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_body.png'),
(312, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_lower_left.png'),
(313, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_lower_right.png'),
(314, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_upper_left.png'),
(315, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%2010%20Male%20Mask_upper_right.png'),
(316, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_body.png'),
(317, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_neck.png', 18, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_neck.png'),
(318, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_lower_left.png'),
(319, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_lower_right.png'),
(320, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_upper_left.png'),
(321, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Female%20Mask_upper_right.png'),
(322, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_body.png'),
(323, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_neck.png', 18, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_neck.png');
INSERT INTO `appearances` (`idAppearance`, `link`, `idAppearanceType`, `idBodyType`, `canBeDisplayedOnTop`, `maskLink`) VALUES
(324, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_lower_left.png'),
(325, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_lower_right.png'),
(326, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_upper_left.png'),
(327, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2001%20Armor%20Male%20Mask_upper_right.png'),
(328, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female%20Mask_body.png'),
(329, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female_neck.png', 18, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female%20Mask_neck.png'),
(330, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Female%20Mask_upper_left.png'),
(331, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male%20Mask_body.png'),
(332, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male%20Mask_upper_left.png'),
(333, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2002%20Armor%20Male%20Mask_upper_right.png'),
(334, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_body.png'),
(335, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_neck.png', 18, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(336, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_lower_left.png'),
(337, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_lower_right.png'),
(338, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_upper_left.png'),
(339, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Female%20Mask_upper_right.png'),
(340, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_body.png'),
(341, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_neck.png', 18, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_neck.png'),
(342, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_lower_left.png'),
(343, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_lower_right.png'),
(344, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_upper_left.png'),
(345, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2003%20Armor%20Male%20Mask_upper_right.png'),
(346, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female%20Mask_body.png'),
(347, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female%20Mask_lower_right.png'),
(348, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female%20Mask_upper_left.png'),
(349, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Female%20Mask_upper_right.png'),
(350, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_body.png'),
(351, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_lower_left.png'),
(352, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_lower_right.png'),
(353, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_upper_left.png'),
(354, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2004%20Armor%20Male%20Mask_upper_right.png'),
(355, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_body.png', 17, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_body.png'),
(356, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_lower_left.png', 19, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_lower_left.png'),
(357, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_lower_right.png', 20, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_lower_right.png'),
(358, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_upper_left.png', 21, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_upper_left.png'),
(359, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female_upper_right.png', 22, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Female%20Mask_upper_right.png'),
(360, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_body.png', 17, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_body.png'),
(361, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_neck.png', 18, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_neck.png'),
(362, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_lower_left.png', 19, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_lower_left.png'),
(363, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_lower_right.png', 20, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_lower_right.png'),
(364, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_upper_left.png', 21, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_upper_left.png'),
(365, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male_upper_right.png', 22, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/armors/Fantasy%20Set%2005%20Armor%20Male%20Mask_upper_right.png'),
(366, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(367, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(368, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(369, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(370, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(371, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(372, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(373, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(374, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(375, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2000%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(376, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_hip.png'),
(377, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_lower_left.png'),
(378, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_lower_right.png'),
(379, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_upper_left.png'),
(380, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Female%20Mask_upper_right.png'),
(381, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_hip.png'),
(382, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_lower_left.png'),
(383, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_lower_right.png'),
(384, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_upper_left.png'),
(385, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2001%20Male%20Mask_upper_right.png'),
(386, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_hip.png'),
(387, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_lower_left.png'),
(388, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_lower_right.png'),
(389, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_upper_left.png'),
(390, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Female%20Mask_upper_right.png'),
(391, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_hip.png'),
(392, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_lower_left.png'),
(393, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_lower_right.png'),
(394, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_upper_left.png'),
(395, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2002%20Male%20Mask_upper_right.png'),
(396, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_hip.png'),
(397, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_lower_left.png'),
(398, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_lower_right.png'),
(399, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_upper_left.png'),
(400, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Female%20Mask_upper_right.png'),
(401, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_hip.png'),
(402, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_lower_left.png'),
(403, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_lower_right.png'),
(404, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_upper_left.png'),
(405, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2003%20Male%20Mask_upper_right.png'),
(406, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(407, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(408, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(409, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(410, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(411, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_hip.png'),
(412, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_lower_left.png'),
(413, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_lower_right.png'),
(414, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_upper_left.png'),
(415, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2004%20Male%20Mask_upper_right.png'),
(416, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_hip.png'),
(417, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_lower_left.png'),
(418, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_lower_right.png'),
(419, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_upper_left.png'),
(420, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_upper_right.png'),
(421, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_hip.png'),
(422, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_lower_left.png'),
(423, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_lower_right.png'),
(424, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_upper_left.png'),
(425, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Male%20Mask_upper_right.png'),
(426, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_hip.png'),
(427, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_lower_left.png'),
(428, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_lower_right.png'),
(429, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_upper_left.png'),
(430, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2005%20Female%20Mask_upper_right.png'),
(431, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_hip.png'),
(432, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_lower_left.png'),
(433, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_lower_right.png'),
(434, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_upper_left.png'),
(435, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2006%20Male%20Mask_upper_right.png'),
(436, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_hip.png'),
(437, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_lower_left.png'),
(438, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_lower_right.png'),
(439, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_upper_left.png'),
(440, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Female%20Mask_upper_right.png'),
(441, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_hip.png'),
(442, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_lower_left.png'),
(443, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_lower_right.png'),
(444, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_upper_left.png'),
(445, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2007%20Male%20Mask_upper_right.png'),
(446, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_hip.png'),
(447, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_lower_left.png'),
(448, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_lower_right.png'),
(449, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_upper_left.png'),
(450, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Female%20Mask_upper_right.png'),
(451, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_hip.png'),
(452, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_lower_left.png'),
(453, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_lower_right.png'),
(454, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_upper_left.png'),
(455, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2008%20Male%20Mask_upper_right.png'),
(456, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_hip.png'),
(457, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_lower_left.png'),
(458, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_lower_right.png'),
(459, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_upper_left.png'),
(460, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_upper_right.png'),
(461, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_hip.png'),
(462, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_lower_left.png'),
(463, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_lower_right.png'),
(464, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_upper_left.png'),
(465, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Male%20Mask_upper_right.png'),
(466, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female%20Mask_hip.png'),
(467, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female%20Mask_upper_left.png'),
(468, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Female%20Mask_upper_right.png'),
(469, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_hip.png'),
(470, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_lower_left.png'),
(471, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_lower_right.png'),
(472, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_upper_left.png'),
(473, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2010%20Male%20Mask_upper_right.png'),
(474, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_hip.png'),
(475, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_lower_left.png'),
(476, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_lower_right.png'),
(477, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_upper_left.png'),
(478, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Female%20Mask_upper_right.png'),
(479, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_hip.png'),
(480, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_lower_left.png'),
(481, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_lower_right.png'),
(482, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_upper_left.png'),
(483, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2001%20Male%20Mask_upper_right.png'),
(484, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female%20Mask_hip.png'),
(485, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female%20Mask_upper_left.png'),
(486, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Female%20Mask_upper_right.png'),
(487, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male%20Mask_hip.png'),
(488, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male%20Mask_upper_left.png'),
(489, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2002%20Male%20Mask_upper_right.png'),
(490, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_hip.png'),
(491, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_lower_left.png'),
(492, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_lower_right.png'),
(493, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_upper_left.png'),
(494, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Female%20Mask_upper_right.png'),
(495, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_hip.png'),
(496, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_lower_left.png'),
(497, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_lower_right.png'),
(498, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_upper_left.png'),
(499, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2003%20Male%20Mask_upper_right.png'),
(500, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_hip.png'),
(501, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_lower_left.png'),
(502, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_lower_right.png'),
(503, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_upper_left.png'),
(504, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Female%20Mask_upper_right.png'),
(505, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_hip.png'),
(506, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_lower_left.png'),
(507, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_lower_right.png'),
(508, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_upper_left.png'),
(509, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2004%20Male%20Mask_upper_right.png'),
(510, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_hip.png'),
(511, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_lower_left.png'),
(512, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_lower_right.png'),
(513, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_upper_left.png'),
(514, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Female%20Mask_upper_right.png'),
(515, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_hip.png', 23, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_hip.png'),
(516, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_lower_left.png', 24, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_lower_left.png'),
(517, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_lower_right.png', 25, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_lower_right.png'),
(518, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_upper_left.png', 26, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_upper_left.png'),
(519, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male_upper_right.png', 27, 1, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%20Set%2005%20Male%20Mask_upper_right.png'),
(520, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2000_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(521, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2000_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(522, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2001_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(523, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2001_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(524, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2002_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2002%20Mask_foot_left.png'),
(525, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2002_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2002%20Mask_foot_right.png'),
(526, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003%20Mask_lower_left.png'),
(527, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003%20Mask_lower_right.png'),
(528, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003%20Mask_foot_left.png'),
(529, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2003%20Mask_foot_right.png'),
(530, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2004_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(531, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2004_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(532, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2004_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(533, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2004_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(534, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005%20Mask_lower_left.png'),
(535, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005%20Mask_lower_right.png'),
(536, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005%20Mask_foot_left.png'),
(537, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2005%20Mask_foot_right.png'),
(538, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006%20Mask_lower_left.png'),
(539, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006%20Mask_lower_right.png'),
(540, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006%20Mask_foot_left.png'),
(541, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2006%20Mask_foot_right.png'),
(542, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007%20Mask_lower_left.png'),
(543, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007%20Mask_lower_right.png'),
(544, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007%20Mask_foot_left.png'),
(545, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2007%20Mask_foot_right.png'),
(546, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008%20Mask_lower_left.png'),
(547, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008%20Mask_lower_right.png'),
(548, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008%20Mask_foot_left.png'),
(549, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2008%20Mask_foot_right.png'),
(550, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009%20Mask_lower_left.png'),
(551, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009%20Mask_lower_right.png'),
(552, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009%20Mask_foot_left.png'),
(553, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2009%20Mask_foot_right.png'),
(554, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010%20Mask_lower_left.png'),
(555, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010%20Mask_lower_right.png'),
(556, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010%20Mask_foot_left.png'),
(557, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%2010%20Mask_foot_right.png'),
(558, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2001_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2001%20Mask_foot_left.png'),
(559, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2001_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2001%20Mask_foot_right.png'),
(560, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002%20Mask_lower_left.png'),
(561, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002%20Mask_lower_right.png'),
(562, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002%20Mask_foot_left.png'),
(563, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2002%20Mask_foot_right.png'),
(564, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003%20Mask_lower_left.png'),
(565, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003%20Mask_lower_right.png'),
(566, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003%20Mask_foot_left.png'),
(567, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2003%20Mask_foot_right.png'),
(568, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004%20Mask_lower_left.png'),
(569, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004%20Mask_lower_right.png');
INSERT INTO `appearances` (`idAppearance`, `link`, `idAppearanceType`, `idBodyType`, `canBeDisplayedOnTop`, `maskLink`) VALUES
(570, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004%20Mask_foot_left.png'),
(571, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2004%20Mask_foot_right.png'),
(572, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005_lower_left.png', 28, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005%20Mask_lower_left.png'),
(573, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005_lower_right.png', 29, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005%20Mask_lower_right.png'),
(574, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005_foot_left.png', 30, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005%20Mask_foot_left.png'),
(575, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005_foot_right.png', 31, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/boots/Fantasy%20Set%2005%20Mask_foot_right.png'),
(576, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_hip.png', 23, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_hip.png'),
(577, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_lower_left.png', 24, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_lower_left.png'),
(578, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_lower_right.png', 25, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_lower_right.png'),
(579, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_upper_left.png', 26, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_upper_left.png'),
(580, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female_real_upper_right.png', 27, 2, 1, 'https://cdn.fight-rpg.com/images/appearances/pants/Fantasy%2009%20Female%20Mask_real_upper_right.png'),
(581, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2000.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2000%20Mask.png'),
(582, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2001.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2001%20Mask.png'),
(583, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2002.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Axe%2002%20Mask.png'),
(584, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2000.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2000%20Mask.png'),
(585, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2001.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2001%20Mask.png'),
(586, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2002.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2002%20Mask.png'),
(587, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2003.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Dagger%2003%20Mask.png'),
(588, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2000.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2000%20Mask.png'),
(589, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2001.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2001%20Mask.png'),
(590, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2002.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2002%20Mask.png'),
(591, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2003.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Sword%2003%20Mask.png'),
(592, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2000.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2000%20Mask.png'),
(593, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2001.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2001%20Mask.png'),
(594, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2002.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2002%20Mask.png'),
(595, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2003.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2003%20Mask.png'),
(596, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2004.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/one_handed/Wand%2004%20Mask.png'),
(597, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2000.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(598, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2001.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2001%20Mask.png'),
(599, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2002.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2002%20Mask.png'),
(600, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2003.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2003%20Mask.png'),
(601, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2004.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/two_handed/Staff%2004%20Mask.png'),
(602, 'https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2000.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2000%20Mask.png'),
(603, 'https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2001.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2001%20Mask.png'),
(604, 'https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2002.png', 32, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/two_handed/War%20Hammer%2002%20Mask.png'),
(605, 'https://cdn.fight-rpg.com/images/appearances/bows/Bow%2000.png', 35, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/misc/all_mask.png'),
(606, 'https://cdn.fight-rpg.com/images/appearances/bows/Bow%2001.png', 35, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/bows/Bow%2001%20Mask.png'),
(607, 'https://cdn.fight-rpg.com/images/appearances/bows/Bow%2002.png', 35, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/bows/Bow%2002%20Mask.png'),
(608, 'https://cdn.fight-rpg.com/images/appearances/bows/Bow%2003.png', 35, NULL, 1, 'https://cdn.fight-rpg.com/images/appearances/bows/Bow%2003%20Mask.png');

-- --------------------------------------------------------

--
-- Structure de la table `appearancestype`
--

CREATE TABLE `appearancestype` (
  `idAppearanceType` int(10) UNSIGNED NOT NULL,
  `propertyName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `appearancestype`
--

INSERT INTO `appearancestype` (`idAppearanceType`, `propertyName`) VALUES
(1, 'ear'),
(2, 'eyes.front'),
(3, 'eyes.back'),
(4, 'eyebrow'),
(5, 'nose'),
(6, 'facialHair'),
(7, 'hair.front'),
(8, 'hair.back'),
(9, 'mouth.teeths'),
(10, 'mouth.lips'),
(11, 'gloves.left.wrist'),
(12, 'gloves.left.hand'),
(13, 'gloves.right.wrist'),
(14, 'gloves.right.hand'),
(15, 'helmet.back'),
(16, 'helmet.front'),
(17, 'armor.body'),
(18, 'armor.neck'),
(19, 'armor.lower_left'),
(20, 'armor.lower_right'),
(21, 'armor.upper_left'),
(22, 'armor.upper_right'),
(23, 'pants.hip'),
(24, 'pants.lower_left'),
(25, 'pants.lower_right'),
(26, 'pants.upper_left'),
(27, 'pants.upper_right'),
(28, 'boots.lower_left'),
(29, 'boots.lower_right'),
(30, 'boots.foot_left'),
(31, 'boots.foot_right'),
(32, 'weapon.main'),
(33, 'weapon.offhand'),
(34, 'weapon.shield'),
(35, 'weapon.bow');

-- --------------------------------------------------------

--
-- Structure de la table `areas`
--

CREATE TABLE `areas` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `AreaImage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'https://cdn.pixabay.com/photo/2013/04/06/11/50/image-editing-101040_960_720.jpg',
  `idAreaType` int(10) UNSIGNED NOT NULL,
  `AreaLevel` int(10) UNSIGNED NOT NULL,
  `statPoints` int(10) UNSIGNED NOT NULL DEFAULT '5'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areas`
--

INSERT INTO `areas` (`idArea`, `AreaImage`, `idAreaType`, `AreaLevel`, `statPoints`) VALUES
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
(34, 'https://bnetcmsus-a.akamaihd.net/cms/gallery/A0IFUJNHQ73S1421193822596.jpg', 2, 1, 0),
(35, 'https://i.ytimg.com/vi/qTJ8skYIpJc/maxresdefault.jpg', 3, 1, 5),
(36, 'https://image.freepik.com/free-vector/cave-with-entrance_1308-17047.jpg', 3, 1, 5),
(37, 'https://cdn.fight-rpg.com/images/areas/TombEntrance.jpg', 3, 1, 5),
(38, 'https://pbs.twimg.com/media/ES7MkdgXsAARRjR.jpg', 3, 1, 5),
(39, 'https://cdn.clipart.email/694fdbe27e5c77d81560e5bb593d73fd_ice-cave-doodles-4-4-by-lastkrystaldragon-on-deviantart_1024-682.png', 3, 1, 5);

-- --------------------------------------------------------

--
-- Structure de la table `areasbonuses`
--

CREATE TABLE `areasbonuses` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idBonusTypes` int(10) UNSIGNED NOT NULL,
  `value` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasbonuses`
--

INSERT INTO `areasbonuses` (`idArea`, `idBonusTypes`, `value`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `areasclimates`
--

CREATE TABLE `areasclimates` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idClimate` int(10) UNSIGNED NOT NULL,
  `currentWeather` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `intensity` int(10) UNSIGNED NOT NULL DEFAULT '100'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasclimates`
--

INSERT INTO `areasclimates` (`idArea`, `idClimate`, `currentWeather`, `intensity`) VALUES
(1, 1, 1, 100),
(2, 1, 1, 100),
(3, 1, 1, 100),
(4, 1, 1, 100),
(5, 1, 1, 100),
(6, 1, 1, 100),
(7, 5, 1, 100),
(8, 1, 1, 100),
(9, 1, 1, 100),
(10, 1, 1, 100),
(11, 5, 1, 100),
(12, 1, 1, 100),
(13, 1, 1, 100),
(14, 1, 1, 100),
(15, 3, 1, 100),
(16, 3, 1, 100),
(17, 3, 1, 100),
(18, 3, 1, 100),
(19, 3, 1, 100),
(20, 3, 1, 100),
(21, 5, 1, 100),
(22, 2, 1, 100),
(23, 2, 1, 100),
(24, 2, 1, 100),
(25, 2, 1, 100),
(26, 2, 1, 100),
(27, 5, 1, 100),
(28, 4, 1, 100),
(29, 4, 1, 100),
(30, 4, 1, 100),
(31, 4, 1, 100),
(32, 4, 1, 100),
(33, 5, 1, 100),
(34, 4, 1, 100),
(35, 2, 1, 100),
(36, 5, 1, 100),
(37, 5, 1, 100),
(38, 2, 1, 100),
(39, 4, 1, 100);

-- --------------------------------------------------------

--
-- Structure de la table `areasitems`
--

CREATE TABLE `areasitems` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `percentage` float UNSIGNED NOT NULL DEFAULT '0',
  `min` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `max` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasitems`
--

INSERT INTO `areasitems` (`idArea`, `idBaseItem`, `percentage`, `min`, `max`) VALUES
(9, 38, 0.007, 1, 1),
(10, 38, 0.007, 1, 1),
(11, 38, 0.007, 1, 1),
(12, 38, 0.007, 1, 1),
(13, 38, 0.007, 1, 1),
(17, 39, 0.003, 1, 1),
(18, 39, 0.003, 1, 1),
(19, 39, 0.003, 1, 1),
(20, 39, 0.003, 1, 1),
(21, 39, 0.003, 1, 1),
(27, 40, 0.0005, 1, 1),
(33, 49, 0.002, 25, 50),
(33, 56, 0.0001, 1, 1),
(37, 39, 0.003, 1, 1),
(38, 40, 0.0005, 1, 1),
(39, 56, 0.0001, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `areaslevels`
--

CREATE TABLE `areaslevels` (
  `idAreaLevel` int(10) UNSIGNED NOT NULL,
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT '1000000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areaslevels`
--

INSERT INTO `areaslevels` (`idAreaLevel`, `price`) VALUES
(1, 250000),
(2, 500000),
(3, 750000),
(4, 1000000);

-- --------------------------------------------------------

--
-- Structure de la table `areasmonsters`
--

CREATE TABLE `areasmonsters` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idMonstresGroupe` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasmonsters`
--

INSERT INTO `areasmonsters` (`idArea`, `idMonstresGroupe`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(3, 13),
(3, 14),
(3, 15),
(3, 16),
(3, 17),
(3, 18),
(3, 19),
(3, 20),
(4, 21),
(4, 22),
(4, 23),
(4, 24),
(4, 25),
(4, 26),
(4, 27),
(4, 28),
(7, 29),
(9, 30),
(19, 30),
(20, 30),
(9, 31),
(9, 32),
(10, 33),
(10, 34),
(12, 35),
(12, 36),
(13, 37),
(13, 38),
(13, 39),
(11, 40),
(17, 41),
(17, 42),
(17, 43),
(18, 43),
(17, 44),
(18, 45),
(18, 46),
(18, 47),
(19, 48),
(20, 49),
(19, 50),
(20, 50),
(19, 51),
(20, 52),
(21, 53),
(23, 54),
(23, 55),
(25, 55),
(23, 56),
(25, 56),
(23, 57),
(24, 58),
(24, 59),
(25, 59),
(24, 60),
(24, 61),
(25, 62),
(26, 63),
(26, 64),
(26, 65),
(26, 66),
(27, 67),
(28, 68),
(32, 68),
(28, 69),
(31, 69),
(28, 70),
(32, 70),
(28, 71),
(32, 71),
(30, 72),
(31, 72),
(30, 73),
(32, 73),
(30, 74),
(31, 74),
(30, 75),
(31, 76),
(33, 77),
(35, 78),
(36, 79),
(37, 80),
(38, 81),
(39, 82);

-- --------------------------------------------------------

--
-- Structure de la table `areasmonsterslevels`
--

CREATE TABLE `areasmonsterslevels` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `minLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `maxLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `minRebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `maxRebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasmonsterslevels`
--

INSERT INTO `areasmonsterslevels` (`idArea`, `minLevel`, `maxLevel`, `minRebirthLevel`, `maxRebirthLevel`) VALUES
(1, 1, 5, 0, 0),
(2, 5, 10, 0, 0),
(3, 10, 15, 0, 0),
(4, 15, 20, 0, 0),
(5, 20, 20, 0, 0),
(6, 1, 1, 0, 0),
(7, 20, 20, 0, 0),
(8, 20, 20, 0, 0),
(9, 20, 25, 0, 0),
(10, 25, 30, 0, 0),
(11, 40, 40, 0, 0),
(12, 30, 35, 0, 0),
(13, 35, 40, 0, 0),
(14, 40, 40, 0, 0),
(15, 40, 40, 0, 0),
(16, 60, 60, 0, 0),
(17, 40, 45, 0, 0),
(18, 45, 50, 0, 0),
(19, 55, 60, 0, 0),
(20, 50, 55, 0, 0),
(21, 60, 60, 0, 0),
(22, 80, 80, 0, 0),
(23, 60, 65, 0, 0),
(24, 65, 70, 0, 0),
(25, 70, 75, 0, 0),
(26, 75, 80, 0, 0),
(27, 80, 80, 0, 0),
(28, 80, 85, 0, 0),
(29, 90, 90, 0, 0),
(30, 85, 90, 0, 0),
(31, 90, 95, 0, 0),
(32, 95, 100, 0, 0),
(33, 100, 100, 0, 0),
(34, 100, 100, 0, 0),
(35, 20, 20, 0, 0),
(36, 40, 40, 0, 0),
(37, 60, 60, 0, 0),
(38, 80, 80, 0, 0),
(39, 100, 100, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `areasowners`
--

CREATE TABLE `areasowners` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idGuild` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `areaspaths`
--

CREATE TABLE `areaspaths` (
  `idArea1` int(10) UNSIGNED NOT NULL,
  `idArea2` int(10) UNSIGNED NOT NULL,
  `time` int(10) UNSIGNED NOT NULL DEFAULT '120',
  `goldPrice` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areaspaths`
--

INSERT INTO `areaspaths` (`idArea1`, `idArea2`, `time`, `goldPrice`) VALUES
(1, 2, 45, 0),
(1, 3, 45, 0),
(1, 6, 30, 0),
(2, 1, 45, 0),
(2, 5, 60, 0),
(3, 1, 45, 0),
(3, 4, 45, 0),
(4, 3, 45, 0),
(4, 5, 60, 0),
(4, 35, 30, 0),
(5, 2, 60, 0),
(5, 4, 60, 0),
(6, 1, 30, 0),
(6, 8, 300, 500),
(7, 4, 1, 0),
(8, 6, 300, 0),
(8, 9, 60, 0),
(9, 8, 60, 0),
(9, 10, 40, 0),
(9, 12, 40, 0),
(9, 13, 60, 0),
(10, 9, 40, 0),
(10, 22, 420, 0),
(10, 36, 30, 0),
(11, 10, 1, 0),
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
(20, 37, 20, 0),
(21, 20, 1, 0),
(22, 10, 420, 0),
(22, 23, 90, 0),
(22, 25, 30, 0),
(22, 28, 600, 0),
(22, 38, 30, 0),
(23, 22, 90, 0),
(23, 24, 30, 0),
(24, 23, 30, 0),
(25, 22, 30, 0),
(25, 26, 30, 0),
(26, 25, 30, 0),
(27, 22, 1, 0),
(28, 22, 600, 0),
(28, 29, 80, 0),
(28, 31, 100, 0),
(29, 28, 80, 0),
(29, 30, 70, 0),
(29, 39, 30, 0),
(30, 29, 70, 0),
(31, 28, 100, 0),
(31, 32, 60, 0),
(31, 34, 350, 0),
(32, 31, 60, 0),
(33, 29, 1, 0),
(34, 31, 350, 0),
(35, 4, 30, 0),
(35, 7, 1, 0),
(36, 10, 30, 0),
(36, 11, 1, 0),
(37, 20, 20, 0),
(37, 21, 1, 0),
(38, 22, 30, 0),
(38, 27, 1, 0),
(39, 29, 30, 0),
(39, 33, 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `areasregions`
--

CREATE TABLE `areasregions` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idRegion` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasregions`
--

INSERT INTO `areasregions` (`idArea`, `idRegion`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(35, 1),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(36, 2),
(15, 3),
(16, 3),
(17, 3),
(18, 3),
(19, 3),
(20, 3),
(21, 3),
(37, 3),
(22, 4),
(23, 4),
(24, 4),
(25, 4),
(26, 4),
(27, 4),
(38, 4),
(28, 5),
(29, 5),
(30, 5),
(31, 5),
(32, 5),
(33, 5),
(34, 5),
(39, 5);

-- --------------------------------------------------------

--
-- Structure de la table `areasrequirements`
--

CREATE TABLE `areasrequirements` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idAchievement` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasrequirements`
--

INSERT INTO `areasrequirements` (`idArea`, `idAchievement`) VALUES
(34, 2);

-- --------------------------------------------------------

--
-- Structure de la table `areasresources`
--

CREATE TABLE `areasresources` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idCollectableResource` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasresources`
--

INSERT INTO `areasresources` (`idArea`, `idCollectableResource`) VALUES
(2, 1),
(12, 1),
(3, 2),
(12, 2),
(2, 3),
(3, 3),
(10, 3),
(12, 3),
(3, 4),
(9, 4),
(13, 4),
(1, 5),
(4, 5),
(9, 5),
(3, 6),
(4, 6),
(13, 6),
(2, 7),
(10, 7),
(2, 8),
(10, 8),
(2, 9),
(10, 9),
(1, 10),
(4, 10),
(9, 10),
(13, 10),
(1, 11),
(9, 11),
(13, 11),
(1, 12),
(4, 12),
(10, 12),
(18, 13),
(17, 14),
(17, 15),
(18, 15),
(19, 16),
(20, 16),
(20, 17),
(19, 18),
(19, 19),
(20, 19),
(19, 20),
(19, 21),
(20, 21),
(18, 22),
(17, 23),
(17, 24),
(23, 25),
(24, 25),
(23, 26),
(24, 26),
(23, 27),
(24, 27),
(25, 28),
(25, 29),
(25, 30),
(26, 31),
(26, 32),
(25, 33),
(26, 33),
(24, 34),
(24, 35),
(24, 36),
(28, 37),
(28, 38),
(28, 39),
(31, 40),
(28, 41),
(32, 41),
(31, 42),
(30, 43),
(31, 44),
(30, 45),
(31, 45),
(30, 46),
(32, 46),
(30, 47),
(32, 48),
(12, 49),
(18, 49),
(23, 49),
(26, 49),
(32, 49);

-- --------------------------------------------------------

--
-- Structure de la table `areasshops`
--

CREATE TABLE `areasshops` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idShop` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areasshops`
--

INSERT INTO `areasshops` (`idArea`, `idShop`) VALUES
(6, 1),
(5, 2),
(8, 3),
(14, 4),
(15, 5),
(16, 6),
(22, 7),
(29, 8),
(34, 9);

-- --------------------------------------------------------

--
-- Structure de la table `areastypes`
--

CREATE TABLE `areastypes` (
  `idAreaType` int(10) UNSIGNED NOT NULL,
  `NomAreaType` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `areastypes`
--

INSERT INTO `areastypes` (`idAreaType`, `NomAreaType`) VALUES
(1, 'wild'),
(2, 'city'),
(3, 'dungeon');

-- --------------------------------------------------------

--
-- Structure de la table `attackstypes`
--

CREATE TABLE `attackstypes` (
  `idAttackType` int(10) UNSIGNED NOT NULL,
  `shorthand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `attackstypes`
--

INSERT INTO `attackstypes` (`idAttackType`, `shorthand`) VALUES
(1, 'sure'),
(2, 'physical'),
(3, 'magical');

-- --------------------------------------------------------

--
-- Structure de la table `bodytype`
--

CREATE TABLE `bodytype` (
  `idBodyType` int(10) UNSIGNED NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `head` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `left` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `right` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `left_leg` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `bodytype`
--

INSERT INTO `bodytype` (`idBodyType`, `body`, `head`, `left`, `right`, `left_leg`) VALUES
(1, 'http://cdn.fight-rpg.com/images/appearances/base/bodies/male_body.png', 'http://cdn.fight-rpg.com/images/appearances/base/bodies/male_head_full.png', 'http://cdn.fight-rpg.com/images/appearances/base/bodies/male_left_arm_full.png', 'http://cdn.fight-rpg.com/images/appearances/base/bodies/male_right_arm_full.png', 'http://cdn.fight-rpg.com/images/appearances/base/bodies/male_left_leg_full.png'),
(2, 'http://cdn.fight-rpg.com/images/appearances/base/bodies/female_body.png', 'http://cdn.fight-rpg.com/images/appearances/base/bodies/female_head_full.png', 'http://cdn.fight-rpg.com/images/appearances/base/bodies/female_left_arm_full.png', 'http://cdn.fight-rpg.com/images/appearances/base/bodies/female_right_arm_full.png', 'http://cdn.fight-rpg.com/images/appearances/base/bodies/female_left_leg_full.png');

-- --------------------------------------------------------

--
-- Structure de la table `bonustypes`
--

CREATE TABLE `bonustypes` (
  `idBonusTypes` int(10) UNSIGNED NOT NULL,
  `nom` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `bonustypes`
--

INSERT INTO `bonustypes` (`idBonusTypes`, `nom`) VALUES
(1, 'xp_fight'),
(2, 'xp_collect'),
(3, 'xp_craft'),
(4, 'gold_drop'),
(5, 'item_drop'),
(6, 'collect_drop');

-- --------------------------------------------------------

--
-- Structure de la table `bosses`
--

CREATE TABLE `bosses` (
  `idBoss` int(10) UNSIGNED NOT NULL,
  `hpBase` bigint(19) UNSIGNED NOT NULL DEFAULT '1000000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `bosses`
--

INSERT INTO `bosses` (`idBoss`, `hpBase`) VALUES
(1, 100000),
(2, 200000),
(3, 250000),
(4, 500000);

-- --------------------------------------------------------

--
-- Structure de la table `bossspawninfo`
--

CREATE TABLE `bossspawninfo` (
  `idBoss` int(10) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL,
  `spawnDate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idSpawnedBoss` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `castinfo`
--

CREATE TABLE `castinfo` (
  `idSkill` int(10) UNSIGNED NOT NULL,
  `timeToCast` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `successRate` float UNSIGNED NOT NULL DEFAULT '0',
  `repeat` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',
  `energyGain` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `idAttackType` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `castinfo`
--

INSERT INTO `castinfo` (`idSkill`, `timeToCast`, `successRate`, `repeat`, `energyGain`, `idAttackType`) VALUES
(1, 0, 100, 1, 10, 2),
(2, 0, 100, 1, 20, 2),
(3, 0, 100, 1, 0, 3),
(4, 0, 100, 1, 0, 2),
(5, 0, 100, 1, 0, 2),
(6, 0, 100, 1, 0, 2),
(7, 0, 100, 1, 0, 2),
(8, 0, 100, 1, 0, 2),
(9, 0, 100, 1, 0, 2),
(10, 0, 100, 1, 0, 2),
(11, 0, 100, 1, 0, 2),
(12, 0, 100, 1, 0, 3),
(13, 0, 100, 1, 0, 3),
(14, 0, 100, 1, 0, 3),
(15, 0, 100, 1, 0, 3),
(16, 0, 100, 1, 0, 2),
(17, 0, 100, 1, 0, 2),
(18, 0, 100, 1, 0, 1),
(19, 0, 100, 1, 0, 1),
(20, 0, 100, 1, 0, 1),
(21, 0, 100, 1, 0, 1),
(22, 0, 100, 1, 0, 1),
(23, 0, 100, 1, 0, 1),
(24, 0, 50, 1, 0, 1),
(25, 0, 100, 1, 0, 2),
(26, 0, 100, 1, 0, 1),
(27, 0, 100, 1, 0, 1),
(28, 4, 100, 1, 50, 1),
(29, 0, 100, 1, 0, 2),
(30, 0, 100, 1, 0, 2),
(31, 0, 100, 1, 0, 2),
(32, 0, 100, 1, 0, 2),
(33, 0, 100, 1, 0, 2),
(34, 0, 100, 1, 0, 3);

-- --------------------------------------------------------

--
-- Structure de la table `characters`
--

CREATE TABLE `characters` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `statPoints` int(10) UNSIGNED NOT NULL,
  `money` bigint(19) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL,
  `talentPoints` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactersachievements`
--

CREATE TABLE `charactersachievements` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idAchievement` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactersappearance`
--

CREATE TABLE `charactersappearance` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `hairColor` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bodyColor` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eyeColor` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idBodyType` int(10) UNSIGNED NOT NULL,
  `displayHelmet` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactersappearanceparts`
--

CREATE TABLE `charactersappearanceparts` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idAppearance` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactersattacks`
--

CREATE TABLE `charactersattacks` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idSpawnedBoss` int(10) UNSIGNED NOT NULL,
  `damage` bigint(19) UNSIGNED NOT NULL DEFAULT '0',
  `attackCount` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactersbuilds`
--

CREATE TABLE `charactersbuilds` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idSkill` int(10) UNSIGNED NOT NULL,
  `priority` tinyint(3) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `characterscraftlevel`
--

CREATE TABLE `characterscraftlevel` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `actualLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `actualExp` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `rebirthLevel` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactersequipements`
--

CREATE TABLE `charactersequipements` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idItem` bigint(20) UNSIGNED NOT NULL,
  `idType` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactershonor`
--

CREATE TABLE `charactershonor` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `Honor` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactersinventory`
--

CREATE TABLE `charactersinventory` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idItem` bigint(20) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `charactersstatistics`
--

CREATE TABLE `charactersstatistics` (
  `idStatisticBase` int(10) UNSIGNED NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `value` bigint(19) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `characterstalents`
--

CREATE TABLE `characterstalents` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idNode` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `climates`
--

CREATE TABLE `climates` (
  `idClimate` int(10) UNSIGNED NOT NULL,
  `shorthand` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'none'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `climates`
--

INSERT INTO `climates` (`idClimate`, `shorthand`) VALUES
(1, 'temperate_oceanic'),
(2, 'volcanic_hell'),
(3, 'hot_desert'),
(4, 'eternal_snow'),
(5, 'interior');

-- --------------------------------------------------------

--
-- Structure de la table `climatesweathers`
--

CREATE TABLE `climatesweathers` (
  `idClimate` int(10) UNSIGNED NOT NULL,
  `idWeather` int(10) UNSIGNED NOT NULL,
  `probability` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `climatesweathers`
--

INSERT INTO `climatesweathers` (`idClimate`, `idWeather`, `probability`) VALUES
(1, 1, 60),
(1, 2, 25),
(1, 3, 8),
(1, 4, 5),
(1, 5, 2),
(2, 1, 50),
(2, 2, 30),
(2, 3, 5),
(2, 7, 15),
(3, 1, 80),
(3, 2, 15),
(3, 8, 5),
(4, 1, 60),
(4, 2, 20),
(4, 3, 15),
(4, 9, 5),
(5, 1, 100);

-- --------------------------------------------------------

--
-- Structure de la table `collectableresources`
--

CREATE TABLE `collectableresources` (
  `idCollectableResource` int(11) NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `minLevel` int(10) UNSIGNED NOT NULL,
  `minRebirthLevel` int(10) UNSIGNED NOT NULL,
  `percentage` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `collectableresources`
--

INSERT INTO `collectableresources` (`idCollectableResource`, `idBaseItem`, `minLevel`, `minRebirthLevel`, `percentage`) VALUES
(1, 23, 1, 0, 0),
(2, 24, 1, 0, 0),
(3, 163, 1, 0, 0),
(4, 142, 1, 0, 0),
(5, 34, 1, 0, 0),
(6, 170, 1, 0, 0),
(7, 138, 1, 0, 0),
(8, 152, 1, 0, 0),
(9, 166, 1, 0, 0),
(10, 145, 1, 0, 0),
(11, 159, 1, 0, 0),
(12, 173, 1, 0, 0),
(13, 135, 40, 0, 0),
(14, 149, 40, 0, 0),
(15, 164, 40, 0, 0),
(16, 33, 40, 0, 0),
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
(49, 30, 80, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `commandslogs`
--

CREATE TABLE `commandslogs` (
  `idCommandsLogs` int(10) UNSIGNED NOT NULL,
  `idUser` varchar(21) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `command` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `timestamp` bigint(19) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `conquesttournamentinfo`
--

CREATE TABLE `conquesttournamentinfo` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `actualRound` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `started` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `nextTournament` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `conquesttournamentinscriptions`
--

CREATE TABLE `conquesttournamentinscriptions` (
  `idGuild` int(10) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `conquesttournamentrounds`
--

CREATE TABLE `conquesttournamentrounds` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idRound` int(10) UNSIGNED NOT NULL,
  `idGuild_1` int(10) UNSIGNED NOT NULL,
  `idGuild_2` int(10) UNSIGNED DEFAULT NULL,
  `winner` tinyint(3) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `craftbuilding`
--

CREATE TABLE `craftbuilding` (
  `idCraftBuilding` int(10) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  `rarityMin` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `rarityMax` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `minLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `maxLevel` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `minRebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `maxRebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `craftbuilding`
--

INSERT INTO `craftbuilding` (`idCraftBuilding`, `idArea`, `active`, `rarityMin`, `rarityMax`, `minLevel`, `maxLevel`, `minRebirthLevel`, `maxRebirthLevel`) VALUES
(1, 5, 1, 1, 5, 11, 20, 0, 0),
(2, 6, 1, 1, 5, 1, 10, 0, 0),
(3, 8, 1, 3, 5, 21, 30, 0, 0),
(4, 14, 1, 3, 5, 31, 40, 0, 0),
(5, 15, 1, 3, 5, 41, 50, 0, 0),
(6, 16, 1, 3, 5, 51, 60, 0, 0),
(7, 22, 1, 3, 5, 61, 80, 0, 0),
(8, 29, 1, 3, 5, 81, 100, 0, 0),
(9, 34, 1, 6, 6, 100, 100, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `craftitem`
--

CREATE TABLE `craftitem` (
  `idCraftItem` int(10) UNSIGNED NOT NULL,
  `maxLevel` int(10) UNSIGNED NOT NULL,
  `minLevel` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `minRebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `maxRebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `craftitem`
--

INSERT INTO `craftitem` (`idCraftItem`, `maxLevel`, `minLevel`, `idBaseItem`, `minRebirthLevel`, `maxRebirthLevel`) VALUES
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
(21, 100, 100, 45, 0, 0),
(22, 100, 100, 46, 0, 0),
(23, 100, 100, 47, 0, 0),
(24, 100, 100, 48, 0, 0),
(25, 100, 100, 80, 0, 0),
(26, 100, 100, 86, 0, 0),
(27, 100, 100, 92, 0, 0),
(28, 100, 100, 98, 0, 0),
(29, 100, 100, 104, 0, 0),
(30, 100, 100, 110, 0, 0),
(31, 100, 100, 116, 0, 0),
(32, 100, 100, 122, 0, 0),
(33, 100, 100, 128, 0, 0),
(34, 100, 100, 134, 0, 0),
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

-- --------------------------------------------------------

--
-- Structure de la table `craftitemsneeded`
--

CREATE TABLE `craftitemsneeded` (
  `IdCraftItem` int(10) UNSIGNED NOT NULL,
  `NeededItem` int(10) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `minRebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `craftitemsneeded`
--

INSERT INTO `craftitemsneeded` (`IdCraftItem`, `NeededItem`, `number`, `minRebirthLevel`) VALUES
(1, 23, 1, 0),
(2, 135, 1, 0),
(3, 136, 1, 0),
(4, 137, 1, 0),
(5, 23, 1, 0),
(5, 24, 1, 0),
(5, 142, 1, 0),
(6, 33, 1, 0),
(6, 135, 1, 0),
(6, 149, 1, 0),
(7, 136, 1, 0),
(7, 143, 1, 0),
(7, 150, 1, 0),
(8, 137, 1, 0),
(8, 144, 1, 0),
(8, 151, 1, 0),
(9, 23, 1, 0),
(9, 24, 2, 0),
(9, 142, 1, 0),
(9, 145, 1, 0),
(9, 163, 2, 0),
(10, 33, 1, 0),
(10, 135, 1, 0),
(10, 146, 1, 0),
(10, 149, 2, 0),
(10, 164, 2, 0),
(11, 136, 1, 0),
(11, 143, 1, 0),
(11, 147, 1, 0),
(11, 150, 2, 0),
(11, 165, 2, 0),
(12, 25, 2, 0),
(12, 137, 1, 0),
(12, 144, 1, 0),
(12, 148, 1, 0),
(12, 151, 2, 0),
(13, 23, 1, 0),
(14, 135, 1, 0),
(15, 136, 1, 0),
(16, 137, 1, 0),
(17, 23, 2, 0),
(17, 24, 1, 0),
(18, 135, 2, 0),
(18, 149, 1, 0),
(19, 136, 2, 0),
(19, 150, 1, 0),
(20, 137, 2, 0),
(20, 151, 1, 0),
(21, 25, 6, 0),
(21, 30, 6, 0),
(21, 35, 6, 0),
(21, 49, 800, 0),
(22, 25, 15, 0),
(22, 49, 1200, 0),
(23, 30, 15, 0),
(23, 49, 1000, 0),
(24, 35, 15, 0),
(24, 49, 1000, 0),
(25, 25, 2, 0),
(25, 30, 6, 0),
(25, 35, 10, 0),
(25, 49, 800, 0),
(26, 25, 6, 0),
(26, 30, 7, 0),
(26, 35, 5, 0),
(26, 49, 800, 0),
(27, 25, 2, 0),
(27, 30, 8, 0),
(27, 35, 8, 0),
(27, 49, 800, 0),
(28, 25, 1, 0),
(28, 30, 7, 0),
(28, 35, 10, 0),
(28, 49, 800, 0),
(29, 30, 25, 0),
(29, 49, 1200, 0),
(30, 30, 25, 0),
(30, 49, 1200, 0),
(31, 30, 15, 0),
(31, 49, 1000, 0),
(32, 30, 15, 0),
(32, 49, 1000, 0),
(33, 30, 15, 0),
(33, 49, 1000, 0),
(34, 30, 15, 0),
(34, 49, 1000, 0),
(35, 23, 2, 0),
(35, 24, 2, 0),
(35, 138, 1, 0),
(35, 163, 2, 0),
(36, 135, 2, 0),
(36, 139, 1, 0),
(36, 149, 2, 0),
(36, 164, 2, 0),
(37, 136, 2, 0),
(37, 140, 1, 0),
(37, 150, 2, 0),
(37, 165, 2, 0),
(38, 25, 2, 0),
(38, 137, 2, 0),
(38, 141, 1, 0),
(38, 151, 2, 0),
(39, 23, 1, 0),
(40, 135, 1, 0),
(41, 136, 1, 0),
(42, 137, 1, 0),
(43, 23, 2, 0),
(43, 24, 1, 0),
(44, 135, 2, 0),
(44, 149, 1, 0),
(45, 136, 2, 0),
(45, 150, 1, 0),
(46, 137, 2, 0),
(46, 151, 1, 0),
(47, 23, 2, 0),
(47, 24, 2, 0),
(47, 138, 1, 0),
(47, 163, 2, 0),
(48, 135, 2, 0),
(48, 139, 1, 0),
(48, 149, 2, 0),
(48, 164, 2, 0),
(49, 136, 2, 0),
(49, 140, 1, 0),
(49, 150, 2, 0),
(49, 165, 2, 0),
(50, 25, 2, 0),
(50, 137, 2, 0),
(50, 141, 1, 0),
(50, 151, 2, 0),
(51, 23, 1, 0),
(52, 135, 1, 0),
(53, 136, 1, 0),
(54, 137, 1, 0),
(55, 23, 2, 0),
(55, 24, 1, 0),
(56, 135, 2, 0),
(56, 149, 1, 0),
(57, 136, 2, 0),
(57, 150, 1, 0),
(58, 137, 2, 0),
(58, 151, 1, 0),
(59, 23, 2, 0),
(59, 24, 2, 0),
(59, 138, 1, 0),
(59, 163, 2, 0),
(60, 135, 2, 0),
(60, 139, 1, 0),
(60, 149, 2, 0),
(60, 164, 2, 0),
(61, 136, 2, 0),
(61, 140, 1, 0),
(61, 150, 2, 0),
(61, 165, 2, 0),
(62, 25, 2, 0),
(62, 137, 2, 0),
(62, 141, 1, 0),
(62, 151, 2, 0),
(63, 142, 1, 0),
(64, 33, 1, 0),
(65, 143, 1, 0),
(66, 144, 1, 0),
(67, 34, 1, 0),
(67, 142, 2, 0),
(68, 33, 2, 0),
(68, 156, 1, 0),
(69, 143, 2, 0),
(69, 157, 1, 0),
(70, 144, 2, 0),
(70, 158, 1, 0),
(71, 34, 2, 0),
(71, 138, 1, 0),
(71, 142, 2, 0),
(71, 170, 2, 0),
(72, 33, 2, 0),
(72, 139, 1, 0),
(72, 156, 2, 0),
(72, 171, 2, 0),
(73, 35, 2, 0),
(73, 140, 1, 0),
(73, 143, 2, 0),
(73, 157, 2, 0),
(74, 141, 1, 0),
(74, 144, 2, 0),
(74, 158, 2, 0),
(74, 172, 2, 0),
(75, 23, 1, 0),
(76, 135, 1, 0),
(77, 136, 1, 0),
(78, 137, 1, 0),
(79, 23, 1, 0),
(79, 24, 1, 0),
(79, 142, 1, 0),
(80, 33, 1, 0),
(80, 135, 1, 0),
(80, 149, 1, 0),
(81, 136, 1, 0),
(81, 143, 1, 0),
(81, 150, 1, 0),
(82, 137, 1, 0),
(82, 144, 1, 0),
(82, 151, 1, 0),
(83, 24, 2, 0),
(83, 142, 1, 0),
(83, 145, 1, 0),
(83, 163, 2, 0),
(84, 33, 1, 0),
(84, 146, 1, 0),
(84, 149, 2, 0),
(84, 164, 2, 0),
(85, 143, 1, 0),
(85, 147, 1, 0),
(85, 150, 2, 0),
(85, 165, 2, 0),
(86, 25, 2, 0),
(86, 144, 1, 0),
(86, 148, 1, 0),
(86, 151, 2, 0),
(87, 142, 1, 0),
(88, 33, 1, 0),
(89, 143, 1, 0),
(90, 144, 1, 0),
(91, 34, 1, 0),
(91, 142, 2, 0),
(92, 33, 2, 0),
(92, 156, 1, 0),
(93, 143, 2, 0),
(93, 157, 1, 0),
(94, 144, 2, 0),
(94, 158, 1, 0),
(95, 34, 2, 0),
(95, 142, 3, 0),
(95, 170, 2, 0),
(96, 33, 3, 0),
(96, 156, 2, 0),
(96, 171, 2, 0),
(97, 35, 2, 0),
(97, 143, 3, 0),
(97, 157, 2, 0),
(98, 144, 3, 0),
(98, 158, 2, 0),
(98, 172, 2, 0),
(99, 23, 1, 0),
(99, 142, 1, 0),
(100, 33, 1, 0),
(100, 135, 1, 0),
(101, 136, 1, 0),
(101, 143, 1, 0),
(102, 137, 1, 0),
(102, 144, 1, 0),
(103, 23, 2, 0),
(103, 34, 1, 0),
(103, 142, 2, 0),
(104, 33, 2, 0),
(104, 135, 2, 0),
(104, 156, 1, 0),
(105, 136, 2, 0),
(105, 143, 2, 0),
(105, 157, 1, 0),
(106, 137, 2, 0),
(106, 144, 2, 0),
(106, 158, 1, 0),
(107, 23, 3, 0),
(107, 34, 2, 0),
(107, 142, 3, 0),
(107, 170, 2, 0),
(108, 33, 3, 0),
(108, 135, 3, 0),
(108, 156, 2, 0),
(108, 171, 2, 0),
(109, 35, 2, 0),
(109, 136, 3, 0),
(109, 143, 3, 0),
(109, 157, 2, 0),
(110, 137, 3, 0),
(110, 144, 3, 0),
(110, 158, 2, 0),
(110, 172, 2, 0),
(111, 138, 1, 0),
(112, 139, 1, 0),
(113, 140, 1, 0),
(114, 141, 1, 0),
(115, 138, 2, 0),
(115, 152, 1, 0),
(116, 139, 2, 0),
(116, 153, 1, 0),
(117, 140, 2, 0),
(117, 154, 1, 0),
(118, 141, 2, 0),
(118, 155, 1, 0),
(119, 138, 3, 0),
(119, 152, 2, 0),
(119, 166, 2, 0),
(120, 139, 3, 0),
(120, 153, 2, 0),
(120, 167, 2, 0),
(121, 140, 3, 0),
(121, 154, 2, 0),
(121, 168, 2, 0),
(122, 141, 3, 0),
(122, 155, 2, 0),
(122, 169, 2, 0),
(123, 138, 1, 0),
(123, 145, 1, 0),
(124, 139, 1, 0),
(124, 146, 1, 0),
(125, 140, 1, 0),
(125, 147, 1, 0),
(126, 141, 1, 0),
(126, 148, 1, 0),
(127, 138, 2, 0),
(127, 145, 2, 0),
(127, 159, 1, 0),
(128, 139, 2, 0),
(128, 146, 2, 0),
(128, 160, 1, 0),
(129, 140, 2, 0),
(129, 147, 2, 0),
(129, 161, 1, 0),
(130, 141, 2, 0),
(130, 148, 2, 0),
(130, 162, 1, 0),
(131, 138, 3, 0),
(131, 145, 3, 0),
(131, 159, 2, 0),
(131, 173, 2, 0),
(132, 139, 3, 0),
(132, 146, 3, 0),
(132, 160, 2, 0),
(132, 174, 2, 0),
(133, 140, 3, 0),
(133, 147, 3, 0),
(133, 161, 2, 0),
(133, 175, 2, 0),
(134, 141, 3, 0),
(134, 148, 3, 0),
(134, 162, 2, 0),
(134, 176, 2, 0),
(135, 138, 1, 0),
(136, 139, 1, 0),
(137, 140, 1, 0),
(138, 141, 1, 0),
(139, 138, 2, 0),
(139, 152, 1, 0),
(140, 139, 2, 0),
(140, 153, 1, 0),
(141, 140, 2, 0),
(141, 154, 1, 0),
(142, 141, 2, 0),
(142, 155, 1, 0),
(143, 138, 3, 0),
(143, 152, 2, 0),
(143, 166, 2, 0),
(144, 139, 3, 0),
(144, 153, 2, 0),
(144, 167, 2, 0),
(145, 140, 3, 0),
(145, 154, 2, 0),
(145, 168, 2, 0),
(146, 141, 3, 0),
(146, 155, 2, 0),
(146, 169, 2, 0),
(147, 138, 1, 0),
(147, 145, 1, 0),
(148, 139, 1, 0),
(148, 146, 1, 0),
(149, 140, 1, 0),
(149, 147, 1, 0),
(150, 141, 1, 0),
(150, 148, 1, 0),
(151, 138, 2, 0),
(151, 145, 2, 0),
(151, 159, 1, 0),
(152, 139, 2, 0),
(152, 146, 2, 0),
(152, 160, 1, 0),
(153, 140, 2, 0),
(153, 147, 2, 0),
(153, 161, 1, 0),
(154, 141, 2, 0),
(154, 148, 2, 0),
(154, 162, 1, 0),
(155, 138, 3, 0),
(155, 145, 3, 0),
(155, 159, 2, 0),
(155, 173, 2, 0),
(156, 139, 3, 0),
(156, 146, 3, 0),
(156, 160, 2, 0),
(156, 174, 2, 0),
(157, 140, 3, 0),
(157, 147, 3, 0),
(157, 161, 2, 0),
(157, 175, 2, 0),
(158, 141, 3, 0),
(158, 148, 3, 0),
(158, 162, 2, 0),
(158, 176, 2, 0),
(159, 138, 1, 0),
(160, 139, 1, 0),
(161, 140, 1, 0),
(162, 141, 1, 0),
(163, 138, 2, 0),
(163, 152, 1, 0),
(164, 139, 2, 0),
(164, 153, 1, 0),
(165, 140, 2, 0),
(165, 154, 1, 0),
(166, 141, 2, 0),
(166, 155, 1, 0),
(167, 138, 3, 0),
(167, 152, 2, 0),
(167, 166, 2, 0),
(168, 139, 3, 0),
(168, 153, 2, 0),
(168, 167, 2, 0),
(169, 140, 3, 0),
(169, 154, 2, 0),
(169, 168, 2, 0),
(170, 141, 3, 0),
(170, 155, 2, 0),
(170, 169, 2, 0),
(171, 138, 1, 0),
(171, 145, 1, 0),
(172, 139, 1, 0),
(172, 146, 1, 0),
(173, 140, 1, 0),
(173, 147, 1, 0),
(174, 141, 1, 0),
(174, 148, 1, 0),
(175, 138, 2, 0),
(175, 145, 2, 0),
(175, 159, 1, 0),
(176, 139, 2, 0),
(176, 146, 2, 0),
(176, 160, 1, 0),
(177, 140, 2, 0),
(177, 147, 2, 0),
(177, 161, 1, 0),
(178, 141, 2, 0),
(178, 148, 2, 0),
(178, 162, 1, 0),
(179, 138, 3, 0),
(179, 145, 3, 0),
(179, 159, 2, 0),
(179, 173, 2, 0),
(180, 139, 3, 0),
(180, 146, 3, 0),
(180, 160, 2, 0),
(180, 174, 2, 0),
(181, 140, 3, 0),
(181, 147, 3, 0),
(181, 161, 2, 0),
(181, 175, 2, 0),
(182, 141, 3, 0),
(182, 148, 3, 0),
(182, 162, 2, 0),
(182, 176, 2, 0);

-- --------------------------------------------------------

--
-- Structure de la table `damageinfo`
--

CREATE TABLE `damageinfo` (
  `idSkill` int(10) UNSIGNED NOT NULL,
  `idDamageType` int(10) UNSIGNED NOT NULL,
  `idElementType` int(10) UNSIGNED DEFAULT NULL,
  `formula` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `variance` tinyint(4) NOT NULL DEFAULT '0',
  `criticalHit` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `damageinfo`
--

INSERT INTO `damageinfo` (`idSkill`, `idDamageType`, `idElementType`, `formula`, `variance`, `criticalHit`) VALUES
(1, 1, 1, 'a.str * 1.5', 20, 1),
(2, 1, 1, 'a.dex * 1.8', 40, 1),
(3, 1, 1, 'a.int * 2', 10, 1),
(4, 1, 2, 'a.str * 2 + a.cha * 0.8', 20, 1),
(5, 1, 3, 'a.str * 2 + a.cha * 0.8', 20, 1),
(6, 1, 4, 'a.str * 2 + a.cha * 0.8', 20, 1),
(7, 1, 5, 'a.str * 2 + a.cha * 0.8', 20, 1),
(8, 1, 2, 'a.dex * 1.8 + a.wis * 0.8', 30, 1),
(9, 1, 3, 'a.dex * 1.8 + a.wis * 0.8', 30, 1),
(10, 1, 4, 'a.dex * 1.8 + a.wis * 0.8', 30, 1),
(11, 1, 5, 'a.dex * 1.8 + a.wis * 0.8', 30, 1),
(12, 1, 2, 'a.int * 2 + a.wis * 1.2', 10, 0),
(13, 1, 3, 'a.int * 2 + a.wis * 1.2', 10, 0),
(14, 1, 4, 'a.int * 2 + a.wis * 1.2', 10, 0),
(15, 1, 5, 'a.int * 2 + a.wis * 1.2', 10, 0),
(16, 1, 4, 'b.mhp * 0.1 + a.dex * 0.4', 50, 0),
(17, 1, 4, 'b.mhp * 0.05 + a.dex * 0.2', 50, 0),
(18, 3, 1, 'a.mhp * 0.1', 5, 0),
(21, 3, 1, 'a.int * 0.7 + a.wis * 0.2', 20, 1),
(22, 3, 1, 'a.int * 0.5 + a.wis * 0.15', 20, 1),
(23, 3, 1, 'a.int * 0.2 + a.wis * 0.1', 30, 1),
(24, 3, 1, 'b.mhp * 0.1', 0, 0),
(25, 1, 1, 'a.dex * 0.3', 50, 0),
(28, 1, 1, 'a.mhp / 2', 0, 0),
(29, 1, 1, 'a.str * 3', 20, 1),
(30, 1, 1, '(a.str + a.dex) * 1.2', 30, 1),
(31, 1, 1, 'a.str * 0.6 + a.con * 0.6', 20, 1),
(32, 1, 1, 'a.str * 2 + a.cha * 0.6', 20, 1),
(33, 1, 1, 'a.dex * 1.8 + a.wis * 0.6', 30, 1),
(34, 1, 1, 'a.int * 2 + a.wis', 10, 0);

-- --------------------------------------------------------

--
-- Structure de la table `damagestypes`
--

CREATE TABLE `damagestypes` (
  `idDamageType` int(10) UNSIGNED NOT NULL,
  `shorthand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `damagestypes`
--

INSERT INTO `damagestypes` (`idDamageType`, `shorthand`) VALUES
(1, 'hpDamage'),
(2, 'manaDamage'),
(3, 'healHp'),
(4, 'healMp'),
(5, 'lifeSteal'),
(6, 'manaSteal');

-- --------------------------------------------------------

--
-- Structure de la table `effectsskills`
--

CREATE TABLE `effectsskills` (
  `idEffectSkill` int(10) UNSIGNED NOT NULL,
  `idSkill` int(10) UNSIGNED NOT NULL,
  `idEffectType` int(11) NOT NULL,
  `percentageValue` float DEFAULT NULL,
  `fixedValue` int(11) DEFAULT NULL,
  `stateValue` int(10) UNSIGNED DEFAULT NULL,
  `statValue` int(10) UNSIGNED DEFAULT NULL,
  `roundsValue` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `effectsskills`
--

INSERT INTO `effectsskills` (`idEffectSkill`, `idSkill`, `idEffectType`, `percentageValue`, `fixedValue`, `stateValue`, `statValue`, `roundsValue`) VALUES
(1, 1, 4, 0, 0, 1, NULL, 0),
(2, 12, 4, 0.5, 0, 11, NULL, 0),
(3, 13, 4, 0.33, 0, 12, NULL, 0),
(4, 14, 4, 0.1, 0, 1, NULL, 0),
(5, 14, 4, 0.1, 0, 10, NULL, 0),
(6, 16, 4, 0.9, 0, 4, NULL, 0),
(7, 17, 4, 0.5, 0, 4, NULL, 0),
(8, 18, 4, 1, 0, 6, NULL, 0),
(9, 19, 4, 1, 0, 3, NULL, 0),
(10, 20, 4, 1, 0, 3, NULL, 0),
(11, 21, 4, 1, 0, 8, NULL, 0),
(12, 22, 4, 1, 0, 8, NULL, 0),
(13, 23, 4, 1, 0, 8, NULL, 0),
(14, 24, 4, 0.25, 0, 3, NULL, 0),
(15, 25, 4, 0.8, 0, 5, NULL, 0),
(16, 26, 4, 1, 0, 7, NULL, 0),
(17, 27, 4, 1, 0, 2, NULL, 0),
(18, 28, 4, 1, 0, 9, NULL, 0),
(19, 29, 4, 0.25, 0, 10, NULL, 0),
(20, 30, 4, 0.25, 0, 4, NULL, 0),
(21, 31, 4, 1, 0, 1, NULL, 0);

-- --------------------------------------------------------

--
-- Structure de la table `effectstypes`
--

CREATE TABLE `effectstypes` (
  `idEffectType` int(11) NOT NULL,
  `shortname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `effectstypes`
--

INSERT INTO `effectstypes` (`idEffectType`, `shortname`) VALUES
(1, 'hpHeal'),
(2, 'manaHeal'),
(3, 'energyHeal'),
(4, 'addState'),
(5, 'removeState');

-- --------------------------------------------------------

--
-- Structure de la table `elementstypes`
--

CREATE TABLE `elementstypes` (
  `idElementType` int(10) UNSIGNED NOT NULL,
  `shorthand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `elementstypes`
--

INSERT INTO `elementstypes` (`idElementType`, `shorthand`) VALUES
(1, 'physical'),
(2, 'fire'),
(3, 'water'),
(4, 'earth'),
(5, 'air'),
(6, 'dark'),
(7, 'light');

-- --------------------------------------------------------

--
-- Structure de la table `events`
--

CREATE TABLE `events` (
  `idEvent` int(10) UNSIGNED NOT NULL,
  `idEventType` int(10) UNSIGNED NOT NULL,
  `backgroundImage` text NOT NULL,
  `iconImage` text NOT NULL,
  `occurence` bigint(20) UNSIGNED NOT NULL DEFAULT '86400',
  `length` bigint(20) UNSIGNED NOT NULL DEFAULT '43200',
  `startDate` datetime NOT NULL,
  `endDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `events`
--

INSERT INTO `events` (`idEvent`, `idEventType`, `backgroundImage`, `iconImage`, `occurence`, `length`, `startDate`, `endDate`) VALUES
(1, 2, 'https://freesvg.org/img/nicubunu_Chocolate_birthday_cake.png', 'https://cdn.fight-rpg.com/images/events/anniversary_icon.png', 525600, 10080, '2021-06-11 00:00:00', NULL),
(2, 3, 'https://tinyurl.com/2h3sesp8', 'https://tinyurl.com/2h3sesp8', 99999, 7200, '2021-05-17 00:00:00', '2021-05-21 00:00:00');

-- --------------------------------------------------------

--
-- Structure de la table `eventsareasdrops`
--

CREATE TABLE `eventsareasdrops` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idEvent` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `eventsareastypesdrops`
--

CREATE TABLE `eventsareastypesdrops` (
  `idAreaType` int(10) UNSIGNED NOT NULL,
  `idEvent` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `eventsglobalmodifiers`
--

CREATE TABLE `eventsglobalmodifiers` (
  `idEvent` int(10) UNSIGNED NOT NULL,
  `idBonusTypes` int(10) UNSIGNED NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `eventsglobalmodifiers`
--

INSERT INTO `eventsglobalmodifiers` (`idEvent`, `idBonusTypes`, `value`) VALUES
(1, 1, 20),
(1, 2, 20),
(1, 3, 20),
(1, 4, 20),
(1, 5, 20),
(1, 6, 20),
(2, 2, 25),
(2, 3, 25),
(2, 6, 25);

-- --------------------------------------------------------

--
-- Structure de la table `eventspecificdrops`
--

CREATE TABLE `eventspecificdrops` (
  `idEvent` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `percentage` float UNSIGNED NOT NULL,
  `min` int(10) UNSIGNED NOT NULL,
  `max` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `eventstypes`
--

CREATE TABLE `eventstypes` (
  `idEventType` int(10) UNSIGNED NOT NULL,
  `name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `eventstypes`
--

INSERT INTO `eventstypes` (`idEventType`, `name`) VALUES
(2, 'reccuring'),
(3, 'special'),
(1, 'uncategorized');

-- --------------------------------------------------------

--
-- Structure de la table `guilds`
--

CREATE TABLE `guilds` (
  `idGuild` int(10) UNSIGNED NOT NULL,
  `nom` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `argent` bigint(19) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `guildsappliances`
--

CREATE TABLE `guildsappliances` (
  `idGuild` int(10) UNSIGNED NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `guildsmembers`
--

CREATE TABLE `guildsmembers` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idGuild` int(10) UNSIGNED NOT NULL,
  `idGuildRank` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `guildsranks`
--

CREATE TABLE `guildsranks` (
  `idGuildRank` int(10) UNSIGNED NOT NULL,
  `nom` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `guildsranks`
--

INSERT INTO `guildsranks` (`idGuildRank`, `nom`) VALUES
(1, 'member'),
(2, 'officer'),
(3, 'guild_master');

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `idItem` bigint(20) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `level` int(10) UNSIGNED NOT NULL,
  `favorite` tinyint(4) NOT NULL DEFAULT '0',
  `rebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `itemsappearances`
--

CREATE TABLE `itemsappearances` (
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `idAppearance` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `itemsappearances`
--

INSERT INTO `itemsappearances` (`idBaseItem`, `idAppearance`) VALUES
(104, 137),
(104, 138),
(106, 141),
(107, 141),
(108, 141),
(109, 141),
(106, 142),
(107, 142),
(108, 142),
(109, 142),
(106, 143),
(107, 143),
(108, 143),
(109, 143),
(106, 144),
(107, 144),
(108, 144),
(109, 144),
(100, 145),
(101, 145),
(102, 145),
(103, 145),
(100, 146),
(101, 146),
(102, 146),
(103, 146),
(100, 147),
(101, 147),
(102, 147),
(103, 147),
(100, 148),
(101, 148),
(102, 148),
(103, 148),
(110, 149),
(110, 150),
(110, 151),
(110, 152),
(46, 163),
(46, 164),
(46, 165),
(46, 166),
(7, 179),
(8, 179),
(9, 179),
(10, 179),
(7, 180),
(8, 180),
(9, 180),
(10, 180),
(7, 181),
(8, 181),
(9, 181),
(10, 181),
(7, 182),
(8, 182),
(9, 182),
(10, 182),
(105, 183),
(105, 184),
(105, 185),
(105, 186),
(129, 191),
(123, 192),
(124, 193),
(131, 194),
(130, 196),
(132, 196),
(133, 196),
(134, 196),
(125, 197),
(126, 197),
(127, 197),
(128, 197),
(16, 204),
(17, 210),
(18, 210),
(19, 210),
(20, 210),
(48, 212),
(6, 230),
(99, 230),
(6, 233),
(99, 233),
(100, 244),
(101, 244),
(102, 244),
(103, 244),
(100, 250),
(101, 250),
(102, 250),
(103, 250),
(7, 266),
(8, 266),
(9, 266),
(10, 266),
(7, 272),
(8, 272),
(9, 272),
(10, 272),
(46, 277),
(46, 283),
(105, 289),
(106, 289),
(107, 289),
(108, 289),
(109, 289),
(105, 292),
(106, 292),
(107, 292),
(108, 292),
(109, 292),
(104, 334),
(104, 340),
(110, 346),
(110, 350),
(11, 366),
(111, 366),
(11, 371),
(111, 371),
(116, 386),
(116, 391),
(117, 401),
(118, 401),
(119, 401),
(120, 401),
(121, 401),
(117, 436),
(118, 436),
(119, 436),
(120, 436),
(121, 436),
(12, 446),
(13, 446),
(14, 446),
(15, 446),
(47, 446),
(112, 461),
(113, 461),
(114, 461),
(115, 461),
(12, 469),
(13, 469),
(14, 469),
(15, 469),
(47, 469),
(122, 500),
(122, 505),
(11, 522),
(111, 522),
(116, 536),
(117, 536),
(118, 536),
(119, 536),
(120, 536),
(121, 536),
(122, 536),
(112, 548),
(113, 548),
(114, 548),
(115, 548),
(12, 552),
(13, 552),
(14, 552),
(15, 552),
(47, 552),
(112, 576),
(113, 576),
(114, 576),
(115, 576),
(81, 584),
(82, 584),
(83, 584),
(84, 584),
(85, 584),
(86, 587),
(1, 588),
(2, 588),
(3, 588),
(4, 588),
(5, 588),
(45, 589),
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
(98, 601),
(75, 605),
(76, 606),
(77, 606),
(78, 606),
(79, 606),
(80, 608);

-- --------------------------------------------------------

--
-- Structure de la table `itemsappearancesmaskcolors`
--

CREATE TABLE `itemsappearancesmaskcolors` (
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `idAppearance` int(10) UNSIGNED NOT NULL,
  `sourceColor` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `targetColor` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `itemsappearancesmaskcolors`
--

INSERT INTO `itemsappearancesmaskcolors` (`idBaseItem`, `idAppearance`, `sourceColor`, `targetColor`) VALUES
(1, 588, '#0000ff', '#624a2e'),
(1, 588, '#00ff00', '#985717'),
(1, 588, '#ff0000', '#985717'),
(2, 588, '#0000ff', '#624a2e'),
(2, 588, '#00ff00', '#c0c0c0'),
(2, 588, '#ff0000', '#e9ecef'),
(3, 588, '#0000ff', '#624a2e'),
(3, 588, '#00ff00', '#a19d94'),
(3, 588, '#ff0000', '#9c9b99'),
(4, 588, '#0000ff', '#624a2e'),
(4, 588, '#00ff00', '#e7bd42'),
(4, 588, '#ff0000', '#ffea00'),
(5, 588, '#0000ff', '#624a2e'),
(5, 588, '#00ff00', '#1773d1'),
(5, 588, '#ff0000', '#b0ceed'),
(6, 230, '#00ff00', '#624a2e'),
(6, 230, '#ff0000', '#d2b48c'),
(6, 233, '#0000ff', '#624a2e'),
(6, 233, '#00ff00', '#d2b48c'),
(6, 233, '#ff0000', '#d2b48c'),
(7, 179, '#ff0000', '#624a2e'),
(7, 180, '#00ff00', '#c0c0c0'),
(7, 180, '#ff0000', '#624a2e'),
(7, 181, '#ff0000', '#624a2e'),
(7, 182, '#00ff00', '#c0c0c0'),
(7, 182, '#ff0000', '#624a2e'),
(7, 266, '#0000ff', '#624a2e'),
(7, 266, '#00ff00', '#c0c0c0'),
(7, 266, '#ff0000', '#624a2e'),
(7, 272, '#0000ff', '#624a2e'),
(7, 272, '#00ff00', '#c0c0c0'),
(7, 272, '#ff0000', '#624a2e'),
(8, 179, '#ff0000', '#624a2e'),
(8, 180, '#00ff00', '#a19d94'),
(8, 180, '#ff0000', '#624a2e'),
(8, 181, '#ff0000', '#624a2e'),
(8, 182, '#00ff00', '#a19d94'),
(8, 182, '#ff0000', '#624a2e'),
(8, 266, '#0000ff', '#624a2e'),
(8, 266, '#00ff00', '#a19d94'),
(8, 266, '#ff0000', '#624a2e'),
(8, 272, '#0000ff', '#624a2e'),
(8, 272, '#00ff00', '#a19d94'),
(8, 272, '#ff0000', '#624a2e'),
(9, 179, '#ff0000', '#624a2e'),
(9, 180, '#00ff00', '#e7bd42'),
(9, 180, '#ff0000', '#624a2e'),
(9, 181, '#ff0000', '#624a2e'),
(9, 182, '#00ff00', '#e7bd42'),
(9, 182, '#ff0000', '#624a2e'),
(9, 266, '#0000ff', '#624a2e'),
(9, 266, '#00ff00', '#e7bd42'),
(9, 266, '#ff0000', '#624a2e'),
(9, 272, '#0000ff', '#624a2e'),
(9, 272, '#00ff00', '#e7bd42'),
(9, 272, '#ff0000', '#624a2e'),
(10, 179, '#ff0000', '#624a2e'),
(10, 180, '#00ff00', '#1773d1'),
(10, 180, '#ff0000', '#624a2e'),
(10, 181, '#ff0000', '#624a2e'),
(10, 182, '#00ff00', '#1773d1'),
(10, 182, '#ff0000', '#624a2e'),
(10, 266, '#0000ff', '#624a2e'),
(10, 266, '#00ff00', '#1773d1'),
(10, 266, '#ff0000', '#624a2e'),
(10, 272, '#0000ff', '#624a2e'),
(10, 272, '#00ff00', '#1773d1'),
(10, 272, '#ff0000', '#624a2e'),
(11, 366, '#ff0000', '#624a2e'),
(11, 371, '#ff0000', '#624a2e'),
(11, 522, '#ff0000', '#624a2e'),
(12, 446, '#0000ff', '#c0c0c0'),
(12, 446, '#00ff00', '#c0c0c0'),
(12, 446, '#ff0000', '#624a2e'),
(12, 469, '#0000ff', '#c0c0c0'),
(12, 469, '#00ff00', '#c0c0c0'),
(12, 469, '#ff0000', '#624a2e'),
(12, 552, '#0000ff', '#c0c0c0'),
(12, 552, '#00ff00', '#c0c0c0'),
(12, 552, '#ff0000', '#c0c0c0'),
(13, 446, '#0000ff', '#a19d94'),
(13, 446, '#00ff00', '#a19d94'),
(13, 446, '#ff0000', '#624a2e'),
(13, 469, '#0000ff', '#a19d94'),
(13, 469, '#00ff00', '#a19d94'),
(13, 469, '#ff0000', '#624a2e'),
(13, 552, '#0000ff', '#a19d94'),
(13, 552, '#00ff00', '#a19d94'),
(13, 552, '#ff0000', '#a19d94'),
(14, 446, '#0000ff', '#e7bd42'),
(14, 446, '#00ff00', '#e7bd42'),
(14, 446, '#ff0000', '#624a2e'),
(14, 469, '#0000ff', '#e7bd42'),
(14, 469, '#00ff00', '#e7bd42'),
(14, 469, '#ff0000', '#624a2e'),
(14, 552, '#0000ff', '#e7bd42'),
(14, 552, '#00ff00', '#e7bd42'),
(14, 552, '#ff0000', '#e7bd42'),
(15, 446, '#0000ff', '#1773d1'),
(15, 446, '#00ff00', '#1773d1'),
(15, 446, '#ff0000', '#624a2e'),
(15, 469, '#0000ff', '#1773d1'),
(15, 469, '#00ff00', '#1773d1'),
(15, 469, '#ff0000', '#624a2e'),
(15, 552, '#0000ff', '#1773d1'),
(15, 552, '#00ff00', '#1773d1'),
(15, 552, '#ff0000', '#1773d1'),
(17, 210, '#00ff00', '#c0c0c0'),
(17, 210, '#ff0000', '#c0c0c0'),
(18, 210, '#00ff00', '#a19d94'),
(18, 210, '#ff0000', '#a19d94'),
(19, 210, '#00ff00', '#e7bd42'),
(19, 210, '#ff0000', '#e7bd42'),
(20, 210, '#00ff00', '#1773d1'),
(20, 210, '#ff0000', '#1773d1'),
(45, 589, '#0000ff', '#624a2e'),
(45, 589, '#00ff00', '#2f0c50'),
(45, 589, '#ff0000', '#5a189a'),
(46, 163, '#0000ff', '#624a2e'),
(46, 163, '#00ff00', '#5a189a'),
(46, 163, '#ff0000', '#2f0c50'),
(46, 164, '#0000ff', '#624a2e'),
(46, 164, '#00ff00', '#5a189a'),
(46, 164, '#ff0000', '#2f0c50'),
(46, 165, '#0000ff', '#624a2e'),
(46, 165, '#00ff00', '#5a189a'),
(46, 165, '#ff0000', '#2f0c50'),
(46, 166, '#0000ff', '#624a2e'),
(46, 166, '#00ff00', '#5a189a'),
(46, 166, '#ff0000', '#2f0c50'),
(46, 277, '#0000ff', '#624a2e'),
(46, 277, '#00ff00', '#5a189a'),
(46, 277, '#ff0000', '#2f0c50'),
(46, 283, '#0000ff', '#624a2e'),
(46, 283, '#00ff00', '#5a189a'),
(46, 283, '#ff0000', '#2f0c50'),
(47, 446, '#0000ff', '#5a189a'),
(47, 446, '#00ff00', '#5a189a'),
(47, 446, '#ff0000', '#2f0c50'),
(47, 469, '#0000ff', '#5a189a'),
(47, 469, '#00ff00', '#5a189a'),
(47, 469, '#ff0000', '#2f0c50'),
(47, 552, '#0000ff', '#5a189a'),
(47, 552, '#00ff00', '#5a189a'),
(47, 552, '#ff0000', '#2f0c50'),
(48, 212, '#00ff00', '#5a189a'),
(48, 212, '#ff0000', '#2f0c50'),
(75, 605, '#ff0000', '#8b5a2b'),
(76, 606, '#0000ff', '#c0c0c0'),
(76, 606, '#00ff00', '#624a2e'),
(76, 606, '#ff0000', '#8b5a2b'),
(77, 606, '#0000ff', '#a19d94'),
(77, 606, '#00ff00', '#624a2e'),
(77, 606, '#ff0000', '#8b5a2b'),
(78, 606, '#0000ff', '#e7bd42'),
(78, 606, '#00ff00', '#624a2e'),
(78, 606, '#ff0000', '#8b5a2b'),
(79, 606, '#0000ff', '#1773d1'),
(79, 606, '#00ff00', '#624a2e'),
(79, 606, '#ff0000', '#8b5a2b'),
(80, 608, '#00ff00', '#2f0c50'),
(80, 608, '#ff0000', '#5a189a'),
(81, 584, '#0000ff', '#624a2e'),
(81, 584, '#00ff00', '#985717'),
(81, 584, '#ff0000', '#985717'),
(82, 584, '#0000ff', '#624a2e'),
(82, 584, '#00ff00', '#c0c0c0'),
(82, 584, '#ff0000', '#e9ecef'),
(83, 584, '#0000ff', '#624a2e'),
(83, 584, '#00ff00', '#a19d94'),
(83, 584, '#ff0000', '#9c9b99'),
(84, 584, '#0000ff', '#624a2e'),
(84, 584, '#00ff00', '#e7bd42'),
(84, 584, '#ff0000', '#ffea00'),
(85, 584, '#0000ff', '#624a2e'),
(85, 584, '#00ff00', '#1773d1'),
(85, 584, '#ff0000', '#b0ceed'),
(86, 587, '#00ff00', '#2f0c50'),
(86, 587, '#ff0000', '#5a189a'),
(87, 592, '#0000ff', '#c0c0c0'),
(87, 592, '#00ff00', '#624a2e'),
(87, 592, '#ff0000', '#8b5a2b'),
(88, 592, '#0000ff', '#c0c0c0'),
(88, 592, '#00ff00', '#624a2e'),
(88, 592, '#ff0000', '#8b5a2b'),
(89, 592, '#0000ff', '#a19d94'),
(89, 592, '#00ff00', '#624a2e'),
(89, 592, '#ff0000', '#8b5a2b'),
(90, 592, '#0000ff', '#e7bd42'),
(90, 592, '#00ff00', '#624a2e'),
(90, 592, '#ff0000', '#8b5a2b'),
(91, 592, '#0000ff', '#1773d1'),
(91, 592, '#00ff00', '#624a2e'),
(91, 592, '#ff0000', '#8b5a2b'),
(92, 596, '#0000ff', '#2f0c50'),
(92, 596, '#00ff00', '#2f0c50'),
(92, 596, '#ff0000', '#5a189a'),
(93, 597, '#0000ff', '#c0c0c0'),
(93, 597, '#00ff00', '#624a2e'),
(93, 597, '#ff0000', '#8b5a2b'),
(94, 600, '#0000ff', '#c0c0c0'),
(94, 600, '#00ff00', '#624a2e'),
(94, 600, '#ff0000', '#8b5a2b'),
(95, 600, '#0000ff', '#a19d94'),
(95, 600, '#00ff00', '#624a2e'),
(95, 600, '#ff0000', '#8b5a2b'),
(96, 600, '#0000ff', '#e7bd42'),
(96, 600, '#00ff00', '#624a2e'),
(96, 600, '#ff0000', '#8b5a2b'),
(97, 600, '#0000ff', '#1773d1'),
(97, 600, '#00ff00', '#624a2e'),
(97, 600, '#ff0000', '#8b5a2b'),
(98, 601, '#0000ff', '#2f0c50'),
(98, 601, '#00ff00', '#2f0c50'),
(98, 601, '#ff0000', '#5a189a'),
(99, 230, '#00ff00', '#624a2e'),
(99, 230, '#ff0000', '#d2b48c'),
(99, 233, '#0000ff', '#624a2e'),
(99, 233, '#00ff00', '#d2b48c'),
(99, 233, '#ff0000', '#d2b48c'),
(100, 145, '#0000ff', '#c0c0c0'),
(100, 145, '#ff0000', '#d2b48c'),
(100, 146, '#0000ff', '#c0c0c0'),
(100, 146, '#00ff00', '#9a9a9a'),
(100, 146, '#ff0000', '#d2b48c'),
(100, 147, '#0000ff', '#c0c0c0'),
(100, 147, '#ff0000', '#d2b48c'),
(100, 148, '#0000ff', '#c0c0c0'),
(100, 148, '#ff0000', '#d2b48c'),
(100, 244, '#0000ff', '#c0c0c0'),
(100, 244, '#00ff00', '#9a9a9a'),
(100, 244, '#ff0000', '#d2b48c'),
(100, 250, '#0000ff', '#c0c0c0'),
(100, 250, '#00ff00', '#9a9a9a'),
(100, 250, '#ff0000', '#d2b48c'),
(101, 145, '#0000ff', '#a19d94'),
(101, 145, '#ff0000', '#d2b48c'),
(101, 146, '#0000ff', '#a19d94'),
(101, 146, '#00ff00', '#9c9b99'),
(101, 146, '#ff0000', '#d2b48c'),
(101, 147, '#0000ff', '#a19d94'),
(101, 147, '#ff0000', '#d2b48c'),
(101, 148, '#0000ff', '#a19d94'),
(101, 148, '#ff0000', '#d2b48c'),
(101, 244, '#0000ff', '#a19d94'),
(101, 244, '#00ff00', '#9c9b99'),
(101, 244, '#ff0000', '#d2b48c'),
(101, 250, '#0000ff', '#a19d94'),
(101, 250, '#00ff00', '#9c9b99'),
(101, 250, '#ff0000', '#d2b48c'),
(102, 145, '#0000ff', '#e7bd42'),
(102, 145, '#ff0000', '#d2b48c'),
(102, 146, '#0000ff', '#e7bd42'),
(102, 146, '#00ff00', '#ffea00'),
(102, 146, '#ff0000', '#d2b48c'),
(102, 147, '#0000ff', '#e7bd42'),
(102, 147, '#ff0000', '#d2b48c'),
(102, 148, '#0000ff', '#e7bd42'),
(102, 148, '#ff0000', '#d2b48c'),
(102, 244, '#0000ff', '#e7bd42'),
(102, 244, '#00ff00', '#ffea00'),
(102, 244, '#ff0000', '#d2b48c'),
(102, 250, '#0000ff', '#e7bd42'),
(102, 250, '#00ff00', '#ffea00'),
(102, 250, '#ff0000', '#d2b48c'),
(103, 145, '#0000ff', '#1773d1'),
(103, 145, '#ff0000', '#d2b48c'),
(103, 146, '#0000ff', '#1773d1'),
(103, 146, '#00ff00', '#b0ceed'),
(103, 146, '#ff0000', '#d2b48c'),
(103, 147, '#0000ff', '#1773d1'),
(103, 147, '#ff0000', '#d2b48c'),
(103, 148, '#0000ff', '#1773d1'),
(103, 148, '#ff0000', '#d2b48c'),
(103, 244, '#0000ff', '#1773d1'),
(103, 244, '#00ff00', '#b0ceed'),
(103, 244, '#ff0000', '#d2b48c'),
(103, 250, '#0000ff', '#1773d1'),
(103, 250, '#00ff00', '#b0ceed'),
(103, 250, '#ff0000', '#d2b48c'),
(104, 137, '#ff0000', '#5a189a'),
(104, 138, '#ff0000', '#5a189a'),
(104, 334, '#0000ff', '#624a2e'),
(104, 334, '#00ff00', '#2f0c50'),
(104, 334, '#ff0000', '#5a189a'),
(104, 340, '#0000ff', '#624a2e'),
(104, 340, '#00ff00', '#2f0c50'),
(104, 340, '#ff0000', '#5a189a'),
(105, 183, '#00ff00', '#624a2e'),
(105, 183, '#ff0000', '#624a2e'),
(105, 184, '#ff0000', '#624a2e'),
(105, 185, '#00ff00', '#624a2e'),
(105, 185, '#ff0000', '#624a2e'),
(105, 186, '#ff0000', '#624a2e'),
(105, 289, '#0000ff', '#624a2e'),
(105, 289, '#00ff00', '#624a2e'),
(105, 289, '#ff0000', '#d2b48c'),
(105, 292, '#0000ff', '#624a2e'),
(105, 292, '#00ff00', '#624a2e'),
(105, 292, '#ff0000', '#d2b48c'),
(106, 141, '#00ff00', '#47632d'),
(106, 141, '#ff0000', '#624a2e'),
(106, 142, '#ff0000', '#624a2e'),
(106, 143, '#00ff00', '#47632d'),
(106, 143, '#ff0000', '#624a2e'),
(106, 144, '#ff0000', '#624a2e'),
(106, 289, '#0000ff', '#624a2e'),
(106, 289, '#00ff00', '#624a2e'),
(106, 289, '#ff0000', '#47632d'),
(106, 292, '#0000ff', '#624a2e'),
(106, 292, '#00ff00', '#624a2e'),
(106, 292, '#ff0000', '#47632d'),
(107, 141, '#00ff00', '#a19d94'),
(107, 141, '#ff0000', '#624a2e'),
(107, 142, '#ff0000', '#624a2e'),
(107, 143, '#00ff00', '#a19d94'),
(107, 143, '#ff0000', '#624a2e'),
(107, 144, '#ff0000', '#624a2e'),
(107, 289, '#0000ff', '#624a2e'),
(107, 289, '#00ff00', '#624a2e'),
(107, 289, '#ff0000', '#a19d94'),
(107, 292, '#0000ff', '#624a2e'),
(107, 292, '#00ff00', '#624a2e'),
(107, 292, '#ff0000', '#a19d94'),
(108, 141, '#00ff00', '#e7bd42'),
(108, 141, '#ff0000', '#624a2e'),
(108, 142, '#ff0000', '#624a2e'),
(108, 143, '#00ff00', '#e7bd42'),
(108, 143, '#ff0000', '#624a2e'),
(108, 144, '#ff0000', '#624a2e'),
(108, 289, '#0000ff', '#624a2e'),
(108, 289, '#00ff00', '#e7bd42'),
(108, 289, '#ff0000', '#191f22'),
(108, 292, '#0000ff', '#624a2e'),
(108, 292, '#00ff00', '#e7bd42'),
(108, 292, '#ff0000', '#191f22'),
(109, 141, '#00ff00', '#1773d1'),
(109, 141, '#ff0000', '#191f22'),
(109, 142, '#ff0000', '#191f22'),
(109, 143, '#00ff00', '#1773d1'),
(109, 143, '#ff0000', '#191f22'),
(109, 144, '#ff0000', '#191f22'),
(109, 289, '#0000ff', '#191f22'),
(109, 289, '#00ff00', '#1773d1'),
(109, 289, '#ff0000', '#191f22'),
(109, 292, '#0000ff', '#191f22'),
(109, 292, '#00ff00', '#1773d1'),
(109, 292, '#ff0000', '#191f22'),
(110, 149, '#0000ff', '#191f22'),
(110, 149, '#00ff00', '#5a189a'),
(110, 149, '#ff0000', '#191f22'),
(110, 150, '#ff0000', '#191f22'),
(110, 151, '#0000ff', '#191f22'),
(110, 151, '#00ff00', '#5a189a'),
(110, 151, '#ff0000', '#191f22'),
(110, 152, '#ff0000', '#191f22'),
(110, 346, '#0000ff', '#2f0c50'),
(110, 346, '#00ff00', '#191f22'),
(110, 346, '#ff0000', '#5a189a'),
(110, 350, '#0000ff', '#2f0c50'),
(110, 350, '#00ff00', '#191f22'),
(110, 350, '#ff0000', '#5a189a'),
(111, 366, '#ff0000', '#d2b48c'),
(111, 371, '#ff0000', '#d2b48c'),
(111, 522, '#ff0000', '#d2b48c'),
(112, 461, '#0000ff', '#c0c0c0'),
(112, 461, '#00ff00', '#e9ecef'),
(112, 461, '#ff0000', '#d2b48c'),
(112, 548, '#0000ff', '#c0c0c0'),
(112, 548, '#00ff00', '#e9ecef'),
(112, 548, '#ff0000', '#d2b48c'),
(112, 576, '#0000ff', '#c0c0c0'),
(112, 576, '#00ff00', '#e9ecef'),
(112, 576, '#ff0000', '#d2b48c'),
(113, 461, '#0000ff', '#a19d94'),
(113, 461, '#00ff00', '#9c9b99'),
(113, 461, '#ff0000', '#d2b48c'),
(113, 548, '#0000ff', '#a19d94'),
(113, 548, '#00ff00', '#9c9b99'),
(113, 548, '#ff0000', '#d2b48c'),
(113, 576, '#0000ff', '#a19d94'),
(113, 576, '#00ff00', '#9c9b99'),
(113, 576, '#ff0000', '#d2b48c'),
(114, 461, '#0000ff', '#e7bd42'),
(114, 461, '#00ff00', '#ffea00'),
(114, 461, '#ff0000', '#d2b48c'),
(114, 576, '#0000ff', '#e7bd42'),
(114, 576, '#00ff00', '#ffea00'),
(114, 576, '#ff0000', '#d2b48c'),
(115, 461, '#0000ff', '#1773d1'),
(115, 461, '#00ff00', '#b0ceed'),
(115, 461, '#ff0000', '#d2b48c'),
(115, 548, '#0000ff', '#1773d1'),
(115, 548, '#00ff00', '#b0ceed'),
(115, 548, '#ff0000', '#d2b48c'),
(116, 386, '#00ff00', '#5a189a'),
(116, 386, '#ff0000', '#2f0c50'),
(116, 391, '#0000ff', '#a19d94'),
(116, 391, '#00ff00', '#624a2e'),
(116, 391, '#ff0000', '#5a189a'),
(116, 536, '#00ff00', '#5a189a'),
(116, 536, '#ff0000', '#2f0c50'),
(117, 401, '#00ff00', '#624a2e'),
(117, 401, '#ff0000', '#624a2e'),
(117, 436, '#0000ff', '#624a2e'),
(117, 436, '#00ff00', '#624a2e'),
(117, 436, '#ff0000', '#624a2e'),
(117, 536, '#00ff00', '#624a2e'),
(117, 536, '#ff0000', '#624a2e'),
(118, 401, '#00ff00', '#47632d'),
(118, 401, '#ff0000', '#624a2e'),
(118, 436, '#0000ff', '#47632d'),
(118, 436, '#00ff00', '#47632d'),
(118, 436, '#ff0000', '#624a2e'),
(118, 536, '#00ff00', '#47632d'),
(118, 536, '#ff0000', '#624a2e'),
(119, 401, '#00ff00', '#a19d94'),
(119, 401, '#ff0000', '#624a2e'),
(119, 436, '#0000ff', '#a19d94'),
(119, 436, '#00ff00', '#a19d94'),
(119, 436, '#ff0000', '#624a2e'),
(119, 536, '#00ff00', '#a19d94'),
(119, 536, '#ff0000', '#624a2e'),
(120, 401, '#00ff00', '#e7bd42'),
(120, 401, '#ff0000', '#624a2e'),
(120, 436, '#0000ff', '#e7bd42'),
(120, 436, '#00ff00', '#e7bd42'),
(120, 436, '#ff0000', '#624a2e'),
(120, 536, '#00ff00', '#e7bd42'),
(120, 536, '#ff0000', '#624a2e'),
(121, 401, '#00ff00', '#1773d1'),
(121, 401, '#ff0000', '#191f22'),
(121, 436, '#0000ff', '#1773d1'),
(121, 436, '#00ff00', '#1773d1'),
(121, 436, '#ff0000', '#191f22'),
(121, 536, '#00ff00', '#1773d1'),
(121, 536, '#ff0000', '#191f22'),
(122, 500, '#0000ff', '#624a2e'),
(122, 500, '#00ff00', '#2f0c50'),
(122, 500, '#ff0000', '#5a189a'),
(122, 505, '#0000ff', '#624a2e'),
(122, 505, '#00ff00', '#2f0c50'),
(122, 505, '#ff0000', '#5a189a'),
(122, 536, '#00ff00', '#2f0c50'),
(122, 536, '#ff0000', '#5a189a'),
(123, 192, '#ff0000', '#624a2e'),
(124, 193, '#00ff00', '#ffffff'),
(124, 193, '#ff0000', '#d2b48c'),
(125, 197, '#0000ff', '#9c9b99'),
(125, 197, '#00ff00', '#624a2e'),
(125, 197, '#ff0000', '#d2b48c'),
(126, 197, '#0000ff', '#e7bd42'),
(126, 197, '#00ff00', '#624a2e'),
(126, 197, '#ff0000', '#d2b48c'),
(127, 197, '#0000ff', '#1773d1'),
(127, 197, '#00ff00', '#624a2e'),
(127, 197, '#ff0000', '#d2b48c'),
(128, 197, '#0000ff', '#5a189a'),
(128, 197, '#00ff00', '#624a2e'),
(128, 197, '#ff0000', '#d2b48c'),
(129, 191, '#ff0000', '#624a2e'),
(130, 196, '#0000ff', '#a19d94'),
(130, 196, '#00ff00', '#624a2e'),
(130, 196, '#ff0000', '#624a2e'),
(131, 194, '#0000ff', '#d2b48c'),
(131, 194, '#00ff00', '#624a2e'),
(131, 194, '#ff0000', '#47632d'),
(132, 196, '#0000ff', '#a19d94'),
(132, 196, '#00ff00', '#e7bd42'),
(132, 196, '#ff0000', '#624a2e'),
(133, 196, '#0000ff', '#a19d94'),
(133, 196, '#00ff00', '#1773d1'),
(133, 196, '#ff0000', '#624a2e'),
(134, 196, '#0000ff', '#a19d94'),
(134, 196, '#00ff00', '#5a189a'),
(134, 196, '#ff0000', '#624a2e');

-- --------------------------------------------------------

--
-- Structure de la table `itemsbase`
--

CREATE TABLE `itemsbase` (
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `idType` int(10) UNSIGNED NOT NULL,
  `idRarity` int(10) UNSIGNED NOT NULL,
  `imageItem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `idSousType` int(10) UNSIGNED NOT NULL,
  `isInDefaultLootTable` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `itemsbase`
--

INSERT INTO `itemsbase` (`idBaseItem`, `idType`, `idRarity`, `imageItem`, `idSousType`, `isInDefaultLootTable`) VALUES
(1, 1, 1, 'unknown', 4, 1),
(2, 1, 2, 'unknown', 4, 1),
(3, 1, 3, 'unknown', 4, 1),
(4, 1, 4, 'unknown', 4, 1),
(5, 1, 5, 'unknown', 4, 1),
(6, 2, 1, 'unknown', 6, 1),
(7, 2, 2, 'unknown', 6, 1),
(8, 2, 3, 'unknown', 6, 1),
(9, 2, 4, 'unknown', 6, 1),
(10, 2, 5, 'unknown', 6, 1),
(11, 3, 1, 'unknown', 6, 1),
(12, 3, 2, 'unknown', 6, 1),
(13, 3, 3, 'unknown', 6, 1),
(14, 3, 4, 'unknown', 6, 1),
(15, 3, 5, 'unknown', 6, 1),
(16, 4, 1, 'unknown', 6, 1),
(17, 4, 2, 'unknown', 6, 1),
(18, 4, 3, 'unknown', 6, 1),
(19, 4, 4, 'unknown', 6, 1),
(20, 4, 5, 'unknown', 6, 1),
(21, 5, 1, 'unknown', 1, 0),
(22, 5, 2, 'unknown', 1, 0),
(23, 5, 3, 'unknown', 1, 0),
(24, 5, 4, 'unknown', 1, 0),
(25, 5, 5, 'unknown', 1, 0),
(26, 5, 1, 'unknown', 2, 0),
(27, 5, 2, 'unknown', 2, 0),
(28, 5, 3, 'unknown', 2, 0),
(29, 5, 4, 'unknown', 2, 0),
(30, 5, 5, 'unknown', 2, 0),
(31, 5, 1, 'unknown', 3, 0),
(32, 5, 2, 'unknown', 3, 0),
(33, 5, 3, 'unknown', 3, 0),
(34, 5, 4, 'unknown', 3, 0),
(35, 5, 5, 'unknown', 3, 0),
(36, 8, 1, 'unknown', 11, 0),
(37, 8, 2, 'unknown', 11, 0),
(38, 8, 3, 'unknown', 11, 0),
(39, 8, 4, 'unknown', 11, 0),
(40, 8, 5, 'unknown', 11, 0),
(41, 6, 1, 'unknown', 9, 0),
(42, 7, 5, 'unknown', 10, 0),
(43, 7, 4, 'unknown', 12, 0),
(44, 7, 5, 'unknown', 12, 0),
(45, 1, 6, 'unknown', 4, 0),
(46, 2, 6, 'unknonw', 6, 0),
(47, 3, 6, 'unknonw', 6, 0),
(48, 4, 6, 'unknonw', 6, 0),
(49, 5, 6, 'unknown', 13, 0),
(50, 6, 1, 'unknown', 14, 0),
(51, 6, 2, 'unknown', 14, 0),
(52, 6, 3, 'unknown', 14, 0),
(53, 6, 4, 'unknown', 14, 0),
(54, 6, 5, 'unknown', 14, 0),
(55, 6, 6, 'unknown', 14, 0),
(56, 8, 5, 'unknown', 11, 0),
(75, 1, 1, 'unknown', 20, 1),
(76, 1, 2, 'unknown', 20, 1),
(77, 1, 3, 'unknown', 20, 1),
(78, 1, 4, 'unknown', 20, 1),
(79, 1, 5, 'unknown', 20, 1),
(80, 1, 6, 'unknown', 20, 0),
(81, 1, 1, 'unknown', 21, 1),
(82, 1, 2, 'unknown', 21, 1),
(83, 1, 3, 'unknown', 21, 1),
(84, 1, 4, 'unknown', 21, 1),
(85, 1, 5, 'unknown', 21, 1),
(86, 1, 6, 'unknown', 21, 0),
(87, 1, 1, 'unknown', 22, 1),
(88, 1, 2, 'unknown', 22, 1),
(89, 1, 3, 'unknown', 22, 1),
(90, 1, 4, 'unknown', 22, 1),
(91, 1, 5, 'unknown', 22, 1),
(92, 1, 6, 'unknown', 22, 0),
(93, 1, 1, 'unknown', 23, 1),
(94, 1, 2, 'unknown', 23, 1),
(95, 1, 3, 'unknown', 23, 1),
(96, 1, 4, 'unknown', 23, 1),
(97, 1, 5, 'unknown', 23, 1),
(98, 1, 6, 'unknown', 23, 0),
(99, 2, 1, 'unknown', 18, 1),
(100, 2, 2, 'unknown', 18, 1),
(101, 2, 3, 'unknown', 18, 1),
(102, 2, 4, 'unknown', 18, 1),
(103, 2, 5, 'unknown', 18, 1),
(104, 2, 6, 'unknown', 18, 0),
(105, 2, 1, 'unknown', 19, 1),
(106, 2, 2, 'unknown', 19, 1),
(107, 2, 3, 'unknown', 19, 1),
(108, 2, 4, 'unknown', 19, 1),
(109, 2, 5, 'unknown', 19, 1),
(110, 2, 6, 'unknown', 19, 0),
(111, 3, 1, 'unknown', 18, 1),
(112, 3, 2, 'unknown', 18, 1),
(113, 3, 3, 'unknown', 18, 1),
(114, 3, 4, 'unknown', 18, 1),
(115, 3, 5, 'unknown', 18, 1),
(116, 3, 6, 'unknown', 18, 0),
(117, 3, 1, 'unknown', 19, 1),
(118, 3, 2, 'unknown', 19, 1),
(119, 3, 3, 'unknown', 19, 1),
(120, 3, 4, 'unknown', 19, 1),
(121, 3, 5, 'unknown', 19, 1),
(122, 3, 6, 'unknown', 19, 0),
(123, 4, 1, 'unknown', 18, 1),
(124, 4, 2, 'unknown', 18, 1),
(125, 4, 3, 'unknown', 18, 1),
(126, 4, 4, 'unknown', 18, 1),
(127, 4, 5, 'unknown', 18, 1),
(128, 4, 6, 'unknown', 18, 0),
(129, 4, 1, 'unknown', 19, 1),
(130, 4, 2, 'unknown', 19, 1),
(131, 4, 3, 'unknown', 19, 1),
(132, 4, 4, 'unknown', 19, 1),
(133, 4, 5, 'unknown', 19, 1),
(134, 4, 6, 'unknown', 19, 0),
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

-- --------------------------------------------------------

--
-- Structure de la table `itemspower`
--

CREATE TABLE `itemspower` (
  `idItem` bigint(20) UNSIGNED NOT NULL,
  `power` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `itemsrarities`
--

CREATE TABLE `itemsrarities` (
  `idRarity` int(10) UNSIGNED NOT NULL,
  `nomRarity` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `couleurRarity` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `itemsrarities`
--

INSERT INTO `itemsrarities` (`idRarity`, `nomRarity`, `couleurRarity`) VALUES
(1, 'common', '#FFFFFF'),
(2, 'rare', '#00FF00'),
(3, 'superior', '#0000FF'),
(4, 'epic', '#FF00FF'),
(5, 'legendary', '#C80000'),
(6, 'mythic', '#FFA500');

-- --------------------------------------------------------

--
-- Structure de la table `itemssecondarystats`
--

CREATE TABLE `itemssecondarystats` (
  `idItem` bigint(20) UNSIGNED NOT NULL,
  `idSecondaryStat` int(10) UNSIGNED NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `itemssecondarystatselementalresists`
--

CREATE TABLE `itemssecondarystatselementalresists` (
  `idItem` bigint(20) UNSIGNED NOT NULL,
  `idElementType` int(10) UNSIGNED NOT NULL,
  `value` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `itemssoustypes`
--

CREATE TABLE `itemssoustypes` (
  `idSousType` int(10) UNSIGNED NOT NULL,
  `nomSousType` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `itemssoustypes`
--

INSERT INTO `itemssoustypes` (`idSousType`, `nomSousType`) VALUES
(1, 'ore'),
(2, 'plant'),
(3, 'wood'),
(4, 'sword'),
(5, 'whip'),
(6, 'metal'),
(7, 'loot_box_equipment'),
(8, 'loot_box_equipment'),
(9, 'reset_time_potion'),
(10, 'founder_box'),
(11, 'horse'),
(12, 'random_loot_box_equipment'),
(13, 'crystal'),
(14, 'energy_potion'),
(18, 'cloth'),
(19, 'leather'),
(20, 'bow'),
(21, 'dagger'),
(22, 'wand'),
(23, 'staff');

-- --------------------------------------------------------

--
-- Structure de la table `itemsstats`
--

CREATE TABLE `itemsstats` (
  `idItem` bigint(20) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `itemstypes`
--

CREATE TABLE `itemstypes` (
  `idType` int(10) UNSIGNED NOT NULL,
  `nomType` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `equipable` tinyint(4) NOT NULL DEFAULT '1',
  `stackable` tinyint(4) NOT NULL DEFAULT '0',
  `usable` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `itemstypes`
--

INSERT INTO `itemstypes` (`idType`, `nomType`, `equipable`, `stackable`, `usable`) VALUES
(1, 'weapon', 1, 0, 0),
(2, 'chest', 1, 0, 0),
(3, 'legs', 1, 0, 0),
(4, 'head', 1, 0, 0),
(5, 'resource', 0, 1, 0),
(6, 'potion', 0, 1, 1),
(7, 'lootbox', 0, 1, 1),
(8, 'mount', 1, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `languages`
--

CREATE TABLE `languages` (
  `lang` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `languages`
--

INSERT INTO `languages` (`lang`) VALUES
('en'),
('es'),
('fr'),
('pt-BR'),
('ru'),
('vi');

-- --------------------------------------------------------

--
-- Structure de la table `levels`
--

CREATE TABLE `levels` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `actualExp` int(10) UNSIGNED NOT NULL,
  `actualLevel` int(10) UNSIGNED NOT NULL,
  `rebirthLevel` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `levelsrequire`
--

CREATE TABLE `levelsrequire` (
  `level` int(10) UNSIGNED NOT NULL,
  `expNextLevel` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `levelsrequire`
--

INSERT INTO `levelsrequire` (`level`, `expNextLevel`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `linkedappearances`
--

CREATE TABLE `linkedappearances` (
  `idAppearance` int(10) UNSIGNED NOT NULL,
  `idLinkedAppearance` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `linkedappearances`
--

INSERT INTO `linkedappearances` (`idAppearance`, `idLinkedAppearance`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `localizationachievements`
--

CREATE TABLE `localizationachievements` (
  `idAchievement` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameAchievement` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descAchievement` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationachievements`
--

INSERT INTO `localizationachievements` (`idAchievement`, `lang`, `nameAchievement`, `descAchievement`) VALUES
(1, 'en', 'Founder', 'Available only to players who were there during the beta phase of the game.'),
(1, 'es', 'Fundador', 'Disponible sólo para los jugadores que estuvieron en la fase beta del juego.'),
(1, 'fr', 'Fondateur', 'Disponible uniquement aux joueurs qui étaient là lors de la phase beta du jeu.'),
(1, 'pt-BR', 'Fundador', 'Disponível apenas para jogadores que estavam lá durante a fase beta do jogo.'),
(1, 'ru', 'Основатель', 'Доступен только для игроков, которые были там во время бета-фазе игры.'),
(2, 'en', 'One last challenge', 'Fight the Boss inside the dungeon level 100 and win the battle to unlock access to the Antique Dwarf Forge!'),
(2, 'es', 'Un último desafío', '¡Lucha contra el jefe dentro de la mazmorra nivel 100 y gana la batalla para desbloquear el acceso a la Antigua Fragua Enana!'),
(2, 'fr', 'Un Dernier Défi', 'Combattez le Boss du Donjon niveau 100 et gagnez le combat pour débloquer l\'accès à la forge antique naine !'),
(2, 'pt-BR', 'Um último desafio', 'Lute com o Chefe dentro da masmorra nível 100 e vença a batalha para liberar o acesso à Antiga Forja Anã!'),
(2, 'ru', 'Последний вызов', 'Борьба с боссом внутри подземелья уровня 100 и выиграть битву, чтобы открыть доступ к Антикварной кузнице гномов!'),
(3, 'en', 'Shining armor', 'Equip yourself with a set of equipment of level 100 or higher, of mythical quality.'),
(3, 'fr', 'Armure luisante', 'Équipez vous d\'un ensemble d’équipements de niveau 100 ou plus, de qualité mythique.'),
(4, 'en', 'Epicurean luck', 'Get an epic-quality equipment from a fight.'),
(4, 'fr', 'Chance épicurienne', 'Obtenez un équipement de qualité épique lors d\'un combat.'),
(5, 'en', 'Legend diary', 'Get an legendary-quality equipment from a fight.'),
(5, 'fr', 'Les gens d\'air', 'Obtenez un équipement de qualité légendaire lors d\'un combat.'),
(6, 'en', 'Discovery of the depths', 'Complete any dungeon.'),
(6, 'fr', 'Découverte des profondeurs', 'Terminez n\'importe quel donjon.'),
(7, 'en', 'Hangout with friends', 'Have a group fight.'),
(7, 'fr', 'Sortie entre amis', 'Faites un combat en groupe.'),
(8, 'en', 'Newbie', 'Reach level 20.'),
(8, 'fr', 'Noob', 'Atteindre le niveau 20.'),
(9, 'en', 'Experienced player', 'Reach level 100.'),
(9, 'fr', 'Joueur expérimenté', 'Atteindre le niveau 100.'),
(10, 'en', 'Beginner craftsman', 'Craft your first item.'),
(10, 'fr', 'Artisan débutant', 'Fabriquez votre premier objet.'),
(11, 'en', 'Social adventurer', 'Join a guild.'),
(11, 'fr', 'Aventurier social', 'Rejoindre une guilde.'),
(12, 'en', 'Experienced figther', 'Win 1,000 fights.'),
(12, 'fr', 'Combattant chevronné', 'Gagner 1 000 combats.'),
(13, 'en', 'Addict figther', 'Win 10,000 fights.'),
(13, 'fr', 'Combattant addict', 'Gagner 10 000 combats.'),
(14, 'en', 'Motivated craftsman', 'Reach level 20 in craft.'),
(14, 'fr', 'Artisan motivé', 'Atteindre le niveau 20 en fabrication d\'objets.'),
(15, 'en', 'Experienced craftsman', 'Reach level 100 in craft.'),
(15, 'fr', 'Artisan expérimenté', 'Atteindre le niveau 100 en fabrication d\'objets.');

-- --------------------------------------------------------

--
-- Structure de la table `localizationareas`
--

CREATE TABLE `localizationareas` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameArea` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descArea` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationareas`
--

INSERT INTO `localizationareas` (`idArea`, `lang`, `nameArea`, `descArea`) VALUES
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
(34, 'pt-BR', 'Antiga Forja Anã', 'Uma vez nesta forja anã, muitas armas lendárias foram criadas pelos anões mais habilidosos desta região, aquecidos pelo fogo desta forja. Agora muitas dessas armas estão perdidas, ou enterradas na neve. Tesouros lendários que aguardam por serem encontrados.'),
(35, 'en', 'Groundfire Bridge', 'If you think it\'s hot, don\'t cross that bridge, you might melt...'),
(35, 'fr', 'Le pont des nappes feu-à-tiques', 'Si tu trouve qu\'il fait chaud, ne traverse pas ce pont, tu risque de fondre.'),
(36, 'en', 'Tywardreath Caves Entrance', 'Only the entrance to a cold and humid cave, rumors say a powerful monster is hiding there...'),
(36, 'fr', 'Entrée des grottes de Tywardreath', 'Seulement l\'entrée d\'une grotte froide et humide, des rumeurs racontent qu\'un monstre puissant s\'y cache.'),
(37, 'en', 'Entrance of The Forgotten Tombs', 'You don\'t know what lies within these walls. Come to think of it, you should find a lot of sand...'),
(37, 'fr', 'Entrée des Tombes Oubliées', 'Vous ne savez pas ce qu\'il se trouve entre ces murs. En y repensant, vous devriez trouver énormément de sable...'),
(38, 'en', 'Entrance of The Daemonic Citadel', 'You\'re on the verge of trouble. Only the bravest can enter the citadel and hope to vanquish the raging hordes of demons...'),
(38, 'fr', 'Entrée de La Citadelle Démoniaque', 'Vous êtes au abords des problèmes. Seuls les plus braves peuvent entrer dans la citadelle et espérer vaincre les hordes démons enragés...'),
(39, 'en', 'Entrance of Ice Mirror Cave', 'The entrance to this cave is not welcoming. It sends chills down your spine. Perhaps you will discover mysteries buried in this frozen place.'),
(39, 'fr', 'Entrée de la Caverne des Miroirs de Glace', 'L\'entrée de cette grotte n\'est pas accueillante. Elle vous fait froid dans le dos. Peut-être découvrirez vous des mystères enfouis dans cet endroit glacé.');

-- --------------------------------------------------------

--
-- Structure de la table `localizationbosses`
--

CREATE TABLE `localizationbosses` (
  `idBoss` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameBoss` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'generic'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationbosses`
--

INSERT INTO `localizationbosses` (`idBoss`, `lang`, `nameBoss`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `localizationevents`
--

CREATE TABLE `localizationevents` (
  `idEvent` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `desc` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationevents`
--

INSERT INTO `localizationevents` (`idEvent`, `lang`, `title`, `desc`) VALUES
(1, 'en', 'Fight RPG - Anniversary!', 'One more year for FightRPG! Ah, how time flies. Let\'s celebrate together!'),
(1, 'fr', 'Fight RPG - Anniversaire !', 'Un an de plus pour FightRPG ! Ah, que le temps passe vite. C�l�brons �a ensemble !'),
(2, 'en', 'Update 1.12 - On your marks, set, collect!', 'A harvest bonus is required due to changes in the ingredients needed to make items'),
(2, 'fr', 'A vos marques, pr�ts, collectez !', 'Un bonus � la r�colte est n�cessaire au vu des changements apport�s aux ingr�dients n�cessaires pour fabriquer les objets.');

-- --------------------------------------------------------

--
-- Structure de la table `localizationitems`
--

CREATE TABLE `localizationitems` (
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameItem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `descItem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationitems`
--

INSERT INTO `localizationitems` (`idBaseItem`, `lang`, `nameItem`, `descItem`) VALUES
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
(56, 'pt-BR', 'Cavalo Gélido', 'Este cavalo viveu por tanto tempo neste paraíso frio e sem vida que agora ele e o clima local são um só.'),
(75, 'en', 'Rudimentary Bow', 'A banal bow.'),
(75, 'fr', 'Arc Rudimentaire', 'Un arc vraiment banal.'),
(76, 'en', 'Wooden Bow', 'A wooden bow, at the same time what did you expect?'),
(76, 'fr', 'Arc en Bois', 'Un arc en bois, en même temps vous vous attendiez à quoi ?'),
(77, 'en', 'Reinforced Wooden Bow', 'A warrior\'s bow.'),
(77, 'fr', 'Arc en Bois Renforcé', 'Un arc de guerrier.'),
(78, 'en', 'Ornamented Wooden Bow', 'Here we go again, gems.'),
(78, 'fr', 'Arc en Bois Orné', 'Et voilà, ça fait le fier avec ses gemmes.'),
(79, 'en', 'Bow of Excellent Craftsmanship', 'An exceptional quality, I wonder if you deserve it...'),
(79, 'fr', 'Arc d\'Excellente Manufacture', 'Une qualité exceptionnelle, je me demande si vous le méritez...'),
(80, 'en', 'Chaos Bow', 'This bow is made of magic from chaos shards from another dimension.'),
(80, 'fr', 'Arc du Chaos', 'Cet arc est fait de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(81, 'en', 'Rudimentary Dagger', 'Short, banal, I hope you don\'t think of anything else.'),
(81, 'fr', 'Dague Rudimentaire', 'Courte, banale, j\'espère que vous ne pensez pas à quelque chose d\'autre.'),
(82, 'en', 'Silver Dagger', 'A werewolf toothpick.'),
(82, 'fr', 'Dague en Argent', 'Un cure-dent anti loup-garou.'),
(83, 'en', 'Iron Dagger', 'An iron dagger, nothing more banal'),
(83, 'fr', 'Dague en Fer', 'Une dague en fer, rien de plus banal'),
(84, 'en', 'Golden Dagger', 'A beautiful golden dagger, too bad it is so short.'),
(84, 'fr', 'Dague en Or', 'Une belle dague en or, dommage qu\'elle soit si courte.'),
(85, 'en', 'Mithril Dagger', 'Small but powerful.'),
(85, 'fr', 'Dague en Mithril', 'Petite mais puissante.'),
(86, 'en', 'Chaos Dagger', 'This dagger is made of magic from chaos shards from another dimension.'),
(86, 'fr', 'Dague du Chaos', 'Cette dague est faite de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(87, 'en', 'Rudimentary Wand', 'A banal wand.'),
(87, 'fr', 'Baguette Rudimentaire', 'Une baguette vraiment banale.'),
(88, 'en', 'Wooden Wand', 'A wooden wand, you surely throw its splinters.'),
(88, 'fr', 'Baguette en Bois', 'Une baguette en bois, vous lancez sûrement ses échardes...'),
(89, 'en', 'Reinforced Wooden Wand', 'A majorette\'s wand, er, sorry, wizard\'s wand.'),
(89, 'fr', 'Baguette en Bois Renforcé', 'Une baguette de majorette, euh, pardon, de sorcier.'),
(90, 'en', 'Ornamented Wooden Wand', 'It takes at least a few gems for the magic to work.'),
(90, 'fr', 'Baguette en Bois Orné', 'Il faut au moins quelques gemmes pour que la magie opère.'),
(91, 'en', 'Wand of Excellent Craftsmanship', 'An exceptional quality, for a piece of wood, it looks great!'),
(91, 'fr', 'Baguette d\'Excellente Manufacture', 'Une qualité exceptionnelle, pour un morceau de bois, ça en jette !'),
(92, 'en', 'Chaos Wand', 'This wand is made of magic from chaos shards from another dimension.'),
(92, 'fr', 'Baguette du Chaos', 'Cette baguette est faite de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(93, 'en', 'Rudimentary Staff', 'A banal staff'),
(93, 'fr', 'Baton Rudimentaire', 'Un baton vraiment banal.'),
(94, 'en', 'Silver Staff', 'Silver, really? Do you think you\'re Bigdalf?'),
(94, 'fr', 'Baton en Argent', 'De l\'argent, vraiment ? Vous vous prenez pour Grosdalf ?'),
(95, 'en', 'Iron Staff', 'Iron? And what next? Gold? You think that drives the magic?'),
(95, 'fr', 'Baton en Fer', 'Du fer ? Et ce sera quoi la suite ? De l\'or ? Vous pensez que ça conduit la magie ?'),
(96, 'en', 'Golden Staff', 'Oh no, gold, well, maybe, it really does drive the magic.'),
(96, 'fr', 'Baton en Or', 'Oh non, de l\'or, bon, si ça se trouve, ça conduit vraiment la magie.'),
(97, 'en', 'Mithril Staff', 'Mithril, really? What\'s your excuse this time?'),
(97, 'fr', 'Baton en Mithril', 'Du Mithril, vraiment ? C\'est quoi votre excuse cette fois ?'),
(98, 'en', 'Chaos Staff', 'This staff is made of magic from chaos shards from another dimension.'),
(98, 'fr', 'Baton du Chaos', 'Ce baton est fait de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(99, 'en', 'Rudimentary Chest Clothing', 'A beggar is better dressed.'),
(99, 'fr', 'Chemisier Rudimentaire', 'Un mendiant est mieu vêtu.'),
(100, 'en', 'Silvery Chest Clothing', 'Given the contact of silver on your skin, I\'m sure you\'re not a werewolf.'),
(100, 'fr', 'Chemisier Argenté', 'Vu le contact de l\'argent sur la peau, je suis sûr que tu n\'es pas un loup-garou.'),
(101, 'en', 'Irony Chest Clothing', 'Isn\'t the name funny?'),
(101, 'fr', 'Chemisier Ironique', 'Est-ce que nom n\'est pas amusant ?'),
(102, 'en', 'Golden Chest Clothing', 'Are you proud with all that gold?'),
(102, 'fr', 'Chemisier Doré', 'Vous faites le fier avec tout cet or ?'),
(103, 'en', 'Chest Clothing Orned With Mithril', 'It\'s beautiful, and it looks like something a certain Brodon used to wear.'),
(103, 'fr', 'Chemisier Orné de Mithril', 'C\'est beau, et ça ressemble à ce qu\'un certain Brodon portait.'),
(104, 'en', 'Chaos Chest Clothing', 'This chest clothing is made of magic from chaos shards from another dimension.'),
(104, 'fr', 'Chemisier du Chaos', 'Cette tenue est faite de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(105, 'en', 'Used Leather Chest Armor', 'Already used, with traces of... combat.'),
(105, 'fr', 'Armure de Torse en Cuir d\'Occasion', 'Déjà utilisée, avec des traces de... combat.'),
(106, 'en', 'Leather Chest Armor', 'Leather, straps, and boom, it\'s something ordinary.'),
(106, 'fr', 'Armure de Torse en Cuir', 'Du cuir, des sangles, et boum ça fait quelque chose de banal.'),
(107, 'en', 'Thief\'s Leather Chest Armor', 'With this, you\'re sure to get arrested.'),
(107, 'fr', 'Armure de Torse en Cuir du Voleur', 'Avec ça, c\'est sûr vous vous faites arrêter.'),
(108, 'en', 'Ornamented Leather Chest Armor', 'Leather, metal, it\'s beautiful.'),
(108, 'fr', 'Armure de Torse en Cuir Orné', 'Du cuir, des métaux, c\'est beau.'),
(109, 'en', 'Beautiful Leather Chest Armor', 'Leather and mithril? Truly ingenious.'),
(109, 'fr', 'Magnifique Armure de Torse en Cuir', 'Du cuir, et du mithril ? Vraiment ingénieux.'),
(110, 'en', 'Chaos Leather Chest Armor', 'This leather chest armor is made of magic from chaos shards from another dimension.'),
(110, 'fr', 'Armure de Torse en Cuir du Chaos', 'Cette armure en cuir est faite de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(111, 'en', 'Used Cloth Leggings', 'Already used, with traces of... magic'),
(111, 'fr', 'Jambières en Tissu Usé', 'Déjà utilisée, avec des traces de... magie.'),
(112, 'en', 'Cloth Leggings', 'Cloth, magic, and boom, it does something banal.'),
(112, 'fr', 'Jambières en Tissu', 'Du tissu, de la magie, et boum ça fait quelque chose de banal.'),
(113, 'en', 'Mage\'s Cloth Leggings', 'I had never seen under a magician\'s skirt, it\'s not a pretty sight.'),
(113, 'fr', 'Jambières en Tissu du Mage', 'J\'avais jamais vu sous la jupe d\'un mage, c\'est pas beau à voir.'),
(114, 'en', 'Ornamented Cloth Leggings', 'Beautiful family jewels. Ah sorry, it\'s your leggings.'),
(114, 'fr', 'Jambières en Tissu Orné', 'De beau bijous de famille. Ah pardon, c\'est vos jambières.'),
(115, 'en', 'Beautiful CLoth Leggings', 'They are magnificent... I\'m talking about your leggings.'),
(115, 'fr', 'Magnifiques Jambières en Tissu', 'Elle sont magnfiques... Je parle de vos jambières.'),
(116, 'en', 'Chaos Cloth Leggings', 'This cloth leggings is made of magic from chaos shards from another dimension.'),
(116, 'fr', 'Jambière en Tissu du Chaos', 'Ces jambières en tissu sont faites de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(117, 'en', 'Used Leather Leggings', 'Already used, with traces of... combat.'),
(117, 'fr', 'Jambières en Cuir Usé', 'Déjà utilisée, avec des traces de... combat.'),
(118, 'en', 'Leather Leggings', 'Leather, straps, and boom, it\'s something ordinary.'),
(118, 'fr', 'Jambières en Cuir', 'Du cuir, des sangles, et boum ça fait quelque chose de banal.'),
(119, 'en', 'Thief\'s Leather Leggings', 'With this, you\'re sure to get arrested.'),
(119, 'fr', 'Jambières en Cuir du Voleur', 'Avec ça, c\'est sûr vous vous faites arrêter.'),
(120, 'en', 'Ornamented Leather Leggings', 'Leather, metal, it\'s beautiful.'),
(120, 'fr', 'Jambières en Cuir Orné', 'Du cuir, des métaux, c\'est beau.'),
(121, 'en', 'Beautiful Leather Leggings', 'Leather and mithril? Truly ingenious.'),
(121, 'fr', 'Magnifiques Jambières en Cuir', 'Du cuir, et du mithril ? Vraiment ingénieux.'),
(122, 'en', 'Chaos Leather Leggings', 'This leather leggings is made of magic from chaos shards from another dimension.'),
(122, 'fr', 'Jambière en Cuir du Chaos', 'Ces jambières en cuir sont faites de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(123, 'en', 'Used Cloth Hat', 'Already used, not very popular. If you wear it, you\'re a has-been.'),
(123, 'fr', 'Chapeau en Tissu Usé', 'Déjà utilisé, pas très fashion. Si vous le portez, vous êtes has been.'),
(124, 'en', 'Cloth Hat', 'Really Banal and Ugly, not even sure if it protects you from the rain.'),
(124, 'fr', 'Chapeau en Tissu', 'Vraiment Banal et Moche, même pas sûr que cela vous protège de la pluie.'),
(125, 'en', 'Mage\'s Cloth Hat', 'You become the magician\'s cliché with this hat.'),
(125, 'fr', 'Chapeau en Tissu de Mage', 'Vous devenez le cliché du mage avec ce chapeau.'),
(126, 'en', 'Ornamented Cloth Hat', 'We have to stop this fashion of hats with gems.'),
(126, 'fr', 'Chapeau en Tissu Orné', 'Faut arrêter cette mode des chapeaux avec des gemmes.'),
(127, 'en', 'Magical Cloth Hat', 'It\'s magic, it\'s your sorting hat.'),
(127, 'fr', 'Chapeau en Tissu Magique', 'Il est magique, c\'est votre choixpeau.'),
(128, 'en', 'Chaos Cloth Hat', 'This cloth hat is made of magic from chaos shards from another dimension.'),
(128, 'fr', 'Chapeau en Tissu du Chaos', 'Ce chapeau en tissu est fait de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(129, 'en', 'Used Leather Hat', 'It protects from the rain, that\'s all.'),
(129, 'fr', 'Chapeau en Cuir Usé', 'Il protège de la pluie, c\'est tout.'),
(130, 'en', 'Leather Hat', 'I don\'t know about that style.'),
(130, 'fr', 'Chapeau en Cuir', 'Je ne sais pas quoi dire de ce style.'),
(131, 'en', 'Archer\'s hat', 'Does this... thing protect you from arrows?'),
(131, 'fr', 'Chapeau d\'Archer', 'Est-ce que cette... chose vous protège des flèches ?'),
(132, 'en', 'Ornamented Leather Hat', 'These few gems don\'t help you look your best.'),
(132, 'fr', 'Chapeau en Cuir Orné', 'Ces quelques gemmes ne vous aide pas à paraître sous un meilleur jour.'),
(133, 'en', 'Vibrating Leather Hat', 'It is not a legend! This hat is vibrating! Is it scared?'),
(133, 'fr', 'Chapeau en Cuir Vibrant', 'Ce n\'est pas une légende ! Ce chapeau vibre ! Est-ce qu\'il aurait peur ?'),
(134, 'en', 'Chaos Leather Hat', 'This leather hat is made of magic from chaos shards from another dimension.'),
(134, 'fr', 'Chapeau en Cuir du Chaos', 'Ce chapeau en cuir est fait de magie provenant d\'éclats du chaos appartenant à une autre dimension.'),
(135, 'en', 'Sandy Iron', ''),
(135, 'es', 'Sandy Iron', ''),
(135, 'fr', 'Fer Ensabl�', ''),
(135, 'pt-BR', 'Sandy Iron', ''),
(135, 'ru', 'Sandy Iron', ''),
(135, 'vi', 'Sandy Iron', ''),
(136, 'en', 'Burning Iron', ''),
(136, 'es', 'Burning Iron', ''),
(136, 'fr', 'Fer Br�lant', ''),
(136, 'pt-BR', 'Burning Iron', ''),
(136, 'ru', 'Burning Iron', ''),
(136, 'vi', 'Burning Iron', ''),
(137, 'en', 'Freezing Iron', ''),
(137, 'es', 'Freezing Iron', ''),
(137, 'fr', 'Fer Glacial', ''),
(137, 'pt-BR', 'Freezing Iron', ''),
(137, 'ru', 'Freezing Iron', ''),
(137, 'vi', 'Freezing Iron', ''),
(138, 'en', 'Flax', ''),
(138, 'es', 'Flax', ''),
(138, 'fr', 'Lin', ''),
(138, 'pt-BR', 'Flax', ''),
(138, 'ru', 'Flax', ''),
(138, 'vi', 'Flax', ''),
(139, 'en', 'Yellow Flax', ''),
(139, 'es', 'Yellow Flax', ''),
(139, 'fr', 'Lin Jaune', ''),
(139, 'pt-BR', 'Yellow Flax', ''),
(139, 'ru', 'Yellow Flax', ''),
(139, 'vi', 'Yellow Flax', ''),
(140, 'en', 'Red Flax', ''),
(140, 'es', 'Red Flax', ''),
(140, 'fr', 'Lin Rouge', ''),
(140, 'pt-BR', 'Red Flax', ''),
(140, 'ru', 'Red Flax', ''),
(140, 'vi', 'Red Flax', ''),
(141, 'en', 'Crystallised Flax', ''),
(141, 'es', 'Crystallised Flax', ''),
(141, 'fr', 'Lin Crystalis�', ''),
(141, 'pt-BR', 'Crystallised Flax', ''),
(141, 'ru', 'Crystallised Flax', ''),
(141, 'vi', 'Crystallised Flax', ''),
(142, 'en', 'Oak Wood', ''),
(142, 'es', 'Oak Wood', ''),
(142, 'fr', 'Bois de Ch�ne', ''),
(142, 'pt-BR', 'Oak Wood', ''),
(142, 'ru', 'Oak Wood', ''),
(142, 'vi', 'Oak Wood', ''),
(143, 'en', 'Burnt Wood', ''),
(143, 'es', 'Burnt Wood', ''),
(143, 'fr', 'Bois Brul�', ''),
(143, 'pt-BR', 'Burnt Wood', ''),
(143, 'ru', 'Burnt Wood', ''),
(143, 'vi', 'Burnt Wood', ''),
(144, 'en', 'Ice Wood', ''),
(144, 'es', 'Ice Wood', ''),
(144, 'fr', 'Bois Glacial', ''),
(144, 'pt-BR', 'Ice Wood', ''),
(144, 'ru', 'Ice Wood', ''),
(144, 'vi', 'Ice Wood', ''),
(145, 'en', 'Leather', ''),
(145, 'es', 'Leather', ''),
(145, 'fr', 'Cuir Simple', ''),
(145, 'pt-BR', 'Leather', ''),
(145, 'ru', 'Leather', ''),
(145, 'vi', 'Leather', ''),
(146, 'en', 'Sandy Leather', ''),
(146, 'es', 'Sandy Leather', ''),
(146, 'fr', 'Cuir Ensabl�', ''),
(146, 'pt-BR', 'Sandy Leather', ''),
(146, 'ru', 'Sandy Leather', ''),
(146, 'vi', 'Sandy Leather', ''),
(147, 'en', 'Smoky Leather', ''),
(147, 'es', 'Smoky Leather', ''),
(147, 'fr', 'Cuir Allum�', ''),
(147, 'pt-BR', 'Smoky Leather', ''),
(147, 'ru', 'Smoky Leather', ''),
(147, 'vi', 'Smoky Leather', ''),
(148, 'en', 'Frosty Leather', ''),
(148, 'es', 'Frosty Leather', ''),
(148, 'fr', 'Cuir Glacial', ''),
(148, 'pt-BR', 'Frosty Leather', ''),
(148, 'ru', 'Frosty Leather', ''),
(148, 'vi', 'Frosty Leather', ''),
(149, 'en', 'Sandy Gold', ''),
(149, 'es', 'Sandy Gold', ''),
(149, 'fr', 'Or Sablonneux', ''),
(149, 'pt-BR', 'Sandy Gold', ''),
(149, 'ru', 'Sandy Gold', ''),
(149, 'vi', 'Sandy Gold', ''),
(150, 'en', 'Molten Gold', ''),
(150, 'es', 'Molten Gold', ''),
(150, 'fr', 'Or en fusion', ''),
(150, 'pt-BR', 'Molten Gold', ''),
(150, 'ru', 'Molten Gold', ''),
(150, 'vi', 'Molten Gold', ''),
(151, 'en', 'Frozen Gold', ''),
(151, 'es', 'Frozen Gold', ''),
(151, 'fr', 'Or Gel�', ''),
(151, 'pt-BR', 'Frozen Gold', ''),
(151, 'ru', 'Frozen Gold', ''),
(151, 'vi', 'Frozen Gold', ''),
(152, 'en', 'Cotton', ''),
(152, 'es', 'Cotton', ''),
(152, 'fr', 'Coton', ''),
(152, 'pt-BR', 'Cotton', ''),
(152, 'ru', 'Cotton', ''),
(152, 'vi', 'Cotton', ''),
(153, 'en', 'Arid Cotton', ''),
(153, 'es', 'Arid Cotton', ''),
(153, 'fr', 'Coton Aride', ''),
(153, 'pt-BR', 'Arid Cotton', ''),
(153, 'ru', 'Arid Cotton', ''),
(153, 'vi', 'Arid Cotton', ''),
(154, 'en', 'Burning Cotton', ''),
(154, 'es', 'Burning Cotton', ''),
(154, 'fr', 'Coton Br�lant', ''),
(154, 'pt-BR', 'Burning Cotton', ''),
(154, 'ru', 'Burning Cotton', ''),
(154, 'vi', 'Burning Cotton', ''),
(155, 'en', 'Icy Cotton', ''),
(155, 'es', 'Icy Cotton', ''),
(155, 'fr', 'Coton Glac�', ''),
(155, 'pt-BR', 'Icy Cotton', ''),
(155, 'ru', 'Icy Cotton', ''),
(155, 'vi', 'Icy Cotton', ''),
(156, 'en', 'Cactus with Branches', ''),
(156, 'es', 'Cactus with Branches', ''),
(156, 'fr', 'Cactus � Branches', ''),
(156, 'pt-BR', 'Cactus with Branches', ''),
(156, 'ru', 'Cactus with Branches', ''),
(156, 'vi', 'Cactus with Branches', ''),
(157, 'en', 'Vitrified Wood', ''),
(157, 'es', 'Vitrified Wood', ''),
(157, 'fr', 'Bois Vitrifi�', ''),
(157, 'pt-BR', 'Vitrified Wood', ''),
(157, 'ru', 'Vitrified Wood', ''),
(157, 'vi', 'Vitrified Wood', ''),
(158, 'en', 'Ice Branch', ''),
(158, 'es', 'Ice Branch', ''),
(158, 'fr', 'Branche de Glace', ''),
(158, 'pt-BR', 'Ice Branch', ''),
(158, 'ru', 'Ice Branch', ''),
(158, 'vi', 'Ice Branch', ''),
(159, 'en', 'Resistant Leather', ''),
(159, 'es', 'Resistant Leather', ''),
(159, 'fr', 'Cuir Resistant', ''),
(159, 'pt-BR', 'Resistant Leather', ''),
(159, 'ru', 'Resistant Leather', ''),
(159, 'vi', 'Resistant Leather', ''),
(160, 'en', 'Striped Leather', ''),
(160, 'es', 'Striped Leather', ''),
(160, 'fr', 'Cuir � Rayures', ''),
(160, 'pt-BR', 'Striped Leather', ''),
(160, 'ru', 'Striped Leather', ''),
(160, 'vi', 'Striped Leather', ''),
(161, 'en', 'Red Scaled Leather', ''),
(161, 'es', 'Red Scaled Leather', ''),
(161, 'fr', 'Cuir � Ecailles Rouges', ''),
(161, 'pt-BR', 'Red Scaled Leather', ''),
(161, 'ru', 'Red Scaled Leather', ''),
(161, 'vi', 'Red Scaled Leather', ''),
(162, 'en', 'Flexible Ice', ''),
(162, 'es', 'Flexible Ice', ''),
(162, 'fr', 'Glace Flexible', ''),
(162, 'pt-BR', 'Flexible Ice', ''),
(162, 'ru', 'Flexible Ice', ''),
(162, 'vi', 'Flexible Ice', ''),
(163, 'en', 'Damaged Mithril', ''),
(163, 'es', 'Damaged Mithril', ''),
(163, 'fr', 'Mithril Abim�', ''),
(163, 'pt-BR', 'Damaged Mithril', ''),
(163, 'ru', 'Damaged Mithril', ''),
(163, 'vi', 'Damaged Mithril', ''),
(164, 'en', 'Sandy Mithril', ''),
(164, 'es', 'Sandy Mithril', ''),
(164, 'fr', 'Mithril Ensabl�', ''),
(164, 'pt-BR', 'Sandy Mithril', ''),
(164, 'ru', 'Sandy Mithril', ''),
(164, 'vi', 'Sandy Mithril', ''),
(165, 'en', 'Heat Deformed Mithril', ''),
(165, 'es', 'Heat Deformed Mithril', ''),
(165, 'fr', 'Mithril D�form� par la Chaleur', ''),
(165, 'pt-BR', 'Heat Deformed Mithril', ''),
(165, 'ru', 'Heat Deformed Mithril', ''),
(165, 'vi', 'Heat Deformed Mithril', ''),
(166, 'en', 'Magnificent Wool', ''),
(166, 'es', 'Magnificent Wool', ''),
(166, 'fr', 'Laine Magnifique', ''),
(166, 'pt-BR', 'Magnificent Wool', ''),
(166, 'ru', 'Magnificent Wool', ''),
(166, 'vi', 'Magnificent Wool', ''),
(167, 'en', 'Arid Wool', ''),
(167, 'es', 'Arid Wool', ''),
(167, 'fr', 'Laine Aride', ''),
(167, 'pt-BR', 'Arid Wool', ''),
(167, 'ru', 'Arid Wool', ''),
(167, 'vi', 'Arid Wool', ''),
(168, 'en', 'Warm Wool', ''),
(168, 'es', 'Warm Wool', ''),
(168, 'fr', 'Laine Chaude', ''),
(168, 'pt-BR', 'Warm Wool', ''),
(168, 'ru', 'Warm Wool', ''),
(168, 'vi', 'Warm Wool', ''),
(169, 'en', 'Cold Wool', ''),
(169, 'es', 'Cold Wool', ''),
(169, 'fr', 'Laine Froide', ''),
(169, 'pt-BR', 'Cold Wool', ''),
(169, 'ru', 'Cold Wool', ''),
(169, 'vi', 'Cold Wool', ''),
(170, 'en', 'Noble Wood', ''),
(170, 'es', 'Noble Wood', ''),
(170, 'fr', 'Bois Noble', ''),
(170, 'pt-BR', 'Noble Wood', ''),
(170, 'ru', 'Noble Wood', ''),
(170, 'vi', 'Noble Wood', ''),
(171, 'en', 'Royal Cactus', ''),
(171, 'es', 'Royal Cactus', ''),
(171, 'fr', 'Cactus Royal', ''),
(171, 'pt-BR', 'Royal Cactus', ''),
(171, 'ru', 'Royal Cactus', ''),
(171, 'vi', 'Royal Cactus', ''),
(172, 'en', 'Snow Wood', ''),
(172, 'es', 'Snow Wood', ''),
(172, 'fr', 'Bois de Neige', ''),
(172, 'pt-BR', 'Snow Wood', ''),
(172, 'ru', 'Snow Wood', ''),
(172, 'vi', 'Snow Wood', ''),
(173, 'en', 'Giant Wolf Leather', ''),
(173, 'es', 'Giant Wolf Leather', ''),
(173, 'fr', 'Cuir de Loup G�ant', ''),
(173, 'pt-BR', 'Giant Wolf Leather', ''),
(173, 'ru', 'Giant Wolf Leather', ''),
(173, 'vi', 'Giant Wolf Leather', ''),
(174, 'en', 'Sabre-toothed Camel Leather', ''),
(174, 'es', 'Sabre-toothed Camel Leather', ''),
(174, 'fr', 'Cuir de Chameau � Dents de Sabre', ''),
(174, 'pt-BR', 'Sabre-toothed Camel Leather', ''),
(174, 'ru', 'Sabre-toothed Camel Leather', ''),
(174, 'vi', 'Sabre-toothed Camel Leather', ''),
(175, 'en', 'Armored Leather', ''),
(175, 'es', 'Armored Leather', ''),
(175, 'fr', 'Cuir Cuirass�', ''),
(175, 'pt-BR', 'Armored Leather', ''),
(175, 'ru', 'Armored Leather', ''),
(175, 'vi', 'Armored Leather', ''),
(176, 'en', 'Yeti Leather', ''),
(176, 'es', 'Yeti Leather', ''),
(176, 'fr', 'Cuir de Y�ti', ''),
(176, 'pt-BR', 'Yeti Leather', ''),
(176, 'ru', 'Yeti Leather', ''),
(176, 'vi', 'Yeti Leather', ''),
(177, 'en', 'Sewing Thread', ''),
(177, 'es', 'Sewing Thread', ''),
(177, 'fr', 'Fil � Coudre', ''),
(177, 'pt-BR', 'Sewing Thread', ''),
(177, 'ru', 'Sewing Thread', ''),
(177, 'vi', 'Sewing Thread', '');

-- --------------------------------------------------------

--
-- Structure de la table `localizationmonsters`
--

CREATE TABLE `localizationmonsters` (
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameMonster` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationmonsters`
--

INSERT INTO `localizationmonsters` (`idMonstre`, `lang`, `nameMonster`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `localizationnodespstree`
--

CREATE TABLE `localizationnodespstree` (
  `idNode` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationnodespstree`
--

INSERT INTO `localizationnodespstree` (`idNode`, `lang`, `name`) VALUES
(1, 'en', 'Strength'),
(1, 'es', 'Strength'),
(1, 'fr', 'Strength'),
(1, 'pt-BR', 'Strength'),
(1, 'ru', 'Strength'),
(1, 'vi', 'Strength'),
(2, 'en', 'Constitution'),
(2, 'es', 'Constitution'),
(2, 'fr', 'Constitution'),
(2, 'pt-BR', 'Constitution'),
(2, 'ru', 'Constitution'),
(2, 'vi', 'Constitution'),
(3, 'en', 'Roguery'),
(3, 'es', 'Roguery'),
(3, 'fr', 'Roguery'),
(3, 'pt-BR', 'Roguery'),
(3, 'ru', 'Roguery'),
(3, 'vi', 'Roguery'),
(4, 'en', 'Knight Path'),
(4, 'es', 'Knight Path'),
(4, 'fr', 'Knight Path'),
(4, 'pt-BR', 'Knight Path'),
(4, 'ru', 'Knight Path'),
(4, 'vi', 'Knight Path'),
(5, 'en', 'Break Shield'),
(5, 'es', 'Break Shield'),
(5, 'fr', 'Break Shield'),
(5, 'pt-BR', 'Break Shield'),
(5, 'ru', 'Break Shield'),
(5, 'vi', 'Break Shield'),
(6, 'en', 'Break Sword'),
(6, 'es', 'Break Sword'),
(6, 'fr', 'Break Sword'),
(6, 'pt-BR', 'Break Sword'),
(6, 'ru', 'Break Sword'),
(6, 'vi', 'Break Sword'),
(7, 'en', 'Fighter Path'),
(7, 'es', 'Duelist Path'),
(7, 'fr', 'Duelist Path'),
(7, 'pt-BR', 'Duelist Path'),
(7, 'ru', 'Duelist Path'),
(7, 'vi', 'Duelist Path'),
(8, 'en', 'Flag 1'),
(8, 'es', 'Flag 1'),
(8, 'fr', 'Flag 1'),
(8, 'pt-BR', 'Flag 1'),
(8, 'ru', 'Flag 1'),
(8, 'vi', 'Flag 1'),
(9, 'en', 'Helmet Eye'),
(9, 'es', 'Helmet Eye'),
(9, 'fr', 'Helmet Eye'),
(9, 'pt-BR', 'Helmet Eye'),
(9, 'ru', 'Helmet Eye'),
(9, 'vi', 'Helmet Eye'),
(10, 'en', 'Multi Swords'),
(10, 'es', 'Multi Swords'),
(10, 'fr', 'Multi Swords'),
(10, 'pt-BR', 'Multi Swords'),
(10, 'ru', 'Multi Swords'),
(10, 'vi', 'Multi Swords'),
(11, 'en', 'Smash Attack'),
(11, 'es', 'Smash Attack'),
(11, 'fr', 'Smash Attack'),
(11, 'pt-BR', 'Smash Attack'),
(11, 'ru', 'Smash Attack'),
(11, 'vi', 'Smash Attack'),
(12, 'en', 'Evasion'),
(12, 'es', 'Evasion'),
(12, 'fr', 'Evasion'),
(12, 'pt-BR', 'Evasion'),
(12, 'ru', 'Evasion'),
(12, 'vi', 'Evasion'),
(13, 'en', 'Shield'),
(13, 'es', 'Shield'),
(13, 'fr', 'Shield'),
(13, 'pt-BR', 'Shield'),
(13, 'ru', 'Shield'),
(13, 'vi', 'Shield'),
(14, 'en', 'Sword Skull'),
(14, 'es', 'Sword Skull'),
(14, 'fr', 'Sword Skull'),
(14, 'pt-BR', 'Sword Skull'),
(14, 'ru', 'Sword Skull'),
(14, 'vi', 'Sword Skull'),
(15, 'en', 'Taunt'),
(15, 'es', 'Taunt'),
(15, 'fr', 'Taunt'),
(15, 'pt-BR', 'Taunt'),
(15, 'ru', 'Taunt'),
(15, 'vi', 'Taunt'),
(16, 'en', 'Focused Tornado'),
(16, 'es', 'Focused Tornado'),
(16, 'fr', 'Focused Tornado'),
(16, 'pt-BR', 'Focused Tornado'),
(16, 'ru', 'Focused Tornado'),
(16, 'vi', 'Focused Tornado'),
(17, 'en', 'Winner Cup'),
(17, 'es', 'Winner Cup'),
(17, 'fr', 'Winner Cup'),
(17, 'pt-BR', 'Winner Cup'),
(17, 'ru', 'Winner Cup'),
(17, 'vi', 'Winner Cup'),
(18, 'en', 'Rain Arrow'),
(18, 'es', 'Rain Arrow'),
(18, 'fr', 'Rain Arrow'),
(18, 'pt-BR', 'Rain Arrow'),
(18, 'ru', 'Rain Arrow'),
(18, 'vi', 'Rain Arrow'),
(19, 'en', 'Aimed Shot'),
(19, 'es', 'Aimed Shot'),
(19, 'fr', 'Aimed Shot'),
(19, 'pt-BR', 'Aimed Shot'),
(19, 'ru', 'Aimed Shot'),
(19, 'vi', 'Aimed Shot'),
(20, 'en', 'Charge Shot 2'),
(20, 'es', 'Charge Shot 2'),
(20, 'fr', 'Charge Shot 2'),
(20, 'pt-BR', 'Charge Shot 2'),
(20, 'ru', 'Charge Shot 2'),
(20, 'vi', 'Charge Shot 2'),
(21, 'en', 'Dash Archer'),
(21, 'es', 'Dash Archer'),
(21, 'fr', 'Dash Archer'),
(21, 'pt-BR', 'Dash Archer'),
(21, 'ru', 'Dash Archer'),
(21, 'vi', 'Dash Archer'),
(22, 'en', 'Flame Blue'),
(22, 'es', 'Flame Blue'),
(22, 'fr', 'Flame Blue'),
(22, 'pt-BR', 'Flame Blue'),
(22, 'ru', 'Flame Blue'),
(22, 'vi', 'Flame Blue'),
(23, 'en', 'Dexterity'),
(23, 'es', 'Dexterity'),
(23, 'fr', 'Dexterity'),
(23, 'pt-BR', 'Dexterity'),
(23, 'ru', 'Dexterity'),
(23, 'vi', 'Dexterity'),
(24, 'en', 'Flame Red'),
(24, 'es', 'Flame Red'),
(24, 'fr', 'Flame Red'),
(24, 'pt-BR', 'Flame Red'),
(24, 'ru', 'Flame Red'),
(24, 'vi', 'Flame Red'),
(25, 'en', 'Weakness Exploit'),
(25, 'es', 'Weakness Exploit'),
(25, 'fr', 'Weakness Exploit'),
(25, 'pt-BR', 'Weakness Exploit'),
(25, 'ru', 'Weakness Exploit'),
(25, 'vi', 'Weakness Exploit'),
(26, 'en', 'Flower Vortex'),
(26, 'es', 'Flower Vortex'),
(26, 'fr', 'Flower Vortex'),
(26, 'pt-BR', 'Flower Vortex'),
(26, 'ru', 'Flower Vortex'),
(26, 'vi', 'Flower Vortex'),
(27, 'en', 'Sword 1'),
(27, 'es', 'Sword 1'),
(27, 'fr', 'Sword 1'),
(27, 'pt-BR', 'Sword 1'),
(27, 'ru', 'Sword 1'),
(27, 'vi', 'Sword 1'),
(28, 'en', 'Flaming Blow'),
(28, 'es', 'Flaming Blow'),
(28, 'fr', 'Flaming Blow'),
(28, 'pt-BR', 'Flaming Blow'),
(28, 'ru', 'Flaming Blow'),
(28, 'vi', 'Flaming Blow'),
(29, 'en', 'Precision'),
(29, 'es', 'Precision'),
(29, 'fr', 'Precision'),
(29, 'pt-BR', 'Precision'),
(29, 'ru', 'Precision'),
(29, 'vi', 'Precision'),
(30, 'en', 'Aimed Shot'),
(30, 'es', 'Aimed Shot'),
(30, 'fr', 'Aimed Shot'),
(30, 'pt-BR', 'Aimed Shot'),
(30, 'ru', 'Aimed Shot'),
(30, 'vi', 'Aimed Shot'),
(31, 'en', 'Dragon Summon'),
(31, 'es', 'Dragon Summon'),
(31, 'fr', 'Dragon Summon'),
(31, 'pt-BR', 'Dragon Summon'),
(31, 'ru', 'Dragon Summon'),
(31, 'vi', 'Dragon Summon'),
(32, 'en', 'Arcane Shards'),
(32, 'es', 'Arcane Shards'),
(32, 'fr', 'Arcane Shards'),
(32, 'pt-BR', 'Arcane Shards'),
(32, 'ru', 'Arcane Shards'),
(32, 'vi', 'Arcane Shards'),
(33, 'en', 'Lightning Bolt 1'),
(33, 'es', 'Lightning Bolt 1'),
(33, 'fr', 'Lightning Bolt 1'),
(33, 'pt-BR', 'Lightning Bolt 1'),
(33, 'ru', 'Lightning Bolt 1'),
(33, 'vi', 'Lightning Bolt 1'),
(34, 'en', 'Path of Magic'),
(34, 'es', 'Path of Magic'),
(34, 'fr', 'Path of Magic'),
(34, 'pt-BR', 'Path of Magic'),
(34, 'ru', 'Path of Magic'),
(34, 'vi', 'Path of Magic'),
(35, 'en', 'Magic Knowledge'),
(35, 'es', 'Magic Knowledge'),
(35, 'fr', 'Magic Knowledge'),
(35, 'pt-BR', 'Magic Knowledge'),
(35, 'ru', 'Magic Knowledge'),
(35, 'vi', 'Magic Knowledge'),
(36, 'en', 'Assassinate'),
(36, 'es', 'Assassinate'),
(36, 'fr', 'Assassinate'),
(36, 'pt-BR', 'Assassinate'),
(36, 'ru', 'Assassinate'),
(36, 'vi', 'Assassinate'),
(37, 'en', 'Battle Cry'),
(37, 'es', 'Battle Cry'),
(37, 'fr', 'Battle Cry'),
(37, 'pt-BR', 'Battle Cry'),
(37, 'ru', 'Battle Cry'),
(37, 'vi', 'Battle Cry'),
(38, 'en', 'Break Shield 2'),
(38, 'es', 'Break Shield 2'),
(38, 'fr', 'Break Shield 2'),
(38, 'pt-BR', 'Break Shield 2'),
(38, 'ru', 'Break Shield 2'),
(38, 'vi', 'Break Shield 2'),
(39, 'en', 'Bomberman'),
(39, 'es', 'Bomberman'),
(39, 'fr', 'Bomberman'),
(39, 'pt-BR', 'Bomberman'),
(39, 'ru', 'Bomberman'),
(39, 'vi', 'Bomberman'),
(40, 'en', 'Dark Orb'),
(40, 'es', 'Dark Orb'),
(40, 'fr', 'Dark Orb'),
(40, 'pt-BR', 'Dark Orb'),
(40, 'ru', 'Dark Orb'),
(40, 'vi', 'Dark Orb'),
(41, 'en', 'Dead Hand'),
(41, 'es', 'Dead Hand'),
(41, 'fr', 'Dead Hand'),
(41, 'pt-BR', 'Dead Hand'),
(41, 'ru', 'Dead Hand'),
(41, 'vi', 'Dead Hand'),
(42, 'en', 'Eagle Claw'),
(42, 'es', 'Eagle Claw'),
(42, 'fr', 'Eagle Claw'),
(42, 'pt-BR', 'Eagle Claw'),
(42, 'ru', 'Eagle Claw'),
(42, 'vi', 'Eagle Claw'),
(43, 'en', 'Eat'),
(43, 'es', 'Eat'),
(43, 'fr', 'Eat'),
(43, 'pt-BR', 'Eat'),
(43, 'ru', 'Eat'),
(43, 'vi', 'Eat'),
(44, 'en', 'Fire Magic Strike'),
(44, 'es', 'Fire Magic Strike'),
(44, 'fr', 'Fire Magic Strike'),
(44, 'pt-BR', 'Fire Magic Strike'),
(44, 'ru', 'Fire Magic Strike'),
(44, 'vi', 'Fire Magic Strike'),
(45, 'en', 'Fireball'),
(45, 'es', 'Fireball'),
(45, 'fr', 'Fireball'),
(45, 'pt-BR', 'Fireball'),
(45, 'ru', 'Fireball'),
(45, 'vi', 'Fireball'),
(46, 'en', 'Heal'),
(46, 'es', 'Heal'),
(46, 'fr', 'Heal'),
(46, 'pt-BR', 'Heal'),
(46, 'ru', 'Heal'),
(46, 'vi', 'Heal'),
(47, 'en', 'Weakness Exploit'),
(47, 'es', 'Weakness Exploit'),
(47, 'fr', 'Weakness Exploit'),
(47, 'pt-BR', 'Weakness Exploit'),
(47, 'ru', 'Weakness Exploit'),
(47, 'vi', 'Weakness Exploit'),
(48, 'en', 'Ice Block'),
(48, 'es', 'Ice Block'),
(48, 'fr', 'Ice Block'),
(48, 'pt-BR', 'Ice Block'),
(48, 'ru', 'Ice Block'),
(48, 'vi', 'Ice Block'),
(49, 'en', 'Ice Shards'),
(49, 'es', 'Ice Shards'),
(49, 'fr', 'Ice Shards'),
(49, 'pt-BR', 'Ice Shards'),
(49, 'ru', 'Ice Shards'),
(49, 'vi', 'Ice Shards'),
(50, 'en', 'Light Ray'),
(50, 'es', 'Light Ray'),
(50, 'fr', 'Light Ray'),
(50, 'pt-BR', 'Light Ray'),
(50, 'ru', 'Light Ray'),
(50, 'vi', 'Light Ray'),
(51, 'en', 'Lightning Blue'),
(51, 'es', 'Lightning Blue'),
(51, 'fr', 'Lightning Blue'),
(51, 'pt-BR', 'Lightning Blue'),
(51, 'ru', 'Lightning Blue'),
(51, 'vi', 'Lightning Blue'),
(52, 'en', 'Lightning Purple'),
(52, 'es', 'Lightning Purple'),
(52, 'fr', 'Lightning Purple'),
(52, 'pt-BR', 'Lightning Purple'),
(52, 'ru', 'Lightning Purple'),
(52, 'vi', 'Lightning Purple'),
(53, 'en', 'Wisdom'),
(53, 'es', 'Wisdom'),
(53, 'fr', 'Wisdom'),
(53, 'pt-BR', 'Wisdom'),
(53, 'ru', 'Wisdom'),
(53, 'vi', 'Wisdom'),
(54, 'en', 'Shield 2'),
(54, 'es', 'Shield 2'),
(54, 'fr', 'Shield 2'),
(54, 'pt-BR', 'Shield 2'),
(54, 'ru', 'Shield 2'),
(54, 'vi', 'Shield 2'),
(55, 'en', 'Spider'),
(55, 'es', 'Spider'),
(55, 'fr', 'Spider'),
(55, 'pt-BR', 'Spider'),
(55, 'ru', 'Spider'),
(55, 'vi', 'Spider'),
(56, 'en', 'Starfall Purple'),
(56, 'es', 'Starfall Purple'),
(56, 'fr', 'Starfall Purple'),
(56, 'pt-BR', 'Starfall Purple'),
(56, 'ru', 'Starfall Purple'),
(56, 'vi', 'Starfall Purple'),
(57, 'en', 'Archery'),
(57, 'es', 'Archery'),
(57, 'fr', 'Archery'),
(57, 'pt-BR', 'Archery'),
(57, 'ru', 'Archery'),
(57, 'vi', 'Archery'),
(58, 'en', 'Healing Knowledge'),
(58, 'es', 'Healing Knowledge'),
(58, 'fr', 'Healing Knowledge'),
(58, 'pt-BR', 'Healing Knowledge'),
(58, 'ru', 'Healing Knowledge'),
(58, 'vi', 'Healing Knowledge'),
(59, 'en', 'Tornado'),
(59, 'es', 'Tornado'),
(59, 'fr', 'Tornado'),
(59, 'pt-BR', 'Tornado'),
(59, 'ru', 'Tornado'),
(59, 'vi', 'Tornado'),
(60, 'en', 'Venom'),
(60, 'es', 'Venom'),
(60, 'fr', 'Venom'),
(60, 'pt-BR', 'Venom'),
(60, 'ru', 'Venom'),
(60, 'vi', 'Venom'),
(61, 'en', 'Wolf'),
(61, 'es', 'Wolf'),
(61, 'fr', 'Wolf'),
(61, 'pt-BR', 'Wolf'),
(61, 'ru', 'Wolf'),
(61, 'vi', 'Wolf'),
(62, 'en', 'Resurrect'),
(62, 'es', 'Resurrect'),
(62, 'fr', 'Resurrect'),
(62, 'pt-BR', 'Resurrect'),
(62, 'ru', 'Resurrect'),
(62, 'vi', 'Resurrect'),
(63, 'en', 'Path of the Elements'),
(63, 'es', 'Path of the Elements'),
(63, 'fr', 'Path of the Elements'),
(63, 'pt-BR', 'Path of the Elements'),
(63, 'ru', 'Path of the Elements'),
(63, 'vi', 'Path of the Elements'),
(64, 'en', 'Rock Shards'),
(64, 'es', 'Rock Shards'),
(64, 'fr', 'Rock Shards'),
(64, 'pt-BR', 'Rock Shards'),
(64, 'ru', 'Rock Shards'),
(64, 'vi', 'Rock Shards'),
(65, 'en', 'Smoke Bomb'),
(65, 'es', 'Smoke Bomb'),
(65, 'fr', 'Smoke Bomb'),
(65, 'pt-BR', 'Smoke Bomb'),
(65, 'ru', 'Smoke Bomb'),
(65, 'vi', 'Smoke Bomb'),
(66, 'en', 'Toxic Bomb'),
(66, 'es', 'Toxic Bomb'),
(66, 'fr', 'Toxic Bomb'),
(66, 'pt-BR', 'Toxic Bomb'),
(66, 'ru', 'Toxic Bomb'),
(66, 'vi', 'Toxic Bomb'),
(67, 'en', 'Flaming Arrow'),
(67, 'es', 'Flaming Arrow'),
(67, 'fr', 'Flaming Arrow'),
(67, 'pt-BR', 'Flaming Arrow'),
(67, 'ru', 'Flaming Arrow'),
(67, 'vi', 'Flaming Arrow'),
(68, 'en', 'Stone Arrow'),
(68, 'es', 'Stone Arrow'),
(68, 'fr', 'Stone Arrow'),
(68, 'pt-BR', 'Stone Arrow'),
(68, 'ru', 'Stone Arrow'),
(68, 'vi', 'Stone Arrow'),
(69, 'en', 'Windy Arrow'),
(69, 'es', 'Windy Arrow'),
(69, 'fr', 'Windy Arrow'),
(69, 'pt-BR', 'Windy Arrow'),
(69, 'ru', 'Windy Arrow'),
(69, 'vi', 'Windy Arrow'),
(70, 'en', 'Ice Arrow'),
(70, 'es', 'Ice Arrow'),
(70, 'fr', 'Ice Arrow'),
(70, 'pt-BR', 'Ice Arrow'),
(70, 'ru', 'Ice Arrow'),
(70, 'vi', 'Ice Arrow'),
(71, 'en', 'Cold Blow'),
(71, 'es', 'Cold Blow'),
(71, 'fr', 'Cold Blow'),
(71, 'pt-BR', 'Cold Blow'),
(71, 'ru', 'Cold Blow'),
(71, 'vi', 'Cold Blow'),
(72, 'en', 'Windy Blow'),
(72, 'es', 'Windy Blow'),
(72, 'fr', 'Windy Blow'),
(72, 'pt-BR', 'Windy Blow'),
(72, 'ru', 'Windy Blow'),
(72, 'vi', 'Windy Blow'),
(73, 'en', 'Earthy Blow'),
(73, 'es', 'Earthy Blow'),
(73, 'fr', 'Earthy Blow'),
(73, 'pt-BR', 'Earthy Blow'),
(73, 'ru', 'Earthy Blow'),
(73, 'vi', 'Earthy Blow'),
(74, 'en', 'Regeneration'),
(74, 'es', 'Regeneration'),
(74, 'fr', 'Regeneration'),
(74, 'pt-BR', 'Regeneration'),
(74, 'ru', 'Regeneration'),
(74, 'vi', 'Regeneration'),
(75, 'en', 'Warrior Path'),
(75, 'es', 'Warrior Path'),
(75, 'fr', 'Warrior Path'),
(75, 'pt-BR', 'Warrior Path'),
(75, 'ru', 'Warrior Path'),
(75, 'vi', 'Warrior Path'),
(76, 'en', 'Armor Up'),
(76, 'es', 'Armor Up'),
(76, 'fr', 'Armor Up'),
(76, 'pt-BR', 'Armor Up'),
(76, 'ru', 'Armor Up'),
(76, 'vi', 'Armor Up'),
(77, 'en', 'Intelligence'),
(77, 'es', 'Intelligence'),
(77, 'fr', 'Intelligence'),
(77, 'pt-BR', 'Intelligence'),
(77, 'ru', 'Intelligence'),
(77, 'vi', 'Intelligence'),
(78, 'en', 'Wisdom'),
(78, 'es', 'Wisdom'),
(78, 'fr', 'Wisdom'),
(78, 'pt-BR', 'Wisdom'),
(78, 'ru', 'Wisdom'),
(78, 'vi', 'Wisdom');

-- --------------------------------------------------------

--
-- Structure de la table `localizationregions`
--

CREATE TABLE `localizationregions` (
  `idRegion` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameRegion` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `imageRegion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationregions`
--

INSERT INTO `localizationregions` (`idRegion`, `lang`, `nameRegion`, `imageRegion`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `localizationskills`
--

CREATE TABLE `localizationskills` (
  `idSkill` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameSkill` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descSkill` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `messageSkill` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationskills`
--

INSERT INTO `localizationskills` (`idSkill`, `lang`, `nameSkill`, `descSkill`, `messageSkill`) VALUES
(1, 'en', 'Melee Attack', '', ' uses %s!'),
(2, 'en', 'Distant Attack', '', ' uses %s!'),
(3, 'en', 'Magic Bolt', '', ' uses %s!'),
(4, 'en', 'Flaming Blow', '', ' uses %s!'),
(5, 'en', 'Cold Blow', '', ' uses %s!'),
(6, 'en', 'Earthy Blow', '', ' uses %s!'),
(7, 'en', 'Windy Blow', '', ' uses %s!'),
(8, 'en', 'Flaming Arrow', '', ' throws %s!'),
(9, 'en', 'Ice Arrow', '', ' throws %s!'),
(10, 'en', 'Stone Arrow', '', ' throws %s!'),
(11, 'en', 'Windy Arrow', '', ' throws %s!'),
(12, 'en', 'Fireball', '', ' uses %s!'),
(13, 'en', 'Ice Shards', '', ' uses %s!'),
(14, 'en', 'Rock Shards', '', ' uses %s!'),
(15, 'en', 'Focused Tornado', '', ' uses %s!'),
(16, 'en', 'Venom', '', ' throws %s!'),
(17, 'en', 'Toxic Bomb', '', ' throws %s!'),
(18, 'en', 'Taunt', '', ' uses %s!'),
(19, 'en', 'Self Regen Boost', '', ' uses %s!'),
(20, 'en', 'Group Regen Boost', '', ' uses %s!'),
(21, 'en', 'Self Heal', '', ' uses %s!'),
(22, 'en', 'Heal', '', ' uses %s!'),
(23, 'en', 'Group Heal', '', ' uses %s!'),
(24, 'en', 'Resurrect', '', ' uses %s!'),
(25, 'en', 'Smoke Bomb', '', ' throws %s!'),
(26, 'en', 'Deceit', '', ' uses %s!'),
(27, 'en', 'Defend', '', ' uses %s!'),
(28, 'en', 'Enrage', '', ' enrage!'),
(29, 'en', 'Animal Bite', '', ' bites!'),
(30, 'en', 'Poisonous Bite', '', ' bites!'),
(31, 'en', 'Charge', '', ' charges!'),
(32, 'en', 'Smash Attack', '', ' uses %s!'),
(33, 'en', 'Aimed Shot', '', ' throws %s!'),
(34, 'en', 'Arcane Shards', '', ' uses %s!');

-- --------------------------------------------------------

--
-- Structure de la table `localizationstates`
--

CREATE TABLE `localizationstates` (
  `idState` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nameState` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descState` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `localizationstates`
--

INSERT INTO `localizationstates` (`idState`, `lang`, `nameState`, `descState`) VALUES
(1, 'en', 'Stun', ''),
(2, 'en', 'Defense', ''),
(3, 'en', 'Regeneration', ''),
(4, 'en', 'Poison', ''),
(5, 'en', 'Blind', ''),
(6, 'en', 'Provoke', ''),
(7, 'en', 'Hide', ''),
(8, 'en', 'Heal Resistant', ''),
(9, 'en', 'Enraged', ''),
(10, 'en', 'Bleed', ''),
(11, 'en', 'Burn', ''),
(12, 'en', 'Freeze', '');

-- --------------------------------------------------------

--
-- Structure de la table `marketplaces`
--

CREATE TABLE `marketplaces` (
  `idMarketplace` int(10) UNSIGNED NOT NULL,
  `tax` float NOT NULL DEFAULT '0.05',
  `idArea` int(10) UNSIGNED NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `marketplaces`
--

INSERT INTO `marketplaces` (`idMarketplace`, `tax`, `idArea`, `active`) VALUES
(1, 0.05, 5, 1),
(2, 0.05, 6, 1),
(6, 0.05, 8, 1),
(7, 0.05, 14, 1),
(8, 0.05, 15, 1),
(9, 0.05, 16, 1),
(10, 0.05, 22, 1),
(11, 0.05, 29, 1),
(12, 0.05, 34, 1);

-- --------------------------------------------------------

--
-- Structure de la table `marketplacesorders`
--

CREATE TABLE `marketplacesorders` (
  `idMarketplace` int(10) UNSIGNED NOT NULL,
  `idItem` bigint(20) UNSIGNED NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `monstersbuilds`
--

CREATE TABLE `monstersbuilds` (
  `idMonstersBuildsProfil` int(10) UNSIGNED NOT NULL,
  `idSkill` int(10) UNSIGNED NOT NULL,
  `priority` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `monstersbuilds`
--

INSERT INTO `monstersbuilds` (`idMonstersBuildsProfil`, `idSkill`, `priority`) VALUES
(1, 1, 0),
(1, 29, 0),
(1, 31, 0),
(2, 1, 0),
(2, 4, 0),
(2, 5, 0),
(2, 6, 0),
(2, 7, 0),
(2, 31, 0),
(3, 3, 0),
(3, 12, 0),
(3, 13, 0),
(3, 14, 0),
(3, 15, 0),
(4, 2, 0),
(4, 8, 0),
(4, 9, 0),
(4, 10, 0),
(4, 11, 0),
(5, 1, 0),
(5, 30, 0),
(5, 31, 0),
(6, 1, 0),
(6, 4, 0),
(6, 31, 0),
(7, 1, 0),
(7, 5, 0),
(7, 31, 0),
(8, 1, 0),
(8, 6, 0),
(8, 31, 0),
(9, 1, 0),
(9, 7, 0),
(9, 31, 0),
(10, 1, 0),
(10, 18, 0),
(10, 27, 0),
(10, 31, 0),
(11, 2, 0),
(11, 29, 0),
(11, 31, 0),
(12, 3, 0),
(12, 20, 0),
(12, 22, 0),
(12, 23, 0),
(12, 24, 0),
(13, 2, 0),
(13, 16, 0),
(13, 30, 0),
(14, 1, 0),
(14, 12, 0),
(14, 27, 0),
(15, 1, 0),
(15, 13, 0),
(15, 27, 0),
(16, 1, 0),
(16, 14, 0),
(16, 27, 0),
(17, 1, 0),
(17, 15, 0),
(17, 27, 0);

-- --------------------------------------------------------

--
-- Structure de la table `monstersbuildsprofil`
--

CREATE TABLE `monstersbuildsprofil` (
  `idMonstersBuildsProfil` int(10) UNSIGNED NOT NULL,
  `name` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `monstersbuildsprofil`
--

INSERT INTO `monstersbuildsprofil` (`idMonstersBuildsProfil`, `name`) VALUES
(1, 'animal_generic_melee'),
(2, 'warrior'),
(3, 'mage'),
(4, 'archer'),
(5, 'animal_poisonous_melee'),
(6, 'warrior_elemental_fire'),
(7, 'warrior_elemental_water'),
(8, 'warrior_elemental_earth'),
(9, 'warrior_elemental_wind'),
(10, 'warrior_tank'),
(11, 'animal_generic_distance'),
(12, 'healer'),
(13, 'animal_poisonous_distant'),
(14, 'mage_elemental_fire'),
(15, 'mage_elemental_water'),
(16, 'mage_elemental_earth'),
(17, 'mage_elemental_wind');

-- --------------------------------------------------------

--
-- Structure de la table `monstres`
--

CREATE TABLE `monstres` (
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `avglevel` int(10) UNSIGNED NOT NULL,
  `idType` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `monstres`
--

INSERT INTO `monstres` (`idMonstre`, `avglevel`, `idType`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `monstresgroupes`
--

CREATE TABLE `monstresgroupes` (
  `idMonstresGroupe` int(10) UNSIGNED NOT NULL,
  `shrothand` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `monstresgroupes`
--

INSERT INTO `monstresgroupes` (`idMonstresGroupe`, `shrothand`) VALUES
(1, ''),
(2, ''),
(3, ''),
(4, ''),
(5, ''),
(6, ''),
(7, ''),
(8, ''),
(9, ''),
(10, ''),
(11, ''),
(12, ''),
(13, ''),
(14, ''),
(15, ''),
(16, ''),
(17, ''),
(18, ''),
(19, ''),
(20, ''),
(21, ''),
(22, ''),
(23, ''),
(24, ''),
(25, ''),
(26, ''),
(27, ''),
(28, ''),
(29, ''),
(30, ''),
(31, ''),
(32, ''),
(33, ''),
(34, ''),
(35, ''),
(36, ''),
(37, ''),
(38, ''),
(39, ''),
(40, ''),
(41, ''),
(42, ''),
(43, ''),
(44, ''),
(45, ''),
(46, ''),
(47, ''),
(48, ''),
(49, ''),
(50, ''),
(51, ''),
(52, ''),
(53, ''),
(54, ''),
(55, ''),
(56, ''),
(57, ''),
(58, ''),
(59, ''),
(60, ''),
(61, ''),
(62, ''),
(63, ''),
(64, ''),
(65, ''),
(66, ''),
(67, ''),
(68, ''),
(69, ''),
(70, ''),
(71, ''),
(72, ''),
(73, ''),
(74, ''),
(75, ''),
(76, ''),
(77, ''),
(78, 'two_monsters_of_region_1'),
(79, 'dungeon_tywardreath_floor_one'),
(80, 'dungeon_tjesomunein_floor_one'),
(81, 'dungeon_demonic_citadel_floor_one'),
(82, 'dungeon_ice_mirror_cave_floor_one');

-- --------------------------------------------------------

--
-- Structure de la table `monstresgroupesassoc`
--

CREATE TABLE `monstresgroupesassoc` (
  `idMonstresGroupe` int(10) UNSIGNED NOT NULL,
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `monstresgroupesassoc`
--

INSERT INTO `monstresgroupesassoc` (`idMonstresGroupe`, `idMonstre`, `number`) VALUES
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
(77, 81, 1),
(78, 14, 2),
(79, 36, 4),
(80, 50, 5),
(81, 62, 4),
(81, 69, 1),
(82, 74, 1),
(82, 80, 4);

-- --------------------------------------------------------

--
-- Structure de la table `monstrestypes`
--

CREATE TABLE `monstrestypes` (
  `idType` int(10) UNSIGNED NOT NULL,
  `nom` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `monstrestypes`
--

INSERT INTO `monstrestypes` (`idType`, `nom`) VALUES
(1, 'normal'),
(2, 'elite'),
(3, 'boss'),
(4, 'boss'),
(5, 'boss');

-- --------------------------------------------------------

--
-- Structure de la table `pstreenodes`
--

CREATE TABLE `pstreenodes` (
  `idNode` int(10) UNSIGNED NOT NULL,
  `idNodeVisual` int(10) UNSIGNED DEFAULT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `cost` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `isInitial` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `pstreenodes`
--

INSERT INTO `pstreenodes` (`idNode`, `idNodeVisual`, `x`, `y`, `cost`, `isInitial`) VALUES
(1, 1, 0, 1.5, 1, 1),
(2, 75, 0, 3.5, 1, 0),
(3, 7, -1.5, 5, 4, 0),
(4, 11, -3, 6.5, 4, 0),
(5, 63, -4.5, 8, 4, 0),
(6, 73, -4.5, 6.5, 5, 0),
(7, 72, -5.5, 7, 5, 0),
(8, 71, -5.5, 9, 5, 0),
(9, 28, -4.5, 9.5, 5, 0),
(10, 1, 0, 6.5, 2, 0),
(11, 1, 0, 8.5, 4, 0),
(12, 1, 0, 10.5, 10, 0),
(13, 4, 1.5, 5, 4, 0),
(14, 2, 3, 6.5, 2, 0),
(15, 2, 3, 8.5, 4, 0),
(16, 2, 3, 10.5, 10, 0),
(17, 15, 3, 3.5, 6, 0),
(18, 13, 3.5, 5, 5, 0),
(19, 76, 5, 6.5, 5, 0),
(20, 76, 7, 6.5, 5, 0),
(21, 63, 5, 3.5, 5, 0),
(22, 63, 7, 3.5, 5, 0),
(23, 34, 1.5, 0, 1, 0),
(24, 58, 3, -1.5, 4, 0),
(25, 62, 1, -1.5, 4, 0),
(26, 53, 4.5, -3, 2, 0),
(27, 53, 4.5, -5, 4, 0),
(28, 53, 4.5, -7, 10, 0),
(29, 74, 3, -3.5, 8, 0),
(30, 74, 3, -5.5, 8, 0),
(31, 46, 1.5, -3, 10, 0),
(32, 46, 1.5, -5, 3, 0),
(33, 46, 1.5, -7, 7, 0),
(34, 35, 3, 1.5, 4, 0),
(35, 32, 5, 1.5, 4, 0),
(36, 77, 5, -0.5, 2, 0),
(37, 77, 6.5, -2, 4, 0),
(38, 77, 8.5, -2, 10, 0),
(39, 63, 7, 1.5, 4, 0),
(40, 16, 7, 0, 5, 0),
(41, 45, 8, 0.5, 5, 0),
(42, 64, 8.5, 1.5, 5, 0),
(43, 49, 8, 2.5, 5, 0),
(44, 21, -1.5, 0, 1, 0),
(45, 3, -3, -1.5, 6, 0),
(46, 12, -1.5, -3, 5, 0),
(47, 12, -1.5, -5, 5, 0),
(48, 12, -1.5, -7, 5, 0),
(49, 39, -4.5, -3, 4, 0),
(50, 66, -4.5, -5, 4, 0),
(51, 65, -6.5, -3, 4, 0),
(52, 60, -5, -1.5, 4, 0),
(53, 57, -3, 1.5, 6, 0),
(54, 25, -3, 3.5, 5, 0),
(55, 25, -4.5, 5, 5, 0),
(56, 63, -4.5, 3, 4, 0),
(57, 69, -5.5, 4, 5, 0),
(58, 67, -6, 3, 5, 0),
(59, 70, -5.5, 2, 5, 0),
(60, 68, -4.5, 1.5, 5, 0),
(61, 23, -4.5, 0, 2, 0),
(62, 23, -6.5, 0, 4, 0),
(63, 23, -8.5, 0, 10, 0);

-- --------------------------------------------------------

--
-- Structure de la table `pstreenodeslinks`
--

CREATE TABLE `pstreenodeslinks` (
  `idNodeParent` int(10) UNSIGNED NOT NULL,
  `PSTreeNodesChild` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `pstreenodeslinks`
--

INSERT INTO `pstreenodeslinks` (`idNodeParent`, `PSTreeNodesChild`) VALUES
(1, 2),
(2, 3),
(3, 4),
(5, 4),
(5, 6),
(5, 7),
(5, 8),
(5, 9),
(3, 10),
(13, 10),
(10, 11),
(11, 12),
(2, 13),
(13, 14),
(14, 15),
(15, 16),
(13, 17),
(13, 18),
(18, 19),
(19, 20),
(18, 21),
(21, 22),
(1, 23),
(24, 23),
(24, 25),
(24, 26),
(26, 27),
(27, 28),
(24, 29),
(29, 30),
(24, 31),
(31, 32),
(32, 33),
(23, 34),
(35, 34),
(35, 36),
(36, 37),
(37, 38),
(35, 39),
(39, 40),
(39, 41),
(39, 42),
(39, 43),
(1, 44),
(44, 45),
(46, 45),
(47, 46),
(48, 47),
(45, 49),
(49, 50),
(49, 51),
(45, 52),
(44, 53),
(56, 53),
(61, 53),
(3, 54),
(53, 54),
(55, 54),
(56, 57),
(56, 58),
(56, 59),
(56, 60),
(61, 62),
(63, 62);

-- --------------------------------------------------------

--
-- Structure de la table `pstreenodessecondarystatsdata`
--

CREATE TABLE `pstreenodessecondarystatsdata` (
  `idNode` int(10) UNSIGNED NOT NULL,
  `idSecondaryStat` int(10) UNSIGNED NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `pstreenodessecondarystatsdata`
--

INSERT INTO `pstreenodessecondarystatsdata` (`idNode`, `idSecondaryStat`, `value`) VALUES
(1, 1, 0),
(1, 2, 0),
(1, 3, 0),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(1, 7, 0),
(1, 8, 0),
(1, 9, 0),
(1, 10, 0),
(1, 11, 0),
(1, 12, 0),
(2, 1, 0),
(2, 2, 0),
(2, 3, 0),
(2, 4, 0),
(2, 5, 0),
(2, 6, 1),
(2, 7, 0),
(2, 8, 0),
(2, 9, 0),
(2, 10, 0),
(2, 11, 0),
(2, 12, 0),
(3, 1, 0),
(3, 2, 0),
(3, 3, 1),
(3, 4, 0),
(3, 5, 0),
(3, 6, 0),
(3, 7, 0),
(3, 8, 5),
(3, 9, 0),
(3, 10, 0),
(3, 11, 0),
(3, 12, 0),
(4, 1, 0),
(4, 2, 0),
(4, 3, 0),
(4, 4, 0),
(4, 5, 0),
(4, 6, 0),
(4, 7, 0),
(4, 8, 0),
(4, 9, 0),
(4, 10, 0),
(4, 11, 0),
(4, 12, 0),
(5, 1, 0),
(5, 2, 0),
(5, 3, 0),
(5, 4, 0),
(5, 5, 0),
(5, 6, 0),
(5, 7, 0),
(5, 8, 0),
(5, 9, 0),
(5, 10, 0),
(5, 11, 0),
(5, 12, 0),
(6, 1, 0),
(6, 2, 0),
(6, 3, 0),
(6, 4, 0),
(6, 5, 0),
(6, 6, 0),
(6, 7, 0),
(6, 8, 0),
(6, 9, 0),
(6, 10, 0),
(6, 11, 0),
(6, 12, 0),
(7, 1, 0),
(7, 2, 0),
(7, 3, 0),
(7, 4, 0),
(7, 5, 0),
(7, 6, 0),
(7, 7, 0),
(7, 8, 0),
(7, 9, 0),
(7, 10, 0),
(7, 11, 0),
(7, 12, 0),
(8, 1, 0),
(8, 2, 0),
(8, 3, 0),
(8, 4, 0),
(8, 5, 0),
(8, 6, 0),
(8, 7, 0),
(8, 8, 0),
(8, 9, 0),
(8, 10, 0),
(8, 11, 0),
(8, 12, 0),
(9, 1, 0),
(9, 2, 0),
(9, 3, 0),
(9, 4, 0),
(9, 5, 0),
(9, 6, 0),
(9, 7, 0),
(9, 8, 0),
(9, 9, 0),
(9, 10, 0),
(9, 11, 0),
(9, 12, 0),
(10, 1, 0),
(10, 2, 0),
(10, 3, 0),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(10, 7, 0),
(10, 8, 0),
(10, 9, 0),
(10, 10, 0),
(10, 11, 0),
(10, 12, 0),
(11, 1, 0),
(11, 2, 0),
(11, 3, 0),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(11, 7, 0),
(11, 8, 0),
(11, 9, 0),
(11, 10, 0),
(11, 11, 0),
(11, 12, 0),
(12, 1, 0),
(12, 2, 0),
(12, 3, 0),
(12, 4, 0),
(12, 5, 0),
(12, 6, 0),
(12, 7, 0),
(12, 8, 0),
(12, 9, 0),
(12, 10, 0),
(12, 11, 0),
(12, 12, 0),
(13, 1, 0),
(13, 2, 0),
(13, 3, 0),
(13, 4, 0),
(13, 5, 0),
(13, 6, 0),
(13, 7, 0),
(13, 8, 5),
(13, 9, 0),
(13, 10, 0),
(13, 11, 0),
(13, 12, 0),
(14, 1, 0),
(14, 2, 0),
(14, 3, 0),
(14, 4, 0),
(14, 5, 0),
(14, 6, 0),
(14, 7, 0),
(14, 8, 0),
(14, 9, 0),
(14, 10, 0),
(14, 11, 0),
(14, 12, 0),
(15, 1, 0),
(15, 2, 0),
(15, 3, 0),
(15, 4, 0),
(15, 5, 0),
(15, 6, 0),
(15, 7, 0),
(15, 8, 0),
(15, 9, 0),
(15, 10, 0),
(15, 11, 0),
(15, 12, 0),
(16, 1, 0),
(16, 2, 0),
(16, 3, 0),
(16, 4, 0),
(16, 5, 0),
(16, 6, 0),
(16, 7, 0),
(16, 8, 0),
(16, 9, 0),
(16, 10, 0),
(16, 11, 0),
(16, 12, 0),
(17, 1, 0),
(17, 2, 0),
(17, 3, 0),
(17, 4, 0),
(17, 5, 0),
(17, 6, 0),
(17, 7, 0),
(17, 8, 0),
(17, 9, 0),
(17, 10, 0),
(17, 11, 5),
(17, 12, 0),
(18, 1, 0),
(18, 2, 0),
(18, 3, 0),
(18, 4, 0),
(18, 5, 0),
(18, 6, 0),
(18, 7, 0),
(18, 8, 0),
(18, 9, 0),
(18, 10, 0),
(18, 11, 10),
(18, 12, 0),
(19, 1, 0),
(19, 2, 0),
(19, 3, 0),
(19, 4, 0),
(19, 5, 0),
(19, 6, 0),
(19, 7, 0),
(19, 8, 0),
(19, 9, 0),
(19, 10, 0),
(19, 11, 0),
(19, 12, 0),
(20, 1, 0),
(20, 2, 0),
(20, 3, 0),
(20, 4, 0),
(20, 5, 0),
(20, 6, 0),
(20, 7, 0),
(20, 8, 0),
(20, 9, 0),
(20, 10, 0),
(20, 11, 0),
(20, 12, 0),
(21, 1, 0),
(21, 2, 0),
(21, 3, 0),
(21, 4, 0),
(21, 5, 0),
(21, 6, 0),
(21, 7, 0),
(21, 8, 0),
(21, 9, 0),
(21, 10, 0),
(21, 11, 0),
(21, 12, 0),
(22, 1, 0),
(22, 2, 0),
(22, 3, 0),
(22, 4, 0),
(22, 5, 0),
(22, 6, 0),
(22, 7, 0),
(22, 8, 0),
(22, 9, 0),
(22, 10, 0),
(22, 11, 0),
(22, 12, 0),
(23, 1, 0),
(23, 2, 0),
(23, 3, 0),
(23, 4, 0),
(23, 5, 0),
(23, 6, 0),
(23, 7, 0),
(23, 8, 0),
(23, 9, 0),
(23, 10, 0),
(23, 11, 0),
(23, 12, 0),
(24, 1, 0),
(24, 2, 0),
(24, 3, 0),
(24, 4, 0),
(24, 5, 0),
(24, 6, 0),
(24, 7, 5),
(24, 8, 0),
(24, 9, 0),
(24, 10, 0),
(24, 11, 0),
(24, 12, 0),
(25, 1, 0),
(25, 2, 0),
(25, 3, 0),
(25, 4, 0),
(25, 5, 0),
(25, 6, 0),
(25, 7, 0),
(25, 8, 0),
(25, 9, 0),
(25, 10, 0),
(25, 11, 0),
(25, 12, 0),
(26, 1, 0),
(26, 2, 0),
(26, 3, 0),
(26, 4, 0),
(26, 5, 0),
(26, 6, 0),
(26, 7, 0),
(26, 8, 0),
(26, 9, 0),
(26, 10, 0),
(26, 11, 0),
(26, 12, 0),
(27, 1, 0),
(27, 2, 0),
(27, 3, 0),
(27, 4, 0),
(27, 5, 0),
(27, 6, 0),
(27, 7, 0),
(27, 8, 0),
(27, 9, 0),
(27, 10, 0),
(27, 11, 0),
(27, 12, 0),
(28, 1, 0),
(28, 2, 0),
(28, 3, 0),
(28, 4, 0),
(28, 5, 0),
(28, 6, 0),
(28, 7, 0),
(28, 8, 0),
(28, 9, 0),
(28, 10, 0),
(28, 11, 0),
(28, 12, 0),
(29, 1, 0),
(29, 2, 0),
(29, 3, 0),
(29, 4, 0),
(29, 5, 0),
(29, 6, 0),
(29, 7, 0),
(29, 8, 0),
(29, 9, 0),
(29, 10, 0),
(29, 11, 0),
(29, 12, 0),
(30, 1, 0),
(30, 2, 0),
(30, 3, 0),
(30, 4, 0),
(30, 5, 0),
(30, 6, 0),
(30, 7, 5),
(30, 8, 0),
(30, 9, 0),
(30, 10, 0),
(30, 11, 0),
(30, 12, 0),
(31, 1, 0),
(31, 2, 0),
(31, 3, 2),
(31, 4, 0),
(31, 5, 0),
(31, 6, 0),
(31, 7, 0),
(31, 8, 0),
(31, 9, 0),
(31, 10, 0),
(31, 11, 0),
(31, 12, 0),
(32, 1, 0),
(32, 2, 0),
(32, 3, 0),
(32, 4, 0),
(32, 5, 0),
(32, 6, 0),
(32, 7, 5),
(32, 8, 0),
(32, 9, 0),
(32, 10, 0),
(32, 11, 0),
(32, 12, 0),
(33, 1, 0),
(33, 2, 0),
(33, 3, 0),
(33, 4, 0),
(33, 5, 0),
(33, 6, 0),
(33, 7, 5),
(33, 8, 0),
(33, 9, 0),
(33, 10, 0),
(33, 11, 0),
(33, 12, 0),
(34, 1, 0),
(34, 2, 0),
(34, 3, 0),
(34, 4, 0),
(34, 5, 0),
(34, 6, 0),
(34, 7, 5),
(34, 8, 0),
(34, 9, 0),
(34, 10, 0),
(34, 11, 0),
(34, 12, 0),
(35, 1, 0),
(35, 2, 0),
(35, 3, 0),
(35, 4, 0),
(35, 5, 0),
(35, 6, 0),
(35, 7, 5),
(35, 8, 0),
(35, 9, 0),
(35, 10, 0),
(35, 11, 0),
(35, 12, 0),
(36, 1, 0),
(36, 2, 0),
(36, 3, 0),
(36, 4, 0),
(36, 5, 0),
(36, 6, 0),
(36, 7, 0),
(36, 8, 0),
(36, 9, 0),
(36, 10, 0),
(36, 11, 0),
(36, 12, 0),
(37, 1, 0),
(37, 2, 0),
(37, 3, 0),
(37, 4, 0),
(37, 5, 0),
(37, 6, 0),
(37, 7, 0),
(37, 8, 0),
(37, 9, 0),
(37, 10, 0),
(37, 11, 0),
(37, 12, 0),
(38, 1, 0),
(38, 2, 0),
(38, 3, 0),
(38, 4, 0),
(38, 5, 0),
(38, 6, 0),
(38, 7, 0),
(38, 8, 0),
(38, 9, 0),
(38, 10, 0),
(38, 11, 0),
(38, 12, 0),
(39, 1, 0),
(39, 2, 7),
(39, 3, 0),
(39, 4, 0),
(39, 5, 0),
(39, 6, 0),
(39, 7, 0),
(39, 8, 0),
(39, 9, 0),
(39, 10, 0),
(39, 11, 0),
(39, 12, 0),
(40, 1, 0),
(40, 2, 0),
(40, 3, 0),
(40, 4, 0),
(40, 5, 0),
(40, 6, 0),
(40, 7, 0),
(40, 8, 0),
(40, 9, 0),
(40, 10, 0),
(40, 11, 0),
(40, 12, 0),
(41, 1, 0),
(41, 2, 0),
(41, 3, 0),
(41, 4, 0),
(41, 5, 0),
(41, 6, 0),
(41, 7, 0),
(41, 8, 0),
(41, 9, 0),
(41, 10, 0),
(41, 11, 0),
(41, 12, 0),
(42, 1, 0),
(42, 2, 0),
(42, 3, 0),
(42, 4, 0),
(42, 5, 0),
(42, 6, 0),
(42, 7, 0),
(42, 8, 0),
(42, 9, 0),
(42, 10, 0),
(42, 11, 0),
(42, 12, 0),
(43, 1, 0),
(43, 2, 0),
(43, 3, 0),
(43, 4, 0),
(43, 5, 0),
(43, 6, 0),
(43, 7, 0),
(43, 8, 0),
(43, 9, 0),
(43, 10, 0),
(43, 11, 0),
(43, 12, 0),
(44, 1, 0),
(44, 2, 0),
(44, 3, 0),
(44, 4, 0),
(44, 5, 0),
(44, 6, 1),
(44, 7, 0),
(44, 8, 0),
(44, 9, 0),
(44, 10, 0),
(44, 11, 0),
(44, 12, 0),
(45, 1, 5),
(45, 2, 5),
(45, 3, 0),
(45, 4, 0),
(45, 5, 0),
(45, 6, 0),
(45, 7, 0),
(45, 8, 0),
(45, 9, 0),
(45, 10, 0),
(45, 11, 0),
(45, 12, 0),
(46, 1, 0),
(46, 2, 7),
(46, 3, 0),
(46, 4, 0),
(46, 5, 0),
(46, 6, 0),
(46, 7, 0),
(46, 8, 0),
(46, 9, 1),
(46, 10, 1),
(46, 11, 0),
(46, 12, 0),
(47, 1, 0),
(47, 2, 7),
(47, 3, 0),
(47, 4, 0),
(47, 5, 0),
(47, 6, 0),
(47, 7, 0),
(47, 8, 0),
(47, 9, 1),
(47, 10, 1),
(47, 11, 0),
(47, 12, 0),
(48, 1, 0),
(48, 2, 7),
(48, 3, 0),
(48, 4, 0),
(48, 5, 0),
(48, 6, 0),
(48, 7, 0),
(48, 8, 0),
(48, 9, 1),
(48, 10, 1),
(48, 11, 0),
(48, 12, 0),
(49, 1, 5),
(49, 2, 0),
(49, 3, 0),
(49, 4, 0),
(49, 5, 0),
(49, 6, 0),
(49, 7, 0),
(49, 8, 0),
(49, 9, 0),
(49, 10, 0),
(49, 11, 0),
(49, 12, 0),
(50, 1, 5),
(50, 2, 0),
(50, 3, 0),
(50, 4, 0),
(50, 5, 0),
(50, 6, 0),
(50, 7, 0),
(50, 8, 0),
(50, 9, 0),
(50, 10, 0),
(50, 11, 0),
(50, 12, 0),
(51, 1, 5),
(51, 2, 0),
(51, 3, 0),
(51, 4, 0),
(51, 5, 0),
(51, 6, 0),
(51, 7, 0),
(51, 8, 0),
(51, 9, 0),
(51, 10, 0),
(51, 11, 0),
(51, 12, 0),
(52, 1, 0),
(52, 2, 0),
(52, 3, 0),
(52, 4, 0),
(52, 5, 0),
(52, 6, 0),
(52, 7, 0),
(52, 8, 0),
(52, 9, 0),
(52, 10, 0),
(52, 11, 0),
(52, 12, 0),
(53, 1, 0),
(53, 2, 5),
(53, 3, 1),
(53, 4, 0),
(53, 5, 0),
(53, 6, 0),
(53, 7, 0),
(53, 8, 0),
(53, 9, 0),
(53, 10, 0),
(53, 11, 0),
(53, 12, 0),
(54, 1, 2),
(54, 2, 0),
(54, 3, 5),
(54, 4, 0),
(54, 5, 0),
(54, 6, 0),
(54, 7, 0),
(54, 8, 0),
(54, 9, 0),
(54, 10, 0),
(54, 11, 0),
(54, 12, 0),
(55, 1, 2),
(55, 2, 0),
(55, 3, 5),
(55, 4, 0),
(55, 5, 0),
(55, 6, 0),
(55, 7, 0),
(55, 8, 0),
(55, 9, 0),
(55, 10, 0),
(55, 11, 0),
(55, 12, 0),
(56, 1, 0),
(56, 2, 0),
(56, 3, 0),
(56, 4, 0),
(56, 5, 0),
(56, 6, 0),
(56, 7, 0),
(56, 8, 0),
(56, 9, 0),
(56, 10, 0),
(56, 11, 0),
(56, 12, 0),
(57, 1, 0),
(57, 2, 0),
(57, 3, 0),
(57, 4, 0),
(57, 5, 0),
(57, 6, 0),
(57, 7, 0),
(57, 8, 0),
(57, 9, 0),
(57, 10, 0),
(57, 11, 0),
(57, 12, 0),
(58, 1, 0),
(58, 2, 0),
(58, 3, 0),
(58, 4, 0),
(58, 5, 0),
(58, 6, 0),
(58, 7, 0),
(58, 8, 0),
(58, 9, 0),
(58, 10, 0),
(58, 11, 0),
(58, 12, 0),
(59, 1, 0),
(59, 2, 0),
(59, 3, 0),
(59, 4, 0),
(59, 5, 0),
(59, 6, 0),
(59, 7, 0),
(59, 8, 0),
(59, 9, 0),
(59, 10, 0),
(59, 11, 0),
(59, 12, 0),
(60, 1, 0),
(60, 2, 0),
(60, 3, 0),
(60, 4, 0),
(60, 5, 0),
(60, 6, 0),
(60, 7, 0),
(60, 8, 0),
(60, 9, 0),
(60, 10, 0),
(60, 11, 0),
(60, 12, 0),
(61, 1, 0),
(61, 2, 0),
(61, 3, 0),
(61, 4, 0),
(61, 5, 0),
(61, 6, 0),
(61, 7, 0),
(61, 8, 0),
(61, 9, 0),
(61, 10, 0),
(61, 11, 0),
(61, 12, 0),
(62, 1, 0),
(62, 2, 0),
(62, 3, 0),
(62, 4, 0),
(62, 5, 0),
(62, 6, 0),
(62, 7, 0),
(62, 8, 0),
(62, 9, 0),
(62, 10, 0),
(62, 11, 0),
(62, 12, 0),
(63, 1, 0),
(63, 2, 0),
(63, 3, 0),
(63, 4, 0),
(63, 5, 0),
(63, 6, 0),
(63, 7, 0),
(63, 8, 0),
(63, 9, 0),
(63, 10, 0),
(63, 11, 0),
(63, 12, 0);

-- --------------------------------------------------------

--
-- Structure de la table `pstreenodessecondarystatselementalresistsdata`
--

CREATE TABLE `pstreenodessecondarystatselementalresistsdata` (
  `idNode` int(10) UNSIGNED NOT NULL,
  `idElementType` int(10) UNSIGNED NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `pstreenodessecondarystatselementalresistsdata`
--

INSERT INTO `pstreenodessecondarystatselementalresistsdata` (`idNode`, `idElementType`, `value`) VALUES
(1, 1, 0),
(1, 2, 0),
(1, 3, 0),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(1, 7, 0),
(2, 1, 0),
(2, 2, 0),
(2, 3, 0),
(2, 4, 0),
(2, 5, 0),
(2, 6, 0),
(2, 7, 0),
(3, 1, 0),
(3, 2, 0),
(3, 3, 0),
(3, 4, 0),
(3, 5, 0),
(3, 6, 0),
(3, 7, 0),
(4, 1, 0),
(4, 2, 0),
(4, 3, 0),
(4, 4, 0),
(4, 5, 0),
(4, 6, 0),
(4, 7, 0),
(5, 1, 1),
(5, 2, 1),
(5, 3, 1),
(5, 4, 1),
(5, 5, 1),
(5, 6, 0),
(5, 7, 0),
(6, 1, 0),
(6, 2, 0),
(6, 3, 0),
(6, 4, 2),
(6, 5, 0),
(6, 6, 0),
(6, 7, 0),
(7, 1, 0),
(7, 2, 0),
(7, 3, 0),
(7, 4, 0),
(7, 5, 2),
(7, 6, 0),
(7, 7, 0),
(8, 1, 0),
(8, 2, 0),
(8, 3, 2),
(8, 4, 0),
(8, 5, 0),
(8, 6, 0),
(8, 7, 0),
(9, 1, 0),
(9, 2, 2),
(9, 3, 0),
(9, 4, 0),
(9, 5, 0),
(9, 6, 0),
(9, 7, 0),
(10, 1, 0),
(10, 2, 0),
(10, 3, 0),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(10, 7, 0),
(11, 1, 0),
(11, 2, 0),
(11, 3, 0),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(11, 7, 0),
(12, 1, 0),
(12, 2, 0),
(12, 3, 0),
(12, 4, 0),
(12, 5, 0),
(12, 6, 0),
(12, 7, 0),
(13, 1, 0),
(13, 2, 0),
(13, 3, 0),
(13, 4, 0),
(13, 5, 0),
(13, 6, 0),
(13, 7, 0),
(14, 1, 0),
(14, 2, 0),
(14, 3, 0),
(14, 4, 0),
(14, 5, 0),
(14, 6, 0),
(14, 7, 0),
(15, 1, 0),
(15, 2, 0),
(15, 3, 0),
(15, 4, 0),
(15, 5, 0),
(15, 6, 0),
(15, 7, 0),
(16, 1, 0),
(16, 2, 0),
(16, 3, 0),
(16, 4, 0),
(16, 5, 0),
(16, 6, 0),
(16, 7, 0),
(17, 1, 0),
(17, 2, 0),
(17, 3, 0),
(17, 4, 0),
(17, 5, 0),
(17, 6, 0),
(17, 7, 0),
(18, 1, 2),
(18, 2, 1),
(18, 3, 1),
(18, 4, 1),
(18, 5, 1),
(18, 6, 0),
(18, 7, 0),
(19, 1, 5),
(19, 2, 0),
(19, 3, 0),
(19, 4, 0),
(19, 5, 0),
(19, 6, 0),
(19, 7, 0),
(20, 1, 10),
(20, 2, 0),
(20, 3, 0),
(20, 4, 0),
(20, 5, 0),
(20, 6, 0),
(20, 7, 0),
(21, 1, 2),
(21, 2, 2),
(21, 3, 2),
(21, 4, 2),
(21, 5, 2),
(21, 6, 0),
(21, 7, 0),
(22, 1, 9),
(22, 2, 9),
(22, 3, 9),
(22, 4, 9),
(22, 5, 9),
(22, 6, 0),
(22, 7, 0),
(23, 1, 0),
(23, 2, 0),
(23, 3, 0),
(23, 4, 0),
(23, 5, 0),
(23, 6, 0),
(23, 7, 0),
(24, 1, 0),
(24, 2, 0),
(24, 3, 0),
(24, 4, 0),
(24, 5, 0),
(24, 6, 0),
(24, 7, 0),
(25, 1, 0),
(25, 2, 0),
(25, 3, 0),
(25, 4, 0),
(25, 5, 0),
(25, 6, 0),
(25, 7, 0),
(26, 1, 0),
(26, 2, 0),
(26, 3, 0),
(26, 4, 0),
(26, 5, 0),
(26, 6, 0),
(26, 7, 0),
(27, 1, 0),
(27, 2, 0),
(27, 3, 0),
(27, 4, 0),
(27, 5, 0),
(27, 6, 0),
(27, 7, 0),
(28, 1, 0),
(28, 2, 0),
(28, 3, 0),
(28, 4, 0),
(28, 5, 0),
(28, 6, 0),
(28, 7, 0),
(29, 1, 0),
(29, 2, 0),
(29, 3, 0),
(29, 4, 0),
(29, 5, 0),
(29, 6, 0),
(29, 7, 0),
(30, 1, 0),
(30, 2, 0),
(30, 3, 0),
(30, 4, 0),
(30, 5, 0),
(30, 6, 0),
(30, 7, 0),
(31, 1, 0),
(31, 2, 0),
(31, 3, 0),
(31, 4, 0),
(31, 5, 0),
(31, 6, 0),
(31, 7, 0),
(32, 1, 0),
(32, 2, 0),
(32, 3, 0),
(32, 4, 0),
(32, 5, 0),
(32, 6, 0),
(32, 7, 0),
(33, 1, 0),
(33, 2, 0),
(33, 3, 0),
(33, 4, 0),
(33, 5, 0),
(33, 6, 0),
(33, 7, 0),
(34, 1, 0),
(34, 2, 0),
(34, 3, 0),
(34, 4, 0),
(34, 5, 0),
(34, 6, 0),
(34, 7, 0),
(35, 1, 0),
(35, 2, 0),
(35, 3, 0),
(35, 4, 0),
(35, 5, 0),
(35, 6, 0),
(35, 7, 0),
(36, 1, 0),
(36, 2, 0),
(36, 3, 0),
(36, 4, 0),
(36, 5, 0),
(36, 6, 0),
(36, 7, 0),
(37, 1, 0),
(37, 2, 0),
(37, 3, 0),
(37, 4, 0),
(37, 5, 0),
(37, 6, 0),
(37, 7, 0),
(38, 1, 0),
(38, 2, 0),
(38, 3, 0),
(38, 4, 0),
(38, 5, 0),
(38, 6, 0),
(38, 7, 0),
(39, 1, 1),
(39, 2, 1),
(39, 3, 1),
(39, 4, 1),
(39, 5, 1),
(39, 6, 0),
(39, 7, 0),
(40, 1, 0),
(40, 2, 0),
(40, 3, 0),
(40, 4, 0),
(40, 5, 2),
(40, 6, 0),
(40, 7, 0),
(41, 1, 0),
(41, 2, 2),
(41, 3, 0),
(41, 4, 0),
(41, 5, 0),
(41, 6, 0),
(41, 7, 0),
(42, 1, 0),
(42, 2, 0),
(42, 3, 0),
(42, 4, 2),
(42, 5, 0),
(42, 6, 0),
(42, 7, 0),
(43, 1, 0),
(43, 2, 0),
(43, 3, 2),
(43, 4, 0),
(43, 5, 0),
(43, 6, 0),
(43, 7, 0),
(44, 1, 0),
(44, 2, 0),
(44, 3, 0),
(44, 4, 0),
(44, 5, 0),
(44, 6, 0),
(44, 7, 0),
(45, 1, 0),
(45, 2, 0),
(45, 3, 0),
(45, 4, 0),
(45, 5, 0),
(45, 6, 0),
(45, 7, 0),
(46, 1, 0),
(46, 2, 0),
(46, 3, 0),
(46, 4, 0),
(46, 5, 0),
(46, 6, 0),
(46, 7, 0),
(47, 1, 0),
(47, 2, 0),
(47, 3, 0),
(47, 4, 0),
(47, 5, 0),
(47, 6, 0),
(47, 7, 0),
(48, 1, 0),
(48, 2, 0),
(48, 3, 0),
(48, 4, 0),
(48, 5, 0),
(48, 6, 0),
(48, 7, 0),
(49, 1, 0),
(49, 2, 0),
(49, 3, 0),
(49, 4, 0),
(49, 5, 0),
(49, 6, 0),
(49, 7, 0),
(50, 1, 0),
(50, 2, 0),
(50, 3, 0),
(50, 4, 0),
(50, 5, 0),
(50, 6, 0),
(50, 7, 0),
(51, 1, 0),
(51, 2, 0),
(51, 3, 0),
(51, 4, 0),
(51, 5, 0),
(51, 6, 0),
(51, 7, 0),
(52, 1, 0),
(52, 2, 0),
(52, 3, 0),
(52, 4, 5),
(52, 5, 0),
(52, 6, 0),
(52, 7, 0),
(53, 1, 0),
(53, 2, 0),
(53, 3, 0),
(53, 4, 0),
(53, 5, 0),
(53, 6, 0),
(53, 7, 0),
(54, 1, 0),
(54, 2, 0),
(54, 3, 0),
(54, 4, 0),
(54, 5, 0),
(54, 6, 0),
(54, 7, 0),
(55, 1, 0),
(55, 2, 0),
(55, 3, 0),
(55, 4, 0),
(55, 5, 0),
(55, 6, 0),
(55, 7, 0),
(56, 1, 1),
(56, 2, 1),
(56, 3, 1),
(56, 4, 1),
(56, 5, 1),
(56, 6, 0),
(56, 7, 0),
(57, 1, 0),
(57, 2, 0),
(57, 3, 0),
(57, 4, 0),
(57, 5, 2),
(57, 6, 0),
(57, 7, 0),
(58, 1, 0),
(58, 2, 2),
(58, 3, 0),
(58, 4, 0),
(58, 5, 0),
(58, 6, 0),
(58, 7, 0),
(59, 1, 0),
(59, 2, 0),
(59, 3, 2),
(59, 4, 0),
(59, 5, 0),
(59, 6, 0),
(59, 7, 0),
(60, 1, 0),
(60, 2, 0),
(60, 3, 0),
(60, 4, 2),
(60, 5, 0),
(60, 6, 0),
(60, 7, 0),
(61, 1, 0),
(61, 2, 0),
(61, 3, 0),
(61, 4, 0),
(61, 5, 0),
(61, 6, 0),
(61, 7, 0),
(62, 1, 0),
(62, 2, 0),
(62, 3, 0),
(62, 4, 0),
(62, 5, 0),
(62, 6, 0),
(62, 7, 0),
(63, 1, 0),
(63, 2, 0),
(63, 3, 0),
(63, 4, 0),
(63, 5, 0),
(63, 6, 0),
(63, 7, 0);

-- --------------------------------------------------------

--
-- Structure de la table `pstreenodesskillsunlockdata`
--

CREATE TABLE `pstreenodesskillsunlockdata` (
  `idNode` int(10) UNSIGNED NOT NULL,
  `idSkill` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `pstreenodesskillsunlockdata`
--

INSERT INTO `pstreenodesskillsunlockdata` (`idNode`, `idSkill`) VALUES
(1, 1),
(44, 2),
(23, 3),
(9, 4),
(8, 5),
(6, 6),
(7, 7),
(58, 8),
(59, 9),
(60, 10),
(57, 11),
(41, 12),
(43, 13),
(42, 14),
(40, 15),
(52, 16),
(50, 17),
(17, 18),
(29, 19),
(30, 20),
(31, 21),
(32, 22),
(33, 23),
(25, 24),
(51, 25),
(45, 26),
(2, 27),
(18, 27),
(4, 32),
(53, 33),
(35, 34);

-- --------------------------------------------------------

--
-- Structure de la table `pstreenodesstatesdata`
--

CREATE TABLE `pstreenodesstatesdata` (
  `idNode` int(10) UNSIGNED NOT NULL,
  `idState` int(10) UNSIGNED NOT NULL,
  `isProtectedFrom` tinyint(4) NOT NULL DEFAULT '0',
  `isAdded` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `pstreenodesstatsdata`
--

CREATE TABLE `pstreenodesstatsdata` (
  `idNode` int(10) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `pstreenodesstatsdata`
--

INSERT INTO `pstreenodesstatsdata` (`idNode`, `idStat`, `value`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 2),
(1, 4, 0),
(1, 5, 1),
(1, 6, 0),
(1, 7, 0),
(1, 8, 0),
(1, 9, 0),
(1, 10, 0),
(2, 1, 3),
(2, 2, 0),
(2, 3, 2),
(2, 4, 0),
(2, 5, 0),
(2, 6, 0),
(2, 7, 0),
(2, 8, 0),
(2, 9, 0),
(2, 10, 0),
(3, 1, 5),
(3, 2, 0),
(3, 3, 0),
(3, 4, 0),
(3, 5, 0),
(3, 6, 0),
(3, 7, 0),
(3, 8, 0),
(3, 9, 0),
(3, 10, 0),
(4, 1, 0),
(4, 2, 0),
(4, 3, 0),
(4, 4, 0),
(4, 5, 0),
(4, 6, 0),
(4, 7, 0),
(4, 8, 0),
(4, 9, 0),
(4, 10, 0),
(5, 1, 5),
(5, 2, 0),
(5, 3, 0),
(5, 4, 0),
(5, 5, 0),
(5, 6, 0),
(5, 7, 0),
(5, 8, 0),
(5, 9, 0),
(5, 10, 0),
(6, 1, 12),
(6, 2, 0),
(6, 3, 3),
(6, 4, 0),
(6, 5, 0),
(6, 6, 0),
(6, 7, 0),
(6, 8, 0),
(6, 9, 0),
(6, 10, 0),
(7, 1, 12),
(7, 2, 0),
(7, 3, 3),
(7, 4, 0),
(7, 5, 0),
(7, 6, 0),
(7, 7, 0),
(7, 8, 0),
(7, 9, 0),
(7, 10, 0),
(8, 1, 12),
(8, 2, 0),
(8, 3, 3),
(8, 4, 0),
(8, 5, 0),
(8, 6, 0),
(8, 7, 0),
(8, 8, 0),
(8, 9, 0),
(8, 10, 0),
(9, 1, 12),
(9, 2, 0),
(9, 3, 3),
(9, 4, 0),
(9, 5, 0),
(9, 6, 0),
(9, 7, 0),
(9, 8, 0),
(9, 9, 0),
(9, 10, 0),
(10, 1, 5),
(10, 2, 0),
(10, 3, 0),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(10, 7, 0),
(10, 8, 0),
(10, 9, 0),
(10, 10, 0),
(11, 1, 10),
(11, 2, 0),
(11, 3, 0),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(11, 7, 0),
(11, 8, 0),
(11, 9, 0),
(11, 10, 0),
(12, 1, 25),
(12, 2, 0),
(12, 3, 0),
(12, 4, 0),
(12, 5, 0),
(12, 6, 0),
(12, 7, 0),
(12, 8, 0),
(12, 9, 0),
(12, 10, 0),
(13, 1, 0),
(13, 2, 0),
(13, 3, 5),
(13, 4, 0),
(13, 5, 0),
(13, 6, 0),
(13, 7, 0),
(13, 8, 0),
(13, 9, 0),
(13, 10, 0),
(14, 1, 0),
(14, 2, 0),
(14, 3, 5),
(14, 4, 0),
(14, 5, 0),
(14, 6, 0),
(14, 7, 0),
(14, 8, 0),
(14, 9, 0),
(14, 10, 0),
(15, 1, 0),
(15, 2, 0),
(15, 3, 10),
(15, 4, 0),
(15, 5, 0),
(15, 6, 0),
(15, 7, 0),
(15, 8, 0),
(15, 9, 0),
(15, 10, 0),
(16, 1, 0),
(16, 2, 0),
(16, 3, 25),
(16, 4, 0),
(16, 5, 0),
(16, 6, 0),
(16, 7, 0),
(16, 8, 0),
(16, 9, 0),
(16, 10, 0),
(17, 1, 0),
(17, 2, 0),
(17, 3, 10),
(17, 4, 0),
(17, 5, 0),
(17, 6, 0),
(17, 7, 0),
(17, 8, 0),
(17, 9, 0),
(17, 10, 0),
(18, 1, 0),
(18, 2, 0),
(18, 3, 5),
(18, 4, 0),
(18, 5, 0),
(18, 6, 0),
(18, 7, 0),
(18, 8, 0),
(18, 9, 0),
(18, 10, 0),
(19, 1, 0),
(19, 2, 0),
(19, 3, 10),
(19, 4, 0),
(19, 5, 0),
(19, 6, 0),
(19, 7, 0),
(19, 8, 0),
(19, 9, 0),
(19, 10, 0),
(20, 1, 0),
(20, 2, 0),
(20, 3, 5),
(20, 4, 0),
(20, 5, 0),
(20, 6, 0),
(20, 7, 0),
(20, 8, 0),
(20, 9, 0),
(20, 10, 0),
(21, 1, 0),
(21, 2, 0),
(21, 3, 5),
(21, 4, 0),
(21, 5, 0),
(21, 6, 0),
(21, 7, 0),
(21, 8, 0),
(21, 9, 0),
(21, 10, 0),
(22, 1, 0),
(22, 2, 0),
(22, 3, 0),
(22, 4, 0),
(22, 5, 0),
(22, 6, 0),
(22, 7, 0),
(22, 8, 0),
(22, 9, 0),
(22, 10, 0),
(23, 1, 0),
(23, 2, 5),
(23, 3, 0),
(23, 4, 0),
(23, 5, 0),
(23, 6, 1),
(23, 7, 0),
(23, 8, 0),
(23, 9, 0),
(23, 10, 0),
(24, 1, 0),
(24, 2, 5),
(24, 3, 0),
(24, 4, 0),
(24, 5, 0),
(24, 6, 5),
(24, 7, 0),
(24, 8, 0),
(24, 9, 0),
(24, 10, 0),
(25, 1, 0),
(25, 2, 0),
(25, 3, 0),
(25, 4, 0),
(25, 5, 0),
(25, 6, 5),
(25, 7, 0),
(25, 8, 0),
(25, 9, 0),
(25, 10, 0),
(26, 1, 0),
(26, 2, 0),
(26, 3, 0),
(26, 4, 0),
(26, 5, 0),
(26, 6, 5),
(26, 7, 0),
(26, 8, 0),
(26, 9, 0),
(26, 10, 0),
(27, 1, 0),
(27, 2, 0),
(27, 3, 0),
(27, 4, 0),
(27, 5, 0),
(27, 6, 10),
(27, 7, 0),
(27, 8, 0),
(27, 9, 0),
(27, 10, 0),
(28, 1, 0),
(28, 2, 0),
(28, 3, 0),
(28, 4, 0),
(28, 5, 0),
(28, 6, 25),
(28, 7, 0),
(28, 8, 0),
(28, 9, 0),
(28, 10, 0),
(29, 1, 0),
(29, 2, 5),
(29, 3, 0),
(29, 4, 0),
(29, 5, 0),
(29, 6, 5),
(29, 7, 0),
(29, 8, 0),
(29, 9, 0),
(29, 10, 0),
(30, 1, 0),
(30, 2, 5),
(30, 3, 0),
(30, 4, 0),
(30, 5, 0),
(30, 6, 5),
(30, 7, 0),
(30, 8, 0),
(30, 9, 0),
(30, 10, 0),
(31, 1, 0),
(31, 2, 20),
(31, 3, 0),
(31, 4, 0),
(31, 5, 0),
(31, 6, 5),
(31, 7, 0),
(31, 8, 0),
(31, 9, 0),
(31, 10, 0),
(32, 1, 0),
(32, 2, 0),
(32, 3, 0),
(32, 4, 0),
(32, 5, 0),
(32, 6, 5),
(32, 7, 0),
(32, 8, 0),
(32, 9, 0),
(32, 10, 0),
(33, 1, 0),
(33, 2, 5),
(33, 3, 0),
(33, 4, 0),
(33, 5, 0),
(33, 6, 5),
(33, 7, 0),
(33, 8, 0),
(33, 9, 0),
(33, 10, 0),
(34, 1, 0),
(34, 2, 5),
(34, 3, 0),
(34, 4, 0),
(34, 5, 0),
(34, 6, 0),
(34, 7, 0),
(34, 8, 0),
(34, 9, 0),
(34, 10, 0),
(35, 1, 0),
(35, 2, 0),
(35, 3, 0),
(35, 4, 0),
(35, 5, 0),
(35, 6, 0),
(35, 7, 0),
(35, 8, 0),
(35, 9, 0),
(35, 10, 0),
(36, 1, 0),
(36, 2, 5),
(36, 3, 0),
(36, 4, 0),
(36, 5, 0),
(36, 6, 0),
(36, 7, 0),
(36, 8, 0),
(36, 9, 0),
(36, 10, 0),
(37, 1, 0),
(37, 2, 10),
(37, 3, 0),
(37, 4, 0),
(37, 5, 0),
(37, 6, 0),
(37, 7, 0),
(37, 8, 0),
(37, 9, 0),
(37, 10, 0),
(38, 1, 0),
(38, 2, 25),
(38, 3, 0),
(38, 4, 0),
(38, 5, 0),
(38, 6, 0),
(38, 7, 0),
(38, 8, 0),
(38, 9, 0),
(38, 10, 0),
(39, 1, 0),
(39, 2, 5),
(39, 3, 0),
(39, 4, 0),
(39, 5, 0),
(39, 6, 5),
(39, 7, 0),
(39, 8, 0),
(39, 9, 0),
(39, 10, 0),
(40, 1, 0),
(40, 2, 5),
(40, 3, 0),
(40, 4, 0),
(40, 5, 0),
(40, 6, 5),
(40, 7, 0),
(40, 8, 0),
(40, 9, 0),
(40, 10, 0),
(41, 1, 0),
(41, 2, 5),
(41, 3, 0),
(41, 4, 0),
(41, 5, 0),
(41, 6, 5),
(41, 7, 0),
(41, 8, 0),
(41, 9, 0),
(41, 10, 0),
(42, 1, 0),
(42, 2, 5),
(42, 3, 0),
(42, 4, 0),
(42, 5, 0),
(42, 6, 5),
(42, 7, 0),
(42, 8, 0),
(42, 9, 0),
(42, 10, 0),
(43, 1, 0),
(43, 2, 5),
(43, 3, 0),
(43, 4, 0),
(43, 5, 0),
(43, 6, 5),
(43, 7, 0),
(43, 8, 0),
(43, 9, 0),
(43, 10, 0),
(44, 1, 0),
(44, 2, 0),
(44, 3, 0),
(44, 4, 0),
(44, 5, 5),
(44, 6, 0),
(44, 7, 0),
(44, 8, 0),
(44, 9, 0),
(44, 10, 0),
(45, 1, 0),
(45, 2, 0),
(45, 3, 0),
(45, 4, 0),
(45, 5, 5),
(45, 6, 0),
(45, 7, 0),
(45, 8, 0),
(45, 9, 0),
(45, 10, 0),
(46, 1, 0),
(46, 2, 0),
(46, 3, 0),
(46, 4, 0),
(46, 5, 0),
(46, 6, 0),
(46, 7, 0),
(46, 8, 0),
(46, 9, 0),
(46, 10, 0),
(47, 1, 0),
(47, 2, 0),
(47, 3, 0),
(47, 4, 0),
(47, 5, 0),
(47, 6, 0),
(47, 7, 0),
(47, 8, 0),
(47, 9, 0),
(47, 10, 0),
(48, 1, 0),
(48, 2, 0),
(48, 3, 0),
(48, 4, 0),
(48, 5, 0),
(48, 6, 0),
(48, 7, 0),
(48, 8, 0),
(48, 9, 0),
(48, 10, 0),
(49, 1, 0),
(49, 2, 0),
(49, 3, 0),
(49, 4, 0),
(49, 5, 0),
(49, 6, 0),
(49, 7, 0),
(49, 8, 10),
(49, 9, 0),
(49, 10, 10),
(50, 1, 0),
(50, 2, 0),
(50, 3, 0),
(50, 4, 0),
(50, 5, 5),
(50, 6, 0),
(50, 7, 0),
(50, 8, 0),
(50, 9, 0),
(50, 10, 0),
(51, 1, 0),
(51, 2, 0),
(51, 3, 0),
(51, 4, 0),
(51, 5, 5),
(51, 6, 0),
(51, 7, 0),
(51, 8, 0),
(51, 9, 0),
(51, 10, 0),
(52, 1, 0),
(52, 2, 0),
(52, 3, 0),
(52, 4, 0),
(52, 5, 5),
(52, 6, 0),
(52, 7, 0),
(52, 8, 0),
(52, 9, 0),
(52, 10, 0),
(53, 1, 0),
(53, 2, 0),
(53, 3, 0),
(53, 4, 0),
(53, 5, 5),
(53, 6, 0),
(53, 7, 0),
(53, 8, 0),
(53, 9, 0),
(53, 10, 0),
(54, 1, 0),
(54, 2, 0),
(54, 3, 0),
(54, 4, 0),
(54, 5, 0),
(54, 6, 0),
(54, 7, 0),
(54, 8, 0),
(54, 9, 0),
(54, 10, 0),
(55, 1, 0),
(55, 2, 0),
(55, 3, 0),
(55, 4, 0),
(55, 5, 0),
(55, 6, 0),
(55, 7, 0),
(55, 8, 0),
(55, 9, 0),
(55, 10, 0),
(56, 1, 0),
(56, 2, 0),
(56, 3, 0),
(56, 4, 0),
(56, 5, 5),
(56, 6, 0),
(56, 7, 0),
(56, 8, 5),
(56, 9, 0),
(56, 10, 0),
(57, 1, 0),
(57, 2, 0),
(57, 3, 0),
(57, 4, 0),
(57, 5, 5),
(57, 6, 0),
(57, 7, 0),
(57, 8, 5),
(57, 9, 0),
(57, 10, 0),
(58, 1, 0),
(58, 2, 0),
(58, 3, 0),
(58, 4, 0),
(58, 5, 5),
(58, 6, 0),
(58, 7, 0),
(58, 8, 5),
(58, 9, 0),
(58, 10, 0),
(59, 1, 0),
(59, 2, 0),
(59, 3, 0),
(59, 4, 0),
(59, 5, 5),
(59, 6, 0),
(59, 7, 0),
(59, 8, 5),
(59, 9, 0),
(59, 10, 0),
(60, 1, 0),
(60, 2, 0),
(60, 3, 0),
(60, 4, 0),
(60, 5, 5),
(60, 6, 0),
(60, 7, 0),
(60, 8, 5),
(60, 9, 0),
(60, 10, 0),
(61, 1, 0),
(61, 2, 0),
(61, 3, 0),
(61, 4, 0),
(61, 5, 5),
(61, 6, 0),
(61, 7, 0),
(61, 8, 0),
(61, 9, 0),
(61, 10, 0),
(62, 1, 0),
(62, 2, 0),
(62, 3, 0),
(62, 4, 0),
(62, 5, 10),
(62, 6, 0),
(62, 7, 0),
(62, 8, 0),
(62, 9, 0),
(62, 10, 0),
(63, 1, 0),
(63, 2, 0),
(63, 3, 0),
(63, 4, 0),
(63, 5, 25),
(63, 6, 0),
(63, 7, 0),
(63, 8, 0),
(63, 9, 0),
(63, 10, 0);

-- --------------------------------------------------------

--
-- Structure de la table `pstreepossiblesnodesvisuals`
--

CREATE TABLE `pstreepossiblesnodesvisuals` (
  `idNode` int(10) UNSIGNED NOT NULL,
  `icon` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `pstreepossiblesnodesvisuals`
--

INSERT INTO `pstreepossiblesnodesvisuals` (`idNode`, `icon`) VALUES
(1, 'https://cdn.fight-rpg.com/images/pstree/sword-strength.png'),
(2, 'https://cdn.fight-rpg.com/images/pstree/constitution.png'),
(3, 'https://cdn.fight-rpg.com/images/pstree/perception.png'),
(4, 'https://cdn.fight-rpg.com/images/pstree/armor-energy.png'),
(5, 'https://cdn.fight-rpg.com/images/pstree/breack-shield.png'),
(6, 'https://cdn.fight-rpg.com/images/pstree/break-sword.png'),
(7, 'https://cdn.fight-rpg.com/images/pstree/crossed-swords.png'),
(8, 'https://cdn.fight-rpg.com/images/pstree/flag.png'),
(9, 'https://cdn.fight-rpg.com/images/pstree/helmet-eye.png'),
(10, 'https://cdn.fight-rpg.com/images/pstree/multi-swords.png'),
(11, 'https://cdn.fight-rpg.com/images/pstree/punch.png'),
(12, 'https://cdn.fight-rpg.com/images/pstree/running.png'),
(13, 'https://cdn.fight-rpg.com/images/pstree/shield.png'),
(14, 'https://cdn.fight-rpg.com/images/pstree/sword-skull.png'),
(15, 'https://cdn.fight-rpg.com/images/pstree/taunt.png'),
(16, 'https://cdn.fight-rpg.com/images/pstree/tornado.png'),
(17, 'https://cdn.fight-rpg.com/images/pstree/winner-cup.png'),
(18, 'https://cdn.fight-rpg.com/images/pstree/Archer-Arrow-rain.png'),
(19, 'https://cdn.fight-rpg.com/images/pstree/Archer-Charge-shot-2.png'),
(20, 'https://cdn.fight-rpg.com/images/pstree/Archer-Charge-shot-3.png'),
(21, 'https://cdn.fight-rpg.com/images/pstree/Archer-lunge.png'),
(22, 'https://cdn.fight-rpg.com/images/pstree/Flame-Blue.png'),
(23, 'https://cdn.fight-rpg.com/images/pstree/Flame-Green.png'),
(24, 'https://cdn.fight-rpg.com/images/pstree/Flame-Original.png'),
(25, 'https://cdn.fight-rpg.com/images/pstree/Samurai-Anger.png'),
(26, 'https://cdn.fight-rpg.com/images/pstree/Samurai-Flower-vortex.png'),
(27, 'https://cdn.fight-rpg.com/images/pstree/Samurai-Prick.png'),
(28, 'https://cdn.fight-rpg.com/images/pstree/Samurai-Sword-Strike.png'),
(29, 'https://cdn.fight-rpg.com/images/pstree/Archer-a-crack-shot.png'),
(30, 'https://cdn.fight-rpg.com/images/pstree/Archer-a-small-arrow-shot-by-a-archer.png'),
(31, 'https://cdn.fight-rpg.com/images/pstree/Wizard-Dragon-Summon.png'),
(32, 'https://cdn.fight-rpg.com/images/pstree/Wizard-Finale.png'),
(33, 'https://cdn.fight-rpg.com/images/pstree/Wizard-lightning-bolt.png'),
(34, 'https://cdn.fight-rpg.com/images/pstree/Wizard-Spatial-distortion.png'),
(35, 'https://cdn.fight-rpg.com/images/pstree/Wizard-Trick.png'),
(36, 'https://cdn.fight-rpg.com/images/pstree/Thief-Assassination.png'),
(37, 'https://cdn.fight-rpg.com/images/pstree/battle-cry.png'),
(38, 'https://cdn.fight-rpg.com/images/pstree/break-shield2.png'),
(39, 'https://cdn.fight-rpg.com/images/pstree/bullets.png'),
(40, 'https://cdn.fight-rpg.com/images/pstree/dark-orb.png'),
(41, 'https://cdn.fight-rpg.com/images/pstree/dead-hand.png'),
(42, 'https://cdn.fight-rpg.com/images/pstree/eagle-claw.png'),
(43, 'https://cdn.fight-rpg.com/images/pstree/eat.png'),
(44, 'https://cdn.fight-rpg.com/images/pstree/fire-attack.png'),
(45, 'https://cdn.fight-rpg.com/images/pstree/fireball.png'),
(46, 'https://cdn.fight-rpg.com/images/pstree/heal.png'),
(47, 'https://cdn.fight-rpg.com/images/pstree/hide-bush.png'),
(48, 'https://cdn.fight-rpg.com/images/pstree/ice-block.png'),
(49, 'https://cdn.fight-rpg.com/images/pstree/ice-shards.png'),
(50, 'https://cdn.fight-rpg.com/images/pstree/light-ray.png'),
(51, 'https://cdn.fight-rpg.com/images/pstree/lightning-blue.png'),
(52, 'https://cdn.fight-rpg.com/images/pstree/lightning-purple.png'),
(53, 'https://cdn.fight-rpg.com/images/pstree/meteor-blue.png'),
(54, 'https://cdn.fight-rpg.com/images/pstree/shield2.png'),
(55, 'https://cdn.fight-rpg.com/images/pstree/spider.png'),
(56, 'https://cdn.fight-rpg.com/images/pstree/star-purple.png'),
(57, 'https://cdn.fight-rpg.com/images/pstree/target-short.png'),
(58, 'https://cdn.fight-rpg.com/images/pstree/thorns.png'),
(59, 'https://cdn.fight-rpg.com/images/pstree/tornado.png'),
(60, 'https://cdn.fight-rpg.com/images/pstree/venom.png'),
(61, 'https://cdn.fight-rpg.com/images/pstree/world.png'),
(62, 'https://cdn.fight-rpg.com/images/pstree/loosepng.png'),
(63, 'https://cdn.fight-rpg.com/images/pstree/elements.png'),
(64, 'https://cdn.fight-rpg.com/images/pstree/rock-shards.png'),
(65, 'https://cdn.fight-rpg.com/images/pstree/smoke-bomb.png'),
(66, 'https://cdn.fight-rpg.com/images/pstree/venom-bomb.png'),
(67, 'https://cdn.fight-rpg.com/images/pstree/flaming-arrow.png'),
(68, 'https://cdn.fight-rpg.com/images/pstree/stone-arrow.png'),
(69, 'https://cdn.fight-rpg.com/images/pstree/windy-arrow.png'),
(70, 'https://cdn.fight-rpg.com/images/pstree/ice-arrow.png'),
(71, 'https://cdn.fight-rpg.com/images/pstree/cold-blow.png'),
(72, 'https://cdn.fight-rpg.com/images/pstree/windy-blow.png'),
(73, 'https://cdn.fight-rpg.com/images/pstree/eaarthy-blow.png'),
(74, 'https://cdn.fight-rpg.com/images/pstree/heal.png'),
(75, 'https://cdn.fight-rpg.com/images/pstree/punch.png'),
(76, 'https://cdn.fight-rpg.com/images/pstree/shield.png'),
(77, 'https://cdn.fight-rpg.com/images/pstree/xia-pu-.jpg'),
(78, 'https://cdn.fight-rpg.com/images/pstree/le-vuong-togashikazuep.jpg');

-- --------------------------------------------------------

--
-- Structure de la table `rebirthspossibles`
--

CREATE TABLE `rebirthspossibles` (
  `rebirthLevel` int(10) UNSIGNED NOT NULL,
  `nbrOfStatsPointsPerLevel` int(10) UNSIGNED NOT NULL DEFAULT '5',
  `nbrOfTalentPointsBonus` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `percentageBonusToMonstersStats` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `percentageBonusToItemsStats` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `rebirthspossibles`
--

INSERT INTO `rebirthspossibles` (`rebirthLevel`, `nbrOfStatsPointsPerLevel`, `nbrOfTalentPointsBonus`, `percentageBonusToMonstersStats`, `percentageBonusToItemsStats`) VALUES
(0, 5, 0, 0, 0),
(1, 6, 5, 10, 5),
(2, 7, 10, 20, 10),
(3, 8, 15, 30, 15),
(4, 9, 20, 40, 20),
(5, 10, 25, 50, 25);

-- --------------------------------------------------------

--
-- Structure de la table `rebirthspossiblesitemsneeded`
--

CREATE TABLE `rebirthspossiblesitemsneeded` (
  `rebirthLevel` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `number` int(11) NOT NULL DEFAULT '1',
  `minRebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `regions`
--

CREATE TABLE `regions` (
  `idRegion` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `regions`
--

INSERT INTO `regions` (`idRegion`) VALUES
(1),
(2),
(3),
(4),
(5);

-- --------------------------------------------------------

--
-- Structure de la table `regionsbosses`
--

CREATE TABLE `regionsbosses` (
  `idBoss` int(10) UNSIGNED NOT NULL,
  `idRegion` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `regionsbosses`
--

INSERT INTO `regionsbosses` (`idBoss`, `idRegion`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- --------------------------------------------------------

--
-- Structure de la table `requiredsubtypeequipped`
--

CREATE TABLE `requiredsubtypeequipped` (
  `idSousType` int(10) UNSIGNED NOT NULL,
  `idSkill` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `secondarystats`
--

CREATE TABLE `secondarystats` (
  `idSecondaryStat` int(10) UNSIGNED NOT NULL,
  `name` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `desc` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `secondarystats`
--

INSERT INTO `secondarystats` (`idSecondaryStat`, `name`, `desc`) VALUES
(1, 'hitRate', ''),
(2, 'evadeRate', ''),
(3, 'criticalRate', ''),
(4, 'regenHp', ''),
(5, 'regenMp', ''),
(6, 'regenEnergy', ''),
(7, 'skillManaCost', ''),
(8, 'skillEnergyCost', ''),
(9, 'criticalEvadeRate', ''),
(10, 'magicalEvadeRate', ''),
(11, 'threat', ''),
(12, 'initiative', '');

-- --------------------------------------------------------

--
-- Structure de la table `secondarystatselementalresistsrepartition`
--

CREATE TABLE `secondarystatselementalresistsrepartition` (
  `idStatsProfil` int(10) UNSIGNED NOT NULL,
  `idElementType` int(10) UNSIGNED NOT NULL,
  `baseValue` int(11) NOT NULL DEFAULT '0',
  `multPerLevel` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `secondarystatselementalresistsrepartition`
--

INSERT INTO `secondarystatselementalresistsrepartition` (`idStatsProfil`, `idElementType`, `baseValue`, `multPerLevel`) VALUES
(1, 1, 0, 0),
(1, 2, 0, 0),
(1, 3, 0, 0),
(1, 4, 0, 0),
(1, 5, 0, 0),
(1, 6, 0, 0),
(1, 7, 0, 0),
(2, 1, 0, 0),
(2, 2, 50, 0),
(2, 3, -100, 0),
(2, 4, 0, 0),
(2, 5, 0, 0),
(2, 6, 0, 0),
(2, 7, 0, 0),
(3, 1, 0, 0),
(3, 2, 0, 0),
(3, 3, 50, 0),
(3, 4, -100, 0),
(3, 5, 0, 0),
(3, 6, 0, 0),
(3, 7, 0, 0),
(4, 1, 0, 0),
(4, 2, 0, 0),
(4, 3, 0, 0),
(4, 4, 50, 0),
(4, 5, -100, 0),
(4, 6, 0, 0),
(4, 7, 0, 0),
(5, 1, 0, 0),
(5, 2, -100, 0),
(5, 3, 0, 0),
(5, 4, 0, 0),
(5, 5, 50, 0),
(5, 6, 0, 0),
(5, 7, 0, 0),
(6, 1, 0, 0),
(6, 2, 50, 0),
(6, 3, -100, 0),
(6, 4, 0, 0),
(6, 5, 0, 0),
(6, 6, 0, 0),
(6, 7, 0, 0),
(7, 1, 0, 0),
(7, 2, 0, 0),
(7, 3, 50, 0),
(7, 4, -100, 0),
(7, 5, 0, 0),
(7, 6, 0, 0),
(7, 7, 0, 0),
(8, 1, 0, 0),
(8, 2, 0, 0),
(8, 3, 0, 0),
(8, 4, 50, 0),
(8, 5, -100, 0),
(8, 6, 0, 0),
(8, 7, 0, 0),
(9, 1, 0, 0),
(9, 2, -100, 0),
(9, 3, 0, 0),
(9, 4, 0, 0),
(9, 5, 50, 0),
(9, 6, 0, 0),
(9, 7, 0, 0),
(10, 1, 0, 0),
(10, 2, 50, 0),
(10, 3, -100, 0),
(10, 4, 0, 0),
(10, 5, 0, 0),
(10, 6, 0, 0),
(10, 7, 0, 0),
(11, 1, 0, 0),
(11, 2, 0, 0),
(11, 3, 50, 0),
(11, 4, -100, 0),
(11, 5, 0, 0),
(11, 6, 0, 0),
(11, 7, 0, 0),
(12, 1, 0, 0),
(12, 2, 0, 0),
(12, 3, 0, 0),
(12, 4, 50, 0),
(12, 5, -100, 0),
(12, 6, 0, 0),
(12, 7, 0, 0),
(13, 1, 0, 0),
(13, 2, -100, 0),
(13, 3, 0, 0),
(13, 4, 0, 0),
(13, 5, 50, 0),
(13, 6, 0, 0),
(13, 7, 0, 0),
(14, 1, 8, 0),
(14, 2, 20, 0),
(14, 3, 20, 0),
(14, 4, 20, 0),
(14, 5, 20, 0),
(14, 6, 20, 0),
(14, 7, 20, 0),
(15, 1, 8, 0),
(15, 2, 20, 0),
(15, 3, 20, 0),
(15, 4, 20, 0),
(15, 5, 20, 0),
(15, 6, 20, 0),
(15, 7, 20, 0),
(16, 1, 0, 0),
(16, 2, 5, 0),
(16, 3, 5, 0),
(16, 4, 5, 0),
(16, 5, 5, 0),
(16, 6, 5, 0),
(16, 7, 5, 0),
(17, 1, -30, 0),
(17, 2, 10, 0),
(17, 3, 10, 0),
(17, 4, 10, 0),
(17, 5, 10, 0),
(17, 6, 10, 0),
(17, 7, 10, 0),
(18, 1, 10, 0),
(18, 2, 0, 0),
(18, 3, 0, 0),
(18, 4, 0, 0),
(18, 5, 0, 0),
(18, 6, 0, 0),
(18, 7, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `secondarystatsrepartition`
--

CREATE TABLE `secondarystatsrepartition` (
  `idStatsProfil` int(10) UNSIGNED NOT NULL,
  `idSecondaryStat` int(10) UNSIGNED NOT NULL,
  `baseValue` int(11) NOT NULL,
  `multPerLevel` float NOT NULL DEFAULT '0.01'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `secondarystatsrepartition`
--

INSERT INTO `secondarystatsrepartition` (`idStatsProfil`, `idSecondaryStat`, `baseValue`, `multPerLevel`) VALUES
(1, 1, 100, 0),
(1, 2, 0, 0),
(1, 3, 0, 0),
(1, 4, 0, 0),
(1, 5, 0, 0),
(1, 6, 5, 0),
(1, 7, 0, 0),
(1, 8, 0, 0),
(1, 9, 0, 0),
(1, 10, 0, 0),
(1, 11, 0, 0),
(2, 1, 100, 0),
(2, 2, 0, 0),
(2, 3, 0, 0),
(2, 4, 1, 0.1),
(2, 5, 1, 0.1),
(2, 6, 5, 0),
(2, 7, 0, 0),
(2, 8, 0, 0),
(2, 9, 0, 0),
(2, 10, 0, 0),
(2, 11, 0, 0),
(3, 1, 100, 0),
(3, 2, 0, 0),
(3, 3, 0, 0),
(3, 4, 1, 0.1),
(3, 5, 1, 0.1),
(3, 6, 5, 0),
(3, 7, 0, 0),
(3, 8, 0, 0),
(3, 9, 0, 0),
(3, 10, 0, 0),
(3, 11, 0, 0),
(4, 1, 100, 0),
(4, 2, 0, 0),
(4, 3, 0, 0),
(4, 4, 1, 0.1),
(4, 5, 1, 0.1),
(4, 6, 5, 0),
(4, 7, 0, 0),
(4, 8, 0, 0),
(4, 9, 0, 0),
(4, 10, 0, 0),
(4, 11, 0, 0),
(5, 1, 100, 0),
(5, 2, 0, 0),
(5, 3, 0, 0),
(5, 4, 1, 0.1),
(5, 5, 1, 0.1),
(5, 6, 5, 0),
(5, 7, 0, 0),
(5, 8, 0, 0),
(5, 9, 0, 0),
(5, 10, 0, 0),
(5, 11, 0, 0),
(6, 1, 100, 0),
(6, 2, 0, 0),
(6, 3, 0, 0),
(6, 4, 0, 0),
(6, 5, 1, 0.1),
(6, 6, 5, 0),
(6, 7, 0, 0),
(6, 8, 0, 0),
(6, 9, 0, 0),
(6, 10, 5, 0),
(6, 11, 0, 0),
(7, 1, 100, 0),
(7, 2, 0, 0),
(7, 3, 0, 0),
(7, 4, 0, 0),
(7, 5, 1, 0.1),
(7, 6, 5, 0),
(7, 7, 0, 0),
(7, 8, 0, 0),
(7, 9, 0, 0),
(7, 10, 5, 0),
(7, 11, 0, 0),
(8, 1, 100, 0),
(8, 2, 0, 0),
(8, 3, 0, 0),
(8, 4, 0, 0),
(8, 5, 1, 0.1),
(8, 6, 5, 0),
(8, 7, 0, 0),
(8, 8, 0, 0),
(8, 9, 0, 0),
(8, 10, 5, 0),
(8, 11, 0, 0),
(9, 1, 100, 0),
(9, 2, 0, 0),
(9, 3, 0, 0),
(9, 4, 0, 0),
(9, 5, 1, 0.1),
(9, 6, 5, 0),
(9, 7, 0, 0),
(9, 8, 0, 0),
(9, 9, 0, 0),
(9, 10, 5, 0),
(9, 11, 0, 0),
(10, 1, 100, 0),
(10, 2, 30, 0),
(10, 3, 30, 0),
(10, 4, 0, 0),
(10, 5, 5, 0.05),
(10, 6, 15, 0),
(10, 7, 0, 0),
(10, 8, 0, 0),
(10, 9, 15, 0),
(10, 10, 0, 0),
(10, 11, 0, 0),
(11, 1, 100, 0),
(11, 2, 30, 0),
(11, 3, 30, 0),
(11, 4, 0, 0),
(11, 5, 5, 0.05),
(11, 6, 15, 0),
(11, 7, 0, 0),
(11, 8, 0, 0),
(11, 9, 15, 0),
(11, 10, 0, 0),
(11, 11, 0, 0),
(12, 1, 100, 0),
(12, 2, 30, 0),
(12, 3, 30, 0),
(12, 4, 0, 0),
(12, 5, 5, 0.05),
(12, 6, 15, 0),
(12, 7, 0, 0),
(12, 8, 0, 0),
(12, 9, 15, 0),
(12, 10, 0, 0),
(12, 11, 0, 0),
(13, 1, 100, 0),
(13, 2, 30, 0),
(13, 3, 30, 0),
(13, 4, 0, 0),
(13, 5, 5, 0.05),
(13, 6, 15, 0),
(13, 7, 0, 0),
(13, 8, 0, 0),
(13, 9, 15, 0),
(13, 10, 0, 0),
(13, 11, 0, 0),
(14, 1, 100, 0),
(14, 2, 0, 0),
(14, 3, 0, 0),
(14, 4, 0, 0),
(14, 5, 0, 0),
(14, 6, 5, 0),
(14, 7, 0, 0),
(14, 8, 0, 0),
(14, 9, 0, 0),
(14, 10, 0, 0),
(14, 11, 7, 0),
(15, 1, 100, 0),
(15, 2, 0, 0),
(15, 3, 0, 0),
(15, 4, 0, 0),
(15, 5, 0, 0),
(15, 6, 5, 0),
(15, 7, 0, 0),
(15, 8, 0, 0),
(15, 9, 0, 0),
(15, 10, 0, 0),
(15, 11, 7, 0),
(16, 1, 100, 0),
(16, 2, 0, 0),
(16, 3, 0, 0),
(16, 4, 1, 0.2),
(16, 5, 1, 0.2),
(16, 6, 5, 0),
(16, 7, 0, 0),
(16, 8, 0, 0),
(16, 9, 0, 0),
(16, 10, 0, 0),
(16, 11, 7, 0),
(17, 1, 100, 0),
(17, 2, 0, 0),
(17, 3, 0, 0),
(17, 4, 0, 0),
(17, 5, 3, 0.2),
(17, 6, 5, 0),
(17, 7, 5, 0),
(17, 8, 0, 0),
(17, 9, 0, 0),
(17, 10, 10, 0),
(17, 11, 0, 0),
(18, 1, 110, 0),
(18, 2, 10, 0),
(18, 3, 20, 0),
(18, 4, 0, 0),
(18, 5, 0, 0),
(18, 6, 10, 0),
(18, 7, 0, 0),
(18, 8, 5, 0),
(18, 9, 5, 0),
(18, 10, 0, 0),
(18, 11, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `sellableitems`
--

CREATE TABLE `sellableitems` (
  `idSellableItems` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `level` int(11) NOT NULL DEFAULT '1',
  `number` int(11) NOT NULL DEFAULT '1',
  `price` int(11) NOT NULL DEFAULT '1',
  `rebirthLevel` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `sellableitems`
--

INSERT INTO `sellableitems` (`idSellableItems`, `idBaseItem`, `level`, `number`, `price`, `rebirthLevel`) VALUES
(1, 43, 10, 1, 65, 0),
(2, 43, 20, 1, 130, 0),
(3, 43, 30, 1, 195, 0),
(4, 43, 40, 1, 260, 0),
(5, 43, 50, 1, 320, 0),
(6, 43, 60, 1, 385, 0),
(7, 43, 70, 1, 450, 0),
(8, 43, 80, 1, 510, 0),
(9, 44, 10, 1, 85, 0),
(10, 44, 20, 1, 170, 0),
(11, 44, 30, 1, 260, 0),
(12, 44, 40, 1, 345, 0),
(13, 44, 50, 1, 425, 0),
(14, 44, 60, 1, 510, 0),
(15, 44, 70, 1, 600, 0),
(16, 44, 80, 1, 680, 0),
(17, 36, 1, 1, 3000, 0),
(18, 37, 1, 1, 15000, 0),
(19, 36, 1, 1, 3000, 0),
(20, 37, 1, 1, 15000, 0),
(21, 43, 90, 1, 580, 0),
(22, 43, 100, 1, 650, 0),
(23, 44, 90, 1, 800, 0),
(24, 44, 100, 1, 1000, 0);

-- --------------------------------------------------------

--
-- Structure de la table `serversstats`
--

CREATE TABLE `serversstats` (
  `idServer` varchar(21) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `serverPrefix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serverName` varchar(101) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `memberCount` int(11) NOT NULL DEFAULT '0',
  `region` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `shop`
--

CREATE TABLE `shop` (
  `idShop` int(10) UNSIGNED NOT NULL,
  `tax` float UNSIGNED NOT NULL DEFAULT '0.05',
  `active` tinyint(3) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `shop`
--

INSERT INTO `shop` (`idShop`, `tax`, `active`) VALUES
(1, 0.05, 1),
(2, 0.05, 1),
(3, 0.05, 1),
(4, 0.05, 1),
(5, 0.05, 1),
(6, 0.05, 1),
(7, 0.05, 1),
(8, 0.05, 1),
(9, 0.05, 1);

-- --------------------------------------------------------

--
-- Structure de la table `shopitems`
--

CREATE TABLE `shopitems` (
  `idShop` int(10) UNSIGNED NOT NULL,
  `idSellableItems` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `shopitems`
--

INSERT INTO `shopitems` (`idShop`, `idSellableItems`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `skills`
--

CREATE TABLE `skills` (
  `idSkill` int(10) UNSIGNED NOT NULL,
  `shorthand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idSkillType` int(10) UNSIGNED DEFAULT NULL,
  `energyCost` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `manaCost` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `idTargetRange` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `skills`
--

INSERT INTO `skills` (`idSkill`, `shorthand`, `idSkillType`, `energyCost`, `manaCost`, `idTargetRange`) VALUES
(1, 'melee_attack', NULL, 0, 0, 2),
(2, 'distant_attack', NULL, 0, 0, 2),
(3, 'magic_bolt', 1, 0, 0, 2),
(4, 'flaming_blow', NULL, 30, 0, 2),
(5, 'cold_blow', NULL, 30, 0, 2),
(6, 'earthy_blow', NULL, 30, 0, 2),
(7, 'windy_blow', NULL, 30, 0, 2),
(8, 'flaming_arrow', NULL, 50, 10, 2),
(9, 'ice_arrow', NULL, 50, 10, 2),
(10, 'stone_arrow', NULL, 50, 10, 2),
(11, 'windy_arrow', NULL, 50, 10, 2),
(12, 'fireball', 1, 0, 80, 2),
(13, 'ice_shards', 1, 0, 80, 2),
(14, 'rock_shards', 1, 0, 80, 2),
(15, 'focused_tornado', 1, 0, 80, 2),
(16, 'venom', NULL, 20, 20, 2),
(17, 'toxic_bomb', NULL, 20, 20, 4),
(18, 'taunt', 2, 20, 0, 14),
(19, 'self_regen boost', 1, 0, 35, 14),
(20, 'group_regen boost', 1, 0, 75, 9),
(21, 'self_heal', 1, 0, 50, 14),
(22, 'heal', 1, 0, 75, 6),
(23, 'group_heal', 1, 0, 110, 9),
(24, 'resurrect', 1, 0, 95, 10),
(25, 'smoke_bomb', NULL, 20, 20, 4),
(26, 'deceit', 1, 20, 0, 14),
(27, 'defend', 2, 20, 0, 14),
(28, 'enrage', 2, 0, 0, 14),
(29, 'animal_bite', NULL, 20, 0, 2),
(30, 'poisonous_bite', NULL, 20, 0, 2),
(31, 'charge', NULL, 20, 0, 2),
(32, 'smash_attack', NULL, 22, 0, 2),
(33, 'aimed_shot', NULL, 40, 10, 2),
(34, 'arcane_shards', 1, 0, 95, 2);

-- --------------------------------------------------------

--
-- Structure de la table `skillstypes`
--

CREATE TABLE `skillstypes` (
  `idSkillType` int(10) UNSIGNED NOT NULL,
  `shorthand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `skillstypes`
--

INSERT INTO `skillstypes` (`idSkillType`, `shorthand`) VALUES
(1, 'magic'),
(2, 'special');

-- --------------------------------------------------------

--
-- Structure de la table `spawnedbosses`
--

CREATE TABLE `spawnedbosses` (
  `idSpawnedBoss` int(10) UNSIGNED NOT NULL,
  `actualHp` bigint(19) UNSIGNED NOT NULL DEFAULT '100',
  `maxHp` bigint(19) UNSIGNED NOT NULL DEFAULT '100',
  `idBoss` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `spawnedbossesareas`
--

CREATE TABLE `spawnedbossesareas` (
  `idSpawnedBoss` int(10) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `states`
--

CREATE TABLE `states` (
  `idState` int(10) UNSIGNED NOT NULL,
  `idStateRestriction` int(10) UNSIGNED DEFAULT NULL,
  `shorthand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `states`
--

INSERT INTO `states` (`idState`, `idStateRestriction`, `shorthand`) VALUES
(1, 4, 'stun'),
(2, NULL, 'defense'),
(3, NULL, 'regeneration'),
(4, NULL, 'poison'),
(5, NULL, 'blind'),
(6, NULL, 'provoke'),
(7, 1, 'hide'),
(8, NULL, 'heal_resistant'),
(9, NULL, 'enraged'),
(10, NULL, 'bleed'),
(11, NULL, 'burn'),
(12, 4, 'freeze');

-- --------------------------------------------------------

--
-- Structure de la table `statesremovalconditions`
--

CREATE TABLE `statesremovalconditions` (
  `idState` int(10) UNSIGNED NOT NULL,
  `afterFight` tinyint(4) NOT NULL DEFAULT '0',
  `afterRounds` tinyint(4) NOT NULL DEFAULT '0',
  `roundMin` int(11) NOT NULL DEFAULT '0',
  `roundMax` int(11) NOT NULL DEFAULT '0',
  `afterDamage` tinyint(4) NOT NULL DEFAULT '0',
  `damageProbability` float NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `statesremovalconditions`
--

INSERT INTO `statesremovalconditions` (`idState`, `afterFight`, `afterRounds`, `roundMin`, `roundMax`, `afterDamage`, `damageProbability`) VALUES
(1, 1, 1, 1, 1, 0, 100),
(2, 1, 1, 3, 4, 0, 100),
(3, 1, 1, 3, 3, 0, 100),
(4, 1, 1, 1, 3, 0, 100),
(5, 1, 1, 1, 2, 0, 100),
(6, 1, 1, 3, 4, 0, 100),
(7, 1, 1, 2, 4, 0, 50),
(8, 1, 1, 1, 1, 0, 20),
(9, 1, 1, 2, 3, 0, 50),
(10, 1, 1, 2, 2, 0, 100),
(11, 1, 1, 2, 2, 0, 100),
(12, 1, 1, 1, 3, 0, 25);

-- --------------------------------------------------------

--
-- Structure de la table `statesrestrictions`
--

CREATE TABLE `statesrestrictions` (
  `idStateRestriction` int(10) UNSIGNED NOT NULL,
  `shorhand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `statesrestrictions`
--

INSERT INTO `statesrestrictions` (`idStateRestriction`, `shorhand`) VALUES
(1, 'cant_target_enemy'),
(2, 'cant_target_ally'),
(3, 'cant_target_self'),
(4, 'cant_target_do_anything');

-- --------------------------------------------------------

--
-- Structure de la table `statestraits`
--

CREATE TABLE `statestraits` (
  `idState` int(10) UNSIGNED NOT NULL,
  `idTrait` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `statestraits`
--

INSERT INTO `statestraits` (`idState`, `idTrait`) VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 4),
(3, 5),
(3, 6),
(4, 7),
(5, 8),
(5, 9),
(6, 10),
(7, 11),
(8, 12),
(9, 13),
(9, 14),
(9, 15),
(9, 16),
(10, 17),
(10, 18),
(11, 19),
(11, 20),
(12, 21);

-- --------------------------------------------------------

--
-- Structure de la table `statisticsbases`
--

CREATE TABLE `statisticsbases` (
  `idStatisticBase` int(10) UNSIGNED NOT NULL,
  `name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `statisticsbases`
--

INSERT INTO `statisticsbases` (`idStatisticBase`, `name`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `stats`
--

CREATE TABLE `stats` (
  `idStat` int(10) UNSIGNED NOT NULL,
  `nom` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `stats`
--

INSERT INTO `stats` (`idStat`, `nom`, `desc`) VALUES
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

-- --------------------------------------------------------

--
-- Structure de la table `statscharacters`
--

CREATE TABLE `statscharacters` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `value` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `statsmonstres`
--

CREATE TABLE `statsmonstres` (
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `idStatsProfil` int(10) UNSIGNED NOT NULL,
  `idMonstersBuildsProfil` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `statsmonstres`
--

INSERT INTO `statsmonstres` (`idMonstre`, `idStatsProfil`, `idMonstersBuildsProfil`) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 5),
(4, 1, 5),
(5, 1, 1),
(6, 1, 8),
(7, 16, 8),
(8, 16, 6),
(9, 16, 7),
(10, 16, 9),
(11, 16, 9),
(12, 16, 3),
(13, 16, 5),
(14, 15, 1),
(15, 14, 1),
(16, 18, 11),
(17, 16, 1),
(18, 18, 11),
(19, 16, 10),
(20, 16, 5),
(21, 15, 5),
(22, 14, 1),
(23, 14, 1),
(24, 15, 10),
(25, 15, 1),
(26, 15, 1),
(27, 2, 2),
(28, 10, 4),
(29, 2, 6),
(30, 2, 6),
(31, 4, 2),
(32, 12, 4),
(33, 14, 2),
(34, 8, 3),
(35, 15, 10),
(36, 15, 1),
(37, 15, 1),
(38, 4, 8),
(39, 4, 8),
(40, 14, 1),
(41, 15, 1),
(42, 14, 1),
(43, 18, 13),
(44, 18, 13),
(45, 15, 1),
(46, 16, 1),
(47, 15, 1),
(48, 16, 1),
(49, 4, 8),
(50, 4, 8),
(51, 4, 8),
(52, 15, 10),
(53, 16, 2),
(54, 16, 2),
(55, 15, 10),
(56, 2, 6),
(57, 6, 14),
(58, 6, 14),
(59, 6, 14),
(60, 9, 17),
(61, 5, 9),
(62, 16, 6),
(63, 15, 6),
(64, 15, 6),
(65, 15, 2),
(66, 18, 4),
(67, 17, 3),
(68, 15, 7),
(69, 14, 10),
(70, 14, 6),
(71, 15, 2),
(72, 18, 4),
(73, 17, 3),
(74, 16, 2),
(75, 15, 2),
(76, 18, 4),
(77, 17, 3),
(78, 15, 5),
(79, 14, 10),
(80, 3, 7),
(81, 7, 15);

-- --------------------------------------------------------

--
-- Structure de la table `statsprofil`
--

CREATE TABLE `statsprofil` (
  `idStatsProfil` int(10) UNSIGNED NOT NULL,
  `name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `statsprofil`
--

INSERT INTO `statsprofil` (`idStatsProfil`, `name`) VALUES
(1, 'balance_low'),
(2, 'elemental_strength_fire'),
(3, 'elemental_strength_water'),
(4, 'elemental_strength_earth'),
(5, 'elemental_strength_wind'),
(6, 'elemental_magical_fire'),
(7, 'elemental_magical_water'),
(8, 'elemental_magical_earth'),
(9, 'elemental_magical_wind'),
(10, 'elemental_dexterity_fire'),
(11, 'elemental_dexterity_water'),
(12, 'elemental_dexterity_earth'),
(13, 'elemental_dexterity_wind'),
(14, 'tank_strength'),
(15, 'tank_stun'),
(16, 'balance'),
(17, 'mage_healer_intellect'),
(18, 'dexterity');

-- --------------------------------------------------------

--
-- Structure de la table `statsrepartition`
--

CREATE TABLE `statsrepartition` (
  `idStatsProfil` int(10) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `percentage` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `statsrepartition`
--

INSERT INTO `statsrepartition` (`idStatsProfil`, `idStat`, `percentage`) VALUES
(1, 1, 5),
(1, 2, 0),
(1, 3, 5),
(1, 4, 10),
(1, 5, 0),
(1, 6, 0),
(1, 7, 0),
(1, 8, 0),
(1, 9, 0),
(1, 10, 0),
(2, 1, 60),
(2, 2, 0),
(2, 3, 40),
(2, 4, 40),
(2, 5, 0),
(2, 6, 30),
(2, 7, 0),
(2, 8, 0),
(2, 9, 0),
(2, 10, 0),
(3, 1, 60),
(3, 2, 0),
(3, 3, 40),
(3, 4, 40),
(3, 5, 0),
(3, 6, 30),
(3, 7, 0),
(3, 8, 0),
(3, 9, 0),
(3, 10, 0),
(4, 1, 60),
(4, 2, 0),
(4, 3, 40),
(4, 4, 40),
(4, 5, 0),
(4, 6, 30),
(4, 7, 0),
(4, 8, 0),
(4, 9, 0),
(4, 10, 0),
(5, 1, 60),
(5, 2, 0),
(5, 3, 40),
(5, 4, 40),
(5, 5, 0),
(5, 6, 30),
(5, 7, 0),
(5, 8, 0),
(5, 9, 0),
(5, 10, 0),
(6, 1, 0),
(6, 2, 60),
(6, 3, 40),
(6, 4, 40),
(6, 5, 0),
(6, 6, 60),
(6, 7, 0),
(6, 8, 0),
(6, 9, 0),
(6, 10, 0),
(7, 1, 0),
(7, 2, 60),
(7, 3, 40),
(7, 4, 40),
(7, 5, 0),
(7, 6, 60),
(7, 7, 0),
(7, 8, 0),
(7, 9, 0),
(7, 10, 0),
(8, 1, 0),
(8, 2, 60),
(8, 3, 40),
(8, 4, 40),
(8, 5, 0),
(8, 6, 60),
(8, 7, 0),
(8, 8, 0),
(8, 9, 0),
(8, 10, 0),
(9, 1, 0),
(9, 2, 60),
(9, 3, 40),
(9, 4, 40),
(9, 5, 0),
(9, 6, 60),
(9, 7, 0),
(9, 8, 0),
(9, 9, 0),
(9, 10, 0),
(10, 1, 25),
(10, 2, 0),
(10, 3, 40),
(10, 4, 40),
(10, 5, 50),
(10, 6, 40),
(10, 7, 0),
(10, 8, 10),
(10, 9, 0),
(10, 10, 10),
(11, 1, 25),
(11, 2, 0),
(11, 3, 40),
(11, 4, 40),
(11, 5, 50),
(11, 6, 40),
(11, 7, 0),
(11, 8, 10),
(11, 9, 0),
(11, 10, 10),
(12, 1, 25),
(12, 2, 0),
(12, 3, 40),
(12, 4, 40),
(12, 5, 50),
(12, 6, 40),
(12, 7, 0),
(12, 8, 10),
(12, 9, 0),
(12, 10, 10),
(13, 1, 25),
(13, 2, 0),
(13, 3, 40),
(13, 4, 40),
(13, 5, 50),
(13, 6, 40),
(13, 7, 0),
(13, 8, 10),
(13, 9, 0),
(13, 10, 10),
(14, 1, 55),
(14, 2, 0),
(14, 3, 60),
(14, 4, 60),
(14, 5, 0),
(14, 6, 0),
(14, 7, 0),
(14, 8, 0),
(14, 9, 0),
(14, 10, 5),
(15, 1, 40),
(15, 2, 0),
(15, 3, 60),
(15, 4, 60),
(15, 5, 0),
(15, 6, 0),
(15, 7, 30),
(15, 8, 0),
(15, 9, 50),
(15, 10, 5),
(16, 1, 40),
(16, 2, 40),
(16, 3, 40),
(16, 4, 40),
(16, 5, 40),
(16, 6, 40),
(16, 7, 40),
(16, 8, 40),
(16, 9, 40),
(16, 10, 40),
(17, 1, 0),
(17, 2, 60),
(17, 3, 35),
(17, 4, 30),
(17, 5, 0),
(17, 6, 50),
(17, 7, 0),
(17, 8, 0),
(17, 9, 0),
(17, 10, 5),
(18, 1, 15),
(18, 2, 0),
(18, 3, 40),
(18, 4, 40),
(18, 5, 45),
(18, 6, 20),
(18, 7, 0),
(18, 8, 10),
(18, 9, 0),
(18, 10, 10);

-- --------------------------------------------------------

--
-- Structure de la table `targetrange`
--

CREATE TABLE `targetrange` (
  `idTargetRange` int(11) NOT NULL,
  `shothand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `targetrange`
--

INSERT INTO `targetrange` (`idTargetRange`, `shothand`) VALUES
(1, 'all_enemies'),
(2, '1_random_enemy'),
(3, '2_random_enemy'),
(4, '3_random_enemy'),
(5, '4_random_enemy'),
(6, '1_random_ally'),
(7, '2_random_ally'),
(8, '3_random_ally'),
(9, 'all_allies'),
(10, '1_random_ally_dead'),
(11, '3_random_ally_dead'),
(12, '3_random_ally_dead'),
(13, 'all_allies_dead'),
(14, 'caster');

-- --------------------------------------------------------

--
-- Structure de la table `traits`
--

CREATE TABLE `traits` (
  `idTrait` int(10) UNSIGNED NOT NULL,
  `idTraitType` int(10) UNSIGNED NOT NULL,
  `valueFloat` float DEFAULT '0',
  `valueState` int(10) UNSIGNED DEFAULT NULL,
  `valueElementType` int(10) UNSIGNED DEFAULT NULL,
  `valueSkillType` int(10) UNSIGNED DEFAULT NULL,
  `valueStat` int(10) UNSIGNED DEFAULT NULL,
  `valueSkill` int(10) UNSIGNED DEFAULT NULL,
  `valueSecondaryStat` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `traits`
--

INSERT INTO `traits` (`idTrait`, `idTraitType`, `valueFloat`, `valueState`, `valueElementType`, `valueSkillType`, `valueStat`, `valueSkill`, `valueSecondaryStat`) VALUES
(1, 9, -1, NULL, NULL, NULL, NULL, NULL, 2),
(2, 3, 1.25, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 3, 1.25, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 9, 0.1, NULL, NULL, NULL, NULL, NULL, 4),
(5, 9, 0.1, NULL, NULL, NULL, NULL, NULL, 5),
(6, 9, 0.1, NULL, NULL, NULL, NULL, NULL, 6),
(7, 9, -0.1, NULL, NULL, NULL, NULL, NULL, 4),
(8, 9, -0.5, NULL, NULL, NULL, NULL, NULL, 1),
(9, 9, -0.5, NULL, NULL, NULL, NULL, NULL, 2),
(10, 9, 2, NULL, NULL, NULL, NULL, NULL, 11),
(11, 9, 0, NULL, NULL, NULL, NULL, NULL, 11),
(12, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 3, 2, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 3, 2, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 3, 0.7, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 3, 0.7, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 9, -0.1, NULL, NULL, NULL, NULL, NULL, 4),
(18, 9, -0.2, NULL, NULL, NULL, NULL, NULL, 1),
(19, 9, -0.1, NULL, NULL, NULL, NULL, NULL, 4),
(20, 4, 1.5, NULL, 5, NULL, NULL, NULL, NULL),
(21, 9, -1, NULL, NULL, NULL, NULL, NULL, 2);

-- --------------------------------------------------------

--
-- Structure de la table `traitstypes`
--

CREATE TABLE `traitstypes` (
  `idTraitType` int(10) UNSIGNED NOT NULL,
  `typeShorthand` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `traitstypes`
--

INSERT INTO `traitstypes` (`idTraitType`, `typeShorthand`) VALUES
(1, 'element_attack'),
(4, 'element_rate'),
(8, 'quiet_skill'),
(10, 'quiet_specific_skill'),
(11, 'secondary_stats'),
(9, 'secondary_stats_debuff'),
(2, 'state_attack'),
(6, 'state_debuff'),
(7, 'state_resist'),
(5, 'stats_debuff'),
(3, 'stats_param');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `idUser` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `userName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isConnected` tinyint(3) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `userspreferences`
--

CREATE TABLE `userspreferences` (
  `idUser` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `groupmute` tinyint(4) NOT NULL DEFAULT '0',
  `lang` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `marketplacemute` tinyint(4) NOT NULL DEFAULT '0',
  `fightmute` tinyint(4) NOT NULL DEFAULT '0',
  `trademute` tinyint(4) NOT NULL DEFAULT '0',
  `worldbossmute` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `wbrewardstates`
--

CREATE TABLE `wbrewardstates` (
  `idSpawnedBoss` int(10) UNSIGNED NOT NULL,
  `state` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `weathers`
--

CREATE TABLE `weathers` (
  `idWeather` int(10) UNSIGNED NOT NULL,
  `shorthand` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'none',
  `travelSpeed` int(10) UNSIGNED NOT NULL DEFAULT '100',
  `collectSpeed` int(10) UNSIGNED NOT NULL DEFAULT '100',
  `collectChances` int(10) UNSIGNED NOT NULL DEFAULT '100'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `weathers`
--

INSERT INTO `weathers` (`idWeather`, `shorthand`, `travelSpeed`, `collectSpeed`, `collectChances`) VALUES
(1, 'sunny', 100, 100, 100),
(2, 'cloudy', 100, 90, 100),
(3, 'foggy', 75, 75, 75),
(4, 'rainy', 85, 85, 100),
(5, 'rainstorm', 60, 80, 100),
(6, 'snowy', 70, 85, 100),
(7, 'firestorm', 25, 5, 150),
(8, 'sandstorm', 30, 25, 70),
(9, 'snowstorm', 30, 70, 25);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `achievement`
--
ALTER TABLE `achievement`
  ADD PRIMARY KEY (`idAchievement`),
  ADD UNIQUE KEY `idAchievement_UNIQUE` (`idAchievement`),
  ADD UNIQUE KEY `name_identifier_UNIQUE` (`name_identifier`);

--
-- Index pour la table `appearances`
--
ALTER TABLE `appearances`
  ADD PRIMARY KEY (`idAppearance`),
  ADD UNIQUE KEY `idAppearance_UNIQUE` (`idAppearance`),
  ADD KEY `fk_Appearances_BodyType1_idx` (`idBodyType`),
  ADD KEY `fk_Appearances_AppearancesType1_idx` (`idAppearanceType`);

--
-- Index pour la table `appearancestype`
--
ALTER TABLE `appearancestype`
  ADD PRIMARY KEY (`idAppearanceType`),
  ADD UNIQUE KEY `idAppearanceType_UNIQUE` (`idAppearanceType`);

--
-- Index pour la table `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`idArea`),
  ADD UNIQUE KEY `idArea_UNIQUE` (`idArea`),
  ADD KEY `fk_Areas_AreasTypes1_idx` (`idAreaType`),
  ADD KEY `fk_Areas_AreasLevels1_idx` (`AreaLevel`);

--
-- Index pour la table `areasbonuses`
--
ALTER TABLE `areasbonuses`
  ADD PRIMARY KEY (`idArea`,`idBonusTypes`),
  ADD KEY `fk_AreasBonuses_BonusTypes1_idx` (`idBonusTypes`);

--
-- Index pour la table `areasclimates`
--
ALTER TABLE `areasclimates`
  ADD PRIMARY KEY (`idArea`),
  ADD UNIQUE KEY `Areas_idArea_UNIQUE` (`idArea`),
  ADD KEY `fk_AreasClimates_Climates1_idx` (`idClimate`),
  ADD KEY `fk_AreasClimates_Weathers1_idx` (`currentWeather`);

--
-- Index pour la table `areasitems`
--
ALTER TABLE `areasitems`
  ADD PRIMARY KEY (`idArea`,`idBaseItem`),
  ADD KEY `fk_AreasItems_ItemsBase1_idx` (`idBaseItem`);

--
-- Index pour la table `areaslevels`
--
ALTER TABLE `areaslevels`
  ADD PRIMARY KEY (`idAreaLevel`),
  ADD UNIQUE KEY `idAreaLevel_UNIQUE` (`idAreaLevel`);

--
-- Index pour la table `areasmonsters`
--
ALTER TABLE `areasmonsters`
  ADD PRIMARY KEY (`idArea`,`idMonstresGroupe`),
  ADD KEY `fk_AreasMonsters_MonstresGroupes1_idx` (`idMonstresGroupe`);

--
-- Index pour la table `areasmonsterslevels`
--
ALTER TABLE `areasmonsterslevels`
  ADD PRIMARY KEY (`idArea`),
  ADD KEY `fk_AreasMonstersLevels_RebirthsPossibles1_idx` (`minRebirthLevel`),
  ADD KEY `fk_AreasMonstersLevels_RebirthsPossibles2_idx` (`maxRebirthLevel`);

--
-- Index pour la table `areasowners`
--
ALTER TABLE `areasowners`
  ADD PRIMARY KEY (`idArea`,`idGuild`),
  ADD KEY `fk_AreasOwners_Guilds1_idx` (`idGuild`);

--
-- Index pour la table `areaspaths`
--
ALTER TABLE `areaspaths`
  ADD PRIMARY KEY (`idArea1`,`idArea2`),
  ADD KEY `fk_AreasPaths_Areas2_idx` (`idArea2`);

--
-- Index pour la table `areasregions`
--
ALTER TABLE `areasregions`
  ADD PRIMARY KEY (`idArea`),
  ADD KEY `fk_AreasRegions_Regions1_idx` (`idRegion`);

--
-- Index pour la table `areasrequirements`
--
ALTER TABLE `areasrequirements`
  ADD PRIMARY KEY (`idArea`,`idAchievement`),
  ADD KEY `fk_AreasRequirements_Achievement1_idx` (`idAchievement`);

--
-- Index pour la table `areasresources`
--
ALTER TABLE `areasresources`
  ADD PRIMARY KEY (`idArea`,`idCollectableResource`),
  ADD KEY `fk_AreasResources_CollectableResources1_idx` (`idCollectableResource`);

--
-- Index pour la table `areasshops`
--
ALTER TABLE `areasshops`
  ADD PRIMARY KEY (`idArea`,`idShop`),
  ADD KEY `fk_AreasShops_Shop1_idx` (`idShop`);

--
-- Index pour la table `areastypes`
--
ALTER TABLE `areastypes`
  ADD PRIMARY KEY (`idAreaType`),
  ADD UNIQUE KEY `idAreaType_UNIQUE` (`idAreaType`);

--
-- Index pour la table `attackstypes`
--
ALTER TABLE `attackstypes`
  ADD PRIMARY KEY (`idAttackType`),
  ADD UNIQUE KEY `idAttackType_UNIQUE` (`idAttackType`);

--
-- Index pour la table `bodytype`
--
ALTER TABLE `bodytype`
  ADD PRIMARY KEY (`idBodyType`),
  ADD UNIQUE KEY `idBodyType_UNIQUE` (`idBodyType`);

--
-- Index pour la table `bonustypes`
--
ALTER TABLE `bonustypes`
  ADD PRIMARY KEY (`idBonusTypes`),
  ADD UNIQUE KEY `idbonusTypes_UNIQUE` (`idBonusTypes`);

--
-- Index pour la table `bosses`
--
ALTER TABLE `bosses`
  ADD PRIMARY KEY (`idBoss`);

--
-- Index pour la table `bossspawninfo`
--
ALTER TABLE `bossspawninfo`
  ADD PRIMARY KEY (`idBoss`),
  ADD KEY `fk_BossSpawnInfo_Areas1_idx` (`idArea`),
  ADD KEY `fk_BossSpawnInfo_SpawnedBosses1_idx` (`idSpawnedBoss`);

--
-- Index pour la table `castinfo`
--
ALTER TABLE `castinfo`
  ADD PRIMARY KEY (`idSkill`),
  ADD KEY `fk_CastInfo_AttacksTypes1_idx` (`idAttackType`);

--
-- Index pour la table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`idCharacter`),
  ADD UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`),
  ADD KEY `fk_Characters_Areas1_idx` (`idArea`);

--
-- Index pour la table `charactersachievements`
--
ALTER TABLE `charactersachievements`
  ADD PRIMARY KEY (`idCharacter`,`idAchievement`),
  ADD KEY `fk_CharactersAchievements_Achievement1_idx` (`idAchievement`);

--
-- Index pour la table `charactersappearance`
--
ALTER TABLE `charactersappearance`
  ADD PRIMARY KEY (`idCharacter`),
  ADD KEY `fk_CharacterAppearance_BodyType1_idx` (`idBodyType`);

--
-- Index pour la table `charactersappearanceparts`
--
ALTER TABLE `charactersappearanceparts`
  ADD PRIMARY KEY (`idCharacter`,`idAppearance`),
  ADD KEY `fk_CharactersAppearanceParts_Appearances1_idx` (`idAppearance`);

--
-- Index pour la table `charactersattacks`
--
ALTER TABLE `charactersattacks`
  ADD PRIMARY KEY (`idCharacter`,`idSpawnedBoss`),
  ADD KEY `fk_CharactersAttacks_SpawnedBosses1_idx` (`idSpawnedBoss`);

--
-- Index pour la table `charactersbuilds`
--
ALTER TABLE `charactersbuilds`
  ADD PRIMARY KEY (`idCharacter`,`idSkill`),
  ADD KEY `fk_CharactersBuilds_Skills1_idx` (`idSkill`);

--
-- Index pour la table `characterscraftlevel`
--
ALTER TABLE `characterscraftlevel`
  ADD PRIMARY KEY (`idCharacter`),
  ADD KEY `fk_CharactersCraftLevel_LevelsRequire1_idx` (`actualLevel`),
  ADD KEY `fk_CharactersCraftLevel_RebirthsPossibles1_idx` (`rebirthLevel`);

--
-- Index pour la table `charactersequipements`
--
ALTER TABLE `charactersequipements`
  ADD PRIMARY KEY (`idCharacter`,`idItem`,`idType`),
  ADD UNIQUE KEY `idItem_UNIQUE` (`idItem`),
  ADD KEY `fk_CharactersEquipements_Items1_idx` (`idItem`),
  ADD KEY `fk_CharactersEquipements_ItemsTypes1_idx` (`idType`);

--
-- Index pour la table `charactershonor`
--
ALTER TABLE `charactershonor`
  ADD PRIMARY KEY (`idCharacter`);

--
-- Index pour la table `charactersinventory`
--
ALTER TABLE `charactersinventory`
  ADD PRIMARY KEY (`idCharacter`,`idItem`),
  ADD UNIQUE KEY `idItem_UNIQUE` (`idItem`),
  ADD KEY `fk_CharactersInventory_Items1_idx` (`idItem`);

--
-- Index pour la table `charactersstatistics`
--
ALTER TABLE `charactersstatistics`
  ADD PRIMARY KEY (`idStatisticBase`,`idCharacter`),
  ADD KEY `fk_CharactersStatistics_Characters1_idx` (`idCharacter`);

--
-- Index pour la table `characterstalents`
--
ALTER TABLE `characterstalents`
  ADD PRIMARY KEY (`idCharacter`,`idNode`),
  ADD KEY `fk_CharactersTalents_PSTreeNodes1_idx` (`idNode`);

--
-- Index pour la table `climates`
--
ALTER TABLE `climates`
  ADD PRIMARY KEY (`idClimate`),
  ADD UNIQUE KEY `idClimate_UNIQUE` (`idClimate`);

--
-- Index pour la table `climatesweathers`
--
ALTER TABLE `climatesweathers`
  ADD PRIMARY KEY (`idClimate`,`idWeather`),
  ADD KEY `fk_ClimatesWeathers_Weathers1_idx` (`idWeather`);

--
-- Index pour la table `collectableresources`
--
ALTER TABLE `collectableresources`
  ADD PRIMARY KEY (`idCollectableResource`),
  ADD KEY `fk_CollectableResources_ItemsBase1_idx` (`idBaseItem`),
  ADD KEY `fk_CollectableResources_LevelsRequire1_idx` (`minLevel`),
  ADD KEY `fk_CollectableResources_RebirthsPossibles1_idx` (`minRebirthLevel`);

--
-- Index pour la table `commandslogs`
--
ALTER TABLE `commandslogs`
  ADD PRIMARY KEY (`idCommandsLogs`,`idUser`);

--
-- Index pour la table `conquesttournamentinfo`
--
ALTER TABLE `conquesttournamentinfo`
  ADD PRIMARY KEY (`idArea`);

--
-- Index pour la table `conquesttournamentinscriptions`
--
ALTER TABLE `conquesttournamentinscriptions`
  ADD PRIMARY KEY (`idGuild`),
  ADD UNIQUE KEY `idGuild_UNIQUE` (`idGuild`),
  ADD KEY `fk_AreaConquestTournament_Guilds1_idx` (`idGuild`),
  ADD KEY `fk_ConquestTournamentIncriptions_Areas1_idx` (`idArea`);

--
-- Index pour la table `conquesttournamentrounds`
--
ALTER TABLE `conquesttournamentrounds`
  ADD PRIMARY KEY (`idArea`,`idRound`,`idGuild_1`),
  ADD KEY `fk_ConquestTournamentRounds_ConquestTournamentInscriptions1_idx` (`idGuild_1`),
  ADD KEY `fk_ConquestTournamentRounds_ConquestTournamentInscriptions2_idx` (`idGuild_2`),
  ADD KEY `fk_ConquestTournamentRounds_Areas1_idx` (`idArea`);

--
-- Index pour la table `craftbuilding`
--
ALTER TABLE `craftbuilding`
  ADD PRIMARY KEY (`idCraftBuilding`),
  ADD UNIQUE KEY `idCraftBuilding_UNIQUE` (`idCraftBuilding`),
  ADD UNIQUE KEY `idArea_UNIQUE` (`idArea`),
  ADD KEY `fk_CraftBuilding_Areas1_idx` (`idArea`),
  ADD KEY `fk_CraftBuilding_ItemsRarities1_idx` (`rarityMax`),
  ADD KEY `fk_CraftBuilding_LevelsRequire1_idx` (`minLevel`),
  ADD KEY `fk_CraftBuilding_LevelsRequire2_idx` (`maxLevel`),
  ADD KEY `fk_CraftBuilding_ItemsRarities2_idx` (`rarityMin`),
  ADD KEY `fk_CraftBuilding_RebirthsPossibles1_idx` (`minRebirthLevel`),
  ADD KEY `fk_CraftBuilding_RebirthsPossibles2_idx` (`maxRebirthLevel`);

--
-- Index pour la table `craftitem`
--
ALTER TABLE `craftitem`
  ADD PRIMARY KEY (`idCraftItem`),
  ADD KEY `fk_CraftItem_LevelsRequire1_idx` (`maxLevel`),
  ADD KEY `fk_CraftItem_LevelsRequire2_idx` (`minLevel`),
  ADD KEY `fk_CraftItem_ItemsBase1_idx` (`idBaseItem`),
  ADD KEY `fk_CraftItem_RebirthsPossibles1_idx` (`minRebirthLevel`),
  ADD KEY `fk_CraftItem_RebirthsPossibles2_idx` (`maxRebirthLevel`);

--
-- Index pour la table `craftitemsneeded`
--
ALTER TABLE `craftitemsneeded`
  ADD PRIMARY KEY (`IdCraftItem`,`NeededItem`),
  ADD KEY `fk_CraftItemsNeeded_CraftItem1_idx` (`IdCraftItem`),
  ADD KEY `fk_CraftItemsNeeded_ItemsBase1` (`NeededItem`),
  ADD KEY `fk_CraftItemsNeeded_RebirthsPossibles1_idx` (`minRebirthLevel`);

--
-- Index pour la table `damageinfo`
--
ALTER TABLE `damageinfo`
  ADD PRIMARY KEY (`idSkill`),
  ADD KEY `fk_DamageInfo_DamagesTypes1_idx` (`idDamageType`),
  ADD KEY `fk_DamageInfo_ElementsTypes1_idx` (`idElementType`);

--
-- Index pour la table `damagestypes`
--
ALTER TABLE `damagestypes`
  ADD PRIMARY KEY (`idDamageType`),
  ADD UNIQUE KEY `idDamageType_UNIQUE` (`idDamageType`);

--
-- Index pour la table `effectsskills`
--
ALTER TABLE `effectsskills`
  ADD PRIMARY KEY (`idEffectSkill`),
  ADD UNIQUE KEY `idEffectSkill_UNIQUE` (`idEffectSkill`),
  ADD KEY `fk_EffectsSkills_Skills1_idx` (`idSkill`),
  ADD KEY `fk_EffectsSkills_EffectsTypes1_idx` (`idEffectType`),
  ADD KEY `fk_EffectsSkills_States1_idx` (`stateValue`),
  ADD KEY `fk_EffectsSkills_Stats1_idx` (`statValue`);

--
-- Index pour la table `effectstypes`
--
ALTER TABLE `effectstypes`
  ADD PRIMARY KEY (`idEffectType`);

--
-- Index pour la table `elementstypes`
--
ALTER TABLE `elementstypes`
  ADD PRIMARY KEY (`idElementType`),
  ADD UNIQUE KEY `idElementType_UNIQUE` (`idElementType`);

--
-- Index pour la table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`idEvent`),
  ADD KEY `fk_Events_EventsTypes1_idx` (`idEventType`);

--
-- Index pour la table `eventsareasdrops`
--
ALTER TABLE `eventsareasdrops`
  ADD PRIMARY KEY (`idArea`,`idEvent`,`idBaseItem`),
  ADD KEY `fk_EventsAreasDrops_EventSpecificDrops1_idx` (`idEvent`,`idBaseItem`);

--
-- Index pour la table `eventsareastypesdrops`
--
ALTER TABLE `eventsareastypesdrops`
  ADD PRIMARY KEY (`idAreaType`,`idEvent`,`idBaseItem`),
  ADD KEY `fk_EventsAreasTypesDrops_EventSpecificDrops1_idx` (`idEvent`,`idBaseItem`);

--
-- Index pour la table `eventsglobalmodifiers`
--
ALTER TABLE `eventsglobalmodifiers`
  ADD PRIMARY KEY (`idEvent`,`idBonusTypes`),
  ADD KEY `fk_EventsBonuses_BonusTypes1_idx` (`idBonusTypes`);

--
-- Index pour la table `eventspecificdrops`
--
ALTER TABLE `eventspecificdrops`
  ADD PRIMARY KEY (`idEvent`,`idBaseItem`),
  ADD KEY `fk_EventSpecificDrops_ItemsBase1_idx` (`idBaseItem`);

--
-- Index pour la table `eventstypes`
--
ALTER TABLE `eventstypes`
  ADD PRIMARY KEY (`idEventType`),
  ADD UNIQUE KEY `name_UNIQUE` (`name`);

--
-- Index pour la table `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`idGuild`),
  ADD UNIQUE KEY `idGuild_UNIQUE` (`idGuild`),
  ADD UNIQUE KEY `nom_UNIQUE` (`nom`);

--
-- Index pour la table `guildsappliances`
--
ALTER TABLE `guildsappliances`
  ADD PRIMARY KEY (`idGuild`,`idCharacter`),
  ADD KEY `fk_table1_Characters1_idx` (`idCharacter`);

--
-- Index pour la table `guildsmembers`
--
ALTER TABLE `guildsmembers`
  ADD PRIMARY KEY (`idCharacter`,`idGuild`),
  ADD KEY `fk_GuildsMembers_Guilds1_idx` (`idGuild`),
  ADD KEY `fk_GuildsMembers_GuildsRanks1_idx` (`idGuildRank`);

--
-- Index pour la table `guildsranks`
--
ALTER TABLE `guildsranks`
  ADD PRIMARY KEY (`idGuildRank`),
  ADD UNIQUE KEY `idGuildRank_UNIQUE` (`idGuildRank`);

--
-- Index pour la table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`idItem`),
  ADD UNIQUE KEY `idItems_UNIQUE` (`idItem`),
  ADD KEY `fk_Items_ItemsBase1_idx` (`idBaseItem`),
  ADD KEY `fk_Items_LevelsRequire1_idx` (`level`),
  ADD KEY `fk_Items_RebirthsPossibles1_idx` (`rebirthLevel`);

--
-- Index pour la table `itemsappearances`
--
ALTER TABLE `itemsappearances`
  ADD PRIMARY KEY (`idBaseItem`,`idAppearance`),
  ADD KEY `fk_ItemsAppearances_Appearances1_idx` (`idAppearance`);

--
-- Index pour la table `itemsappearancesmaskcolors`
--
ALTER TABLE `itemsappearancesmaskcolors`
  ADD PRIMARY KEY (`idBaseItem`,`idAppearance`,`sourceColor`);

--
-- Index pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  ADD PRIMARY KEY (`idBaseItem`),
  ADD UNIQUE KEY `idItem_UNIQUE` (`idBaseItem`),
  ADD KEY `fk_Items_ItemsTypes1_idx` (`idType`),
  ADD KEY `fk_ItemsBase_ItemsRarities1_idx` (`idRarity`),
  ADD KEY `fk_ItemsBase_ItemsSousTypes1_idx` (`idSousType`);

--
-- Index pour la table `itemspower`
--
ALTER TABLE `itemspower`
  ADD PRIMARY KEY (`idItem`);

--
-- Index pour la table `itemsrarities`
--
ALTER TABLE `itemsrarities`
  ADD PRIMARY KEY (`idRarity`),
  ADD UNIQUE KEY `idItemRaritie_UNIQUE` (`idRarity`);

--
-- Index pour la table `itemssecondarystats`
--
ALTER TABLE `itemssecondarystats`
  ADD PRIMARY KEY (`idItem`,`idSecondaryStat`),
  ADD KEY `fk_ItemsSecondaryStats_SecondaryStats1_idx` (`idSecondaryStat`);

--
-- Index pour la table `itemssecondarystatselementalresists`
--
ALTER TABLE `itemssecondarystatselementalresists`
  ADD PRIMARY KEY (`idItem`,`idElementType`),
  ADD KEY `fk_ItemsSecondaryStatsElementalResists_ElementsTypes1_idx` (`idElementType`);

--
-- Index pour la table `itemssoustypes`
--
ALTER TABLE `itemssoustypes`
  ADD PRIMARY KEY (`idSousType`),
  ADD UNIQUE KEY `idSousType_UNIQUE` (`idSousType`);

--
-- Index pour la table `itemsstats`
--
ALTER TABLE `itemsstats`
  ADD PRIMARY KEY (`idItem`,`idStat`),
  ADD KEY `fk_ItemsStats_Stats1_idx` (`idStat`);

--
-- Index pour la table `itemstypes`
--
ALTER TABLE `itemstypes`
  ADD PRIMARY KEY (`idType`),
  ADD UNIQUE KEY `idType_UNIQUE` (`idType`);

--
-- Index pour la table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`lang`);

--
-- Index pour la table `levels`
--
ALTER TABLE `levels`
  ADD PRIMARY KEY (`idCharacter`),
  ADD UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`),
  ADD KEY `fk_Levels_LevelsRequire1_idx` (`actualLevel`),
  ADD KEY `fk_Levels_RebirthsPossibles1_idx` (`rebirthLevel`);

--
-- Index pour la table `levelsrequire`
--
ALTER TABLE `levelsrequire`
  ADD PRIMARY KEY (`level`),
  ADD UNIQUE KEY `level_UNIQUE` (`level`);

--
-- Index pour la table `linkedappearances`
--
ALTER TABLE `linkedappearances`
  ADD PRIMARY KEY (`idAppearance`,`idLinkedAppearance`),
  ADD KEY `fk_LinkedAppearances_Appearances2_idx` (`idLinkedAppearance`);

--
-- Index pour la table `localizationachievements`
--
ALTER TABLE `localizationachievements`
  ADD PRIMARY KEY (`idAchievement`,`lang`),
  ADD KEY `fk_LocalizationAchievements_Languages1_idx` (`lang`);

--
-- Index pour la table `localizationareas`
--
ALTER TABLE `localizationareas`
  ADD PRIMARY KEY (`idArea`,`lang`),
  ADD KEY `fk_LocalizationAreas_Languages1_idx` (`lang`);

--
-- Index pour la table `localizationbosses`
--
ALTER TABLE `localizationbosses`
  ADD PRIMARY KEY (`idBoss`,`lang`),
  ADD KEY `fk_LocalizationBosses_Languages1_idx` (`lang`);

--
-- Index pour la table `localizationevents`
--
ALTER TABLE `localizationevents`
  ADD PRIMARY KEY (`idEvent`,`lang`),
  ADD KEY `fk_LocalizationEvents_Events1_idx` (`idEvent`),
  ADD KEY `fk_LocalizationEvents_Languages1` (`lang`);

--
-- Index pour la table `localizationitems`
--
ALTER TABLE `localizationitems`
  ADD PRIMARY KEY (`idBaseItem`,`lang`),
  ADD KEY `fk_LocalizationItems_Languages1_idx` (`lang`);

--
-- Index pour la table `localizationmonsters`
--
ALTER TABLE `localizationmonsters`
  ADD PRIMARY KEY (`idMonstre`,`lang`),
  ADD KEY `fk_LocalizationMonsters_Languages1_idx` (`lang`);

--
-- Index pour la table `localizationnodespstree`
--
ALTER TABLE `localizationnodespstree`
  ADD PRIMARY KEY (`idNode`,`lang`),
  ADD KEY `fk_LocalizationNodesPSTree_Languages1_idx` (`lang`);

--
-- Index pour la table `localizationregions`
--
ALTER TABLE `localizationregions`
  ADD PRIMARY KEY (`idRegion`,`lang`),
  ADD KEY `fk_LocalizationRegions_Languages1_idx` (`lang`);

--
-- Index pour la table `localizationskills`
--
ALTER TABLE `localizationskills`
  ADD PRIMARY KEY (`idSkill`,`lang`),
  ADD KEY `fk_LocalizationSkills_Languages1_idx` (`lang`);

--
-- Index pour la table `localizationstates`
--
ALTER TABLE `localizationstates`
  ADD PRIMARY KEY (`idState`,`lang`),
  ADD KEY `fk_LocalizationStates_Languages1_idx` (`lang`);

--
-- Index pour la table `marketplaces`
--
ALTER TABLE `marketplaces`
  ADD PRIMARY KEY (`idMarketplace`),
  ADD UNIQUE KEY `idMarketplace_UNIQUE` (`idMarketplace`),
  ADD UNIQUE KEY `idArea_UNIQUE` (`idArea`),
  ADD KEY `fk_Marketplaces_Areas1_idx` (`idArea`);

--
-- Index pour la table `marketplacesorders`
--
ALTER TABLE `marketplacesorders`
  ADD PRIMARY KEY (`idMarketplace`,`idItem`,`idCharacter`),
  ADD UNIQUE KEY `idItem_UNIQUE` (`idItem`),
  ADD KEY `fk_MarketplacesOrders_Items1_idx` (`idItem`),
  ADD KEY `fk_MarketplacesOrders_Characters1_idx` (`idCharacter`);

--
-- Index pour la table `monstersbuilds`
--
ALTER TABLE `monstersbuilds`
  ADD PRIMARY KEY (`idMonstersBuildsProfil`,`idSkill`),
  ADD KEY `fk_MonstersBuilds_Skills1_idx` (`idSkill`),
  ADD KEY `fk_MonstersBuilds_MonstersBuildsProfil1_idx` (`idMonstersBuildsProfil`);

--
-- Index pour la table `monstersbuildsprofil`
--
ALTER TABLE `monstersbuildsprofil`
  ADD PRIMARY KEY (`idMonstersBuildsProfil`);

--
-- Index pour la table `monstres`
--
ALTER TABLE `monstres`
  ADD PRIMARY KEY (`idMonstre`),
  ADD UNIQUE KEY `idMonstre_UNIQUE` (`idMonstre`),
  ADD KEY `fk_Monstres_MonstresTypes1_idx` (`idType`);

--
-- Index pour la table `monstresgroupes`
--
ALTER TABLE `monstresgroupes`
  ADD PRIMARY KEY (`idMonstresGroupe`),
  ADD UNIQUE KEY `idMonstresGroupe_UNIQUE` (`idMonstresGroupe`);

--
-- Index pour la table `monstresgroupesassoc`
--
ALTER TABLE `monstresgroupesassoc`
  ADD PRIMARY KEY (`idMonstresGroupe`,`idMonstre`),
  ADD KEY `fk_MonstresGroupes_Monstres1_idx` (`idMonstre`),
  ADD KEY `fk_MonstresGroupesAssoc_MonstresGroupes1_idx` (`idMonstresGroupe`);

--
-- Index pour la table `monstrestypes`
--
ALTER TABLE `monstrestypes`
  ADD PRIMARY KEY (`idType`),
  ADD UNIQUE KEY `idType_UNIQUE` (`idType`);

--
-- Index pour la table `pstreenodes`
--
ALTER TABLE `pstreenodes`
  ADD PRIMARY KEY (`idNode`),
  ADD UNIQUE KEY `idNode_UNIQUE` (`idNode`),
  ADD KEY `fk_PSTreeNodes_PSTreePossiblesNodesVisuals1_idx` (`idNodeVisual`);

--
-- Index pour la table `pstreenodeslinks`
--
ALTER TABLE `pstreenodeslinks`
  ADD PRIMARY KEY (`idNodeParent`,`PSTreeNodesChild`),
  ADD KEY `fk_PSTreeNodesLinks_PSTreeNodes2_idx` (`PSTreeNodesChild`);

--
-- Index pour la table `pstreenodessecondarystatsdata`
--
ALTER TABLE `pstreenodessecondarystatsdata`
  ADD PRIMARY KEY (`idNode`,`idSecondaryStat`),
  ADD KEY `fk_PSTreeNodesSecondaryStatsData_SecondaryStats1_idx` (`idSecondaryStat`);

--
-- Index pour la table `pstreenodessecondarystatselementalresistsdata`
--
ALTER TABLE `pstreenodessecondarystatselementalresistsdata`
  ADD PRIMARY KEY (`idNode`,`idElementType`),
  ADD KEY `fk_PSTreeNodesSecondaryStatsElementalResistsData_ElementsTy_idx` (`idElementType`);

--
-- Index pour la table `pstreenodesskillsunlockdata`
--
ALTER TABLE `pstreenodesskillsunlockdata`
  ADD PRIMARY KEY (`idNode`,`idSkill`),
  ADD KEY `fk_PSTreeNodesSkillsUnlockData_Skills1_idx` (`idSkill`);

--
-- Index pour la table `pstreenodesstatesdata`
--
ALTER TABLE `pstreenodesstatesdata`
  ADD PRIMARY KEY (`idNode`,`idState`),
  ADD KEY `fk_PSTreeNodesStatesData_States1_idx` (`idState`);

--
-- Index pour la table `pstreenodesstatsdata`
--
ALTER TABLE `pstreenodesstatsdata`
  ADD PRIMARY KEY (`idNode`,`idStat`),
  ADD KEY `fk_PSTreeNodesStatsData_Stats1_idx` (`idStat`);

--
-- Index pour la table `pstreepossiblesnodesvisuals`
--
ALTER TABLE `pstreepossiblesnodesvisuals`
  ADD PRIMARY KEY (`idNode`),
  ADD UNIQUE KEY `idNode_UNIQUE` (`idNode`);

--
-- Index pour la table `rebirthspossibles`
--
ALTER TABLE `rebirthspossibles`
  ADD PRIMARY KEY (`rebirthLevel`),
  ADD UNIQUE KEY `rebrithLevel_UNIQUE` (`rebirthLevel`);

--
-- Index pour la table `rebirthspossiblesitemsneeded`
--
ALTER TABLE `rebirthspossiblesitemsneeded`
  ADD PRIMARY KEY (`rebirthLevel`,`idBaseItem`),
  ADD KEY `fk_RebirthsPossiblesItemsNeeded_ItemsBase1_idx` (`idBaseItem`),
  ADD KEY `fk_RebirthsPossiblesItemsNeeded_RebirthsPossibles2_idx` (`minRebirthLevel`);

--
-- Index pour la table `regions`
--
ALTER TABLE `regions`
  ADD PRIMARY KEY (`idRegion`),
  ADD UNIQUE KEY `idRegions_UNIQUE` (`idRegion`);

--
-- Index pour la table `regionsbosses`
--
ALTER TABLE `regionsbosses`
  ADD PRIMARY KEY (`idBoss`,`idRegion`),
  ADD KEY `fk_RegionsBosses_Regions1_idx` (`idRegion`);

--
-- Index pour la table `requiredsubtypeequipped`
--
ALTER TABLE `requiredsubtypeequipped`
  ADD PRIMARY KEY (`idSousType`,`idSkill`),
  ADD KEY `fk_RequiredSubtypeEquipped_Skills1_idx` (`idSkill`);

--
-- Index pour la table `secondarystats`
--
ALTER TABLE `secondarystats`
  ADD PRIMARY KEY (`idSecondaryStat`),
  ADD UNIQUE KEY `name_UNIQUE` (`name`),
  ADD UNIQUE KEY `idSecondaryStat_UNIQUE` (`idSecondaryStat`);

--
-- Index pour la table `secondarystatselementalresistsrepartition`
--
ALTER TABLE `secondarystatselementalresistsrepartition`
  ADD PRIMARY KEY (`idStatsProfil`,`idElementType`),
  ADD KEY `fk_SecondaryStatsElementalResistsRepartition_StatsProfil1_idx` (`idStatsProfil`),
  ADD KEY `fk_SecondaryStatsElementalResistsRepartition_ElementsTypes1` (`idElementType`);

--
-- Index pour la table `secondarystatsrepartition`
--
ALTER TABLE `secondarystatsrepartition`
  ADD PRIMARY KEY (`idStatsProfil`,`idSecondaryStat`),
  ADD KEY `fk_SecondaryStatsRepartition_SecondaryStats1_idx` (`idSecondaryStat`);

--
-- Index pour la table `sellableitems`
--
ALTER TABLE `sellableitems`
  ADD PRIMARY KEY (`idSellableItems`),
  ADD KEY `fk_SellableItems_ItemsBase1_idx` (`idBaseItem`),
  ADD KEY `fk_SellableItems_RebirthsPossibles1_idx` (`rebirthLevel`);

--
-- Index pour la table `serversstats`
--
ALTER TABLE `serversstats`
  ADD PRIMARY KEY (`idServer`);

--
-- Index pour la table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`idShop`);

--
-- Index pour la table `shopitems`
--
ALTER TABLE `shopitems`
  ADD PRIMARY KEY (`idShop`,`idSellableItems`),
  ADD KEY `fk_ShopItems_SellableItems1_idx` (`idSellableItems`);

--
-- Index pour la table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`idSkill`),
  ADD UNIQUE KEY `idSkill_UNIQUE` (`idSkill`),
  ADD KEY `fk_Skills_SkillsTypes1_idx` (`idSkillType`),
  ADD KEY `fk_Skills_TargetRange1_idx` (`idTargetRange`);

--
-- Index pour la table `skillstypes`
--
ALTER TABLE `skillstypes`
  ADD PRIMARY KEY (`idSkillType`),
  ADD UNIQUE KEY `idSkillType_UNIQUE` (`idSkillType`);

--
-- Index pour la table `spawnedbosses`
--
ALTER TABLE `spawnedbosses`
  ADD PRIMARY KEY (`idSpawnedBoss`),
  ADD KEY `fk_SpawnedBosses_Bosses1_idx` (`idBoss`);

--
-- Index pour la table `spawnedbossesareas`
--
ALTER TABLE `spawnedbossesareas`
  ADD PRIMARY KEY (`idSpawnedBoss`),
  ADD KEY `fk_SpawnedBossesAreas_Areas1_idx` (`idArea`);

--
-- Index pour la table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`idState`),
  ADD UNIQUE KEY `idState_UNIQUE` (`idState`),
  ADD KEY `fk_States_StatesRestrictions1_idx` (`idStateRestriction`);

--
-- Index pour la table `statesremovalconditions`
--
ALTER TABLE `statesremovalconditions`
  ADD PRIMARY KEY (`idState`),
  ADD KEY `fk_StatesRemovalConditions_States1_idx` (`idState`);

--
-- Index pour la table `statesrestrictions`
--
ALTER TABLE `statesrestrictions`
  ADD PRIMARY KEY (`idStateRestriction`),
  ADD UNIQUE KEY `idStateRestriction_UNIQUE` (`idStateRestriction`);

--
-- Index pour la table `statestraits`
--
ALTER TABLE `statestraits`
  ADD PRIMARY KEY (`idState`,`idTrait`),
  ADD KEY `fk_StatesTraits_Traits1_idx` (`idTrait`);

--
-- Index pour la table `statisticsbases`
--
ALTER TABLE `statisticsbases`
  ADD PRIMARY KEY (`idStatisticBase`),
  ADD UNIQUE KEY `idStatisticBase_UNIQUE` (`idStatisticBase`);

--
-- Index pour la table `stats`
--
ALTER TABLE `stats`
  ADD PRIMARY KEY (`idStat`),
  ADD UNIQUE KEY `idStat_UNIQUE` (`idStat`),
  ADD UNIQUE KEY `nom_UNIQUE` (`nom`);

--
-- Index pour la table `statscharacters`
--
ALTER TABLE `statscharacters`
  ADD PRIMARY KEY (`idCharacter`,`idStat`),
  ADD KEY `fk_StatsCharacters_Stats1_idx` (`idStat`);

--
-- Index pour la table `statsmonstres`
--
ALTER TABLE `statsmonstres`
  ADD PRIMARY KEY (`idMonstre`),
  ADD KEY `fk_StatsMonstres_StatsProfil1_idx` (`idStatsProfil`),
  ADD KEY `fk_StatsMonstres_MonstersBuildsProfil1_idx` (`idMonstersBuildsProfil`);

--
-- Index pour la table `statsprofil`
--
ALTER TABLE `statsprofil`
  ADD PRIMARY KEY (`idStatsProfil`);

--
-- Index pour la table `statsrepartition`
--
ALTER TABLE `statsrepartition`
  ADD PRIMARY KEY (`idStatsProfil`,`idStat`),
  ADD KEY `fk_StatsRepartition_Stats1_idx` (`idStat`);

--
-- Index pour la table `targetrange`
--
ALTER TABLE `targetrange`
  ADD PRIMARY KEY (`idTargetRange`);

--
-- Index pour la table `traits`
--
ALTER TABLE `traits`
  ADD PRIMARY KEY (`idTrait`),
  ADD UNIQUE KEY `idTrait_UNIQUE` (`idTrait`),
  ADD KEY `fk_Traits_States1_idx` (`valueState`),
  ADD KEY `fk_Traits_TraitsTypes1_idx` (`idTraitType`),
  ADD KEY `fk_Traits_ElementsTypes1_idx` (`valueElementType`),
  ADD KEY `fk_Traits_SkillsTypes1_idx` (`valueSkillType`),
  ADD KEY `fk_Traits_Stats1_idx` (`valueStat`),
  ADD KEY `fk_Traits_Skills1_idx` (`valueSkill`),
  ADD KEY `fk_Traits_SecondaryStats1_idx` (`valueSecondaryStat`);

--
-- Index pour la table `traitstypes`
--
ALTER TABLE `traitstypes`
  ADD PRIMARY KEY (`idTraitType`),
  ADD UNIQUE KEY `typeShorthand_UNIQUE` (`typeShorthand`),
  ADD UNIQUE KEY `idTraitType_UNIQUE` (`idTraitType`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`idUser`),
  ADD UNIQUE KEY `idUsers_UNIQUE` (`idUser`),
  ADD UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`),
  ADD UNIQUE KEY `token_UNIQUE` (`token`),
  ADD KEY `fk_Users_Character_idx` (`idCharacter`);

--
-- Index pour la table `userspreferences`
--
ALTER TABLE `userspreferences`
  ADD PRIMARY KEY (`idUser`),
  ADD UNIQUE KEY `idUser_UNIQUE` (`idUser`);

--
-- Index pour la table `wbrewardstates`
--
ALTER TABLE `wbrewardstates`
  ADD PRIMARY KEY (`idSpawnedBoss`);

--
-- Index pour la table `weathers`
--
ALTER TABLE `weathers`
  ADD PRIMARY KEY (`idWeather`),
  ADD UNIQUE KEY `idWeather_UNIQUE` (`idWeather`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `achievement`
--
ALTER TABLE `achievement`
  MODIFY `idAchievement` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT pour la table `appearances`
--
ALTER TABLE `appearances`
  MODIFY `idAppearance` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=609;

--
-- AUTO_INCREMENT pour la table `appearancestype`
--
ALTER TABLE `appearancestype`
  MODIFY `idAppearanceType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT pour la table `areas`
--
ALTER TABLE `areas`
  MODIFY `idArea` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT pour la table `areaslevels`
--
ALTER TABLE `areaslevels`
  MODIFY `idAreaLevel` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `areastypes`
--
ALTER TABLE `areastypes`
  MODIFY `idAreaType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `attackstypes`
--
ALTER TABLE `attackstypes`
  MODIFY `idAttackType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `bodytype`
--
ALTER TABLE `bodytype`
  MODIFY `idBodyType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `bonustypes`
--
ALTER TABLE `bonustypes`
  MODIFY `idBonusTypes` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `bosses`
--
ALTER TABLE `bosses`
  MODIFY `idBoss` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `characters`
--
ALTER TABLE `characters`
  MODIFY `idCharacter` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `climates`
--
ALTER TABLE `climates`
  MODIFY `idClimate` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `commandslogs`
--
ALTER TABLE `commandslogs`
  MODIFY `idCommandsLogs` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `craftbuilding`
--
ALTER TABLE `craftbuilding`
  MODIFY `idCraftBuilding` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `craftitem`
--
ALTER TABLE `craftitem`
  MODIFY `idCraftItem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=183;

--
-- AUTO_INCREMENT pour la table `damagestypes`
--
ALTER TABLE `damagestypes`
  MODIFY `idDamageType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `effectsskills`
--
ALTER TABLE `effectsskills`
  MODIFY `idEffectSkill` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `elementstypes`
--
ALTER TABLE `elementstypes`
  MODIFY `idElementType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `events`
--
ALTER TABLE `events`
  MODIFY `idEvent` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `eventstypes`
--
ALTER TABLE `eventstypes`
  MODIFY `idEventType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `guilds`
--
ALTER TABLE `guilds`
  MODIFY `idGuild` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `guildsranks`
--
ALTER TABLE `guildsranks`
  MODIFY `idGuildRank` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `items`
--
ALTER TABLE `items`
  MODIFY `idItem` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  MODIFY `idBaseItem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=178;

--
-- AUTO_INCREMENT pour la table `itemsrarities`
--
ALTER TABLE `itemsrarities`
  MODIFY `idRarity` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `itemssoustypes`
--
ALTER TABLE `itemssoustypes`
  MODIFY `idSousType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pour la table `itemstypes`
--
ALTER TABLE `itemstypes`
  MODIFY `idType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `levelsrequire`
--
ALTER TABLE `levelsrequire`
  MODIFY `level` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT pour la table `marketplaces`
--
ALTER TABLE `marketplaces`
  MODIFY `idMarketplace` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `monstersbuildsprofil`
--
ALTER TABLE `monstersbuildsprofil`
  MODIFY `idMonstersBuildsProfil` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pour la table `monstres`
--
ALTER TABLE `monstres`
  MODIFY `idMonstre` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT pour la table `monstresgroupes`
--
ALTER TABLE `monstresgroupes`
  MODIFY `idMonstresGroupe` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT pour la table `monstrestypes`
--
ALTER TABLE `monstrestypes`
  MODIFY `idType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `pstreenodes`
--
ALTER TABLE `pstreenodes`
  MODIFY `idNode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT pour la table `pstreepossiblesnodesvisuals`
--
ALTER TABLE `pstreepossiblesnodesvisuals`
  MODIFY `idNode` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT pour la table `regions`
--
ALTER TABLE `regions`
  MODIFY `idRegion` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `secondarystats`
--
ALTER TABLE `secondarystats`
  MODIFY `idSecondaryStat` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `sellableitems`
--
ALTER TABLE `sellableitems`
  MODIFY `idSellableItems` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT pour la table `shop`
--
ALTER TABLE `shop`
  MODIFY `idShop` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `skills`
--
ALTER TABLE `skills`
  MODIFY `idSkill` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT pour la table `skillstypes`
--
ALTER TABLE `skillstypes`
  MODIFY `idSkillType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `spawnedbosses`
--
ALTER TABLE `spawnedbosses`
  MODIFY `idSpawnedBoss` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `states`
--
ALTER TABLE `states`
  MODIFY `idState` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `statesrestrictions`
--
ALTER TABLE `statesrestrictions`
  MODIFY `idStateRestriction` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `statisticsbases`
--
ALTER TABLE `statisticsbases`
  MODIFY `idStatisticBase` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT pour la table `stats`
--
ALTER TABLE `stats`
  MODIFY `idStat` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `statsprofil`
--
ALTER TABLE `statsprofil`
  MODIFY `idStatsProfil` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT pour la table `traits`
--
ALTER TABLE `traits`
  MODIFY `idTrait` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `traitstypes`
--
ALTER TABLE `traitstypes`
  MODIFY `idTraitType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `weathers`
--
ALTER TABLE `weathers`
  MODIFY `idWeather` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `appearances`
--
ALTER TABLE `appearances`
  ADD CONSTRAINT `fk_Appearances_AppearancesType1` FOREIGN KEY (`idAppearanceType`) REFERENCES `appearancestype` (`idAppearanceType`),
  ADD CONSTRAINT `fk_Appearances_BodyType1` FOREIGN KEY (`idBodyType`) REFERENCES `bodytype` (`idBodyType`);

--
-- Contraintes pour la table `areas`
--
ALTER TABLE `areas`
  ADD CONSTRAINT `fk_Areas_AreasLevels1` FOREIGN KEY (`AreaLevel`) REFERENCES `areaslevels` (`idAreaLevel`),
  ADD CONSTRAINT `fk_Areas_AreasTypes1` FOREIGN KEY (`idAreaType`) REFERENCES `areastypes` (`idAreaType`);

--
-- Contraintes pour la table `areasbonuses`
--
ALTER TABLE `areasbonuses`
  ADD CONSTRAINT `fk_AreasBonuses_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasBonuses_BonusTypes1` FOREIGN KEY (`idBonusTypes`) REFERENCES `bonustypes` (`idBonusTypes`);

--
-- Contraintes pour la table `areasclimates`
--
ALTER TABLE `areasclimates`
  ADD CONSTRAINT `fk_AreasClimates_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasClimates_Climates1` FOREIGN KEY (`idClimate`) REFERENCES `climates` (`idClimate`),
  ADD CONSTRAINT `fk_AreasClimates_Weathers1` FOREIGN KEY (`currentWeather`) REFERENCES `weathers` (`idWeather`);

--
-- Contraintes pour la table `areasitems`
--
ALTER TABLE `areasitems`
  ADD CONSTRAINT `fk_AreasItems_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasItems_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`);

--
-- Contraintes pour la table `areasmonsters`
--
ALTER TABLE `areasmonsters`
  ADD CONSTRAINT `fk_AreasMonsters_MonstresGroupes1` FOREIGN KEY (`idMonstresGroupe`) REFERENCES `monstresgroupes` (`idMonstresGroupe`),
  ADD CONSTRAINT `fk_table1_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`);

--
-- Contraintes pour la table `areasmonsterslevels`
--
ALTER TABLE `areasmonsterslevels`
  ADD CONSTRAINT `fk_AreasMonstersLevels_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasMonstersLevels_RebirthsPossibles1` FOREIGN KEY (`minRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`),
  ADD CONSTRAINT `fk_AreasMonstersLevels_RebirthsPossibles2` FOREIGN KEY (`maxRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `areasowners`
--
ALTER TABLE `areasowners`
  ADD CONSTRAINT `fk_AreasOwners_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasOwners_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`);

--
-- Contraintes pour la table `areaspaths`
--
ALTER TABLE `areaspaths`
  ADD CONSTRAINT `fk_AreasPaths_Areas1` FOREIGN KEY (`idArea1`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasPaths_Areas2` FOREIGN KEY (`idArea2`) REFERENCES `areas` (`idArea`);

--
-- Contraintes pour la table `areasregions`
--
ALTER TABLE `areasregions`
  ADD CONSTRAINT `fk_AreasRegions_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasRegions_Regions1` FOREIGN KEY (`idRegion`) REFERENCES `regions` (`idRegion`);

--
-- Contraintes pour la table `areasrequirements`
--
ALTER TABLE `areasrequirements`
  ADD CONSTRAINT `fk_AreasRequirements_Achievement1` FOREIGN KEY (`idAchievement`) REFERENCES `achievement` (`idAchievement`),
  ADD CONSTRAINT `fk_AreasRequirements_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`);

--
-- Contraintes pour la table `areasresources`
--
ALTER TABLE `areasresources`
  ADD CONSTRAINT `fk_AreasResources_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasResources_CollectableResources1` FOREIGN KEY (`idCollectableResource`) REFERENCES `collectableresources` (`idCollectableResource`);

--
-- Contraintes pour la table `areasshops`
--
ALTER TABLE `areasshops`
  ADD CONSTRAINT `fk_AreasShops_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_AreasShops_Shop1` FOREIGN KEY (`idShop`) REFERENCES `shop` (`idShop`);

--
-- Contraintes pour la table `bossspawninfo`
--
ALTER TABLE `bossspawninfo`
  ADD CONSTRAINT `fk_BossSpawnInfo_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_BossSpawnInfo_Bosses1` FOREIGN KEY (`idBoss`) REFERENCES `bosses` (`idBoss`),
  ADD CONSTRAINT `fk_BossSpawnInfo_SpawnedBosses1` FOREIGN KEY (`idSpawnedBoss`) REFERENCES `spawnedbosses` (`idSpawnedBoss`);

--
-- Contraintes pour la table `castinfo`
--
ALTER TABLE `castinfo`
  ADD CONSTRAINT `fk_CastInfo_AttacksTypes1` FOREIGN KEY (`idAttackType`) REFERENCES `attackstypes` (`idAttackType`),
  ADD CONSTRAINT `fk_CastInfo_Skills1` FOREIGN KEY (`idSkill`) REFERENCES `skills` (`idSkill`);

--
-- Contraintes pour la table `characters`
--
ALTER TABLE `characters`
  ADD CONSTRAINT `fk_Characters_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`);

--
-- Contraintes pour la table `charactersachievements`
--
ALTER TABLE `charactersachievements`
  ADD CONSTRAINT `fk_CharactersAchievements_Achievement1` FOREIGN KEY (`idAchievement`) REFERENCES `achievement` (`idAchievement`),
  ADD CONSTRAINT `fk_CharactersAchievements_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`);

--
-- Contraintes pour la table `charactersappearance`
--
ALTER TABLE `charactersappearance`
  ADD CONSTRAINT `fk_CharacterAppearance_BodyType1` FOREIGN KEY (`idBodyType`) REFERENCES `bodytype` (`idBodyType`),
  ADD CONSTRAINT `fk_CharacterAppearance_Characters2` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`);

--
-- Contraintes pour la table `charactersappearanceparts`
--
ALTER TABLE `charactersappearanceparts`
  ADD CONSTRAINT `fk_CharacterAppearance_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_CharactersAppearanceParts_Appearances1` FOREIGN KEY (`idAppearance`) REFERENCES `appearances` (`idAppearance`);

--
-- Contraintes pour la table `charactersattacks`
--
ALTER TABLE `charactersattacks`
  ADD CONSTRAINT `fk_CharactersAttacks_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_CharactersAttacks_SpawnedBosses1` FOREIGN KEY (`idSpawnedBoss`) REFERENCES `spawnedbosses` (`idSpawnedBoss`);

--
-- Contraintes pour la table `charactersbuilds`
--
ALTER TABLE `charactersbuilds`
  ADD CONSTRAINT `fk_CharactersBuilds_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_CharactersBuilds_Skills1` FOREIGN KEY (`idSkill`) REFERENCES `skills` (`idSkill`);

--
-- Contraintes pour la table `characterscraftlevel`
--
ALTER TABLE `characterscraftlevel`
  ADD CONSTRAINT `fk_CharactersCraftLevel_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_CharactersCraftLevel_LevelsRequire1` FOREIGN KEY (`actualLevel`) REFERENCES `levelsrequire` (`level`),
  ADD CONSTRAINT `fk_CharactersCraftLevel_RebirthsPossibles1` FOREIGN KEY (`rebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `charactersequipements`
--
ALTER TABLE `charactersequipements`
  ADD CONSTRAINT `fk_CharactersEquipements_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_CharactersEquipements_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`),
  ADD CONSTRAINT `fk_CharactersEquipements_ItemsTypes1` FOREIGN KEY (`idType`) REFERENCES `itemstypes` (`idType`);

--
-- Contraintes pour la table `charactershonor`
--
ALTER TABLE `charactershonor`
  ADD CONSTRAINT `fk_CharacterHonor_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`);

--
-- Contraintes pour la table `charactersinventory`
--
ALTER TABLE `charactersinventory`
  ADD CONSTRAINT `fk_CharactersInventory_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_CharactersInventory_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`);

--
-- Contraintes pour la table `charactersstatistics`
--
ALTER TABLE `charactersstatistics`
  ADD CONSTRAINT `fk_CharactersStatistics_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_CharactersStatistics_StatisticsBases1` FOREIGN KEY (`idStatisticBase`) REFERENCES `statisticsbases` (`idStatisticBase`);

--
-- Contraintes pour la table `characterstalents`
--
ALTER TABLE `characterstalents`
  ADD CONSTRAINT `fk_CharactersTalents_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_CharactersTalents_PSTreeNodes1` FOREIGN KEY (`idNode`) REFERENCES `pstreenodes` (`idNode`);

--
-- Contraintes pour la table `climatesweathers`
--
ALTER TABLE `climatesweathers`
  ADD CONSTRAINT `fk_ClimatesWeathers_Climates1` FOREIGN KEY (`idClimate`) REFERENCES `climates` (`idClimate`),
  ADD CONSTRAINT `fk_ClimatesWeathers_Weathers1` FOREIGN KEY (`idWeather`) REFERENCES `weathers` (`idWeather`);

--
-- Contraintes pour la table `collectableresources`
--
ALTER TABLE `collectableresources`
  ADD CONSTRAINT `fk_CollectableResources_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`),
  ADD CONSTRAINT `fk_CollectableResources_LevelsRequire1` FOREIGN KEY (`minLevel`) REFERENCES `levelsrequire` (`level`),
  ADD CONSTRAINT `fk_CollectableResources_RebirthsPossibles1` FOREIGN KEY (`minRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `conquesttournamentinfo`
--
ALTER TABLE `conquesttournamentinfo`
  ADD CONSTRAINT `fk_ConquestTournamentInfo_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`);

--
-- Contraintes pour la table `conquesttournamentinscriptions`
--
ALTER TABLE `conquesttournamentinscriptions`
  ADD CONSTRAINT `fk_AreaConquestTournament_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`),
  ADD CONSTRAINT `fk_ConquestTournamentIncriptions_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`);

--
-- Contraintes pour la table `conquesttournamentrounds`
--
ALTER TABLE `conquesttournamentrounds`
  ADD CONSTRAINT `fk_ConquestTournamentRounds_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_ConquestTournamentRounds_ConquestTournamentInscriptions1` FOREIGN KEY (`idGuild_1`) REFERENCES `conquesttournamentinscriptions` (`idGuild`),
  ADD CONSTRAINT `fk_ConquestTournamentRounds_ConquestTournamentInscriptions2` FOREIGN KEY (`idGuild_2`) REFERENCES `conquesttournamentinscriptions` (`idGuild`);

--
-- Contraintes pour la table `craftbuilding`
--
ALTER TABLE `craftbuilding`
  ADD CONSTRAINT `fk_CraftBuilding_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_CraftBuilding_ItemsRarities1` FOREIGN KEY (`rarityMax`) REFERENCES `itemsrarities` (`idRarity`),
  ADD CONSTRAINT `fk_CraftBuilding_ItemsRarities2` FOREIGN KEY (`rarityMin`) REFERENCES `itemsrarities` (`idRarity`),
  ADD CONSTRAINT `fk_CraftBuilding_LevelsRequire1` FOREIGN KEY (`minLevel`) REFERENCES `levelsrequire` (`level`),
  ADD CONSTRAINT `fk_CraftBuilding_LevelsRequire2` FOREIGN KEY (`maxLevel`) REFERENCES `levelsrequire` (`level`),
  ADD CONSTRAINT `fk_CraftBuilding_RebirthsPossibles1` FOREIGN KEY (`minRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`),
  ADD CONSTRAINT `fk_CraftBuilding_RebirthsPossibles2` FOREIGN KEY (`maxRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `craftitem`
--
ALTER TABLE `craftitem`
  ADD CONSTRAINT `fk_CraftItem_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`),
  ADD CONSTRAINT `fk_CraftItem_LevelsRequire1` FOREIGN KEY (`maxLevel`) REFERENCES `levelsrequire` (`level`),
  ADD CONSTRAINT `fk_CraftItem_LevelsRequire2` FOREIGN KEY (`minLevel`) REFERENCES `levelsrequire` (`level`),
  ADD CONSTRAINT `fk_CraftItem_RebirthsPossibles1` FOREIGN KEY (`minRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`),
  ADD CONSTRAINT `fk_CraftItem_RebirthsPossibles2` FOREIGN KEY (`maxRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `craftitemsneeded`
--
ALTER TABLE `craftitemsneeded`
  ADD CONSTRAINT `fk_CraftItemsNeeded_CraftItem1` FOREIGN KEY (`IdCraftItem`) REFERENCES `craftitem` (`idCraftItem`),
  ADD CONSTRAINT `fk_CraftItemsNeeded_ItemsBase1` FOREIGN KEY (`NeededItem`) REFERENCES `itemsbase` (`idBaseItem`),
  ADD CONSTRAINT `fk_CraftItemsNeeded_RebirthsPossibles1` FOREIGN KEY (`minRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `damageinfo`
--
ALTER TABLE `damageinfo`
  ADD CONSTRAINT `fk_DamageInfo_DamagesTypes1` FOREIGN KEY (`idDamageType`) REFERENCES `damagestypes` (`idDamageType`),
  ADD CONSTRAINT `fk_DamageInfo_ElementsTypes1` FOREIGN KEY (`idElementType`) REFERENCES `elementstypes` (`idElementType`),
  ADD CONSTRAINT `fk_DamageInfo_Skills1` FOREIGN KEY (`idSkill`) REFERENCES `skills` (`idSkill`);

--
-- Contraintes pour la table `effectsskills`
--
ALTER TABLE `effectsskills`
  ADD CONSTRAINT `fk_EffectsSkills_EffectsTypes1` FOREIGN KEY (`idEffectType`) REFERENCES `effectstypes` (`idEffectType`),
  ADD CONSTRAINT `fk_EffectsSkills_Skills1` FOREIGN KEY (`idSkill`) REFERENCES `skills` (`idSkill`),
  ADD CONSTRAINT `fk_EffectsSkills_States1` FOREIGN KEY (`stateValue`) REFERENCES `states` (`idState`),
  ADD CONSTRAINT `fk_EffectsSkills_Stats1` FOREIGN KEY (`statValue`) REFERENCES `stats` (`idStat`);

--
-- Contraintes pour la table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `fk_Events_EventsTypes1` FOREIGN KEY (`idEventType`) REFERENCES `eventstypes` (`idEventType`);

--
-- Contraintes pour la table `eventsareasdrops`
--
ALTER TABLE `eventsareasdrops`
  ADD CONSTRAINT `fk_EventsAreasDrops_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_EventsAreasDrops_EventSpecificDrops1` FOREIGN KEY (`idEvent`,`idBaseItem`) REFERENCES `eventspecificdrops` (`idEvent`, `idBaseItem`);

--
-- Contraintes pour la table `eventsareastypesdrops`
--
ALTER TABLE `eventsareastypesdrops`
  ADD CONSTRAINT `fk_EventsAreasTypesDrops_AreasTypes1` FOREIGN KEY (`idAreaType`) REFERENCES `areastypes` (`idAreaType`),
  ADD CONSTRAINT `fk_EventsAreasTypesDrops_EventSpecificDrops1` FOREIGN KEY (`idEvent`,`idBaseItem`) REFERENCES `eventspecificdrops` (`idEvent`, `idBaseItem`);

--
-- Contraintes pour la table `eventsglobalmodifiers`
--
ALTER TABLE `eventsglobalmodifiers`
  ADD CONSTRAINT `fk_EventsBonuses_BonusTypes1` FOREIGN KEY (`idBonusTypes`) REFERENCES `bonustypes` (`idBonusTypes`),
  ADD CONSTRAINT `fk_EventsBonuses_Events1` FOREIGN KEY (`idEvent`) REFERENCES `events` (`idEvent`);

--
-- Contraintes pour la table `eventspecificdrops`
--
ALTER TABLE `eventspecificdrops`
  ADD CONSTRAINT `fk_EventSpecificDrops_Events1` FOREIGN KEY (`idEvent`) REFERENCES `events` (`idEvent`),
  ADD CONSTRAINT `fk_EventSpecificDrops_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`);

--
-- Contraintes pour la table `guildsappliances`
--
ALTER TABLE `guildsappliances`
  ADD CONSTRAINT `fk_table1_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_table1_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`);

--
-- Contraintes pour la table `guildsmembers`
--
ALTER TABLE `guildsmembers`
  ADD CONSTRAINT `fk_GuildsMembers_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_GuildsMembers_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`),
  ADD CONSTRAINT `fk_GuildsMembers_GuildsRanks1` FOREIGN KEY (`idGuildRank`) REFERENCES `guildsranks` (`idGuildRank`);

--
-- Contraintes pour la table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `fk_Items_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`),
  ADD CONSTRAINT `fk_Items_LevelsRequire1` FOREIGN KEY (`level`) REFERENCES `levelsrequire` (`level`),
  ADD CONSTRAINT `fk_Items_RebirthsPossibles1` FOREIGN KEY (`rebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `itemsappearances`
--
ALTER TABLE `itemsappearances`
  ADD CONSTRAINT `fk_ItemsAppearances_Appearances1` FOREIGN KEY (`idAppearance`) REFERENCES `appearances` (`idAppearance`),
  ADD CONSTRAINT `fk_ItemsAppearances_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`);

--
-- Contraintes pour la table `itemsappearancesmaskcolors`
--
ALTER TABLE `itemsappearancesmaskcolors`
  ADD CONSTRAINT `fk_table1_ItemsAppearances1` FOREIGN KEY (`idBaseItem`,`idAppearance`) REFERENCES `itemsappearances` (`idBaseItem`, `idAppearance`);

--
-- Contraintes pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  ADD CONSTRAINT `fk_ItemsBase_ItemsRarities1` FOREIGN KEY (`idRarity`) REFERENCES `itemsrarities` (`idRarity`),
  ADD CONSTRAINT `fk_ItemsBase_ItemsSousTypes1` FOREIGN KEY (`idSousType`) REFERENCES `itemssoustypes` (`idSousType`),
  ADD CONSTRAINT `fk_Items_ItemsTypes1` FOREIGN KEY (`idType`) REFERENCES `itemstypes` (`idType`);

--
-- Contraintes pour la table `itemspower`
--
ALTER TABLE `itemspower`
  ADD CONSTRAINT `fk_ItemsPower_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`);

--
-- Contraintes pour la table `itemssecondarystats`
--
ALTER TABLE `itemssecondarystats`
  ADD CONSTRAINT `fk_ItemsSecondaryStats_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`),
  ADD CONSTRAINT `fk_ItemsSecondaryStats_SecondaryStats1` FOREIGN KEY (`idSecondaryStat`) REFERENCES `secondarystats` (`idSecondaryStat`);

--
-- Contraintes pour la table `itemssecondarystatselementalresists`
--
ALTER TABLE `itemssecondarystatselementalresists`
  ADD CONSTRAINT `fk_ItemsSecondaryStatsElementalResists_ElementsTypes1` FOREIGN KEY (`idElementType`) REFERENCES `elementstypes` (`idElementType`),
  ADD CONSTRAINT `fk_ItemsSecondaryStatsElementalResists_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`);

--
-- Contraintes pour la table `itemsstats`
--
ALTER TABLE `itemsstats`
  ADD CONSTRAINT `fk_ItemsStats_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`),
  ADD CONSTRAINT `fk_ItemsStats_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`);

--
-- Contraintes pour la table `levels`
--
ALTER TABLE `levels`
  ADD CONSTRAINT `fk_Levels_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_Levels_LevelsRequire1` FOREIGN KEY (`actualLevel`) REFERENCES `levelsrequire` (`level`),
  ADD CONSTRAINT `fk_Levels_RebirthsPossibles1` FOREIGN KEY (`rebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `linkedappearances`
--
ALTER TABLE `linkedappearances`
  ADD CONSTRAINT `fk_LinkedAppearances_Appearances1` FOREIGN KEY (`idAppearance`) REFERENCES `appearances` (`idAppearance`),
  ADD CONSTRAINT `fk_LinkedAppearances_Appearances2` FOREIGN KEY (`idLinkedAppearance`) REFERENCES `appearances` (`idAppearance`);

--
-- Contraintes pour la table `localizationachievements`
--
ALTER TABLE `localizationachievements`
  ADD CONSTRAINT `fk_LocalizationAchievements_Achievement1` FOREIGN KEY (`idAchievement`) REFERENCES `achievement` (`idAchievement`),
  ADD CONSTRAINT `fk_LocalizationAchievements_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`);

--
-- Contraintes pour la table `localizationareas`
--
ALTER TABLE `localizationareas`
  ADD CONSTRAINT `fk_LocalizationAreas_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_LocalizationAreas_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`);

--
-- Contraintes pour la table `localizationbosses`
--
ALTER TABLE `localizationbosses`
  ADD CONSTRAINT `fk_LocalizationBosses_Bosses1` FOREIGN KEY (`idBoss`) REFERENCES `bosses` (`idBoss`),
  ADD CONSTRAINT `fk_LocalizationBosses_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`);

--
-- Contraintes pour la table `localizationevents`
--
ALTER TABLE `localizationevents`
  ADD CONSTRAINT `fk_LocalizationEvents_Events1` FOREIGN KEY (`idEvent`) REFERENCES `events` (`idEvent`),
  ADD CONSTRAINT `fk_LocalizationEvents_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`);

--
-- Contraintes pour la table `localizationitems`
--
ALTER TABLE `localizationitems`
  ADD CONSTRAINT `fk_LocalizationItems_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`),
  ADD CONSTRAINT `fk_LocalizationItems_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`);

--
-- Contraintes pour la table `localizationmonsters`
--
ALTER TABLE `localizationmonsters`
  ADD CONSTRAINT `fk_LocalizationMonsters_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`),
  ADD CONSTRAINT `fk_LocalizationMonsters_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`);

--
-- Contraintes pour la table `localizationnodespstree`
--
ALTER TABLE `localizationnodespstree`
  ADD CONSTRAINT `fk_LocalizationNodesPSTree_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`),
  ADD CONSTRAINT `fk_LocalizationNodesPSTree_PSTreePossiblesNodesVisuals1` FOREIGN KEY (`idNode`) REFERENCES `pstreepossiblesnodesvisuals` (`idNode`);

--
-- Contraintes pour la table `localizationregions`
--
ALTER TABLE `localizationregions`
  ADD CONSTRAINT `fk_LocalizationRegions_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`),
  ADD CONSTRAINT `fk_LocalizationRegions_Regions1` FOREIGN KEY (`idRegion`) REFERENCES `regions` (`idRegion`);

--
-- Contraintes pour la table `localizationskills`
--
ALTER TABLE `localizationskills`
  ADD CONSTRAINT `fk_LocalizationSkills_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`),
  ADD CONSTRAINT `fk_LocalizationSkills_Skills1` FOREIGN KEY (`idSkill`) REFERENCES `skills` (`idSkill`);

--
-- Contraintes pour la table `localizationstates`
--
ALTER TABLE `localizationstates`
  ADD CONSTRAINT `fk_LocalizationStates_Languages1` FOREIGN KEY (`lang`) REFERENCES `languages` (`lang`),
  ADD CONSTRAINT `fk_LocalizationStates_States1` FOREIGN KEY (`idState`) REFERENCES `states` (`idState`);

--
-- Contraintes pour la table `marketplaces`
--
ALTER TABLE `marketplaces`
  ADD CONSTRAINT `fk_Marketplaces_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`);

--
-- Contraintes pour la table `marketplacesorders`
--
ALTER TABLE `marketplacesorders`
  ADD CONSTRAINT `fk_MarketplacesOrders_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_MarketplacesOrders_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`),
  ADD CONSTRAINT `fk_MarketplacesOrders_Marketplaces1` FOREIGN KEY (`idMarketplace`) REFERENCES `marketplaces` (`idMarketplace`);

--
-- Contraintes pour la table `monstersbuilds`
--
ALTER TABLE `monstersbuilds`
  ADD CONSTRAINT `fk_MonstersBuilds_MonstersBuildsProfil1` FOREIGN KEY (`idMonstersBuildsProfil`) REFERENCES `monstersbuildsprofil` (`idMonstersBuildsProfil`),
  ADD CONSTRAINT `fk_MonstersBuilds_Skills1` FOREIGN KEY (`idSkill`) REFERENCES `skills` (`idSkill`);

--
-- Contraintes pour la table `monstres`
--
ALTER TABLE `monstres`
  ADD CONSTRAINT `fk_Monstres_MonstresTypes1` FOREIGN KEY (`idType`) REFERENCES `monstrestypes` (`idType`);

--
-- Contraintes pour la table `monstresgroupesassoc`
--
ALTER TABLE `monstresgroupesassoc`
  ADD CONSTRAINT `fk_MonstresGroupesAssoc_MonstresGroupes1` FOREIGN KEY (`idMonstresGroupe`) REFERENCES `monstresgroupes` (`idMonstresGroupe`),
  ADD CONSTRAINT `fk_MonstresGroupes_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`);

--
-- Contraintes pour la table `pstreenodes`
--
ALTER TABLE `pstreenodes`
  ADD CONSTRAINT `fk_PSTreeNodes_PSTreePossiblesNodesVisuals1` FOREIGN KEY (`idNodeVisual`) REFERENCES `pstreepossiblesnodesvisuals` (`idNode`);

--
-- Contraintes pour la table `pstreenodeslinks`
--
ALTER TABLE `pstreenodeslinks`
  ADD CONSTRAINT `fk_PSTreeNodesLinks_PSTreeNodes1` FOREIGN KEY (`idNodeParent`) REFERENCES `pstreenodes` (`idNode`),
  ADD CONSTRAINT `fk_PSTreeNodesLinks_PSTreeNodes2` FOREIGN KEY (`PSTreeNodesChild`) REFERENCES `pstreenodes` (`idNode`);

--
-- Contraintes pour la table `pstreenodessecondarystatsdata`
--
ALTER TABLE `pstreenodessecondarystatsdata`
  ADD CONSTRAINT `fk_PSTreeNodesSecondaryStatsData_PSTreeNodes1` FOREIGN KEY (`idNode`) REFERENCES `pstreenodes` (`idNode`),
  ADD CONSTRAINT `fk_PSTreeNodesSecondaryStatsData_SecondaryStats1` FOREIGN KEY (`idSecondaryStat`) REFERENCES `secondarystats` (`idSecondaryStat`);

--
-- Contraintes pour la table `pstreenodessecondarystatselementalresistsdata`
--
ALTER TABLE `pstreenodessecondarystatselementalresistsdata`
  ADD CONSTRAINT `fk_PSTreeNodesSecondaryStatsElementalResistsData_ElementsTypes1` FOREIGN KEY (`idElementType`) REFERENCES `elementstypes` (`idElementType`),
  ADD CONSTRAINT `fk_PSTreeNodesSecondaryStatsElementalResistsData_PSTreeNodes1` FOREIGN KEY (`idNode`) REFERENCES `pstreenodes` (`idNode`);

--
-- Contraintes pour la table `pstreenodesskillsunlockdata`
--
ALTER TABLE `pstreenodesskillsunlockdata`
  ADD CONSTRAINT `fk_PSTreeNodesSkillsUnlockData_PSTreeNodes1` FOREIGN KEY (`idNode`) REFERENCES `pstreenodes` (`idNode`),
  ADD CONSTRAINT `fk_PSTreeNodesSkillsUnlockData_Skills1` FOREIGN KEY (`idSkill`) REFERENCES `skills` (`idSkill`);

--
-- Contraintes pour la table `pstreenodesstatesdata`
--
ALTER TABLE `pstreenodesstatesdata`
  ADD CONSTRAINT `fk_PSTreeNodesStatesData_PSTreeNodes1` FOREIGN KEY (`idNode`) REFERENCES `pstreenodes` (`idNode`),
  ADD CONSTRAINT `fk_PSTreeNodesStatesData_States1` FOREIGN KEY (`idState`) REFERENCES `states` (`idState`);

--
-- Contraintes pour la table `pstreenodesstatsdata`
--
ALTER TABLE `pstreenodesstatsdata`
  ADD CONSTRAINT `fk_PSTreeNodesStatsData_PSTreeNodes1` FOREIGN KEY (`idNode`) REFERENCES `pstreenodes` (`idNode`),
  ADD CONSTRAINT `fk_PSTreeNodesStatsData_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`);

--
-- Contraintes pour la table `rebirthspossiblesitemsneeded`
--
ALTER TABLE `rebirthspossiblesitemsneeded`
  ADD CONSTRAINT `fk_RebirthsPossiblesItemsNeeded_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`),
  ADD CONSTRAINT `fk_RebirthsPossiblesItemsNeeded_RebirthsPossibles1` FOREIGN KEY (`rebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`),
  ADD CONSTRAINT `fk_RebirthsPossiblesItemsNeeded_RebirthsPossibles2` FOREIGN KEY (`minRebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `regionsbosses`
--
ALTER TABLE `regionsbosses`
  ADD CONSTRAINT `fk_RegionsBosses_Bosses1` FOREIGN KEY (`idBoss`) REFERENCES `bosses` (`idBoss`),
  ADD CONSTRAINT `fk_RegionsBosses_Regions1` FOREIGN KEY (`idRegion`) REFERENCES `regions` (`idRegion`);

--
-- Contraintes pour la table `requiredsubtypeequipped`
--
ALTER TABLE `requiredsubtypeequipped`
  ADD CONSTRAINT `fk_RequiredSubtypeEquipped_ItemsSousTypes1` FOREIGN KEY (`idSousType`) REFERENCES `itemssoustypes` (`idSousType`),
  ADD CONSTRAINT `fk_RequiredSubtypeEquipped_Skills1` FOREIGN KEY (`idSkill`) REFERENCES `skills` (`idSkill`);

--
-- Contraintes pour la table `secondarystatselementalresistsrepartition`
--
ALTER TABLE `secondarystatselementalresistsrepartition`
  ADD CONSTRAINT `fk_SecondaryStatsElementalResistsRepartition_ElementsTypes1` FOREIGN KEY (`idElementType`) REFERENCES `elementstypes` (`idElementType`),
  ADD CONSTRAINT `fk_SecondaryStatsElementalResistsRepartition_StatsProfil1` FOREIGN KEY (`idStatsProfil`) REFERENCES `statsprofil` (`idStatsProfil`);

--
-- Contraintes pour la table `secondarystatsrepartition`
--
ALTER TABLE `secondarystatsrepartition`
  ADD CONSTRAINT `fk_SecondaryStatsRepartition_SecondaryStats1` FOREIGN KEY (`idSecondaryStat`) REFERENCES `secondarystats` (`idSecondaryStat`),
  ADD CONSTRAINT `fk_SecondaryStatsRepartition_StatsProfil1` FOREIGN KEY (`idStatsProfil`) REFERENCES `statsprofil` (`idStatsProfil`);

--
-- Contraintes pour la table `sellableitems`
--
ALTER TABLE `sellableitems`
  ADD CONSTRAINT `fk_SellableItems_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`),
  ADD CONSTRAINT `fk_SellableItems_RebirthsPossibles1` FOREIGN KEY (`rebirthLevel`) REFERENCES `rebirthspossibles` (`rebirthLevel`);

--
-- Contraintes pour la table `shopitems`
--
ALTER TABLE `shopitems`
  ADD CONSTRAINT `fk_ShopItems_SellableItems1` FOREIGN KEY (`idSellableItems`) REFERENCES `sellableitems` (`idSellableItems`),
  ADD CONSTRAINT `fk_ShopItems_Shop1` FOREIGN KEY (`idShop`) REFERENCES `shop` (`idShop`);

--
-- Contraintes pour la table `skills`
--
ALTER TABLE `skills`
  ADD CONSTRAINT `fk_Skills_SkillsTypes1` FOREIGN KEY (`idSkillType`) REFERENCES `skillstypes` (`idSkillType`),
  ADD CONSTRAINT `fk_Skills_TargetRange1` FOREIGN KEY (`idTargetRange`) REFERENCES `targetrange` (`idTargetRange`);

--
-- Contraintes pour la table `spawnedbosses`
--
ALTER TABLE `spawnedbosses`
  ADD CONSTRAINT `fk_SpawnedBosses_Bosses1` FOREIGN KEY (`idBoss`) REFERENCES `bosses` (`idBoss`);

--
-- Contraintes pour la table `spawnedbossesareas`
--
ALTER TABLE `spawnedbossesareas`
  ADD CONSTRAINT `fk_SpawnedBossesAreas_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`),
  ADD CONSTRAINT `fk_SpawnedBossesAreas_SpawnedBosses1` FOREIGN KEY (`idSpawnedBoss`) REFERENCES `spawnedbosses` (`idSpawnedBoss`);

--
-- Contraintes pour la table `states`
--
ALTER TABLE `states`
  ADD CONSTRAINT `fk_States_StatesRestrictions1` FOREIGN KEY (`idStateRestriction`) REFERENCES `statesrestrictions` (`idStateRestriction`);

--
-- Contraintes pour la table `statesremovalconditions`
--
ALTER TABLE `statesremovalconditions`
  ADD CONSTRAINT `fk_StatesRemovalConditions_States1` FOREIGN KEY (`idState`) REFERENCES `states` (`idState`);

--
-- Contraintes pour la table `statestraits`
--
ALTER TABLE `statestraits`
  ADD CONSTRAINT `fk_StatesTraits_States1` FOREIGN KEY (`idState`) REFERENCES `states` (`idState`),
  ADD CONSTRAINT `fk_StatesTraits_Traits1` FOREIGN KEY (`idTrait`) REFERENCES `traits` (`idTrait`);

--
-- Contraintes pour la table `statscharacters`
--
ALTER TABLE `statscharacters`
  ADD CONSTRAINT `fk_StatsCharacters_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`),
  ADD CONSTRAINT `fk_StatsCharacters_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`);

--
-- Contraintes pour la table `statsmonstres`
--
ALTER TABLE `statsmonstres`
  ADD CONSTRAINT `fk_StatsMonstres_MonstersBuildsProfil1` FOREIGN KEY (`idMonstersBuildsProfil`) REFERENCES `monstersbuildsprofil` (`idMonstersBuildsProfil`),
  ADD CONSTRAINT `fk_StatsMonstres_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`),
  ADD CONSTRAINT `fk_StatsMonstres_StatsProfil1` FOREIGN KEY (`idStatsProfil`) REFERENCES `statsprofil` (`idStatsProfil`);

--
-- Contraintes pour la table `statsrepartition`
--
ALTER TABLE `statsrepartition`
  ADD CONSTRAINT `fk_StatsRepartition_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`),
  ADD CONSTRAINT `fk_StatsRepartition_StatsProfil1` FOREIGN KEY (`idStatsProfil`) REFERENCES `statsprofil` (`idStatsProfil`);

--
-- Contraintes pour la table `traits`
--
ALTER TABLE `traits`
  ADD CONSTRAINT `fk_Traits_ElementsTypes1` FOREIGN KEY (`valueElementType`) REFERENCES `elementstypes` (`idElementType`),
  ADD CONSTRAINT `fk_Traits_SecondaryStats1` FOREIGN KEY (`valueSecondaryStat`) REFERENCES `secondarystats` (`idSecondaryStat`),
  ADD CONSTRAINT `fk_Traits_Skills1` FOREIGN KEY (`valueSkill`) REFERENCES `skills` (`idSkill`),
  ADD CONSTRAINT `fk_Traits_SkillsTypes1` FOREIGN KEY (`valueSkillType`) REFERENCES `skillstypes` (`idSkillType`),
  ADD CONSTRAINT `fk_Traits_States1` FOREIGN KEY (`valueState`) REFERENCES `states` (`idState`),
  ADD CONSTRAINT `fk_Traits_Stats1` FOREIGN KEY (`valueStat`) REFERENCES `stats` (`idStat`),
  ADD CONSTRAINT `fk_Traits_TraitsTypes1` FOREIGN KEY (`idTraitType`) REFERENCES `traitstypes` (`idTraitType`);

--
-- Contraintes pour la table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_Users_Character` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`);

--
-- Contraintes pour la table `userspreferences`
--
ALTER TABLE `userspreferences`
  ADD CONSTRAINT `fk_UsersPreferences_Users1` FOREIGN KEY (`idUser`) REFERENCES `users` (`idUser`);

--
-- Contraintes pour la table `wbrewardstates`
--
ALTER TABLE `wbrewardstates`
  ADD CONSTRAINT `fk_WBRewardStates_SpawnedBosses1` FOREIGN KEY (`idSpawnedBoss`) REFERENCES `spawnedbosses` (`idSpawnedBoss`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
