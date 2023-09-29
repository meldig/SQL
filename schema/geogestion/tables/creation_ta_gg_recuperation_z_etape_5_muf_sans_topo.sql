
CREATE TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO
    (	
    OBJECTID NUMBER(38,0),
    FID_NUMERO_DOSSIER NUMBER(38,0), 
  	OBJECTID_ELEMENT NUMBER, 
  	OBJECTID_SOMMET NUMBER, 
  	COORD_X NUMBER, 
  	COORD_Y NUMBER, 
  	COORD_Z NUMBER, 
  	GEOM SDO_GEOMETRY
    )
;

-- 5.2. Création de la contrainte d'unité
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO_OBJECTID_OBJECTID_ELEMENT_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID","OBJECTID_ELEMENT","OBJECTID_SOMMET");



-- 5.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO  IS  'Table temporaire utilisée pour sommet des polygones des murs qui ne croisent pas de point topographique';

-- 5.4. Création des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO.OBJECTID IS 'Identifiant de l'' objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO.OBJECTID_ELEMENT IS 'Identifiant du sous élément de l'' objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de l'' objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO.COORD_X IS 'Coordonnée X du sommet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO.COORD_Y IS 'Coordonnée Y du sommet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO.COORD_Z IS 'Coordonnée Z du sommet';

-- 1.1.5. Création des métadonnées spatiales
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME ='TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO';
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005),SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005),SDO_DIM_ELEMENT('Z', -100, 100, 0.005)),
    2154
);
COMMIT;

-- 1.1.6. Création des index
-- 1.1.6.1. Création de l'index spatial sur le champ geom
CREATE INDEX TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO_SIDX
ON G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 2.1.6.2. Création d'un index sur le champ FID_IDENTIFIANT_TYPE
CREATE INDEX TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO_OBJECTID_IDX ON G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO(OBJECTID) TABLESPACE G_ADT_INDX;

/
