  
/*
Création de la vue matérialisée des Unités Territoriales (faite à partir de l'aggrégation des communes) quand la MEL se composait de 90 communes.
*/

/*
DROP MATERIALIZED VIEW G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'ADMIN_UNITE_TERRITORIALE_MEL90';
*/

-- 1. Création de la vue matérialisée
/*CREATE MATERIALIZED VIEW G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90(
    identifiant,
    code_adm,
    nom,
    geom
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
SELECT
    c.objectid AS identifiant,
    h.valeur AS code_adm,
    e.valeur AS nom_a,
    SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom
FROM
    G_GEO.ta_commune a
    INNER JOIN G_GEO.TA_ZA_COMMUNES b ON a.objectid = b.fid_commune
    INNER JOIN G_GEO.TA_ZONE_ADMINISTRATIVE c ON b.fid_zone_administrative = c.objectid
    INNER JOIN G_GEO.TA_LIBELLE d ON c.fid_libelle = d.objectid
    INNER JOIN G_GEO.TA_LIBELLE_long e ON d.fid_libelle_long = e.objectid
    INNER JOIN G_GEO.TA_NOM f ON c.fid_nom = e.objectid
    INNER JOIN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE g ON c.objectid = g.fid_zone_administrative
    INNER JOIN G_GEO.TA_CODE h ON g.fid_identifiant = h.objectid
WHERE
    e.valeur = 'Unité Territoriale'
    AND b.debut_validite = '01/01/2017'
    AND b.fin_validite = '31/12/2019'
GROUP BY e.valeur, c.objectid, h.valeur
;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ADMIN_UNITE_TERRITORIALE_MEL90',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90 
ADD CONSTRAINT ADMIN_UNITE_TERRITORIALE_MEL90_PK 
PRIMARY KEY (IDENTIFIANT);

-- 4. Création de l'index spatial
CREATE INDEX ADMIN_UNITE_TERRITORIALE_MEL90_SIDX
ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90 IS 'Vue matérialisée proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90.code_adm IS 'Code unique de chaque unité territoriale (CODTER).';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90.nom IS 'Nom des Unités Territoriales.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90.geom IS 'Géométrie de chaque Unité Territoriale.';

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC et aux administrateurs
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90 TO G_REFERENTIEL_LEC;
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90 TO G_REFERENTIEL_MAJ;
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL90 TO G_ADT_DSIG_ADM;

/*
Création de la vue matérialisée des Unités Territoriales (faite à partir de l'aggrégation des communes) actuelles.
*/

/*
DROP MATERIALIZED VIEW G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'ADMIN_UNITE_TERRITORIALE_MEL';
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL(
    identifiant,
    code_adm,
    nom,
    geom
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
SELECT
        c.objectid AS identifiant,
        h.valeur AS code_adm,
        f.valeur AS nom_a,
        SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom
    FROM
        G_GEO.ta_commune a
        INNER JOIN G_GEO.TA_ZA_COMMUNES b ON a.objectid = b.fid_commune
        INNER JOIN G_GEO.TA_ZONE_ADMINISTRATIVE c ON b.fid_zone_administrative = c.objectid
        INNER JOIN G_GEO.TA_LIBELLE d ON c.fid_libelle = d.objectid
        INNER JOIN G_GEO.TA_LIBELLE_long e ON d.fid_libelle_long = e.objectid
        INNER JOIN G_GEO.TA_NOM f ON c.fid_nom = f.objectid
        INNER JOIN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE g ON c.objectid = g.fid_zone_administrative
        INNER JOIN G_GEO.TA_CODE h ON g.fid_identifiant = h.objectid
    WHERE
        e.valeur = 'Unité Territoriale'
        AND sysdate BETWEEN b.debut_validite AND b.fin_validite
GROUP BY f.valeur, c.objectid, h.valeur
;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ADMIN_UNITE_TERRITORIALE_MEL',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL 
ADD CONSTRAINT ADMIN_UNITE_TERRITORIALE_MEL_PK 
PRIMARY KEY (IDENTIFIANT);

-- 4. Création de l'index spatial
CREATE INDEX ADMIN_UNITE_TERRITORIALE_MEL_SIDX
ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL IS 'Vue matérialisée proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL.code_adm IS 'Code unique de chaque unité territoriale (CODTER).';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL.nom IS 'Nom des Unités Territoriales.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL.geom IS 'Géométrie de chaque Unité Territoriale.';

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC et aux administrateurs
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL TO G_REFERENTIEL_LEC;
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL TO G_REFERENTIEL_MAJ;
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL TO G_ADMIN_SIG;