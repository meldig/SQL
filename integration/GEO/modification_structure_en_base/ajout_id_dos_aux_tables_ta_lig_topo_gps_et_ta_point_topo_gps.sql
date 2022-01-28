/* 
Requêtes pour ajouter une colonne ID_DOS aux tables TEMP_TA_LIG_TOPO_GPS et TA_POINT_TOPO_GPS et remplir les colonnes
seul les éléments qui ont un GEO_REF:
	- commençant par REC_ ou IC_ ;
	- et dont la sous chaine SUBSTR(a.GEO_REF, INSTR(a.GEO_REF, '_') +1, LENGTH(a.GEO_REF)) (soit la suite de chiffre qui suit le ‘_’) est dans TA_GG_DOSSIER
verront leur attribut ID_DOS mise à jour
*/

/*
1. Ajout de la colonne ID_DOS aux tables
- TEMP_TA_LIG_TOPO_GPS
- TA_POINT_TOPO_GPS
*/

-- 1.1. Ajout de la colonne ID_DOS à la table TEMP_TA_LIG_TOPO_GPS
ALTER TABLE GEO.TEMP_TA_LIG_TOPO_GPS
ADD ID_DOS NUMBER(38,0);

COMMENT ON COLUMN GEO.TEMP_TA_LIG_TOPO_GPS.ID_DOS IS 'Identifiant de chaque dossier de récolement ou d''investigation complémentaire duquel est issue chaque entité de la table.';

-- 1.2. Ajout de la colonne ID_DOS à la table TA_POINT_TOPO_GPS
ALTER TABLE GEO.TA_POINT_TOPO_GPS
ADD ID_DOS NUMBER(38,0);

COMMENT ON COLUMN GEO.TEMP_TA_POINT_TOPO_GPS.ID_DOS IS 'Identifiant de chaque dossier de récolement ou d''investigation complémentaire duquel est issue chaque entité de la table.';

/*
2. Mise à jour des colonnes ID_DOS des tables
- TEMP_TA_LIG_TOPO_GPS
- TA_POINT_TOPO_GPS
*/

-- 2.1. Mise à jour de la colonne ID_DOS de la table TEMP_TA_LIG_TOPO_GPS
MERGE INTO GEO.TEMP_TA_LIG_TOPO_GPS a
USING
	(
		SELECT
		    a.OBJECTID,
		    CAST(SUBSTR(a.GEO_REF, INSTR(a.GEO_REF, '_') +1, LENGTH(a.GEO_REF)) AS NUMBER) AS ID_DOS
		FROM
		    GEO.TEMP_TA_LIG_TOPO_GPS a
		WHERE
		    CAST(SUBSTR(a.GEO_REF, INSTR(a.GEO_REF, '_') +1, LENGTH(a.GEO_REF))AS NUMBER) IN 
		        (
		            SELECT
		                DISTINCT(a.ID_DOS)
		            FROM
		                GEO.TA_GG_DOSSIER a
		        )
		AND (a.GEO_REF LIKE 'REC_%'
		    OR a.GEO_REF LIKE 'IC_%')
	)b
ON(a.OBJECTID = b.OBJECTID)
WHEN MATCHED THEN UPDATE
SET a.ID_DOS = b.ID_DOS;

-- 2.2. Mise à jour de la colonne ID_DOS de la table  ALTER TABLE GEO.TA_POINT_TOPO_GPS
MERGE INTO GEO.TA_POINT_TOPO_GPS a
USING
	(
		SELECT
		    a.OBJECTID,
		    CAST(SUBSTR(a.GEO_REF, INSTR(a.GEO_REF, '_') +1, LENGTH(a.GEO_REF)) AS NUMBER) AS ID_DOS
		FROM
		    GEO.TA_POINT_TOPO_GPS a
		WHERE
		    CAST(SUBSTR(a.GEO_REF, INSTR(a.GEO_REF, '_') +1, LENGTH(a.GEO_REF))AS NUMBER) IN 
		        (
		            SELECT
		                DISTINCT(a.ID_DOS)
		            FROM
		                GEO.TA_GG_DOSSIER a
		        )
		AND (a.GEO_REF LIKE 'REC_%'
		    OR a.GEO_REF LIKE 'IC_%')
	)b
ON(a.OBJECTID = b.OBJECTID)
WHEN MATCHED THEN UPDATE
SET a.ID_DOS = b.ID_DOS;

COMMIT;