CREATE INDEX TA_SUR_TOPO_G_DATE_MAJ_NBR_IDX ON TA_SUR_TOPO_G (GEO_NMN, GEO_DM);

CREATE INDEX TA_SUR_TOPO_G_DATE_CREATION_NBR_IDX ON TA_SUR_TOPO_G (GEO_NMS, GEO_DS) TABLESPACE INDX_GEO;;

INDX_GEO
SELECT *FROM USER_TABLESPACES

-- par type d'action, par année et par mois
WITH
source_creation AS (
	SELECT
	  'surfaces créées' AS "type",
		GEO_NMS AS agent,
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
	  'lignes créées' AS "type",
		GEO_NMS AS agent,
		extract(year from GEO_DS) as "année",
		extract(month from GEO_DS) as "mois",
		COUNT(GEO_DS) AS total
	FROM GEO.TA_LIG_TOPO_G
	group by
		extract(year from GEO_DS),
		extract(month from GEO_DS),
		GEO_NMS
	),

source_maj AS (
	SELECT
	  'surfaces màj' AS "type",
		GEO_NMN AS agent,
		extract(year from GEO_DS) as "année",
		extract(month from GEO_DS) as "mois",
		COUNT(GEO_DS) AS total
	FROM GEO.TA_SUR_TOPO_G
	group by
		extract(year from GEO_DS),
		extract(month from GEO_DS),
		GEO_NMN
	UNION
	SELECT
	  'lignes màj' AS "type",
		GEO_NMN AS agent,
		extract(year from GEO_DS) as "année",
		extract(month from GEO_DS) as "mois",
		COUNT(GEO_DS) AS total
	FROM GEO.TA_LIG_TOPO_G
	group by
		extract(year from GEO_DS),
		extract(month from GEO_DS),
		GEO_NMN
	),

-- fusion des sources pour pouvoir faire un simple tri sur le total par la suite
fusion AS (
	SELECT * FROM source_creation
	UNION
	SELECT * FROM source_maj)

SELECT 
  agent,
	SUM(total)
FROM fusion
WHERE "année" >= 2019





select extract(year from date_created) as yr, extract(month from date_created) as mon,
       sum(Num_of_Pictures)
from pictures_table
group by extract(year from date_created), extract(month from date_created)
order by yr, mon;
