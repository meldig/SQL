/*
La vue matérialisée vm_unite_territoriale permet à l'utilisateur d'utiliser les unités territoriales dont les communes qui les composent sont en core en cours de validité. 
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW vm_unite_territoriale(
	id_ut,
	nom_ut,
	geom
)
SELECT
	a.objectid,
	a.nom_ut,
	SDO_AGGR_UNION(
		SDOAGGRTYPE(
			b.geom,
			0.005
		)
	) AS geom

FROM
	ta_ut_communes c
	INNER JOIN ta_commune b
	ON b.objectid = c.fid_commune
	INNER JOIN ta_unite_territoriale a
	ON a.objectid = c.fid_unite_territoriale
	INNER JOIN ta_validite d
	ON d.objectid = a.fid_validite
WHERE
	sysdate BETWEEN d.debut_validite AND d.fin_validite;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'vm_unite_territoriale',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

ALTER MATERIALIZED VIEW 
  vm_unite_territoriale 
ADD CONSTRAINT 
  vm_unite_territoriale_PK 
PRIMARY KEY (INSEE)
DISABLE;

CREATE INDEX vm_unite_territoriale_SIDX
ON vm_unite_territoriale(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=INDX_GEO, 
  work_tablespace=DATA_TEMP'
);