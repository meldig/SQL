/*
Les ilôts sont utilisés par les photo-interprétes pour suivre l'avancé de leur travail sur une commune. Pour l'instant, tout se fait via une table ta_gestion_ilot_g sans rien d'automatisé concernant la mise à jour des géométries, de leur validités, etc.
*/

-- désactivation des ilôts
UPDATE GEO.TA_GESTION_ILOT_G a
SET GEO_ON_VALIDE = 1
WHERE EXISTS (
	SELECT
		b.OBJECTID
	FROM
		GEO.TA_SUR_TOPO_G b
	WHERE
 		b.CLA_INU = 213
		AND a.OBJECTID = b.OBJECTID
		AND b.GEO_ON_VALIDE = 1
);

-- mise à jour des géométries d'ilots
-- insertion des ilôts présents dan la table d'origine sans équivalent dans la copie
MERGE INTO GEO.TA_GESTION_ILOT_G a
USING (
	select
		b.OBJECTID, b.CLA_INU, b.GEO_REF, b.GEO_INSEE, b.GEOM, b.GEO_DV, b.GEO_DF, b.GEO_ON_VALIDE, b.GEO_TEXTE, b.GEO_TYPE, b.GEO_NMN, b.GEO_DS, b.GEO_NMS, b.GEO_DM
	from GEO.TA_SUR_TOPO_G b
	where b.CLA_INU = 213 AND GEO_ON_VALIDE = 0
	) b
ON (a.OBJECTID = b.OBJECTID)
WHEN MATCHED THEN
  UPDATE SET GEOM = b.GEOM
WHEN NOT MATCHED THEN
	INSERT (a.OBJECTID, a.CLA_INU, a.GEO_REF, a.GEO_INSEE, a.GEOM, a.GEO_DV, a.GEO_DF, a.GEO_ON_VALIDE, a.GEO_TEXTE, a.GEO_TYPE, a.GEO_NMN, a.GEO_DS, a.GEO_NMS, a.GEO_DM)
	VALUES (b.OBJECTID, b.CLA_INU, b.GEO_REF, b.GEO_INSEE, b.GEOM, b.GEO_DV, b.GEO_DF, b.GEO_ON_VALIDE, b.GEO_TEXTE, b.GEO_TYPE, b.GEO_NMN, b.GEO_DS, b.GEO_NMS, b.GEO_DM)
	WHERE b.GEO_ON_VALIDE = 0;

-- changement d'état d'avancée par commune
UPDATE GEO.TA_GESTION_ILOT_G a
SET GEO_ON_VALIDE = 0
WHERE EXISTS (
	SELECT
		b.OBJECTID
	FROM
		GEO.TA_GESTION_ILOT_G b,
		GEO.LM_COMMUNES c
	WHERE
		SDO_ANYINTERACT (b.GEOM, c.GEOM) = 'TRUE'
		AND (c.INSEE = '59636' OR c.INSEE = '59317' OR c.INSEE = '59017')
		AND a.OBJECTID = b.OBJECTID
);

-- suppression des obsolètes


-- comparaison des doublons
WITH source AS (
SELECT
  OBJECTID,
	count(OBJECTID) AS nbr
FROM
  GEO.TA_GESTION_ILOT_G a
GROUP BY OBJECTID
)

SELECT
  a.OBJECTID,
	nbr
FROM
  source a
WHERE nbr > 1

-- supprimer de la gestion d'ilots ceux désactivés dans la table source
SELECT a.OBJECTID
FROM GEO.TA_GESTION_ILOT_G a, GEO.TA_SUR_TOPO_G b
WHERE b.GEO_ON_VALIDE = 1 AND a.OBJECTID = b.OBJECTID
