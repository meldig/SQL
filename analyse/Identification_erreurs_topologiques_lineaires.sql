/*
Cette requête permet de savoir si certaines lignes simples sont concernées par des erreurs topologiques ou non.
Précision : ces requêtes fonctionnent avec des géométries de type SDO_GEOMETRY et non SDO_TOPO_GEOMETRY, autrement dit elles n'utilisent pas les primitives topologiques.
*/

 -- Sélection des lignes mal connectées (c-a-dire suffisament proches pour être censées être connectées)
    SELECT
        a.objectid AS ligne_1,
        b.objectid AS ligne_2,
        'mal connectées' AS ETAT
    FROM
       G_GEO.TEMP_LIGNE a,
       G_GEO.TEMP_LIGNE b
    WHERE 
        a.objectid < b.objectid
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
        AND SDO_RELATE(a.geom, b.geom, 'mask=OVERLAPBDYDISJOINT') <> 'TRUE'
    UNION ALL
 -- Sélection des lignes bien connectées
    SELECT
        a.objectid AS ligne_1,
        b.objectid AS ligne_2,
        'connectées' AS ETAT
    FROM
       G_GEO.TEMP_LIGNE a,
       G_GEO.TEMP_LIGNE b
    WHERE 
        a.objectid < b.objectid
        AND SDO_WITHIN_DISTANCE(
            b.geom, 
            a.geom, 
            'distance = 0.005'
        ) = 'TRUE'
        AND SDO_LRS.CONNECTED_GEOM_SEGMENTS(
                SDO_LRS.CONVERT_TO_LRS_GEOM(a.geom), 
                SDO_LRS.CONVERT_TO_LRS_GEOM(b.geom),
                0.005
            ) = 'TRUE'
        AND SDO_RELATE(a.geom, b.geom, 'mask=EQUAL') <> 'TRUE'
    UNION ALL
-- Sélection des doublons géométriques
        SELECT 
            a.objectid ligne_1, 
            b.objectid ligne_2,
            'doublons géométriques' AS ETAT
        FROM
            G_GEO.TEMP_LIGNE a,
            G_GEO.TEMP_LIGNE b
        WHERE
            a.objectid < b.objectid
            AND SDO_RELATE(a.geom, b.geom, 'mask=EQUAL') = 'TRUE'  
    UNION ALL
 -- Sélection des mauvaises intersections (hors start/endpoint)
        SELECT 
            a.objectid ligne_1, 
            b.objectid ligne_2,
            'intersection hors start/end point' AS ETAT
        FROM
            G_GEO.TEMP_LIGNE a,
            G_GEO.TEMP_LIGNE b
        WHERE
            a.objectid < b.objectid
            AND SDO_RELATE(a.geom, b.geom, 'mask=OVERLAPBDYDISJOINT') = 'TRUE';