-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Dim 28 Janvier 2018 à 06:33
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

--
-- Index pour les tables exportées
--

--
-- Index pour la table `monstres`
--
ALTER TABLE `monstres`
  ADD PRIMARY KEY (`idMonstre`),
  ADD UNIQUE KEY `idMonstre_UNIQUE` (`idMonstre`),
  ADD KEY `fk_Monstres_MonstresTypes1_idx` (`idType`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `monstres`
--
ALTER TABLE `monstres`
  MODIFY `idMonstre` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `monstres`
--
ALTER TABLE `monstres`
  ADD CONSTRAINT `fk_Monstres_MonstresTypes1` FOREIGN KEY (`idType`) REFERENCES `monstrestypes` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
