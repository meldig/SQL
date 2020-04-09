-- Insertion de la nomenclature IRIS
-- 1. Insertion de la source dans TA_SOURCE
MERGE INTO ta_source s
USING 
    (
        SELECT 'Contours IRIS' AS nom, 'Contours...Iris®, coédition Insee et IGN, est la base de données de référence pour la diffusion infracommunale des résultats du recensement de la population par Iris, de précision décamétrique.' AS description FROM DUAL
    ) temp
ON (temp.nom = s.nom_source
AND temp.desription = s.description)
WHEN NOT MATCHED THEN
INSERT (s.nom_source,s.description)
VALUES (temp.nom,temp.description)
;

-- 2. Insertion des données dans TA_PROVENANCE
MERGE INTO ta_provenance p
USING
    (
        SELECT 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris' AS url, 'Donnée à télécharger en libre accès' AS methode_acquisition FROM DUAL
    ) temp
ON (p.url = temp.url
AND p.methode_acquisition = temp.methode_acquisition)
WHEN NOT MATCHED THEN
INSERT p.url,p.methode_acquisition)
VALUES(temp.url,temp.methode_acquisition)
;

-- 3. Insertion dans TA_DATE_ACQUISITION
MERGE INTO ta_date_acquisition a
USING
    (
        SELECT TO_DATE('01/04/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2018') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
    ) temp
ON (temp.date_acquisition = a.date_acquisition
AND temp.millesime = a.millesime)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition,a.millesime)
VALUES (temp.date_acquisition,temp.millesime)
;

-- 4. Insertion de la source dans TA_ORGANISME
MERGE INTO ta_organisme a
USING
    (SELECT 'IGN' AS ACRONYME, 'Institut National de l''Information Géographique et Forestière' AS NOM_ORGANISME FROM DUAL) temp
ON (a.acronyme = temp.acronyme)
WHEN NOT MATCHED THEN
INSERT (a.acronyme,a.nom_organisme)
VALUES(temp.acronyme,temp.nom_organisme)
;


-- 5. Insertion des métadonnées dans la table TA_METADONNEE
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
        s.nom_source = 'Contours IRIS'
    AND
        a.millesime IN ('01/01/2018')
    AND
        a.date_acquisition = '01/04/2020'
    AND
        p.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris'
    AND
        o.acronyme = 'IGN'
;
-- 6. Insertion de la nomenclature dans la table TA_LIBELLE

MERGE INTO ta_libelle t
USING 
    (
    SELECT 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' AS TYPE FROM dual
    UNION
    SELECT 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' AS TYPE FROM dual
    UNION
    SELECT 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' AS TYPE FROM dual
    UNION
    SELECT 'Communes non découpées en IRIS' AS TYPE FROM dual
    UNION
    SELECT 'code IRIS' AS TYPE FROM dual
    ) temp
  ON (temp.TYPE = t.libelle)
  WHEN NOT MATCHED THEN
  INSERT (t.libelle)
  VALUES (temp.TYPE)
  ;

-- 7. Insertion de la nomenclature dans la table TA_LIBELLE_COURT

MERGE INTO ta_libelle_court tl
USING 
    (
    SELECT 'A' AS TYPE FROM dual
    UNION
    SELECT 'D' AS TYPE FROM dual
    UNION
    SELECT 'H' AS TYPE FROM dual
    UNION
    SELECT 'Z' AS TYPE FROM dual
    ) temp
ON (temp.TYPE = tl.libelle_court)
WHEN NOT MATCHED THEN
INSERT (tl.libelle_court)
VALUES (temp.TYPE)
;


-- 8. Insertion des correspondances dans la table TA_CORRESPONDANCE_LIBELLE

INSERT INTO TA_CORRESPONDANCE_LIBELLE(fid_libelle, fid_libelle_court)
SELECT
    a.objectid AS objectid_libelle,
    b.objectid AS objectid_libelle_court
FROM
    ta_libelle a,
    ta_libelle_court b
WHERE
    a.libelle ='IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' and b.libelle_court='H' OR
    a.libelle ='IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' and b.libelle_court='D' OR
    a.libelle ='IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente'  and b.libelle_court='A' OR
    a.libelle ='Communes non découpées en IRIS' and b.libelle_court='Z'
;


-- 9. Insertion des familles utilisée par les données IRIS.

MERGE INTO ta_famille f
USING 
    (
    SELECT 'type de zone IRIS' AS famille FROM dual
    UNION
    SELECT 'Identifiant de zone admINistratives' AS famille FROM dual
    ) temp
ON (temp.famille = f.famille)
WHEN NOT MATCHED THEN
INSERT (f.famille)
VALUES (temp.famille);


-- 10. Insertion des correspondance familler libelle dans TA_FAMILLE_LIBELLE;

INSERT INTO TA_FAMILLE_LIBELLE(fid_famille, fid_libelle)
SELECT
    a.objectid AS objectid_famille,
    b.objectid AS objectid_libelle
FROM
    ta_famille a,
    ta_libelle b
WHERE
	a.famille = 'type de zone IRIS' AND b.libelle = 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' OR
	a.famille = 'type de zone IRIS' AND b.libelle = 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' OR
	a.famille = 'type de zone IRIS' AND b.libelle = 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' OR
	a.famille = 'type de zone IRIS' AND b.libelle = 'Communes non découpées en IRIS' OR
	a.famille = 'Identifiant de zone admINistratives' AND b.libelle = 'code IRIS'
;