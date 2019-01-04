/*
permet l'identification des secteurs n'étant pas couvert par des ilôts
*/

WITH
-- récupération des limites communales (non-nettoyées)
a AS (
SELECT
  LM_COMMUNES."GEOM"
FROM "GEO"."LM_COMMUNES"
),

-- intersection des limites de communes avec les tronçons de voirie
c AS(
SELECT
  SDO_GEOM.SDO_INTERSECTION(a."GEOM", b."GEOM", 1) AS GEOM
FROM a, "G_SIDU"."V_LIG_TRONCON_20" b
)

-- recherche les produits de l'intersection n'ayant pas de correspondance avec des ilôts existants
SELECT
  c.GEOM
FROM GEO."TA_SUR_TOPO_G" d, c
WHERE
  d."CLA_INU" = 213 AND
  d."GEO_ON_VALIDE" = 0 AND
  SDO_CONTAINS(c.GEOM, SDO_GEOM.SDO_CENTROID(d.GEOM, 2)) = 'TRUE';



	WITH
	-- récupération des limites communales (non-nettoyées)
	a AS (
	SELECT
	  LM_COMMUNES."GEOM"
	FROM "GEO"."LM_COMMUNES"
	),

	-- intersection des limites de communes avec les tronçons de voirie
	c AS(
	SELECT
	  SDO_GEOM.SDO_INTERSECTION(a."GEOM", b."GEOM", 1) AS GEOM
	FROM a, "G_SIDU"."ILTATRC" b
	WHERE b.CDVALTRO = 'V'
	)

	-- recherche les produits de l'intersection n'ayant pas de correspondance avec des ilôts existants
	SELECT
	  c.GEOM
	FROM GEO."TA_SUR_TOPO_G" d, c
	WHERE
	  d."CLA_INU" = 213 AND
	  d."GEO_ON_VALIDE" = 0 AND
	  SDO_CONTAINS(c.GEOM, SDO_GEOM.SDO_CENTROID(d.GEOM)) = 'TRUE';
