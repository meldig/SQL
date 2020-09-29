/*
Ensemble des requêtes utilisés pour insérer la nomenclature des données IRIS dans la base de données.
*/
SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVERGARDE_NOMENCLATURE_1;

-- 1. Insertion de la source dans G_GEO.TA_SOURCE
MERGE INTO G_GEO.TA_SOURCE a
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


-- 2. Insertion de la provenance de la données dans G_GEO.TA_PROVENANCE
MERGE INTO G_GEO.TA_PROVENANCE a
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


-- 3. Insertion des dates d'acquisition et du millesime de la source dans la table G_GEO.TA_DATE_ACQUISITION
-- attention à l'insertion des dates, à mettre à jour suivant le millesime de la donnée à insérer
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
USING
    (
        SELECT TO_DATE(SYSDATE,'dd/mm/yy') AS DATE_ACQUISITION, TO_DATE('01/01/19') AS MILLESIME, SYS_CONTEXT('USERENV', 'OS_USER') AS NOM_OBTENTEUR FROM DUAL
    ) b
ON (a.date_acquisition = b.date_acquisition
AND a.millesime = b.millesime
AND a.nom_obtenteur = b.nom_obtenteur)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition,a.millesime, a.nom_obtenteur)
VALUES (b.date_acquisition, b.millesime, b.nom_obtenteur)
;


-- 4. Insertion de l'organisme producteur dans la table G_GEO.TA_ORGANISME
MERGE INTO G_GEO.TA_ORGANISME a
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

-- 5. Insertion de l'echelle d'utilisation dans la table G_GEO.TA_ECHELLE
MERGE INTO G_GEO.TA_ECHELLE a
USING
    (
        SELECT '1000000' AS VALEUR FROM DUAL
    )b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES(b.valeur)
;


-- 6. Insertion des métadonnées dans la table G_GEO.TA_METADONNEE
-- attention à l'insertion des dates, à mettre à jour suivant le millesime de la donnée à insérer
MERGE INTO G_GEO.TA_METADONNEE a
USING
    (
        SELECT 
            a.objectid AS FID_SOURCE,
            b.objectid AS FID_ACQUISITION,
            c.objectid AS FID_PROVENANCE
        FROM
            G_GEO.TA_SOURCE a,
            G_GEO.TA_DATE_ACQUISITION b,
            G_GEO.TA_PROVENANCE c
        WHERE
            a.nom_source = 'Contours...IRIS'
        AND
            b.millesime IN ('01/01/2019')
        AND
            b.date_acquisition = TO_DATE(SYSDATE,'dd/mm/yy')
        AND
            b.nom_obtenteur = SYS_CONTEXT('USERENV', 'OS_USER')
        AND
            c.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris'
    )temp
ON (a.fid_source = temp.fid_source
AND a.fid_acquisition = temp.fid_acquisition
AND a.fid_provenance = temp.fid_provenance)
WHEN NOT MATCHED THEN
INSERT (a.fid_source, a.fid_acquisition, a.fid_provenance)
VALUES (temp.fid_source, temp.fid_acquisition, temp.fid_provenance)
;

-- 7. Insertion des information dans la table G_GEO.TA_METADONNEE_RELATION_ORGANISME
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
USING
    (
        SELECT
            a.objectid AS fid_metadonnee,
            e.objectid AS fid_organisme
        FROM
            G_GEO.TA_METADONNEE a
        INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
        INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
        INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid,
            G_GEO.TA_ORGANISME e
        WHERE
            b.nom_source = 'Contours...IRIS'
        AND
            c.date_acquisition = TO_DATE(SYSDATE,'dd/mm/yy')
        AND
            c.millesime = '01/01/2019'
        AND
            d.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris'
        AND
            e.nom_organisme IN ('Institut National de l''Information Geographie et Forestiere','Institut National de la statistique et des études économiques')
    )b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_organisme = b.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(b.fid_metadonnee, b.fid_organisme)
;


-- 8. Insertion des données dans la table G_GEO.TA_METADONNEE_RELATION_ECHELLE
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ECHELLE a
USING
    (
        SELECT
            a.objectid AS fid_metadonnee,
            g.objectid AS fid_echelle
        FROM
            G_GEO.TA_METADONNEE a
        INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
        INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
        INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid
        INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME e ON e.fid_metadonnee = a.objectid
        INNER JOIN G_GEO.TA_ORGANISME f ON f.objectid = e.fid_organisme,
            G_GEO.TA_ECHELLE g
        WHERE
            b.nom_source = 'Contours...IRIS'
        AND
            c.date_acquisition = TO_DATE(SYSDATE,'dd/mm/yy')
        AND
            c.millesime = '01/01/2019'
        AND
            d.url = 'https://geoservices.ign.fr/documentation/diffusion/telechargement-donnees-libres.html#contoursiris'
        AND
            f.nom_organisme IN ('Institut National de l''Information Geographie et Forestiere','Institut National de la statistique et des études économiques')
        AND
            g.valeur IN ('1000000')
    )b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_echelle = b.fid_echelle)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_echelle)
VALUES(b.fid_metadonnee, b.fid_echelle)
;

-- 9. Insertion de la nomenclature dans la table G_GEO.TA_LIBELLE_COURT
MERGE INTO G_GEO.TA_LIBELLE_COURT a
USING 
    (
    SELECT DISTINCT TYP_IRIS AS VALEUR FROM contours_iris
    ) b
ON (a.VALEUR = b.VALEUR)
WHEN NOT MATCHED THEN
INSERT (a.VALEUR)
VALUES (b.VALEUR)
;


-- 10. Insertion de la nomenclature dans la table G_GEO.TA_LIBELLE LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
USING 
    (
    SELECT 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbain (voies principales, voies ferrées, cours d''eau, ...)' AS VALEUR FROM dual
    UNION
    SELECT 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moins deux fois plus d''emplois salariés que de population résidente' AS VALEUR FROM dual
    UNION
    SELECT 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' AS VALEUR FROM dual
    UNION
    SELECT 'Communes non découpées en IRIS' AS VALEUR FROM dual
    UNION
    SELECT 'code iris' AS VALEUR FROM dual
    ) b
  ON (a.VALEUR = b.VALEUR)
  WHEN NOT MATCHED THEN
  INSERT (a.VALEUR)
  VALUES (b.VALEUR)
  ;


-- 11. Insertion des familles utilisée par les données IRIS dans la table G_GEO.TA_FAMILLE.
MERGE INTO G_GEO.TA_FAMILLE a
USING 
    (
    SELECT 'type de zone IRIS' AS VALEUR FROM dual
    UNION
    SELECT 'identifiants de zone statistique' AS VALEUR FROM dual
    ) b
ON (a.VALEUR = b.VALEUR)
WHEN NOT MATCHED THEN
INSERT (a.VALEUR)
VALUES (b.VALEUR);


-- 12. Insertion des correspondances famille libelle dans G_GEO.TA_FAMILLE_LIBELLE;
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING 
    (
    SELECT
        a.objectid AS fid_famille,
        b.objectid AS fid_libelle_long
    FROM
        G_GEO.TA_FAMILLE a,
        G_GEO.TA_LIBELLE_LONG b
    WHERE
        a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbain (voies principales, voies ferrées, cours d''eau, ...)'
        OR a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....'
        OR a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente'
        OR a.VALEUR = 'type de zone IRIS' AND b.VALEUR = 'Communes non découpées en IRIS'
        OR a.VALEUR = 'Identifiants de zone statistique' AND b.VALEUR = 'code iris'
    ) b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES (b.fid_famille,b.fid_libelle_long);


-- 13. Insertion des fid_libelle_long dans la table G_GEO.TA_LIBELLE
MERGE INTO G_GEO.TA_LIBELLE a
USING
    (
    SELECT
        a.objectid AS fid_libelle_long,
        a.VALEUR AS libelle_long
    FROM
        G_GEO.TA_LIBELLE_LONG a
    INNER JOIN G_GEO.TA_FAMILLE_LIBELLE b ON b.fid_libelle_long = a.objectid
    INNER JOIN G_GEO.TA_FAMILLE c ON c.objectid = b.fid_famille
    WHERE
        c.VALEUR = 'type de zone IRIS'
    OR c.VALEUR = 'identifiants de zone statistique'
    )b
ON(a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle_long)
VALUES (b.fid_libelle_long);


-- 14. Insertion des données dans la table G_GEO.TA_LIBELLE_CORRESPONDANCE
MERGE INTO G_GEO.TA_LIBELLE_CORRESPONDANCE a
USING 
    (
        SELECT
            a.objectid AS fid_libelle,
            b.objectid AS fid_libelle_court
        FROM
            G_GEO.TA_LIBELLE_COURT b,        
            G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = a.fid_libelle_long
        INNER JOIN G_GEO.TA_FAMILLE_LIBELLE d ON d.fid_libelle_long = c.objectid
        INNER JOIN G_GEO.TA_FAMILLE e ON e.objectid = d.fid_famille
        WHERE
            b.VALEUR = 'H' AND c.VALEUR = 'IRIS d''habitat:  leur population se situe en général entre 1 800 et 5 000 habitants. Ils sont homogènes quant au type d''habitat et leurs limites s''appuient sur les grandes coupures du tissu urbain (voies principales, voies ferrées, cours d''eau, ...)' OR
            b.VALEUR = 'D' AND c.VALEUR = 'IRIS divers: il s''agit de grandes zones spécifiques peu habitées et ayant une superficie importante (parcs de loisirs, zones portuaires, forêts, ....' OR
            b.VALEUR = 'A' AND c.VALEUR = 'IRIS d''activité: ils regroupent environ 1 000 salariés et comptent au moINs deux fois plus d''emplois salariés que de population résidente' OR
            b.VALEUR = 'Z' AND c.VALEUR = 'Communes non découpées en IRIS' AND
            e.VALEUR = 'type de zone IRIS'
    )b
ON(a.fid_libelle = b.fid_libelle
AND a.fid_libelle_court = b.fid_libelle_court)
WHEN NOT MATCHED THEN
INSERT(a.fid_libelle, a.fid_libelle_court)
VALUES(b.fid_libelle, b.fid_libelle_court);

COMMIT;
-- 15. En cas d'exeption levée, faire un ROLLBACK
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('une erreur est survenue, un rollback va être effectué: ' || SQLCODE || ' : '  || SQLERRM(SQLCODE));
    ROLLBACK TO POINT_SAUVERGARDE_NOMENCLATURE_1;
END;
/