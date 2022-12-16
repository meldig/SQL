-- 2.3 TA_OCSMEL

-- 2.3.1. Creation de la table

CREATE TABLE G_GESTIONGEO.TA_OCSMEL
	(
	OBJECTID NUMBER(38,0),
	GEOM SDO_GEOMETRY, 
	NUMERO_DOSSIER VARCHAR2(13 BYTE),
	IDENTIFIANT_TYPE NUMBER(8,0), 
--	GEO_DV DATE, 
--	GEO_DF DATE, 
--	GEO_ON_VALIDE NUMBER(1,0), 
--	GEO_TEXTE VARCHAR2(2048 BYTE), 
--	GEO_TYPE CHAR(1 BYTE), 
	FID_PNOM_CREATION NUMBER(38,0),
	DATE_CREATION DATE, 
	FID_PNOM_MODIFICATION NUMBER(38,0),
	DATE_MODIFICATION DATE, 
	SURFACE NUMBER(38,0) AS (ROUND(SDO_GEOM.SDO_AREA(GEOM,0.005)))
	)
;

-- 2.3.2. Commentaire table
COMMENT ON TABLE G_GESTIONGEO.TA_OCSMEL IS 'Objets surfaciques du plan topographique de gestion';

-- 2.3.3. Commentaire des colonnes
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.OBJECTID IS 'Clé primaire de la table';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.GEOM IS 'Geometrie de l''objet - type polygone';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.NUMERO_DOSSIER IS 'Reference du dossier pour lequel l''objet a ete releve';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.IDENTIFIANT_TYPE IS 'Identifiant de la classe de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.FID_PNOM_CREATION IS 'Agent qui a cree l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.DATE_CREATION IS 'Date de creation de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.FID_PNOM_MODIFICATION IS 'Dernier agent qui a modifie l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.DATE_MODIFICATION IS 'Date de derniere modification de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL.SURFACE IS 'Surface de l''objet en mètre carré';


-- 2.2.4. Contraintes

-- 2.2.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_OCSMEL
ADD CONSTRAINT TA_OCSMEL_OBJECTID_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 2.2.4.2. Clés étrangères

-- 2.2.4.2.1. CHAMP IDENTIFIANT_TYPE VERS TA_GG_CLASSE
ALTER TABLE G_GESTIONGEO.TA_OCSMEL
ADD CONSTRAINT TA_OCSMEL_IDENTIFIANT_TYPE_FK 
FOREIGN KEY (IDENTIFIANT_TYPE)
REFERENCES G_GESTIONGEO.TA_GG_CLASSE(objectid);

-- 2.2.4.2.2. CHAMP PNOM_CREATION VERS G_GESTIONGEO.TA_GG_AGENT
-- ALTER TABLE G_GESTIONGEO.TA_OCSMEL
-- ADD CONSTRAINT TA_OCSMEL_PNOM_CREATION_FK 
-- FOREIGN KEY (PNOM_CREATION)
-- REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 2.2.4.2.3. CHAMP PNOM_MODIFICATION VERS G_GESTIONGEO.TA_GG_AGENT
-- ALTER TABLE G_GESTIONGEO.TA_OCSMEL
-- ADD CONSTRAINT TA_OCSMEL_PNOM_MODIFICATION_FK 
-- FOREIGN KEY (PNOM_MODIFICATION)
-- REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 2.2.4.2.4. CHAMP NUMERO_DOSSIER vers G_GESTIONGEO.TA_GG_DOSSIER
--ALTER TABLE G_GESTIONGEO.TA_OCSMEL
--ADD CONSTRAINT TA_OCSMEL_NUMERO_DOSSIER_FK 
--FOREIGN KEY (NUMERO_DOSSIER)
--REFERENCES G_GESTIONGEO.TA_GG_DOSSIER(objectid);


-- 2.2.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_OCSMEL',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)),
    2154
);


-- 2.2.6. Création de l'index spatial sur le champ geom
CREATE INDEX TA_OCSMEL_SIDX
ON G_GESTIONGEO.TA_OCSMEL(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 2.2.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL TO G_GESTIONGEO_MAJ;
/
