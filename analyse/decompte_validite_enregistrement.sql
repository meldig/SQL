-- décompte par état de validité de l'enregistrement (0 = valide)
SELECT
  'surfaces' AS type_geom,
	GEO_ON_VALIDE,
  COUNT(OBJECTID)
FROM
 GEO.TA_SUR_TOPO_G
GROUP BY GEO_ON_VALIDE
UNION
SELECT
  'lignes' AS type_geom,
	GEO_ON_VALIDE,
  COUNT(OBJECTID)
FROM
 GEO.TA_LIG_TOPO_G
GROUP BY GEO_ON_VALIDE
