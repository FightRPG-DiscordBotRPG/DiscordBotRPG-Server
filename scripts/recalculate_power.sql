-- Should be Updated For 1.10

REPLACE INTO itemspower SELECT idItem, 
FLOOR(COALESCE((SELECT DISTINCT
(
    SELECT
    COALESCE((SELECT DISTINCT
        (
        SELECT
            COALESCE(SUM(itemsstats.value) / 100, 0) AS powerValue
        FROM
            itemsstats
        WHERE
            idItem = subItems.idItem AND itemsstats.idStat IN(1, 2, 5)
    )+
    (
        SELECT
            COALESCE(
                SUM(itemsstats.value) / 100 * 0.25
            , 0) AS powerValue
        FROM
            itemsstats
        WHERE
            idItem = subItems.idItem AND itemsstats.idStat IN(8, 10)
    )+
    (
        SELECT
            COALESCE(
                SUM(itemsstats.value) / 100 * 0.9
            , 0) AS powerValue
        FROM
            itemsstats
        WHERE
            idItem = subItems.idItem AND itemsstats.idStat IN(3, 6)
    )+
    (
        SELECT
            COALESCE(
                SUM(itemsstats.value) / 100 * 0.65
            , 0) AS powerValue
        FROM
            itemsstats
        WHERE
            idItem = subItems.idItem AND itemsstats.idStat IN(7, 9)
    )+
    (
        SELECT
            COALESCE(
                SUM(itemsstats.value) / CEIL((8 *(POW(50, 2)) / 7) / 4.5) * 0.65
            , 0) AS powerValue
        FROM
            itemsstats
        WHERE
            idItem = subItems.idItem AND itemsstats.idStat = 4
    )
    FROM
        items
    WHERE
        items.idItem = subItems.idItem), 0)
    as power FROM items subItems3 WHERE idItem = subItems.idItem
)
+
(
    SELECT  
    COALESCE((SELECT DISTINCT
    (
        SELECT
            COALESCE(
                SUM(itemssecondarystats.value) / 10 * 0.7
            , 0) AS powerValue
        FROM
            itemssecondarystats
        WHERE
            idItem = subItems.idItem AND itemssecondarystats.idSecondaryStat IN (1, 2, 3, 9, 10)
    )
    +
    (
        SELECT
            COALESCE(
                SUM(itemssecondarystats.value) / 10 * 0.5
            , 0) AS powerValue
        FROM
            itemssecondarystats
        WHERE
            idItem = subItems.idItem AND itemssecondarystats.idSecondaryStat IN (6)
    )
    +
    (
        SELECT
            COALESCE(
                SUM(itemssecondarystats.value) / 10 * 0.6
            , 0) AS powerValue
        FROM
            itemssecondarystats
        WHERE
            idItem = subItems.idItem AND itemssecondarystats.idSecondaryStat IN (7, 8)
    )
    +
    (
        SELECT
            COALESCE(
                SUM(itemssecondarystats.value) / 10 * 0.2
            , 0) AS powerValue
        FROM
            itemssecondarystats
        WHERE
            idItem = subItems.idItem AND itemssecondarystats.idSecondaryStat IN (4, 5, 11, 12)
    )
    FROM
        itemssecondarystats
    WHERE
        itemssecondarystats.idItem = subItems.idItem), 0)
    as power FROM items subItems2 WHERE idItem = subItems.idItem
)
+
(
    SELECT
        COALESCE(
            SUM(itemssecondarystatselementalresists.value) / 10
        , 0) AS powerValue
    FROM
        itemssecondarystatselementalresists
    WHERE
        idItem = subItems.idItem AND itemssecondarystatselementalresists.idElementType IN (1, 2, 3, 4, 5, 6, 7)
)
FROM
    items
WHERE
    items.idItem = subItems.idItem), 0)/5 *100)
as power FROM items subItems