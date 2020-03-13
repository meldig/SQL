/*
Création de la vue matérialisée des Unités Territoriales (faite à partir de l'aggrégation des communes) quand la MEL se composait de 90 communes.
*/

/*
DROP MATERIALIZED VIEW g_referentiel.admin_unite_territoriale_mel90;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'admin_unite_territoriale_mel90';
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW g_referentiel.admin_unite_territoriale_mel90(
    identifiant,
    nom,
    geom
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
SELECT
    c.objectid AS identifiant,
    e.nom AS nom_a,
    SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom
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
GROUP BY e.nom, c.objectid
;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'admin_unite_territoriale_mel90',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW admin_unite_territoriale_mel90 
ADD CONSTRAINT admin_unite_territoriale_mel90_PK 
PRIMARY KEY (IDENTIFIANT);

-- 4. Création de l'index spatial
CREATE INDEX admin_unite_territoriale_mel90_SIDX
ON admin_unite_territoriale_mel90(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW g_referentiel.admin_unite_territoriale_mel90 IS 'Vue matérialisée proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN g_referentiel.admin_unite_territoriale_mel90.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN g_referentiel.admin_unite_territoriale_mel90.nom IS 'Nom des Unités Territoriales.';
COMMENT ON COLUMN g_referentiel.admin_unite_territoriale_mel90.geom IS 'Géométrie de chaque Unité Territoriale.';

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC et aux administrateurs
GRANT SELECT ON admin_unite_territoriale_mel90 TO G_REFERENTIEL_LEC;
GRANT SELECT ON admin_unite_territoriale_mel90 TO G_ADMIN_SIG;

/*
Création de la vue matérialisée des Unités Territoriales (faite à partir de l'aggrégation des communes) actuelles.
*/

/*
DROP MATERIALIZED VIEW g_referentiel.admin_unite_territoriale_mel;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'admin_unite_territoriale_mel';
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW g_referentiel.admin_unite_territoriale_mel(
    identifiant,
    nom,
    geom
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
SELECT
        c.objectid AS identifiant,
        e.nom AS nom_a,
        SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom
    FROM
        g_geo.ta_commune a
        INNER JOIN g_geo.ta_za_communes b ON a.objectid = b.fid_commune
        INNER JOIN g_geo.ta_zone_administrative c ON b.fid_zone_administrative = c.objectid
        INNER JOIN g_geo.ta_libelle d ON c.fid_libelle = d.objectid
        INNER JOIN g_geo.ta_nom e ON c.fid_nom = e.objectid
    
    WHERE
        d.libelle = 'Unité Territoriale'
        AND sysdate BETWEEN b.debut_validite AND b.fin_validite
GROUP BY e.nom, c.objectid
;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'admin_unite_territoriale_mel',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW admin_unite_territoriale_mel 
ADD CONSTRAINT admin_unite_territoriale_mel_PK 
PRIMARY KEY (IDENTIFIANT);

-- 4. Création de l'index spatial
CREATE INDEX admin_unite_territoriale_mel_SIDX
ON admin_unite_territoriale_mel(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW g_referentiel.admin_unite_territoriale_mel IS 'Vue matérialisée proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN g_referentiel.admin_unite_territoriale_mel.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN g_referentiel.admin_unite_territoriale_mel.nom IS 'Nom des Unités Territoriales.';
COMMENT ON COLUMN g_referentiel.admin_unite_territoriale_mel.geom IS 'Géométrie de chaque Unité Territoriale.';

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC et aux administrateurs
GRANT SELECT ON admin_unite_territoriale_mel TO G_REFERENTIEL_LEC;
GRANT SELECT ON admin_unite_territoriale_mel TO G_ADMIN_SIG;