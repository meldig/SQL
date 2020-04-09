-- normalisation des données IRIS

-- 1. Insertion des noms IRIS dans TA_NOM

MERGE INTO ta_nom n
USING 
        (
        SELECT distinct(NOM_IRIS) FROM contours_iris
        ) temp
ON (temp.NOM_IRIS = n.nom)
WHEN NOT MATCHED THEN
INSERT (n.nom)
VALUES (temp.NOM_IRIS);


-- 2. Insertion des codes IRIS TA_CODE

MERGE INTO ta_code c
USING 
        (
        SELECT
            distINct(i.CODE_IRIS),
            l.objectid
        FROM 
            contours_iris i,
            ta_libelle l
        WHERE l.libelle = 'code IRIS'
        ) temp
ON (temp.CODE_IRIS = c.code)
WHEN NOT MATCHED THEN
INSERT (c.code,c.fid_libelle)
VALUES (temp.CODE_IRIS,temp.objectid);


-- 3. Insertion des géométrie des IRIS dans TA_IRIS_GEOM
INSERT INTO ta_iris_geom(geom)
SELECT 
    ora_geometry
FROM
    contours_iris a
-- Sous requete dans le WHERE pour n'insérer que les nouvelles géométrie pas encore présente dans la table
WHERE
    code_iris not IN
        (SELECT
            a.code_iris
        FROM
            contours_iris a,
            ta_iris_geom b
        WHERE
            SDO_RELATE(a.ora_geometry, b.geom,'mask=equal') = 'TRUE')
;


-- 4. Insertion des IRIS dans TA_IRIS
INSERT INTO ta_iris(fid_libelle_court, fid_code, fid_nom, fid_metadonnee, fid_iris_geom)
SELECT
    b.objectid AS fid_libelle,
    g.objectid AS fid_code,
    i.objectid AS fid_nom,
    h.objectid AS fid_metadonnee,
    j.objectid AS geom
FROM
    ta_metadonnee h,
    ta_iris_geom j,
    contours_iris a
    INNER JOIN ta_libelle_court b ON b.libelle_court=a.typ_iris    
    INNER JOIN ta_correspondance_libelle c ON c.fid_libelle_court = b.objectid
    INNER JOIN ta_libelle d ON c.fid_libelle=d.objectid
    INNER JOIN ta_famille_libelle e ON e.fid_libelle = d.objectid
    INNER JOIN ta_famille f ON f.objectid = e.fid_famille
    INNER JOIN ta_code g ON a.code_iris = g.code
    INNER JOIN ta_nom i ON a.nom_iris = i.nom

-- sous requete dans le WHERE pour être sur d'avoir des clé étrangé fid_code qui correspondent à des code IRIS
WHERE
    f.famille = 'type de zone iris'
-- sous requete AND pour insérer le fid_métadonnee au millesime le plus récent pour la donnée considérée
AND 
    h.objectid IN
        (
        SELECT
            metadonnee_objectid
        FROM
            (
            SELECT
                max(a.objectid) AS metadonnee_objectid,
                max(c.nom_source) AS source,
                max(b.millesime) AS millesime,
                max(p.url) AS url,
                max(o.acronyme)AS acronyme
            FROM
                ta_metadonnee a
                INNER JOIN ta_date_acquisition b ON a.fid_acquisition = b.objectid
                INNER JOIN ta_source c ON a.fid_source = c.objectid
                INNER JOIN ta_provenance p ON a.fid_provenance = p.objectid
                INNER JOIN ta_organisme o ON a.fid_organisme = o.objectid
            WHERE
                c.nom_source = ('IRIS')
            )
        )
-- sous requete AND pour insérer le fid_bpe_geom de la bonne géométrie de l'IRIS.
AND
    SDO_RELATE(a.ora_geometry, j.geom,'mask=equal') = 'TRUE'
;