/*
La table ta_organisme recense tous les organismes créateurs de données desquels proviennent les données source de la table ta_source.
*/

-- 1. Création de la table ta_organisme
CREATE TABLE ta_organisme(
    objectid NUMBER(38,0),
    acronyme VARCHAR2(50),
    nom_organisme VARCHAR2(2000)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_organisme IS 'Table rassemblant tous les organismes créateurs des données source utilisées par la MEL.';
COMMENT ON COLUMN geo.ta_organisme.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN geo.ta_organisme.nom_organisme IS 'Nom de l''organisme créateur des données sources utilisées par la MEL';

-- 3. Création de la clé primaire
ALTER TABLE ta_organisme 
ADD CONSTRAINT ta_organisme_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_organisme
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_organisme
BEFORE INSERT ON ta_organisme
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_organisme.nextval;
END;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_organisme TO G_ADT_DSIG_ADM;