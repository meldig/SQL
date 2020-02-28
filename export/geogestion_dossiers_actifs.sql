/*
A FAIRE
- gérer les géométries ID_GEOM ayant le même dos_num -> geom collection
- gérer les geom NULL
*/

--CREATE VIEW GEO.V_ACQ_GG_STAT_COM AS
WITH
source AS (
SELECT
  TRIM(d.NOM) AS COMMUNE,
  c.FAM_LIB AS FAMILLE,
  e.ETAT_LIB AS ETAT,
  a.DOS_NUM AS NUMERO,
  b.USER_ID,
--EXTRACT(YEAR FROM b.DOS_DC) AS annee_creation, -- invalide car incohérent avec l'année en début de code pour les dos_num d'avant geogestion
  CAST(
  CASE
			WHEN SUBSTR(b.DOS_NUM, 1, 1) = 1 THEN '20' || SUBSTR(b.DOS_NUM, 1, 2)
      WHEN SUBSTR(b.DOS_NUM, 1, 1) != 1 THEN '200' || SUBSTR(b.DOS_NUM, 1, 1)
		ELSE NULL
	END AS NUMBER) AS annee_creation,
  EXTRACT(YEAR FROM b.DOS_DMAJ) AS annee_maj,
  (SELECT LITYVOIE FROM G_SIDU.TYPEVOIE WHERE TYPEVOIE.CCODTVO = f.CCODTVO) || ' ' || f.CNOMVOI AS voie,
  replace(replace(b.DOS_RQ, CHR(13)), CHR(10), ' - ') AS COMMENTAIRE,
  a.GEOM
FROM
  GEO.LM_COMMUNES d,
  GEO.TA_GG_GEO a
JOIN GEO.TA_GG_DOSSIER b ON b.ID_DOS = a.ID_DOS
JOIN GEO.TA_GG_FAMILLE c ON c.FAM_ID = b.FAM_ID
JOIN GEO.TA_GG_ETAT e ON a.ETAT_ID = e.ETAT_ID
JOIN G_SIDU.VOIEVOI f ON b.DOS_VOIE = f.CCOMVOI
WHERE
  SDO_CONTAINS(d.geom, SDO_GEOM.SDO_CENTROID(a.geom, 2)) = 'TRUE'
  AND a.ETAT_ID != '9'
ORDER BY d.NOM, c.FAM_LIB, e.ETAT_LIB
),

source_pop AS (
SELECT
  CODPOP,
  NOMUSU
FROM ANNU.POPULATIONS
WHERE
  DATE_DEPART IS NULL
  AND societe='AGT'
)

SELECT DISTINCT
  zone.NOM_AGENT,
  COMMUNE,
  FAMILLE,
  ETAT,
  NUMERO,
  source_pop.NOMUSU AS AUTEUR,
  annee_creation,
  annee_maj,
  voie,
  COMMENTAIRE
FROM
  GEO.V_ACQ_GG_ZONAGE2 zone,
  source
LEFT JOIN source_pop ON source_pop.CODPOP = source.USER_ID
WHERE
  SDO_CONTAINS(zone.geom, SDO_GEOM.SDO_CENTROID(source.geom, 2)) = 'TRUE';
