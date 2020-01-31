/*
La table ta_famille rassemble toutes les familles de libellés.
*/
-- 1. Création de la table
CREATE TABLE ta_famille(
	objectid NUMBER(38,0),
	famille VARCHAR2(255)
);

-- 2. Création des commentaires
COMMENT ON TABLE ta_famille IS 'Table contenant les familles de libellés.';
COMMENT ON COLUMN ta_famille.objectid IS 'Identifiant de chaque famille de libellés.';
COMMENT ON COLUMN ta_famille.famille IS 'Valeur de chaque famille de libellés.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_famille
ADD CONSTRAINT 
	ta_famille_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation de la clé primaire
CREATE SEQUENCE SEQ_ta_famille
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur d'auto-incrémentation de la clé primaire
CREATE OR REPLACE TRIGGER BEF_ta_famille
BEFORE INSERT ON ta_famille
FOR EACH ROW

BEGIN
	:new.objectid := SEQ_ta_famille.nextval;
END;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_famille TO G_ADT_DSIG_ADM;