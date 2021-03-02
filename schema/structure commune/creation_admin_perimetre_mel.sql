/*
Création du périmètre actuel de la MEL à partir de la BdTopo la plus récente.
*/

CREATE TABLE G_REFERENTIEL.ADMIN_PERIMETRE_MEL(IDENTIFIANT, NOM, GEOM)
SELECT
        c.objectid AS identifiant,
        f.valeur AS nom_a,
        SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.005)) AS geom
    FROM
        g_geo.TA_COMMUNE a
        INNER JOIN g_geo.TA_ZA_COMMUNES b ON b.fid_commune = a.objectid
        INNER JOIN g_geo.TA_ZONE_ADMINISTRATIVE c ON c.objectid = b.fid_zone_administrative
        INNER JOIN g_geo.TA_LIBELLE d ON d.objectid = c.fid_libelle
        INNER JOIN g_geo.TA_LIBELLE_long e ON e.objectid = d.fid_libelle_long
        INNER JOIN g_geo.TA_NOM f ON f.objectid = c.fid_nom
    
    WHERE
        UPPER(e.valeur) = UPPER('Métropole')
        AND UPPER(f.acronyme) = UPPER('MEL')
        AND sysdate BETWEEN b.debut_validite AND b.fin_validite
GROUP BY f.valeur, c.objectid;

-- 2. Création des commentaires
COMMENT ON TABLE G_REFERENTIEL.ADMIN_PERIMETRE_MEL IS 'Table du périmètre de la MEL provenant de l''IGN français avec une géométrie de type polygone. La donnée est issue de la fusion des communes de la MEL actuelle, à partir de la BdTopo la plus récente.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_PERIMETRE_MEL.IDENTIFIANT IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_PERIMETRE_MEL.NOM IS 'Nom de l''établissement publique de coopération intercommunal.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_PERIMETRE_MEL.GEOM IS 'Géométrie de l''objet.';

-- 3. 
ALTER TABLE G_REFERENTIEL.ADMIN_PERIMETRE_MEL 
ADD CONSTRAINT ADMIN_PERIMETRE_MEL_PK 
PRIMARY KEY (identifiant);

-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA (
  TABLE_NAME, 
  COLUMN_NAME, 
  DIMINFO, 
  SRID
)
VALUES (
  'admin_perimetre_mel',
  'geom', 
  SDO_DIM_ARRAY(
    SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),
    SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)
  ),
  2154
);
COMMIT;

-- 5. Création de l'index spatial
CREATE INDEX ADMIN_PERIMETRE_MEL_SIDX
ON G_REFERENTIEL.ADMIN_PERIMETRE_MEL(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 6. Don du droit de lecture de la TABLE aux schémas G_REFERENTIEL_LEC et G_REFERENTIEL_MAJ ainsi qu'aux administrateurs
GRANT SELECT ON G_REFERENTIEL.ADMIN_PERIMETRE_MEL TO G_REFERENTIEL_LEC;
GRANT SELECT ON G_REFERENTIEL.ADMIN_PERIMETRE_MEL TO G_REFERENTIEL_MAJ;
GRANT SELECT ON G_REFERENTIEL.ADMIN_PERIMETRE_MEL TO G_ADMIN_SIG;