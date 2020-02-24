/*
Création de la table matérialisée des Unités Territoriales (faite à partir de l'aggrégation des communes)
*/

DROP MATERIALIZED VIEW g_referentiel.vm_unite_territoriale;

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW g_referentiel.vm_unite_territoriale(
	nom_minuscule,
    geom
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
SELECT 
    LOWER(d.nom)AS nom_minuscule,
    UPPER(d.nom) AS nom_majuscule,
    SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom,
    ROUND(SDO_GEOM.SDO_AREA(geom, 0.005, 'unit=SQ_KILOMETER'), 2) AS aire_km2,
FROM
    g_geo.ta_commune a
    INNER JOIN g_geo.ta_za_communes b ON a.objectid = b.fid_commune
    INNER JOIN g_geo.ta_zone_administrative c ON b.fid_zone_administrative = c.objectid
    INNER JOIN g_geo.ta_nom d ON c.fid_nom = d.objectid
WHERE
    d.nom IN('TOURCOING-ARMENTIERES', 'ROUBAIX-VILLENEUVE D''ASCQ', 'LILLE-SECLIN', 'LA BASSEE-MARCQ EN BAROEUL')
GROUP BY d.nom;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'vm_unite_territoriale',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW 
  vm_unite_territoriale 
ADD CONSTRAINT 
  vm_unite_territoriale_PK 
PRIMARY KEY (NOM)
DISABLE;

-- 4. Création de l'index spatial
CREATE INDEX vm_unite_territoriale_SIDX
ON vm_unite_territoriale(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);