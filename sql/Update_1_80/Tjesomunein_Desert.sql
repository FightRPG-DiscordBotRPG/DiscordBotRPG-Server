-- Areas
-- type 1 wild, 2 city, 3 dungeon
INSERT INTO areas
VALUES
    (15, "https://vignette.wikia.nocookie.net/planarch-world/images/3/32/Egypt_fantasy_art_1280x800_64840.jpg/revision/latest?cb=20130904022740", 2, 1, 5), -- sepsibenu

    (16, "https://img00.deviantart.net/197a/i/2012/241/b/0/city_at_sunset_by_vennom07-d5cuzhr.jpg", 2, 1, 5), -- fontaine occidentale

    (17, "https://img00.deviantart.net/b5ba/i/2016/117/d/2/cracked_landsape_by_thechrispman-da0ehq0.png", 1, 1, 5),
    -- désolé et craquelé

    (18, "http://fc03.deviantart.net/fs70/i/2013/019/a/2/desert_landscape_by_rambled-d5s0cib.jpg", 1, 1, 5),
    -- cratères en feu

    (19, "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/intermediary/f/2abc5a8d-58e0-4913-a8a5-1d067c864b26/db6my5y-fd0aad3e-4e85-4cfd-b449-3268ff2acff2.jpg/v1/fill/w_900,h_480,q_70,strp/orc_village_by_veravoyna_db6my5y-fullview.jpg", 1, 1, 5),
    -- village wutgarek

    (20, "https://vignette.wikia.nocookie.net/assassinscreed/images/e/e4/ACO_Desert_Ruin_-_Concept_Art.jpg/revision/latest?cb=20171019091305", 1, 1, 5),
    -- acbydet

    (21, "https://pre00.deviantart.net/7106/th/pre/i/2016/030/a/f/ruins_underground_by_asahisuperdry-d9puru6.jpg", 3, 1, 5); -- tombes oubliées



INSERT INTO localizationareas
VALUES
    (15, "en", "Sepsibenu", "Sebsibenu is the typical desert city. It has been able to take advantage of the waterways of the Western Fountain. It is now the most important point in the region in terms of trade."),
    (15, "fr", "Sepsibenu", "Sebsibenu est la cité typique du désert. Elle a su profiter des cours d'eaux de la Fontaine Occidentale. Elle est désormais le point le plus important de la région en terme en terme de commerce."),

    (16, "en", "Western Fountain", "This city is surrounded by magic, its water sources seem to be inexhaustible. At the time of colonization, this city did not exist, in fact, it was built very soon afterwards."),
    (16, "fr", "La Fontaine Occidentale", "Cette cité est entourée de magie, ses sources d'eaux semblent être inépuisables. Lors de la colonisation, cette citée n'existait pas, en effet, elle fût construite très peu de temps après."),

    (17, "en", "Desolated Cracked Desert", "A piece of the desert filled with giant insects. This area only has interesting minerals. The cracks in it have already killed more than one."),
    (17, "fr", "Le Désert Désolé et Craquelé", "Un morceau du désert rempli d'insectes géants. Cette zone n'a d'intéressant que ses minerais. Les crevasses qui la composent en ont déjà tué plus d'un."),

    (18, "en", "The Fire Craters", "Still the result of meteorites, however this part of the desert has some very interesting minerals and it seems that there is a chance of coming across Sand Golems."),
    (18, "fr", "Les Cratères en Feu", "Encore le résultat de météorites, cependant cette partie du désert possède des minerais très intéressants et parait-il qu'il y aurait chances de tomber sur des Golems de Sable."),

    (19, "en", "Wutgarek Village", "This village is surely the nerve centre of the Wutgareks. But if you're here, it's certainly not to appreciate the buildings. Be careful, however, the Wutgarek will not give you any respite."),
    (19, "fr", "Village Wutgarek", "Ce village est sûrement le coeur névralgique des Wutgareks. Mais si vous êtes là ce n'est sûrement pas pour apprécier les constructions. Faites cependant attention, les Wutgarek ne vous laisserons aucun répit."),

    (20, "en", "Acbydet", "This ancient city is invaded by Wutgareks, insects and mummies. Apart from its graves, this place is probably the worst place in the desert."),
    (20, "fr", "Acbydet", "Cette ancienne cité est envahie par des Wutgareks, des insectes et des momies. Mis à part ses tombes, cet endroit est un sûrement le pire endroit du désert."),

    (21, "en", "The Forgotten Tombs", "These ancient tombs are filled with a dark magic, you seem to hear in the distance, a kind of black mass. What could it be?"),
    (21, "fr", "Les Tombes Oubliées", "Ces anciennes tombes sont remplies d'une magie sombre, vous semblez entendre au loin, une sorte de messe noire. Qu'est-ce que cela peut-il bien être ?");

-- Paths
INSERT INTO areaspaths
VALUES
    -- Interzone
    -- From Sepsibenu
    (15, 16, 90, 0),
    (16, 15, 90, 0),
    (15, 17, 30, 0),
    (17, 15, 30, 0),

    -- Desolated desert
    (17, 16, 60, 0),
    (16, 17, 60, 0),
    (17, 18, 40, 0),
    (18, 17, 40, 0),
    (17, 19, 30, 0),
    (19, 17, 30, 0),
    (17, 20, 80, 0),
    (20, 17, 80, 0),

    -- From Wutgarek
    (19, 20, 60, 0),
    (20, 19, 60, 0),

    -- Acybet
    (20, 21, 20, 0),
    (21, 20, 20, 0),

    -- Outsite
    (15, 14, 420, 0),
    (14, 15, 420, 0),
    (20, 14, 380, 0),
    (14, 20, 380, 0);

INSERT INTO areasmonsterslevels
VALUES
    (15, 40, 40),
    (16, 60, 60),
    (17, 40, 45),
    (18, 45, 50),
    (19, 55, 60),
    (20, 50, 55),
    (21, 60, 60);


-- Regions 

INSERT INTO regions
VALUES
    (3);

INSERT INTO localizationregions
VALUES
    (3, "en", "Tjesomunein Desert", "https://image.ibb.co/nfW4JV/tjesomunein-desert-en.png"),
    (3, "fr", "Désert de Tjesomunein", "https://image.ibb.co/dHaydV/tjesomunein-desert-fr.png");

INSERT INTO areasregions
VALUES
    (15, 3),
    (16, 3),
    (17, 3),
    (18, 3),
    (19, 3),
    (20, 3),
    (21, 3);


-- Monstres 31 grp 30

INSERT INTO monstres
VALUES
    (45, 0, 1),
    (46, 0, 1),
    (47, 0, 1),
    (48, 0, 2),

    (49, 0, 1),
    (50, 0, 1),
    (51, 0, 2),

    (52, 0, 2),

    (53, 0, 1),
    (54, 0, 2),
    (55, 0, 3);

INSERT INTO localizationmonsters
VALUES
    (45, "en", "Aggressive Giant Rove Beetle"),
    (45, "fr", "Staphylin Géant Agressif"),

    (46, "en", "Giant Praying Mantis"),
    (46, "fr", "Mante Religieuse Géante"),

    (47, "en", "Giant Rhinoceros Beetle"),
    (47, "fr", "Scarabée Rhinocéros Géant"),
    
    (48, "en", "Mutant Praying Mantis"),
    (48, "fr", "Mante Religieuse Mutante"),
    
    (49, "en", "Small Meteorite Golem"),
    (49, "fr", "Petit Golem de Météorite"),

    (50, "en", "Sand Golem"),
    (50, "fr", "Golem de Sable"),

    (51, "en", "Giant Sand Golem"),
    (51, "fr", "Golem de Sable Géant"),

    (52, "en", "Wutgarek Lieutenant"),
    (52, "fr", "Lieutenant Wutgarek"),

    (53, "en", "Decomposed Living Mummy"),
    (53, "fr", "Momie Vivante Décomposée"),

    (54, "en", "Servant of the Tombs"),
    (54, "fr", "Serviteur des Tombes"),

    (55, "en", "Guardian of the Tombs"),
    (55, "fr", "Gardien des Tombes");

-- 2 smorc, 3 tank_stun, 4 crit, 5 tank_armor_stun, 6 tank_will, 7 damage, 8 damage_crit, 9 tanky

INSERT INTO statsmonstres
VALUES
    (45, 8),
    (46, 4),
    (47, 3),
    (48, 7),

    (49, 6),
    (50, 5),
    (51, 5),

    (52, 2),

    (53, 2),
    (54, 7),
    (55, 9);


INSERT INTO monstresgroupes
VALUES
    (41, 45, 1),
    (42, 46, 1),
    (43, 47, 1),
    (44, 48, 1),
    (45, 49, 1),
    (46, 50, 1),
    (47, 51, 1),
    (48, 52, 1),
    (49, 53, 1),
    -- wutgarek
    (50, 33, 2),
    (51, 34, 1),

    -- dj
    (52, 54, 1), -- solo

    (53, 54, 2),
    (53, 55, 1);


INSERT INTO areasmonsters
VALUES
    (17, 41, 45),
    (17, 42, 46),
    (17, 43, 47),
    (17, 44, 48),

    (18, 43, 47),
    (18, 45, 49),
    (18, 46, 50),
    (18, 47, 51),

    (19, 50, 33),
    (19, 51, 34),
    (19, 48, 52),
    (19, 30, 31),

    (20, 50, 33),
    (20, 30, 31),
    (20, 49, 53),
    (20, 52, 54),
    
    -- dj
    (21, 53, 54),
    (21, 53, 55);


INSERT INTO areasitems
VALUES
    -- desert
    (17, 2, 0, 1, 1),
    (17, 3, 0, 1, 1),
    (17, 4, 0, 1, 1),
    (17, 7, 0, 1, 1),
    (17, 8, 0, 1, 1),
    (17, 9, 0, 1, 1),
    (17, 12, 0, 1, 1),
    (17, 13, 0, 1, 1),
    (17, 14, 0, 1, 1),
    (17, 15, 0, 1, 1),
    (17, 17, 0, 1, 1),
    (17, 18, 0, 1, 1),
    (17, 19, 0, 1, 1),
    -- crater
    (18, 2, 0, 1, 1),
    (18, 3, 0, 1, 1),
    (18, 4, 0, 1, 1),
    (18, 5, 0, 1, 1),
    (18, 7, 0, 1, 1),
    (18, 8, 0, 1, 1),
    (18, 9, 0, 1, 1),
    (18, 12, 0, 1, 1),
    (18, 13, 0, 1, 1),
    (18, 14, 0, 1, 1),
    (18, 17, 0, 1, 1),
    (18, 18, 0, 1, 1),
    (18, 19, 0, 1, 1),
    -- village
    (19, 2, 0, 1, 1),
    (19, 3, 0, 1, 1),
    (19, 4, 0, 1, 1),
    (19, 7, 0, 1, 1),
    (19, 8, 0, 1, 1),
    (19, 9, 0, 1, 1),
    (19, 12, 0, 1, 1),
    (19, 13, 0, 1, 1),
    (19, 14, 0, 1, 1),
    (19, 17, 0, 1, 1),
    (19, 18, 0, 1, 1),
    (19, 19, 0, 1, 1),
    (19, 20, 0, 1, 1),
    -- acbydet
    (20, 3, 0, 1, 1),
    (20, 4, 0, 1, 1),
    (20, 8, 0, 1, 1),
    (20, 9, 0, 1, 1),
    (20, 10, 0, 1, 1),
    (20, 13, 0, 1, 1),
    (20, 14, 0, 1, 1),
    (20, 18, 0, 1, 1),
    (20, 19, 0, 1, 1),
    -- tomb
    (21, 5, 0, 1, 1),
    (21, 10, 0, 1, 1),
    (21, 15, 0, 1, 1),
    (21, 20, 0, 1, 1);


INSERT INTO areasresources
VALUES

    (17, 22),
    (17, 21),
    (17, 23),
    (17, 28),

    (18, 21),
    (18, 24),
    (18, 25),
    (18, 28),

    (19, 28),
    (19, 33),
    (19, 31),

    (20, 21),
    (20, 26),
    (20, 28),
    (20, 33),
    (20, 31);
    


INSERT INTO craftbuilding
VALUES
    (5, 15, 1, 3, 5, 41, 50),
    (6, 16, 1, 3, 5, 51, 60);

