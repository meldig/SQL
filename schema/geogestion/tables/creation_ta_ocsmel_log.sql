-- 3.3. Creation de la table TA_OCSMEL_LOG

-- 3.3.1. Creation de la table

CREATE TABLE G_GESTIONGEO.TA_OCSMEL_LOG
	(
	OBJECTID NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_OCSMEL_LOG_OBJECTID.NEXTVAL NOT NULL ENABLE, 
	GEOM SDO_GEOMETRY NOT NULL,
	IDENTIFIANT_OBJET NUMBER (38,0) NOT NULL,
--	NUMERO_DOSSIER NUMBER(8,0),
	FID_IDENTIFIANT_TYPE NUMBER(38,0) NOT NULL, 
--	GEO_DV DATE, 
--	GEO_DF DATE, 
--	GEO_ON_VALIDE NUMBER(1,0), 
--	GEO_TEXTE VARCHAR2(2048 BYTE), 
--	GEO_TYPE CHAR(1 BYTE), 
	FID_PNOM_ACTION NUMBER(38,0) NOT NULL,
	DATE_ACTION DATE NOT NULL, 
	FID_TYPE_ACTION NUMBER(38,0)
	)
;


-- 2.3.2. Commentaire table
COMMENT ON TABLE G_GESTIONGEO.TA_OCSMEL_LOG IS 'Objets surfaciques du plan topographique de gestion';

-- 2.3.3. Commentaire des colonnes
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LOG.OBJECTID IS 'Clé primaire de la table';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LOG.GEOM IS 'Geometrie de l''objet - type polygone';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LOG.IDENTIFIANT_OBJET IS 'Identifiant de l''objet qui est/était présent dans la table de production.';
--COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LOG.NUMERO_DOSSIER IS 'Reference du dossier pour lequel l''objet a ete releve';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LOG.FID_IDENTIFIANT_TYPE IS 'Clé étrangère vers la table TA_GG_CLASSE. Identifiant de la classe de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LOG.FID_PNOM_ACTION IS 'Clé étrangère vers la table TA_GG_AGENT. Dernier agent qui a modifie l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LOG.DATE_ACTION IS 'Date de derniere action applique sur l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LOG.FID_TYPE_ACTION IS 'Clé étrangère vers la table TA_GG_LIBELLE. Type de modification effectué sur la donnée';


-- 2.2.4. Contraintes

-- 2.2.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LOG
ADD CONSTRAINT TA_OCSMEL_LOG_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 2.2.4.2. Clés étrangères

-- 2.2.4.2.1. CHAMP FID_IDENTIFIANT_TYPE VERS TA_GG_CLASSE
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LOG
ADD CONSTRAINT TA_OCSMEL_LOG_FID_IDENTIFIANT_TYPE_FK 
FOREIGN KEY (FID_IDENTIFIANT_TYPE)
REFERENCES G_GESTIONGEO.TA_GG_CLASSE(objectid);

-- 2.2.4.2.2. CHAMP FID_PNOM_ACTION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LOG
ADD CONSTRAINT TA_OCSMEL_LOG_FID_PNOM_ACTION_FK 
FOREIGN KEY (FID_PNOM_ACTION)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 2.2.4.2.3. CHAMP NUMERO_DOSSIER vers G_GESTIONGEO.TA_GG_DOSSIER
/*
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LOG
ADD CONSTRAINT TA_OCSMEL_LOG_NUMERO_DOSSIER_FK 
FOREIGN KEY (NUMERO_DOSSIER)
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER(objectid);
*/

-- 3.2.4.2.4. CHAMP FID_TYPE_ACTION VERS G_GESTIONGEO.TA_GG_LIBELLE
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LOG
ADD CONSTRAINT TA_OCSMEL_LOG_FID_TYPE_ACTION_FK 
FOREIGN KEY (FID_TYPE_ACTION)
REFERENCES G_GESTIONGEO.TA_GG_LIBELLE(objectid);


-- 2.2.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_OCSMEL_LOG',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)),
    2154
);


-- 3.2.6. Creation des index.
-- 3.2.6.1. Création de l'index spatial sur le champ geom
CREATE INDEX TA_OCSMEL_LOG_SIDX
ON G_GESTIONGEO.TA_OCSMEL_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 3.2.6.2. Création d'un index sur le champ FID_IDENTIFIANT_TYPE
CREATE INDEX TA_OCSMEL_LOG_FID_IDENTIFIANT_TYPE_IDX ON G_GESTIONGEO.TA_OCSMEL_LOG(FID_IDENTIFIANT_TYPE) TABLESPACE G_ADT_INDX;


-- 2.2.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LOG TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LOG TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LOG TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LOG TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LOG TO G_GESTIONGEO_MAJ;

/
