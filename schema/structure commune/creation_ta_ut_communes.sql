/* 
La table ta_ut_communes sert de table de liaison entre les tables ta_commune et ta_unite_territoriale.
Fonction : savoir quelle commune appartient à quelle unité territoriale.

*/
-- 1. Création de la table ta_ut_communes
CREATE TABLE ta_ut_communes(
    objectid NUMBER(38,0),
    fid_commune NUMBER(38,0),
    fid_unite_territoriale NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_ut_communes IS 'Table de liaison entre les tables ta_commune et ta_unite_territoriale';
COMMENT ON COLUMN geo.ta_ut_communes.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN geo.ta_ut_communes.objectid IS 'Clé étrangère permettant de lier une commune à une unité territoriale - ta_commune.';
COMMENT ON COLUMN geo.ta_ut_communes.objectid IS 'Clé trangère permettant de lier une unité territoriale à une ou plusieurs communes - ta_unite_territoriale.';

-- 3. Création de la clé primaire
ALTER TABLE ta_ut_communes 
ADD CONSTRAINT ta_ut_communes_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_ut_communes
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_ut_communes
BEFORE INSERT ON ta_ut_communes
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_ut_communes.nextval;
END;

-- 6. Création des clés étrangères

ALTER TABLE ta_ut_communes
ADD CONSTRAINT ta_ut_communes_fid_commune_FK
FOREIGN KEY (fid_commune)
REFERENCES test_ta_commune(objectid);

ALTER TABLE ta_ut_communes
ADD CONSTRAINT ta_ut_communes_fid_ut_FK
FOREIGN KEY (fid_unite_territoriale)
REFERENCES ta_unite_territoriale(objectid);

-- 7. Création des index sur les clés étrangères
CREATE INDEX ta_ut_communes_fid_com_IDX ON ta_ut_communes(fid_commune)
    TABLESPACE INDX_GEO;

CREATE INDEX ta_ut_communes_fid_ut_IDX ON ta_ut_communes(fid_unite_territoriale)
    TABLESPACE INDX_GEO;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_ut_communes TO G_ADT_DSIG_ADM;