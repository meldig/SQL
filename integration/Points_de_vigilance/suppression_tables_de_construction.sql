-- Suppression de la table d'import et de ses métadonnées spatiales ;
DROP TABLE G_GEO.TEMP_POINT_VIGILANCE CASCADE CONSTRAINTS;

DELETE
FROM 
	USER_SDO_GEOM_METADATA
WHERE
	TABLE_NAME = 'TEMP_POINT_VIGILANCE';
COMMIT;
/