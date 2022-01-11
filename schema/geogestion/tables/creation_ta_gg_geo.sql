/*
TA_GG_GEO : Création de la table TA_GG_GEO contenant le périmètre géométrique des dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_GEO (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID.NEXTVAL NOT NULL,
    "CODE_INSEE" AS (TRIM(GET_CODE_INSEE_POLYGON(geom))),
	"SURFACE" NUMBER(38,2) AS (ROUND(SDO_GEOM.SDO_AREA(geom, 0.005, 'UNIT=SQ_METER'), 2)),
    "GEOM" MDSYS.SDO_GEOMETRY NOT NULL
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_GEO IS 'Table rassemblant les géométries des périmètres de chaque dossier créé dans GestionGeo.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.OBJECTID IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.CODE_INSEE IS 'Champ calculé permettant d''identifier le code INSEE de la commune d''appartenance du dossier via une requête spatiale sélectionnant la commune comportant le centroïde du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.SURFACE IS 'Champ calculé permettant de calculer la surface de chaque objet de la table en m².';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_GEO.GEOM IS 'Champ géométrique de la table, de type multipolygone.';

-- 3. Les métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_GG_GEO',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 4. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_GEO
ADD CONSTRAINT TA_GG_GEO_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 5. Les indexes
-- Index spatial
CREATE INDEX TA_GG_GEO_SIDX
ON G_GESTIONGEO.TA_GG_GEO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

CREATE INDEX G_GESTIONGEO."TA_GG_GEO_SURFACE_IDX" ON G_GESTIONGEO.TA_GG_GEO ("SURFACE") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_GEO_CODE_INSEE_IDX" ON G_GESTIONGEO.TA_GG_GEO ("CODE_INSEE") 
    TABLESPACE G_ADT_INDX;

-- 6. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO TO G_ADMIN_SIG;

/

