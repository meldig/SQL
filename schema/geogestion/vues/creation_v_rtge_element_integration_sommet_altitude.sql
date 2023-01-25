-- 1. creation de la vue:
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE (IDENTIFIANT, IDENTIFIANT_ELEMENT, SOURCE, NUMERO_DOSSIER, IDENTIFIANT_TYPE, TYPE_OBJET_LIBELLE_COURT, COORD_Z, GEOM,
CONSTRAINT "V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE) AS
WITH CTE_1 AS
    (
    SELECT 
        a.objectid AS IDENTIFIANT_ELEMENT,
        'G_GESTIONGEO.TA_RTGE_POINT_INTEGRATION' AS SOURCE,
        a.FID_NUMERO_DOSSIER,
        a.FID_IDENTIFIANT_TYPE,
        b.LIBELLE_COURT AS TYPE_OBJET_LIBELLE_COURT,
        CAST(a.GEOM.sdo_point.z AS NUMBER(9,2)) AS COORD_Z,
        SDO_CS.MAKE_2D(a.geom, 2154) AS GEOM
    FROM
        G_GESTIONGEO.TA_RTGE_POINT_INTEGRATION a
        INNER JOIN G_GESTIONGEO.TA_GG_CLASSE b ON a.FID_IDENTIFIANT_TYPE = b.objectid
        ),
CTE_2 AS
    (
    SELECT 
        a.objectid AS IDENTIFIANT_ELEMENT,
        'G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION' AS SOURCE,
        a.FID_NUMERO_DOSSIER,
        a.FID_IDENTIFIANT_TYPE,
        b.LIBELLE_COURT AS TYPE_OBJET_LIBELLE_COURT,
        CAST(t.z AS NUMBER(9,2)) AS COORD_Z,
        SDO_GEOMETRY(2001, 2154,
        SDO_POINT_TYPE(t.X,t.Y,NULL),
        NULL, NULL) AS GEOM
    FROM
        G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION a
    INNER JOIN G_GESTIONGEO.TA_GG_CLASSE b ON a.FID_IDENTIFIANT_TYPE = b.objectid,
    TABLE
        (SDO_UTIL.GETVERTICES(a.GEOM)) t
    ),
CTE_3 AS
    (
    SELECT
        CTE_1.*
    FROM
        CTE_1
    UNION ALL
    SELECT
        CTE_2.*
    FROM
        CTE_2
    )
    SELECT
        ROWNUM as IDENTIFIANT,
        CTE_3.*
    FROM
        CTE_3
    ;


-- 2. Commentaire
COMMENT ON TABLE G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE  IS 'Vue permettant d''analyser les coordonnées X,Y et Z des elements contenus dans la table TA_RTGE_POINT_INTEGRATION et les altitudes des sommets des elements contenu dans la table TA_RTGE_LINEAIRE_INTEGRATION.';

COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE.IDENTIFIANT IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE.IDENTIFIANT_ELEMENT IS 'Identifiant de l''entité d''origine présente dans la table TA_RTGE_POINT_INTEGRATION ou TA_RTGE_LINEAIRE_INTEGRATION.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE.SOURCE IS 'Table source de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE.NUMERO_DOSSIER IS 'Numéro de dossier de l''objet.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE.IDENTIFIANT_TYPE IS 'Identifiant du type de l''objet.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE.TYPE_OBJET_LIBELLE_COURT IS 'libelle court du type de l''objet.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE.COORD_Z IS 'Coordonnée Z du point.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE.GEOM IS 'Géométrie de l''objet - point.';

-- 3. Métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005),SDO_DIM_ELEMENT('Z', -100, 100, 0.005)),
    2154
);

-- 4. DROIT
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_INTEGRATION_SOMMET_ALTITUDE TO G_GESTIONGEO_MAJ;

/
