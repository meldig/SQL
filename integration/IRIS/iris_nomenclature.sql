/*
Ensemble des requêtes utilisés pour insérer la nomenclature des données IRIS dans la base de données.
*/
-- 1. Insertion de la source dans TA_SOURCE
MERGE INTO ta_source s
USING 
    (
        SELECT 'Contours IRIS' AS nom, 'Contours...Iris®, coédition Insee et IGN, est la base de données de référence pour la diffusion infracommunale des résultats du recensement de la population par Iris, de précision décamétrique.' AS description FROM DUAL
    ) temp
ON (temp.nom = s.nom_source
AND temp.description = s.description)
WHEN NOT MATCHED THEN
INSERT (s.nom_source,s.description)
VALUES (temp.nom,temp.description)
;


-- 2. Insertion de la provenance de la données dans TA_PROVENANCE
MERGE INTO ta_provenance p
USING
    (
        SELECT 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris' AS url, 'Donnée à télécharger en libre accès' AS methode_acquisition FROM DUAL
    ) temp
ON (p.url = temp.url
AND p.methode_acquisition = temp.methode_acquisition)
WHEN NOT MATCHED THEN
INSERT (p.url,p.methode_acquisition)
VALUES(temp.url,temp.methode_acquisition)
;


-- 3. Insertion des dates d'acquisition et du millesime de la source dans la table TA_DATE_ACQUISITION
-- attention à l'insertion des dates, à mettre à jour suivant le millesime de la donnée à insérer
MERGE INTO ta_date_acquisition a
USING
    (
        SELECT TO_DATE('12/06/2012') AS DATE_ACQUISITION, TO_DATE('01/01/2018') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
    ) temp
ON (temp.date_acquisition = a.date_acquisition
AND temp.millesime = a.millesime)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition,a.millesime)
VALUES (temp.date_acquisition,temp.millesime)
;


-- 4. Insertion de l'organisme producteur dans la table TA_ORGANISME
MERGE INTO ta_organisme a
USING
    (
        SELECT 'IGN' AS ACRONYME, 'Institut National de l''Information Géographique et Forestière' AS NOM_ORGANISME FROM DUAL
    ) temp
ON (a.acronyme = temp.acronyme)
WHEN NOT MATCHED THEN
INSERT (a.acronyme,a.nom_organisme)
VALUES(temp.acronyme,temp.nom_organisme)
;


-- 5. Insertion de l'echelle d'utilisation dans la table TA_ECHELLE
MERGE INTO ta_echelle e
USING
    (
        SELECT '1/1000000' AS ECHELLE FROM DUAL
    )temp
ON (e.echelle = temp.echelle)
WHEN NOT MATCHED THEN
INSERT (e.echelle)
VALUES(temp.echelle)
;


-- 6. Insertion des métadonnées dans la table TA_METADONNEE
-- attention à l'insertion des dates, à mettre à jour suivant le millesime de la donnée à insérer
MERGE INTO ta_metadonnee m
USING
    (
        SELECT 
            s.objectid AS fid_source,
            a.objectid AS fid_acquisition,
            p.objectid AS fid_provenance,
            o.objectid AS fid_organisme,
            e.objectid AS fid_echelle
        FROM
            ta_source s,
            ta_date_acquisition a,
            ta_provenance p,
            ta_organisme o,
            ta_echelle e
        WHERE
            s.nom_source = 'Contours IRIS'
        AND
            a.millesime IN ('01/01/2019')
        AND
            a.date_acquisition = '12/06/2020'
        AND
            p.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris'
        AND
            o.acronyme = 'IGN'
        AND
            e.echelle = '1/1000000'
    )temp
ON (m.fid_source = temp.fid_source
AND m.fid_acquisition = temp.fid_acquisition
AND m.fid_provenance = temp.fid_provenance
AND m.fid_organisme = temp.fid_organisme
AND m.fid_echelle = temp.fid_echelle)
WHEN NOT MATCHED THEN
INSERT (m.fid_source, m.fid_acquisition, m.fid_provenance, m.fid_organisme, m.fid_echelle)
VALUES (temp.fid_source, temp.fid_acquisition, temp.fid_provenance, temp.fid_organisme, temp.fid_echelle)
;


-- 7. Insertion de la nomenclature dans la table TA_LIBELLE_COURT
MERGE INTO ta_libelle_court tl
USING 
    (
    SELECT DISTINCT TYP_IRIS AS VALEUR FROM contours_iris
    ) temp
ON (temp.VALEUR = tl.VALEUR)
WHEN NOT MATCHED THEN
INSERT (tl.VALEUR)
VALUES (temp.VALEUR)
;


-- 8. Insertion de la nomenclature dans la table TA_LIBELLE LONG
MERGE INTO ta_libelle_long t
USING 
    (
    SELECT 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' AS VALEUR FROM dual
    UNION
    SELECT 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' AS VALEUR FROM dual
    UNION
    SELECT 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' AS VALEUR FROM dual
    UNION
    SELECT 'Communes non découpées en IRIS' AS VALEUR FROM dual
    UNION
    SELECT 'code IRIS' AS VALEUR FROM dual
    ) temp
  ON (temp.VALEUR = t.VALEUR)
  WHEN NOT MATCHED THEN
  INSERT (t.VALEUR)
  VALUES (temp.VALEUR)
  ;


-- 9. Insertion des familles utilisée par les données IRIS dans la table TA_FAMILLE.
MERGE INTO ta_famille f
USING 
    (
    SELECT 'type de zone IRIS' AS VALEUR FROM dual
    UNION
    SELECT 'Identifiant de zone administrative' AS VALEUR FROM dual
    ) temp
ON (temp.VALEUR = f.VALEUR)
WHEN NOT MATCHED THEN
INSERT (f.VALEUR)
VALUES (temp.VALEUR);


-- 10. Insertion des correspondances famille libelle dans TA_FAMILLE_LIBELLE;
MERGE INTO ta_famille_libelle fl
USING 
    (
    SELECT
        a.objectid AS objectid_famille,
        b.objectid AS objectid_libelle_long
    FROM
        ta_famille a,
        ta_libelle_long b
    WHERE
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' OR
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' OR
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' OR
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'Communes non découpées en IRIS' OR
        a.VALEUR = 'Identifiant de zone administrative' AND b.VALEUR = 'code IRIS'
    ) temp
ON (temp.objectid_famille = fl.fid_famille
AND temp.objectid_libelle_long = fl.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (fl.fid_famille,fl.fid_libelle_long)
VALUES (temp.objectid_famille,temp.objectid_libelle_long);


-- 11. Création de la table temporaire fusion_nomenclature_iris
CREATE GLOBAL TEMPORARY TABLE fusion_nomenclature_iris AS
(SELECT
    a.objectid AS objectid,
    b.objectid AS fid_libelle_long,
    b.VALEUR AS libelle_long,
    c.objectid AS fid_libelle_court,
    c.VALEUR AS libelle_court
FROM
    ta_libelle a,
    ta_libelle_court c,
    ta_libelle_long b
INNER JOIN
    TA_FAMILLE_LIBELLE trl ON trl.fid_libelle_long = b.objectid
INNER JOIN
    TA_FAMILLE f ON f.objectid = trl.fid_famille
WHERE
    c.VALEUR = 'H' AND b.VALEUR = 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' OR
    c.VALEUR = 'D' AND b.VALEUR = 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' OR
    c.VALEUR = 'A' AND b.VALEUR = 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' OR
    c.VALEUR = 'Z' AND b.VALEUR = 'Communes non découpées en IRIS' AND
    f.VALEUR = 'type de zone IRIS'
);


-- 12. Insertion des données dans la table temporaire fusion_nomenclature_iris
INSERT INTO fusion_nomenclature_iris
SELECT
-- Attention à la séquence utilisée
    ISEQ$$_78716.nextval as objectid,
-- Attention à la séquence utilisée
    b.objectid AS fid_libelle_long,
    b.VALEUR AS libelle_long,
    c.objectid AS fid_libelle_court,
    c.VALEUR AS libelle_court
FROM
    ta_libelle_court c,
    ta_libelle_long b
INNER JOIN
    TA_FAMILLE_LIBELLE trl ON trl.fid_libelle_long = b.objectid
INNER JOIN
    TA_FAMILLE f ON f.objectid = trl.fid_famille
WHERE
    c.VALEUR = 'H' AND b.VALEUR = 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' OR
    c.VALEUR = 'D' AND b.VALEUR = 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' OR
    c.VALEUR = 'A' AND b.VALEUR = 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' OR
    c.VALEUR = 'Z' AND b.VALEUR = 'Communes non découpées en IRIS' AND
    f.VALEUR = 'type de zone IRIS'
;


-- 13. Insertion des données dans ta_libelle
MERGE INTO ta_libelle l
USING
    (
    SELECT
        objectid, 
        fid_libelle_long
    FROM fusion_nomenclature_iris
    ) temp
ON (temp.objectid = l.objectid
AND temp.fid_libelle_long = l.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (l.objectid,l.fid_libelle_long)
VALUES (temp.objectid,temp.fid_libelle_long)
;


-- 14. Insertion des données dans ta_correspondance_libelle
MERGE INTO ta_correspondance_libelle tc
USING
    (
    SELECT
        objectid, 
        fid_libelle_court
    FROM fusion_nomenclature_iris
    ) temp
ON (temp.objectid = tc.fid_libelle
AND temp.fid_libelle_court = tc.fid_libelle_court)
WHEN NOT MATCHED THEN
INSERT (tc.fid_libelle,tc.fid_libelle_court)
VALUES (temp.objectid,temp.fid_libelle_court)
;


-- 15. Suppression des tables et des vues utilisés seulement pour l'insertion de la nomenclature.
-- 15.1. Suppression de la table temporaire fusion_nomenclature_iris
DROP TABLE fusion_nomenclature_iris CASCADE CONSTRAINTS PURGE;