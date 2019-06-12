-- nombre de mise à jour dans le mois courant
WITH
source_maj AS (
	SELECT
		lower(GEO_NMN) AS agent,
		COUNT(GEO_DM) AS total
	FROM GEO.TA_SUR_TOPO_G
	WHERE
		extract(year from GEO_DM) = extract(year from sysdate) AND
	  extract(month from GEO_DM) = extract(month from sysdate)
	group by GEO_NMN
	UNION
	SELECT
		lower(GEO_NMN) AS agent,
		COUNT(GEO_DM) AS total
	FROM GEO.TA_LIG_TOPO_G
	WHERE
		extract(year from GEO_DM) = extract(year from sysdate) AND
		extract(month from GEO_DM) = extract(month from sysdate)
	group by GEO_NMN
),

-- nombre de création sur un mois
source_creation AS (
	SELECT
		lower(GEO_NMS) AS agent,
		COUNT(GEO_DS) AS total
	FROM GEO.TA_SUR_TOPO_G
	WHERE
		extract(year from GEO_DS) = extract(year from sysdate) AND
		extract(month from GEO_DS) = extract(month from sysdate)
	group by GEO_NMS
	UNION
	SELECT
		lower(GEO_NMS) AS agent,
		COUNT(GEO_DS) AS total
	FROM GEO.TA_LIG_TOPO_G
	WHERE
		extract(year from GEO_DS) = extract(year from sysdate) AND
		extract(month from GEO_DS) = extract(month from sysdate)
	group by GEO_NMS
	),

fusion AS (
	SELECT 'modification' AS type,agent, total FROM source_maj
	UNION
	SELECT 'création' AS type, agent, total FROM source_creation
)

SELECT
	type,
	agent,
	SUM(total) AS total_maj
FROM fusion
GROUP BY type, agent
ORDER BY TYPE, total_maj DESC
