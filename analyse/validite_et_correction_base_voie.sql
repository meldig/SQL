/*
Vérification de l'invalidité de la géométrie de chaque objet de la Base Voie (avec une tolérance = 1mm ) :
*/

SELECT 
    COUNT(a.OBJECTID)
FROM 
    LM_VOIE a;


SELECT 
    a.OBJECTID,
    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.GEOM, 0.001)
FROM 
    GEO.LM_VOIE a
WHERE 
    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.GEOM, 0.001) <> 'TRUE'
;

-- Décompte des mauvaises connexion entre lignes :

SELECT
    COUNT(
        SDO_LRS.CONNECTED_GEOM_SEGMENTS(
            SDO_LRS.CONVERT_TO_LRS_GEOM(a.geom),
            SDO_LRS.CONVERT_TO_LRS_GEOM(b.geom),
            0.005
        )
    )/2 AS connecte
FROM
    GEO.LM_VOIE a,
    GEO.LM_VOIE b
WHERE 
    a.objectid <> b.objectid
    AND SDO_WITHIN_DISTANCE(
        b.geom, 
        a.geom, 
        'distance = 0.005'
    ) = 'TRUE'
    AND SDO_LRS.CONNECTED_GEOM_SEGMENTS(
            SDO_LRS.CONVERT_TO_LRS_GEOM(a.geom), 
            SDO_LRS.CONVERT_TO_LRS_GEOM(b.geom),
            0.005
        ) = 'FALSE'
;

/*
Sélection des identifiants des lignes mal connectées :
*/

SELECT
    a.objectid AS ligne_1,
    b.objectid AS ligne_2,
    SDO_LRS.CONNECTED_GEOM_SEGMENTS(
        SDO_LRS.CONVERT_TO_LRS_GEOM(a.geom),
        SDO_LRS.CONVERT_TO_LRS_GEOM(b.geom),
        0.005
    ) AS connecte
FROM
    GEO.LM_VOIE a,
    GEO.LM_VOIE b
WHERE 
    a.objectid <> b.objectid
    AND SDO_WITHIN_DISTANCE(
            b.geom, 
            a.geom, 
            'distance = 0.005'
        ) = 'TRUE'
    AND SDO_LRS.CONNECTED_GEOM_SEGMENTS(
            SDO_LRS.CONVERT_TO_LRS_GEOM(a.geom), 
            SDO_LRS.CONVERT_TO_LRS_GEOM(b.geom), 
            0.005
        ) = 'FALSE'
;
