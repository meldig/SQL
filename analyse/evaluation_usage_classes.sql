-- évalution du nombre de géométries valides par classes CLA_INU
WITH
source AS (
SELECT
	CLA_INU,
	COUNT(CLA_INU) AS nbr
FROM "GEO"."TA_SUR_TOPO_G"
WHERE GEO_ON_VALIDE = '0'
GROUP BY CLA_INU
)

SELECT
  source.CLA_INU,
  TA_CLASSE.CLA_LI,
	source.nbr
FROM source
JOIN GEO.TA_CLASSE ON TA_CLASSE.CLA_INU = source.CLA_INU
ORDER BY nbr DESC;
