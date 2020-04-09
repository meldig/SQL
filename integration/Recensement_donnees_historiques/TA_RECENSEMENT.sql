/*
La table ta_recensement regroupe toutes les valeurs des différents recensements comptabilisés par les communes composant la MEL entre 1876 et 2017

*/
-- 1. Création de la table
CREATE TABLE ta_recensement(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
	fid_code NUMBER(38,0),
	fid_recensement NUMBER(38,0),
	population NUMBER(38,0),
	fid_metadonnee NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_recensement IS 'Table qui regroupe toutes les valeurs des différents récensements comptabilisées par les communes composant la MEL entre 1876 et 2017.';
COMMENT ON COLUMN g_geo.ta_recensement.objectid IS 'Clé primaire de la table.';
COMMENT ON COLUMN g_geo.ta_recensement.fid_code IS 'Clé étrangère vers la table TA_CODE pour connaitre la commune concernée par la valeur du recensement.';
COMMENT ON COLUMN g_geo.ta_recensement.fid_recensement IS 'Clé étrangère vers la table TA_LIBELLE_COURT pour connaitre la date du recensement.';
COMMENT ON COLUMN g_geo.ta_recensement.population IS 'Nombre d''habitant recensé.';
COMMENT ON COLUMN g_geo.ta_recensement.fid_metadonnee IS 'Clé étrangère vers la table TA_METADONNEE pour connaitre les informations sur les données contenues dans la table.';

-- 3. Création de la clé primaire
ALTER TABLE ta_recensement
	ADD CONSTRAINT ta_recensement_PK 
	PRIMARY KEY("OBJECTID")
	USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des cles etrangere

-- 4.1 Clé étrangère du champ fid_commune vers la table ta_code

ALTER TABLE ta_recensement
	ADD CONSTRAINT ta_recensement_fid_code_FK
	FOREIGN KEY (fid_code)
	REFERENCES ta_code(objectid);

-- 4.2 Clé étrangère du champ fid_nomenclature_recensement vers la table ta_nomenclature

ALTER TABLE ta_recensement
	ADD CONSTRAINT ta_recensement_fid_recensement_FK
	FOREIGN KEY (fid_recensement)
	REFERENCES ta_libelle_court(objectid);

-- 4.3 Clé étrangère du champ fid_metadonnee vers la table ta_metadonnee

ALTER TABLE ta_recensement
	ADD CONSTRAINT ta_recensement_fid_metadonnee_FK
	FOREIGN KEY (fid_metadonnee)
	REFERENCES ta_metadonnee(objectid);

-- 5. Création de l'index de la clé étrangère
CREATE INDEX ta_recensement_fid_code_IDX ON ta_recensement(fid_code)
TABLESPACE "G_ADT_INDX";

CREATE INDEX ta_recensement_fid_recenseemnt_IDX ON ta_recensement(fid_recensement)
TABLESPACE "G_ADT_INDX";

CREATE INDEX ta_recensement_fid_metadonnee_IDX ON ta_recensement(fid_metadonnee)
TABLESPACE "G_ADT_INDX";