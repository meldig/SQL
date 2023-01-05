-- 2.1. Creation de la table TA_RTGE_POINT

-- 2.1.1. Creation de la table
CREATE TABLE G_GESTIONGEO.TA_RTGE_POINT
	(
	OBJECTID NUMBER(38,0),
	GEOM SDO_GEOMETRY,
	NUMERO_DOSSIER NUMBER(8,0),	
	IDENTIFIANT_TYPE NUMBER(8,0),
--	GEO_INSEE CHAR(3 BYTE),
--	DATE_DEBUT_VALIDITE DATE,
--	DATE_FIN_VALIDITE DATE,
--	VALIDITE NUMBER(1,0),
	TEXTE VARCHAR2(2048 BYTE),
	LONGUEUR NUMBER(8,0),
	LARGEUR NUMBER(8,0),
	ORIENTATION NUMBER(5,2),
	HAUTEUR NUMBER(8,0),
	INCLINAISON NUMBER(5,2),
--	GEO_TYPE CHAR(1 BYTE),
	FID_PNOM_CREATION NUMBER(38,0),
	DATE_CREATION DATE,
	FID_PNOM_MODIFICATION NUMBER(38,0),
	DATE_MODIFICATION DATE
	)
;

-- 2.1.2. Commentaire des tables
COMMENT ON TABLE G_GESTIONGEO.TA_RTGE_POINT IS 'Table utilisée pour inserer les points releves par le geometre avant leur validation';

-- 2.1.3. Commentaire de la colonne
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.OBJECTID IS 'Cle primaire de la table';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.GEOM IS 'Geometrie de la table - type point';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.NUMERO_DOSSIER IS 'Reference du dossier pour lequel l''objet a ete releve';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.IDENTIFIANT_TYPE IS 'Identifiant de la classe de l''objet';
-- COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.DATE_DEBUT_VALIDITE IS 'Date de debut de validite';
-- COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.DATE_FIN_VALIDITE IS 'Date de fin de validite';
-- COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.VALIDITE IS 'Validite de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.TEXTE IS 'Texte associe a l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.LONGUEUR IS 'Longeur de l''objet en cm';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.LARGEUR IS 'Largeur de l''objet en cm';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.ORIENTATION IS 'Orientation de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.HAUTEUR IS 'Hauteur de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.INCLINAISON IS 'Inclainaison de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.FID_PNOM_CREATION IS 'Agent qui a cree l''element';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.DATE_CREATION IS 'Date de creation de l''element';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.FID_PNOM_MODIFICATION IS 'Dernier agent qui a modifie l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_RTGE_POINT.DATE_MODIFICATION IS 'Date de derniere modification de l''objet';


-- 2.1.4. Contraintes

-- 2.1.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT
ADD CONSTRAINT TA_RTGE_POINT_OBJECTID_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 2.1.4.2. Clés étrangères

-- 2.1.4.2.1. CHAMP IDENTIFIANT_TYPE VERS TA_GG_CLASSE
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT
ADD CONSTRAINT TA_RTGE_POINT_IDENTIFIANT_TYPE_FK 
FOREIGN KEY (IDENTIFIANT_TYPE)
REFERENCES G_GESTIONGEO.TA_GG_CLASSE(objectid);

-- 2.1.4.2.2. CHAMP PNOM_CREATION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT
ADD CONSTRAINT TA_RTGE_POINT_PNOM_CREATION_FK 
FOREIGN KEY (PNOM_CREATION)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 2.1.4.2.3. CHAMP PNOM_MODIFICATION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT
ADD CONSTRAINT TA_RTGE_POINT_PNOM_MODIFICATION_FK 
FOREIGN KEY (PNOM_MODIFICATION)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 2.1.4.2.4. CHAMP NUMERO_DOSSIER vers G_GESTIONGEO.TA_GG_DOSSIER
ALTER TABLE G_GESTIONGEO.TA_RTGE_POINT
ADD CONSTRAINT TA_RTGE_POINT_NUMERO_DOSSIER_FK 
FOREIGN KEY (NUMERO_DOSSIER)
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER(objectid);


-- 2.1.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_RTGE_POINT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005),SDO_DIM_ELEMENT('Z', -100, 100, 0.005)),
    2154
);


-- 2.1.6. Creation des index
-- 2.1.6.1 Création de l'index spatial sur le champ geom
CREATE INDEX TA_RTGE_POINT_SIDX
ON G_GESTIONGEO.TA_RTGE_POINT(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 2.1.6.2. Création d'un index sur le champ IDENTIFIANT_TYPE
CREATE INDEX TA_RTGE_POINT_IDENTIFIANT_TYPE_IDX ON G_GESTIONGEO.TA_RTGE_POINT(IDENTIFIANT_TYPE) TABLESPACE G_ADT_INDX;

-- 2.1.6.3. Creation d'un index sur le champ numero dossier
CREATE INDEX TA_RTGE_POINT_NUMERO_DOSSIER_IDX ON G_GESTIONGEO.TA_RTGE_POINT(NUMERO_DOSSIER) TABLESPACE G_ADT_INDX;

-- 2.1.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_RTGE_POINT TO G_GESTIONGEO_MAJ;

/
