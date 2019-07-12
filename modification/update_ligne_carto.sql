-- désactive les lignes non-exploitables sur le périmètre d'une commune
-- attention au booléen, 1 = false

UPDATE GEO.TA_LIG_TOPO_G a
SET GEO_ON_VALIDE = 1
WHERE EXISTS (
	SELECT
		b.OBJECTID
	FROM
		GEO.TA_LIG_TOPO_G b,
		GEO.LM_COMMUNES c
	WHERE
		SDO_ANYINTERACT (b.GEOM, c.GEOM) = 'TRUE'
		AND c.INSEE = '59566'
		AND b.CLA_INU = 829
		AND a.OBJECTID = b.OBJECTID
		AND b.GEO_ON_VALIDE = 0
);
