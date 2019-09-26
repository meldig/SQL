/* 
La table ta_unite_territoriale permet de recenser tous les noms des unités territoirales présentes sur le territoire de la MEL.

*/
-- 1. Création de la table ta_unite_territoriale
CREATE TABLE ta_unite_territoriale(
    objectid NUMBER(38,0),
    nom_ut Varchar2(200),
    fid_validite NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_unite_territoriale IS 'Table regroupant toutes les unités territoriales de la MEL';
COMMENT ON COLUMN geo.ta_unite_territoriale.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN geo.ta_unite_territoriale.nom_ut IS 'Nom de chaque unité territoriale.';
COMMENT ON COLUMN geo.ta_unite_territoriale.fid_validite IS 'Clé trangère permettant de lier une unité territoriale à ses dates de début et de fin de validité - ta_validite.';

-- 3. Création de la clé primaire
ALTER TABLE ta_unite_territoriale 
ADD CONSTRAINT ta_unite_territoriale_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_unite_territoriale
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_unite_territoriale
BEFORE INSERT ON ta_unite_territoriale
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_unite_territoriale.nextval;
END;

-- 6. Création des clés étrangères

ALTER TABLE ta_unite_territoriale
ADD CONSTRAINT ta_ut_fid_validite_FK
FOREIGN KEY (fid_validite)
REFERENCES ta_validite(objectid);

-- 7. Création des index sur les clés étrangères
CREATE INDEX ta_ut_fid_validite_IDX ON ta_unite_territoriale(fid_validite)
    TABLESPACE INDX_GEO;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_unite_territoriale TO G_ADT_DSIG_ADM;