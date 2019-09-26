/*
La table ta_validite permet de connaître la date de début et de fin de validité des données.
*/

-- 1. Création de la table ta_unite_territoriale
CREATE TABLE ta_validite(
    objectid NUMBER(38,0),
    debut_validite DATE,
    fin_validite DATE
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_validite IS 'Table rassemblant toutes les dates de début et de fin de validité des données.';
COMMENT ON COLUMN geo.ta_validite.objectid IS 'Identifiant de chaque donnée de la table.';
COMMENT ON COLUMN geo.ta_validite.debut_validite IS 'Date de début de validité de la donnée.';
COMMENT ON COLUMN geo.ta_validite.fin_validite IS 'Date de fin de validité de la donnée.';


-- 3. Création de la clé primaire
ALTER TABLE ta_validite 
ADD CONSTRAINT ta_validite_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_validite
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_validite
BEFORE INSERT ON ta_validite
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_validite.nextval;
END;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_validite TO G_ADT_DSIG_ADM;