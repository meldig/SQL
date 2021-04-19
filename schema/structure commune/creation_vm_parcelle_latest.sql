/*
Cette vue matérialisée a pour objectif de présenter les parcelles les plus récentes issues d'EDIGEO.
Il est inutile de présenter d'utiliser ici un filtre sur les données puisque le schéma S_EDIGEO est complètement vidé avant chaque mise à jour.
*/

-- 1. Création de la vue matéralisée
CREATE MATERIALIZED VIEW "G_DGFIP"."VM_PARCELLE_LATEST"
	(
	NUMERO_IDU,
	CODE_INSEE,
	PREFIXE,
	SECTION, 
	NUMERO_PARCELLE,
	CLA_INU,
	GEOM
	) AS 
SELECT 
  p.ID_PAR AS NUMERO_IDU,
  p.ID_COM AS CODE_INSEE,
  p.PRE AS PREFIXE,
  p.SECTION AS SECTION,
  p.PARCELLE AS NUMERO_PARCELLE,
  CAST(21 as number(8,0)) AS CLA_INU,
  p.GEOM AS GEOM
FROM 
	S_EDIGEO.PARCELLE p
;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'VM_PARCELLE_LATEST',
    'GEOM',
    SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('X', 684540, 719822.2, 0.005), MDSYS.SDO_DIM_ELEMENT('Y', 7044212, 7078072, 0.005)),
    2154
);


-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW G_DGFIP.VM_PARCELLE_LATEST
ADD CONSTRAINT VM_PARCELLE_LATEST_PK 
PRIMARY KEY (NUMERO_IDU);

-- 4. Création de l'index spatial
CREATE INDEX VM_PARCELLE_LATEST_SIDX
ON G_DGFIP.VM_PARCELLE_LATEST (GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW G_DGFIP.VM_PARCELLE_LATEST  IS 'Vue matérialisée proposant les parcelles actuelles sur le périmètre de la MEL.';
COMMENT ON COLUMN G_DGFIP.VM_PARCELLE_LATEST.NUMERO_IDU IS 'Clé primaire de chaque parcelle obtenue via la concaténation du CODE_INSEE + PREFIXE + SECTION + NUMERO_PARCELLE.';
COMMENT ON COLUMN G_DGFIP.VM_PARCELLE_LATEST.CODE_INSEE IS 'Code INSEE de la parcelle sur 5 caractères.';
COMMENT ON COLUMN G_DGFIP.VM_PARCELLE_LATEST.PREFIXE IS 'Préfixe de la section cadastrale de la parcelle sur 3 caractères.';
COMMENT ON COLUMN G_DGFIP.VM_PARCELLE_LATEST.SECTION IS 'Section cadastrale de la parcelle sur 2 caractères.';
COMMENT ON COLUMN G_DGFIP.VM_PARCELLE_LATEST.NUMERO_PARCELLE IS 'Numéro de la parcelle sur 4 caractères.';
COMMENT ON COLUMN G_DGFIP.VM_PARCELLE_LATEST.CLA_INU IS 'Le CLA_INU est un identifiant permettant de catégoriser les objets en faisant référence à la table GEO.TA_CLASSE. En l''occurrence il s''agit ici du CLA_INU des parcelles.';
COMMENT ON COLUMN G_DGFIP.VM_PARCELLE_LATEST.GEOM IS 'Géométrie de l''objet de type polygone.';