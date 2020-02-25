/*
Création de la table matérialisée des Unités Territoriales (faite à partir de l'aggrégation des communes)
*/

DROP MATERIALIZED VIEW g_referentiel.unite_territoriale_mel;

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW g_referentiel.unite_territoriale_mel(
	objectid,
  nom_minuscule,
  nom_majuscule,
  geom,
  aire_km2
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
WITH
    v_fusion_ut AS(
SELECT 
    LOWER(d.nom)AS nom_minuscule,
    UPPER(d.nom) AS nom_majuscule,
    SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom
FROM
    g_geo.ta_commune a
    INNER JOIN g_geo.ta_za_communes b ON a.objectid = b.fid_commune
    INNER JOIN g_geo.ta_zone_administrative c ON b.fid_zone_administrative = c.objectid
    INNER JOIN g_geo.ta_nom d ON c.fid_nom = d.objectid
WHERE
    d.nom IN('TOURCOING-ARMENTIERES', 'ROUBAIX-VILLENEUVE D''ASCQ', 'LILLE-SECLIN', 'LA BASSEE-MARCQ EN BAROEUL')
    AND sysdate BETWEEN b.debut_validite AND b.fin_validite
GROUP BY d.nom
    )
    
SELECT
    rownum AS objectid,
    a.nom_minuscule,
    a.nom_majuscule,
    a.geom,
    ROUND(SDO_GEOM.SDO_AREA(a.geom, 0.005, 'unit=SQ_KILOMETER'), 2) AS aire_km2
FROM
    v_fusion_ut a;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'unite_territoriale_mel',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW 
  unite_territoriale_mel 
ADD CONSTRAINT 
  unite_territoriale_mel_PK 
PRIMARY KEY (NOM)
DISABLE;

-- 4. Création de l'index spatial
CREATE INDEX unite_territoriale_mel_SIDX
ON unite_territoriale_mel(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW g_referentiel.unite_territoriale_mel IS 'Vue matérialisée proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN g_referentiel.unite_territoriale_mel.OBJECTID IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN g_referentiel.unite_territoriale_mel.nom_minuscule IS 'Nom des Unités Territoriales en minuscule.';
COMMENT ON COLUMN g_referentiel.unite_territoriale_mel.nom_majuscule IS 'Nom des Unités Territoriales en majuscule.';
COMMENT ON COLUMN g_referentiel.unite_territoriale_mel.GEOM IS 'Géométrie de chaque Unités Territoriales.';
COMMENT ON COLUMN g_referentiel.unite_territoriale_mel.aire_km2 IS 'Surface de chaque commune, municipalité en km² arrondie à deux decimales.';
COMMENT ON COLUMN g_referentiel.unite_territoriale_mel.SOURCE IS 'Source de la donnée avec l''organisme créateur, la source et son millésime.';