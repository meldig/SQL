/*
La table ta_diff_carto_lidar regroupe toutes les différences de bâti entre le Lidar et le Plan de Gestion (ta_sur_topo_g).
*/

-- 1. Création des fonctions utilisées pour remplir les champs calculés. Ces fonctions sont obligatoires, car elles permettent d'obtenir des résultats déterministes, sans quoi il serait impossible de créer des indexes sur ces champs.

-- 1.1. Création de la fonction : get_aire_polygone
CREATE OR REPLACE FUNCTION get_aire_polygone(geom MDSYS.SDO_GEOMETRY) RETURN NUMBER DETERMINISTIC AS
BEGIN
    RETURN (SDO_GEOM.SDO_AREA(geom, 0.001));
END;

-- 1.2. Création de la fonction : get_perimetre
CREATE OR REPLACE FUNCTION get_perimetre(geom MDSYS.SDO_GEOMETRY) RETURN NUMBER DETERMINISTIC AS
BEGIN
    RETURN (SDO_GEOM.SDO_LENGTH(geom, 0.001));
END;

-- 2. Création de la table ta_diff_carto_lidar

CREATE TABLE ta_diff_carto_lidar(
    objectid NUMBER(38,0),
    fid_libelle NUMBER(38,0),
    geom MDSYS.SDO_GEOMETRY,
    id_carto NUMBER(38,0),
    surface NUMBER GENERATED ALWAYS AS(get_aire_polygone(geom)) VIRTUAL,
    perimetre NUMBER GENERATED ALWAYS AS(get_perimetre(geom)) VIRTUAL,
    ratio NUMBER(38,3),
    statut NUMBER(1)
);

-- 3. Création des commentaires sur la table et les champs
COMMENT ON TABLE ta_diff_carto_lidar IS 'Table rassemblant toutes les différences de bâti entre le Lidar et le plan carto.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.fid_libelle IS 'Clé étrangère indiquant si l''objet provient du plan carto ou du lidar - ta_libelle.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.geom IS 'Géométrie de chaque objet.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.id_carto IS 'Identifiant d''appartenance des objets aux bâtis du plan de gestion - TA_SUR_TOPO_G.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.surface IS 'Champ calculé à partir du champ geom indiquant la surface de chaque polygone en m².';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.perimetre IS 'Champ calculé à partir du champ geom indiquant le périmètre de chaque polygone en m.';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.ratio IS 'Ratio entre la surface et le périmètre de chaque objet distinguant les différences dues au dévers de celles dues à un problème de saisie ou à une mise à jour manquante';
COMMENT ON COLUMN geo.ta_diff_carto_lidar.statut IS 'Statut de l''objet permettant de savoir s''il a été vu, traité (1), ou pas (0).';

-- 4. Création de la clé primaire
ALTER TABLE ta_diff_carto_lidar 
ADD CONSTRAINT ta_diff_carto_lidar_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "INDX_GEO";

-- 5. Création de la séquence d'auto-incrémentation
CREATE SEQUENCE SEQ_ta_diff_carto_lidar
START WITH 1 INCREMENT BY 1;

-- 6. Création du déclencheur de la séquence permettant d'avoir une PK auto-incrémentée
CREATE OR REPLACE TRIGGER BEF_ta_diff_carto_lidar
BEFORE INSERT ON ta_diff_carto_lidar
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_ta_diff_carto_lidar.nextval;
END;

-- 7. Création des métadonnées spatiales
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

-- 8. Création de l'index spatial sur le champ geom
CREATE INDEX ta_diff_carto_lidar_SIDX
ON ta_diff_carto_lidar(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=INDX_GEO, work_tablespace=DATA_TEMP');


-- 9. Création des indexes multi-colonnes

-- 9.1. Création de l'index ta_diff_carto_lidar_idx
CREATE INDEX ta_diff_carto_lidar_IDX
ON ta_diff_carto_lidar(fid_libelle, surface, perimetre)
TABLESPACE INDX_GEO;

-- 9.2. Création de l'index ta_diff_carto_lidar_2idx
CREATE INDEX ta_diff_carto_lidar_2IDX
ON ta_diff_carto_lidar(statut, fid_libelle, ratio, surface)
TABLESPACE INDX_GEO;

