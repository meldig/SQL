-- 1. creation de la vue:
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE (IDENTIFIANT, IDENTIFIANT_ELEMENT, SOURCE, NUMERO_DOSSIER, IDENTIFIANT_TYPE, TYPE_OBJET_LIBELLE_COURT, COORD_Z, GEOM,
CONSTRAINT "V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE) AS
SELECT
    ROWNUM AS IDENTIFIANT,
    a.objectid AS IDENTIFIANT_ELEMENT,
    'G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN' AS SOURCE,
    a.FID_NUMERO_DOSSIER,
    a.FID_IDENTIFIANT_TYPE,
    b.LIBELLE_COURT AS TYPE_OBJET_LIBELLE_COURT,
    CAST(t.z AS NUMBER(9,2)) AS COORD_Z,
    SDO_GEOMETRY(2001, 2154,
    SDO_POINT_TYPE(t.X,t.Y,NULL),
    NULL, NULL) AS GEOM
FROM
    G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN a
INNER JOIN G_GESTIONGEO.TA_GG_CLASSE b ON a.IDENTIFIANT_TYPE = b.objectid,
TABLE
    (SDO_UTIL.GETVERTICES(a.GEOM)) t
;


-- 2. Commentaire
COMMENT ON TABLE G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE  IS 'Vue permettant d''analyser les coordonnées X,Y et Z des sommets des lignes de la table G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN.';

COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE.IDENTIFIANT IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE.IDENTIFIANT_ELEMENT IS 'Identifiant de l''entité d''origine présente dans la table G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE.SOURCE IS 'Source de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE.NUMERO_DOSSIER IS 'Numéro de dossier de l''objet.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE.IDENTIFIANT_TYPE IS 'Identifiant du type de l''objet.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE.TYPE_OBJET_LIBELLE_COURT IS 'libelle court du type de l''objet.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE.COORD_Z IS 'Coordonnée Z du point.';
COMMENT ON COLUMN G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE.GEOM IS 'Géométrie de l''objet - point.';

-- 3. Métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005),SDO_DIM_ELEMENT('Z', -100, 100, 0.005)),
    2154
);

-- 4. DROIT
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_RTGE_ELEMENT_LINEAIRE_SOMMET_ALTITUDE TO G_GESTIONGEO_MAJ;

/