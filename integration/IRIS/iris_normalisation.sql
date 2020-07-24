-- Requêtes SQL nécessaire pour normaliser les données IRIS

-- 1. Insertion des noms IRIS dans TA_NOM
MERGE INTO ta_nom a
USING 
        (
        SELECT distinct(NOM_IRIS) AS VALEUR FROM contours_iris
        ) b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur);


-- 2. Insertion des codes IRIS TA_CODE
MERGE INTO ta_code a
USING 
        (
            SELECT
-- IRIS: code à 4 chiffres
                distinct(a.iris) AS valeur,
                b.objectid AS fid_libelle
            FROM 
                contours_iris a,
                ta_libelle b
            INNER JOIN ta_libelle_long c ON b.fid_libelle_long = c.objectid
            WHERE c.valeur = 'code IRIS'
        ) b
ON (a.valeur = b.valeur
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN
INSERT (a.valeur,a.fid_libelle)
VALUES (b.valeur,b.fid_libelle);


-- 3. Insertion des codes insee TA_CODE
MERGE INTO ta_code a
USING
    (
        SELECT
            distinct(a.insee_com) as valeur,
            b.objectid as fid_libelle
        FROM
            contours_iris a,
            ta_libelle b
        INNER JOIN
            ta_libelle_long ll ON ll.objectid = b.fid_libelle_long
        WHERE
            ll.valeur = 'code insee'
    )b
ON(a.valeur = b.valeur
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN
INSERT(a.valeur,a.fid_libelle)
VALUES(b.valeur,b.fid_libelle)


-- 4. Insertion des géométrie des IRIS dans TA_IRIS_GEOM
INSERT INTO ta_iris_geom(geom)
SELECT
    ora_geometry
FROM
    contours_iris
-- Sous requete dans le WHERE pour n'insérer que les nouvelles géométrie pas encore présente dans la table
WHERE
    code_iris not IN
        (
        SELECT
            a.code_iris
        FROM
            contours_iris a,
            ta_iris_geom b
        WHERE
            ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(a.ora_geometry)))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(b.geom))))
        )
;


-- 5. Insertion des données IRIS dans TA_IRIS
MERGE INTO ta_iris a
USING 
    (
        SELECT
            d.objectid AS fid_lib_type,
            h.objectid AS fid_code,
            i.objectid AS fid_nom,
            j.objectid AS fid_metadonnee,
            k.objectid AS fid_iris_geom
        FROM
            contours_iris a
            INNER JOIN ta_libelle_court b ON b.valeur = a.typ_iris    
            INNER JOIN ta_libelle_correspondance c ON b.objectid = c.fid_libelle_court
            INNER JOIN ta_libelle d ON c.fid_libelle = d.objectid
            INNER JOIN ta_libelle_long e ON d.fid_libelle_long = e.objectid
            INNER JOIN ta_famille_libelle f ON e.objectid = f.fid_libelle_long
            INNER JOIN ta_famille g ON f.fid_famille = g.objectid
            INNER JOIN ta_code h ON a.iris = h.valeur
            INNER JOIN ta_nom i ON a.nom_iris = i.valeur,
            ta_metadonnee j,
            ta_iris_geom k
        -- sous requete dans le WHERE pour être sur d'avoir des clé étrangé fid_code qui correspondent à des code IRIS
        WHERE
            g.valeur = 'type de zone IRIS'
        -- sous requete AND pour insérer le fid_métadonnee au millesime le plus récent pour la donnée considérée
        AND 
            j.objectid IN
                (
                SELECT
                    metadonnee_objectid
                FROM
                    (
                    SELECT
                        max(a.objectid) AS metadonnee_objectid,
                        max(c.nom_source) AS source,
                        max(b.millesime) AS millesime,
                        max(d.url) AS url,
                        max(f.acronyme)AS acronyme
                    FROM
                        ta_metadonnee a
                        INNER JOIN ta_date_acquisition b ON a.fid_acquisition = b.objectid
                        INNER JOIN ta_source c ON a.fid_source = c.objectid
                        INNER JOIN ta_provenance d ON a.fid_provenance = d.objectid
                        INNER JOIN ta_metadonnee_relation_organisme e ON a.objectid = e.fid_metadonnee
                        INNER JOIN ta_organisme f ON e.fid_organisme = f.objectid
                    WHERE
                        c.nom_source = 'Contours...IRIS'
                    )
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
DROP TABLE contours_iris CASCADE CONSTRAINTS