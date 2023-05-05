--Creation de la table TA_RTGE_MUF_END_POINT
-- Cette table a pour objectif de stocker en base les END_POINT des MUF. Cela est necessaire pour pouvoir determiner le lineaire de MUF relevé par les géomètres

CREATE TABLE G_GESTIONGEO.TA_RTGE_MUF_END_POINT
	(
   	OBJECTID NUMBER(38,0), 
	FID_NUMERO_DOSSIER NUMBER(8,0) NOT NULL ENABLE, 
	GEOM SDO_GEOMETRY
	)
;


-- 2.1.2. Commentaire des tables
COMMENT ON TABLE G_GESTIONGEO.TA_RTGE_MUF_END_POINT IS 'Table utilisée pour stocker en base les START POINT des MUF. Cela est necessaire pour pouvoir determiner le lineaire de MUF relevé par les géomètres';


-- 2.1.3. Commentaire de la colonne
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_MUF_END_POINT.OBJECTID IS 'Cle primaire de la table, identifiant de la ligne.';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_MUF_END_POINT.GEOM IS 'Géometrie des éléments de la table - type point';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_MUF_END_POINT.FID_NUMERO_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER. Référence du dossier pour lequel l''objet a ete releve';


-- 2.1.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_RTGE_MUF_END_POINT
ADD CONSTRAINT TA_RTGE_MUF_END_POINT_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";


-- 2.1.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_RTGE_MUF_END_POINT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)),
    2154
);


-- 2.1.6. Creation des index
-- 2.1.6.1 Création de l'index spatial sur le champ geom
CREATE INDEX TA_RTGE_MUF_END_POINT_SIDX
ON G_GESTIONGEO.TA_RTGE_MUF_END_POINT(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 2.1.6.3. Creation d'un index sur le champ FID_NUMERO_DOSSIER
CREATE INDEX TA_RTGE_MUF_END_POINT_FID_NUMERO_DOSSIER_IDX ON G_GESTIONGEO.TA_RTGE_MUF_END_POINT(FID_NUMERO_DOSSIER) TABLESPACE G_ADT_INDX;

-- 2.1.6.4. Creation d'un index sur les champs FID_NUMERO_DOSSIER et FID_IDENTIFIANT_TYPE
CREATE INDEX TA_RTGE_MUF_END_POINT_OBJECTID_FID_NUMERO_DOSSIER_IDX ON G_GESTIONGEO.TA_RTGE_MUF_END_POINT(OBJECTID, FID_NUMERO_DOSSIER) TABLESPACE G_ADT_INDX;

/
