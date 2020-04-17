-- Insertion de la nomenclature de la base de population historique du recensement entre 1876 et 2017

-- 1. Insertion de la source dans TA_SOURCE.
MERGE INTO ta_source s
USING
    (
    	SELECT 'Recensements de la population 1876-2017' AS nom,'Les statistiques sont proposées dans la géographie communale en vigueur au 01/01/2019 pour la France hors Mayotte, afin que leurs comparaisons dans le temps se fassent sur un champ géographique stable.' AS description FROM DUAL
    ) temp
ON (temp.nom = s.nom_source
AND temp.desription = s.description)
WHEN NOT MATCHED THEN
INSERT (s.nom_source,s.description)
VALUES (temp.nom,temp.description)
;

-- 2. Insertion de la provenance dans TA_PROVENANCE
MERGE INTO ta_provenance p
USING
    (
    	SELECT 'https://www.insee.fr/fr/statistiques/3698339#consulter' AS url,'les données sont proposées en libre accès sous la forme d''un tableau xlxs.'  AS methode_acquisition FROM DUAL
   	) temp
ON (p.url = temp.url
AND p.methode_acquisition = temp.methode_acquisition)
WHEN NOT MATCHED THEN
INSERT p.url,p.methode_acquisition)
VALUES(temp.url,temp.methode_acquisition)
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
INSERT INTO ta_metadonnee (fid_source,fid_acquisition,fid_provenance,fid_organisme)
SELECT
  s.objectid,
  a.objectid,
  p.objectid,
  o.objectid
FROM
  ta_source s,
  ta_date_acquisition a,
  ta_provenance p,
  ta_organisme o
WHERE
  s.nom_source = 'Recensements de la population 1876-2017'
  AND a.millesime BETWEEN '01/01/1876' AND '01/01/2017'
  AND a.date_acquisition = '06/04/2020'
  AND p.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
  AND o.acronyme = 'INSEE'
;

-- 6. Insertion des libelles courts dans TA_LIBELLE_COURT

MERGE INTO ta_libelle_court tlc
USING
	(
		SELECT 'PMUN17' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN16' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN15' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN14' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN13' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN12' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN11' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN10' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN09' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN08' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN07' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PMUN06' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PSDC99' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PSDC90' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PSDC82' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PSDC75' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PSDC68' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PSDC62' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT54' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT36' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1931' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1926' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1921' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1911' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1906' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1901' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1896' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1891' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1886' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1881' AS RECENSEMENT FROM DUAL
		UNION SELECT 'PTOT1876' AS RECENSEMENT FROM DUAL
	) temp
ON (temp.RECENSEMENT = tlc.libelle_court)
WHEN NOT MATCHED THEN
INSERT (tlc.libelle_court)
VALUES (temp.RECENSEMENT)
;

-- 7. Insertion des libelles dans TA_LIBELLE

MERGE INTO ta_libelle tl
USING
	(
		SELECT 'Population municipale en 2017' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2016' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2015' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2014' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2013' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2012' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2011' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2010' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2009' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2008' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2007' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population municipale en 2006' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population sans double compte en 1999' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population sans double compte en 1990' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population sans double compte en 1982' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population sans double compte en 1975' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population sans double compte en 1968' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population sans double compte en 1962' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1954' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1936' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1931' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1926' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1921' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1911' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1906' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1901' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1896' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1891' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1886' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1881' AS RECENSEMENT FROM DUAL
		UNION SELECT 'Population totale en 1876' AS RECENSEMENT FROM DUAL
	) temp
ON (temp.RECENSEMENT = tl.libelle)
WHEN NOT MATCHED THEN
INSERT (tl.libelle)
VALUES (temp.RECENSEMENT)
;

-- 8. Insertion des données dans TA_FAMILLE
INSERT INTO
ta_famille(famille)
VALUES ('recensement');

-- 9. Insertion des données dans ta_famille_libelle
INSERT INTO ta_famille_libelle(fid_famille,fid_libelle)
SELECT
  f.objectid,
  l.objectid
FROM
  ta_famille f,
  ta_libelle l
WHERE
  f.famille = 'recensement'
  AND (
    l.libelle LIKE 'Population municipale%'
    OR l.libelle LIKE 'Population sans double compte%'
    OR l.libelle LIKE 'Population totale%'
  );

-- 10. Insertion des correspondances dans la table TA_CORRESPONDANCE LIBELLE

INSERT INTO ta_correspondance_libelle(fid_libelle,fid_libelle_court)
SELECT
  l.objectid,
  lc.objectid
FROM
  ta_libelle l,
  ta_libelle_court lc,
  ta_famille f
WHERE
  f.famille = 'recensement'
  AND (
    (lc.libelle_court = 'PMUN17' AND l.libelle = 'Population municipale en 2017')
    OR (lc.libelle_court = 'PMUN16' AND l.libelle = 'Population municipale en 2016')
    OR (lc.libelle_court = 'PMUN15' AND l.libelle = 'Population municipale en 2015')
    OR (lc.libelle_court = 'PMUN14' AND l.libelle = 'Population municipale en 2014')
    OR (lc.libelle_court = 'PMUN13' AND l.libelle = 'Population municipale en 2013')
    OR (lc.libelle_court = 'PMUN12' AND l.libelle = 'Population municipale en 2012')
    OR (lc.libelle_court = 'PMUN11' AND l.libelle = 'Population municipale en 2011')
    OR (lc.libelle_court = 'PMUN10' AND l.libelle = 'Population municipale en 2010')
    OR (lc.libelle_court = 'PMUN09' AND l.libelle = 'Population municipale en 2009')
    OR (lc.libelle_court = 'PMUN08' AND l.libelle = 'Population municipale en 2008')
    OR (lc.libelle_court = 'PMUN07' AND l.libelle = 'Population municipale en 2007')
    OR (lc.libelle_court = 'PMUN06' AND l.libelle = 'Population municipale en 2006')
    OR (lc.libelle_court = 'PSDC99' AND l.libelle = 'Population sans double compte en 1999')
    OR (lc.libelle_court = 'PSDC90' AND l.libelle = 'Population sans double compte en 1990')
    OR (lc.libelle_court = 'PSDC82' AND l.libelle = 'Population sans double compte en 1982')
    OR (lc.libelle_court = 'PSDC75' AND l.libelle = 'Population sans double compte en 1975')
    OR (lc.libelle_court = 'PSDC68' AND l.libelle = 'Population sans double compte en 1968')
    OR (lc.libelle_court = 'PSDC62' AND l.libelle = 'Population sans double compte en 1962')
    OR (lc.libelle_court = 'PTOT54' AND l.libelle = 'Population totale en 1954')
    OR (lc.libelle_court = 'PTOT36' AND l.libelle = 'Population totale en 1936')
    OR (lc.libelle_court = 'PTOT1931' AND l.libelle = 'Population totale en 1931')
    OR (lc.libelle_court = 'PTOT1926' AND l.libelle = 'Population totale en 1926')
    OR (lc.libelle_court = 'PTOT1921' AND l.libelle = 'Population totale en 1921')
    OR (lc.libelle_court = 'PTOT1911' AND l.libelle = 'Population totale en 1911')
    OR (lc.libelle_court = 'PTOT1906' AND l.libelle = 'Population totale en 1906')
    OR (lc.libelle_court = 'PTOT1901' AND l.libelle = 'Population totale en 1901')
    OR (lc.libelle_court = 'PTOT1896' AND l.libelle = 'Population totale en 1896')
    OR (lc.libelle_court = 'PTOT1891' AND l.libelle = 'Population totale en 1891')
    OR (lc.libelle_court = 'PTOT1886' AND l.libelle = 'Population totale en 1886')
    OR (lc.libelle_court = 'PTOT1881' AND l.libelle = 'Population totale en 1881')
    OR (lc.libelle_court = 'PTOT1876' AND l.libelle = 'Population totale en 1876')
    );
