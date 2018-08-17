CREATE PROCEDURE `doesPlayerHaveEnoughMatsToCraftThisItem` (IN idCharacterToLook INT, IN idCaftToLook INT)
BEGIN
	SELECT 
    IF((SELECT 
                COUNT(*)
            FROM
                charactersinventory
                    INNER JOIN
                items ON items.idItem = charactersinventory.idItem
            WHERE
                charactersinventory.idCharacter = idCharacterToLook
                    AND items.idBaseItem IN (SELECT 
                        craftitemsneeded.NeededItem
                    FROM
                        craftitemsneeded
                    WHERE
                        craftitemsneeded.IdCraftItem = idCaftToLook)
                    AND charactersinventory.number >= (SELECT 
                        craftitemsneeded.number
                    FROM
                        craftitemsneeded
                    WHERE
                        craftitemsneeded.IdCraftItem = idCaftToLook
                            AND craftitemsneeded.NeededItem = items.idBaseItem)) = (SELECT 
                COUNT(*)
            FROM
                craftitemsneeded
            WHERE
                craftitemsneeded.IdCraftItem = idCaftToLook),
        'true',
        'false') AS doesPlayerHaveEnoughMats;
END