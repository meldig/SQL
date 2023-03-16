-- 1. Creation de la table

CREATE TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE
	(
	OBJECTID NUMBER(38,0),
	GEOM SDO_GEOMETRY NOT NULL,
	FID_IDENTIFIANT_TYPE NUMBER(38,0) NOT NULL,
	FID_PNOM_CREATION NUMBER(38,0) NOT NULL,
	DATE_CREATION DATE NOT NULL,
	FID_PNOM_MODIFICATION NUMBER(38,0),
	DATE_MODIFICATION DATE
	)
;


-- 1.2. Commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE IS 'Objets lineaires du plan topographique de gestion';


-- 1.3. Commentaire des colonnes
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE.OBJECTID IS 'Identifiant interne de l''objet geographique';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE.GEOM IS 'Type de geometrie de l''objet geographique - LIGNE';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE.FID_IDENTIFIANT_TYPE IS 'Clé étrangère vers la table TA_GG_CLASSE. Identifiant de la classe de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE.FID_PNOM_CREATION IS 'Clé étrangère vers la table TA_GG_AGENT. Agent qui a créé l''objet.';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE.DATE_CREATION IS 'Date de creation de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE.FID_PNOM_MODIFICATION IS 'Clé étrangère vers la table TA_GG_AGENT. Dernier agent qui a modifié l''objet.';
COMMENT ON COLUMN G_GESTIONGEO.TA_OCSMEL_LINEAIRE.DATE_MODIFICATION IS 'Date de dernière modification de l''objet';


-- 1.4. Contraintes

-- 1.4.1. Clé primaire
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE
ADD CONSTRAINT TA_OCSMEL_LINEAIRE_OBJECTID_PK 
PRIMARY KEY (OBJECTID)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 1.4.2. Clés étrangères

-- 1.4.2.1. CHAMP FID_IDENTIFIANT_TYPE VERS TA_GG_CLASSE
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE
ADD CONSTRAINT TA_OCSMEL_LINEAIRE_FID_IDENTIFIANT_TYPE_FK 
FOREIGN KEY (FID_IDENTIFIANT_TYPE)
REFERENCES G_GESTIONGEO.TA_GG_CLASSE(objectid);

-- 1.4.2.2. CHAMP PNOM_CREATION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE
ADD CONSTRAINT TA_OCSMEL_LINEAIRE_FID_PNOM_CREATION_FK 
FOREIGN KEY (FID_PNOM_CREATION)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);

-- 1.4.2.3. CHAMP PNOM_MODIFICATION VERS G_GESTIONGEO.TA_GG_AGENT
ALTER TABLE G_GESTIONGEO.TA_OCSMEL_LINEAIRE
ADD CONSTRAINT TA_OCSMEL_LINEAIRE_FID_PNOM_MODIFICATION_FK 
FOREIGN KEY (FID_PNOM_MODIFICATION)
REFERENCES G_GESTIONGEO.TA_GG_AGENT(objectid);


-- 1.5. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_OCSMEL_LINEAIRE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)),
    2154
);


-- 1.6. Creation des index
-- 1.6.1. Création de l'index spatial sur le champ geom
CREATE INDEX TA_OCSMEL_LINEAIRE_SIDX
ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 1.6.2. Création d'un index sur le champ FID_IDENTIFIANT_TYPE
CREATE INDEX TA_OCSMEL_LINEAIRE_FID_IDENTIFIANT_TYPE_IDX ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE(FID_IDENTIFIANT_TYPE) TABLESPACE G_ADT_INDX;


-- 1.7. Affection des droits de lecture
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE TO G_SERVICE_WEB;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE TO ISOGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE TO G_GESTIONGEO_LEC;
GRANT SELECT, UPDATE, DELETE, INSERT ON  G_GESTIONGEO.TA_OCSMEL_LINEAIRE TO G_GESTIONGEO_MAJ;
GRANT UPDATE ("GEOM") ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE TO G_GESTIONGEO_MAJ;

/
