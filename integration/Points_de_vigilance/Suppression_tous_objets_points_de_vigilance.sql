/*
Requêtes permettant la suppression de tous les objets, et donc des données, liés aux points de vigilance (tables, contraintes, déclencheurs).
	1. Suppression de la table d'import et de ses métadonnées spatiales ;
	2. Suppression de la table pivot permettant d'associer un point de vigilance à un permis de construire ;
	3. Suppression de la table des permis de construire ;
	4. Suppression de la table d'audit ;
	5. Suppression de la table des points de vigilance et de ses métadonnées spatiales ;
*/

-- 1. Suppression de la table d'import et de ses métadonnées spatiales ;
	DROP TABLE G_GEO.TEMP_POINT_VIGILANCE CASCADE CONSTRAINTS;

	DELETE 
	FROM 
		USER_SDO_GEOM_METADATA 
	WHERE 
		TABLE_NAME = 'TEMP_POINT_VIGILANCE';

-- 2. Suppression de la table pivot permettant d'associer un point de vigilance à un permis de construire ;
	DROP TABLE G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE CASCADE CONSTRAINTS;

-- 3. Suppression de la table des permis de construire ;
	DROP TABLE G_GEO.TA_GG_PERMIS_CONSTRUIRE CASCADE CONSTRAINTS;

-- 4. Suppression de la table d'audit ;
	DROP TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT  CASCADE CONSTRAINTS;

-- 5. Suppression de la table des points de vigilance et de ses métadonnées spatiales ;
	DROP TABLE G_GEO.TA_GG_POINT_VIGILANCE CASCADE CONSTRAINTS;

	DELETE 
	FROM 
		USER_SDO_GEOM_METADATA 
	WHERE 
		TABLE_NAME = 'TA_GG_POINT_VIGILANCE';
	COMMIT;
	/