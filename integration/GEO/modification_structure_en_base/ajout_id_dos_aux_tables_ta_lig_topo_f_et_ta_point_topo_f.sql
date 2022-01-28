/*
Ajout du champ ID_DOS aux tables TA_LIG_TOPO_F et TA_POINT_TOPO_F, 
permettant de rattacher un élément du plan topo fin à un dossier de récolement ou d'investigation complémentaire.
*/

-- 1. TA_LIG_TOPO_F
-- 1.1. Création du nouveau champ
ALTER TABLE GEO.TA_LIG_TOPO_F
ADD COLUMN ID_DOS NUMBER(38,0);

-- 1.2. Création du commentaire du nouveau champ
COMMENT ON COLUMN GEO.TA_LIG_TOPO_F.ID_DOS IS 'Identifiant du dossier de récolement ou d''investigation complémentaire auquel appartient chaque entité de la table.';

-- 1.3. Remplissage du nouveau champ
MERGE INTO GEO.TA_LIG_TOPO_F a
	USING(
		SELECT
			objectid,
			id_dos
		FROM
			GEO.TA_LIG_TOPO_GPS
		WHERE
            id_dos IS NOT NULL
	)t
ON(a.objectid = t.objectid)
WHEN MATCHED THEN
	UPDATE SET a.id_dos = t.id_dos;
COMMIT;

-- 2. TA_POINT_TOPO_F
-- 2.1. Création du nouveau champ
ALTER TABLE GEO.TA_POINT_TOPO_F
ADD COLUMN ID_DOS NUMBER(38,0);

-- 1.2. Création du commentaire du nouveau champ
COMMENT ON COLUMN GEO.TA_POINT_TOPO_F.ID_DOS IS 'Identifiant du dossier de récolement ou d''investigation complémentaire auquel appartient chaque entité de la table.';

-- 1.3. Remplissage du nouveau champ
MERGE INTO GEO.TA_POINT_TOPO_F a
	USING(
		SELECT
			objectid,
			id_dos
		FROM
			GEO.TA_POINT_TOPO_GPS
		WHERE
            id_dos IS NOT NULL
	)t
ON(a.objectid = t.objectid)
WHEN MATCHED THEN
	UPDATE SET a.id_dos = t.id_dos;
COMMIT;

/

