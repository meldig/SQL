/*
Etat des lieux des tables utilisées dans GestionGeo.
*/

-- 1. Vue permettant de connaître les types de géométries par table (et leur nombre par GEO_ON_VALIDE), avec le nom de leur index, son tablespace, son statut et ses paramètres
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

-- 2. Création des commentaires de la vue
COMMENT ON TABLE V_BILAN_GEOM_GESTION_GEO IS 'Vue évaluant les types de géométries (par GEO_ON_VALIDE) et le nombre d''objets/géométries pour les tables TA_SUR_TOPO_G, TA_LIG_TOPO_G, TA_POINT_TOPO_G avec leur nom d''index spatial, son statut et ses paramètres.';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.OBJECTID IS 'Clé primaire - cet identifiant n''a aucune autre utilité que celle de distinguer les entités de la vue.';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.OWNER IS 'Nom du schéma dans lequel se trouve les tables.';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.TABLE_NAME IS 'Nom des tables contenant les géométries à évaluer.';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.TYPE_GEOMETRIE IS 'Types de géométries présentes dans les tables.';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.NB_OBJETS IS 'Nombre d''objets par type de géométrie et par GEO_ON_VALIDE (0 ou 1).';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.GEO_ON_VALIDE IS 'Objet tagué en tant que valide ou invalide (cette classification est propre aux tables de production et indépendante de la validité de la géométrie des objets.)';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.INDEX_NAME IS 'Nom de l''index spatial utilisé sur le champ géométrique de chaque table.';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.INDEX_TABLESPACE IS 'Nom du tablespace dans lequel se situe l''index spatial de chaque table.';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.STATUS IS 'Statut valide/invalide de l''index spatial.';
COMMENT ON COLUMN V_BILAN_GEOM_GESTION_GEO.PARAMETRES_INDEX IS 'Paramètres de chaque index spatial permettant, entre autre, de savoir quel type de géométrie peut contenir ce champ géométrique.';