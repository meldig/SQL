-- décompte par état de validité de l'enregistrement
SELECT
  GEO_ON_VALIDE,
  COUNT(OBJECTID)
FROM
 GEO.TA_SUR_TOPO_G
GROUP BY GEO_ON_VALIDE;
