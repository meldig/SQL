-- 3.2. Creation de la table TA_OCSMEL_LINEAIRE_LOG

-- 3.2.1. Creation de la table

CREATE TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG
	(
	OBJECTID NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_OCSMEL_LINEAIRE_LOG_OBJECTID.NEXTVAL NOT NULL ENABLE, 
	GEOM SDO_GEOMETRY NOT NULL,
	IDENTIFIANT_OBJET NUMBER(38,0) NOT NULL,
	FID_IDENTIFIANT_TYPE NUMBER(38,0) NOT NULL,
	FID_PNOM_ACTION NUMBER(38,0) NOT NULL,
	DATE_ACTION DATE NOT NULL,
	FID_TYPE_ACTION NUMBER(38,0) NOT NULL
	)
;

-- 3.2.2. Commentaire des tables
COMMENT ON TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG IS 'Table utilisée pour inserer les points releves par le geometre avant leur validation';

-- 3.2.3. Commentaire de la colonne
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG.OBJECTID IS 'Cle primaire de la table';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG.GEOM IS 'Geometrie de la table - type ligne';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG.IDENTIFIANT_OBJET IS 'Identifiant de l''objet qui est/était présent dans la table de production.';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG.FID_IDENTIFIANT_TYPE IS 'Clé étrangère vers la table TA_GG_CLASSE. Identifiant de la classe de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG.FID_PNOM_ACTION IS 'Clé étrangère vers la table TA_GG_AGENT. Dernier agent qui a modifie l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG.DATE_ACTION IS 'Date de derniere action appliqué sur l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG.FID_TYPE_ACTION IS 'Clé étrangère vers la table TA_GG_LIBELLE. Type d''action effectuée sur la donnée';


-- 3.2.4. Contraintes

-- 3.2.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG
ADD CONSTRAINT TA_OCSMEL_LINEAIRE_LOG_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 3.2.4.2. Clés étrangères

-- 3.2.4.2.1. CHAMP FID_IDENTIFIANT_TYPE VERS TA_GG_CLASSE
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG
ADD CONSTRAINT TA_OCSMEL_LINEAIRE_LOG_FID_IDENTIFIANT_TYPE_FK 
FOREIGN KEY (FID_IDENTIFIANT_TYPE)
REFERENCES G_GESTIONGEO.TA_GG_CLASSE(objectid);

-- 3.2.4.2.3. CHAMP FID_PNOM_ACTION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG
ADD CONSTRAINT TA_OCSMEL_LINEAIRE_LOG_FID_PNOM_ACTION_FK 
FOREIGN KEY (FID_PNOM_ACTION)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 3.2.4.2.4. CHAMP FID_TYPE_ACTION VERS G_GESTIONGEO.TA_GG_LIBELLE
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG
ADD CONSTRAINT TA_OCSMEL_LINEAIRE_LOG_FID_TYPE_ACTION_FK 
FOREIGN KEY (FID_TYPE_ACTION)
REFERENCES G_GESTIONGEO.TA_GG_LIBELLE(objectid);

-- 2.2.4.2.6. CHAMP FID_IDENTIFIANT_OBJET_INTEGRATION VERS G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION_LOG
/*
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_FID_IDENTIFIANT_OBJET_INTEGRATION_FK 
FOREIGN KEY (FID_IDENTIFIANT_OBJET_INTEGRATION)
REFERENCES G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION_LOG(IDENTIFIANT_OBJET);
*/

-- 3.2.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_OCSMEL_LINEAIRE_LOG',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)),
    2154
);


-- 3.2.6. Creation des index.
-- 3.2.6.1. Création de l'index spatial sur le champ geom
CREATE INDEX TA_OCSMEL_LINEAIRE_LOG_SIDX
ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 3.2.6.2. Création d'un index sur le champ FID_IDENTIFIANT_TYPE
CREATE INDEX TA_OCSMEL_LINEAIRE_LOG_FID_IDENTIFIANT_TYPE_IDX ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG(FID_IDENTIFIANT_TYPE) TABLESPACE G_ADT_INDX;

-- 3.2.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG TO G_GESTIONGEO_MAJ;

/
