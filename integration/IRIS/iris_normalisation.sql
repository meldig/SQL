-- Requêtes SQL nécessaire pour normaliser les données IRIS

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
            WHERE c.valeur = 'code iris'
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
            j.objectid AS fid_metadonnee,
            k.objectid AS fid_iris_geom
        FROM
            G_GEO.CONTOURS_IRIS a
            INNER JOIN G_GEO.TA_LIBELLE_COURT b ON b.valeur = a.typ_iris    
            INNER JOIN G_GEO.TA_LIBELLE_CORRESPONDANCE c ON b.objectid = c.fid_libelle_court
            INNER JOIN G_GEO.TA_LIBELLE d ON c.fid_libelle = d.objectid
            INNER JOIN G_GEO.TA_LIBELLE_LONG e ON d.fid_libelle_long = e.objectid
            INNER JOIN G_GEO.TA_FAMILLE_LIBELLE f ON e.objectid = f.fid_libelle_long
            INNER JOIN G_GEO.TA_FAMILLE g ON f.fid_famille = g.objectid
            INNER JOIN G_GEO.TA_CODE h ON a.iris = h.valeur
            INNER JOIN G_GEO.TA_NOM i ON a.nom_iris = i.valeur,
            G_GEO.TA_METADONNEE j,
            G_GEO.TA_IRIS_GEOM k
        -- sous requete dans le WHERE pour être sur d'avoir des clé étrangé fid_code qui correspondent à des code iris
        WHERE
            g.valeur = 'type de zone IRIS'
        -- sous requete AND pour insérer le fid_métadonnee au millesime le plus récent pour la donnée considérée
        AND 
            j.objectid IN
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
            ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(a.ora_geometry)))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(k.geom))))
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
DROP TABLE G_GEO.CONTOURS_IRIS CASCADE CONSTRAINTS