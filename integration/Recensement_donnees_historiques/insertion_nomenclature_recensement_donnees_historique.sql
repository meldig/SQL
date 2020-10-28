-- Insertion de la nomenclature de la base de population historique du recensement entre 1876 et 2017

SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVEGARDE_INSERTION_NOMENCLATURE_RECENSEMENT;

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
ON (
	UPPER(a.nom_source) = UPPER(b.nom_source)
	AND UPPER(a.description) = UPPER(b.description)
	)
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
ON (
	UPPER(a.url) = UPPER(b.url)
	AND UPPER(a.methode_acquisition) = UPPER(b.methode_acquisition)
	)
WHEN NOT MATCHED THEN
INSERT(a.url,a.methode_acquisition)
VALUES(b.url,b.methode_acquisition)
;


-- 3. Insertion des données dans G_GEO.TA_DATE_ACQUISITION
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
USING
	(
	SELECT TO_DATE(sysdate, 'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2017') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2016') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2015') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2014') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2013') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2012') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2011') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2010') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2009') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2008') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2007') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/2006') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1999') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1990') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1982') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1975') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1968') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1962') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1954') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1936') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1931') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1926') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1921') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1911') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1906') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1901') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1896') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1891') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1886') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1881') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	UNION SELECT TO_DATE(sysdate,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/1876') AS MILLESIME, SYS_CONTEXT('USERENV','OS_USER') AS NOM_OBTENTEUR FROM DUAL
	) b
ON (
	a.date_acquisition = b.date_acquisition
	AND a.millesime = b.millesime
	AND a.nom_obtenteur = b.nom_obtenteur
	)
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
ON (
	UPPER(a.acronyme) = UPPER(b.acronyme)
	AND UPPER(a.nom_organisme) = UPPER(b.nom_organisme)
	)
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
		AND b.date_acquisition = TO_DATE(SYSDATE, 'dd/mm/yy')
		AND b.nom_obtenteur = SYS_CONTEXT('USERENV','OS_USER')
		AND c.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
	)b
ON (
	a.fid_source = b.fid_source
	AND a.fid_acquisition = b.fid_acquisition
	AND a.fid_provenance = b.fid_provenance
	)
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
    INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
    INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON c.objectid = a.fid_acquisition
    INNER JOIN G_GEO.TA_PROVENANCE d ON d.objectid = a.fid_provenance,
        G_GEO.TA_ORGANISME f
    WHERE
        b.nom_source = 'Recensements de la population 1876-2017'
    AND c.date_acquisition = TO_DATE(SYSDATE, 'dd/mm/yy')
    AND c.millesime BETWEEN '01/01/1876' AND '01/01/2017'
    AND d.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
    AND f.nom_organisme IN ('Institut National de la Statistique et des Etudes Economiques')
	)b
ON (
	a.fid_metadonnee = b.fid_metadonnee
	AND a.fid_organisme = b.fid_organisme
	)
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
    INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
    WHERE
    	c.valeur = 'code insee'
    )b
ON (
	a.valeur = b.valeur
	AND a.fid_libelle = b.fid_libelle
	)
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
ON (
	UPPER(a.valeur) = UPPER(b.valeur)
	)
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
ON (
	UPPER(a.valeur) = UPPER(b.valeur)
	)
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
ON (
	UPPER(a.valeur) = UPPER(b.valeur)
	)
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
		UPPER(a.valeur) = UPPER('recensement')
	AND (UPPER(b.valeur) LIKE UPPER('Population municipale%')
	OR UPPER(b.valeur) LIKE UPPER('Population sans double compte%')
	OR UPPER(b.valeur) LIKE UPPER('Population totale%'))
	)b
ON (
	a.fid_famille = b.fid_famille
	AND a.fid_libelle_long = b.fid_libelle_long
	)
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
			UPPER(c.valeur) = UPPER('recensement')
		AND (UPPER(a.valeur) LIKE UPPER('Population municipale%')
		OR UPPER(a.valeur) LIKE UPPER('Population sans double compte%')
		OR UPPER(a.valeur) LIKE UPPER('Population totale%'))
	)b
ON (
	a.fid_libelle_long = b.fid_libelle_long
	)
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
		UPPER(d.valeur) = UPPER('recensement') 
		AND 
			(
			(UPPER(e.valeur) = UPPER('PMUN17') AND UPPER(b.valeur) = UPPER('Population municipale en 2017'))
			OR (UPPER(e.valeur) = UPPER('PMUN16') AND UPPER(b.valeur) = UPPER('Population municipale en 2016'))
			OR (UPPER(e.valeur) = UPPER('PMUN15') AND UPPER(b.valeur) = UPPER('Population municipale en 2015'))
			OR (UPPER(e.valeur) = UPPER('PMUN14') AND UPPER(b.valeur) = UPPER('Population municipale en 2014'))
			OR (UPPER(e.valeur) = UPPER('PMUN13') AND UPPER(b.valeur) = UPPER('Population municipale en 2013'))
			OR (UPPER(e.valeur) = UPPER('PMUN12') AND UPPER(b.valeur) = UPPER('Population municipale en 2012'))
			OR (UPPER(e.valeur) = UPPER('PMUN11') AND UPPER(b.valeur) = UPPER('Population municipale en 2011'))
			OR (UPPER(e.valeur) = UPPER('PMUN10') AND UPPER(b.valeur) = UPPER('Population municipale en 2010'))
			OR (UPPER(e.valeur) = UPPER('PMUN09') AND UPPER(b.valeur) = UPPER('Population municipale en 2009'))
			OR (UPPER(e.valeur) = UPPER('PMUN08') AND UPPER(b.valeur) = UPPER('Population municipale en 2008'))
			OR (UPPER(e.valeur) = UPPER('PMUN07') AND UPPER(b.valeur) = UPPER('Population municipale en 2007'))
			OR (UPPER(e.valeur) = UPPER('PMUN06') AND UPPER(b.valeur) = UPPER('Population municipale en 2006'))
			OR (UPPER(e.valeur) = UPPER('PSDC99') AND UPPER(b.valeur) = UPPER('Population sans double compte en 1999'))
			OR (UPPER(e.valeur) = UPPER('PSDC90') AND UPPER(b.valeur) = UPPER('Population sans double compte en 1990'))
			OR (UPPER(e.valeur) = UPPER('PSDC82') AND UPPER(b.valeur) = UPPER('Population sans double compte en 1982'))
			OR (UPPER(e.valeur) = UPPER('PSDC75') AND UPPER(b.valeur) = UPPER('Population sans double compte en 1975'))
			OR (UPPER(e.valeur) = UPPER('PSDC68') AND UPPER(b.valeur) = UPPER('Population sans double compte en 1968'))
			OR (UPPER(e.valeur) = UPPER('PSDC62') AND UPPER(b.valeur) = UPPER('Population sans double compte en 1962'))
			OR (UPPER(e.valeur) = UPPER('PTOT54') AND UPPER(b.valeur) = UPPER('Population totale en 1954'))
			OR (UPPER(e.valeur) = UPPER('PTOT36') AND UPPER(b.valeur) = UPPER('Population totale en 1936'))
			OR (UPPER(e.valeur) = UPPER('PTOT1931') AND UPPER(b.valeur) = UPPER('Population totale en 1931'))
			OR (UPPER(e.valeur) = UPPER('PTOT1926') AND UPPER(b.valeur) = UPPER('Population totale en 1926'))
			OR (UPPER(e.valeur) = UPPER('PTOT1921') AND UPPER(b.valeur) = UPPER('Population totale en 1921'))
			OR (UPPER(e.valeur) = UPPER('PTOT1911') AND UPPER(b.valeur) = UPPER('Population totale en 1911'))
			OR (UPPER(e.valeur) = UPPER('PTOT1906') AND UPPER(b.valeur) = UPPER('Population totale en 1906'))
			OR (UPPER(e.valeur) = UPPER('PTOT1901') AND UPPER(b.valeur) = UPPER('Population totale en 1901'))
			OR (UPPER(e.valeur) = UPPER('PTOT1896') AND UPPER(b.valeur) = UPPER('Population totale en 1896'))
			OR (UPPER(e.valeur) = UPPER('PTOT1891') AND UPPER(b.valeur) = UPPER('Population totale en 1891'))
			OR (UPPER(e.valeur) = UPPER('PTOT1886') AND UPPER(b.valeur) = UPPER('Population totale en 1886'))
			OR (UPPER(e.valeur) = UPPER('PTOT1881') AND UPPER(b.valeur) = UPPER('Population totale en 1881'))
			OR (UPPER(e.valeur) = UPPER('PTOT1876') AND UPPER(b.valeur) = UPPER('Population totale en 1876'))
			)
    ) b
ON (
	a.fid_libelle = b.fid_libelle
	AND a.fid_libelle_court = b.fid_libelle_court
	)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle,a.fid_libelle_court)
VALUES (b.fid_libelle,b.fid_libelle_court)
;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAUVEGARDE_INSERTION_NOMENCLATURE_RECENSEMENT;
END;
/