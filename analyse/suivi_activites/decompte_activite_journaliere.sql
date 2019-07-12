-- suivi de l'activité journalière
WITH
-- nombre de mise à jours par utilisateur depuis le début de la journée
source_surface_maj AS (
	SELECT
	  'surfaces mises à jour' AS "type",
	  GEO_NMN,
	  COUNT(GEO_DM) AS TOTAL
	FROM GEO.TA_SUR_TOPO_G
	WHERE GEO_DM >= trunc(sysdate)
	GROUP BY GEo_NMN),
source_ligne_maj AS (
	SELECT
	  'lignes mises à jour' AS "type",
	  GEO_NMN,
	  COUNT(GEO_DM) AS TOTAL
	FROM GEO.TA_LIG_TOPO_G
	WHERE GEO_DM >= trunc(sysdate)
	GROUP BY GEO_NMN),

-- nombre de création par utilisateur depuis le début de la journée
source_surface_creation AS (
	SELECT
	  'surfaces créées' AS "type",
	  GEO_NMS,
	  COUNT(GEO_DS) AS TOTAL
	FROM GEO.TA_SUR_TOPO_G
	WHERE GEO_DS >= trunc(sysdate)
	GROUP BY GEo_NMS),
source_ligne_creation AS (
	SELECT
	  'lignes créées' AS "type",
	  GEO_NMS,
	  COUNT(GEO_DS) AS TOTAL
	FROM GEO.TA_LIG_TOPO_G
	WHERE GEO_DS >= trunc(sysdate)
	GROUP BY GEO_NMS),

-- fusion des sources pour pouvoir faire un simple tri sur le total par la suite
fusion AS (
	SELECT * FROM source_surface_maj
	UNION ALL
	SELECT * FROM source_ligne_maj
	UNION
	SELECT * FROM source_surface_creation
	UNION ALL
	SELECT * FROM source_ligne_creation)

SELECT * FROM fusion
order by total DESC
