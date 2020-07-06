-- 1. Insertion des communes belges dans la base oracle;

INSERT INTO ta_organisme(acronyme, nom_organisme)
VALUES('IGN', 'Institut Géographique National Belge');
COMMIT;

-- 2. Insertion des metadonnees
-- 2.1. Insertion dans ta_source
INSERT INTO ta_source(nom_source, description)
VALUES('Inventaire topogéographique du territoire belge', 'AdminVector est la série de données vectorielles qui contient les données vectorielles administratives de l''IGN les plus précises géométriquement et les plus détaillées sémantiquement. La série de données comporte 12 classes d''objets portant sur les secteurs statistiques, les anciennes communes, les communes, les arrondissements, les provinces, les régions et les limites territoriales et maritimes de la Belgique. La géométrie des données de tous ces thèmes est décrite par des coordonnées x,y ou x,y,z.');
COMMIT;

-- 2.2. Insertion dans ta_provenance
INSERT INTO ta_provenance(url, methode_acquisition)
VALUES('http://www.ngi.be/FR/FR1-5-2.shtm', 'Téléchargement de la donnée au format shape depuis le site de l''IGN belge.');
COMMIT;

-- 2.3. Insertion dans ta_date_acquisition
INSERT INTO ta_date_acquisition(date_acquisition, millesime, nom_obtenteur)
VALUES('18/02/2020', '04/11/2019', 'bjacq');
COMMIT;

-- 2.4. Insertion dans ta_echelle
INSERT INTO ta_echelle(valeur)
VALUES('10 000');
COMMIT;

-- 2.5. Insertion dans ta_metadonnee
INSERT INTO ta_metadonnee(fid_source, fid_acquisition, fid_provenance, fid_echelle)
SELECT
	MAX(a.objectid),
	MAX(b.objectid),
	MAX(c.objectid),
	MAX(d.objectid)
FROM
	ta_source a,
	ta_date_acquisition b,
	ta_provenance c,
    ta_echelle d;
COMMIT;

INSERT INTO ta_metadonnee_relation_organisme(fid_metadonnee, fid_organisme )
SELECT
	MAX(a.objectid),
    MAX(b.objectid)
FROM
    ta_metadonnee a,
    ta_organisme b;
COMMIT;


-- 3. Insertion des noms dans TA_NOM
MERGE INTO TA_NOM a
USING municipalite_belge b
ON(a.valeur = b."NOM")
WHEN NOT MATCHED THEN
INSERT(a.valeur)
VALUES(b."NOM");

-- 4. Insertion des libelles long concernant les communes belges
MERGE INTO ta_libelle_long a
USING
	(
		SELECT 'Municipalite belge' AS valeur FROM DUAL
        UNION
		SELECT 'Code ins' AS valeur FROM DUAL
	)b
ON(a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT(a.valeur)
VALUES(b.valeur);


-- 5. Insertion des relation famille-libelle concernant les communes belges
MERGE INTO ta_famille_libelle a
USING
    (
		SELECT
			a.objectid AS fid_famille,
			b.objectid AS fid_libelle_long
		FROM
			ta_famille a,
			ta_libelle_long b
		WHERE
			a.valeur = 'types de commune' AND b.valeur = 'Municipalite belge' OR 
			a.valeur = 'Identifiants de zone administrative' AND b.valeur = 'Code ins'
    )b
ON(a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT(a.fid_famille, a.fid_libelle_long)
VALUES(b.fid_famille, b.fid_libelle_long);

-- 6. Insertion des fid_libelle_long dans ta_libelle
MERGE INTO ta_libelle a
USING
	(
		SELECT
			objectid AS fid_libelle_long
		FROM
			ta_libelle_long
		WHERE
			valeur in ('Municipalite belge','Code ins')
	)b
ON(a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT(a.fid_libelle_long)
VALUES(b.fid_libelle_long);

-- 7. Insertion des codes ins dans ta_code
MERGE INTO ta_code a
USING
	(
		SELECT
			a.code_ins AS valeur,
			b.objectid AS fid_libelle
		FROM
			municipalite_belge a,
			ta_libelle b
		INNER JOIN ta_libelle_long c ON b.fid_libelle_long = c.objectid
		WHERE
			c.valeur = 'Code ins'
	)b
ON(a.valeur = b.valeur
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN
INSERT(a.valeur, a.fid_libelle)
VALUES(b.valeur, b.fid_libelle);

-- 8. Insertion des municipalités belges dans TA_COMMUNE
INSERT INTO ta_commune(geom, fid_lib_type_commune, fid_metadonnee, fid_nom)
SELECT
    a.ora_geometry,
    b.objectid,
    c.objectid,
    d.objectid
FROM
    ta_metadonnee c
	INNER JOIN ta_source e ON c.fid_source = e.objectid
	INNER JOIN ta_date_acquisition f ON c.fid_acquisition = f.objectid
	INNER JOIN ta_provenance g ON c.fid_provenance = g.objectid
	INNER JOIN ta_echelle h ON c.fid_echelle = h.objectid
	INNER JOIN ta_metadonnee_relation_organisme i ON c.objectid = i.fid_metadonnee
	INNER JOIN ta_organisme j ON i.fid_organisme = j.objectid,
    municipalite_belge a
    INNER JOIN ta_nom d ON a.nom = d.valeur,
    ta_libelle b
    INNER JOIN ta_libelle_long k ON b.fid_libelle_long = k.objectid
WHERE
    k.valeur = 'Municipalite belge'
AND 
	j.nom_organisme = 'Institut Géographique National Belge'
AND
	h.valeur = '10 000'
AND
	e.nom_source = 'Inventaire topogéographique du territoire belge'
AND
	g.url = 'http://www.ngi.be/FR/FR1-5-2.shtm'
AND
	f.date_acquisition = '18/02/2020'
AND
	f.millesime = '04/11/2019'
AND
	f.nom_obtenteur = 'bjacq'
    ;
    
COMMIT;