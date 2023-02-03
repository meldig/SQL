-- Creation de la vue V_RTGE_LINEAIRE afin de restituer les informations de la table TA_RTGE_LINEAIRE.

-- 1. Creation de la vue.
CREATE OR REPLACE FORCE VIEW G_GEO.V_RTGE_LINEAIRE (
    IDENTIFIANT_OBJET,
    IDENTIFIANT_TYPE,
    CODE_TYPE,
    LIBELLE_TYPE,
    DECALAGE_DROITE,
    DECALAGE_GAUCHE,
    DATE_MAJ,
    GEOM,
CONSTRAINT "V_RTGE_LINEAIRE_PK" PRIMARY KEY ("IDENTIFIANT_OBJET") DISABLE) 
AS
SELECT
    a.IDENTIFIANT_OBJET,
    a.IDENTIFIANT_TYPE,
    a.CODE_TYPE,
    a.LIBELLE_TYPE,
    a.DECALAGE_DROITE,
    a.DECALAGE_GAUCHE,
    a.DATE_MAJ,
    a.GEOM
FROM
	G_GEO.TA_RTGE_LINEAIRE a
;


-- 2. Commentaire de la vue.
COMMENT ON TABLE G_GEO.V_RTGE_LINEAIRE IS 'Vue qui présente les points contenus dans la table G_GEO.TA_RTGE_LINEAIRE (les arcs sont linearises).';

-- 3. Creation des commentaires des colonnes.
COMMENT ON COLUMN G_GEO.V_RTGE_LINEAIRE.IDENTIFIANT_OBJET IS 'Identifiant interne de l''objet geographique - Cle primaire de la vue materialisee';
COMMENT ON COLUMN G_GEO.V_RTGE_LINEAIRE.IDENTIFIANT_TYPE IS 'Identifiant de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.V_RTGE_LINEAIRE.CODE_TYPE IS 'Nom court de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.V_RTGE_LINEAIRE.LIBELLE_TYPE IS 'Libelle de la classe de l''objet';
COMMENT ON COLUMN G_GEO.V_RTGE_LINEAIRE.DECALAGE_DROITE IS 'Decallage a droite par rapport a la generatrice (en cm)';
COMMENT ON COLUMN G_GEO.V_RTGE_LINEAIRE.DECALAGE_GAUCHE IS 'Decallage a gauche par rapport a la generatrice (en cm)';
COMMENT ON COLUMN G_GEO.V_RTGE_LINEAIRE.DATE_MAJ IS 'Date de derniere modification de l''objet';
COMMENT ON COLUMN G_GEO.V_RTGE_LINEAIRE.GEOM IS 'Geometrie de l''objet - type ligne';


-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'V_RTGE_LINEAIRE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)), 
    2154
);
COMMIT;


-- 5. Affection des droits de lecture
GRANT SELECT ON G_GEO.V_RTGE_LINEAIRE TO G_ADMIN_SIG;
GRANT SELECT ON G_GEO.V_RTGE_LINEAIRE TO G_SERVICE_WEB;
GRANT SELECT ON G_GEO.V_RTGE_LINEAIRE TO ISOGEO_LEC;
GRANT SELECT ON G_GEO.V_RTGE_LINEAIRE TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GEO.V_RTGE_LINEAIRE TO G_GESTIONGEO_MAJ;


/