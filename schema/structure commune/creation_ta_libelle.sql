/*
La table ta_libelle regroupe tous les états ou actions regroupés dans une famille elle-même située dans la tabe ta_famille.

*/
-- 1. Création de la table
CREATE TABLE ta_libelle(
	objectid NUMBER(38,0),
	libelle VARCHAR2(4000)
);

-- 2. Création des commentaires
COMMENT ON TABLE ta_libelle IS 'Table contenant les libellés utilisés dans pour définir un état. Lien avec la table ta_fam_lib.';
COMMENT ON COLUMN ta_libelle.objectid IS 'Identifiant de chaque libellé.';
COMMENT ON COLUMN ta_libelle.libelle IS 'Valeur de chaque libellé définissant l''état d''un objet ou d''une action.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_libelle
ADD CONSTRAINT 
	ta_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation de la clé primaire
CREATE SEQUENCE SEQ_ta_libelle
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur d'auto-incrémentation de la clé primaire
CREATE OR REPLACE TRIGGER BEF_ta_libelle
BEFORE INSERT ON ta_libelle
FOR EACH ROW

BEGIN
	:new.objectid := SEQ_ta_libelle.nextval;
END;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_libelle TO G_ADT_DSIG_ADM;