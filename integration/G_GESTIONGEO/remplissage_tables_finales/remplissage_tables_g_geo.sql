/*
Instructions DML pour intégrer en base les libelles 
*/

-- 1. AJOUT DE LA FAMILLE URL
MERGE INTO G_GEO.TA_FAMILLE a
USING
	(
		SELECT
			'URL' AS VALEUR
		FROM
			DUAL
	)b
ON(a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;
COMMIT;


-- 2. AJOUT DES URLS DANS LA TABLE TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
USING
	(
		SELECT
			'/var/www/extraction/apps/gestiongeo' AS VALEUR
		FROM
			DUAL
		UNION
		SELECT
			'https://gtf.lillemetropole.fr/apps/gestiongeo/' AS VALEUR
		FROM
			DUAL
	)b
ON(a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;
COMMIT;


-- 3. Ajout des relations libelles/famille
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
ON(a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle_long)
VALUES (b.fid_libelle_long)
;
COMMIT;


-- 4. AJOUT DES CLES ETRANGERES DANS LA TABLE TA_LIBELLE
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
VALUES (b.fid_libelle_long)
;
COMMIT;