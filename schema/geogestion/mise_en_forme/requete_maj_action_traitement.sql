-------------------------------------------------------
------------ REQUETE_MAJ_ACTION_TRAITEMENT ------------
-------------------------------------------------------

-- Insertion des valeurs dans la table TA_GG_LIBELLE (longueur, largeur, decalage gauche et decalage droite)
/*
MERGE INTO G_GESTIONGEO.TA_GG_LIBELLE_LONG a
USING
	(
		SELECT 'Insertion' AS VALEUR FROM DUAL UNION
		SELECT 'Suppression' AS VALEUR FROM DUAL UNION
		SELECT 'Modification' AS VALEUR FROM DUAL UNION
		SELECT 'édition' AS VALEUR FROM DUAL
	)b
ON (TRIM(LOWER(a.VALEUR)) = TRIM(LOWER(b.VALEUR)))
WHEN NOT MATCHED THEN
INSERT (a.VALEUR)
VALUES (b.VALEUR)
;
*/


-- Insertion de la famille mesure dans TA_GG_FAMILLE
/*
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
*/

-- Insertion des libelles long dans TA_GG_LIBELLE
/*
MERGE INTO G_GESTIONGEO.TA_GG_LIBELLE a
USING
	(
	SELECT
	    a.objectid AS FID_LIBELLE_LONG
	FROM
	    G_GESTIONGEO.TA_GG_LIBELLE_LONG a
	WHERE
	    (
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Insertion')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Modification')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Suppression')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('édition'))
	    )
	)b
ON (a.FID_LIBELLE_LONG = b.FID_LIBELLE_LONG)
WHEN NOT MATCHED THEN
INSERT (a.FID_LIBELLE_LONG)VALUES (b.FID_LIBELLE_LONG)
;

*/

-- Insertion des relations libelle et famille
/*
MERGE INTO G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE a
USING
	(
	SELECT
	    a.objectid AS FID_LIBELLE,
	    b.objectid AS FID_FAMILLE
	FROM
	    G_GESTIONGEO.TA_GG_LIBELLE a
	    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG c ON c.OBJECTID = a.FID_LIBELLE_LONG,
	    G_GESTIONGEO.TA_GG_FAMILLE b
	WHERE
	    (
	    LOWER(TRIM(c.valeur)) IN LOWER(TRIM('Insertion')) OR
	    LOWER(TRIM(c.valeur)) IN LOWER(TRIM('Suppression')) OR
	    LOWER(TRIM(c.valeur)) IN LOWER(TRIM('Modification')) OR
	    LOWER(TRIM(c.valeur)) IN LOWER(TRIM('édition'))
	    )
	    AND LOWER(TRIM(b.libelle)) IN LOWER(TRIM('Type d''action'))
	)b
ON (a.FID_FAMILLE = b.FID_FAMILLE
AND a.FID_LIBELLE = b.FID_LIBELLE)
WHEN NOT MATCHED THEN
INSERT (a.FID_FAMILLE,a.FID_LIBELLE)
VALUES (b.FID_FAMILLE,b.FID_LIBELLE)
;
*/


------ TYPE ELEMENT

-- Insertion des valeurs dans la table TA_GG_LIBELLE (longueur, largeur, decalage gauche et decalage droite)
MERGE INTO G_GESTIONGEO.TA_GG_LIBELLE_LONG a
USING
	(
		SELECT 'Element point' AS VALEUR FROM DUAL UNION
		SELECT 'Elment lineaire' AS VALEUR FROM DUAL
	)b
ON (TRIM(LOWER(a.VALEUR)) = TRIM(LOWER(b.VALEUR)))
WHEN NOT MATCHED THEN
INSERT (a.VALEUR)
VALUES (b.VALEUR)
;

COMMIT;


-- Insertion de la famille mesure dans TA_GG_FAMILLE
MERGE INTO G_GESTIONGEO.TA_GG_FAMILLE a
USING
	(
		SELECT 'Type d''élément' AS LIBELLE FROM DUAL
	)b
ON (TRIM(LOWER(a.LIBELLE)) = TRIM(LOWER(b.LIBELLE)))
WHEN NOT MATCHED THEN
INSERT (a.LIBELLE)
VALUES (b.LIBELLE)
;

COMMIT;


-- Insertion des libelles long dans TA_GG_LIBELLE

MERGE INTO G_GESTIONGEO.TA_GG_LIBELLE a
USING
	(
	SELECT
	    a.objectid AS FID_LIBELLE_LONG
	FROM
	    G_GESTIONGEO.TA_GG_LIBELLE_LONG a
	WHERE
	    (
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Element point')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('Element lineaire'))
	    )
	)b
ON (a.FID_LIBELLE_LONG = b.FID_LIBELLE_LONG)
WHEN NOT MATCHED THEN
INSERT (a.FID_LIBELLE_LONG)VALUES (b.FID_LIBELLE_LONG)
;

COMMIT;

/


-- Insertion des relations libelle et famille

MERGE INTO G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE a
USING
	(
	SELECT
	    a.objectid AS FID_LIBELLE,
	    b.objectid AS FID_FAMILLE
	FROM
	    G_GESTIONGEO.TA_GG_LIBELLE a
	    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG c ON c.OBJECTID = a.FID_LIBELLE_LONG,
	    G_GESTIONGEO.TA_GG_FAMILLE b
	WHERE
	    (
	    LOWER(TRIM(c.valeur)) IN LOWER(TRIM('Element point')) OR
	    LOWER(TRIM(c.valeur)) IN LOWER(TRIM('Element lineaire'))
	    )
	    AND LOWER(TRIM(b.libelle)) IN LOWER(TRIM('Type d''élément'))
	)b
ON (a.FID_FAMILLE = b.FID_FAMILLE
AND a.FID_LIBELLE = b.FID_LIBELLE)
WHEN NOT MATCHED THEN
INSERT (a.FID_FAMILLE,a.FID_LIBELLE)
VALUES (b.FID_FAMILLE,b.FID_LIBELLE)
;

COMMIT;

/
