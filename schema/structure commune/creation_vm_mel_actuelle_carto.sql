/*
La vue métarialisée vm_mel_actuelle_carto permet à l'utilisateur d'utiliser les contours de la MEL dont les communes sont encore en cours de validité.
Cette vue affiche uniquement le contour de la MEL et non celui des communes.
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW vm_mel_actuelle_carto (
	insee,
	nom,
	geom
)

REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
SELECT
	a.insee,
	a.nom,
	SDO_AGGR_UNION(SDOAGGRTYPE(a.geom,0.005)) AS geom
	
FROM
	ta_commune a
	INNER JOIN ta_validite b
	ON a.fid_validite = b.objectid
WHERE
	sysdate BETWEEN b.debut_validite AND b.fin_validite;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'vm_mel_actuelle_carto',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

ALTER MATERIALIZED VIEW 
  vm_mel_actuelle_carto 
ADD CONSTRAINT 
  vm_mel_actuelle_carto_PK 
PRIMARY KEY (INSEE)
DISABLE;

CREATE INDEX vm_mel_actuelle_carto_SIDX
ON vm_mel_actuelle_carto(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=INDX_GEO, 
  work_tablespace=DATA_TEMP'
);