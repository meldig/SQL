/*
Etat des lieux des tables utilisées dans GestionGeo.
*/

-- Requête permettant de connaître les types de géométries par table (et leur nombre par GEO_ON_VALIDE), avec le nom de leur index, son tablespace, son statut et ses paramètres
CREATE OR REPLACE FORCE VIEW geo.v_bilan_geom_gestion_geo(
    OBJECTID,
    OWNER,
    TABLE_NAME,
    TYPE_GEOMETRIE,
    NB_OBJETS,
    GEO_ON_VALIDE,
    INDEX_NAME,
    INDEX_TABLESPACE,
    STATUS,
    PARAMETRES_INDEX,
    CONSTRAINT "V_BILAN_GEOM_GESTION_GEO_PK" PRIMARY KEY(OBJECTID) DISABLE
)
AS
WITH C_1 AS(
SELECT
    a.owner,
    a.table_name,
    c.geom.sdo_gtype AS Type_geometrie,
    COUNT(c.objectid) AS nb_objets,
    c.geo_on_valide,
    b.index_name,
    b.tablespace_name AS index_tablespace,
    b.status,
    b.parameters AS parametres_index
FROM
    ALL_TABLES a
    INNER JOIN ALL_INDEXES b ON b.TABLE_NAME = a.TABLE_NAME,
    GEO.TA_SUR_TOPO_G c
WHERE
    a.owner = 'GEO'
    AND a.TABLE_NAME = 'TA_SUR_TOPO_G'
    AND b.ITYP_NAME = 'SPATIAL_INDEX'
GROUP BY 
    c.geom.sdo_gtype,
    a.owner,
    a.table_name,
    b.index_name,
    b.status,
    c.geo_on_valide,
    b.parameters,
    b.tablespace_name
UNION ALL
SELECT
    a.owner,
    a.table_name,
    c.geom.sdo_gtype AS Type_geometrie,
    COUNT(c.objectid) AS nb_objets,
    c.geo_on_valide,
    b.index_name,
    b.tablespace_name AS index_tablespace,
    b.status,
    b.parameters AS parametres_index
FROM
    ALL_TABLES a
    INNER JOIN ALL_INDEXES b ON b.TABLE_NAME = a.TABLE_NAME,
    GEO.TA_LIG_TOPO_G c
WHERE
    a.owner = 'GEO'
    AND a.TABLE_NAME = 'TA_LIG_TOPO_G'
    AND b.ITYP_NAME = 'SPATIAL_INDEX'
GROUP BY 
    c.geom.sdo_gtype,
    a.owner,
    a.table_name,
    b.index_name,
    b.status,
    c.geo_on_valide,
    b.parameters,
    b.tablespace_name
UNION ALL
SELECT
    a.owner,
    a.table_name,
    c.geom.sdo_gtype AS Type_geometrie,
    COUNT(c.objectid) AS nb_objets,
    c.geo_on_valide,
    b.index_name,
    b.tablespace_name AS index_tablespace,
    b.status,
    b.parameters AS parametres_index
FROM
    ALL_TABLES a
    INNER JOIN ALL_INDEXES b ON b.TABLE_NAME = a.TABLE_NAME,
    GEO.TA_POINT_TOPO_G c
WHERE
    a.owner = 'GEO'
    AND a.TABLE_NAME = 'TA_POINT_TOPO_G'
    AND b.ITYP_NAME = 'SPATIAL_INDEX'
GROUP BY 
    c.geom.sdo_gtype,
    a.owner,
    a.table_name,
    b.index_name,
    b.status,
    c.geo_on_valide,
    b.parameters,
    b.tablespace_name
)
SELECT
    ROWNUM AS OBJECTID,
    OWNER,
    TABLE_NAME,
    TYPE_GEOMETRIE,
    NB_OBJETS,
    GEO_ON_VALIDE,
    INDEX_NAME,
    INDEX_TABLESPACE,
    STATUS,
    PARAMETRES_INDEX
FROM
    C_1
ORDER BY
    TABLE_NAME,
    Type_geometrie,
    nb_objets;