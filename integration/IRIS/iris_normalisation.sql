-- Requêtes SQL nécessaire pour normaliser les données IRIS
SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVERGARDE_NORMALISATION_1;

-- 1. Suppression des IRIS qui ne sont pas présents dans les Hauts-de-France
DELETE FROM G_GEO.CONTOURS_IRIS WHERE SUBSTR(INSEE_COM,1,2) NOT IN ('02','59','60','62','80');

-- 2. Insertion des noms IRIS dans G_GEO.TA_NOM
MERGE INTO G_GEO.TA_NOM a
USING 
        (
        SELECT DISTINCT(NOM_IRIS) AS VALEUR FROM G_GEO.CONTOURS_IRIS
        ) b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur);


-- 3. Insertion des codes IRIS G_GEO.TA_CODE
MERGE INTO G_GEO.TA_CODE a
USING 
        (
            SELECT
-- IRIS: code à 4 chiffres
                DISTINCT(a.iris) AS valeur,
                b.objectid AS fid_libelle
            FROM 
                G_GEO.CONTOURS_IRIS a,
                G_GEO.TA_LIBELLE b
            INNER JOIN G_GEO.TA_LIBELLE_LONG c ON b.fid_libelle_long = c.objectid
            INNER JOIN G_GEO.TA_FAMILLE_LIBELLE d ON d.fid_libelle_long = c.objectid
            INNER JOIN G_GEO.TA_FAMILLE e ON e.objectid = d.fid_famille
            WHERE
                c.valeur = 'code iris'
            AND e.valeur = 'identifiants de zone statistique'
        ) b
ON (a.valeur = b.valeur
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN
INSERT (a.valeur,a.fid_libelle)
VALUES (b.valeur,b.fid_libelle);


-- 4. Insertion des géométrie des IRIS dans G_GEO.TA_IRIS_GEOM
INSERT INTO G_GEO.TA_IRIS_GEOM(geom)
SELECT
    ora_geometry
FROM
    G_GEO.CONTOURS_IRIS
-- Sous requete dans le WHERE pour n'insérer que les nouvelles géométrie pas encore présente dans la table
WHERE
    code_iris not IN
        (
        SELECT
            a.code_iris
        FROM
            G_GEO.CONTOURS_IRIS a,
            G_GEO.TA_IRIS_GEOM b
        WHERE
            ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(a.ora_geometry)))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(b.geom))))
        )
;


-- 5. Insertion des données IRIS dans G_GEO.TA_IRIS
MERGE INTO G_GEO.TA_IRIS a
USING 
    (
SELECT
            d.objectid AS fid_lib_type,
            h.objectid AS fid_code,
            i.objectid AS fid_nom,
            n.objectid AS fid_metadonnee,
            o.objectid AS fid_iris_geom
        FROM
            G_GEO.CONTOURS_IRIS a
            INNER JOIN G_GEO.TA_LIBELLE_COURT b ON b.valeur = a.typ_iris    
            INNER JOIN G_GEO.TA_LIBELLE_CORRESPONDANCE c ON c.fid_libelle_court = b.objectid
            INNER JOIN G_GEO.TA_LIBELLE d ON d.objectid = c.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = d.fid_libelle_long
            INNER JOIN G_GEO.TA_FAMILLE_LIBELLE f ON f.fid_libelle_long = e.objectid
            INNER JOIN G_GEO.TA_FAMILLE g ON g.objectid = f.fid_famille
            INNER JOIN G_GEO.TA_CODE h ON h.valeur = a.iris
            INNER JOIN G_GEO.TA_NOM i ON i.valeur = a.nom_iris
            INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = h.fid_libelle
            INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
            INNER JOIN G_GEO.TA_FAMILLE_LIBELLE l ON l.fid_libelle_long = k.objectid
            INNER JOIN G_GEO.TA_FAMILLE m ON m.objectid = l.fid_famille,
            G_GEO.TA_METADONNEE n,
            G_GEO.TA_IRIS_GEOM o
        -- sous requete dans le WHERE pour être sur d'avoir des clés étrangéres fid_libelle qui correspondent à des types de zone IRIS
        WHERE
            g.valeur = 'type de zone IRIS'
        -- AND pour être sur d'avoir des clés étrangéres fid_code qui correspondent à des identifiants de zone statistique
        AND
            m.valeur = 'identifiants de zone statistique'
        -- sous requete AND pour insérer le fid_métadonnee au millesime le plus récent pour la donnée considérée
        AND 
            n.objectid IN
                (
                SELECT
                    a.objectid AS id_mtd
                FROM
                    ta_metadonnee a
                    INNER JOIN ta_source b ON a.fid_source = b.objectid
                    INNER JOIN ta_date_acquisition c ON c.objectid = a.fid_acquisition
                WHERE
                    c.millesime IN(
                                SELECT
                                    MAX(b.millesime) as MILLESIME
                                FROM
                                    ta_metadonnee a
                                INNER JOIN ta_date_acquisition  b ON a.fid_acquisition = b.objectid 
                                INNER JOIN ta_source c ON c.objectid = a.fid_source
                                WHERE c.nom_source = 'Contours...IRIS'
                                )
                AND
                    b.nom_source = 'Contours...IRIS'
                )
        -- sous requete AND pour insérer le fid_iris_geom de la bonne géométrie de l'IRIS.
        AND
            ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(a.ora_geometry)))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(o.geom))))
    )b
ON (a.fid_lib_type = b.fid_lib_type
AND a.fid_code = b.fid_code
AND a.fid_nom = b.fid_nom
AND a.fid_metadonnee = b.fid_metadonnee
AND a.fid_iris_geom = b.fid_iris_geom )
WHEN NOT MATCHED THEN
INSERT (a.fid_lib_type,a.fid_code,a.fid_nom,a.fid_metadonnee,a.fid_iris_geom)
VALUES (b.fid_lib_type,b.fid_code,b.fid_nom,b.fid_metadonnee,b.fid_iris_geom)
;

-- 6. Suppression de la table d'import des IRIS
-- 6.1. Suppression de la table d'import des IRIS
-- DROP TABLE G_GEO.CONTOURS_IRIS CASCADE CONSTRAINTS;
-- 6.2. Suppression des métadonnee de la table G_GEO.CONTOURS_IRIS CASCADE CONSTRAINTS
-- DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'CONTOURS_IRIS';

COMMIT;
-- 7. En cas d'exeption levée, faire un ROLLBACK
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('une erreur est survenue, un rollback va être effectué: ' || SQLCODE || ' : '  || SQLERRM(SQLCODE));
    ROLLBACK TO POINT_SAUVERGARDE_NORMALISATION_1;
END;
/