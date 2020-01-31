/*
La table test_ta_commune regroupe toutes les communes de la MEL.
*/

-- 1. Création de la table test_ta_commune
CREATE TABLE test_ta_commune(
    objectid NUMBER(38,0),
    insee NUMBER(38,0),
    nom_com VARCHAR2(255),
    geom SDO_GEOMETRY,
    fid_source NUMBER(38,0),
    fid_lib_type_commune NUMBER(38,0),
    fid_validite NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE test_ta_commune IS 'Table rassemblant tous les contours communaux de la MEL.';
COMMENT ON COLUMN geo.test_ta_commune.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN geo.test_ta_commune.insee IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN geo.test_ta_commune.nom_com IS 'Nom complet de chaque commune.';
COMMENT ON COLUMN geo.test_ta_commune.geom IS 'Géométrie de chaque commune.';
COMMENT ON COLUMN geo.test_ta_commune.fid_source IS 'Clé étrangère permettant de retrouver la source à partir de laquelle la donnée est issue - ta_source.';
COMMENT ON COLUMN geo.test_ta_commune.fid_lib_type_commune IS 'Clé étrangère permettant de connaître le statut de la commune - ta_libelle.';
COMMENT ON COLUMN geo.test_ta_commune.fid_validite IS 'Clé étrangère permettant de connaître la date de début et de fin de validité d''une donnée - ta_validite.';

-- 3. Création de la clé primaire
ALTER TABLE test_ta_commune 
ADD CONSTRAINT test_ta_commune_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_test_ta_commune
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_test_ta_commune
BEFORE INSERT ON test_ta_commune
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_test_ta_commune.nextval;
END;

-- 6. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'test_ta_commune',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 7. Création de l'index spatial sur le champ geom
CREATE INDEX test_ta_commune_SIDX
ON test_ta_commune(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=INDX_GEO, work_tablespace=DATA_TEMP');

-- 8. Création des clés étrangères
ALTER TABLE test_ta_commune
ADD CONSTRAINT test_ta_commune_fid_source_FK 
FOREIGN KEY (fid_source)
REFERENCES ta_source(objectid);

ALTER TABLE test_ta_commune
ADD CONSTRAINT test_ta_commune_fid_lib_FK
FOREIGN KEY (fid_lib_type_commune)
REFERENCES ta_libelle(objectid);

ALTER TABLE test_ta_commune
ADD CONSTRAINT test_ta_commune_fid_valid_FK
FOREIGN KEY (fid_validite)
REFERENCES ta_validite(objectid);

-- 9. Création des index sur les clés étrangères
CREATE INDEX test_ta_commune_fid_source_IDX ON test_ta_commune(fid_source)
    TABLESPACE INDX_GEO;

CREATE INDEX test_ta_commune_fid_lib_IDX ON test_ta_commune(fid_lib_type_commune)
    TABLESPACE INDX_GEO;

CREATE INDEX test_ta_commune_fid_valid_IDX ON test_ta_commune(fid_validite)
    TABLESPACE INDX_GEO;

-- 10. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.test_ta_commune TO G_ADT_DSIG_ADM;