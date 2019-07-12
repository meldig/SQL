-- nombre de mise à jour par agents, mois et années
WITH
source_maj AS (
	SELECT
		lower(GEO_NMN) AS agent,
		extract(year from GEO_DM) as "année",
		extract(month from GEO_DM) as "mois",
		COUNT(GEO_DM) AS total
	FROM GEO.TA_SUR_TOPO_G
	group by
		extract(year from GEO_DM),
		extract(month from GEO_DM),
		GEO_NMN
	UNION
	SELECT
		lower(GEO_NMN) AS agent,
		extract(year from GEO_DM) as "année",
		extract(month from GEO_DM) as "mois",
		COUNT(GEO_DM) AS total
	FROM GEO.TA_LIG_TOPO_G
	group by
		extract(year from GEO_DM),
		extract(month from GEO_DM),
		GEO_NMN
	),

source_creation AS (
	SELECT
		lower(GEO_NMS) AS agent,
		extract(year from GEO_DS) as "année",
		extract(month from GEO_DS) as "mois",
		COUNT(GEO_DS) AS total
	FROM GEO.TA_SUR_TOPO_G
	group by
		extract(year from GEO_DS),
		extract(month from GEO_DS),
		GEO_NMS
	UNION
	SELECT
		lower(GEO_NMS) AS agent,
		extract(year from GEO_DS) as "année",
		extract(month from GEO_DS) as "mois",
		COUNT(GEO_DS) AS total
	FROM GEO.TA_LIG_TOPO_G
	group by
		extract(year from GEO_DS),
		extract(month from GEO_DS),
		GEO_NMS
	),

fusion AS (
	SELECT 'modification' AS type, agent, "année", "mois", total FROM source_maj
	UNION
	SELECT 'création' AS type, agent, "année", "mois", total FROM source_creation
)

SELECT
	type,
	agent,
	"année",
	"mois",
	SUM(total) AS total_maj
FROM fusion
GROUP BY type, agent, "année", "mois"
ORDER BY type, agent, "année", "mois" DESC
