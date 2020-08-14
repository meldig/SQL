/*
La table ta_commune regroupe toutes les communes de la MEL.
*/

-- 1. Création de la table ta_commune
CREATE TABLE g_geo.ta_commune(
    objectid NUMBER(38,0)GENERATED ALWAYS AS IDENTITY,
    geom SDO_GEOMETRY,
    fid_lib_type_commune NUMBER(38,0),
    fid_nom NUMBER(38,0),
    fid_metadonnee NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_commune IS 'Table rassemblant tous les contours communaux de la MEL et leur équivalent belge.';
COMMENT ON COLUMN g_geo.ta_commune.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_commune.geom IS 'Géométrie de chaque commune ou équivalent international.';
COMMENT ON COLUMN g_geo.ta_commune.fid_lib_type_commune IS 'Clé étrangère permettant de connaître le statut de la commune ou équivalent international - ta_libelle.';
COMMENT ON COLUMN g_geo.ta_commune.fid_nom IS 'Clé étrangère de la table TA_NOM permettant de connaître le nom de chaque commune ou équivalent international.';
COMMENT ON COLUMN g_geo.ta_commune.fid_metadonnee IS 'Clé étrangère permettant de retrouver la source à partir de laquelle la donnée est issue - ta_source.';

-- 3. Création de la clé primaire
ALTER TABLE g_geo.ta_commune 
ADD CONSTRAINT ta_commune_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_commune',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX ta_commune_SIDX
ON g_geo.ta_commune(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 6. Création des clés étrangères
ALTER TABLE g_geo.ta_commune
ADD CONSTRAINT ta_commune_fid_source_FK 
FOREIGN KEY (fid_source)
REFERENCES g_geo.ta_source(objectid);

ALTER TABLE g_geo.ta_commune
ADD CONSTRAINT ta_commune_fid_lib_type_commune_FK
FOREIGN KEY (fid_lib_type_commune_type_commune)
REFERENCES g_geo.ta_libelle(objectid);

ALTER TABLE g_geo.ta_commune
ADD CONSTRAINT ta_commune_fid_nom_FK
FOREIGN KEY (fid_nom)
REFERENCES g_geo.ta_nom(objectid);

ALTER TABLE g_geo.ta_commune
ADD CONSTRAINT ta_commune_fid_metadonnee_FK
FOREIGN KEY (fid_metadonnee)
REFERENCES g_geo.ta_metadonnee(objectid);

-- 7. Création des index sur les clés étrangères
CREATE INDEX ta_commune_fid_source_IDX ON g_geo.ta_commune(fid_source)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_commune_fid_lib_type_commune_IDX ON g_geo.ta_commune(fid_lib_type_commune)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_commune_fid_nom_IDX ON g_geo.ta_commune(fid_nom)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_commune_fid_metadonnee_IDX ON g_geo.ta_commune(fid_metadonnee)
    TABLESPACE G_ADT_INDX;


-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_commune TO G_ADT_DSIG_ADM;