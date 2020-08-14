/*
La table TA_METADONNEE est une table pivot qui permet de regrouper toutes les métadonnées des donnees du schéma.
*/
-- 1. Création de la table
CREATE TABLE g_geo.ta_metadonnee(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	fid_source NUMBER(38,0),
	fid_acquisition NUMBER(38,0),
	fid_provenance NUMBER(38,0),
	fid_echelle NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_metadonnee IS 'Table qui regroupe toutes les informations relatives aux différentes donnees du schema.';
COMMENT ON COLUMN g_geo.ta_metadonnee.objectid IS 'clé primaire de la table.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_source IS 'clé étrangère vers la table TA_SOURCE pour connaitre la source de la donnée.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_acquisition IS 'clé étrangère vers la table ta_date_acquisition pour connaitre la date d''acquisition de la donnée.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_provenance IS 'clé étrangère vers la table TA_PROVENANCE pour connaitre la provenance de la donnée.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_echelle IS 'clé étrangère vers la table TA_ECHELLE pour connaitre l''echelle de la donnee.';

-- 3. Création de la clé primaire
ALTER TABLE g_geo.ta_metadonnee
ADD CONSTRAINT	ta_metadonnee_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE g_geo.ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_source_FK
FOREIGN KEY (fid_source)
REFERENCES g_geo.ta_source(objectid);

-- 4.2. clé étrangère vers la table TA_DATE_ACQUISITION
ALTER TABLE g_geo.ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_acquisition_FK
FOREIGN KEY (fid_acquisition)
REFERENCES g_geo.ta_date_acquisition(objectid);

-- 4.3. clé étrangère vers la table TA_PROVENANCE
ALTER TABLE g_geo.ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_provenance_FK
FOREIGN KEY (fid_provenance)
REFERENCES g_geo.ta_provenance(objectid);

-- 4.. clé étrangère vers la table TA_ECHELLE
ALTER TABLE g_geo.ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_echelle_FK
FOREIGN KEY (fid_echelle)
REFERENCES g_geo.ta_echelle(objectid);

-- 5. Création des indexes sur les clés étrangères
CREATE INDEX ta_metadonnee_fid_source_IDX ON ta_metadonnee(fid_source)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_metadonnee_fid_acquisition_IDX ON ta_metadonnee(fid_acquisition)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_metadonnee_fid_provenance_IDX ON ta_metadonnee(fid_provenance)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_metadonnee_fid_echelle_IDX ON ta_metadonnee(fid_echelle)
TABLESPACE G_ADT_INDX;


-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_metadonnee TO G_ADT_DSIG_ADM;