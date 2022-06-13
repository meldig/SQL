/*
Création de la table regroupant les Unités Territoriales actuelles à partir des communes de la Mel actuelles et de la BdTopo la plus récente.
*/

-- 1. Création de la table
CREATE TABLE G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL(
    identifiant,
    code_adm,
    nom,
    geom
)
AS
SELECT
        c.objectid AS identifiant,
        h.valeur AS code_adm,
        f.valeur AS nom_a,
        SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom
    FROM
        G_GEO.ta_commune a
        INNER JOIN G_GEO.TA_ZA_COMMUNES b ON b.fid_commune = a.objectid
        INNER JOIN G_GEO.TA_ZONE_ADMINISTRATIVE c ON c.objectid = b.fid_zone_administrative
        INNER JOIN G_GEO.TA_LIBELLE d ON d.objectid = c.fid_libelle
        INNER JOIN G_GEO.TA_LIBELLE_LONG e ON e.objectid = d.fid_libelle_long
        INNER JOIN G_GEO.TA_NOM f ON f.objectid = c.fid_nom
        INNER JOIN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE g ON g.fid_zone_administrative = c.objectid
        INNER JOIN G_GEO.TA_CODE h ON h.objectid = g.fid_identifiant
    WHERE
        UPPER(e.valeur) = UPPER('Unité Territoriale')
        AND sysdate BETWEEN b.debut_validite AND b.fin_validite
GROUP BY 
    f.valeur, 
    c.objectid, 
    h.valeur
;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL IS 'Table proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL.code_adm IS 'Code unique de chaque unité territoriale (CODTER).';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL.nom IS 'Nom des Unités Territoriales.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL.geom IS 'Géométrie de chaque Unité Territoriale.';

-- 3. Création des métadonnées spatiales
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
COMMIT;

-- 4. Création de la clé primaire
ALTER TABLE G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL 
ADD CONSTRAINT ADMIN_UNITE_TERRITORIALE_MEL_PK 
PRIMARY KEY (IDENTIFIANT);

-- 5. Création des indexes
-- 5.1. Création de l'index spatial
CREATE INDEX ADMIN_UNITE_TERRITORIALE_MEL_SIDX
ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5.2. Création des indexes non-spatiaux
CREATE INDEX ADMIN_UNITE_TERRITORIALE_MEL_CODE_ADM_IDX ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL(CODE_ADM)
    TABLESPACE G_ADT_INDX; 
CREATE INDEX ADMIN_UNITE_TERRITORIALE_MEL_NOM_IDX ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL(NOM)
    TABLESPACE G_ADT_INDX;

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC et aux administrateurs
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL TO G_REFERENTIEL_LEC;
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL TO G_REFERENTIEL_MAJ;
GRANT SELECT ON G_REFERENTIEL.ADMIN_UNITE_TERRITORIALE_MEL TO G_ADMIN_SIG;