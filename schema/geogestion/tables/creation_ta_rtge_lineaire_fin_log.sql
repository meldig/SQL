-- 3.2. Creation de la table TA_RTGE_LINEAIRE_FIN_LOG

-- 3.2.1. Creation de la table

CREATE TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG
	(
	OBJECTID NUMBER(38,0),
	GEOM SDO_GEOMETRY,
	FID_IDENTIFIANT NUMBER(38,0),
	NUMERO_DOSSIER VARCHAR2(13 BYTE),	
	IDENTIFIANT_TYPE NUMBER(8,0),
	DECALAGE_DROITE NUMBER(8,0),
	DECALAGE_GAUCHE NUMBER(8,0),
	FID_PNOM_MODIFICATION NUMBER(38,0),
	DATE_MODIFICATION DATE,
	MODIFICATION NUMBER(38,0)
	)
;

-- 3.2.2. Commentaire des tables
COMMENT ON TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG IS 'Table utilisée pour inserer les points releves par le geometre avant leur validation';

-- 3.2.3. Commentaire de la colonne
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.OBJECTID IS 'Cle primaire de la table';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.GEOM IS 'Geometrie de la table - type ligne';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.FID_IDENTIFIANT IS 'IIdentifiant de l''objet qui est/était présent dans la table de production.';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.NUMERO_DOSSIER IS 'Reference du dossier pour lequel l''objet a ete releve';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.IDENTIFIANT_TYPE IS 'Identifiant de la classe de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.DECALAGE_DROITE IS 'Decallage a droite par rapport a la generatrice';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.DECALAGE_GAUCHE IS 'Decallage a gauche par rapport a la generatrice';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.FID_PNOM_MODIFICATION IS 'Dernier agent qui a modifie l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.DATE_MODIFICATION IS 'Date de derniere modification de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG.MODIFICATION IS 'Type de modification effectuée sur la donnée : 1 = mise à jour, 0 = suppression';


-- 3.2.4. Contraintes

-- 3.2.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_FIN_LOG_OBJECTID_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 3.2.4.2. Clés étrangères

-- 3.2.4.2.1. CHAMP IDENTIFIANT_TYPE VERS TA_GG_CLASSE
ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG
ADD CONSTRAINT TA_RTGE_LINEAIRE_FIN_LOG_IDENTIFIANT_TYPE_FK 
FOREIGN KEY (IDENTIFIANT_TYPE)
REFERENCES G_GESTIONGEO.TA_GG_CLASSE(objectid);

-- 3.2.4.2.3. CHAMP PNOM_MODIFICATION VERS G_GESTIONGEO.TA_GG_AGENT
-- ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG
-- ADD CONSTRAINT TA_RTGE_LINEAIRE_FIN_LOG_PNOM_MODIFICATION_FK 
-- FOREIGN KEY (PNOM_MODIFICATION)
-- REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 3.2.4.2.4. CHAMP PNOM_MODIFICATION VERS G_GESTIONGEO.TA_GG_AGENT
-- ALTER TABLE G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG
-- ADD CONSTRAINT TA_RTGE_LINEAIRE_FIN_LOG_NUMERO_DOSSIER_FK 
-- FOREIGN KEY (NUMERO_DOSSIER)
-- REFERENCES G_GESTIONGEO.TA_GG_DOSSIER(objectid);


-- 3.2.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_RTGE_LINEAIRE_FIN_LOG',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005),SDO_DIM_ELEMENT('Z', -100, 100, 0.005)),
    2154
);


-- 3.2.6. Création de l'index spatial sur le champ geom
CREATE INDEX TA_RTGE_LINEAIRE_FIN_LOG_SIDX
ON G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 3.2.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_LINEAIRE_FIN_LOG TO G_GESTIONGEO_MAJ;
/
