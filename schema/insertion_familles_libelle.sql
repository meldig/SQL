-- Insertion des familles
INSERT INTO G_GEO.TA_FAMILLE(valeur)
SELECT
	'etat avancement' AS valeur
FROM
	DUAL
UNION ALL
SELECT
	'thèmes de grilles' AS valeur
FROM
	DUAL;

-- Insertion des libellés
INSERT INTO G_GEO.TA_LIBELLE_LONG(valeur)
SELECT
	libelle
FROM
	G_GEO.TEMP_LIBELLE;

INSERT INTO G_GEO.TA_LIBELLE_LONG(valeur)
SELECT
	thematique
FROM
	G_GEO.TEMP_THEMATIQUE;

-- Insertion des relations famille/libelle
-- Etat d'avancement
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING(
	SELECT
		a.objectid AS fid_famille,
		b.objectid AS fid_libelle_long
	FROM
		G_GEO.TA_FAMILLE a,
		G_GEO.TA_LIBELLE_LONG b
	WHERE
		UPPER(a.valeur) = UPPER('etat avancement')
		AND UPPER(b.valeur) IN(UPPER('a faire'), UPPER('fait partiellement'), UPPER('terminé'))
)f
ON (a.fid_famille = f.fid_famille AND a.fid_libelle_long = f.fid_libelle_long)
WHEN NOT MATCHED THEN
	INSERT(a.fid_famille, a.fid_libelle_long)
	VALUES(f.fid_famille, f.fid_libelle_long);

-- Thèmes de grille
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING(
	SELECT
		a.objectid AS fid_famille,
		b.objectid AS fid_libelle_long
	FROM
		G_GEO.TA_FAMILLE a,
		G_GEO.TA_LIBELLE_LONG b
	WHERE
		UPPER(a.valeur) = UPPER('thèmes de grilles')
		AND UPPER(b.valeur) IN(
								UPPER('Vérification du bati issu du lidar et du plan de gestion'), 
								UPPER('grille en cours de transition'), 
								UPPER('verification PLU2 : verification des elements du PLU2'),
								UPPER('controle dossier : comparaison des donnees baties avec orthophotographie 2018'),
								UPPER('controle dossier : comparaison des donnees baties avec orthophotographie 2020'),
								UPPER('recalage du bâti et de îlots par commune')
							)
)f
ON (a.fid_famille = f.fid_famille AND a.fid_libelle_long = f.fid_libelle_long)
WHEN NOT MATCHED THEN
	INSERT(a.fid_famille, a.fid_libelle_long)
	VALUES(f.fid_famille, f.fid_libelle_long);

-- Insertion dans TA_LIBELLE
MERGE INTO G_GEO.TA_LIBELLE a
USING(
	SELECT
		c.objectid AS fid_libelle_long
	FROM
		G_GEO.TA_FAMILLE a
		INNER JOIN G_GEO.TA_FAMILLE_LIBELLE b ON b.fid_famille = a.objectid
		INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.fid_libelle_long = b.fid_libelle_long
	WHERE
		UPPER(a.valeur) IN(
							UPPER('thèmes de grilles'),
							UPPER('etat avancement')
						)
)f
ON (a.fid_libelle_long = f.fid_libelle_long)
WHEN NOT MATCHED THEN
	INSERT(a.fid_libelle_long)
	VALUES(f.fid_libelle_long);
COMMIT;