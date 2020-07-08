/*
Ensemble des requêtes utilisés pour insérer la nomenclature des données IRIS dans la base de données.
*/
-- 1. Insertion de la source dans TA_SOURCE
MERGE INTO ta_source a
USING 
    (
        SELECT 'Contours...IRIS' AS nom_source, 'Contours...Iris®, coédition Insee et IGN, est la base de données de référence pour la diffusion infracommunale des résultats du recensement de la population par Iris, de précision décamétrique.' AS description FROM DUAL
    ) b
ON (a.nom_source = b.nom_source
AND a.description = b.description)
WHEN NOT MATCHED THEN
INSERT (a.nom_source,a.description)
VALUES (b.nom_source,b.description)
;


-- 2. Insertion de la provenance de la données dans TA_PROVENANCE
MERGE INTO ta_provenance a
USING
    (
        SELECT 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris' AS url, 'Donnée à télécharger en libre accès' AS methode_acquisition FROM DUAL
    ) b
ON (a.url = b.url
AND a.methode_acquisition = b.methode_acquisition)
WHEN NOT MATCHED THEN
INSERT (a.url,a.methode_acquisition)
VALUES(b.url,b.methode_acquisition)
;


-- 3. Insertion des dates d'acquisition et du millesime de la source dans la table TA_DATE_ACQUISITION
-- attention à l'insertion des dates, à mettre à jour suivant le millesime de la donnée à insérer
MERGE INTO ta_date_acquisition a
USING
    (
        SELECT '12/06/2019' AS DATE_ACQUISITION, '03/09/2019' AS MILLESIME,'rjault' AS NOM_OBTENTEUR FROM DUAL
    ) b
ON (a.date_acquisition = b.date_acquisition
AND a.millesime = b.millesime
AND a.nom_obtenteur = b.nom_obtenteur)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition,a.millesime, a.nom_obtenteur)
VALUES (b.date_acquisition, b.millesime, b.nom_obtenteur)
;


-- 4. Insertion de l'organisme producteur dans la table TA_ORGANISME
MERGE INTO ta_organisme a
USING
    (
        SELECT 'IGN' AS ACRONYME, 'Institut National de l''Information Geographie et Forestiere' AS NOM_ORGANISME FROM DUAL
        UNION
        SELECT 'INSEE' AS ACRONYME, 'Institut National de la Statistique et des Etudes Economiques' AS NOM_ORGANISME FROM DUAL
    ) b
ON (a.acronyme = b.acronyme)
WHEN NOT MATCHED THEN
INSERT (a.acronyme,a.nom_organisme)
VALUES(b.acronyme,b.nom_organisme)
;

-- 5. Insertion de l'echelle d'utilisation dans la table TA_ECHELLE
MERGE INTO ta_echelle a
USING
    (
        SELECT '1 000 000' AS VALEUR FROM DUAL
    )b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES(b.valeur)
;


-- 6. Insertion des métadonnées dans la table TA_METADONNEE
-- attention à l'insertion des dates, à mettre à jour suivant le millesime de la donnée à insérer
MERGE INTO ta_metadonnee a
USING
    (
        SELECT 
            a.objectid AS fid_source,
            b.objectid AS fid_acquisition,
            c.objectid AS fid_provenance,
            d.objectid AS fid_echelle
        FROM
            ta_source a,
            ta_date_acquisition b,
            ta_provenance c,
            ta_echelle d
        WHERE
            a.nom_source = 'Contours...IRIS'
        AND
            b.millesime IN ('03/09/2019')
        AND
            b.date_acquisition = '12/06/2019'
        AND
            c.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris'
        AND
            d.valeur = '1 000 000'
    )temp
ON (a.fid_source = temp.fid_source
AND a.fid_acquisition = temp.fid_acquisition
AND a.fid_provenance = temp.fid_provenance
AND a.fid_echelle = temp.fid_echelle)
WHEN NOT MATCHED THEN
INSERT (a.fid_source, a.fid_acquisition, a.fid_provenance, a.fid_echelle)
VALUES (temp.fid_source, temp.fid_acquisition, temp.fid_provenance, temp.fid_echelle)
;

-- 7. Insertion des information dans la table ta_metadonnee_relation_organisme
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
            b.nom_source = 'Contours...IRIS'
        AND
            c.date_acquisition = '12/06/2019'
        AND
            c.millesime = '03/09/2019'
        AND
            d.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris'
        AND
            e.valeur = '1 000 000'
        AND
            f.nom_organisme IN ('Institut National de l''Information Geographie et Forestiere','Institut National de la statistique et des études économiques')
    )b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_organisme = b.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(b.fid_metadonnee, b.fid_organisme)
;


-- 8. Insertion de la nomenclature dans la table TA_LIBELLE_COURT
MERGE INTO ta_libelle_court a
USING 
    (
    SELECT DISTINCT TYP_IRIS AS VALEUR FROM contours_iris
    ) b
ON (a.VALEUR = b.VALEUR)
WHEN NOT MATCHED THEN
INSERT (a.VALEUR)
VALUES (b.VALEUR)
;


-- 9. Insertion de la nomenclature dans la table TA_LIBELLE LONG
MERGE INTO ta_libelle_long a
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
    ) b
  ON (a.VALEUR = b.VALEUR)
  WHEN NOT MATCHED THEN
  INSERT (a.VALEUR)
  VALUES (b.VALEUR)
  ;


-- 10. Insertion des familles utilisée par les données IRIS dans la table TA_FAMILLE.
MERGE INTO ta_famille a
USING 
    (
    SELECT 'type de zone IRIS' AS VALEUR FROM dual
    ) b
ON (a.VALEUR = b.VALEUR)
WHEN NOT MATCHED THEN
INSERT (a.VALEUR)
VALUES (b.VALEUR);


-- 11. Insertion des correspondances famille libelle dans TA_FAMILLE_LIBELLE;
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
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbaIN (voies prINcipales, voies ferrées, cours d''eau, ...)' OR
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' OR
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' OR
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'Communes non découpées en IRIS'
    ) b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES (b.fid_famille,b.fid_libelle_long);


-- 12. Création de la table temporaire fusion_nomenclature_iris
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


-- 13. Insertion des données dans la table temporaire fusion_nomenclature_iris
INSERT INTO fusion_nomenclature_iris
SELECT
-- Attention à la séquence utilisée
    ISEQ$$_1018816.nextval as objectid,
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


-- 14. insertion du fid_libelle_long 'code IRIS' dans la table TA_LIBELLE
MERGE INTO ta_libelle a
USING 
        (
            SELECT objectid AS fid_libelle_long 
            FROM ta_libelle_long 
            WHERE valeur = 'code IRIS'
        ) b
ON (a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle_long)
VALUES (b.fid_libelle_long);


-- 15. Insertion des données dans ta_libelle
MERGE INTO ta_libelle a
USING
    (
    SELECT
        objectid, 
        fid_libelle_long
    FROM fusion_nomenclature_iris
    ) b
ON (a.objectid = b.objectid
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.objectid,a.fid_libelle_long)
VALUES (b.objectid,b.fid_libelle_long)
;


-- 16. Insertion des données dans ta_correspondance_libelle
MERGE INTO ta_libelle_correspondance a
USING
    (
    SELECT
        objectid AS FID_LIBELLE, 
        fid_libelle_court
    FROM fusion_nomenclature_iris
    ) b
ON (a.fid_libelle = b.fid_libelle
AND a.fid_libelle_court = b.fid_libelle_court)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle,a.fid_libelle_court)
VALUES (b.fid_libelle,b.fid_libelle_court)
;


-- 17. Suppression des tables et des vues utilisés seulement pour l'insertion de la nomenclature.
-- 17. Suppression de la table temporaire fusion_nomenclature_iris
DROP TABLE fusion_nomenclature_iris CASCADE CONSTRAINTS PURGE;