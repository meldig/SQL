/*
Ajout du champ ID_DOS aux tables TA_LIG_TOPO_F et TA_POINT_TOPO_F, 
permettant de rattacher un élément du plan topo fin à un dossier de récolement ou d'investigation complémentaire.
*/

-- 1. TA_LIG_TOPO_F
-- 1.1. Création du nouveau champ
ALTER TABLE GEO.TA_LIG_TOPO_F
ADD ID_DOS NUMBER(38,0);

-- 1.2. Création du commentaire du nouveau champ
COMMENT ON COLUMN GEO.TA_LIG_TOPO_F.ID_DOS IS 'Identifiant du dossier de récolement ou d''investigation complémentaire auquel appartient chaque entité de la table.';

-- 1.3. Remplissage du nouveau champ
MERGE INTO GEO.TA_LIG_TOPO_F a
	USING(
		SELECT
		    a.OBJECTID,
		    CAST(
	    		SUBSTR(
	    				a.GEO_REF, 
	    				INSTR(a.GEO_REF, '_') +1, 
	    				LENGTH(a.GEO_REF)
	    		) 
		    	AS NUMBER
		    ) AS ID_DOS
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
	)t
ON(a.objectid = t.objectid)
WHEN MATCHED THEN
	UPDATE SET a.id_dos = t.id_dos;
COMMIT;

-- 2. TA_POINT_TOPO_F
-- 2.1. Création du nouveau champ
ALTER TABLE GEO.TA_POINT_TOPO_F
ADD ID_DOS NUMBER(38,0);

-- 1.2. Création du commentaire du nouveau champ
COMMENT ON COLUMN GEO.TA_POINT_TOPO_F.ID_DOS IS 'Identifiant du dossier de récolement ou d''investigation complémentaire auquel appartient chaque entité de la table.';

-- 1.3. Remplissage du nouveau champ
MERGE INTO GEO.TA_POINT_TOPO_F a
	USING(
		SELECT
		    a.OBJECTID,
		    CAST(
		    	SUBSTR(
		    		a.GEO_REF, 
		    		INSTR(a.GEO_REF, '_') +1, 
		    		LENGTH(a.GEO_REF)
		    	) 
		    	AS NUMBER
		    ) AS ID_DOS
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
	)t
ON(a.objectid = t.objectid)
WHEN MATCHED THEN
	UPDATE SET a.id_dos = t.id_dos;
COMMIT;

/

