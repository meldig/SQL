/*
Décompte des actions par agent sur les 7 derniers jours du mois courant
Les objets créés sont comptés en double car leur champs de date de mise à jour est rempli avec la date de création
*/

WITH
-- décompte des surfaces créées et modifiées
source_stats_surface AS (
	SELECT
	  'surfaces créées' AS "type_action",
		GEO_NMS AS agent,
		COUNT(GEO_NMS) AS total
	FROM GEO.TA_SUR_TOPO_G
	WHERE
		GEO_DS > = (SELECT SYSDATE - 7 FROM dual)
		AND EXTRACT(YEAR FROM GEO_DS) = EXTRACT(YEAR FROM sysdate)
		AND EXTRACT(MONTH FROM GEO_DS) = EXTRACT(MONTH FROM sysdate)
  GROUP BY GEO_NMS
	UNION
	SELECT
	  'surfaces màj' AS "type_action",
		GEO_NMN AS agent,
		COUNT(GEO_NMS) AS total
	FROM GEO.TA_SUR_TOPO_G
	WHERE
		GEO_DM > = (SELECT SYSDATE - 7 FROM dual)
		AND EXTRACT(YEAR FROM GEO_DS) = EXTRACT(YEAR FROM sysdate)
		AND EXTRACT(MONTH FROM GEO_DS) = EXTRACT(MONTH FROM sysdate)
  GROUP BY GEO_NMN
	),

-- décompte des lignes créées et modifiées
source_stats_ligne AS (
	SELECT
		'lignes créées' AS "type_action",
		GEO_NMS AS agent,
		COUNT(GEO_NMS) AS total
	FROM GEO.TA_LIG_TOPO_G
	WHERE
		GEO_DS > = (SELECT SYSDATE - 7 FROM dual)
		AND EXTRACT(YEAR FROM GEO_DS) = EXTRACT(YEAR FROM sysdate)
		AND EXTRACT(MONTH FROM GEO_DS) = EXTRACT(MONTH FROM sysdate)
	GROUP BY GEO_NMS
	UNION
	SELECT
		'lignes màj' AS "type_action",
		GEO_NMN AS agent,
		COUNT(GEO_NMS) AS total
	FROM GEO.TA_LIG_TOPO_G
	WHERE GEO_DM > = (SELECT SYSDATE - 7 FROM dual)
	GROUP BY GEO_NMN
	),

-- fusion des sources pour pouvoir faire un tri sur le total par la suite (limite d'oracle)
fusion AS (
	SELECT * FROM source_stats_surface
	UNION
	SELECT * FROM source_stats_ligne
	)

SELECT
  agent,
	type_action,
  SUM(total) AS nbr
FROM fusion
GROUP BY type_action, agent
ORDER BY agent, nbr DESC
