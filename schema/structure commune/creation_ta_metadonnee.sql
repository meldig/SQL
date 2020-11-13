/*
La table TA_METADONNEE est une table pivot qui permet de regrouper toutes les métadonnées des donnees du schéma.
*/
-- 1. Création de la table
CREATE TABLE G_GEO.TA_METADONNEE(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	fid_source NUMBER(38,0),
	fid_acquisition NUMBER(38,0),
	fid_provenance NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE G_GEO.TA_METADONNEE IS 'Table qui regroupe toutes les informations relatives aux différentes donnees du schema.';
COMMENT ON COLUMN G_GEO.TA_METADONNEE.objectid IS 'clé primaire de la table.';
COMMENT ON COLUMN G_GEO.TA_METADONNEE.fid_source IS 'clé étrangère vers la table TA_SOURCE pour connaitre la source de la donnée.';
COMMENT ON COLUMN G_GEO.TA_METADONNEE.fid_acquisition IS 'clé étrangère vers la table TA_DATE_ACQUISITION pour connaitre la date d''acquisition de la donnée.';
COMMENT ON COLUMN G_GEO.TA_METADONNEE.fid_provenance IS 'clé étrangère vers la table TA_PROVENANCE pour connaitre la provenance de la donnée.';

-- 3. Création de la clé primaire
ALTER TABLE G_GEO.TA_METADONNEE
ADD CONSTRAINT	TA_METADONNEE_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE G_GEO.TA_METADONNEE
ADD CONSTRAINT TA_METADONNEE_FID_SOURCE_FK
FOREIGN KEY (fid_source)
REFERENCES G_GEO.TA_SOURCE(objectid);

-- 4.2. clé étrangère vers la table TA_DATE_ACQUISITION
ALTER TABLE G_GEO.TA_METADONNEE
ADD CONSTRAINT TA_METADONNEE_FID_ACQUISITION_FK
FOREIGN KEY (fid_acquisition)
REFERENCES G_GEO.TA_DATE_ACQUISITION(objectid);

-- 4.3. clé étrangère vers la table TA_PROVENANCE
ALTER TABLE G_GEO.TA_METADONNEE
ADD CONSTRAINT TA_METADONNEE_FID_PROVENANCE_FK
FOREIGN KEY (fid_provenance)
REFERENCES G_GEO.TA_PROVENANCE(objectid);

-- 5. Création des indexes sur les clés étrangères
CREATE INDEX TA_METADONNEE_fid_source_IDX ON TA_METADONNEE(fid_source)
TABLESPACE G_ADT_INDX;

CREATE INDEX TA_METADONNEE_fid_acquisition_IDX ON TA_METADONNEE(fid_acquisition)
TABLESPACE G_ADT_INDX;

CREATE INDEX TA_METADONNEE_fid_provenance_IDX ON TA_METADONNEE(fid_provenance)
TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_GEO.TA_METADONNEE TO G_ADMIN_SIG;