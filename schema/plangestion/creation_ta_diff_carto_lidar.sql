/*
La table ta_diff_carto_lidar regroupe toutes les différences de bâti entre le Lidar et le Plan de Gestion.
*/

-- 1. Création de la table ta_diff_carto_lidar

CREATE TABLE ta_diff_carto_lidar(
    objectid NUMBER(38,0),
    fid_libelle NUMBER(38,0),
    geom MDSYS.SDO_GEOMETRY,
    id_carto NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_diff_carto_lidar IS 'Table rassemblant toutes les différences de bâti entre le Lidar et le plan carto.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.fid_libelle IS 'Clé étrangère indiquant si l''objet provient du plan carto ou du lidar - ta_libelle.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.geom IS 'Géométrie de chaque objet.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.id_carto IS 'Identifiant d''appartenance des objets aux bâtis du plan de gestion - TA_SUR_TOPO_G.';

-- 3. Création de la clé primaire
ALTER TABLE ta_diff_carto_lidar 
ADD CONSTRAINT ta_diff_carto_lidar_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_diff_carto_lidar
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_diff_carto_lidar
BEFORE INSERT ON ta_diff_carto_lidar
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_diff_carto_lidar.nextval;
END;

-- 6. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_diff_carto_lidar',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 7. Création de l'index spatial sur le champ geom
CREATE INDEX ta_diff_carto_lidar_SIDX
ON ta_diff_carto_lidar(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=INDX_GEO, work_tablespace=DATA_TEMP');

-- 8. Création de la fonction servant à calculer l'aire de chaque objet
CREATE OR REPLACE FUNCTION get_aire_polygone(geom MDSYS.SDO_GEOMETRY) RETURN NUMBER DETERMINISTIC AS
BEGIN
    RETURN (SDO_GEOM.SDO_AREA(geom, 0.001));
END;

-- 9. Création de l'index multi-colonnes avec expression
CREATE INDEX ta_diff_carto_lidar_IDX
ON ta_diff_carto_lidar(fid_libelle, get_aire_polygone(geom))
TABLESPACE INDX_GEO;