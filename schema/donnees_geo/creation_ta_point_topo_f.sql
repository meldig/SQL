-- TA_POINT_TOPO_F:
/*
Table regroupant l'ensemble des géométries de la table GEO@cudl.TA_POINT_TOPO_F.
Cette table est necessaire pour créer la vue matérialisée G_GEO@multi.VM_POINT_RTGE afin de rendre disponible les données de la table GEO@☺cudl.TA_POINT_TOPO_F à travers GEOSERVER.
*/

-- 1. Creation de la table TA_POINT_TOPO_F.
CREATE TABLE G_GEO.TA_POINT_TOPO_F
	(
    IDENTIFIANT_OBJET NUMBER(38,0),
    IDENTIFIANT_TYPE NUMBER(8,0),
    CODE_TYPE CHAR(6 BYTE),
    LIBELLE_TYPE VARCHAR2(100 BYTE),
    LONGUEUR NUMBER(8,0),
    LARGEUR NUMBER(8,0),
    ORIENTATION NUMBER(5,2),
    DATE_MAJ DATE,
    GEOM SDO_GEOMETRY
    )
;


-- 2. Creation du commentaire de la table.
COMMENT ON MATERIALIZED VIEW G_GEO.TA_POINT_TOPO_F IS 'Table qui présente les points contenus dans la table G_GEO@cudl.TA_POINT_TOPO_F';


-- 3. Creation des commentaires des colonnes.
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.IDENTIFIANT_OBJET IS 'Identifiant interne de l''objet geographique - Cle primaire de la table';
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.IDENTIFIANT_TYPE IS 'Identifiant de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.CODE_TYPE IS 'Nom court de la classe a laquelle appartient l''objet';
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.LIBELLE_TYPE IS 'Libelle de la classe de l''objet';
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.LONGUEUR IS 'Longueur de l''objet (en cm)';
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.LARGEUR IS 'Largeur de l''objet (en cm)';
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.ORIENTATION IS 'Orientation de l''objet (en degre)';
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.DATE_MAJ IS 'Date de deniere modification de l''objet';
COMMENT ON COLUMN G_GEO.TA_POINT_TOPO_F.GEOM IS 'Geometrie de l''objet - type point';


-- 4. Creation de la clé primaire.
ALTER TABLE G_GEO.TA_POINT_TOPO_F
ADD CONSTRAINT TA_POINT_TOPO_F_PK 
PRIMARY KEY("IDENTIFIANT_OBJET")
USING INDEX TABLESPACE "G_ADT_INDX";


-- 5. Metadonnee
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_POINT_TOPO_F',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 680041, 724322, 0.005),SDO_DIM_ELEMENT('Y', 7039713, 7082570, 0.005),SDO_DIM_ELEMENT('Z', -999, 999, 0.005)),
    2154
);
COMMIT;


-- 6. Création de l'index spatial sur le champ geom
CREATE INDEX G_GEO.TA_POINT_TOPO_F_SIDX
ON G_GEO.TA_POINT_TOPO_F(GEOM) 
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS ('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 7. INDEX
-- 7.1. Sur le champ IDENTIFIANT_TYPE.
CREATE INDEX TA_POINT_TOPO_F_IDENTIFIANT_TYPE_IDX ON G_GEO.TA_POINT_TOPO_F(IDENTIFIANT_TYPE)
    TABLESPACE G_ADT_INDX;

-- 7.2. Sur le champ IDENTIFIANT_TYPE.
CREATE INDEX TA_POINT_TOPO_F_CODE_TYPE_IDX ON G_GEO.TA_POINT_TOPO_F(CODE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 7.3. Sur le champ IDENTIFIANT_TYPE.
CREATE INDEX TA_POINT_TOPO_F_LIBELLE_TYPE_IDX ON G_GEO.TA_POINT_TOPO_F(LIBELLE_TYPE)
    TABLESPACE G_ADT_INDX;

-- 8. Droits
GRANT SELECT, UPDATE, INSERT, DELETE ON G_GEO.TA_POINT_TOPO_F TO G_GEO_MAJ;
GRANT SELECT ON G_GEO.TA_POINT_TOPO_F TO G_GEO_LEC;