-- Areas
-- type 1 wild, 2 city, 3 dungeon
INSERT INTO areas
VALUES
    (8, "http://ayay.co.uk/backgrounds/rpg_games/fable/city-canal.jpg", 2, 1, 5),

    (9, "https://serc.carleton.edu/images/NZFires/megafires/burned_forest_1367176225_650.jpg", 1, 1, 5),

    (10, "https://thewallpapers.org/zoom/34407/4-3-2-hills.jpg", 1, 1, 5),

    (11, "https://images.fineartamerica.com/images/artworkimages/mediumlarge/1/luray-caverns--virginia--reflections-at-dream-lake-brendan-reals.jpg", 3, 1, 5),

    (12, "https://www.sunsetbld.com/photos/photos-meteor-crater/meteor-crater-03.jpg", 1, 1, 5),

    (13, "https://cdn.wallpapersafari.com/71/41/R5zTvA.jpg", 1, 1, 5),

    (14, "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/intermediary/f/84889e75-a424-4357-838b-7589f64dec2a/d6x7ohy-04a4fdf6-bd50-48b6-9d4d-a395be032703.jpg/v1/fill/w_986,h_810,q_70,strp/desert_outpost_edit_by_fleret_d6x7ohy-pre.jpg", 2, 1, 5);

INSERT INTO localizationareas
VALUES
    (8, "en", "Tywardreath", "The port city of Tywardreath is full of life. Indeed, it is the entry point to the new world. It is rich and active, thanks to its market and foreign trade. It also has fertile land, which local leaders do not hesitate to use."),
    (8, "fr", "Tywardreath", "La ville portuaire de Tywardreath regorge de vie. En effet celle-ci se place comme le point d'entrée du nouveau monde. Elle est riche et active, ceci grâce à son marché et à son commerce extérieur. Elle dispose aussi de terres fertiles, que les dirigeants locaux n'hésitent pas à utiliser."),

    (9, "en", "Tywardreath Burned Forest", "Once a lush forest, the Tywardreath Burned Forest is now a shadow of its own. During the first days of colonization, a race of orcs began to attack and try to defeat the ranks of the colonizers. But the colonizers, thanks to their powerful strike force, managed to overcome it. However, this was not to mention the unfailing motivation of the orcs, who had taken a stand in the forest."),
    (9, "fr", "La Forêt Carbonisée de Tywardreath", "Forêt jadis luxuriante, la Forêt Carbonisée de Tywardreath n'est plus que l'ombre d'elle même. Lors des premiers jours de colonisation une race d'orcs se mirent à attaquer et à essayer de défaire les rangs des colonisateurs. Mais les colonisateurs grâce à leur puissante force de frappe, en vinrent à bout. Cependant, c'était sans compter la motivation sans failles des orcs, qui avaient pris position dans la forêt."),

    (10, "en", "Tywardreath Hills", "The hills in the north of Tywardreath are dotted with paths leading to the mountains. Unfortunately it is not an interesting area, it is unbuildable and full of wild animals. But it is however an obligatory passage, for those who want to venture further north, towards the caves."),
    (10, "fr", "Les Collines de Tywardreath", "Les collines au Nord de Tywardreath sont parsemés de chemins menant aux montagnes. Malheureusement ce n'est pas une zone intéressante, elle est inconstructible et remplie d'animaux sauvages. Mais c'est cependant un passage obligé, pour ceux voulant s'aventurer plus au nord, vers les grottes."),

    (11, "en", "Tywardreath Caves", "No one comes here, this cave is cold, humid and... Ugh, what is this !?"),
    (11, "fr", "Grottes de Tywardreath", "Personne ne vient ici, cette grotte est froide, humide et.. Mais qu'est-ce que cela peut-il bien être !?"),

    (12, "en", "East Crater", "Crater resulting from a meteorite fall. No one dares to venture there, it seems that the meteorite has given life to the ground and that it is likely that a monster will wander there."),
    (12, "fr", "Le Cratère Est", "Cratère résultant d'une chute de météorite. Personne n'ose s'y aventurer, il parait que la météorite a donnée vie au sol et qu'il est probable qu'un monstre s'y ballade."),

    (13, "en", "Tywardreath Forest", "This forest has not been destroyed by orcs, it is full of life, both in terms of fauna and flora. It is also where most adventurers go to enjoy the new world"),
    (13, "fr", "La Forêt de Tywardreath", "Cette forêt n'a pas été détruite par les orcs, elle regorge de vie, tant au niveau de la faune que de la flore. C'est aussi ici que vont la plupart des aventuriers pour profiter du nouveau monde."),

    (14, "en", "Tywardreath Desert Outpost", "An important outpost, the Desert Outpost, allows adventurers to prepare for the great journey to the desert."),
    (14, "fr", "L'avant-poste du Désert", "Avant-poste important, l'Avant-Poste du Desert, permet aux aventuriers de se préparer au grand voyage vers le désert.");

-- Paths
INSERT INTO areaspaths
VALUES
    (8, 9, 60, 0),
    (9, 8, 60, 0),
    (9, 10, 40, 0),
    (10, 9, 40, 0),
    (10, 11, 30, 0),
    (11, 10, 30, 0),
    (9, 12, 40, 0),
    (12, 9, 40, 0),
    (9, 13, 60, 0),
    (13, 9, 60, 0),
    (13, 14, 30, 0),
    (14, 13, 30, 0),
    (8, 6, 300, 500),
    (6, 8, 300, 500);

INSERT INTO areasmonsterslevels
VALUES
    (8, 20, 20),
    (9, 20, 25),
    (10, 25, 30),
    (11, 40, 40),
    (12, 30, 35),
    (13, 35, 40),
    (14, 40, 40);


-- Regions 

INSERT INTO regions
VALUES
    (null);

INSERT INTO localizationregions
VALUES
    (2, "en", "Tywardreath", "https://image.ibb.co/i60da0/tywardreath-en.png"),
    (2, "fr", "Tywardreath", "https://image.ibb.co/hAuPhf/tywardreath-fr.png");

INSERT INTO areasregions
VALUES
    (8, 2),
    (9, 2),
    (10, 2),
    (11, 2),
    (12, 2),
    (13, 2),
    (14, 2);


-- Monstres 31 grp 30

INSERT INTO monstres
VALUES
    (31, 0, 1),
    (32, 0, 1),
    (33, 0, 1),
    (34, 0, 1),
    (35, 0, 2),

    (36, 0, 1),
    (37, 0, 2),

    (38, 0, 1),
    (39, 0, 2),

    (40, 0, 1),
    (41, 0, 1),
    (42, 0, 2),

    (43, 0, 2),
    (44, 0, 3);

INSERT INTO localizationmonsters
VALUES
    (31, "en", "Wutgarek Warrior"),
    (31, "fr", "Guerrier Wutgarek"),

    (32, "en", "Wutgarek Archer"),
    (32, "fr", "Archer Wutgarek"),

    (33, "en", "Wutgarek Berserker"),
    (33, "fr", "Berserker Wutgarek"),

    (34, "en", "Wutgarek Wizard"),
    (34, "fr", "Mage Wutgarek"),

    (35, "en", "Wutgarek Sergeant"),
    (35, "fr", "Sergent Wutgarek"),

    (36, "en", "Bear"),
    (36, "fr", "Ours"),

    (37, "en", "Tywardreath Great Bear"),
    (37, "fr", "Grand Ours de Tywardreath"),

    (38, "en", "Stone Golem"),
    (38, "fr", "Golem de Pierre"),

    (39, "en", "Meteorite Golem"),
    (39, "fr", "Golem Météorite"),

    (40, "en", "Great Wolf"),
    (40, "fr", "Grand Loup"),

    (41, "en", "Great Wild Boar"),
    (41, "fr", "Grand Sanglier"),

    (42, "en", "Tywardreath Great Wolf"),
    (42, "fr", "Grand Loup de Tywardreath"),

    (43, "en", "Tywardreath Flying Snake"),
    (43, "fr", "Serpent Volant de Tywardreath"),

    (44, "en", "Tywardreath Red Eyed Flying Snake"),
    (44, "fr", "Serpent Volant aux Yeux Rouge de Tywardreath");


-- 2 smorc, 3 tank_stun, 4 crit, 5 tank_armor_stun, 6 tank_will, 7 damage, 8 damage_crit, 9 tanky

INSERT INTO statsmonstres
VALUES
    (31, 3),
    (32, 8),
    (33, 2),
    (34, 7),
    (35, 9),

    (36, 6),
    (37, 3),

    (38, 9),
    (39, 7),

    (40, 8),
    (41, 2),
    (42, 4),

    (43, 4),
    (44, 9);


INSERT INTO monstresgroupes
VALUES
    (30, 31, 1),
    (31, 32, 1),
    (32, 35, 1),

    (33, 36, 1),
    (34, 37, 1),

    (35, 38, 1),
    (36, 39, 1),

    (37, 40, 1),
    (38, 41, 1),
    (39, 42, 1),

    (40, 43, 2),
    (40, 44, 1);

INSERT INTO areasmonsters
VALUES
    (9, 30, 31),
    (9, 31, 32),
    (9, 32, 35),

    (10, 33, 36),
    (10, 34, 37),

    (12, 35, 38),
    (12, 36, 39),

    (13, 37, 40),
    (13, 38, 41),
    (13, 39, 42),

    (11, 40, 43),
    (11, 40, 44);


INSERT INTO areasitems
VALUES
    -- Burned forest
    (9, 2, 0, 1, 1),
    (9, 3, 0, 1, 1),
    (9, 4, 0, 1, 1),
    (9, 7, 0, 1, 1),
    (9, 8, 0, 1, 1),
    (9, 9, 0, 1, 1),
    (9, 12, 0, 1, 1),
    (9, 13, 0, 1, 1),
    (9, 14, 0, 1, 1),
    (9, 15, 0, 1, 1),
    (9, 17, 0, 1, 1),
    (9, 18, 0, 1, 1),
    (9, 19, 0, 1, 1),
    -- Hills
    (10, 2, 0, 1, 1),
    (10, 3, 0, 1, 1),
    (10, 4, 0, 1, 1),
    (10, 5, 0, 1, 1),
    (10, 7, 0, 1, 1),
    (10, 8, 0, 1, 1),
    (10, 9, 0, 1, 1),
    (10, 12, 0, 1, 1),
    (10, 13, 0, 1, 1),
    (10, 14, 0, 1, 1),
    (10, 17, 0, 1, 1),
    (10, 18, 0, 1, 1),
    (10, 19, 0, 1, 1),
    -- Crater
    (12, 2, 0, 1, 1),
    (12, 3, 0, 1, 1),
    (12, 4, 0, 1, 1),
    (12, 7, 0, 1, 1),
    (12, 8, 0, 1, 1),
    (12, 9, 0, 1, 1),
    (12, 12, 0, 1, 1),
    (12, 13, 0, 1, 1),
    (12, 14, 0, 1, 1),
    (12, 17, 0, 1, 1),
    (12, 18, 0, 1, 1),
    (12, 19, 0, 1, 1),
    (12, 20, 0, 1, 1),
    -- Forest
    (13, 3, 0, 1, 1),
    (13, 4, 0, 1, 1),
    (13, 8, 0, 1, 1),
    (13, 9, 0, 1, 1),
    (13, 10, 0, 1, 1),
    (13, 13, 0, 1, 1),
    (13, 14, 0, 1, 1),
    (13, 18, 0, 1, 1),
    (13, 19, 0, 1, 1),
    -- Caves
    (11, 5, 0, 1, 1),
    (11, 10, 0, 1, 1),
    (11, 15, 0, 1, 1),
    (11, 20, 0, 1, 1);


INSERT INTO areasresources
VALUES

    (9, 21),
    (9, 26),
    (9, 27),
    (9, 28),
    (9, 31),

    (10, 22),
    (10, 23),
    (10, 24),
    (10, 25),
    (10, 28),

    (12, 21),
    (12, 22),
    (12, 23),
    (12, 26),
    (12, 31),

    (13, 21),
    (13, 28),
    (13, 29),
    (13, 30),
    (13, 31),
    (13, 32),
    (13, 33),
    (13, 34),
    (13, 35);



INSERT INTO craftbuilding
VALUES
    (3, 8, 1, 3, 5, 21, 30),
    (4, 14, 1, 3, 5, 31, 40);




