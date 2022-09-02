/*
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'TA_RTGE_ALTI';
DROP INDEX TA_RTGE_ALTI_SIDX;
DROP INDEX TA_RTGE_ALTI_IDENTIFIANT_TYPE_IDX;
DROP INDEX TA_RTGE_ALTI_CODE_TYPE_IDX;
DROP INDEX TA_RTGE_ALTI_LIBELLE_TYPE_IDX;
DROP TABLE TA_RTGE_ALTI;
*/

----------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------1. Création de la table TA_RTGE_ALTI----------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

-- Creation d'une vue matérialisée pour afficher les sommets des linéaires contenus dans la table G_GEO.TA_LIG_TOPO_F avec l'altitude dans un champ.
--1. Creation
CREATE TABLE G_GEO.TA_RTGE_ALTI
    (
    OBJECTID NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
    FID_IDENTIFIANT NUMBER(38,0),
    IDENTIFIANT_OBJET NUMBER(38,0),
    IDENTIFIANT_TYPE NUMBER(8,0),
    CODE_TYPE VARCHAR2(6 BYTE),
    LIBELLE_TYPE VARCHAR2(100 BYTE),
    COORD_Z NUMBER(9,2),
    SOURCE_ELEMENT NUMBER(1),
    DATE_MAJ DATE,
    GEOM SDO_GEOMETRY
)
;

-- 2. Commentaire
COMMENT ON TABLE G_GEO.TA_RTGE_ALTI IS 'Table qui présente les éléments contenus dans les tables G_GEO.TA_RTGE_POINT et G_GEO.TA_RTGE_LINEAIRE_SOMMET situés dans le perimètre de la MEL et dont l''altitude est comprise entre 0 et 130 m';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.OBJECTID IS 'Cle primaire de la vue materialisee';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.FID_IDENTIFIANT IS 'Identifiant de l''entité dans la table source TA_RTGE_POINT, TA_RTGE_LINAIRE';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.IDENTIFIANT_OBJET IS 'Identifiant interne de l''objet geographique';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.IDENTIFIANT_TYPE IS 'Identifiant de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.CODE_TYPE IS 'Nom court de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.LIBELLE_TYPE IS 'Libelle de la classe de l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.COORD_Z IS 'Altitude du sommet';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.SOURCE_ELEMENT IS 'Provenance du point, 1: TA_RTGE_POINT; 2: TA_RTGE_LINEAIRE_SOMMET';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.DATE_MAJ IS 'Date de deniere modification de l''objet';
COMMENT ON COLUMN G_GEO.TA_RTGE_ALTI.GEOM IS 'Geometrie de l''objet - type ligne';


-- 3. Création de la clé primaire
ALTER TABLE G_GEO.TA_RTGE_ALTI
ADD CONSTRAINT TA_RTGE_ALTI_OBJECTID_PK 
PRIMARY KEY (OBJECTID);

-- 4. Metadonnee
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_RTGE_ALTI',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 680041, 724322, 0.005),SDO_DIM_ELEMENT('Y', 7039713, 7082570, 0.005),SDO_DIM_ELEMENT('Z', 1, 200, 0.005)),
    2154
);
COMMIT;


-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX G_GEO.TA_RTGE_ALTI_SIDX
ON G_GEO.TA_RTGE_ALTI(GEOM) 
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 6. INDEX
-- 6.1. Sur le champ IDENTIFIANT_TYPE.
CREATE INDEX TA_RTGE_ALTI_IDENTIFIANT_TYPE_IDX ON G_GEO.TA_RTGE_ALTI(IDENTIFIANT_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.2. Sur le champ CODE_TYPE.
CREATE INDEX TA_RTGE_ALTI_CODE_TYPE_IDX ON G_GEO.TA_RTGE_ALTI(CODE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.3. Sur le champ LIBELLE_TYPE.
CREATE INDEX TA_RTGE_ALTI_LIBELLE_TYPE_IDX ON G_GEO.TA_RTGE_ALTI(LIBELLE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 6.4. Sur le champ LIBELLE_TYPE.
CREATE INDEX TA_RTGE_ALTI_FID_IDENTIFIANT_IDX ON G_GEO.TA_RTGE_ALTI(FID_IDENTIFIANT)
    TABLESPACE G_ADT_INDX;

-- 6.5. Sur le champ LIBELLE_TYPE.
CREATE INDEX TA_RTGE_ALTI_IDENTIFIANT_OBJET_IDX ON G_GEO.TA_RTGE_ALTI(IDENTIFIANT_OBJET)
    TABLESPACE G_ADT_INDX;

-- 6.6. Sur les champs FID_IDENTIFIANT et IDENTIFIANT_OBJET.
CREATE INDEX TA_RTGE_ALTI_FID_IDENTIFIANT_IDENTIFIANT_OBJET_IDX ON G_GEO.TA_RTGE_ALTI(FID_IDENTIFIANT, IDENTIFIANT_OBJET)
    TABLESPACE G_ADT_INDX;

-- 6.7. Sur les champs OBJECTID, FID_IDENTIFIANT, IDENTIFIANT_OBJET.
CREATE INDEX TA_RTGE_ALTI_OBJECTID_FID_IDENTIFIANT_IDENTIFIANT_OBJET_IDX ON TA_RTGE_ALTI (OBJECTID, FID_IDENTIFIANT, IDENTIFIANT_OBJET) TABLESPACE G_ADT_INDX;

-- 8. Droits
GRANT SELECT, UPDATE, INSERT, DELETE ON G_GEO.TA_RTGE_ALTI TO G_GEO_MAJ;
GRANT SELECT ON G_GEO.TA_RTGE_ALTI TO G_GEO_LEC;
GRANT SELECT ON G_GEO.TA_RTGE_ALTI TO G_SERVICE_WEB;
GRANT SELECT ON G_GEO.TA_RTGE_ALTI TO ISOGEO_LEC;