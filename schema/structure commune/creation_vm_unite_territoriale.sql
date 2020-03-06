/*
Création de la vue matérialisée des Unités Territoriales (faite à partir de l'aggrégation des communes) quand la MEL se composait de 90 communes.
*/

/*
DROP MATERIALIZED VIEW g_referentiel.adm_unite_territoriale_mel90;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'adm_unite_territoriale_mel90';
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW g_referentiel.adm_unite_territoriale_mel90(
    identifiant,
    entite,
    nom_a,
    nom_b,
    nom_c,
    geom,
    surf_km2,
    source
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
WITH
    v_fusion_ut AS( -- Sélection de toutes les données relatives aux unités territoriales
    SELECT
        LOWER(e.nom)AS nom_a,
        SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom,
        ROUND(SDO_GEOM.SDO_AREA(SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)), 0.005, 'unit=SQ_KILOMETER'), 2) AS surf_km2
    FROM
        g_geo.ta_commune a
        INNER JOIN g_geo.ta_za_communes b ON a.objectid = b.fid_commune
        INNER JOIN g_geo.ta_zone_administrative c ON b.fid_zone_administrative = c.objectid
        INNER JOIN g_geo.ta_libelle d ON c.fid_libelle = d.objectid
        INNER JOIN g_geo.ta_nom e ON c.fid_nom = e.objectid
    
    WHERE
        d.libelle = 'Unité Territoriale'
        AND b.debut_validite = '01/01/2017'
        AND b.fin_validite = '31/12/2019'
    GROUP BY e.nom
        ),
    
    v_selection_source AS( --Sélection de la source des communes utilisées pour faire les unités territoriales et des types d'entités
    SELECT DISTINCT
        CONCAT(CONCAT(CONCAT(CONCAT(j.acronyme, ' - '), g.nom_source), ' - '),  EXTRACT(YEAR FROM h.millesime))AS source,
        k.libelle AS entite
    FROM
        g_geo.ta_commune a
        INNER JOIN g_geo.ta_za_communes b ON a.objectid = b.fid_commune
        INNER JOIN g_geo.ta_metadonnee f ON a.fid_metadonnee = f.objectid
        INNER JOIN g_geo.ta_source g ON f.fid_source = g.objectid
        INNER JOIN g_geo.ta_date_acquisition h ON f.fid_acquisition = h.objectid
        INNER JOIN g_geo.ta_organisme j ON f.fid_organisme = j.objectid,
        g_geo.ta_libelle k
    WHERE
        b.debut_validite = '01/01/2017'
        AND b.fin_validite = '31/12/2019'
        AND k.libelle = 'Unité Territoriale'
    )

SELECT -- Regroupement des précédentes sélections dans une seule sélection + création d'une clé primaire + type d'entité
    rownum AS identifiant,
    b.entite,
    a.nom_a,
    '' AS nom_b,
    '' AS nom_c,
    a.geom,
    a.surf_km2,
    b.source
FROM
    v_fusion_ut a,
    v_selection_source b
    ;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'adm_unite_territoriale_mel90',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW adm_unite_territoriale_mel90 
ADD CONSTRAINT adm_unite_territoriale_mel90_PK 
PRIMARY KEY (IDENTIFIANT);

-- 4. Création de l'index spatial
CREATE INDEX adm_unite_territoriale_mel90_SIDX
ON adm_unite_territoriale_mel90(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW g_referentiel.adm_unite_territoriale_mel90 IS 'Vue matérialisée proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel90.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel90.entite IS 'Type d''entité de chaque enregistrement.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel90.nom_a IS 'Libellé long des Unités Territoriales en minuscule.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel90.nom_b IS 'Etiquette format intermédiaire.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel90.nom_c IS 'Etiquette format court.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel90.geom IS 'Géométrie de chaque Unités Territoriales.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel90.surf_km2 IS 'Surface de chaque commune, municipalité en km² arrondie à deux decimales.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel90.source IS 'Source de la donnée avec l''organisme créateur, la source et son millésime.';

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC
GRANT SELECT ON adm_unite_territoriale_mel90 TO G_REFERENTIEL_LEC;

/*
Création de la vue matérialisée des Unités Territoriales (faite à partir de l'aggrégation des communes) actuelles.
*/

/*
DROP MATERIALIZED VIEW g_referentiel.adm_unite_territoriale_mel;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'adm_unite_territoriale_mel';
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW g_referentiel.adm_unite_territoriale_mel(
    identifiant,
    entite,
    nom_a,
    nom_b,
    nom_c,
    geom,
    surf_km2,
    source
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
WITH
    v_fusion_ut AS( -- Sélection de toutes les données relatives aux unités territoriales
SELECT 
    LOWER(e.nom)AS nom_a,
    SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom,
    ROUND(SDO_GEOM.SDO_AREA(SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)), 0.005, 'unit=SQ_KILOMETER'), 2) AS surf_km2
FROM
    g_geo.ta_commune a
    INNER JOIN g_geo.ta_za_communes b ON a.objectid = b.fid_commune
    INNER JOIN g_geo.ta_zone_administrative c ON b.fid_zone_administrative = c.objectid
    INNER JOIN g_geo.ta_libelle d ON c.fid_libelle = d.objectid
    INNER JOIN g_geo.ta_nom e ON c.fid_nom = e.objectid
WHERE
    d.libelle = 'Unité Territoriale'
    AND sysdate BETWEEN b.debut_validite AND b.fin_validite
GROUP BY e.nom
    ),

v_selection_source AS( --Sélection de la source des communes utilisées pour faire les unités territoriales
SELECT DISTINCT
    CONCAT(CONCAT(CONCAT(CONCAT(j.acronyme, ' - '), g.nom_source), ' - '),  EXTRACT(YEAR FROM h.millesime))AS source,
    k.libelle AS entite
FROM
    g_geo.ta_commune a
    INNER JOIN g_geo.ta_za_communes b ON a.objectid = b.fid_commune
    INNER JOIN g_geo.ta_zone_administrative c ON b.fid_zone_administrative = c.objectid
    INNER JOIN g_geo.ta_nom d ON c.fid_nom = d.objectid
    INNER JOIN g_geo.ta_metadonnee f ON a.fid_metadonnee = f.objectid
    INNER JOIN g_geo.ta_source g ON f.fid_source = g.objectid
    INNER JOIN g_geo.ta_date_acquisition h ON f.fid_acquisition = h.objectid
    INNER JOIN g_geo.ta_organisme j ON f.fid_organisme = j.objectid,
    g_geo.ta_libelle k
WHERE
    d.acronyme = 'MEL'
    AND sysdate BETWEEN b.debut_validite AND b.fin_validite
    AND k.libelle = 'Unité Territoriale'
    
)

SELECT -- Regroupement des précédentes sélections dans une seule sélection + création d'une clé primaire 
    rownum AS identifiant,
    b.entite,
    a.nom_a,
    '' AS nom_b,
    '' AS nom_c,
    a.geom,
    a.surf_km2,
    b.source
FROM
    v_fusion_ut a,
    v_selection_source b;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'adm_unite_territoriale_mel',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW adm_unite_territoriale_mel 
ADD CONSTRAINT adm_unite_territoriale_mel_PK 
PRIMARY KEY (IDENTIFIANT);

-- 4. Création de l'index spatial
CREATE INDEX adm_unite_territoriale_mel_SIDX
ON adm_unite_territoriale_mel(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW g_referentiel.adm_unite_territoriale_mel IS 'Vue matérialisée proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel.entite IS 'Type d''entité de chaque enregistrement.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel.nom_a IS 'Libellé long des Unités Territoriales en minuscule.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel.nom_b IS 'Etiquette format intermédiaire.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel.nom_c IS 'Etiquette format court.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel.geom IS 'Géométrie de chaque Unités Territoriales.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel.surf_km2 IS 'Surface de chaque commune, municipalité en km² arrondie à deux decimales.';
COMMENT ON COLUMN g_referentiel.adm_unite_territoriale_mel.source IS 'Source de la donnée avec l''organisme créateur, la source et son millésime.';

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC
GRANT SELECT ON adm_unite_territoriale_mel TO G_REFERENTIEL_LEC;