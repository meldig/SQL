/*
Instructions DML pour intégrer en base les libelles 
*/

-- 1. Ajout de la famille URL et Mesure
MERGE INTO G_GEO.TA_FAMILLE a
USING
	(
		SELECT
            289 AS id_famille,
			'URL' AS VALEUR
		FROM
			DUAL
		UNION ALL
		SELECT
            309 AS id_famille,
            'Mesure' AS valeur
        FROM
		DUAL
	)b
ON(UPPER(a.valeur) = UPPER(b.valeur) AND a.objectid = b.id_famille)
WHEN NOT MATCHED THEN
INSERT (a.objectid, a.valeur)
VALUES (b.id_famille, b.valeur)
;
COMMIT;


-- 2. AJOUT DES URLS et des mesures DANS LA TABLE TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
USING
	(
		SELECT
            841 AS id_libelle_long,
			'/var/www/extraction/apps/gestiongeo' AS VALEUR
		FROM
			DUAL
		UNION ALL
		SELECT
            840 AS id_libelle_long,
			'https://gtf.lillemetropole.fr/apps/gestiongeo/' AS VALEUR
		FROM
			DUAL
		UNION ALL
		SELECT
            860 AS id_libelle_long,
			'longeur' AS VALEUR
		FROM
			DUAL
		UNION ALL
		SELECT
            862 AS id_libelle_long,
			'largeur' AS valeur
		FROM
			DUAL
		UNION ALL
		SELECT
            861 AS id_libelle_long,
			'decalage abscisse droit' AS valeur
		FROM
			DUAL
		UNION ALL
		SELECT
            863 AS id_libelle_long,
			'decalage abscisse gauche' AS valeur
		FROM
			DUAL
	)b
ON(UPPER(a.valeur) = UPPER(b.valeur) AND a.objectid = b.id_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.objectid, a.valeur)
VALUES (b.id_libelle_long, b.valeur)
;
COMMIT;


-- 3. Ajout des relations libelles/famille
-- URL
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING
	(
		SELECT
			a.objectid AS FID_FAMILLE,
			b.objectid AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_FAMILLE a,
			G_GEO.TA_LIBELLE_LONG b
		WHERE
			UPPER(a.valeur) = UPPER('URL')
			AND UPPER(b.valeur) IN (UPPER('/var/www/extraction/apps/gestiongeo'),UPPER('https://gtf.lillemetropole.fr/apps/gestiongeo/'))
	)b
ON(a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES (b.fid_famille,b.fid_libelle_long);

-- Mesure/abscisses
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING
	(
	SELECT
		a.objectid AS fid_famille,
		b.objectid AS fid_libelle_long
	FROM
		G_GEO.TA_FAMILLE a,
		G_GEO.TA_LIBELLE_LONG b
	WHERE
		UPPER(a.valeur) = UPPER('Mesure')
		AND UPPER(b.valeur) IN (UPPER('longeur'),UPPER('largeur'),UPPER('decalage abscisse droit'),UPPER('decalage abscisse gauche'))
	)b
ON(a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES(b.fid_famille,b.fid_libelle_long);
COMMIT;


-- 4. AJOUT DES CLES ETRANGERES DANS LA TABLE TA_LIBELLE
-- URL
MERGE INTO G_GEO.TA_LIBELLE a
USING
	(
		SELECT
            1413 AS id_libelle,
			a.OBJECTID AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_LIBELLE_LONG a
		WHERE
			UPPER(a.valeur) = UPPER('/var/www/extraction/apps/gestiongeo')
        UNION ALL
        SELECT
            1412 AS id_libelle,
			a.OBJECTID AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_LIBELLE_LONG a
		WHERE
			UPPER(a.valeur) = UPPER('https://gtf.lillemetropole.fr/apps/gestiongeo/')
        UNION ALL
        SELECT
            1434 AS id_libelle,
			a.OBJECTID AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_LIBELLE_LONG a
		WHERE
			UPPER(a.valeur) = UPPER('longeur')
        UNION ALL
        SELECT
            1432 AS id_libelle,
			a.OBJECTID AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_LIBELLE_LONG a
		WHERE
			UPPER(a.valeur) = UPPER('largeur')
        UNION ALL
        SELECT
            1433 AS id_libelle,
			a.OBJECTID AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_LIBELLE_LONG a
		WHERE
			UPPER(a.valeur) = UPPER('decalage abscisse droit')
        UNION ALL
        SELECT
            1435 AS id_libelle,
			a.OBJECTID AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_LIBELLE_LONG a
		WHERE
			UPPER(a.valeur) = UPPER('decalage abscisse gauche')
	)b
ON(a.fid_libelle_long = b.fid_libelle_long AND a.objectid = b.id_libelle)
WHEN NOT MATCHED THEN
INSERT (a.objectid, a.fid_libelle_long)
VALUES (b.id_libelle, b.fid_libelle_long);

/*
-- 1. Ajout de la famille URL et Mesure
MERGE INTO G_GEO.TA_FAMILLE a
USING
	(
		SELECT
			'URL' AS VALEUR
		FROM
			DUAL
		UNION ALL
		SELECT
		'Mesure' AS valeur
	FROM
		DUAL
	)b
ON(UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;
COMMIT;


-- 2. AJOUT DES URLS et des mesures DANS LA TABLE TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
USING
	(
		SELECT
			'/var/www/extraction/apps/gestiongeo' AS VALEUR
		FROM
			DUAL
		UNION ALL
		SELECT
			'https://gtf.lillemetropole.fr/apps/gestiongeo/' AS VALEUR
		FROM
			DUAL
		UNION ALL
		SELECT
			'longeur' AS VALEUR
		FROM
			DUAL
		UNION ALL
		SELECT
			'largeur' AS valeur
		FROM
			DUAL
		UNION ALL
		SELECT
			'decalage abscisse droit' AS valeur
		FROM
			DUAL
		UNION ALL
		SELECT
			'decalage abscisse gauche' AS valeur
		FROM
			DUAL
	)b
ON(UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;
COMMIT;


-- 3. Ajout des relations libelles/famille
-- URL
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING
	(
		SELECT
			a.objectid AS FID_FAMILLE,
			b.objectid AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_FAMILLE a,
			G_GEO.TA_LIBELLE_LONG b
		WHERE
			UPPER(a.valeur) = UPPER('URL')
			AND UPPER(b.valeur) IN (UPPER('/var/www/extraction/apps/gestiongeo'),UPPER('https://gtf.lillemetropole.fr/apps/gestiongeo/'))
	)b
ON(a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES (b.fid_famille,b.fid_libelle_long);

-- Mesure/abscisses
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING
	(
	SELECT
		a.objectid AS fid_famille,
		b.objectid AS fid_libelle_long
	FROM
		G_GEO.TA_FAMILLE a,
		G_GEO.TA_LIBELLE_LONG b
	WHERE
		UPPER(a.valeur) = UPPER('Mesure')
		AND UPPER(b.valeur) IN (UPPER('longeur'),UPPER('largeur'),UPPER('decalage abscisse droit'),UPPER('decalage abscisse gauche'))
	)b
ON(a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES(b.fid_famille,b.fid_libelle_long);
COMMIT;


-- 4. AJOUT DES CLES ETRANGERES DANS LA TABLE TA_LIBELLE
-- URL
MERGE INTO G_GEO.TA_LIBELLE a
USING
	(
		SELECT
			a.OBJECTID AS FID_LIBELLE_LONG
		FROM
			G_GEO.TA_LIBELLE_LONG a
		WHERE
			UPPER(a.valeur) IN (UPPER('/var/www/extraction/apps/gestiongeo'),UPPER('https://gtf.lillemetropole.fr/apps/gestiongeo/'))
	)b
ON(a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle_long)
VALUES (b.fid_libelle_long);

-- Mesures / abscisses
MERGE INTO G_GEO.TA_LIBELLE a
USING
	(
	SELECT
		a.objectid AS fid_libelle_long
	FROM
		TA_LIBELLE_LONG a
	WHERE
		UPPER(a.valeur) IN (UPPER('longeur'),UPPER('largeur'),UPPER('decalage abscisse droit'),UPPER('decalage abscisse gauche'))
	)b
ON(a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT(a.fid_libelle_long)
VALUES(b.fid_libelle_long);
*/

COMMIT;