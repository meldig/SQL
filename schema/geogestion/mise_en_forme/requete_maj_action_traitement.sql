-- Insertion des valeurs dans la table TA_GG_LIBELLE (longueur, largeur, decalage gauche et decalage droite)
MERGE INTO G_GESTIONGEO.TA_GG_LIBELLE_LONG a
USING
	(
		SELECT 'Insertion' AS VALEUR FROM DUAL UNION
		SELECT 'Suppression' AS VALEUR FROM DUAL UNION
		SELECT 'Modification' AS VALEUR FROM DUAL
	)b
ON (TRIM(LOWER(a.VALEUR)) = TRIM(LOWER(b.VALEUR)))
WHEN NOT MATCHED THEN
INSERT (a.VALEUR)
VALUES (b.VALEUR)
;

-- Insertion de la famille mesure dans TA_GG_FAMILLE
MERGE INTO G_GESTIONGEO.TA_GG_FAMILLE a
USING
	(
		SELECT 'Type d''action' AS LIBELLE FROM DUAL
	)b
ON (TRIM(LOWER(a.LIBELLE)) = TRIM(LOWER(b.LIBELLE)))
WHEN NOT MATCHED THEN
INSERT (a.LIBELLE)
VALUES (b.LIBELLE)
;


-- Insertion des relations libelle et famille

MERGE INTO G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE a
USING
	(
	SELECT
	    a.objectid AS FID_LIBELLE,
	    b.objectid AS FID_FAMILLE
	FROM
	    G_GESTIONGEO.TA_GG_LIBELLE_LONG a,
	    G_GESTIONGEO.TA_GG_FAMILLE b
	WHERE
	    (
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Insertion')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Suppression')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Modification'))
	    )
	    AND LOWER(TRIM(b.libelle)) IN LOWER(TRIM('Type d''action'))
	)b
ON (a.FID_FAMILLE = b.FID_FAMILLE
AND a.FID_LIBELLE = b.FID_LIBELLE)
WHEN NOT MATCHED THEN
INSERT (a.FID_FAMILLE,a.FID_LIBELLE)
VALUES (b.FID_FAMILLE,b.FID_LIBELLE)
;

-- Insertion des libelles long dans TA_GG_LIBELLE

MERGE INTO G_GESTIONGEO.TA_GG_LIBELLE a
USING
	(
	SELECT
	    a.objectid AS FID_LIBELLE_LONG
	FROM
	    G_GESTIONGEO.TA_GG_LIBELLE_LONG a
	    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE b ON b.FID_LIBELLE = a.OBJECTID
	    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE c ON c.OBJECTID = b.FID_FAMILLE
	WHERE
	    (
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Insertion')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Modification')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Suppression'))
	    )
	    AND LOWER(TRIM(c.libelle)) IN LOWER(TRIM('Type d''action'))
	)b
ON (a.FID_LIBELLE_LONG = b.FID_LIBELLE_LONG)
WHEN NOT MATCHED THEN
INSERT (a.FID_LIBELLE_LONG)VALUES (b.FID_LIBELLE_LONG)
;

/