INSERT INTO sellableitems VALUES (NULL, 36, 1, 1, 3000), (NULL, 37, 1, 1, 15000); --17/18

INSERT INTO shopitems SELECT idShop, 17 FROM shop;
INSERT INTO shopitems SELECT idShop, 18 FROM shop;

-- Tywardreath horse
INSERT INTO areasitems SELECT areas.idArea, 38, 0.007, 1, 1 FROM areas INNER JOIN areasregions ON areasregions.idArea = areas.idArea WHERE areasregions.idRegion = 2 AND areas.idAreaType != 2;

-- Desert Horse
INSERT INTO areasitems SELECT areas.idArea, 39, 0.003, 1, 1 FROM areas INNER JOIN areasregions ON areasregions.idArea = areas.idArea WHERE areasregions.idRegion = 3 AND areas.idAreaType != 2;

-- Palefroi de Feu
INSERT INTO areasitems SELECT areas.idArea, 40, 0.0005, 1, 1 FROM areas INNER JOIN areasregions ON areasregions.idArea = areas.idArea WHERE areasregions.idRegion = 4 AND areas.idAreaType = 3;