INSERT INTO `itemssoustypes` (`idSousType`, `nomSousType`) VALUES (NULL, 'random_loot_box_equipment');

-- ID 43, 44
INSERT INTO `itemsbase` (`idBaseItem`, `idType`, `idRarity`, `imageItem`, `idSousType`) VALUES (NULL, '7', '4', 'unknown', '12'), (NULL, '7', '5', 'unknown', '12'); 

INSERT INTO `localizationitems` (`idBaseItem`, `lang`, `nameItem`, `descItem`) VALUES ('43', 'fr', 'Boite de Pandaleatoire & Pic', "Une boite qui devrait pouvoir vous laisser une chance d'obtenir des équipements efficaces. "), ('43', 'en', 'Pandrandom & Pic Box', 'A box that should give you a chance to get efficient equipment.');

INSERT INTO `localizationitems` (`idBaseItem`, `lang`, `nameItem`, `descItem`) VALUES ('44', 'fr', "Boite de Pandaleatoire Les Gens d'Air", "Une boite extraordinaire, remplie de vent la plupart du temps. Mais qui peut laisser entrevoir de temps à autre un équipement exceptionnel !"), ('44', 'en', 'Pandrandom Lay Gendary Box', 'An extraordinary box, filled with nothing most of the time. But who can let you see from time to time an exceptional equipment.');