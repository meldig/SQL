/*
La table ta_source permet de rassembler toutes les données sources provenant d'une source extérieure à la MEL.
*/

-- 1. Création de la table ta_source
CREATE TABLE ta_source(
    objectid NUMBER(38,0),
    nom_source VARCHAR2(4000),
    fid_organisme NUMBER(38,0),
    fid_date_acquisition NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_source IS 'Table rassemblant toutes les sources des données utilisées par la MEL.';
COMMENT ON COLUMN geo.ta_source.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN geo.ta_source.nom_source IS 'Nom de la source des données.';
COMMENT ON COLUMN geo.ta_source.fid_organisme IS 'Clé étrangère permettant de connaître l''organisme créateur de la donnée - ta_organisme.';
COMMENT ON COLUMN geo.ta_source.fid_date_acquisition IS 'Clé étrangère permettant de connaître la date d''acquisition de la donnée - ta_acquisition.';

-- 3. Création de la clé primaire
ALTER TABLE ta_source 
ADD CONSTRAINT ta_source_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_source
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_source
BEFORE INSERT ON ta_source
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_source.nextval;
END;

-- 6. Création des clés étrangères
ALTER TABLE ta_source
ADD CONSTRAINT ta_source_fid_organisme_FK
FOREIGN KEY (fid_organisme)
REFERENCES ta_organisme(objectid);

ALTER TABLE ta_source
ADD CONSTRAINT ta_source_fid_date_acquis_FK
FOREIGN KEY (fid_date_acquisition)
REFERENCES ta_acquisition(objectid);

-- 7. Création des index sur les clés étrangères
CREATE INDEX ta_source_fid_organisme_IDX ON ta_source(fid_organisme)
    TABLESPACE INDX_GEO;

CREATE INDEX ta_source_fid_date_acquis_IDX ON ta_source(fid_date_acquisition)
    TABLESPACE INDX_GEO;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_source TO G_ADT_DSIG_ADM;