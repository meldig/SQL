-- Création de la table libelles

CREATE TABLE libelles(
    objectid NUMBER(38,0),
    type_libelle VARCHAR2(20),
    valeur VARCHAR2(255)
);

ALTER TABLE libelles ADD CONSTRAINT libelles_PK PRIMARY KEY("OBJECTID") USING INDEX TABLESPACE "INDX_G_MOBILITE";

COMMENT ON TABLE libelles IS 'Table de libellés des points d''intérêts utilisés dans le plan de déplacement piéton. Lien avec la table points_interet';
COMMENT ON COLUMN g_mobilite.libelles.objectid IS 'Identifiant autoincrémenté de chaque libellé.';
COMMENT ON COLUMN g_mobilite.libelles.type_libelle IS 'Catégories de libellé.';
COMMENT ON COLUMN g_mobilite.libelles.valeur IS 'Libellé de chaque point d''intérêt dont la géométrie se situe dans la table points_interet.';

CREATE SEQUENCE SEQ_libelles
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER BEF_libelles
BEFORE INSERT ON libelles
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_libelles.nextval;
END;


-- Création de la table points_interet

CREATE TABLE points_interet(
    objectid NUMBER(38,0),
    id_libelle NUMBER(38,0),
    date_saisie DATE,
    date_maj DATE,
    geom SDO_GEOMETRY
);

ALTER TABLE points_interet ADD CONSTRAINT points_interet_PK PRIMARY KEY("OBJECTID") USING INDEX TABLESPACE "INDX_G_MOBILITE";

COMMENT ON TABLE points_interet IS 'Table regroupant la géométrie de tous les points d''intérêts utilisés dans le plan de déplacement piéton.';
COMMENT ON COLUMN g_mobilite.points_interet.objectid IS 'Identifiant autoincrémenté de chaque point d''intérêt.';
COMMENT ON COLUMN g_mobilite.points_interet.id_libelle IS 'Clé étrangère permettant de faire la liaison avec la table libelles.';
COMMENT ON COLUMN g_mobilite.points_interet.date_saisie IS 'Date de création de l''objet.';
COMMENT ON COLUMN g_mobilite.points_interet.date_maj IS 'Date de mise à jour de l''objet.';

INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'points_interet',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

CREATE INDEX points_interet_SIDX
ON points_interet(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=INDX_G_MOBILITE , work_tablespace=DATA_TEMP');

CREATE SEQUENCE SEQ_points_interet
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER BEF_points_interet
BEFORE INSERT ON points_interet
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_libelles.nextval;
END;


-- Création de la table troncons

CREATE TABLE troncons(
    objectid NUMBER(38,0),
    fid_ligtrc NUMBER(38,0) NOT NULL,
    fid_megatrc NUMBER(38,0),
    geom SDO_GEOMETRY,
    date_saisie DATE,
    date_maj DATE
);

ALTER TABLE troncons ADD CONSTRAINT troncons_PK PRIMARY KEY("OBJECTID") USING INDEX TABLESPACE "INDX_G_MOBILITE";

COMMENT ON TABLE troncons IS 'Table regroupant toutes les géométries des tronçons utilisés dans le plan de déplacement piéton.';
COMMENT ON COLUMN g_mobilite.troncons.objectid IS 'Identifiant autoincrémenté de chaque point d''intérêt.';
COMMENT ON COLUMN g_mobilite.troncons.fid_ligtrc IS 'Clé étrangère faisant le lien avec la table ILTATRC du schéma g_sidu.';
COMMENT ON COLUMN g_mobilite.troncons.fid_megatrc IS 'Clé étrangère faisant le lien avec la table mega_troncons.';
COMMENT ON COLUMN g_mobilite.troncons.geom IS 'géométrie de l''objet de type ligne simple.';
COMMENT ON COLUMN g_mobilite.troncons.date_saisie IS 'Date de création de l''objet.';
COMMENT ON COLUMN g_mobilite.troncons.date_maj IS 'Date de mise à jour de l''objet.';

INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'troncons',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

CREATE INDEX troncons_SIDX
ON troncons(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=LINE, tablespace=INDX_G_MOBILITE , work_tablespace=DATA_TEMP');

CREATE SEQUENCE SEQ_troncons
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER BEF_troncons
BEFORE INSERT ON troncons
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_troncons.nextval;
END;


-- Création de la table mega_troncons

CREATE TABLE mega_troncons(
    objectid NUMBER(38,0),
    valeur_temps NUMBER(38,2),
    date_saisie DATE,
    date_maj DATE
);

ALTER TABLE mega_troncons ADD CONSTRAINT "mega_troncons_PK" PRIMARY KEY ("OBJECTID") USING INDEX TABLESPACE "INDX_G_MOBILITE";

COMMENT ON TABLE mega_troncons IS 'Table regroupant les méga-tronçons utilisés dans le plan de déplacement piéton, c''est-à-dire que chaque méga-tronçon = la fusion de tous les tronçcons entre deux points d''intérêts.';
COMMENT ON COLUMN g_mobilite.mega_troncons.objectid IS 'Identifiant autoincrémenté de chaque point d''intérêt.';
COMMENT ON COLUMN g_mobilite.mega_troncons.valeur_temps IS 'Temps nécessaire pour parcourir chaque méga_tronçon à pied.';
COMMENT ON COLUMN g_mobilite.mega_troncons.date_saisie IS 'Date de création de l''objet.';
COMMENT ON COLUMN g_mobilite.mega_troncons.date_maj IS 'Date de mise à jour de l''objet.';

CREATE SEQUENCE SEQ_mega_troncons
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER BEF_mega_troncons
BEFORE INSERT ON mega_troncons
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_mega_troncons.nextval;
END;