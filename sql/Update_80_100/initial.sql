INSERT INTO levelsrequire VALUES 
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

INSERT INTO itemsbase VALUES 
(56, 8, 5, "unknown", 11);

INSERT INTO itemslocalizations VALUES
(56, "fr", "Cheval de Glace", "Ce cheval a vécu tellement longtemps dans ce paradis froid et sans vie qu'il ne fait désormais plus qu'un avec le climat local."),
(56, "en", "Frost Horse", "This horse has lived so long in this cold and lifeless paradise that it is now one with the local climate.");


UPDATE craftitem SET maxLevel = 100;

INSERT INTO craftitem VALUES
(21, 100, 100, 45),
(22, 100, 100, 46),
(23, 100, 100, 47),
(24, 100, 100, 48);

INSERT INTO craftitemsneeded
VALUES
    (21, 49, 800), (21, 25, 6), (21, 30, 6), (21, 35, 6),
    (22, 49, 1200), (22, 25, 15),
    (23, 49, 1000), (23, 30, 15),
    (24, 49, 1000), (24, 35, 15);


INSERT INTO regions VALUES (5);

INSERT INTO localizationregions
VALUES
    (5, "fr", "Les Terres Glaciales de Horth", "https://cdn.fight-rpg.com/images/regions/horth-glacial-land-fr.png"),
    (5, "en", "Horth's Glacial Lands", "https://cdn.fight-rpg.com/images/regions/horth-glacial-land-en.png");

-- Areas
-- type 1 wild, 2 city, 3 dungeon
INSERT INTO areas
VALUES
    (28, "https://cdn.fight-rpg.com/images/areas/TowerFrozen.png", 1, 1, 5),

    (29, "http://i.imgur.com/28FLw.jpg", 2, 1, 5),

    (30, "https://vignette.wikia.nocookie.net/rsroleplay/images/6/61/Cadderoccourtyard.jpg/", 1, 1, 5),

    (31, "https://cdn.fight-rpg.com/images/areas/HauntedHouse.png", 1, 1, 5),

    (32, "https://cdn.fight-rpg.com/images/areas/HauntedVillage.png", 1, 1, 5),

    (33, "http://img07.deviantart.net/446c/i/2013/158/9/e/ice_cave_by_devin87-d68585o.jpg", 3, 1, 5),

    (34, "https://bnetcmsus-a.akamaihd.net/cms/gallery/A0IFUJNHQ73S1421193822596.jpg", 2, 1, 5);

INSERT INTO areasitems
VALUES

    (28, 2, 0, 1, 1),
    (28, 3, 0, 1, 1),
    (28, 4, 0, 1, 1),
    (28, 7, 0, 1, 1),
    (28, 8, 0, 1, 1),
    (28, 9, 0, 1, 1),
    (28, 12, 0, 1, 1),
    (28, 13, 0, 1, 1),
    (28, 14, 0, 1, 1),
    (28, 15, 0, 1, 1),
    (28, 17, 0, 1, 1),
    (28, 18, 0, 1, 1),
    (28, 19, 0, 1, 1),

    (30, 2, 0, 1, 1),
    (30, 3, 0, 1, 1),
    (30, 4, 0, 1, 1),
    (30, 5, 0, 1, 1),
    (30, 7, 0, 1, 1),
    (30, 8, 0, 1, 1),
    (30, 9, 0, 1, 1),
    (30, 12, 0, 1, 1),
    (30, 13, 0, 1, 1),
    (30, 14, 0, 1, 1),
    (30, 17, 0, 1, 1),
    (30, 18, 0, 1, 1),
    (30, 19, 0, 1, 1),

    (31, 2, 0, 1, 1),
    (31, 3, 0, 1, 1),
    (31, 4, 0, 1, 1),
    (31, 7, 0, 1, 1),
    (31, 8, 0, 1, 1),
    (31, 9, 0, 1, 1),
    (31, 12, 0, 1, 1),
    (31, 13, 0, 1, 1),
    (31, 14, 0, 1, 1),
    (31, 17, 0, 1, 1),
    (31, 18, 0, 1, 1),
    (31, 19, 0, 1, 1),
    (31, 20, 0, 1, 1),

    (32, 3, 0, 1, 1),
    (32, 4, 0, 1, 1),
    (32, 8, 0, 1, 1),
    (32, 9, 0, 1, 1),
    (32, 10, 0, 1, 1),
    (32, 13, 0, 1, 1),
    (32, 14, 0, 1, 1),
    (32, 18, 0, 1, 1),
    (32, 19, 0, 1, 1),

    (33, 5, 0, 1, 1),
    (33, 10, 0, 1, 1),
    (33, 15, 0, 1, 1),
    (33, 20, 0, 1, 1);

INSERT INTO areasmonsterslevels
VALUES
    (28, 80, 85),
    (29, 90, 90),
    (30, 85, 90),
    (31, 90, 95),
    (32, 95, 100),
    (33, 100, 100),
    (34, 100, 100);

INSERT INTO localizationareas VALUES 
(28, "fr", "Tour Glaciale de Horth", "Cette tour antique vous donne des frissons et vous apporte un sentiment de nostalgie, comme si des milliers de batailles s'étaient déjà déroulées ici. Vous vous demandez ce qui vous attend au sommet."),
(29, "fr", "Village du Vent Glacial", "Un petit village qui a réussi à survivre au froid intense de la région. Vous préféreriez certainement un hôtel chaleureux aux Bahamas, mais la vie est ainsi faite."),
(30, "fr", "Cimetière de l'âme givrée", "Pas seulement le froid, mais aussi les morts-vivants ? Super, au moins maintenant, ça va vous réchauffer."),
(31, "fr", "Grand Manoir du Baron Galssor", "Ce manoir labyrinthique était jadis occupé par un baron très puissant et ses serviteurs. Oh, regardez, il y a même une machine à café ! Je me demande si ça marche encore."),
(32, "fr", "Village Hanté de Horth", "Alors que la neige souffle dans le vent, vous voyez des figures spectrales terribles et déformées errer dans ce village, comme s'il s'agissait encore de personnes vivantes habitant le village. Vous espérez donner du repos à ces âmes."),
(33, "fr", "Caverne des Miroirs de Glace", "La légende dit qu'il est possible de voir le reflet de votre âme dans les murs de glace en verre de cette grotte. Personnellement, vous ne ressentez qu'un frisson, comme c'est décevant."),
(34, "fr", "Forge Antique Naine", "Une fois dans cette forge naine, de nombreuses armes légendaires furent fabriquées par les nains les plus habiles de la région, chauffées par le feu de cette forge. Aujourd'hui, beaucoup de ces armes sont perdues ou enterrées dans la neige. Les Trésors légendaires attendent d'être trouvé.")

(28, "en", "Horth Ice Tower", "This antique tower gives you chills and brings you a nostalgic feeling, as if thousands of battles have happened here before. You wonder what's waiting for you on the top of it."),
(29, "en", "Frozen Wind Village", "A small village that managed to survive through the intense cold of the region. You would definitely prefer a warm hotel in the Bahamas, but life goes on."),
(30, "en", "Cemetery of the Frozen Soul", "Not just the cold, but you now also have to deal with undead? Great, at least now this will warm you up."),
(31, "en", "Great Manor of Baron Galssor", "This labyrinthic manor was once occupied by a very powerful baron and it's servants. Oh, look, it even has a coffee machine! I wonder if it still works."),
(32, "en", "Haunted Village of Horth", "As the snow blows in the wind, you see terrible and distorted spectral figures wander through this village, as if they were still live people inhabiting the village. You hope to give a rest to these souls."),
(33, "en", "Ice Mirror Cave", "The legend says it's possible to see the reflection of your very soul in the glass-like ice walls of this cave. You personally only feel a chill, how disappointing."),
(34, "en", "Antique Dwarf Forge", "Once in this dwarf forge, many legendary weapons were crafted by the most skilled dwarves of this region, heated by the fire of this forge. Now many of these weapons are lost, or buried into the snow. Legendary treasury that awaits to be found.");


INSERT INTO areasresources
VALUES
    (28, 21),
    (28, 22),
    (28, 23),
    (28, 24),
    (28, 25),
    (28, 28),

    (30, 23),
    (30, 24),
    (30, 25),
    (30, 28),

    (31, 24),
    (31, 25),
    (31, 28),
    (31, 30),
    (31, 27),

    (32, 24),
    (32, 25),
    (32, 28);


INSERT INTO areasregions
VALUES
    (28, 5),
    (29, 5),
    (30, 5),
    (31, 5),
    (32, 5),
    (33, 5),
    (34, 5);

-- Paths
INSERT INTO areaspaths
VALUES
    (22, 28, 600, 0),
    (28, 22, 600, 0),

    (29, 28, 80, 0),
    (28, 29, 80, 0),

    (31, 28, 100, 0),
    (28, 31, 100, 0),

    (31, 32, 60, 0),
    (32, 31, 60, 0),

    (31, 34, 350, 0),
    (34, 31, 350, 0),

    (29, 30, 70, 0),
    (30, 29, 70, 0),

    (29, 33, 120, 0),
    (33, 29, 120, 0);

INSERT INTO craftbuilding
VALUES
    (8, 29, 1, 3, 5, 81, 100),
    (9, 34, 1, 6, 6, 100, 100);


INSERT INTO monstres
VALUES
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

INSERT INTO localizationmonsters
VALUES
    (71, "en", "Warrior Ghost"),
    (71, "fr", "Fantôme de Guerrier"),

    (72, "en", "Archer Ghost"),
    (72, "fr", "Fantôme d'archer"),

    (73, "en", "Mage Ghost"),
    (73, "fr", "Fantôme de Mage"),

    (74, "en", "Ghost Clusters"),
    (74, "fr", "Amas de Fantômes"),


    (75, "en", "Skeleton Warrior"),
    (75, "fr", "Guerrier Squelette"),

    (76, "en", "Skeleton Archer"),
    (76, "fr", "Archer Squelette"),

    (77, "en", "Skeleton Mage"),
    (77, "fr", "Mage Squelette"),

    (78, "en", "Abomination of Putrient Fleshes"),
    (78, "fr", "Abomination de Chairs Putrides"),

    (79, "en", "Ghost of Baron Galssor"),
    (79, "fr", "Fantôme du Baron Galssor"),

    (80, "en", "Ice Golem"),
    (80, "fr", "Golem de Glace"),

    (81, "en", "Powerful Ice Elemental"),
    (81, "fr", "Puissant Elémentaire de Glace");


-- 2 smorc, 3 tank_stun, 4 crit, 5 tank_armor_stun, 6 tank_will, 7 damage, 8 damage_crit, 9 tanky

INSERT INTO statsmonstres
VALUES
    (71, 3),
    (72, 7),
    (73, 8),
    (74, 2),

    (75, 9),
    (76, 7),
    (77, 8),
    (78, 5),

    (79, 4),

    (80, 2),
    (81, 7);


INSERT INTO monstresgroupes
VALUES
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
    (77, 81, 1);


INSERT INTO areasmonsters
VALUES
    (28, 68, 71),
    (28, 69, 72),
    (28, 70, 73),
    (28, 71, 74),

    (30, 72, 75),
    (30, 73, 76),
    (30, 74, 77),
    (30, 75, 78),

    (31, 72, 75),
    (31, 69, 72),
    (31, 74, 77),
    (31, 76, 79),

    (32, 68, 71),
    (32, 73, 76),
    (32, 70, 73),
    (32, 71, 74),

    (33, 77, 80),
    (33, 77, 81);

INSERT INTO achievement
VALUES
    (2, "last_challenge", 100);

INSERT INTO localizationachievements
VALUES
    (2, "fr", "Un Dernier Défi", "Combattez le Boss du Donjon niveau 100 et gagnez le combat pour débloquer l'accès à la forge antique naine !"),
    (2, "en", "One last challenge", "Fight the Boss inside the dungeon level 100 and win the battle to unlock access to the ancient dwarf forge!");

INSERT INTO areasrequirements 
VALUES
    (34, 2);

INSERT INTO shop VALUES (NULL, 0.05, 1), (NULL, 0.05, 1);

INSERT INTO areasshops VALUES (29,8), (33,9);


-- Epic
INSERT INTO sellableitems VALUES (NULL, 43, 90, 1, 580); -- 17
INSERT INTO sellableitems VALUES (NULL, 43, 100, 1, 650); -- 18

-- legs
INSERT INTO sellableitems VALUES (NULL, 44, 90, 1, 800); -- 19
INSERT INTO sellableitems VALUES (NULL, 44, 100, 1, 1000); -- 20


INSERT INTO shopitems VALUES 
(8, 17), (8, 19),
(9, 18), (9, 20);

