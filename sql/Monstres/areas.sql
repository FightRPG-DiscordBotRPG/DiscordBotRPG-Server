-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Dim 28 Janvier 2018 à 06:34
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
  `AreaLevels` varchar(45) NOT NULL DEFAULT '1 - 2'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `areas`
--

INSERT INTO `areas` (`idArea`, `AreaName`, `AreaDesc`, `AreaImage`, `AreaLevels`) VALUES
(1, 'Forêt de Buldaar', 'Cette forêt accueille un très grand nombre de débutants souhaitant partir à l\'aventure, malheureusement pour eux, l\'aventure n\'est pas de tout repos, même ici.', 'https://c1.staticflickr.com/6/5082/5260289771_1e133585fb_b.jpg', '1-5'),
(2, 'Plaines Rocheuses', 'Cette plaine est remplie de magie, des Golems sont nés de cette magie et depuis ils errent ici.', 'https://cdn.pixabay.com/photo/2015/10/27/08/53/landscape-1008572_960_720.jpg', '5-10'),
(3, 'Impasse de Lirayl', 'Autrefois cette impasse bourdonnait de vie, mais depuis des années un mal ronge la terre et détruit tout sur son passage.', 'https://d2v9y0dukr6mq2.cloudfront.net/video/thumbnail/2czqMab/forest-fire-mountain-tree-destruction-burn-p-hd-0930_vkgzsxlof__F0000.png', '10-15'),
(4, 'Jungle de Baanar', 'C\'est une jungle ! ', 'http://s1.thingpic.com/images/86/6fS2n1Y7d9S7yHdemFr5Ys6Q.jpeg', '15-20');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`idArea`),
  ADD UNIQUE KEY `idArea_UNIQUE` (`idArea`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `areas`
--
ALTER TABLE `areas`
  MODIFY `idArea` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
