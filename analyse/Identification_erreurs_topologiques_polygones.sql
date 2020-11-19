/*
Cette requête permet de savoir si certains polygones sont concernés par des erreurs topologiques ou non.
Précision : ces requêtes fonctionnent avec des géométries de type SDO_GEOMETRY et non SDO_TOPO_GEOMETRY, autrement dit elles n'utilisent pas les primitives topologiques.
*/

-- Sélection des doublons géométriques
    SELECT 
        a.objectid AS polygone_1, 
        b.objectid AS polygone_2,
        'doublons géométriques' AS ETAT
    FROM
        G_GEO.TEMP_POLYGONE a,
        G_GEO.TEMP_POLYGONE b
    WHERE
        a.objectid < b.objectid
        AND SDO_RELATE(a.geom, b.geom, 'mask=EQUAL') = 'TRUE'
    UNION ALL
-- Sélection des polygones qui devraient être jointifs (c-a-d proches à 5 mm maximum les uns des autres)
    SELECT 
        a.objectid AS polygone_1, 
        b.objectid AS polygone_2,
        'disjoint mais supposé jointif' AS ETAT
    FROM
        G_GEO.TEMP_POLYGONE a,
        G_GEO.TEMP_POLYGONE b
    WHERE
        a.objectid < b.objectid
        AND SDO_WITHIN_DISTANCE(
            b.geom, 
            a.geom, 
            'distance = 1'
        ) = 'TRUE'
        AND SDO_RELATE(a.geom, b.geom, 'mask=DISJOINT') = 'TRUE'
    UNION ALL
-- Sélection des polygones jointifs
    SELECT 
        a.objectid AS polygone_1, 
        b.objectid AS polygone_2,
        'jointif' AS ETAT
    FROM
        G_GEO.TEMP_POLYGONE a,
        G_GEO.TEMP_POLYGONE b
    WHERE
        a.objectid < b.objectid
        AND SDO_WITHIN_DISTANCE(
            b.geom, 
            a.geom, 
            'distance = 0.005'
        ) = 'TRUE'
        AND SDO_RELATE(a.geom, b.geom, 'mask=TOUCH') = 'TRUE'
    UNION ALL
-- Sélection des polygones se superposant en partie
    SELECT 
        a.objectid AS polygone_1, 
        b.objectid AS polygone_2,
        'se superposent' AS ETAT
    FROM
        G_GEO.TEMP_POLYGONE a,
        G_GEO.TEMP_POLYGONE b
    WHERE
        a.objectid < b.objectid
        AND SDO_RELATE(a.geom, b.geom, 'mask=OVERLAPBDYINTERSECT') = 'TRUE'
    UNION ALL
-- Sélection des polygones contenus dans d'autres polygones
    SELECT 
        a.objectid AS polygone_1, 
        b.objectid AS polygone_2,
        'le polygone 1 est contenu dans le polygone 2' AS ETAT
    FROM
        G_GEO.TEMP_POLYGONE a,
        G_GEO.TEMP_POLYGONE b
    WHERE
        a.objectid <> b.objectid
        AND SDO_RELATE(a.geom, b.geom, 'mask=INSIDE') = 'TRUE'
    UNION ALL
-- Sélection des polygones contenus dans d'autres polygones mais avec un contour commun
    SELECT 
        a.objectid AS polygone_1, 
        b.objectid AS polygone_2,
        'le polygone 1 contient le polygone 2 et ils partagent un contour commun' AS ETAT
    FROM
        G_GEO.TEMP_POLYGONE a,
        G_GEO.TEMP_POLYGONE b
    WHERE
        a.objectid <> b.objectid
        AND SDO_RELATE(a.geom, b.geom, 'mask=COVERS') = 'TRUE';