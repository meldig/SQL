/*
Requêtes SQL utilisées pour insérer les données nécessaire à la compréhension des données historique des populatons communales. Recensements de la population 1876-2017.
Cette base fournit les données de populations de 1876 à 2017 pour les communes de France continentale, de 1936 à 2017 pour les communes de Corse et de 1954 ou 1962 à 2017 pour les communes des DOM (hors Mayotte).
*/

-- 1. Insertion de la source dans TA_SOURCE.
MERGE INTO ta_source s
USING
	(
		SELECT 'Historique des populations communales - Recensements de la population 1876-2017' AS source FROM DUAL
	) temp
ON (temp.source = s.nom_source)
WHEN NOT MATCHED THEN
INSERT (s.nom_source)
VALUES (temp.source)
;


-- 2. Insertion de la provenance dans TA_PROVENANCE
MERGE INTO ta_provenance p
USING
	(
		SELECT 'https://www.insee.fr/fr/statistiques/3698339#consulter' AS url,'la données est proposé en libre accès sous la forme dans tableau xlxs.' AS methode_acquisition FROM DUAL
	)temp
ON (temp.url = p.url
AND temp.methode_acquisition = p.methode_acquisition)
WHEN NOT MATCHED THEN
INSERT (p.url,p.methode_acquisition)
VALUES (temp.url,temp.methode_acquisition)
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
	) temp
ON (temp.date_acquisition = a.date_acquisition
AND temp.millesime = a.millesime)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition,a.millesime)
VALUES (temp.date_acquisition,temp.millesime)
;


-- 4. Insertion des données dans TA_ORGANISME
MERGE INTO ta_organisme a
USING
	(SELECT 'INSEE' AS ACRONYME, 'Institut National de la Statistique et des Etudes Economiques' AS NOM_ORGANISME FROM DUAL) temp
ON (a.acronyme = temp.acronyme)
WHEN NOT MATCHED THEN
INSERT (a.acronyme,a.nom_organisme)
VALUES(temp.acronyme,temp.nom_organisme)
;


-- 5. Insertion des données dans TA_METADONNEE
MERGE INTO ta_metadonnee m
USING
	(
		SELECT 
		    s.objectid fid_source,
		    a.objectid fid_acquisition,
		    p.objectid fid_provenance,
		    o.objectid fid_organisme
		FROM
		    ta_source s,
		    ta_date_acquisition a,
		    ta_provenance p,
		    ta_organisme o
		WHERE
		    s.nom_source = 'Historique des populations communales - Recensements de la population 1876-2017'
		AND
		    a.millesime IN ('01/01/2017','01/01/2016','01/01/2015','01/01/2014','01/01/2013','01/01/2012','01/01/2011','01/01/2010','01/01/2009','01/01/2008','01/01/2007','01/01/2006','01/01/1999','01/01/1990','01/01/1982','01/01/1975','01/01/1968','01/01/1962','01/01/1954','01/01/1936','01/01/1931','01/01/1926','01/01/1921','01/01/1911','01/01/1906','01/01/1901','01/01/1896','01/01/1891','01/01/1886','01/01/1881','01/01/1876')
		AND
		    a.date_acquisition = '06/04/2020'
		AND
		    p.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
		AND
		    o.acronyme = 'INSEE'
	)temp
ON (m.fid_source = temp.fid_source
AND m.fid_acquisition = temp.fid_acquisition
AND m.fid_provenance = temp.fid_provenance
AND m.fid_organisme = temp.fid_organisme)
WHEN NOT MATCHED THEN
INSERT (m.fid_source,m.fid_acquisition,m.fid_provenance,m.fid_organisme)
VALUES(temp.fid_source,temp.fid_acquisition,temp.fid_provenance,temp.fid_organisme)
;


-- 6. Insertion des code insee dans la table TA_CODE si nécessaire
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


-- 7. Création d'une vue pour simplifier l'insertion de la nomenclature des données historiques du recensement
CREATE VIEW nomenclature_recensement AS    
    SELECT
        codgeo,
        recensement
    FROM
    recensement
    UNPIVOT
        (habitant for (recensement) IN
        (PMUN17 AS 'PMUN17',
        PMUN16 AS 'PMUN16',
        PMUN15 AS 'PMUN15',
        PMUN14 AS 'PMUN14',
        PMUN13 AS 'PMUN13',
        PMUN12 AS 'PMUN12',
        PMUN11 AS 'PMUN11',
        PMUN10 AS 'PMUN10',
        PMUN09 AS 'PMUN09',
        PMUN08 AS 'PMUN08',
        PMUN07 AS 'PMUN07',
        PMUN06 AS 'PMUN06',
        PSDC99 AS 'PSDC99',
        PSDC90 AS 'PSDC90',
        PSDC82 AS 'PSDC82',
        PSDC75 AS 'PSDC75',
        PSDC68 AS 'PSDC68',
        PSDC62 AS 'PSDC62',
        PTOT54 AS 'PTOT54',
        PTOT36 AS 'PTOT36',
        PTOT1931 AS 'PTOT1931',
        PTOT1926 AS 'PTOT1926',
        PTOT1921 AS 'PTOT1921',
        PTOT1911 AS 'PTOT1911',
        PTOT1906 AS 'PTOT1906',
        PTOT1901 AS 'PTOT1901',
        PTOT1896 AS 'PTOT1896',
        PTOT1891 AS 'PTOT1891',
        PTOT1886 AS 'PTOT1886',
        PTOT1881 AS 'PTOT1881',
        PTOT1876 AS 'PTOT1876')
        );


-- 8. Insertion des libellés courts dans TA_LIBELLE_COURT
MERGE INTO ta_libelle_court tlc
USING
	(
		SELECT DISTINCT RECENSEMENT AS valeur FROM nomenclature_recensement
	) temp
ON (temp.valeur = tlc.valeur)
WHEN NOT MATCHED THEN
INSERT (tlc.valeur)
VALUES (temp.valeur)
;


-- 9. Insertion des libellés recensement dans TA_LIBELLE_LONG
MERGE INTO ta_libelle_long tll
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
	) temp
ON (temp.valeur = tll.valeur)
WHEN NOT MATCHED THEN
INSERT (tll.valeur)
VALUES (temp.valeur)
;


-- 10. Insertion de la famille 'Recensement' dans TA_FAMILLE
MERGE INTO TA_FAMILLE f
USING
	(
		SELECT 'Recensement' AS valeur FROM DUAL
	)temp
ON (temp.valeur = f.valeur)
WHEN NOT MATCHED THEN
INSERT (f.valeur)
VALUES (temp.valeur)
;


-- 11. Insertion des données dans la table TA_FAMILLE_LIBELLE
MERGE INTO TA_FAMILLE_LIBELLE fl
USING
	(
		SELECT
		    f.objectid fid_famille,
		    ll.objectid fid_libelle_long
		FROM
		    ta_famille f,
		    ta_libelle_long ll
		WHERE 
    		f.valeur = 'Recensement' AND (ll.valeur LIKE 'Population municipale%' OR ll.valeur LIKE 'Population sans double compte%' OR ll.valeur LIKE 'Population totale%')
	)temp
ON (temp.fid_famille = fl.fid_famille
AND temp.fid_libelle_long = fl.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (fl.fid_famille,fl.fid_libelle_long)
VALUES (temp.fid_famille,temp.fid_libelle_long)
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
	    ISEQ$$_78716.NEXTVAL AS objectid,
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


-- 15. Insertion des données dans ta_correspondance_libelle grâce à la table temporaire fusion_nomenclature_recensement(voir 12. et 13.) dans la table ta_libelle
MERGE INTO ta_correspondance_libelle tc
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

-- 16.2. Suppression de la vue nomenclature_recensement
DROP VIEW nomenclature_recensement CASCADE CONSTRAINTS;