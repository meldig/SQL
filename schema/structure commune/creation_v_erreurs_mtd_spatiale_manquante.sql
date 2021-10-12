CREATE OR REPLACE FORCE VIEW "G_GEO"."V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT" ("IDENTIFIANT", "NOM_SCHEMA", "NOM_OBJET", "TYPE_OBJET", "NOM_COLONNE", "INSERTION_MTD_SPATIALE", "CREATION_INDEX_SPATIAL",
   CONSTRAINT "V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE) AS     
WITH
    C_1 AS( -- Sélection des tables/vues disposant d'un champ géométrique, mais pas de métadonnées spatiales
        SELECT
            user AS nom_schema,
            a.table_name AS nom_objet,
            b.object_type AS type_objet,
            a.column_name AS nom_colonne,
            CASE
                WHEN a.TABLE_NAME NOT IN (SELECT TABLE_NAME FROM USER_SDO_GEOM_METADATA)
                    THEN 'INSERT INTO USER_SDO_GEOM_METADATA(TABLE_NAME,COLUMN_NAME, DIMINFO, SRID)VALUES(''' || a.TABLE_NAME || ''',''' || a.column_name || ''',SDO_DIM_ARRAY(SDO_DIM_ELEMENT(''X'', 594000, 964000, 0.005),SDO_DIM_ELEMENT(''Y'', 6987000, 7165000, 0.005)), 2154);'
            END AS insertion_mtd_spatiale,
            CASE
                WHEN b.object_type = 'VIEW'
                    THEN 'Une vue n''a pas besoin d''index spatial'
                WHEN a.TABLE_NAME NOT IN (SELECT TABLE_NAME FROM USER_SDO_GEOM_METADATA)
                    THEN 'CREATE INDEX ' || a.table_name || '_SIDX ON ' || USER || '.' || a.table_name || '(' || a.column_name || ') INDEXTYPE IS MDSYS.SPATIAL_INDEX PARAMETERS(''sdo_indx_dims=#dimension_type#, layer_gtype=#geometry_type#, tablespace=#user_tablespace#, work_tablespace=DATA_TEMP'');'
            END AS creation_index_spatial
        FROM
            USER_TAB_COLUMNS a
            INNER JOIN USER_OBJECTS b ON b.object_name = a.table_name
        WHERE
            a.data_type = 'SDO_GEOMETRY'
            AND a.TABLE_NAME NOT IN (SELECT TABLE_NAME FROM USER_SDO_GEOM_METADATA)
    ),

    C_2 AS( -- Sélection des vues matérialisées disposant de métadonnées spatiales, mais pas d'index spatial
        SELECT
            user AS nom_schema,
            a.table_name AS nom_objet,
            object_type AS type_objet,
            a.column_name AS nom_colonne,
            'métadonnée spatiale présente en base' AS insertion_mtd_spatiale,
            CASE
                WHEN a.TABLE_NAME NOT IN(SELECT table_name FROM USER_INDEXES WHERE TABLE_OWNER = USER AND INDEX_TYPE = 'DOMAIN')
                    THEN 'CREATE INDEX ' || a.table_name || '_SIDX ON ' || USER || '.' || a.table_name || '(' || a.column_name || ') INDEXTYPE IS MDSYS.SPATIAL_INDEX PARAMETERS(''sdo_indx_dims=#dimension_type#, layer_gtype=#geometry_type#, tablespace=#user_tablespace#, work_tablespace=DATA_TEMP'');'
                ELSE
                    'Index spatial présent en base'
            END AS creation_index_spatial
        FROM
            USER_TAB_COLUMNS a
            INNER JOIN USER_SDO_GEOM_METADATA b ON b.table_name = a.table_name
            INNER JOIN USER_OBJECTS c ON c.object_name = a.table_name
        WHERE
            a.data_type = 'SDO_GEOMETRY'
            AND c.object_type = 'MATERIALIZED VIEW'
            AND a.TABLE_NAME NOT IN(SELECT table_name FROM USER_INDEXES WHERE TABLE_OWNER = USER AND INDEX_TYPE = 'DOMAIN' AND TABLE_TYPE = 'TABLE')
    ),

    C_3 AS( -- Sélection des tables disposant de métadonnées spatiales, mais pas d'index spatial
      SELECT
            user AS nom_schema,
            a.table_name AS nom_objet,
            object_type AS type_objet,
            a.column_name AS nom_colonne,
            'métadonnée spatiale présente en base' AS insertion_mtd_spatiale,
            CASE
                WHEN a.TABLE_NAME NOT IN(SELECT table_name FROM USER_INDEXES WHERE TABLE_OWNER = USER AND INDEX_TYPE = 'DOMAIN')
                    THEN 'CREATE INDEX ' || a.table_name || '_SIDX ON ' || USER || '.' || a.table_name || '(' || a.column_name || ') INDEXTYPE IS MDSYS.SPATIAL_INDEX PARAMETERS(''sdo_indx_dims=#dimension_type#, layer_gtype=#geometry_type#, tablespace=#user_tablespace#, work_tablespace=DATA_TEMP'');'
                ELSE
                    'Index spatial présent en base'
            END AS creation_index_spatial
        FROM
            USER_TAB_COLUMNS a
            INNER JOIN USER_SDO_GEOM_METADATA b ON b.table_name = a.table_name
            INNER JOIN USER_OBJECTS c ON c.object_name = a.table_name
        WHERE
            a.data_type = 'SDO_GEOMETRY'
            AND c.object_type = 'TABLE'
            AND a.table_name NOT IN(SELECT nom_objet FROM C_2)
            AND a.table_name NOT IN(SELECT table_name FROM USER_INDEXES WHERE TABLE_OWNER = USER AND INDEX_TYPE = 'DOMAIN' AND TABLE_TYPE = 'TABLE')

    ),

    C_4 AS( -- Regroupement des résultats de toutes les CTE précédentes
      SELECT
          a.nom_schema,
          a.nom_objet,
          a.type_objet,
          a.nom_colonne,
          a.insertion_mtd_spatiale,
          a.creation_index_spatial
      FROM
          C_1 a
      UNION ALL
      SELECT
          a.nom_schema,
          a.nom_objet,
          a.type_objet,
          a.nom_colonne,
          a.insertion_mtd_spatiale,
          a.creation_index_spatial
      FROM
          C_2 a
      UNION ALL
      SELECT
          a.nom_schema,
          a.nom_objet,
          a.type_objet,
          a.nom_colonne,
          a.insertion_mtd_spatiale,
          a.creation_index_spatial
      FROM
          C_3 a
    )
    
    SELECT
        rownum AS identifiant,
        a.nom_schema,
        a.nom_objet,
        a.type_objet,
        a.nom_colonne,
        a.insertion_mtd_spatiale,
        a.creation_index_spatial
    FROM
        C_4 a;

COMMENT ON COLUMN V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT.IDENTIFIANT IS 'Clé primaire de la vue.';
COMMENT ON COLUMN V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT.NOM_SCHEMA IS 'Nom du schéma propriétaire de (dans lequel se trouve) l''objet.';
COMMENT ON COLUMN V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT.NOM_OBJET IS 'Nom de l''objet n''ayant pas de métadonnées spatiales ou pas d''index spatial.';
COMMENT ON COLUMN V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT.TYPE_OBJET IS 'Type de l''objet : vue, table, vue matérialisée n''ayant pas de métadonnées spatiales ou pas d''index spatial.';
COMMENT ON COLUMN V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT.NOM_COLONNE IS 'Nom du champ géométrique de l''objet n''ayant pas de métadonnées spatiales ou pas d''index spatial.';
COMMENT ON COLUMN V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT.INSERTION_MTD_SPATIALE IS 'Requête d''insertion de la métadonnée spatiale. Précision : la minimum bounding box utilisée a été calculée au plus près du périmètre de la MEL95.';
COMMENT ON COLUMN V_ERREURS_MTD_INDEX_SPATIAL_MANQUANT.CREATION_INDEX_SPATIAL IS 'Requête de création de l''index spatial. ATTENTION : avant de lancer la requête, veuillez spécifier la dimension et le type de géométrie ainsi que le tablespace utilisé.';
