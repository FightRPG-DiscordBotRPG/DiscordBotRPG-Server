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

--
-- Index pour les tables exportées
--

--
-- Index pour la table `statsmonstres`
--
ALTER TABLE `statsmonstres`
  ADD PRIMARY KEY (`idMonstre`,`idStat`),
  ADD KEY `fk_StatsMonstres_Stats1_idx` (`idStat`);

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `statsmonstres`
--
ALTER TABLE `statsmonstres`
  ADD CONSTRAINT `fk_StatsMonstres_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_StatsMonstres_Stats1` FOREIGN KEY (`idStat`) REFERENCES `stats` (`idStat`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
