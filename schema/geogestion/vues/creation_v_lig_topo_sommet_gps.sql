-- 1. creation de la vue V_LIG_TOPO_SOMMET_GPS: Vue presentant les coordonnées X,Y et Z des sommets des lignes de la table TEM_TA_LIG_TOPO_GPS.


CREATE OR REPLACE FORCE VIEW GEO.V_LIG_TOPO_SOMMET_GPS (identifiant,id_topo_lig_gps,cla_inu,cla_li,x,y,z,GEOM,
CONSTRAINT "V_LIG_TOPO_SOMMET_GPS_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE) AS
WITH CTE_1 AS
    (
    SELECT 
        a.objectid, 
        a.cla_inu,
        b.cla_li,
        CAST(t.X AS NUMBER(9,2)) AS x,
        CAST(t.Y AS NUMBER(9,2)) AS y,
        CAST(t.Z AS NUMBER(9,2)) AS z,
        SDO_GEOMETRY(2001, 2154,
        SDO_POINT_TYPE(t.X,t.Y,NULL),
        NULL, NULL) AS GEOM
    FROM
        GEO.temp_ta_lig_topo_gps a
    INNER JOIN GEO.TA_CLASSE b ON a.cla_inu = b.cla_inu,
    TABLE
        (SDO_UTIL.GETVERTICES(a.geom)) t
    WHERE
        a.geo_on_valide = 0
    )
    SELECT 
        rownum AS identifiant,
        CTE_1.objectid AS id_topo_lig_gps,
        CTE_1.cla_inu,
        CTE_1.cla_li,
        CTE_1.x,
        CTE_1.y,
        CTE_1.z,
        CTE_1.GEOM
    FROM
        CTE_1
;


-- 2. Commentaire

COMMENT ON TABLE GEO.V_LIG_TOPO_SOMMET_GPS IS 'Vue presentant les coordonnées X,Y et Z des sommets des lignes de la table TEMP_TA_LIG_TOPO_GPS.';

COMMENT ON COLUMN GEO.V_LIG_TOPO_SOMMET_GPS.IDENTIFIANT IS 'Clé primaire de la vue.';
COMMENT ON COLUMN GEO.V_LIG_TOPO_SOMMET_GPS.ID_TOPO_LIG_GPS IS 'Identifiant de l''entité présente dans la table TEMP_TA_LIG_TOPO_GPS.';
COMMENT ON COLUMN GEO.V_LIG_TOPO_SOMMET_GPS.cla_inu IS 'Cla inu de la ligne du sommet.';
COMMENT ON COLUMN GEO.V_LIG_TOPO_SOMMET_GPS.cla_li IS 'libelle de l''entité.';
COMMENT ON COLUMN GEO.V_LIG_TOPO_SOMMET_GPS.x IS 'Coordonnée X du point.';
COMMENT ON COLUMN GEO.V_LIG_TOPO_SOMMET_GPS.y IS 'Coordonnée Y du point.';
COMMENT ON COLUMN GEO.V_LIG_TOPO_SOMMET_GPS.z IS 'Coordonnée Z du point.';
COMMENT ON COLUMN GEO.V_LIG_TOPO_SOMMET_GPS.geom IS 'Géométrie du point.';

-- 3. Métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_LIG_TOPO_SOMMET_GPS',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);
COMMIT;

/
