/*
Création de la vue matérialisée des Territoires (faite à partir de l'aggrégation des communes actuelles).
*/

/*
DROP MATERIALIZED VIEW ADMIN_TERRITOIRE_MEL;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'ADMIN_TERRITOIRE_MEL';
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW G_REFERENTIEL.ADMIN_TERRITOIRE_MEL(
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
    INNER JOIN G_GEO.TA_LIBELLE_long e ON e.objectid = d.fid_libelle_long
    INNER JOIN G_GEO.TA_NOM f ON f.objectid = c.fid_nom
    INNER JOIN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE g ON g.fid_zone_administrative = c.objectid
    INNER JOIN G_GEO.TA_CODE h ON h.objectid = g.fid_identifiant
WHERE
    e.valeur = 'Territoire'
    AND sysdate BETWEEN b.debut_validite AND b.fin_validite
GROUP BY 
    f.valeur, 
    c.objectid, 
    h.valeur;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ADMIN_TERRITOIRE_MEL',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW ADMIN_TERRITOIRE_MEL 
ADD CONSTRAINT ADMIN_TERRITOIRE_MEL_PK 
PRIMARY KEY (IDENTIFIANT);

-- 4. Création de l'index spatial
CREATE INDEX ADMIN_TERRITOIRE_MEL_SIDX
ON ADMIN_TERRITOIRE_MEL(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW G_REFERENTIEL.ADMIN_TERRITOIRE_MEL IS 'Vue matérialisée proposant les Territoires de la MEL.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_TERRITOIRE_MEL.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_TERRITOIRE_MEL.code_adm IS 'Code unique de chaque territoire (CODTER).';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_TERRITOIRE_MEL.nom IS 'Nom des Territoires.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_TERRITOIRE_MEL.geom IS 'Géométrie de chaque Territoire.';

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC et aux administrateurs
GRANT SELECT ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL TO G_REFERENTIEL_LEC;
GRANT SELECT ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL TO G_REFERENTIEL_MAJ;
GRANT SELECT ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL TO G_ADMIN_SIG;