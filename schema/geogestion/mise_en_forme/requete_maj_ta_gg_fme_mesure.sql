-- Insertion des valeurs dans la table TA_GG_LIBELLE (longueur, largeur, decalage gauche et decalage droite)
MERGE INTO G_GESTIONGEO.TA_GG_LIBELLE_LONG a
USING
	(
		SELECT 'decalage abscisse gauche' AS VALEUR FROM DUAL UNION
		SELECT 'largeur' AS VALEUR FROM DUAL UNION
		SELECT 'longueur' AS VALEUR FROM DUAL UNION
		SELECT 'decalage abscisse droit' AS VALEUR FROM DUAL
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
		SELECT 'Mesure' AS LIBELLE FROM DUAL
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
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('largeur')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('longueur')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('decalage abscisse gauche')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('decalage abscisse droit'))
	    )
	    AND LOWER(TRIM(b.libelle)) IN LOWER(TRIM('mesure'))
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
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('largeur')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('longueur')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('decalage abscisse gauche')) OR
	    LOWER(TRIM(a.valeur)) IN LOWER(TRIM('decalage abscisse droit'))
	    )
	    AND LOWER(TRIM(c.libelle)) IN LOWER(TRIM('mesure'))
	)b
ON (a.FID_LIBELLE_LONG = b.FID_LIBELLE_LONG)
WHEN NOT MATCHED THEN
INSERT (a.FID_LIBELLE_LONG)VALUES (b.FID_LIBELLE_LONG)
;

-- Correction de la colonne FID_MESURE dans la table TA_GG_FME_MESURE, redirection de la clé étrangère 
UPDATE TA_GG_FME_MESURE a
SET FID_MESURE = 
(
WITH CTE AS 
		(
		SELECT 
		    a.objectid AS n_fid_mesure,
		    b.valeur AS n_libelle
		FROM 
		    G_GESTIONGEO.TA_GG_LIBELLE a
		    INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG b ON a.fid_libelle_long = b.objectid
		    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE c ON c.fid_libelle = b.objectid
		    INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE d ON d.objectid = c.fid_famille
		WHERE 
		    d.libelle = 'Mesure'
		),
	CTE_2 AS
		(
		SELECT 
		    e.objectid AS o_fid_mesure,
		    f.valeur AS o_libelle
		FROM
		    G_GEO.TA_LIBELLE e
		    INNER JOIN G_GEO.TA_LIBELLE_LONG f ON e.fid_libelle_long = f.objectid
		    INNER JOIN G_GEO.TA_FAMILLE_LIBELLE g ON g.fid_libelle_long = f.objectid
		    INNER JOIN G_GEO.TA_FAMILLE h ON h.objectid = g.fid_famille
		WHERE
	        h.valeur = 'Mesure'
		),
	CTE_3 AS
		(
		SELECT
			cte.n_fid_mesure,
			cte.n_libelle,
			cte_2.o_fid_mesure,
			cte_2.o_libelle
		FROM
			CTE
			INNER JOIN CTE_2 ON cte.n_libelle = cte_2.o_libelle
		)
        SELECT cte_3.n_fid_mesure FROM CTE_3 WHERE a.FID_MESURE = cte_3.o_fid_mesure
);

/