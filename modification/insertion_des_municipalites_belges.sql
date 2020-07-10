-- 1. Insertion des metadonnees
-- 1.1. Insertion de l'organisme producteur dans la table ta_organisme
INSERT INTO ta_organisme(acronyme, nom_organisme)
VALUES('IGN', 'Institut Géographique National Belge');
COMMIT;

-- 1.2. Insertion de la source dans la table TA_SOURCE
INSERT INTO ta_source(nom_source, description)
VALUES('Inventaire topogéographique du territoire belge', 'AdminVector est la série de données vectorielles qui contient les données vectorielles administratives de l''IGN les plus précises géométriquement et les plus détaillées sémantiquement. La série de données comporte 12 classes d''objets portant sur les secteurs statistiques, les anciennes communes, les communes, les arrondissements, les provinces, les régions et les limites territoriales et maritimes de la Belgique. La géométrie des données de tous ces thèmes est décrite par des coordonnées x,y ou x,y,z.');
COMMIT;

-- 1.3. Insertion de la provenance dans TA_PROVENANCE
INSERT INTO ta_provenance(url, methode_acquisition)
VALUES('http://www.ngi.be/FR/FR1-5-2.shtm', 'Téléchargement de la donnée au format shape depuis le site de l''IGN belge.');
COMMIT;

-- 1.4. Insertion des dates dans TA_DATE_ACQUISITION
INSERT INTO ta_date_acquisition(date_acquisition, millesime, nom_obtenteur)
VALUES('18/02/2020', '04/11/2019', 'bjacq');
COMMIT;

-- 1.5. Insertion de l'échelle dans TA_ECHELLE
INSERT INTO ta_echelle(valeur)
VALUES('10000');
COMMIT;

-- 1.6. Insertion des métadonnées dans la table TA_METADONNEE.
MERGE INTO ta_metadonnee a
USING
	(
		SELECT 
	    a.objectid AS FID_SOURCE,
	    b.objectid AS FID_ACQUISITION,
	    c.objectid AS FID_PROVENANCE,
	    d.objectid AS FID_ECHELLE
		FROM
		    ta_source a,
		    ta_date_acquisition b,
		    ta_provenance c,
		    ta_echelle d
		WHERE
		    a.nom_source = 'Inventaire topogéographique du territoire belge'
		AND
		    b.date_acquisition = '18/02/2020'
		AND
		    b.millesime IN ('04/11/2019')
		AND
		    c.url = 'http://www.ngi.be/FR/FR1-5-2.shtm'
		AND
			c.methode_acquisition = 'Téléchargement de la donnée au format shape depuis le site de l''IGN belge.'
		AND 
			d.valeur IN ('10000')
	)b
ON (a.fid_source = b.fid_source
AND a.fid_acquisition = b.fid_acquisition
AND a.fid_provenance = b.fid_provenance
AND a.fid_echelle = b.fid_echelle)
WHEN NOT MATCHED THEN
INSERT (a.fid_source,a.fid_acquisition,a.fid_provenance,a.fid_echelle)
VALUES(b.fid_source ,b.fid_acquisition,b.fid_provenance,b.fid_echelle)
;

-- 1.7. Insertion des données dans la table TA_METADONNEE_RELATION_ORGANISME
MERGE INTO ta_metadonnee_relation_organisme a
USING
    (
        SELECT
            a.objectid AS fid_metadonnee,
            f.objectid AS fid_organisme
        FROM
            ta_metadonnee a
        INNER JOIN ta_source b ON b.objectid = a.fid_source
        INNER JOIN ta_date_acquisition c ON a.fid_acquisition = c.objectid
        INNER JOIN ta_provenance d ON a.fid_provenance = d.objectid
        INNER JOIN ta_echelle e ON a.fid_echelle = e.objectid,
            ta_organisme f
        WHERE
            b.nom_source = 'Inventaire topogéographique du territoire belge'
        AND
            c.date_acquisition = '18/02/2020'
        AND
            c.millesime = '04/11/2019'
        AND
            d.url = 'http://www.ngi.be/FR/FR1-5-2.shtm'
        AND
            e.valeur = 10000
        AND
            f.nom_organisme IN ('Institut Géographique National Belge')
    )b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_organisme = b.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(b.fid_metadonnee, b.fid_organisme)
;

-- 2. Insertion des noms des municipalité dans TA_NOM
MERGE INTO TA_NOM a
USING municipalite_belge b
ON(a.valeur = b.nom)
WHEN NOT MATCHED THEN
INSERT(a.valeur)
VALUES(b.nom);

-- 3. Insertion des libelles long concernant les municipalites belges dans la table TA_LIBELLE_LONG
MERGE INTO ta_libelle_long a
USING
	(
		SELECT 'Municipalite belge' AS valeur FROM DUAL
        UNION
		SELECT 'code ins' AS valeur FROM DUAL
	)b
ON(a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT(a.valeur)
VALUES(b.valeur);


-- 4. Insertion des relation famille-libelle dans la table TA_FAMILLE_LIBELLE concernant les communes belges
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

-- 5. Insertion des fid_libelle_long dans TA_LIBELLE
MERGE INTO ta_libelle a
USING
	(
		SELECT
			objectid AS fid_libelle_long
		FROM
			ta_libelle_long
		WHERE
			valeur in ('Municipalite belge','code ins')
	)b
ON(a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT(a.fid_libelle_long)
VALUES(b.fid_libelle_long);

-- 6. Insertion des codes ins dans TA_CODE
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
			c.valeur = 'code ins'
	)b
ON(a.valeur = b.valeur
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN
INSERT(a.valeur, a.fid_libelle)
VALUES(b.valeur, b.fid_libelle);

-- 7. Insertion des municipalités belges dans TA_COMMUNE
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
    INNER JOIN ta_nom d ON a."nom" = d.valeur,
    ta_libelle b
    INNER JOIN ta_libelle_long k ON b.fid_libelle_long = k.objectid
WHERE
    k.valeur = 'Municipalite belge'
AND 
	j.nom_organisme = 'Institut Géographique National Belge'
AND
	h.echelle = '10000'
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


-- 8. Insertion des relations municipalités belges et code dans la table TA_IDENTIFIANT_COMMUNE
MERGE INTO ta_identifiant_commune a
USING
	(
	SELECT
	    a.objectid AS fid_commune,
	    d.objectid AS fid_identifiant
	FROM
	    ta_commune a
	    INNER JOIN ta_nom b ON a.fid_nom = b.objectid
	    INNER JOIN municipalite_belge c ON b.valeur = c.nom
	    INNER JOIN ta_code d ON c.code_ins = d.valeur
	    INNER JOIN ta_libelle e ON d.fid_libelle = e.objectid
	    INNER JOIN ta_libelle_long f ON e.fid_libelle_long = f.objectid
	WHERE 
	    f.valeur = 'code ins'
	  )b
ON(a.fid_commune = b.fid_commune
AND a.fid_identifiant = b.fid_identifiant)
WHEN NOT MATCHED THEN
INSERT(a.fid_commune, a.fid_identifiant)
VALUES(b.fid_commune, b.fid_identifiant);