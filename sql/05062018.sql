-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Mar 05 Juin 2018 à 05:34
-- Version du serveur :  5.7.14
-- Version de PHP :  7.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `discord_bot_rpg`
--

-- --------------------------------------------------------

--
-- Structure de la table `areas`
--

CREATE TABLE `areas` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `AreaName` varchar(255) NOT NULL,
  `AreaDesc` varchar(255) DEFAULT NULL,
  `AreaImage` varchar(255) NOT NULL DEFAULT 'https://cdn.pixabay.com/photo/2013/04/06/11/50/image-editing-101040_960_720.jpg',
  `AreaLevels` varchar(45) NOT NULL DEFAULT '1 - 2',
  `idAreaType` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `areas`
--

INSERT INTO `areas` (`idArea`, `AreaName`, `AreaDesc`, `AreaImage`, `AreaLevels`, `idAreaType`) VALUES
(1, 'Forêt de Buldaar', 'Cette forêt accueille un très grand nombre de débutants souhaitant partir à l\'aventure, malheureusement pour eux, l\'aventure n\'est pas de tout repos, même ici.', 'https://c1.staticflickr.com/6/5082/5260289771_1e133585fb_b.jpg', '01-05', 1),
(2, 'Plaines Rocheuses', 'Cette plaine est remplie de magie, des Golems sont nés de cette magie et depuis ils errent ici.', 'https://cdn.pixabay.com/photo/2015/10/27/08/53/landscape-1008572_960_720.jpg', '05-10', 1),
(3, 'Impasse de Lirayl', 'Autrefois cette impasse bourdonnait de vie, mais depuis des années un mal ronge la terre et détruit tout sur son passage.', 'https://d2v9y0dukr6mq2.cloudfront.net/video/thumbnail/2czqMab/forest-fire-mountain-tree-destruction-burn-p-hd-0930_vkgzsxlof__F0000.png', '10-15', 1),
(4, 'Jungle de Baanar', 'C\'est une jungle ! ', 'http://s1.thingpic.com/images/86/6fS2n1Y7d9S7yHdemFr5Ys6Q.jpeg', '15-20', 1),
(5, 'Bradford', 'Bradford est un emplacement très intéressant, et sert de camp de repos à bon nombre d\'aventuriers.', 'https://i.ytimg.com/vi/8yIEOPa9PAs/maxresdefault.jpg', '20', 2),
(6, 'Fishford', 'Un village de pêcheur, mais celui-ci n\'attends qu\'à être étendu.', 'http://i.imgur.com/B7lYXrd.jpg', '01', 2);

-- --------------------------------------------------------

--
-- Structure de la table `areasitems`
--

CREATE TABLE `areasitems` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `areasitems`
--

INSERT INTO `areasitems` (`idArea`, `idBaseItem`) VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 2),
(4, 2),
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(1, 4),
(2, 4),
(1, 5),
(3, 5),
(4, 5),
(1, 6),
(2, 6),
(3, 6),
(4, 6),
(1, 7),
(2, 7),
(1, 8),
(2, 8),
(3, 8),
(4, 8),
(1, 9),
(3, 9),
(4, 9),
(1, 10),
(2, 10),
(1, 11),
(2, 11),
(3, 11),
(4, 11),
(1, 12),
(2, 12),
(3, 12),
(4, 12),
(2, 13),
(3, 14),
(3, 15),
(3, 16),
(4, 17),
(4, 18),
(4, 19);

-- --------------------------------------------------------

--
-- Structure de la table `areasmonsters`
--

CREATE TABLE `areasmonsters` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idMonstre` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `areasmonsters`
--

INSERT INTO `areasmonsters` (`idArea`, `idMonstre`) VALUES
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
(4, 28);

-- --------------------------------------------------------

--
-- Structure de la table `areasowners`
--

CREATE TABLE `areasowners` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idGuild` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `areasowners`
--

INSERT INTO `areasowners` (`idArea`, `idGuild`) VALUES
(1, 11),
(2, 11);

-- --------------------------------------------------------

--
-- Structure de la table `areasresources`
--

CREATE TABLE `areasresources` (
  `idArea` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `areasresources`
--

INSERT INTO `areasresources` (`idArea`, `idBaseItem`) VALUES
(1, 20),
(1, 21),
(1, 22);

-- --------------------------------------------------------

--
-- Structure de la table `areastypes`
--

CREATE TABLE `areastypes` (
  `idAreaType` int(10) UNSIGNED NOT NULL,
  `NomAreaType` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `areastypes`
--

INSERT INTO `areastypes` (`idAreaType`, `NomAreaType`) VALUES
(1, 'wild'),
(2, 'city'),
(3, 'dungeon');

-- --------------------------------------------------------

--
-- Structure de la table `characters`
--

CREATE TABLE `characters` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `statPoints` int(10) UNSIGNED NOT NULL,
  `money` int(10) UNSIGNED NOT NULL,
  `idArea` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `characters`
--

INSERT INTO `characters` (`idCharacter`, `statPoints`, `money`, `idArea`) VALUES
(1, 0, 984198, 5),
(2, 0, 27771, 4),
(3, 0, 129, 1),
(4, 5, 100, 1),
(5, 0, 299, 2),
(6, 0, 1404, 2),
(7, 0, 108, 1),
(8, 5, 283, 1),
(9, 5, 100, 1),
(10, 0, 122, 1),
(11, 5, 115, 1),
(12, 5, 100, 1),
(13, 5, 100, 1),
(14, 0, 805, 2),
(15, 0, 2619, 4),
(16, 5, 100, 1),
(17, 0, 102, 1),
(18, 0, 101, 1),
(19, 5, 100, 2),
(20, 0, 110928, 1);

-- --------------------------------------------------------

--
-- Structure de la table `charactersequipements`
--

CREATE TABLE `charactersequipements` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idItem` int(10) UNSIGNED NOT NULL,
  `idType` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `charactersequipements`
--

INSERT INTO `charactersequipements` (`idCharacter`, `idItem`, `idType`) VALUES
(5, 73, 3),
(5, 79, 4),
(5, 102, 2),
(5, 104, 1),
(6, 105, 3),
(6, 117, 1),
(7, 124, 2),
(7, 125, 4),
(6, 126, 2),
(6, 127, 4),
(8, 164, 4),
(8, 165, 1),
(8, 166, 2),
(8, 167, 3),
(1, 170, 1),
(3, 178, 2),
(1, 206, 2),
(1, 227, 3),
(10, 243, 3),
(3, 255, 4),
(14, 270, 2),
(14, 296, 3),
(14, 297, 4),
(14, 307, 1),
(11, 354, 1),
(11, 355, 2),
(2, 363, 3),
(2, 376, 2),
(2, 406, 1),
(1, 468, 4),
(17, 487, 1),
(15, 489, 3),
(15, 490, 4),
(2, 511, 4),
(15, 524, 1),
(15, 526, 2),
(20, 597, 3),
(20, 599, 4),
(20, 608, 1);

-- --------------------------------------------------------

--
-- Structure de la table `charactershonor`
--

CREATE TABLE `charactershonor` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `Honor` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `charactershonor`
--

INSERT INTO `charactershonor` (`idCharacter`, `Honor`) VALUES
(1, 52),
(2, 8),
(3, 0),
(4, 0),
(5, 0),
(6, 0),
(7, 0),
(8, 0),
(9, 0),
(10, 0),
(11, 0),
(12, 0),
(13, 0),
(14, 1),
(15, 1),
(16, 0),
(17, 0),
(18, 0),
(19, 0),
(20, 1);

-- --------------------------------------------------------

--
-- Structure de la table `charactersinventory`
--

CREATE TABLE `charactersinventory` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idItem` int(10) UNSIGNED NOT NULL,
  `number` int(10) UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `charactersinventory`
--

INSERT INTO `charactersinventory` (`idCharacter`, `idItem`, `number`) VALUES
(2, 201, 1),
(2, 249, 1),
(2, 251, 1),
(2, 402, 1),
(2, 423, 1),
(2, 439, 1),
(2, 505, 1),
(2, 506, 1),
(2, 507, 1),
(2, 508, 1),
(2, 509, 1),
(2, 510, 1),
(2, 515, 1),
(2, 532, 1),
(2, 534, 1),
(2, 554, 1),
(2, 555, 1),
(2, 556, 1),
(3, 53, 1),
(5, 86, 1),
(5, 93, 1),
(5, 103, 1),
(5, 106, 1),
(5, 570, 1),
(7, 466, 1),
(8, 168, 1),
(8, 368, 1),
(10, 244, 1),
(10, 246, 1),
(11, 353, 1),
(14, 298, 1),
(14, 299, 1),
(14, 300, 1),
(14, 301, 1),
(14, 303, 1),
(14, 304, 1),
(14, 305, 1),
(15, 289, 1),
(15, 293, 1),
(15, 440, 1),
(15, 464, 1),
(15, 488, 1),
(15, 491, 1),
(15, 492, 1),
(15, 493, 1),
(15, 502, 1),
(15, 503, 1),
(15, 504, 1),
(15, 516, 1),
(15, 517, 1),
(15, 518, 1),
(15, 519, 1),
(15, 520, 1),
(15, 521, 1),
(15, 522, 1),
(15, 523, 1),
(15, 525, 1),
(15, 527, 1),
(15, 528, 1),
(15, 529, 1),
(15, 530, 1),
(15, 531, 1),
(15, 533, 1),
(15, 535, 1),
(15, 536, 1),
(15, 537, 1),
(18, 558, 1),
(20, 562, 1),
(20, 600, 1),
(20, 601, 1),
(20, 602, 1),
(20, 603, 1),
(20, 604, 1),
(20, 605, 1),
(20, 607, 1);

-- --------------------------------------------------------

--
-- Structure de la table `guilds`
--

CREATE TABLE `guilds` (
  `idGuild` int(10) UNSIGNED NOT NULL,
  `nom` varchar(255) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `level` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `argent` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `guilds`
--

INSERT INTO `guilds` (`idGuild`, `nom`, `message`, `level`, `argent`) VALUES
(2, 'NomDeLaGuilde', '', 1, 100),
(6, 'Bogoss', '', 1, 0),
(7, 'fabulous', '', 1, 0),
(11, 'Laputa', '', 1, 0);

-- --------------------------------------------------------

--
-- Structure de la table `guildsappliances`
--

CREATE TABLE `guildsappliances` (
  `idGuild` int(10) UNSIGNED NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `guildsappliances`
--

INSERT INTO `guildsappliances` (`idGuild`, `idCharacter`) VALUES
(2, 7);

-- --------------------------------------------------------

--
-- Structure de la table `guildsmembers`
--

CREATE TABLE `guildsmembers` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `idGuild` int(10) UNSIGNED NOT NULL,
  `idGuildRank` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `guildsmembers`
--

INSERT INTO `guildsmembers` (`idCharacter`, `idGuild`, `idGuildRank`) VALUES
(15, 11, 1),
(1, 11, 3),
(2, 2, 3),
(3, 7, 3),
(5, 6, 3);

-- --------------------------------------------------------

--
-- Structure de la table `guildsranks`
--

CREATE TABLE `guildsranks` (
  `idGuildRank` int(10) UNSIGNED NOT NULL,
  `nom` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `guildsranks`
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
  `idItem` int(10) UNSIGNED NOT NULL,
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `level` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `items`
--

INSERT INTO `items` (`idItem`, `idBaseItem`, `level`) VALUES
(53, 4, 1),
(73, 7, 2),
(79, 12, 3),
(86, 5, 3),
(93, 2, 3),
(102, 5, 5),
(103, 4, 5),
(104, 2, 5),
(105, 9, 5),
(106, 1, 5),
(117, 3, 7),
(124, 6, 1),
(125, 10, 1),
(126, 4, 10),
(127, 12, 9),
(164, 11, 4),
(165, 1, 5),
(166, 4, 5),
(167, 7, 5),
(168, 1, 3),
(170, 14, 15),
(178, 4, 2),
(201, 17, 20),
(206, 18, 20),
(214, 17, 20),
(227, 19, 20),
(243, 8, 1),
(244, 8, 1),
(246, 7, 1),
(249, 20, 1),
(251, 21, 1),
(255, 11, 1),
(270, 6, 4),
(289, 6, 3),
(293, 9, 5),
(296, 8, 6),
(297, 11, 7),
(298, 2, 6),
(299, 10, 6),
(300, 7, 6),
(301, 4, 6),
(303, 7, 6),
(304, 4, 5),
(305, 10, 7),
(307, 2, 7),
(353, 2, 2),
(354, 2, 2),
(355, 5, 2),
(363, 19, 20),
(368, 6, 1),
(376, 18, 20),
(402, 17, 20),
(406, 3, 20),
(423, 6, 20),
(439, 3, 20),
(440, 12, 6),
(464, 13, 6),
(466, 4, 1),
(468, 17, 20),
(487, 3, 1),
(488, 2, 11),
(489, 9, 11),
(490, 15, 12),
(491, 6, 10),
(492, 3, 13),
(493, 2, 13),
(502, 9, 13),
(503, 5, 14),
(504, 8, 14),
(505, 12, 16),
(506, 8, 20),
(507, 12, 20),
(508, 11, 20),
(509, 2, 20),
(510, 11, 20),
(511, 17, 20),
(515, 3, 20),
(516, 5, 14),
(517, 5, 11),
(518, 3, 13),
(519, 5, 14),
(520, 3, 14),
(521, 2, 15),
(522, 2, 11),
(523, 5, 10),
(524, 14, 15),
(525, 2, 15),
(526, 6, 15),
(527, 8, 15),
(528, 11, 15),
(529, 2, 14),
(530, 12, 15),
(531, 12, 15),
(532, 6, 20),
(533, 11, 15),
(534, 8, 20),
(535, 5, 17),
(536, 11, 19),
(537, 3, 17),
(554, 5, 18),
(555, 2, 20),
(556, 8, 20),
(558, 9, 1),
(562, 1, 1),
(570, 6, 6),
(597, 8, 2),
(599, 11, 2),
(600, 4, 2),
(601, 8, 2),
(602, 7, 2),
(603, 8, 2),
(604, 10, 2),
(605, 1, 2),
(607, 10, 4),
(608, 3, 1);

-- --------------------------------------------------------

--
-- Structure de la table `itemsbase`
--

CREATE TABLE `itemsbase` (
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `nomItem` varchar(50) NOT NULL,
  `descItem` varchar(255) DEFAULT NULL,
  `idType` int(10) UNSIGNED NOT NULL,
  `idRarity` int(10) UNSIGNED NOT NULL,
  `imageItem` varchar(255) NOT NULL DEFAULT 'unknown'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `itemsbase`
--

INSERT INTO `itemsbase` (`idBaseItem`, `nomItem`, `descItem`, `idType`, `idRarity`, `imageItem`) VALUES
(1, 'Epée en Bois', 'Une simple épée d\'entrainement.', 1, 1, 'unknown'),
(2, 'Epée en fer', 'Une épée de simple facture.', 1, 2, 'unknown'),
(3, 'Epée en acier forgé', 'Une épée de très bonne facture.', 1, 3, 'unknown'),
(4, 'Armure de débutant', 'Une armure très basique.', 2, 1, 'unknown'),
(5, 'Armure d\'aventurier', 'Une armure digne d\'un aventurier.', 2, 2, 'unknown'),
(6, 'Armure magique', 'Une armure magique.', 2, 3, 'unknown'),
(7, 'Jambières de débutant', 'Des jambières très basiques.', 3, 1, 'unknown'),
(8, 'Jambières d\'aventurier', 'Des jambières dignes d\'un aventurier.', 3, 2, 'unknown'),
(9, 'Jambières magiques', 'Des jambières magiques.', 3, 3, 'unknown'),
(10, 'Casque de débutant', 'Un casque très basique.', 4, 1, 'unknown'),
(11, 'Casque d\'aventurier', 'Un casque digne d\'un aventurier.', 4, 2, 'unknown'),
(12, 'Casque magique', 'Un casque magique.', 4, 3, 'unknown'),
(13, 'Epée élémentaire', 'Une épée imprégnée de l\'énergie d\'un Golem.', 1, 5, 'unknown'),
(14, 'Épée imprégnée de chaos', 'Cette épée vibre dans votre main, elle semble ne pas vouloir tenir en place.', 1, 4, 'epeechaos'),
(15, 'Casque de chevalier maléfique', 'Ce casque semble vous appeler. Il est d\'un noir profond.', 4, 4, 'unknown'),
(16, 'Culotte de géant', 'C\'est grand, très grand. Il a plusieurs traces et vous n\'avez vraiment pas envie de savoir ce que c\'est.\r\nMais après tout, ça à l\'air résistant, pourquoi pas le porter ?', 3, 5, 'unknown'),
(17, 'Masque sacré Maatan', 'Ce masque est une relique du clan Maatan, je pense qu\'ils n\'apprécient pas que vous l\'ayez.', 4, 5, 'masquemaatan'),
(18, 'Armure d\'os', 'Vous avez vu, vous avez vaincu et vous porter vos ennemis sur vous.', 2, 4, 'armureos'),
(19, 'Pagne de Maatan usagé', 'Il a déjà servi, mais peut encore servir, en plus vous aimez son odeur.', 3, 4, 'unknown'),
(20, 'Bois de Frêne', 'Bois très commun que l\'on retrouve presque partout, il sert surtout à la construction.', 5, 1, 'unknown'),
(21, 'Pierre Brute', 'De la pierre brute.', 6, 1, 'unknown'),
(22, 'Lichen du pauvre', 'Il paraît que ça peut servir.', 7, 1, 'unknown');

-- --------------------------------------------------------

--
-- Structure de la table `itemsrarities`
--

CREATE TABLE `itemsrarities` (
  `idRarity` int(10) UNSIGNED NOT NULL,
  `nomRarity` varchar(45) NOT NULL,
  `couleurRarity` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `itemsrarities`
--

INSERT INTO `itemsrarities` (`idRarity`, `nomRarity`, `couleurRarity`) VALUES
(1, 'Commun', '#FFFFFF'),
(2, 'Rare', '#00FF00'),
(3, 'Supérieur', '#0000FF'),
(4, 'Epique', '#FF00FF'),
(5, 'Légendaire', '#C80000');

-- --------------------------------------------------------

--
-- Structure de la table `itemsstats`
--

CREATE TABLE `itemsstats` (
  `idItem` int(10) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `value` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `itemsstats`
--

INSERT INTO `itemsstats` (`idItem`, `idStat`, `value`) VALUES
(53, 4, 1),
(73, 4, 1),
(79, 4, 2),
(79, 6, 4),
(79, 9, 3),
(86, 4, 1),
(86, 7, 2),
(93, 1, 3),
(93, 8, 2),
(102, 2, 3),
(102, 4, 2),
(103, 4, 2),
(104, 1, 4),
(104, 3, 3),
(105, 3, 4),
(105, 4, 4),
(105, 9, 6),
(106, 1, 2),
(117, 1, 6),
(117, 2, 8),
(117, 7, 7),
(124, 2, 1),
(124, 4, 1),
(124, 8, 1),
(125, 4, 1),
(126, 4, 4),
(127, 4, 12),
(127, 5, 10),
(127, 10, 7),
(164, 3, 2),
(164, 4, 2),
(165, 1, 2),
(166, 4, 1),
(167, 4, 2),
(168, 1, 1),
(170, 1, 21),
(170, 2, 22),
(170, 5, 16),
(170, 7, 18),
(178, 4, 1),
(201, 1, 23),
(201, 4, 89),
(201, 5, 22),
(201, 9, 31),
(201, 10, 20),
(206, 1, 27),
(206, 4, 65),
(206, 8, 18),
(206, 10, 26),
(214, 1, 28),
(214, 3, 21),
(214, 4, 73),
(214, 8, 25),
(214, 9, 37),
(227, 3, 31),
(227, 4, 67),
(227, 5, 32),
(227, 8, 19),
(243, 4, 1),
(243, 5, 1),
(244, 4, 1),
(244, 6, 1),
(246, 4, 1),
(255, 2, 1),
(255, 4, 1),
(270, 4, 2),
(270, 7, 5),
(270, 8, 3),
(289, 3, 4),
(289, 4, 1),
(289, 7, 2),
(293, 1, 5),
(293, 4, 4),
(293, 8, 3),
(296, 4, 3),
(296, 10, 3),
(297, 4, 4),
(297, 9, 4),
(298, 1, 4),
(298, 6, 5),
(299, 4, 2),
(300, 4, 2),
(301, 4, 2),
(303, 4, 1),
(304, 4, 1),
(305, 4, 2),
(307, 1, 3),
(307, 6, 3),
(353, 1, 2),
(353, 5, 1),
(354, 1, 2),
(354, 2, 2),
(355, 4, 1),
(355, 6, 1),
(363, 3, 24),
(363, 4, 76),
(363, 8, 19),
(363, 10, 29),
(368, 4, 1),
(368, 9, 1),
(368, 10, 1),
(376, 1, 32),
(376, 3, 22),
(376, 4, 43),
(376, 5, 29),
(402, 4, 87),
(402, 7, 38),
(402, 8, 34),
(402, 9, 28),
(402, 10, 30),
(406, 1, 19),
(406, 4, 60),
(406, 7, 24),
(423, 4, 50),
(423, 6, 18),
(423, 7, 23),
(439, 1, 13),
(439, 3, 24),
(439, 8, 15),
(440, 2, 8),
(440, 4, 6),
(440, 9, 6),
(464, 1, 7),
(464, 2, 8),
(464, 3, 8),
(464, 4, 9),
(464, 5, 10),
(466, 4, 1),
(468, 1, 31),
(468, 3, 40),
(468, 4, 102),
(468, 5, 35),
(468, 7, 40),
(487, 1, 2),
(487, 2, 2),
(487, 6, 1),
(488, 1, 5),
(488, 5, 7),
(489, 1, 8),
(489, 4, 12),
(489, 5, 12),
(490, 3, 19),
(490, 4, 20),
(490, 5, 12),
(490, 8, 11),
(491, 1, 8),
(491, 4, 11),
(491, 10, 7),
(492, 1, 16),
(492, 6, 9),
(492, 8, 12),
(493, 1, 10),
(493, 7, 6),
(502, 4, 21),
(502, 8, 9),
(502, 9, 12),
(503, 3, 10),
(503, 4, 20),
(504, 2, 9),
(504, 4, 13),
(505, 3, 11),
(505, 4, 24),
(505, 5, 19),
(506, 3, 16),
(506, 4, 24),
(507, 4, 54),
(507, 8, 20),
(507, 9, 17),
(508, 2, 13),
(508, 4, 41),
(509, 1, 12),
(509, 5, 9),
(510, 4, 32),
(510, 7, 9),
(511, 1, 25),
(511, 4, 93),
(511, 5, 26),
(511, 7, 24),
(511, 10, 40),
(515, 1, 18),
(515, 2, 16),
(515, 5, 17),
(516, 4, 13),
(516, 10, 6),
(517, 4, 11),
(517, 7, 9),
(518, 1, 10),
(518, 7, 13),
(518, 9, 9),
(519, 4, 18),
(519, 7, 7),
(520, 1, 11),
(520, 5, 12),
(520, 7, 13),
(521, 1, 12),
(521, 8, 12),
(522, 1, 8),
(522, 6, 6),
(523, 4, 7),
(523, 7, 8),
(524, 1, 18),
(524, 3, 17),
(524, 7, 21),
(524, 8, 24),
(525, 1, 12),
(525, 4, 13),
(526, 1, 18),
(526, 4, 28),
(526, 6, 15),
(527, 4, 14),
(527, 10, 12),
(528, 3, 12),
(528, 4, 16),
(529, 1, 8),
(529, 10, 11),
(530, 1, 15),
(530, 3, 14),
(530, 4, 27),
(531, 1, 9),
(531, 4, 33),
(531, 6, 12),
(532, 4, 60),
(532, 5, 15),
(532, 7, 21),
(533, 4, 16),
(533, 9, 11),
(534, 4, 39),
(534, 5, 13),
(535, 4, 18),
(535, 5, 10),
(536, 3, 9),
(536, 4, 28),
(537, 1, 16),
(537, 7, 17),
(537, 10, 19),
(554, 4, 17),
(554, 10, 10),
(555, 1, 9),
(555, 2, 9),
(556, 4, 37),
(556, 10, 15),
(558, 1, 2),
(558, 4, 1),
(558, 9, 2),
(562, 1, 1),
(570, 4, 5),
(570, 5, 6),
(570, 10, 7),
(597, 4, 1),
(597, 6, 2),
(599, 3, 2),
(599, 4, 1),
(600, 4, 1),
(601, 4, 1),
(601, 8, 1),
(602, 4, 1),
(603, 4, 1),
(603, 7, 2),
(604, 4, 1),
(605, 1, 1),
(607, 4, 1),
(608, 1, 2),
(608, 2, 1),
(608, 9, 1);

-- --------------------------------------------------------

--
-- Structure de la table `itemstypes`
--

CREATE TABLE `itemstypes` (
  `idType` int(10) UNSIGNED NOT NULL,
  `nomType` varchar(45) NOT NULL,
  `equipable` tinyint(4) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `itemstypes`
--

INSERT INTO `itemstypes` (`idType`, `nomType`, `equipable`) VALUES
(1, 'weapon', 1),
(2, 'chest', 1),
(3, 'legs', 1),
(4, 'head', 1),
(5, 'wood', 0),
(6, 'stone', 0),
(7, 'herb', 0);

-- --------------------------------------------------------

--
-- Structure de la table `levels`
--

CREATE TABLE `levels` (
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `actualExp` int(10) UNSIGNED NOT NULL,
  `actualLevel` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `levels`
--

INSERT INTO `levels` (`idCharacter`, `actualExp`, `actualLevel`) VALUES
(1, 0, 20),
(2, 0, 20),
(3, 42, 3),
(4, 0, 1),
(5, 328, 6),
(6, 305, 11),
(7, 8, 2),
(8, 31, 6),
(9, 0, 1),
(10, 28, 3),
(11, 8, 3),
(12, 0, 1),
(13, 0, 1),
(14, 812, 8),
(15, 8537, 18),
(16, 0, 1),
(17, 2, 2),
(18, 1, 1),
(19, 0, 1),
(20, 67, 4);

-- --------------------------------------------------------

--
-- Structure de la table `levelsrequire`
--

CREATE TABLE `levelsrequire` (
  `level` int(10) UNSIGNED NOT NULL,
  `expNextLevel` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `levelsrequire`
--

INSERT INTO `levelsrequire` (`level`, `expNextLevel`) VALUES
(1, 2),
(2, 24),
(3, 62),
(4, 136),
(5, 258),
(6, 440),
(7, 694),
(8, 1032),
(9, 1466),
(10, 2008),
(11, 2670),
(12, 3464),
(13, 4402),
(14, 5496),
(15, 6758),
(16, 8200),
(17, 9834),
(18, 11672),
(19, 13726),
(20, 16008);

-- --------------------------------------------------------

--
-- Structure de la table `monstres`
--

CREATE TABLE `monstres` (
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `avglevel` int(10) UNSIGNED NOT NULL,
  `idType` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `monstres`
--

INSERT INTO `monstres` (`idMonstre`, `name`, `avglevel`, `idType`) VALUES
(1, 'Feu Follet', 1, 1),
(2, 'Slime', 2, 1),
(3, 'Slime Empoisoné', 3, 1),
(4, 'Araignée Arboricole', 4, 1),
(5, 'Loup', 5, 1),
(6, 'Golem de terre', 5, 1),
(7, 'Golem de pierre', 6, 1),
(8, 'Golem de magma', 7, 1),
(9, 'Golem d\'eau', 8, 1),
(10, 'Golem d\'air', 9, 1),
(11, 'Golem des tempêtes', 10, 1),
(12, 'Golem arcanique', 10, 2),
(13, 'Serpent des roches', 10, 1),
(14, 'Basilic de pierre', 11, 1),
(15, 'Ver foreur', 12, 1),
(16, 'Vautour ensanglanté', 13, 1),
(17, 'Hyène', 14, 1),
(18, 'Harpie', 15, 1),
(19, 'Géant torturé', 15, 2),
(20, 'Goule monstrueuse', 15, 2),
(21, 'Serpent de la jungle', 15, 1),
(22, 'Tigre féroce', 16, 1),
(23, 'Raptor solitaire', 17, 1),
(24, 'Gorille dominant', 18, 1),
(25, 'Ours balafré', 19, 1),
(26, 'Alligator imposant', 20, 1),
(27, 'Guerrier Maatan', 20, 2),
(28, 'Chasseur Maatan', 20, 2);

-- --------------------------------------------------------

--
-- Structure de la table `monstrestypes`
--

CREATE TABLE `monstrestypes` (
  `idType` int(10) UNSIGNED NOT NULL,
  `nom` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `monstrestypes`
--

INSERT INTO `monstrestypes` (`idType`, `nom`) VALUES
(1, 'Normal'),
(2, 'Elite');

-- --------------------------------------------------------

--
-- Structure de la table `stats`
--

CREATE TABLE `stats` (
  `idStat` int(10) UNSIGNED NOT NULL,
  `nom` varchar(60) NOT NULL,
  `desc` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `stats`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `statscharacters`
--

INSERT INTO `statscharacters` (`idCharacter`, `idStat`, `value`) VALUES
(1, 1, 30),
(1, 2, 0),
(1, 3, 70),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(1, 7, 0),
(1, 8, 0),
(1, 9, 0),
(1, 10, 0),
(2, 1, 30),
(2, 2, 0),
(2, 3, 48),
(2, 4, 0),
(2, 5, 22),
(2, 6, 0),
(2, 7, 0),
(2, 8, 0),
(2, 9, 0),
(2, 10, 0),
(3, 1, 7),
(3, 2, 0),
(3, 3, 8),
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
(5, 1, 10),
(5, 2, 0),
(5, 3, 15),
(5, 4, 0),
(5, 5, 5),
(5, 6, 0),
(5, 7, 0),
(5, 8, 0),
(5, 9, 0),
(5, 10, 0),
(6, 1, 25),
(6, 2, 0),
(6, 3, 20),
(6, 4, 0),
(6, 5, 10),
(6, 6, 0),
(6, 7, 0),
(6, 8, 0),
(6, 9, 0),
(6, 10, 0),
(7, 1, 6),
(7, 2, 0),
(7, 3, 4),
(7, 4, 0),
(7, 5, 0),
(7, 6, 0),
(7, 7, 0),
(7, 8, 0),
(7, 9, 0),
(7, 10, 0),
(8, 1, 14),
(8, 2, 0),
(8, 3, 9),
(8, 4, 0),
(8, 5, 2),
(8, 6, 0),
(8, 7, 0),
(8, 8, 0),
(8, 9, 0),
(8, 10, 0),
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
(10, 1, 5),
(10, 2, 0),
(10, 3, 10),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(10, 7, 0),
(10, 8, 0),
(10, 9, 0),
(10, 10, 0),
(11, 1, 8),
(11, 2, 0),
(11, 3, 2),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(11, 7, 0),
(11, 8, 0),
(11, 9, 0),
(11, 10, 0),
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
(13, 1, 0),
(13, 2, 0),
(13, 3, 0),
(13, 4, 0),
(13, 5, 0),
(13, 6, 0),
(13, 7, 0),
(13, 8, 0),
(13, 9, 0),
(13, 10, 0),
(14, 1, 25),
(14, 2, 0),
(14, 3, 12),
(14, 4, 0),
(14, 5, 0),
(14, 6, 0),
(14, 7, 0),
(14, 8, 0),
(14, 9, 0),
(14, 10, 3),
(15, 1, 35),
(15, 2, 0),
(15, 3, 45),
(15, 4, 0),
(15, 5, 0),
(15, 6, 0),
(15, 7, 0),
(15, 8, 0),
(15, 9, 10),
(15, 10, 0),
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
(17, 1, 5),
(17, 2, 0),
(17, 3, 5),
(17, 4, 0),
(17, 5, 0),
(17, 6, 0),
(17, 7, 0),
(17, 8, 0),
(17, 9, 0),
(17, 10, 0),
(18, 1, 3),
(18, 2, 0),
(18, 3, 2),
(18, 4, 0),
(18, 5, 0),
(18, 6, 0),
(18, 7, 0),
(18, 8, 0),
(18, 9, 0),
(18, 10, 0),
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
(20, 1, 8),
(20, 2, 0),
(20, 3, 7),
(20, 4, 0),
(20, 5, 0),
(20, 6, 0),
(20, 7, 0),
(20, 8, 5),
(20, 9, 0),
(20, 10, 0);

-- --------------------------------------------------------

--
-- Structure de la table `statsmonstres`
--

CREATE TABLE `statsmonstres` (
  `idMonstre` int(10) UNSIGNED NOT NULL,
  `idStat` int(10) UNSIGNED NOT NULL,
  `value` int(10) UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `statsmonstres`
--

INSERT INTO `statsmonstres` (`idMonstre`, `idStat`, `value`) VALUES
(1, 1, 1),
(1, 3, 1),
(2, 1, 4),
(2, 3, 4),
(3, 1, 7),
(3, 3, 4),
(4, 1, 13),
(4, 3, 4),
(5, 1, 12),
(5, 3, 12),
(5, 4, 7),
(6, 1, 10),
(6, 3, 22),
(6, 4, 20),
(6, 9, 6),
(7, 1, 10),
(7, 3, 25),
(7, 4, 37),
(7, 9, 10),
(8, 1, 23),
(8, 3, 20),
(8, 4, 25),
(8, 5, 10),
(9, 1, 25),
(9, 3, 20),
(9, 4, 31),
(9, 5, 15),
(10, 1, 20),
(10, 3, 30),
(10, 4, 9),
(10, 5, 8),
(10, 7, 10),
(11, 1, 25),
(11, 3, 20),
(11, 4, 12),
(11, 5, 31),
(12, 1, 30),
(12, 3, 51),
(12, 4, 47),
(12, 9, 20),
(13, 1, 16),
(13, 3, 20),
(13, 4, 50),
(13, 5, 40),
(14, 1, 18),
(14, 3, 40),
(14, 4, 115),
(14, 9, 25),
(15, 1, 26),
(15, 3, 30),
(15, 4, 68),
(15, 5, 32),
(16, 1, 30),
(16, 3, 26),
(16, 4, 80),
(16, 5, 42),
(17, 1, 30),
(17, 3, 38),
(17, 4, 90),
(17, 5, 38),
(18, 1, 35),
(18, 3, 30),
(18, 4, 54),
(18, 5, 48),
(19, 1, 41),
(19, 3, 60),
(19, 4, 155),
(19, 5, 35),
(19, 9, 16),
(20, 1, 64),
(20, 3, 40),
(20, 4, 155),
(20, 5, 48),
(21, 1, 40),
(21, 3, 33),
(21, 4, 100),
(21, 5, 40),
(22, 1, 40),
(22, 3, 41),
(22, 4, 120),
(22, 5, 40),
(23, 1, 60),
(23, 3, 54),
(23, 4, 135),
(23, 7, 15),
(24, 1, 45),
(24, 3, 60),
(24, 4, 200),
(24, 9, 31),
(25, 1, 50),
(25, 3, 65),
(25, 4, 250),
(25, 9, 29),
(26, 1, 40),
(26, 3, 70),
(26, 4, 300),
(26, 7, 21),
(26, 9, 20),
(27, 1, 22),
(27, 3, 80),
(27, 4, 370),
(27, 9, 100),
(28, 1, 40),
(28, 3, 62),
(28, 4, 300),
(28, 5, 100);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `idUser` varchar(20) NOT NULL,
  `idCharacter` int(10) UNSIGNED NOT NULL,
  `userName` varchar(255) NOT NULL,
  `token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `users`
--

INSERT INTO `users` (`idUser`, `idCharacter`, `userName`, `token`) VALUES
('145917333699821568', 11, 'Neiky', '01c60cf7a1d8bb62e41963c2646b02f1'),
('151247097641959424', 20, 'Verdrion', '096027b80a6b8475f1e8dea93f6b61af'),
('173865801302933504', 17, 'vokulnin', 'fdcba4594e39ca597415ff055b84a98e'),
('197445678836875265', 3, 'ellycoupter', 'bb60516d7d0040ceb1c19322650442b9'),
('209966862719516673', 6, 'Beta', '566162a2c8c5c27a822814eb41be03f6'),
('224436300336463872', 7, '♠Vallia♠', '6d99f7c2f904114684a47d8721563eb6'),
('228787710607753216', 8, 'Astragor', '21109d34272c05b46a342fbf04060e77'),
('239342462265458690', 9, 'Ganguizz', '53f5f1c960f0d6c0fbf425c130f0e7f7'),
('241564725870198785', 1, 'Roncarlos974', 'c3f56c7edd728b5f9c2660c4b7cf43d4'),
('269191944557690880', 16, 'Vide', '206f5d9ea5f025d49a195b42dbf2fbbb'),
('275842186979835904', 15, 'HydroGene', '9c0d5bc472ea2e4a28d9dc5e29df4ff7'),
('285789367954440194', 2, 'Nagzul', 'dd28d2d532773424ab10fe7a3db5093d'),
('293703430894125056', 10, 'peterpeter', '0fc609385dc72b3a1e4327d835cab857'),
('323013943763140618', 19, 'Nimei', 'a9d5f6d474888fd67214ce4444240334'),
('326415074564505601', 4, 'Kimiyue', '0c171e67a64ccd66c662e38384a892d4'),
('336530676264468490', 14, 'Zér0', '2c388f47dab2d2bee802f8fad8f2d95b'),
('361978328581668865', 18, 'MySi', 'be2dff4b0a2fc807f2bac155514482b8'),
('403229406585421834', 5, 'God', 'c3be2fafba0c931a792a3c384265839a');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`idArea`),
  ADD UNIQUE KEY `idArea_UNIQUE` (`idArea`),
  ADD KEY `fk_Areas_AreasTypes1_idx` (`idAreaType`);

--
-- Index pour la table `areasitems`
--
ALTER TABLE `areasitems`
  ADD PRIMARY KEY (`idArea`,`idBaseItem`),
  ADD KEY `fk_AreasItems_ItemsBase1_idx` (`idBaseItem`);

--
-- Index pour la table `areasmonsters`
--
ALTER TABLE `areasmonsters`
  ADD PRIMARY KEY (`idArea`,`idMonstre`),
  ADD KEY `fk_AreasMonsters_Monstres1_idx` (`idMonstre`);

--
-- Index pour la table `areasowners`
--
ALTER TABLE `areasowners`
  ADD PRIMARY KEY (`idArea`,`idGuild`),
  ADD KEY `fk_AreasOwners_Guilds1_idx` (`idGuild`);

--
-- Index pour la table `areasresources`
--
ALTER TABLE `areasresources`
  ADD PRIMARY KEY (`idArea`,`idBaseItem`),
  ADD KEY `fk_AreasResources_ItemsBase1_idx` (`idBaseItem`);

--
-- Index pour la table `areastypes`
--
ALTER TABLE `areastypes`
  ADD PRIMARY KEY (`idAreaType`),
  ADD UNIQUE KEY `idAreaType_UNIQUE` (`idAreaType`);

--
-- Index pour la table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`idCharacter`),
  ADD UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`),
  ADD KEY `fk_Characters_Areas1_idx` (`idArea`);

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
  ADD KEY `fk_Items_LevelsRequire1_idx` (`level`);

--
-- Index pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  ADD PRIMARY KEY (`idBaseItem`),
  ADD UNIQUE KEY `idItem_UNIQUE` (`idBaseItem`),
  ADD KEY `fk_Items_ItemsTypes1_idx` (`idType`),
  ADD KEY `fk_ItemsBase_ItemsRarities1_idx` (`idRarity`);

--
-- Index pour la table `itemsrarities`
--
ALTER TABLE `itemsrarities`
  ADD PRIMARY KEY (`idRarity`),
  ADD UNIQUE KEY `idItemRaritie_UNIQUE` (`idRarity`);

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
-- Index pour la table `levels`
--
ALTER TABLE `levels`
  ADD PRIMARY KEY (`idCharacter`),
  ADD UNIQUE KEY `idCharacter_UNIQUE` (`idCharacter`),
  ADD KEY `fk_Levels_LevelsRequire1_idx` (`actualLevel`);

--
-- Index pour la table `levelsrequire`
--
ALTER TABLE `levelsrequire`
  ADD PRIMARY KEY (`level`),
  ADD UNIQUE KEY `level_UNIQUE` (`level`);

--
-- Index pour la table `monstres`
--
ALTER TABLE `monstres`
  ADD PRIMARY KEY (`idMonstre`),
  ADD UNIQUE KEY `idMonstre_UNIQUE` (`idMonstre`),
  ADD KEY `fk_Monstres_MonstresTypes1_idx` (`idType`);

--
-- Index pour la table `monstrestypes`
--
ALTER TABLE `monstrestypes`
  ADD PRIMARY KEY (`idType`),
  ADD UNIQUE KEY `idType_UNIQUE` (`idType`);

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
  ADD PRIMARY KEY (`idMonstre`,`idStat`),
  ADD KEY `fk_StatsMonstres_Stats1_idx` (`idStat`);

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
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `areas`
--
ALTER TABLE `areas`
  MODIFY `idArea` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT pour la table `areastypes`
--
ALTER TABLE `areastypes`
  MODIFY `idAreaType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `characters`
--
ALTER TABLE `characters`
  MODIFY `idCharacter` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT pour la table `guilds`
--
ALTER TABLE `guilds`
  MODIFY `idGuild` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT pour la table `guildsranks`
--
ALTER TABLE `guildsranks`
  MODIFY `idGuildRank` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `items`
--
ALTER TABLE `items`
  MODIFY `idItem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=609;
--
-- AUTO_INCREMENT pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  MODIFY `idBaseItem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT pour la table `itemsrarities`
--
ALTER TABLE `itemsrarities`
  MODIFY `idRarity` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT pour la table `itemstypes`
--
ALTER TABLE `itemstypes`
  MODIFY `idType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT pour la table `levelsrequire`
--
ALTER TABLE `levelsrequire`
  MODIFY `level` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT pour la table `monstres`
--
ALTER TABLE `monstres`
  MODIFY `idMonstre` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
--
-- AUTO_INCREMENT pour la table `monstrestypes`
--
ALTER TABLE `monstrestypes`
  MODIFY `idType` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `stats`
--
ALTER TABLE `stats`
  MODIFY `idStat` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `areas`
--
ALTER TABLE `areas`
  ADD CONSTRAINT `fk_Areas_AreasTypes1` FOREIGN KEY (`idAreaType`) REFERENCES `areastypes` (`idAreaType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `areasitems`
--
ALTER TABLE `areasitems`
  ADD CONSTRAINT `fk_AreasItems_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasItems_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `areasmonsters`
--
ALTER TABLE `areasmonsters`
  ADD CONSTRAINT `fk_AreasMonsters_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_table1_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `areasowners`
--
ALTER TABLE `areasowners`
  ADD CONSTRAINT `fk_AreasOwners_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasOwners_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `areasresources`
--
ALTER TABLE `areasresources`
  ADD CONSTRAINT `fk_AreasResources_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasResources_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `characters`
--
ALTER TABLE `characters`
  ADD CONSTRAINT `fk_Characters_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `charactersequipements`
--
ALTER TABLE `charactersequipements`
  ADD CONSTRAINT `fk_CharactersEquipements_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersEquipements_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersEquipements_ItemsTypes1` FOREIGN KEY (`idType`) REFERENCES `itemstypes` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `charactershonor`
--
ALTER TABLE `charactershonor`
  ADD CONSTRAINT `fk_CharacterHonor_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `charactersinventory`
--
ALTER TABLE `charactersinventory`
  ADD CONSTRAINT `fk_CharactersInventory_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CharactersInventory_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `guildsappliances`
--
ALTER TABLE `guildsappliances`
  ADD CONSTRAINT `fk_table1_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_table1_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `guildsmembers`
--
ALTER TABLE `guildsmembers`
  ADD CONSTRAINT `fk_GuildsMembers_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_GuildsMembers_Guilds1` FOREIGN KEY (`idGuild`) REFERENCES `guilds` (`idGuild`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_GuildsMembers_GuildsRanks1` FOREIGN KEY (`idGuildRank`) REFERENCES `guildsranks` (`idGuildRank`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `fk_Items_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Items_LevelsRequire1` FOREIGN KEY (`level`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  ADD CONSTRAINT `fk_ItemsBase_ItemsRarities1` FOREIGN KEY (`idRarity`) REFERENCES `itemsrarities` (`idRarity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Items_ItemsTypes1` FOREIGN KEY (`idType`) REFERENCES `itemstypes` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `itemsstats`
--
ALTER TABLE `itemsstats`
  ADD CONSTRAINT `fk_ItemsStats_Items1` FOREIGN KEY (`idItem`) REFERENCES `items` (`idItem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_ItemsStats_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `levels`
--
ALTER TABLE `levels`
  ADD CONSTRAINT `fk_Levels_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Levels_LevelsRequire1` FOREIGN KEY (`actualLevel`) REFERENCES `levelsrequire` (`level`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `monstres`
--
ALTER TABLE `monstres`
  ADD CONSTRAINT `fk_Monstres_MonstresTypes1` FOREIGN KEY (`idType`) REFERENCES `monstrestypes` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `statscharacters`
--
ALTER TABLE `statscharacters`
  ADD CONSTRAINT `fk_StatsCharacters_Characters1` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_StatsCharacters_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `statsmonstres`
--
ALTER TABLE `statsmonstres`
  ADD CONSTRAINT `fk_StatsMonstres_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_StatsMonstres_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_Users_Character` FOREIGN KEY (`idCharacter`) REFERENCES `characters` (`idCharacter`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
