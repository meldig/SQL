-- Requêtes utilisées pour créer la structure nécessaire à l'insertion des données des recensements.
/*
La table G_GEO.TA_RECENSEMENT regroupe toutes les valeurs des différents recensement.
*/

-- 1. Création de la table
CREATE TABLE G_GEO.TA_RECENSEMENT(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
	fid_code NUMBER(38,0),
	fid_lib_recensement NUMBER(38,0),
	population NUMBER(38,0),
	fid_metadonnee NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE G_GEO.TA_RECENSEMENT IS 'Table qui regroupe toutes les valeurs des différents recensements comptabilisées par les communes des Hauts-de-France.';
COMMENT ON COLUMN G_GEO.TA_RECENSEMENT.objectid IS 'Clé primaire de la table.';
COMMENT ON COLUMN G_GEO.TA_RECENSEMENT.fid_code IS 'Clé étrangère vers la table TA_CODE pour connaitre la commune concernée par la valeur du recensement.';
COMMENT ON COLUMN G_GEO.TA_RECENSEMENT.fid_lib_recensement IS 'Clé étrangère vers la table TA_LIBELLE pour connaitre le recensement concerné par la valeur du nombre d''habitant.';
COMMENT ON COLUMN G_GEO.TA_RECENSEMENT.population IS 'Nombre d''habitant recensé.';
COMMENT ON COLUMN G_GEO.TA_RECENSEMENT.fid_metadonnee IS 'Clé étrangère vers la table TA_METADONNEE pour connaitre les informations sur les données contenues dans la table.';

-- 3. Création de la clé primaire
ALTER TABLE G_GEO.TA_RECENSEMENT
ADD CONSTRAINT TA_RECENSEMENT_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des cles etrangeres
-- 4.1 Clé étrangère du champ fid_commune vers la table ta_code
ALTER TABLE G_GEO.TA_RECENSEMENT
ADD CONSTRAINT "TA_RECENSEMENT_FID_CODE_FK"
FOREIGN KEY ("FID_CODE")
REFERENCES G_GEO."TA_CODE"("OBJECTID");

-- 4.2 Clé étrangère du champ fid_lib_recensement vers la table ta_libelle
ALTER TABLE G_GEO.TA_RECENSEMENT
ADD CONSTRAINT "TA_RECENSEMENT_FID_LIB_RECENSEMENT_FK"
FOREIGN KEY ("FID_LIB_RECENSEMENT")
REFERENCES G_GEO."TA_LIBELLE"("OBJECTID");

-- 4.3 Clé étrangère du champ fid_metadonnee vers la table ta_metadonnee
ALTER TABLE G_GEO.TA_RECENSEMENT
ADD CONSTRAINT "TA_RECENSEMENT_FID_METADONNEE"
FOREIGN KEY ("FID_METADONNEE")
REFERENCES G_GEO."TA_METADONNEE"("OBJECTID");

-- 5. Création de l'index de la clé étrangère
CREATE INDEX ta_recensement_fid_code_IDX ON G_GEO.TA_RECENSEMENT(fid_code)
TABLESPACE "G_ADT_INDX";

CREATE INDEX ta_recensement_fid_libelle_IDX ON G_GEO.TA_RECENSEMENT(fid_lib_recensement)
TABLESPACE "G_ADT_INDX";

CREATE INDEX ta_recensement_fid_metadonnee_IDX ON G_GEO.TA_RECENSEMENT(fid_metadonnee)
TABLESPACE "G_ADT_INDX";