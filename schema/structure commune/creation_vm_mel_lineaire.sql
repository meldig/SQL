/*
Création de la vue matérialisée vm_contour_commune_ign_f qui propose les contours des communes de la MEL sous forme de ligne. Cette vue ne prend que le dernier millésime de la source BdTopo IGN français.
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW vm_contour_commune_ign_f 
USING INDEX 
TABLESPACE G_ADT_INDX 
REFRESH ON DEMAND 
FORCE  
DISABLE QUERY REWRITE AS 
WITH
    dernier_millesime AS(
        SELECT
            max(a.MILLESIME) AS m1
        FROM
            ta_acquisition a
            INNER JOIN ta_source b
            ON a.objectid = b.fid_date_acquisition
        WHERE
            b.objectid = 3
        )
SELECT
    a.insee,
    a.nom,
    SDO_UTIL.POLYGONTOLINE(a.geom) AS geom
FROM
    ta_commune a
    INNER JOIN ta_source b
    ON a.fid_source = b.objectid
    INNER JOIN ta_acquisition c
    ON b.fid_date_acquisition = c.objectid,
    dernier_millesime d
WHERE
    c.millesime = d.m1;

-- 2. Création des commentaires
COMMENT ON MATERIALIZED VIEW vm_contour_commune_ign_f IS 'Vue matérialisée des communes de la MEL provenant de l''IGN français avec une géométrie de type ligne simple.';
COMMENT ON COLUMN g_referentiel.vm_contour_commune_ign_f.insee IS 'Code INSEE de chaque commune de la MEL.';
COMMENT ON COLUMN g_referentiel.vm_contour_commune_ign_f.nom IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN g_referentiel.vm_contour_commune_ign_f.geom IS 'Géométrie de type ligne simple représentant les contours de chaque commune de la MEL.';

-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA (
  TABLE_NAME, 
  COLUMN_NAME, 
  DIMINFO, 
  SRID
)
VALUES (
  'vm_contour_commune_ign_f',
  'GEOM', 
  SDO_DIM_ARRAY(
    SDO_DIM_ELEMENT(
      'X', 
      594000, 
      964000, 
      0.005
    ),
    SDO_DIM_ELEMENT(
      'Y', 
      6987000, 
      7165000, 
      0.005
    )
  ),
  2154
);