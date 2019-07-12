-- dossiers créés dans la journée
SELECT
	"NOMUSU",
	COUNT("NOMUSU") AS NBR
FROM GEO.TA_GG_DOSSIER
JOIN "ANNU"."POPULATIONS" ON TA_GG_DOSSIER.USER_ID = POPULATIONS.CODPOP
WHERE "DOS_DC" >= trunc(sysdate)
ORDER BY "DOS_DC"
ORDER BY "NBR" DESC

-- dossiers créés dans le mois courant
SELECT
	"NOMUSU",
	COUNT("NOMUSU") AS NBR
FROM GEO.TA_GG_DOSSIER
JOIN "ANNU"."POPULATIONS" ON TA_GG_DOSSIER.USER_ID = POPULATIONS.CODPOP
WHERE
  extract(year from DOS_DC) = extract(year from sysdate) AND
  extract(month from DOS_DC) = extract(month from sysdate)
GROUP BY "NOMUSU"
ORDER BY "NBR" DESC
