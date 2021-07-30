-- CREATION DE LA VUE G_OSM.VM_OSM_POINT.
-- Vue proposant les elements OSM points et centroids(point on surface) des polygones actuellement disponible sur le territoire de la MEL

--1. CREATION DE LA VUE MATERIALISEE .
CREATE MATERIALIZED VIEW G_OSM.VM_OSM_POINT
										(
											OBJECTID,
											CATEGORIE,
											VALEUR,
											CATEGORIE_QUANTITATIVE,
											VALEUR_QUANTITATIVE,
											NOM_SOURCE,
											GEOM
										)

USING INDEX
TABLESPACE G_AST_INDEX
REFRESH ON DEMAND
DISABLE QUERY REWRITE AS

-- SELECTION DES ELEMENTS POINTS.
-- SELECTTION DES ATTRIBUTS QUALITATIFS DE LA TABLE TA_OSM_CARACTERISTIQUE.
SELECT
	a.objectid AS OBJECTID,
	b.key AS CATEGORIE,
	b.valeur AS VALEUR,
	NULL AS CATEGORIE_QUANTITATIVE,
	NULL AS VALEUR_QUANTITATIVE,
	m.nom_source || ' - ' || o.nom_organisme || ' - ' || p.MILLESIME || ' ' || 'POINT OSM' AS source,
    d.GEOM AS GEOM
FROM
	G_OSM.TA_OSM a
	INNER JOIN G_OSM.TA_OSM_CARACTERISTIQUE b ON b.fid_osm = a.objectid
    INNER JOIN G_OSM.TA_OSM_RELATION_POINT_GEOM c ON c.fid_osm = a.objectid
    INNER JOIN G_OSM.TA_OSM_POINT_GEOM d ON d.objectid = c.fid_osm_point_geom
	INNER JOIN G_GEO.TA_METADONNEE l ON l.objectid = a.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE m ON m.objectid = l.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME n ON n.fid_metadonnee = l.objectid
    INNER JOIN G_GEO.TA_ORGANISME o ON o.objectid = n.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION p ON p.objectid = l.fid_acquisition
WHERE
	EXTRACT(YEAR from p.date_acquisition)=TO_CHAR(sysdate, 'yyyy')
UNION ALL
-- SELECTTION DES ATTRIBUTS QUANTITATIFS DE LA TABLE TA_OSM_CARACTERISTIQUE_QUANTITATIVE.
SELECT
	a.objectid AS OBJECTID,
	NULL AS CATEGORIE,
	NULL AS VALEUR,
	b.key AS CATEGORIE_QUANTITATIVE,
	b.valeur AS VALEUR_QUANTITATIVE,
	m.nom_source || ' - ' || o.nom_organisme || ' - ' || p.MILLESIME || ' ' || 'POINT OSM' AS source,
    d.GEOM AS GEOM
FROM
	G_OSM.TA_OSM a
	INNER JOIN G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE b ON b.fid_osm = a.objectid
    INNER JOIN G_OSM.TA_OSM_RELATION_POINT_GEOM c ON c.fid_osm = a.objectid
    INNER JOIN G_OSM.TA_OSM_POINT_GEOM d ON d.objectid = c.fid_osm_point_geom
	INNER JOIN G_GEO.TA_METADONNEE l ON l.objectid = a.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE m ON m.objectid = l.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME n ON n.fid_metadonnee = l.objectid
    INNER JOIN G_GEO.TA_ORGANISME o ON o.objectid = n.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION p ON p.objectid = l.fid_acquisition
WHERE
	EXTRACT(YEAR from p.date_acquisition)=TO_CHAR(sysdate, 'yyyy')
-- SELECTION DES CENTROIDS (POINT ON SURFACE) DES ELEMENTS MULTIPOLYGONS.
-- SELECTTION DES ATTRIBUTS QUALITATIFS DE LA TABLE TA_OSM_CARACTERISTIQUE.
UNION ALL
SELECT
	a.objectid AS OBJECTID,
	b.key AS CATEGORIE,
	b.valeur AS VALEUR,
	NULL AS CATEGORIE_QUANTITATIVE,
	NULL AS VALEUR_QUANTITATIVE,
	m.nom_source || ' - ' || o.nom_organisme || ' - ' || p.MILLESIME || ' ' || 'CENTROID MULTIPOLYGONES OSM' AS source,
    SDO_GEOM.SDO_POINTONSURFACE(d.GEOM, mtdt.diminfo) AS GEOM
FROM
	G_OSM.TA_OSM a
	INNER JOIN G_OSM.TA_OSM_CARACTERISTIQUE b ON b.fid_osm = a.objectid
    INNER JOIN G_OSM.TA_OSM_RELATION_GEOM c ON c.fid_osm = a.objectid
    INNER JOIN G_OSM.TA_OSM_GEOM d ON d.objectid = c.fid_osm_geom
	INNER JOIN G_GEO.TA_METADONNEE l ON l.objectid = a.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE m ON m.objectid = l.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME n ON n.fid_metadonnee = l.objectid
    INNER JOIN G_GEO.TA_ORGANISME o ON o.objectid = n.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION p ON p.objectid = l.fid_acquisition,
    USER_SDO_GEOM_METADATA mtdt
WHERE
	EXTRACT(YEAR from p.date_acquisition)=TO_CHAR(sysdate, 'yyyy')
AND
	mtdt.table_name = 'TA_OSM_GEOM'
AND
	mtdt.column_name = 'GEOM'
UNION ALL
-- SELECTTION DES ATTRIBUTS QUANTITATIFS DE LA TABLE TA_OSM_CARACTERISTIQUE_QUANTITATIVE.
SELECT
	a.objectid AS OBJECTID,
	NULL AS CATEGORIE,
	NULL AS VALEUR,
	b.key AS CATEGORIE_QUANTITATIVE,
	b.valeur AS VALEUR_QUANTITATIVE,
	m.nom_source || ' - ' || o.nom_organisme || ' - ' || p.MILLESIME || ' ' || 'CENTROID MULTIPOLYGONES OSM' AS source,
    SDO_GEOM.SDO_POINTONSURFACE(d.GEOM, mtdt.diminfo) AS GEOM
FROM
	G_OSM.TA_OSM a
	INNER JOIN G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE b ON b.fid_osm = a.objectid
    INNER JOIN G_OSM.TA_OSM_RELATION_GEOM c ON c.fid_osm = a.objectid
    INNER JOIN G_OSM.TA_OSM_GEOM d ON d.objectid = c.fid_osm_geom
	INNER JOIN G_GEO.TA_METADONNEE l ON l.objectid = a.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE m ON m.objectid = l.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME n ON n.fid_metadonnee = l.objectid
    INNER JOIN G_GEO.TA_ORGANISME o ON o.objectid = n.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION p ON p.objectid = l.fid_acquisition,
    USER_SDO_GEOM_METADATA mtdt
WHERE
	EXTRACT(YEAR from p.date_acquisition)=TO_CHAR(sysdate, 'yyyy')
AND
	mtdt.table_name = 'TA_OSM_GEOM'
AND
	mtdt.column_name = 'GEOM'
	;

-- 2. CREATION DES COMMENTAIRES DE LA VUE ET DES COLONNES.
COMMENT ON MATERIALIZED VIEW G_OSM.VM_OSM_POINT IS 'Vue proposant les elements OSM points et centroids(point on surface) des polygones actuellement disponible sur le territoire de la MEL';
COMMENT ON COLUMN G_OSM.VM_OSM_POINT.OBJECTID IS 'Identifiant de l''element OSM dans la base';
COMMENT ON COLUMN G_OSM.VM_OSM_POINT.CATEGORIE IS 'KEY OSM. Mot clé dans la terminologie OSM. EXEMPLE: AMENITY';
COMMENT ON COLUMN G_OSM.VM_OSM_POINT.VALEUR IS 'Valeur que peut prendre une clé OSM. EXEMPLE: PARKING';
COMMENT ON COLUMN G_OSM.VM_OSM_POINT.CATEGORIE_QUANTITATIVE IS 'KEY OSM. Mot clé dans la terminologie OSM. EXEMPLE: CAPACITY';
COMMENT ON COLUMN G_OSM.VM_OSM_POINT.VALEUR_QUANTITATIVE IS 'Valeur que peut prendre une catégorie quantitative OSM.  EXEMPLE: 32';
COMMENT ON COLUMN G_OSM.VM_OSM_POINT.NOM_SOURCE IS 'Source de la donnée avec l''organisme créateur de la source.';
COMMENT ON COLUMN G_OSM.VM_OSM_POINT.GEOM IS 'Geometrie de l''element OSM: POINT ou CENTROID MULTIPOLYGONE';


-- 3. CREATION DES METADONNEES SPATIALES.
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'VM_OSM_POINT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 4. CREATION DE L'INDEX SPATIAL.
CREATE INDEX VM_OSM_POINT_SIDX
ON G_OSM.VM_OSM_POINT(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POINT, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);