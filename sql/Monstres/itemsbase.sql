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
-- Structure de la table `itemsbase`
--

CREATE TABLE `itemsbase` (
  `idBaseItem` int(10) UNSIGNED NOT NULL,
  `nomItem` varchar(50) NOT NULL,
  `descItem` varchar(255) DEFAULT NULL,
  `idType` int(10) UNSIGNED NOT NULL,
  `idRarity` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `itemsbase`
--

INSERT INTO `itemsbase` (`idBaseItem`, `nomItem`, `descItem`, `idType`, `idRarity`) VALUES
(1, 'Epée en Bois', 'Une simple épée d\'entrainement.', 1, 1),
(2, 'Epée en fer', 'Une épée de simple facture.', 1, 2),
(3, 'Epée en acier forgé', 'Une épée de très bonne facture.', 1, 3),
(4, 'Armure de débutant', 'Une armure très basique.', 2, 1),
(5, 'Armure d\'aventurier', 'Une armure digne d\'un aventurier.', 2, 2),
(6, 'Armure magique', 'Une armure magique.', 2, 3),
(7, 'Jambières de débutant', 'Des jambières très basiques.', 3, 1),
(8, 'Jambières d\'aventurier', 'Des jambières dignes d\'un aventurier.', 3, 2),
(9, 'Jambières magiques', 'Des jambières magiques.', 3, 3),
(10, 'Casque de débutant', 'Un casque très basique.', 4, 1),
(11, 'Casque d\'aventurier', 'Un casque digne d\'un aventurier.', 4, 2),
(12, 'Casque magique', 'Un casque magique.', 4, 3),
(13, 'Epée élémentaire', 'Une épée imprégnée de l\'énergie d\'un Golem.', 1, 5),
(14, 'Épée imprégnée de chaos', 'Cette épée vibre dans votre main, elle semble ne pas vouloir tenir en place.', 1, 4),
(15, 'Casque de chevalier maléfique', 'Ce casque semble vous appeler. Il est d\'un noir profond.', 4, 4),
(16, 'Culotte de géant', 'C\'est grand, très grand. Il a plusieurs traces et vous n\'avez vraiment pas envie de savoir ce que c\'est.\r\nMais après tout, ça à l\'air résistant, pourquoi pas le porter ?', 3, 5),
(17, 'Masque sacré Maatan', 'Ce masque est une relique du clan Maatan, je pense qu\'ils n\'apprécient pas que vous l\'ayez.', 4, 5),
(18, 'Armure d\'os', 'Vous avez vu, vous avez vaincu et vous porter vos ennemis sur vous.', 2, 4),
(19, 'Pagne de Maatan usagé', 'Il a déjà servi, mais peut encore servir, en plus vous aimez son odeur.', 3, 4);

--
-- Index pour les tables exportées
--

--
-- Index pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  ADD PRIMARY KEY (`idBaseItem`),
  ADD UNIQUE KEY `idItem_UNIQUE` (`idBaseItem`),
  ADD KEY `fk_Items_ItemsTypes1_idx` (`idType`),
  ADD KEY `fk_ItemsBase_ItemsRarities1_idx` (`idRarity`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  MODIFY `idBaseItem` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `itemsbase`
--
ALTER TABLE `itemsbase`
  ADD CONSTRAINT `fk_ItemsBase_ItemsRarities1` FOREIGN KEY (`idRarity`) REFERENCES `itemsrarities` (`idRarity`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Items_ItemsTypes1` FOREIGN KEY (`idType`) REFERENCES `itemstypes` (`idType`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
