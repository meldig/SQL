-- 3.2. Creation de la table TA_RTGE_LINEAIRE_LOG

-- 3.2.1. Creation de la table

CREATE TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG
	(
	OBJECTID NUMBER(38,0),
	GEOM SDO_GEOMETRY NOT NULL,
	IDENTIFIANT_OBJET NUMBER(38,0) NOT NULL,
	FID_NUMERO_DOSSIER NUMBER(38,0) NOT NULL,
	FID_IDENTIFIANT_TYPE NUMBER(38,0) NOT NULL,
	DECALAGE_DROITE NUMBER(38,0),
	DECALAGE_GAUCHE NUMBER(38,0),
	FID_PNOM_ACTION NUMBER(38,0) NOT NULL,
	DATE_ACTION DATE NOT NULL,
	FID_TYPE_ACTION NUMBER(38,0) NOT NULL
	)
;

-- 3.2.2. Commentaire des tables
COMMENT ON TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG IS 'Table utilisée pour inserer les points releves par le geometre avant leur validation';

-- 3.2.3. Commentaire de la colonne
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.OBJECTID IS 'Cle primaire de la table';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.GEOM IS 'Geometrie de la table - type ligne';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.IDENTIFIANT_OBJET IS 'Identifiant de l''objet qui est/était présent dans la table de production.';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.FID_NUMERO_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER. Reference du dossier pour lequel l''objet a ete releve';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.FID_IDENTIFIANT_TYPE IS 'Clé étrangère vers la table TA_GG_CLASSE. Identifiant de la classe de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.DECALAGE_DROITE IS 'Decallage a droite par rapport a la generatrice';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.DECALAGE_GAUCHE IS 'Decallage a gauche par rapport a la generatrice';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.FID_PNOM_ACTION IS 'Clé étrangère vers la table TA_GG_AGENT. Dernier agent qui a modifie l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.DATE_ACTION IS 'Date de derniere action appliqué sur l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG.FID_TYPE_ACTION IS 'Clé étrangère vers la table TA_GG_LIBELLE. Type d''action effectuée sur la donnée';


-- 3.2.4. Contraintes

-- 3.2.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_LOG_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 3.2.4.2. Clés étrangères

-- 3.2.4.2.1. CHAMP FID_IDENTIFIANT_TYPE VERS TA_GG_CLASSE
ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_LOG_FID_IDENTIFIANT_TYPE_FK 
FOREIGN KEY (FID_IDENTIFIANT_TYPE)
REFERENCES G_GESTIONGEO.TA_GG_CLASSE(objectid);

-- 3.2.4.2.3. CHAMP FID_PNOM_ACTION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_LOG_FID_PNOM_ACTION_FK 
FOREIGN KEY (FID_PNOM_ACTION)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 3.2.4.2.4. CHAMP FID_PNOM_ACTION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_LOG_FID_NUMERO_DOSSIER_FK 
FOREIGN KEY (FID_NUMERO_DOSSIER)
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER(objectid);

-- 3.2.4.2.5. CHAMP FID_TYPE_ACTION VERS G_GESTIONGEO.TA_GG_LIBELLE
ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_LOG_FID_TYPE_ACTION_FK 
FOREIGN KEY (FID_TYPE_ACTION)
REFERENCES G_GESTIONGEO.TA_GG_LIBELLE(objectid);


-- 3.2.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_RTGE_LINEAIRE_LOG',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005),SDO_DIM_ELEMENT('Z', -100, 100, 0.005)),
    2154
);


-- 3.2.6. Creation des index.
-- 3.2.6.1. Création de l'index spatial sur le champ geom
CREATE INDEX TA_RTGE_LINEAIRE_LOG_SIDX
ON G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 3.2.6.2. Création d'un index sur le champ FID_IDENTIFIANT_TYPE
CREATE INDEX TA_RTGE_LINEAIRE_LOG_FID_IDENTIFIANT_TYPE_IDX ON G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG(FID_IDENTIFIANT_TYPE) TABLESPACE G_ADT_INDX;

-- 3.2.6.3. Creation d'un index sur le champ FID_NUMERO_DOSSIER
CREATE INDEX TA_RTGE_LINEAIRE_LOG_FID_NUMERO_DOSSIER_IDX ON G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG(FID_NUMERO_DOSSIER) TABLESPACE G_ADT_INDX;

-- 3.2.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_LOG TO G_GESTIONGEO_MAJ;

/
