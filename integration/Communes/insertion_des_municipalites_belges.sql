/*
Insertion des municipalités belges dans G_GEO.TA_COMMUNE.
Attention : pour l'instant seules les municipalités frontalières avec les Hauts-de-France sont insérées en base.

-- 1. Insertion des metadonnees ;
	-- 1.1. Insertion de l'organisme producteur dans la table TA_ORGANISME ;
	-- 1.2. Insertion de la source dans la table TA_SOURCE ;
	-- 1.3. Insertion de la provenance dans TA_PROVENANCE ;
	-- 1.4. Insertion des dates dans TA_DATE_ACQUISITION ;
	-- 1.5. Insertion de l'échelle dans TA_ECHELLE ;
	-- 1.6. Insertion des métadonnées dans la table TA_METADONNEE ;
	-- 1.7. Insertion des données dans la table TA_METADONNEE_RELATION_ORGANISME ;
	-- 1.8. Insertion des données dans la table TA_METADONNEE_RELATION_ECHELLE ;
-- 2. Insertion des noms des municipalité dans TA_NOM ;
-- 3. Insertion des familles concernant les municipalites belges dans la table TA_FAMILLE ;
-- 4. Insertion des libelles long concernant les municipalites belges dans la table TA_LIBELLE_LONG ;
-- 5. Insertion des relation famille-libelle dans la table TA_FAMILLE_LIBELLE concernant les communes belges ;
-- 6. Insertion des fid_libelle_long dans TA_LIBELLE ;
-- 7. Insertion des codes ins dans TA_CODE ;
-- 8. Insertion des municipalités belges dans TA_COMMUNE ;
-- 9. Insertion des relations municipalités belges et code dans la table TA_IDENTIFIANT_COMMUNE ;
*/
SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVEGARDE_INSERTION_MUNICIPALITES;
-- 1. Insertion des metadonnees ;
-- 1.1. Insertion de l'organisme producteur dans la table TA_ORGANISME ;
MERGE INTO G_GEO.TA_ORGANISME a
USING(
    SELECT 
        'IGN' AS acronyme, 
        'Institut Géographique National Belge' AS valeur 
    FROM DUAL
    )t
ON (UPPER(a.acronyme) = UPPER(t.acronyme) AND UPPER(a.nom_organisme) = UPPER(t.valeur))
WHEN NOT MATCHED THEN
    INSERT(a.acronyme, a.nom_organisme)
    VALUES(t.acronyme, t.valeur);

-- 1.2. Insertion de la source dans la table TA_SOURCE ;
MERGE INTO G_GEO.TA_SOURCE a
USING(
    SELECT 
        'Inventaire topogéographique du territoire belge' AS nom, 
        'AdminVector est la série de données vectorielles qui contient les données vectorielles administratives de l''IGN les plus précises géométriquement et les plus détaillées sémantiquement. La série de données comporte 12 classes d''objets portant sur les secteurs statistiques, les anciennes communes, les communes, les arrondissements, les provinces, les régions et les limites territoriales et maritimes de la Belgique. La géométrie des données de tous ces thèmes est décrite par des coordonnées x,y ou x,y,z.' AS description 
    FROM DUAL
    )t
ON (UPPER(a.nom_source) = UPPER(t.nom) AND UPPER(a.description) = UPPER(t.description))
WHEN NOT MATCHED THEN
    INSERT(a.nom_source, a.description)
    VALUES(t.nom, t.description);

-- 1.3. Insertion de la provenance dans TA_PROVENANCE ;
MERGE INTO G_GEO.TA_PROVENANCE a
    USING(
        SELECT 
            'http://www.ngi.be/FR/FR1-5-2.shtm' AS url,
            'Téléchargement de la donnée au format shape depuis le site de l''IGN belge.' AS methode
        FROM
            DUAL
    )t
    ON(
        UPPER(a.url) = UPPER(t.url) AND UPPER(a.methode_acquisition) = UPPER(t.methode)
    )
WHEN NOT MATCHED THEN
    INSERT(a.url, a.methode_acquisition)
    VALUES(t.url, t.methode);

-- 1.4. Insertion des dates dans TA_DATE_ACQUISITION ;
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
    USING(
        SELECT 
            TO_DATE(sysdate, 'dd/mm/yy') AS date_insertion, 
            '04/11/2019' AS date_millesime,
            sys_context('USERENV','OS_USER') AS nom_obtenteur 
        FROM DUAL
    )t
    ON (
            a.date_acquisition = t.date_insertion 
            AND a.millesime = t.date_millesime
            AND a.nom_obtenteur = t.nom_obtenteur
        )
WHEN NOT MATCHED THEN
    INSERT (a.date_acquisition, a.millesime, a.nom_obtenteur)
    VALUES(t.date_insertion, t.date_millesime, t.nom_obtenteur);

-- 1.5. Insertion de l'échelle dans TA_ECHELLE ;
MERGE INTO G_GEO.TA_ECHELLE a
    USING(
        SELECT '10000' AS echelle FROM DUAL
    )t
    ON (a.valeur = t.echelle)
WHEN NOT MATCHED THEN
    INSERT (a.valeur)
    VALUES(t.echelle);

-- 1.6. Insertion des métadonnées dans la table TA_METADONNEE ;
MERGE INTO G_GEO.TA_METADONNEE a
USING
	(
		SELECT 
	    a.objectid AS FID_SOURCE,
	    b.objectid AS FID_ACQUISITION,
	    c.objectid AS FID_PROVENANCE,
	    d.objectid AS FID_ECHELLE
		FROM
		    G_GEO.TA_SOURCE a,
		    G_GEO.TA_DATE_ACQUISITION b,
		    G_GEO.TA_PROVENANCE c
		WHERE
		    a.nom_source = 'Inventaire topogéographique du territoire belge'
		AND
		    b.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
		AND
		    b.millesime IN ('04/11/2019')
		AND
		    c.url = 'http://www.ngi.be/FR/FR1-5-2.shtm'
		AND
			c.methode_acquisition = 'Téléchargement de la donnée au format shape depuis le site de l''IGN belge.'
	)t
	ON (
		a.fid_source = t.fid_source
		AND a.fid_acquisition = t.fid_acquisition
		AND a.fid_provenance = t.fid_provenance
	)
WHEN NOT MATCHED THEN
	INSERT (a.fid_source, a.fid_acquisition, a.fid_provenance)
	VALUES(t.fid_source, t.fid_acquisition, t.fid_provenance)
;

-- 1.7. Insertion des données dans la table TA_METADONNEE_RELATION_ORGANISME ;
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
	USING(
        SELECT
            a.objectid AS fid_metadonnee,
            f.objectid AS fid_organisme
        FROM
            G_GEO.TA_METADONNEE a
	        INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
	        INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON c.objectid = a.fid_acquisition
	        INNER JOIN G_GEO.TA_PROVENANCE d ON d.objectid = a.fid_provenance,
	        G_GEO.TA_ORGANISME f
        WHERE
            UPPER(b.nom_source) = UPPER('Inventaire topogéographique du territoire belge')
        	AND c.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
        	AND c.millesime = '04/11/2019'
        	AND UPPER(d.url) = UPPER('http://www.ngi.be/FR/FR1-5-2.shtm')
        	AND UPPER(f.nom_organisme) = UPPER('Institut Géographique National Belge')
    )t
	ON(
		a.fid_metadonnee = t.fid_metadonnee
		AND a.fid_organisme = t.fid_organisme
	)
WHEN NOT MATCHED THEN
	INSERT(a.fid_metadonnee, a.fid_organisme)
	VALUES(t.fid_metadonnee, t.fid_organisme)
;

-- 1.8. Insertion des données dans la table TA_METADONNEE_RELATION_ECHELLE ;
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ECHELLE a
	USING(
        SELECT
            a.objectid AS fid_metadonnee,
            f.objectid AS fid_echelle
        FROM
            G_GEO.TA_METADONNEE a
	        INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
	        INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON c.objectid = a.fid_acquisition
	        INNER JOIN G_GEO.TA_PROVENANCE d ON d.objectid = a.fid_provenance,
	        INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME e ON e.fid_metadonnee = a.objectid
	        INNER JOIN G_GEO.TA_ORGANISME f ON f.objectid = e.fid_organisme,
	        G_GEO.TA_ECHELLE g
        WHERE
            UPPER(b.nom_source) = UPPER('Inventaire topogéographique du territoire belge')
        	AND c.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
        	AND c.millesime = '04/11/2019'
        	AND UPPER(d.url) = UPPER('http://www.ngi.be/FR/FR1-5-2.shtm')
        	AND UPPER(f.nom_organisme) = UPPER('Institut Géographique National Belge')
        	AND g.valeur = 10000
    )t
	ON(
		a.fid_metadonnee = t.fid_metadonnee
		AND a.fid_echelle = t.fid_echelle
	)
WHEN NOT MATCHED THEN
	INSERT(a.fid_metadonnee, a.fid_echelle)
	VALUES(t.fid_metadonnee, t.fid_echelle)
;

-- 2. Insertion des noms des municipalité dans TA_NOM ;
MERGE INTO G_GEO.TA_NOM a
	USING(
		SELECT
			b.nom
		FROM G_GEO.TEMP_MUNICIPALITE_BELGE b
	)t
	ON(UPPER(a.valeur) = UPPER(t.nom))
WHEN NOT MATCHED THEN
	INSERT(a.valeur)
	VALUES(t.nom);

-- 3. Insertion des familles concernant les municipalites belges dans la table TA_FAMILLE ;
MERGE INTO G_GEO.TA_FAMILLE a
USING
	(
		SELECT 'types de commune' AS valeur FROM DUAL
        UNION
		SELECT 'Identifiants de zone administrative' AS valeur FROM DUAL
	)t
	ON(UPPER(a.valeur) = UPPER(t.valeur))
WHEN NOT MATCHED THEN
	INSERT(a.valeur)
	VALUES(t.valeur);

-- 4. Insertion des libelles long concernant les municipalites belges dans la table TA_LIBELLE_LONG ;
MERGE INTO G_GEO.TA_LIBELLE_LONG a
USING
	(
		SELECT 'Municipalite belge' AS valeur FROM DUAL
        UNION
		SELECT 'code ins' AS valeur FROM DUAL
	)t
	ON(UPPER(a.valeur) = UPPER(t.valeur))
WHEN NOT MATCHED THEN
	INSERT(a.valeur)
	VALUES(t.valeur);

-- 5. Insertion des relation famille-libelle dans la table TA_FAMILLE_LIBELLE concernant les communes belges ;
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
	USING(
		SELECT
			a.objectid AS fid_famille,
			b.objectid AS fid_libelle_long
		FROM
			G_GEO.TA_FAMILLE a,
			G_GEO.TA_LIBELLE_LONG b
		WHERE
			UPPER(a.valeur) = UPPER('types de commune') AND UPPER(b.valeur) = UPPER('Municipalite belge') 
			OR UPPER(a.valeur) = UPPER('Identifiants de zone administrative') AND UPPER(b.valeur) = UPPER('Code ins')
    )t
	ON(a.fid_famille = t.fid_famille
		AND a.fid_libelle_long = t.fid_libelle_long)
WHEN NOT MATCHED THEN
	INSERT(a.fid_famille, a.fid_libelle_long)
	VALUES(t.fid_famille, t.fid_libelle_long);

-- 6. Insertion des fid_libelle_long dans TA_LIBELLE ;
MERGE INTO G_GEO.TA_LIBELLE a
	USING(
		SELECT
			b.objectid AS fid_libelle_long
		FROM
			G_GEO.TA_LIBELLE_LONG b
		WHERE
			UPPER(b.valeur) IN (UPPER('Municipalite belge'), UPPER('code ins'))
	)t
	ON(a.fid_libelle_long = t.fid_libelle_long)
WHEN NOT MATCHED THEN
	INSERT(a.fid_libelle_long)
	VALUES(t.fid_libelle_long);

-- 7. Insertion des codes ins dans TA_CODE ;
MERGE INTO G_GEO.TA_CODE a
	USING(
		SELECT
			a.code_ins AS valeur,
			b.objectid AS fid_libelle
		FROM
			G_GEO.TEMP_MUNICIPALITE_BELGE a,
			G_GEO.TA_LIBELLE b
		INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
		WHERE
			UPPER(c.valeur) = UPPER('code ins')
	)t
	ON(a.valeur = t.valeur
		AND a.fid_libelle = t.fid_libelle
	)
WHEN NOT MATCHED THEN
	INSERT(a.valeur, a.fid_libelle)
	VALUES(t.valeur, t.fid_libelle);

-- 8. Insertion des municipalités belges dans TA_COMMUNE ;
-- Objectif : insérer les géométries des municipalités belges (équivalent belge des communes) dans G_GEO.TA_COMMUNE.
MERGE INTO G_GEO.TA_COMMUNE a
	USING(
		SELECT
		    a.ora_geometry AS geom,
		    b.objectid AS fid_nom,
		    d.objectid AS fid_lib_type_commune,
		    f.objectid AS fid_metadonnee
		FROM
			G_GEO.TEMP_MUNICIPALITE_BELGE a
		    INNER JOIN G_GEO.TA_NOM b ON b.valeur = a.nom,
		    G_GEO.TA_LIBELLE d
		    INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = d.fid_libelle_long,
		    G_GEO.TA_METADONNEE f
			INNER JOIN G_GEO.TA_SOURCE g ON g.objectid = f.fid_source
			INNER JOIN G_GEO.TA_DATE_ACQUISITION h ON h.objectid = f.fid_acquisition
		WHERE
		    UPPER(e.valeur) = UPPER('Municipalite belge')
		    AND UPPER(g.nom_source) = UPPER('Inventaire topogéographique du territoire belge')
		    AND h.millesime = '04/11/19'
		    AND h.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
	)t
	ON(
		a.fid_lib_type_commune = t.fid_lib_type_commune
        AND a.fid_nom = t.fid_nom
        AND a.fid_metadonnee = t.fid_metadonnee
	)
WHEN NOT MATCHED THEN
	INSERT(a.geom, a.fid_nom, a.fid_lib_type_commune, a.fid_metadonnee)
	VALUES(t.geom, t.fid_nom, t.fid_lib_type_commune, t.fid_metadonnee);

-- 9. Insertion des relations municipalités belges et code dans la table TA_IDENTIFIANT_COMMUNE ;
-- Objectif : insérer les municipalité belges frontalières des Hauts-de-France en base
MERGE INTO G_GEO.TA_IDENTIFIANT_COMMUNE a
    USING(
        SELECT
            b.OBJECTID AS fid_commune,
            a.CODE_INS AS temp_code_ins,
            h.objectid AS fid_identifiant,
            h.valeur AS prod_code_ins
        FROM
            -- Sélection des géométries de communes et de leur code INSEE dans la table d'import
            G_GEO.TEMP_MUNICIPALITE_BELGE a,
            -- Sélection des géométries de communes de TA_COMMUNE que l'on vient d'insérer
            G_GEO.TA_COMMUNE b
            INNER JOIN G_GEO.TA_METADONNEE e ON e.objectid = b.fid_metadonnee
            INNER JOIN G_GEO.TA_SOURCE f ON f.objectid = e.fid_source
            INNER JOIN G_GEO.TA_DATE_ACQUISITION g ON g.objectid = e.fid_acquisition,
            -- Sélection des codes communaux de TA_CODE que l'on vient d'insérer (merger)
            G_GEO.TA_CODE h
            INNER JOIN G_GEO.TA_LIBELLE i ON i.objectid = h.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG j ON j.objectid = i.fid_libelle_long
        WHERE
            -- Condition d'égalité de géométrie entre la table d'import et TA_COMMUNE
            SDO_EQUAL(a.ORA_GEOMETRY, b.GEOM) = 'TRUE'
            AND UPPER(f.nom_source) = UPPER('Inventaire topogéographique du territoire belge')
            AND g.millesime = '04/11/19'
            AND g.date_acquisition = TO_DATE(sysdate, 'dd/mm/yy')
            AND UPPER(j.valeur) = UPPER('Code ins')
            AND h.valeur = a.code_ins
    ) t
    ON (a.fid_identifiant = t.fid_identifiant 
    	AND a.fid_commune = t.fid_commune
	)
WHEN NOT MATCHED THEN
    INSERT(a.fid_commune, a.fid_identifiant)
    VALUES(t.fid_commune, t.fid_identifiant);

COMMIT;

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAUVEGARDE_INSERTION_MUNICIPALITES;
END;
/