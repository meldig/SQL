/*
Sélection des objets dépendant des tables de GestionGeo.
La sélection peut se faire directment dans la vue ALL_SEQUENCIES, mais à des fins de lisibilité j'ai préféré diviser les résultats par types d'objet (ce qui permet aussi de faire des sélections plus fines):
*/

-- Sélection des contraintes des tables de GestionGeo
SELECT
    a.TABLE_NAME,
    a.CONSTRAINT_NAME,
    CASE
        WHEN b.CONSTRAINT_TYPE = 'C'
            THEN 'CHECK'
        WHEN b.CONSTRAINT_TYPE = 'P'
            THEN 'PRIMARY KEY'
        WHEN b.CONSTRAINT_TYPE = 'U'
            THEN 'UNIQUE KEY'
        WHEN b.CONSTRAINT_TYPE = 'R'
            THEN 'REFERENTIAL INTEGRITY'
        WHEN b.CONSTRAINT_TYPE = 'V'
            THEN 'WITH CHECK OPTION ON A VIEW'
        WHEN b.CONSTRAINT_TYPE = 'O'
            THEN 'WITH READ ONLY ON A VIEW'
        WHEN b.CONSTRAINT_TYPE = 'F'
            THEN 'FOREIGN KEY'
    END AS CONSTRAINT_TYPE,
    b.SEARCH_CONDITION,
    c.TABLE_NAME AS TABLE_REFERENCE,
    b.STATUS,
    b.VALIDATED,
    b.INDEX_OWNER,
    b.INDEX_NAME
FROM
    ALL_CONS_COLUMNS a
    INNER JOIN ALL_CONSTRAINTS b ON b.CONSTRAINT_NAME = a.CONSTRAINT_NAME
    LEFT JOIN ALL_CONS_COLUMNS c on c.CONSTRAINT_NAME = b.R_CONSTRAINT_NAME
WHERE
    b.owner = 'GEO'
    AND b.TABLE_NAME IN(
        'TA_SUR_TOPO_G',
        'TA_POINT_TOPO_G',
        'TA_LIG_TOPO_G',
        'TA_GG_APP_ADM_RIGHTS',
        'TA_GG_DOC',
        'TA_GG_DOSSIER',
        'TA_DOSSIER_GPS',
        'TA_GG_ETAT',
        'TA_GG_EXTERIEUR',
        'TA_GG_FAMILLE',
        'TA_GG_FILES',
        'TA_GG_FORMAT',
        'TA_GG_GEO',
        'TA_GG_MEDIA',
        'TA_GG_POINT',
        'TA_GG_SOURCE',
        'TA_LIG_TOPO_GPS',
        'TA_POINT_TOPO_GPS',
        'TA_LIG_TOPO_F',
        'TA_POINT_TOPO_F',
        'TA_LIG_TOPO_IC',
        'TA_POINT_TOPO_IC',
        'TA_LIG_TOPO_IC_2D',
        'TA_PIQUAGE_GPS',
        'PTTOPO'
    )
ORDER BY
    a.TABLE_NAME;

-- Sélection de tous les triggers portant sur les tables GestionGeo
SELECT
    a.TABLE_NAME,
    a.TRIGGER_NAME,
    a.TRIGGER_TYPE,
    a.TRIGGERING_EVENT,
    a.OWNER,
    a.STATUS
FROM
    ALL_TRIGGERS a
WHERE
    a.OWNER = 'GEO'
    AND a.TABLE_NAME IN(
        'TA_SUR_TOPO_G',
        'TA_POINT_TOPO_G',
        'TA_LIG_TOPO_G',
        'TA_GG_APP_ADM_RIGHTS',
        'TA_GG_DOC',
        'TA_GG_DOSSIER',
        'TA_DOSSIER_GPS',
        'TA_GG_ETAT',
        'TA_GG_EXTERIEUR',
        'TA_GG_FAMILLE',
        'TA_GG_FILES',
        'TA_GG_FORMAT',
        'TA_GG_GEO',
        'TA_GG_MEDIA',
        'TA_GG_POINT',
        'TA_GG_SOURCE',
        'TA_LIG_TOPO_GPS',
        'TA_POINT_TOPO_GPS',
        'TA_LIG_TOPO_F',
        'TA_POINT_TOPO_F',
        'TA_LIG_TOPO_IC',
        'TA_POINT_TOPO_IC',
        'TA_LIG_TOPO_IC_2D',
        'TA_PIQUAGE_GPS',
        'PTTOPO'
    );

-- Sélection des vues dépendantes des tables Gestiongeo 
SELECT
    REFERENCED_NAME,
    NAME,
    OWNER
FROM
    ALL_DEPENDENCIES
WHERE
    TYPE = 'VIEW'
    AND REFERENCED_OWNER = 'GEO'
    AND REFERENCED_TYPE = 'TABLE'
    AND REFERENCED_NAME IN(
        'TA_SUR_TOPO_G',
        'TA_POINT_TOPO_G',
        'TA_LIG_TOPO_G',
        'TA_GG_APP_ADM_RIGHTS',
        'TA_GG_DOC',
        'TA_GG_DOSSIER',
        'TA_DOSSIER_GPS',
        'TA_GG_ETAT',
        'TA_GG_EXTERIEUR',
        'TA_GG_FAMILLE',
        'TA_GG_FILES',
        'TA_GG_FORMAT',
        'TA_GG_GEO',
        'TA_GG_MEDIA',
        'TA_GG_POINT',
        'TA_GG_SOURCE',
        'TA_LIG_TOPO_GPS',
        'TA_POINT_TOPO_GPS',
        'TA_LIG_TOPO_F',
        'TA_POINT_TOPO_F',
        'TA_LIG_TOPO_IC',
        'TA_POINT_TOPO_IC',
        'TA_LIG_TOPO_IC_2D',
        'TA_PIQUAGE_GPS',
        'PTTOPO'
    );

-- Sélection de toutes les fonctions des tables de gestiongeo    
SELECT
    OWNER,
    NAME,
    REFERENCED_NAME,
    REFERENCED_OWNER
FROM 
    ALL_DEPENDENCIES
WHERE
    TYPE = 'FUNCTION'
    AND REFERENCED_OWNER= 'GEO'
    AND REFERENCED_TYPE = 'TABLE'
    AND REFERENCED_NAME IN(
        'TA_SUR_TOPO_G',
        'TA_POINT_TOPO_G',
        'TA_LIG_TOPO_G',
        'TA_GG_APP_ADM_RIGHTS',
        'TA_GG_DOC',
        'TA_GG_DOSSIER',
        'TA_DOSSIER_GPS',
        'TA_GG_ETAT',
        'TA_GG_EXTERIEUR',
        'TA_GG_FAMILLE',
        'TA_GG_FILES',
        'TA_GG_FORMAT',
        'TA_GG_GEO',
        'TA_GG_MEDIA',
        'TA_GG_POINT',
        'TA_GG_SOURCE',
        'TA_LIG_TOPO_GPS',
        'TA_POINT_TOPO_GPS',
        'TA_LIG_TOPO_F',
        'TA_POINT_TOPO_F',
        'TA_LIG_TOPO_IC',
        'TA_POINT_TOPO_IC',
        'TA_LIG_TOPO_IC_2D',
        'TA_PIQUAGE_GPS',
        'PTTOPO'
    );