-- Creation de la vue V_RTGE_ALTI afin de restituer les informations de la table TA_RTGE_ALTI.

-- 1. Creation de la vue.
CREATE OR REPLACE FORCE VIEW G_GEO.V_RTGE_ALTI (
    OBJECTID,
    FID_IDENTIFIANT,
    IDENTIFIANT_OBJET,
    IDENTIFIANT_TYPE,
    CODE_TYPE,
    LIBELLE_TYPE,
    COORD_Z,
    SOURCE_ELEMENT,
    DATE_MAJ,
    GEOM,
CONSTRAINT "V_RTGE_ALTI_PK" PRIMARY KEY ("IDENTIFIANT_OBJET") DISABLE) 
AS
SELECT
    a.OBJECTID,
    a.FID_IDENTIFIANT,
    a.IDENTIFIANT_OBJET,
    a.IDENTIFIANT_TYPE,
    a.CODE_TYPE,
    a.LIBELLE_TYPE,
    a.COORD_Z,
    a.SOURCE_ELEMENT,
    a.DATE_MAJ,
    a.GEOM
FROM
	G_GEO.TA_RTGE_ALTI a
;


-- 2. Commentaire de la vue.
COMMENT ON TABLE G_GEO.V_RTGE_ALTI IS 'Vue qui présente les éléments contenus dans la table G_GEO.TA_RTGE_ALTI (éléments contenus dans les tables G_GEO.TA_RTGE_POINT et G_GEO.TA_RTGE_LINEAIRE_SOMMET situés dans le perimètre de la MEL et dont l''altitude est comprise entre 0 et 130 m)';

-- 3. Creation des commentaires des colonnes.
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.OBJECTID IS 'Cle primaire de la vue';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.FID_IDENTIFIANT IS 'Identifiant de l''entité dans la table source G_GEO.TA_RTGE_POINT, G_GEO.TA_RTGE_LINAIRE_SOMMET';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.IDENTIFIANT_OBJET IS 'Identifiant interne de l''objet geographique d''appartenance dans les tables G_GEO.TA_RTGE_POINT et G_GEO.TA_RTGE_LINEAIRE';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.IDENTIFIANT_TYPE IS 'Identifiant de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.CODE_TYPE IS 'Nom court de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.LIBELLE_TYPE IS 'Libelle de la classe de l''objet';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.COORD_Z IS 'Altitude du sommet';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.SOURCE_ELEMENT IS 'Provenance du point, 1: G_GEO.TA_RTGE_POINT; 2: G_GEO.TA_RTGE_LINEAIRE_SOMMET';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.DATE_MAJ IS 'Date de derniere modification de l''objet';
COMMENT ON COLUMN G_GEO.V_RTGE_ALTI.GEOM IS 'Geometrie de l''objet - type point';


-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_RTGE_ALTI',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);
COMMIT;


-- 5. Affection des droits de lecture
GRANT SELECT ON G_GEO.V_RTGE_ALTI TO G_ADMIN_SIG;
GRANT SELECT ON G_GEO.V_RTGE_ALTI TO G_SERVICE_WEB;
GRANT SELECT ON G_GEO.V_RTGE_ALTI TO ISOGEO_LEC;
GRANT SELECT ON G_GEO.V_RTGE_ALTI TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GEO.V_RTGE_ALTI TO G_GESTIONGEO_MAJ;


/