/*
Création de la vue matérialisée des communes bdtopo 2019 IGN
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW g_referentiel.vm_communes_ign_2019 (
	nom,
    code_insee,
	code_postal,
    geom,
    source,
    millesime
)

REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
 WITH
 v_code_insee AS(
    SELECT
        a.fid_commune,
        b.code AS code_insee,
        d.nom,
        c.geom,
        f.nom_source AS source,
        EXTRACT(YEAR FROM g.millesime) AS millesime
    FROM
        g_geo.ta_identifiant_commune a
        INNER JOIN g_geo.ta_code b ON a.fid_identifiant = b.objectid
        INNER JOIN g_geo.ta_commune c ON a.fid_commune = c.objectid
        INNER JOIN g_geo.ta_nom d ON c.fid_nom = d.objectid
        INNER JOIN g_geo.ta_metadonnee e ON c.fid_metadonnee = e.objectid
        INNER JOIN g_geo.ta_source f ON e.fid_source = f.objectid
        INNER JOIN g_geo.ta_date_acquisition g ON e.fid_acquisition = g.objectid
    WHERE
        b.fid_libelle = 1
        AND EXTRACT(YEAR FROM g.millesime) = 2019
    ),
    
    v_code_postal AS(
    SELECT
        a.fid_commune,
        b.code AS code_postal
    FROM
        g_geo.ta_identifiant_commune a
        INNER JOIN g_geo.ta_code b ON a.fid_identifiant = b.objectid
    WHERE
        b.fid_libelle = 2
    )
    SELECT
        a.nom,
        a.code_insee,
        b.code_postal,
        a.geom,
        a.source,
        a.millesime
    FROM
        v_code_insee a,
        v_code_postal b 
    WHERE
        a.fid_commune = b.fid_commune;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'vm_communes_ign_2019',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

ALTER MATERIALIZED VIEW vm_communes_ign_2019
ADD CONSTRAINT vm_communes_ign_2019_PK PRIMARY KEY (code_insee)DISABLE;

CREATE INDEX vm_communes_ign_2019_SIDX
ON vm_communes_ign_2019(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

SELECT *
FROM
    USER_SDO_GEOM_METADATA a
WHERE a.table_name = 'VM_COMMUNES_IGN_2019';