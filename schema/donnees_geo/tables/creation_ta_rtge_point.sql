/*
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'TA_RTGE_POINT';
DROP INDEX TA_RTGE_POINT_SIDX;
DROP INDEX TA_RTGE_POINT_IDENTIFIANT_TYPE_IDX;
DROP INDEX TA_RTGE_POINT_CODE_TYPE_IDX;
DROP INDEX TA_RTGE_POINT_LIBELLE_TYPE_IDX;
DROP TABLE TA_RTGE_POINT CASCADE CONSTRAINTS;
*/

----------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------1. Création de la table TA_RTGE_POINT-----------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

-- Creation d'une vue pour afficher les points contenus dans la table G_GEO.TA_POIN_TOPO_F avec l'altitude dans un nouveau champ.
--1. Creation
CREATE TABLE G_GEO.TA_RTGE_POINT
    (
    IDENTIFIANT_OBJET NUMBER(38,0),
    IDENTIFIANT_TYPE NUMBER(8,0),
    CODE_TYPE VARCHAR2(6 BYTE),
    LIBELLE_TYPE VARCHAR2(100 BYTE),
    LONGUEUR NUMBER(8,0),
    LARGEUR NUMBER(8,0),
    ORIENTATION NUMBER(5,2),
    COORD_Z NUMBER(9,2),
    DATE_MAJ DATE,
    GEOM SDO_GEOMETRY
    )
;


-- 2. Commentaire
COMMENT ON TABLE G_GEO.TA_RTGE_POINT IS 'Table qui présente les points contenus dans la table GEO.TA_POINT_TOPO_F, avec la coordonnée Z dans un champ spécifique';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.IDENTIFIANT_OBJET IS 'Identifiant interne de l''objet geographique - Cle primaire de la vue materialisee';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.IDENTIFIANT_TYPE IS 'Identifiant de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.CODE_TYPE IS 'Nom court de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.LIBELLE_TYPE IS 'Libelle de la classe de l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.LONGUEUR IS 'Longueur de l''objet (en cm)';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.LARGEUR IS 'Largeur de l''objet (en cm)';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.ORIENTATION IS 'Orientation de l''objet (en degre)';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.COORD_Z IS 'Altitude du point';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.DATE_MAJ IS 'Date de derniere modification de l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_POINT.GEOM IS 'Geometrie de l''objet - type point';


-- 3. Création de la clé primaire
ALTER TABLE G_GEO.TA_RTGE_POINT
ADD CONSTRAINT TA_RTGE_POINT_IDENTIFIANT_OBJET_PK 
PRIMARY KEY (IDENTIFIANT_OBJET);


-- 4. Metadonnee
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_RTGE_POINT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 680041, 724322, 0.005),SDO_DIM_ELEMENT('Y', 7039713, 7082570, 0.005),SDO_DIM_ELEMENT('Z', -1000, 10000, 0.005)),
    2154
);
COMMIT;


-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX G_GEO.TA_RTGE_POINT_SIDX
ON G_GEO.TA_RTGE_POINT(GEOM) 
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 6. INDEX
-- 6.1. Sur le champ IDENTIFIANT_TYPE.
CREATE INDEX TA_RTGE_POINT_IDENTIFIANT_TYPE_IDX ON G_GEO.TA_RTGE_POINT(IDENTIFIANT_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.2. Sur le champ CODE_TYPE.
CREATE INDEX TA_RTGE_POINT_CODE_TYPE_IDX ON G_GEO.TA_RTGE_POINT(CODE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.3. Sur le champ LIBELLE_TYPE.
CREATE INDEX TA_RTGE_POINT_LIBELLE_TYPE_IDX ON G_GEO.TA_RTGE_POINT(LIBELLE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 7. Droits
GRANT SELECT, UPDATE, INSERT, DELETE ON G_GEO.TA_RTGE_POINT TO G_GEO_MAJ;
GRANT SELECT ON G_GEO.TA_RTGE_POINT TO G_GEO_LEC;
GRANT SELECT ON G_GEO.TA_RTGE_POINT TO G_SERVICE_WEB;
GRANT SELECT ON G_GEO.TA_RTGE_POINT TO ISOGEO_LEC;

COMMIT;

/
