INSERT INTO `monstrestypes` (`idType`, `nom`) VALUES (NULL, 'boss');
INSERT INTO `areas` (`idArea`, `AreaName`, `AreaDesc`, `AreaImage`, `AreaLevels`, `idAreaType`) VALUES (NULL, 'Les nappes feu-à-tiques', 'Il fait chaud non ? Oui il faut chaud.', 'https://pbs.twimg.com/media/CmOgb8vWEAARI_g.jpg', '20', '3');
INSERT INTO `monstres` (`idMonstre`, `name`, `avglevel`, `idType`) VALUES (NULL, 'Bats le Rog, esprit du feu', '20', '3'), (NULL, 'Fouettard ardent', '20', '2');

-- Bats le rog ici
INSERT INTO `statsmonstres` (`idMonstre`, `idStat`, `value`) VALUES ('29', '1', '104'), ('29', '3', '100'), ('29', '5', '50'), ('29', '4', '350');

-- Fouettard
INSERT INTO `statsmonstres` (`idMonstre`, `idStat`, `value`) VALUES ('30', '1', '80'), ('30', '3', '70'), ('30', '5', '52'), ('30', '4', '270');

-- Ajout des mobs dans la zone
INSERT INTO `monstresgroupes` (`idMonstreGroupe`, `idMonstre`, `number`) VALUES ('29', '30', '1'), ('29', '29', '1');

INSERT INTO `areasmonsters` (`idArea`,`idMonstreGroupe`,`idMonstre`) VALUES ('7', '29', '29'),('7', '29', '30');
