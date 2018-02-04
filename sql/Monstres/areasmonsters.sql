-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Dim 28 Janvier 2018 à 06:35
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

--
-- Index pour les tables exportées
--

--
-- Index pour la table `areasmonsters`
--
ALTER TABLE `areasmonsters`
  ADD PRIMARY KEY (`idArea`,`idMonstre`),
  ADD KEY `fk_AreasMonsters_Monstres1_idx` (`idMonstre`);

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `areasmonsters`
--
ALTER TABLE `areasmonsters`
  ADD CONSTRAINT `fk_AreasMonsters_Monstres1` FOREIGN KEY (`idMonstre`) REFERENCES `monstres` (`idMonstre`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_table1_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
