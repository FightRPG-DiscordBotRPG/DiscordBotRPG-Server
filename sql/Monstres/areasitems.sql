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

--
-- Index pour les tables exportées
--

--
-- Index pour la table `areasitems`
--
ALTER TABLE `areasitems`
  ADD PRIMARY KEY (`idArea`,`idBaseItem`),
  ADD KEY `fk_AreasItems_ItemsBase1_idx` (`idBaseItem`);

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `areasitems`
--
ALTER TABLE `areasitems`
  ADD CONSTRAINT `fk_AreasItems_Areas1` FOREIGN KEY (`idArea`) REFERENCES `areas` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_AreasItems_ItemsBase1` FOREIGN KEY (`idBaseItem`) REFERENCES `itemsbase` (`idBaseItem`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
