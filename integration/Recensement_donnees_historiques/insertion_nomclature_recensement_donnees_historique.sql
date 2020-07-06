-- Insertion de la nomenclature de la base de population historique du recensement entre 1876 et 2017
-- 1. Insertion de la source dans TA_SOURCE.
MERGE INTO ta_source a
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


-- 2. Insertion de la provenance dans TA_PROVENANCE
MERGE INTO ta_provenance a
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


-- 3. Insertion des données dans TA_DATE_ACQUISITION
MERGE INTO ta_date_acquisition a
USING
	(
		SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2017') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2016') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2015') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2014') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2013') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2012') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2011') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2010') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2009') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2008') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2007') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2006') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1999') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1990') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1982') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1975') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1968') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1962') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1954') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1936') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1931') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1926') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1921') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1911') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1906') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1901') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1896') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1891') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1886') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1881') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
		UNION SELECT TO_DATE('06/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/1876') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
	) b
ON (a.date_acquisition = b.date_acquisition
AND a.millesime = b.millesime)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition,a.millesime)
VALUES (b.date_acquisition,b.millesime)
;


-- 4. Insertion des données dans TA_ORGANISME
MERGE INTO ta_organisme a
USING
	(SELECT
		'INSEE' AS ACRONYME,
		'Institut National de la Statistique et des Etudes Economiques' AS NOM_ORGANISME
	FROM
		DUAL) b
ON (a.acronyme = b.acronyme
AND a.nom_organisme = b.nom_organisme)
WHEN NOT MATCHED THEN
INSERT (a.acronyme,a.nom_organisme)
VALUES(b.acronyme,b.nom_organisme)
;


-- 5. Insertion des données dans TA_METADONNEE
MERGE INTO ta_metadonnee a
USING
	(
		SELECT
		  a.objectid AS fid_source,
		  b.objectid AS fid_acquisition,
		  c.objectid AS fid_provenance
		FROM
		  ta_source a,
		  ta_date_acquisition b,
		  ta_provenance c
		WHERE
		  a.nom_source = 'Recensements de la population 1876-2017'
		  AND b.millesime BETWEEN '01/01/1876' AND '01/01/2017'
		  AND b.date_acquisition = '06/04/2020'
		  AND c.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
	)b
ON(a.fid_source = b.fid_source
AND a.fid_acquisition = b.fid_acquisition
AND a.fid_provenance = b.fid_provenance)
WHEN NOT MATCHED THEN
INSERT(a.fid_source, a.fid_acquisition, a.fid_provenance)
VALUES(b.fid_source, b.fid_acquisition, b.fid_provenance)
;


-- 6.Insertion des données dans la table TA_METADONNEE_RELATION_ORGANISME
MERGE INTO TA_METADONNEE_RELATION_ORGANISME a
USING
	(
		SELECT
			a.objectid AS fid_metadonnee,
            f.objectid AS fid_organisme
        FROM
            ta_metadonnee a
        INNER JOIN ta_source b ON a.fid_source = b.objectid
        INNER JOIN ta_date_acquisition c ON a.fid_acquisition = c.objectid
        INNER JOIN ta_provenance d ON a.fid_provenance = d.objectid,
            ta_organisme f
        WHERE
            b.nom_source = 'Recensements de la population 1876-2017'
        AND
            c.date_acquisition = '06/04/2020'
        AND
            c.millesime BETWEEN '01/01/1876' AND '01/01/2017'
        AND
            d.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
        AND
            f.nom_organisme IN ('Institut National de la statistique et des études économiques')
	)b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_organisme = b.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(b.fid_metadonnee, b.fid_organisme)
;


-- 7. Insertion des codes insee dans la table TA_CODE si nécessaire
MERGE INTO TA_CODE c
USING 
    (
        SELECT DISTINCT
        	r.CODGEO AS code,
        	l.objectid AS fid_libelle
        FROM
        	RECENSEMENT r,
        	ta_libelle l
        INNER JOIN ta_libelle_long ll ON ll.objectid = l.fid_libelle_long
        WHERE
        	ll.valeur = 'code insee'
    )temp
ON (temp.code = c.code
AND temp.fid_libelle = c.fid_libelle)
WHEN NOT MATCHED THEN
INSERT (c.code,c.fid_libelle)
VALUES (temp.code,temp.fid_libelle)
;


-- 8. Insertion des libelles courts dans TA_LIBELLE_COURT
MERGE INTO ta_libelle_court a
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


-- 9. Insertion des libellés recensement dans TA_LIBELLE_LONG
MERGE INTO ta_libelle_long a
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
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;


-- 10. Insertion de la famille 'Recensement' dans TA_FAMILLE
MERGE INTO TA_FAMILLE a
USING
	(
		SELECT
			'Recensement' AS valeur
		FROM
			DUAL
	)b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;


-- 11. Insertion des données dans ta_famille_libelle
MERGE INTO TA_FAMILLE_LIBELLE a
USING
	(
		SELECT
		    a.objectid fid_famille,
		    b.objectid fid_libelle_long
		FROM
		    ta_famille a,
		    ta_libelle_long b
		WHERE 
    		a.valeur = 'Recensement'
    	AND (b.valeur LIKE 'Population municipale%' OR b.valeur LIKE 'Population sans double compte%' OR b.valeur LIKE 'Population totale%')
	)b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille, a.fid_libelle_long)
VALUES (b.fid_famille, b.fid_libelle_long)
;


-- 12. creation de la table temporaire fusion pour insérer les correspondances
CREATE GLOBAL TEMPORARY TABLE fusion_nomenclature_recensement AS
(SELECT
    a.objectid AS objectid,
    b.objectid AS fid_libelle_long,
    b.valeur AS libelle_long,
    c.objectid AS fid_libelle_court,
    c.valeur AS libelle_court
FROM
    ta_libelle a,
    ta_libelle_court c,
    ta_libelle_long b
INNER JOIN
    TA_FAMILLE_LIBELLE d ON d.fid_libelle_long = b.objectid
INNER JOIN
    TA_FAMILLE f ON f.objectid = d.fid_famille
WHERE
	f.valeur = 'Recensement' AND c.valeur = 'PMUN17' AND b.valeur = 'Population municipale en 2017'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN16' AND b.valeur = 'Population municipale en 2016'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN15' AND b.valeur = 'Population municipale en 2015'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN14' AND b.valeur = 'Population municipale en 2014'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN13' AND b.valeur = 'Population municipale en 2013'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN12' AND b.valeur = 'Population municipale en 2012'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN11' AND b.valeur = 'Population municipale en 2011'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN10' AND b.valeur = 'Population municipale en 2010'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN09' AND b.valeur = 'Population municipale en 2009'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN08' AND b.valeur = 'Population municipale en 2008'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN07' AND b.valeur = 'Population municipale en 2007'
	OR f.valeur = 'Recensement' AND c.valeur = 'PMUN06' AND b.valeur = 'Population municipale en 2006'
	OR f.valeur = 'Recensement' AND c.valeur = 'PSDC99' AND b.valeur = 'Population sans double compte en 1999'
	OR f.valeur = 'Recensement' AND c.valeur = 'PSDC90' AND b.valeur = 'Population sans double compte en 1990'
	OR f.valeur = 'Recensement' AND c.valeur = 'PSDC82' AND b.valeur = 'Population sans double compte en 1982'
	OR f.valeur = 'Recensement' AND c.valeur = 'PSDC75' AND b.valeur = 'Population sans double compte en 1975'
	OR f.valeur = 'Recensement' AND c.valeur = 'PSDC68' AND b.valeur = 'Population sans double compte en 1968'
	OR f.valeur = 'Recensement' AND c.valeur = 'PSDC62' AND b.valeur = 'Population sans double compte en 1962'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT54' AND b.valeur = 'Population totale en 1954'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT36' AND b.valeur = 'Population totale en 1936'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1931' AND b.valeur = 'Population totale en 1931'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1926' AND b.valeur = 'Population totale en 1926'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1921' AND b.valeur = 'Population totale en 1921'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1911' AND b.valeur = 'Population totale en 1911'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1906' AND b.valeur = 'Population totale en 1906'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1901' AND b.valeur = 'Population totale en 1901'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1896' AND b.valeur = 'Population totale en 1896'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1891' AND b.valeur = 'Population totale en 1891'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1886' AND b.valeur = 'Population totale en 1886'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1881' AND b.valeur = 'Population totale en 1881'
	OR f.valeur = 'Recensement' AND c.valeur = 'PTOT1876' AND b.valeur = 'Population totale en 1876'
);


-- 13. Insertion des données dans la table temporaire, la séquence utilisée est celle de la table TA_LIBELLE
INSERT INTO fusion_nomenclature_recensement(objectid, fid_libelle_long, libelle_long, fid_libelle_court, libelle_court)
	SELECT
-- Attention à la séquence utilisée
	    ISEQ$$_1004437.NEXTVAL AS objectid,
-- Attention à la séquence utilisée
	    b.objectid AS fid_libelle_long,
	    b.valeur AS libelle_long,
	    c.objectid AS fid_libelle_court,
	    c.valeur AS libelle_court
	FROM
	    ta_libelle_court c,
	    ta_libelle_long b
	INNER JOIN
	    TA_FAMILLE_LIBELLE d ON d.fid_libelle_long = b.objectid
	INNER JOIN
	    TA_FAMILLE f ON f.objectid = d.fid_famille
	WHERE
		f.valeur = 'Recensement' AND (c.valeur = 'PMUN17' AND b.valeur = 'Population municipale en 2017')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN16' AND b.valeur = 'Population municipale en 2016')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN15' AND b.valeur = 'Population municipale en 2015')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN14' AND b.valeur = 'Population municipale en 2014')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN13' AND b.valeur = 'Population municipale en 2013')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN12' AND b.valeur = 'Population municipale en 2012')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN11' AND b.valeur = 'Population municipale en 2011')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN10' AND b.valeur = 'Population municipale en 2010')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN09' AND b.valeur = 'Population municipale en 2009')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN08' AND b.valeur = 'Population municipale en 2008')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN07' AND b.valeur = 'Population municipale en 2007')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PMUN06' AND b.valeur = 'Population municipale en 2006')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PSDC99' AND b.valeur = 'Population sans double compte en 1999')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PSDC90' AND b.valeur = 'Population sans double compte en 1990')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PSDC82' AND b.valeur = 'Population sans double compte en 1982')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PSDC75' AND b.valeur = 'Population sans double compte en 1975')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PSDC68' AND b.valeur = 'Population sans double compte en 1968')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PSDC62' AND b.valeur = 'Population sans double compte en 1962')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT54' AND b.valeur = 'Population totale en 1954')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT36' AND b.valeur = 'Population totale en 1936')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1931' AND b.valeur = 'Population totale en 1931')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1926' AND b.valeur = 'Population totale en 1926')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1921' AND b.valeur = 'Population totale en 1921')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1911' AND b.valeur = 'Population totale en 1911')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1906' AND b.valeur = 'Population totale en 1906')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1901' AND b.valeur = 'Population totale en 1901')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1896' AND b.valeur = 'Population totale en 1896')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1891' AND b.valeur = 'Population totale en 1891')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1886' AND b.valeur = 'Population totale en 1886')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1881' AND b.valeur = 'Population totale en 1881')
		OR f.valeur = 'Recensement' AND (c.valeur = 'PTOT1876' AND b.valeur = 'Population totale en 1876')
	;


-- 14. Insertion des 'objectid' et des 'fid_libelle_long' grâce à la table temporaire fusion_nomenclature_recensement(voir 12. et 13.) dans la table ta_libelle
MERGE INTO ta_libelle l
USING
    (
    SELECT
        objectid, 
        fid_libelle_long
    FROM fusion_nomenclature_recensement
    ) temp
ON (temp.objectid = l.objectid
AND temp.fid_libelle_long = l.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (l.objectid,l.fid_libelle_long)
VALUES (temp.objectid,temp.fid_libelle_long)
;


-- 15. Insertion des données dans ta_libelle_correspondance grâce à la table temporaire fusion_nomenclature_recensement(voir 12. et 13.) dans la table ta_libelle
MERGE INTO ta_libelle_correspondance tc
USING
    (
    SELECT
        objectid, 
        fid_libelle_court
    FROM fusion_nomenclature_recensement
    ) temp
ON (temp.objectid = tc.fid_libelle
AND temp.fid_libelle_court = tc.fid_libelle_court)
WHEN NOT MATCHED THEN
INSERT (tc.fid_libelle,tc.fid_libelle_court)
VALUES (temp.objectid,temp.fid_libelle_court)
;


-- 16. Suppression des données temporaire.

-- 16.1. Suppression de la table temporaire fusion_nomenclature_recensement
DROP TABLE fusion_nomenclature_recensement CASCADE CONSTRAINTS PURGE;