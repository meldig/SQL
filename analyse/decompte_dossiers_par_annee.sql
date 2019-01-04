-- nombre de dossiers clôturées par années
WITH source AS (
SELECT
   EXTRACT(YEAR FROM DOS_DT_FIN) AS DATE_CLOTURE
FROM GEO.TA_GG_DOSSIER
)

SELECT
  DATE_CLOTURE,
	COUNT(DATE_CLOTURE)
FROM source
GROUP BY DATE_CLOTURE
ORDER BY DATE_CLOTURE




WITH source AS (
SELECT
   FAM_ID,
   EXTRACT(YEAR FROM DOS_DMAJ) AS DATE_MAJ
FROM GEO.TA_GG_DOSSIER
)

SELECT
  DATE_MAJ,
	FAM_ID,
	COUNT(DATE_MAJ)
FROM source
GROUP BY DATE_MAJ, FAM_ID
ORDER BY DATE_MAJ, FAM_ID
