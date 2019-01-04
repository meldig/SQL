-- décompte par année de début de validité
SELECT
  EXTRACT(YEAR FROM GEO_DV) AS "year",
  COUNT(GEO_DV) AS "total_debut_validite"
FROM GEO.TA_SUR_TOPO_G
GROUP BY EXTRACT(YEAR FROM GEO_DV)
ORDER BY "year" ASC;

-- décompte par année de fin de validité
SELECT
  EXTRACT(YEAR FROM GEO_DF) AS "year",
  COUNT(GEO_DF) AS "total_fin_validite"
FROM GEO.TA_SUR_TOPO_G
GROUP BY EXTRACT(YEAR FROM GEO_DF)
ORDER BY "year" ASC;
