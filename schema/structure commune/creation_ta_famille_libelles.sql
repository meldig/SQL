/*
La table ta_famille_libelle sert à faire la liaison entre les tables ta_libelle et ta_famille.
*/
-- 1. Création de la table
CREATE TABLE ta_famille_libelle(
	objectid NUMBER(38,0),
	fid_famille NUMBER(38,0),
	fid_libelle NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE ta_famille_libelle IS 'Table contenant les identifiant des tables ta_libelle et ta_famille, permettant de joindre le libellé à sa famille de libellés.';
COMMENT ON COLUMN ta_famille_libelle.objectid IS 'Identifiant de chaque ligne.';
COMMENT ON COLUMN ta_famille_libelle.fid_famille IS 'Identifiant de chaque famille de libellés - FK de la table ta_famille.';
COMMENT ON COLUMN ta_famille_libelle.fid_libelle IS 'Identifiant de chaque libellés - FK de la table ta_libelle.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT 
	ta_famille_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation de la clé primaire
CREATE SEQUENCE SEQ_ta_famille_libelle
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur d'auto-incrémentation de la clé primaire
CREATE OR REPLACE TRIGGER BEF_ta_famille_libelle
BEFORE INSERT ON ta_famille_libelle
FOR EACH ROW

BEGIN
	:new.objectid := SEQ_ta_famille_libelle.nextval;
END;

-- 6. Création des clés étrangères
ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT
	ta_fam_lib_fid_famille_FK
FOREIGN KEY("fid_famille")
REFERENCES
	ta_famille(objectid);

ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT
	ta_fam_lib_fid_libelle_FK
FOREIGN KEY("fid_libelle")
REFERENCES
	ta_libelle(objectid);

-- 7. Création de l'index de la clé étrangère
CREATE INDEX ta_fam_lib_fid_famille_IDX ON ta_famille(objectid)
TABLESPACE INDX_GEO;

CREATE INDEX ta_fam_lib_fid_libelle_IDX ON ta_libelle(objectid)
TABLESPACE INDX_GEO;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_famille_libelle TO G_ADT_DSIG_ADM;
