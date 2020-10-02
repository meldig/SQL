-- Insertion de la nomenclature de la base de population historique du recensement entre 1876 et 2017
-- 1. Insertion de la source dans G_GEO.TA_SOURCE.
MERGE INTO G_GEO.TA_SOURCE a
USING
    (
    	SELECT
    		'Recensements de la population 1876-2017' AS nom_source,
    		'Les statistiques sont proposées dans la géographie communale en vigueur au 01/01/2019 pour la France hors Mayotte, afin que leurs comparaisons dans le temps se fassent sur un champ géographique stable.' AS description
    	FROM
    		DUAL
    ) b
ON (a.nom_source = b.nom_source
AND a.description = b.description)
WHEN NOT MATCHED THEN
INSERT (a.nom_source,a.description)
VALUES (b.nom_source,b.description)
;


-- 2. Insertion de la provenance dans G_GEO.TA_PROVENANCE
MERGE INTO G_GEO.TA_PROVENANCE a
USING
    (
    	SELECT
    		'https://www.insee.fr/fr/statistiques/3698339#consulter' AS url,
	    	'les données sont proposées en libre accès sous la forme d''un tableau xlxs.' AS methode_acquisition
    	FROM
    		DUAL
   	) b
ON (a.url = b.url
AND a.methode_acquisition = b.methode_acquisition)
WHEN NOT MATCHED THEN
INSERT(a.url,a.methode_acquisition)
VALUES(b.url,b.methode_acquisition)
;


-- 3. Insertion des données dans G_GEO.TA_DATE_ACQUISITION
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
USING
	(
		SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2017') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2016') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2015') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2014') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2013') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2012') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2011') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2010') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2009') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2008') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2007') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/2006') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1999') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1990') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1982') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1975') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1968') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1962') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1954') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1936') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1931') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1926') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1921') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1911') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1906') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1901') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1896') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1891') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1886') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1881') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE(SYSDATE) AS DATE_ACQUISITION, TO_DATE('01/01/1876') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	) b
ON (a.date_acquisition = b.date_acquisition
AND a.millesime = b.millesime)
AND a.nom_obtenteur = b.nom_obtenteur)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition, a.millesime, a.nom_obtenteur)
VALUES (b.date_acquisition, b.millesime, b.nom_obtenteur)
;


-- 4. Insertion des données dans G_GEO.TA_ORGANISME
MERGE INTO G_GEO.TA_ORGANISME a
USING
	(
		SELECT
			'INSEE' AS ACRONYME,
			'Institut National de la Statistique et des Etudes Economiques' AS NOM_ORGANISME
		FROM
			DUAL
	) b
ON (a.acronyme = b.acronyme
AND a.nom_organisme = b.nom_organisme)
WHEN NOT MATCHED THEN
INSERT (a.acronyme,a.nom_organisme)
VALUES(b.acronyme,b.nom_organisme)
;


-- 5. Insertion des données dans G_GEO.TA_METADONNEE
MERGE INTO G_GEO.TA_METADONNEE a
USING
	(
		SELECT
		  a.objectid AS fid_source,
		  b.objectid AS fid_acquisition,
		  c.objectid AS fid_provenance
		FROM
		  G_GEO.TA_SOURCE a,
		  G_GEO.TA_DATE_ACQUISITION b,
		  G_GEO.TA_PROVENANCE c
		WHERE
		  a.nom_source = 'Recensements de la population 1876-2017'
		  AND a.description = 'Les statistiques sont proposées dans la géographie communale en vigueur au 01/01/2019 pour la France hors Mayotte, afin que leurs comparaisons dans le temps se fassent sur un champ géographique stable.'
		  AND b.millesime BETWEEN '01/01/1876' AND '01/01/2017'
		  AND b.date_acquisition = TO_DATE(SYSDATE)
		  AND b.nom_obtenteur = SYS_CONTEXT('USERENV','OS_USER')
		  AND c.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
	)b
ON(a.fid_source = b.fid_source
AND a.fid_acquisition = b.fid_acquisition
AND a.fid_provenance = b.fid_provenance)
WHEN NOT MATCHED THEN
INSERT(a.fid_source, a.fid_acquisition, a.fid_provenance)
VALUES(b.fid_source, b.fid_acquisition, b.fid_provenance)
;


-- 6.Insertion des données dans la table G_GEO.TA_METADONNEE_RELATION_ORGANISME
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
USING
	(
		SELECT
			a.objectid AS fid_metadonnee,
            f.objectid AS fid_organisme
        FROM
            G_GEO.TA_METADONNEE a
        INNER JOIN G_GEO.TA_SOURCE b ON a.fid_source = b.objectid
        INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
        INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid,
            G_GEO.TA_ORGANISME f
        WHERE
            b.nom_source = 'Recensements de la population 1876-2017'
		AND b.description = 'Les statistiques sont proposées dans la géographie communale en vigueur au 01/01/2019 pour la France hors Mayotte, afin que leurs comparaisons dans le temps se fassent sur un champ géographique stable.'
        AND c.date_acquisition = TO_DATE(SYSDATE)
        AND c.millesime BETWEEN '01/01/1876' AND '01/01/2017'
        AND d.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
        AND f.nom_organisme IN ('Institut National de la Statistique et des Etudes Economiques')
	)b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_organisme = b.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(b.fid_metadonnee, b.fid_organisme)
;


-- 7. Insertion des codes insee dans la table G_GEO.TA_CODE si nécessaire
MERGE INTO G_GEO.TA_CODE a
USING 
    (
        SELECT DISTINCT
        	a.CODGEO AS valeur,
        	b.objectid AS fid_libelle
        FROM
        	RECENSEMENT a,
        	G_GEO.TA_LIBELLE b
        INNER JOIN G_GEO.TA_LIBELLE_LONG c ON b.fid_libelle_long = c.objectid
        WHERE
        	c.valeur = 'code insee'
    )b
ON (a.valeur = b.valeur
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN
INSERT (a.valeur,a.fid_libelle)
VALUES (b.valeur,b.fid_libelle)
;


-- 8. Insertion des libelles courts dans G_GEO.TA_LIBELLE_COURT
MERGE INTO G_GEO.TA_LIBELLE_COURT a
USING
	(
		SELECT 'PMUN17' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN16' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN15' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN14' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN13' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN12' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN11' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN10' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN09' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN08' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN07' AS VALEUR FROM DUAL
		UNION SELECT 'PMUN06' AS VALEUR FROM DUAL
		UNION SELECT 'PSDC99' AS VALEUR FROM DUAL
		UNION SELECT 'PSDC90' AS VALEUR FROM DUAL
		UNION SELECT 'PSDC82' AS VALEUR FROM DUAL
		UNION SELECT 'PSDC75' AS VALEUR FROM DUAL
		UNION SELECT 'PSDC68' AS VALEUR FROM DUAL
		UNION SELECT 'PSDC62' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT54' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT36' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1931' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1926' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1921' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1911' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1906' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1901' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1896' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1891' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1886' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1881' AS VALEUR FROM DUAL
		UNION SELECT 'PTOT1876' AS VALEUR FROM DUAL
	) b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;


-- 9. Insertion des libellés recensement dans G_GEO.TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
USING
	(
		SELECT 'Population municipale en 2017' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2016' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2015' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2014' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2013' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2012' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2011' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2010' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2009' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2008' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2007' AS valeur FROM DUAL
		UNION SELECT 'Population municipale en 2006' AS valeur FROM DUAL
		UNION SELECT 'Population sans double compte en 1999' AS valeur FROM DUAL
		UNION SELECT 'Population sans double compte en 1990' AS valeur FROM DUAL
		UNION SELECT 'Population sans double compte en 1982' AS valeur FROM DUAL
		UNION SELECT 'Population sans double compte en 1975' AS valeur FROM DUAL
		UNION SELECT 'Population sans double compte en 1968' AS valeur FROM DUAL
		UNION SELECT 'Population sans double compte en 1962' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1954' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1936' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1931' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1926' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1921' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1911' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1906' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1901' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1896' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1891' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1886' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1881' AS valeur FROM DUAL
		UNION SELECT 'Population totale en 1876' AS valeur FROM DUAL
	) b
ON (UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;


-- 10. Insertion de la famille 'recensement' dans G_GEO.TA_FAMILLE
MERGE INTO G_GEO.TA_FAMILLE a
USING
	(
		SELECT
			'recensement' AS valeur
		FROM
			DUAL
	)b
ON (UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;


-- 11. Insertion des données dans G_GEO.TA_FAMILLE_LIBELLE
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING
	(
		SELECT
		    a.objectid fid_famille,
		    b.objectid fid_libelle_long
		FROM
		    G_GEO.TA_FAMILLE a,
		    G_GEO.TA_LIBELLE_LONG b
		WHERE 
    		a.valeur = 'recensement'
    	AND (b.valeur LIKE 'Population municipale%' OR b.valeur LIKE 'Population sans double compte%' OR b.valeur LIKE 'Population totale%')
	)b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille, a.fid_libelle_long)
VALUES (b.fid_famille, b.fid_libelle_long)
;


-- 12. Insertion des libelles recensement dans la table G_GEO.TA_LIBELLE
MERGE INTO G_GEO.TA_LIBELLE a
USING
	(
		SELECT
			a.objectid AS fid_libelle_long
		FROM
			G_GEO.TA_LIBELLE_LONG a
		INNER JOIN G_GEO.TA_FAMILLE_LIBELLE b ON b.fid_libelle_long = a.objectid
		INNER JOIN G_GEO.TA_FAMILLE c ON c.objectid = b.fid_famille
		WHERE
			c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2017'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2016'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2015'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2014'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2013'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2012'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2011'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2010'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2009'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2008'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2007'
			OR c.valeur = 'recensement' AND a.valeur = 'Population municipale en 2006'
			OR c.valeur = 'recensement' AND a.valeur = 'Population sans double compte en 1999'
			OR c.valeur = 'recensement' AND a.valeur = 'Population sans double compte en 1990'
			OR c.valeur = 'recensement' AND a.valeur = 'Population sans double compte en 1982'
			OR c.valeur = 'recensement' AND a.valeur = 'Population sans double compte en 1975'
			OR c.valeur = 'recensement' AND a.valeur = 'Population sans double compte en 1968'
			OR c.valeur = 'recensement' AND a.valeur = 'Population sans double compte en 1962'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1954'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1936'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1931'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1926'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1921'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1911'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1906'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1901'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1896'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1891'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1886'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1881'
			OR c.valeur = 'recensement' AND a.valeur = 'Population totale en 1876'
	)b
ON (a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle_long)
VALUES (b.fid_libelle_long);


-- 13. Insertion des valeurs dans la table G_GEO.TA_LIBELLE_CORRESPONDANCE

MERGE INTO G_GEO.TA_LIBELLE_CORRESPONDANCE a
USING
	(
		SELECT
			a.objectid AS fid_libelle,
			e.objectid AS fid_libelle_court
		FROM
			G_GEO.TA_LIBELLE a
		INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
		INNER JOIN G_GEO.TA_FAMILLE_LIBELLE c ON c.fid_libelle_long = b.objectid
		INNER JOIN G_GEO.TA_FAMILLE d ON d.objectid = c.fid_famille,
			G_GEO.TA_LIBELLE_COURT e
		WHERE
			d.valeur = 'recensement' AND (e.valeur = 'PMUN17' AND b.valeur = 'Population municipale en 2017')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN16' AND b.valeur = 'Population municipale en 2016')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN15' AND b.valeur = 'Population municipale en 2015')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN14' AND b.valeur = 'Population municipale en 2014')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN13' AND b.valeur = 'Population municipale en 2013')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN12' AND b.valeur = 'Population municipale en 2012')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN11' AND b.valeur = 'Population municipale en 2011')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN10' AND b.valeur = 'Population municipale en 2010')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN09' AND b.valeur = 'Population municipale en 2009')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN08' AND b.valeur = 'Population municipale en 2008')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN07' AND b.valeur = 'Population municipale en 2007')
			OR d.valeur = 'recensement' AND (e.valeur = 'PMUN06' AND b.valeur = 'Population municipale en 2006')
			OR d.valeur = 'recensement' AND (e.valeur = 'PSDC99' AND b.valeur = 'Population sans double compte en 1999')
			OR d.valeur = 'recensement' AND (e.valeur = 'PSDC90' AND b.valeur = 'Population sans double compte en 1990')
			OR d.valeur = 'recensement' AND (e.valeur = 'PSDC82' AND b.valeur = 'Population sans double compte en 1982')
			OR d.valeur = 'recensement' AND (e.valeur = 'PSDC75' AND b.valeur = 'Population sans double compte en 1975')
			OR d.valeur = 'recensement' AND (e.valeur = 'PSDC68' AND b.valeur = 'Population sans double compte en 1968')
			OR d.valeur = 'recensement' AND (e.valeur = 'PSDC62' AND b.valeur = 'Population sans double compte en 1962')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT54' AND b.valeur = 'Population totale en 1954')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT36' AND b.valeur = 'Population totale en 1936')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1931' AND b.valeur = 'Population totale en 1931')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1926' AND b.valeur = 'Population totale en 1926')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1921' AND b.valeur = 'Population totale en 1921')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1911' AND b.valeur = 'Population totale en 1911')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1906' AND b.valeur = 'Population totale en 1906')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1901' AND b.valeur = 'Population totale en 1901')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1896' AND b.valeur = 'Population totale en 1896')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1891' AND b.valeur = 'Population totale en 1891')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1886' AND b.valeur = 'Population totale en 1886')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1881' AND b.valeur = 'Population totale en 1881')
			OR d.valeur = 'recensement' AND (e.valeur = 'PTOT1876' AND b.valeur = 'Population totale en 1876')
    ) b
ON (a.fid_libelle = b.fid_libelle
AND a.fid_libelle_court = b.fid_libelle_court)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle,a.fid_libelle_court)
VALUES (b.fid_libelle,b.fid_libelle_court)
;