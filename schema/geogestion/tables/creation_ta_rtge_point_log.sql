-- 3.1. Création de la table TA_RTGE_POINT_LOG

-- 3.1.1. Creation de la table
CREATE TABLE G_GESTIONGEO.TA_RTGE_POINT_LOG
	(
	OBJECTID NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_RTGE_POINT_LOG_OBJECTID.NEXTVAL NOT NULL ENABLE,
	GEOM SDO_GEOMETRY NOT NULL,
	IDENTIFIANT_OBJET NUMBER(38,0) NOT NULL,
	FID_NUMERO_DOSSIER NUMBER(38,0) NOT NULL,
	FID_IDENTIFIANT_TYPE NUMBER(38,0) NOT NULL,
--	GEO_INSEE CHAR(3 BYTE),
--	DATE_DEBUT_VALIDITE DATE,
--	DATE_FIN_VALIDITE DATE,
	TEXTE VARCHAR2(2048 BYTE),
	LONGUEUR NUMBER(38,3),
	LARGEUR NUMBER(38,3),
	ORIENTATION NUMBER(5,2),
	HAUTEUR NUMBER(38,3),
	INCLINAISON NUMBER(5,2),
--	GEO_TYPE CHAR(1 BYTE),
	FID_PNOM_ACTION NUMBER(38,0) NOT NULL,
	DATE_ACTION DATE NOT NULL,
	FID_TYPE_ACTION NUMBER(38,0) NOT NULL,
	FID_IDENTIFIANT_OBJET_INTEGRATION NUMBER(38,0)
	)
;


-- 3.1.2. Commentaire table
COMMENT ON TABLE G_GESTIONGEO.TA_RTGE_POINT_LOG IS 'Objets surfaciques du plan topographique de gestion';

-- 3.1.3. Commentaire des colonnes
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.OBJECTID IS 'Clé primaire de la table';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.GEOM IS 'Geometrie de l''objet - type point';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.IDENTIFIANT_OBJET IS 'Identifiant de l''objet qui est/était présent dans la table de production.';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.FID_NUMERO_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER. Reference du dossier pour lequel l''objet a ete releve';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.FID_IDENTIFIANT_TYPE IS 'Clé étrangère vers la table TA_GG_CLASSE. Identifiant de la classe de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.TEXTE IS 'Texte associe a l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.LONGUEUR IS 'Longeur de l''objet en cm';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.LARGEUR IS 'Largeur de l''objet en cm';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.ORIENTATION IS 'Orientation de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.HAUTEUR IS 'Hauteur de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.INCLINAISON IS 'Inclainaison de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.FID_PNOM_ACTION IS 'Clé étrangère vers la table TA_GG_AGENT. Dernier agent qui a modifie l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.DATE_ACTION IS 'Date de derniere action applique sur l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.FID_TYPE_ACTION IS 'Clé étrangère vers la table TA_GG_LIBELLE. Type de modification effectuée sur la donnée';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT_LOG.FID_IDENTIFIANT_OBJET_INTEGRATION IS 'Clé étrangère vers la table TA_RTGE_POINT_INTEGRATION_LOG. Permet d''avoir l''historique de l''objet depuis son intégration.';

-- 3.1.4. Contraintes

-- 3.1.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT_LOG
ADD CONSTRAINT TA_RTGE_POINT_LOG_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 3.1.4.2. Clés étrangères

-- 3.1.4.2.1. CHAMP FID_IDENTIFIANT_TYPE VERS TA_GG_CLASSE
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT_LOG
ADD CONSTRAINT TA_RTGE_POINT_LOG_FID_IDENTIFIANT_TYPE_FK 
FOREIGN KEY (FID_IDENTIFIANT_TYPE)
REFERENCES G_GESTIONGEO.TA_GG_CLASSE(objectid);

-- 3.1.4.2.3. CHAMP FID_PNOM_ACTION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT_LOG
ADD CONSTRAINT TA_RTGE_POINT_LOG_PNOM_FID_PNOM_ACTION_FK 
FOREIGN KEY (FID_PNOM_ACTION)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 3.1.4.2.4. CHAMP FID_NUMERO_DOSSIER vers G_GESTIONGEO.TA_GG_DOSSIER
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT_LOG
ADD CONSTRAINT TA_RTGE_POINT_LOG_FID_NUMERO_DOSSIER_FK 
FOREIGN KEY (FID_NUMERO_DOSSIER)
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER(objectid);

-- 3.1.4.2.5. CHAMP FID_TYPE_ACTION vers G_GESTIONGEO.TA_GG_LIBELLE
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT_LOG
ADD CONSTRAINT TA_RTGE_POINT_LOG_FID_TYPE_ACTION_FK 
FOREIGN KEY (FID_TYPE_ACTION)
REFERENCES G_GESTIONGEO.TA_GG_LIBELLE(objectid);

-- 2.2.4.2.6. CHAMP FID_IDENTIFIANT_OBJET_INTEGRATION VERS G_GESTIONGEO.TA_RTGE_POINT_INTEGRATION_LOG
/*
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_FID_IDENTIFIANT_OBJET_INTEGRATION_FK 
FOREIGN KEY (FID_IDENTIFIANT_OBJET_INTEGRATION)
REFERENCES G_GESTIONGEO.TA_RTGE_POINT_INTEGRATION_LOG(IDENTIFIANT_OBJET);
*/


-- 3.1.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_RTGE_POINT_LOG',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005),SDO_DIM_ELEMENT('Z', -100, 100, 0.005)),
    2154
);


-- 3.1.6. Création des index
-- 3.1.6.1. Creation de l'index sur le champ GEOM
CREATE INDEX TA_RTGE_POINT_LOG_SIDX
ON G_GESTIONGEO.TA_RTGE_POINT_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 3.1.6.2. Création d'un index sur le champ FID_IDENTIFIANT_TYPE
CREATE INDEX TA_RTGE_POINT_LOG_FID_IDENTIFIANT_TYPE_IDX ON G_GESTIONGEO.TA_RTGE_POINT_LOG(FID_IDENTIFIANT_TYPE) TABLESPACE G_ADT_INDX;

-- 3.1.6.3. Creation d'un index sur le champ FID_NUMERO_DOSSIER
CREATE INDEX TA_RTGE_POINT_LOG_FID_NUMERO_DOSSIER_IDX ON G_GESTIONGEO.TA_RTGE_POINT_LOG(FID_NUMERO_DOSSIER) TABLESPACE G_ADT_INDX;

-- 3.1.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT_LOG TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT_LOG TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT_LOG TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT_LOG TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT_LOG TO G_GESTIONGEO_MAJ;

/
