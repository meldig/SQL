/*
Création de la table regroupant les Territoires actuels à partir des communes de la Mel actuelle et de la BdTopo la plus récente.
*/

-- 1. Création de la table
CREATE TABLE G_REFERENTIEL.ADMIN_TERRITOIRE_MEL(
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
        INNER JOIN G_GEO.TA_ZA_COMMUNES b ON a.objectid = b.fid_commune
        INNER JOIN G_GEO.TA_ZONE_ADMINISTRATIVE c ON b.fid_zone_administrative = c.objectid
        INNER JOIN G_GEO.TA_LIBELLE d ON c.fid_libelle = d.objectid
        INNER JOIN G_GEO.TA_LIBELLE_LONG e ON d.fid_libelle_long = e.objectid
        INNER JOIN G_GEO.TA_NOM f ON c.fid_nom = f.objectid
        INNER JOIN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE g ON c.objectid = g.fid_zone_administrative
        INNER JOIN G_GEO.TA_CODE h ON g.fid_identifiant = h.objectid
    WHERE
        UPPER(e.valeur) = UPPER('Territoire')
        AND sysdate BETWEEN b.debut_validite AND b.fin_validite
GROUP BY 
    f.valeur, 
    c.objectid, 
    h.valeur
;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE G_REFERENTIEL.ADMIN_TERRITOIRE_MEL IS 'Table proposant les Unités Territoriales de la MEL.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_TERRITOIRE_MEL.identifiant IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_TERRITOIRE_MEL.code_adm IS 'Code unique de chaque unité territoriale (CODTER).';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_TERRITOIRE_MEL.nom IS 'Nom des Unités Territoriales.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_TERRITOIRE_MEL.geom IS 'Géométrie de chaque Unité Territoriale.';

-- 3. Création des métadonnées spatiales
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
COMMIT;

-- 4. Création de la clé primaire
ALTER TABLE G_REFERENTIEL.ADMIN_TERRITOIRE_MEL 
ADD CONSTRAINT ADMIN_TERRITOIRE_MEL_PK 
PRIMARY KEY (IDENTIFIANT);

-- 5. Création des indexes
-- 5.1. Création de l'index spatial
CREATE INDEX ADMIN_TERRITOIRE_MEL_SIDX
ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5.2. Création des indexes non-spatiaux
CREATE INDEX ADMIN_TERRITOIRE_MEL_CODE_ADM_IDX ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL(CODE_ADM)
    TABLESPACE G_ADT_INDX; 
CREATE INDEX ADMIN_TERRITOIRE_MEL_NOM_IDX ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL(NOM)
    TABLESPACE G_ADT_INDX;

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_REFERENTIEL_LEC et aux administrateurs
GRANT SELECT ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL TO G_REFERENTIEL_LEC;
GRANT SELECT ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL TO G_REFERENTIEL_MAJ;
GRANT SELECT ON G_REFERENTIEL.ADMIN_TERRITOIRE_MEL TO G_ADMIN_SIG;