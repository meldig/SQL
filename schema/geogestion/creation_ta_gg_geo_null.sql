CREATE VIEW GEO.V_GG_GEO_PROBLEM AS
-- dossiers (non-IC) sans équivalent géométrique
SELECT DISTINCT
  a.DOS_NUM,
	c.FAM_LIB,
	'présent dans ta_gg_dossier mais sans équivalent dans ta_gg_geo' AS motif
FROM GEO.TA_GG_DOSSIER a
LEFT JOIN (SELECT DISTINCT DOS_NUM FROM TA_GG_GEO) b ON a.DOS_NUM = b.DOS_NUM
JOIN GEO.TA_GG_FAMILLE c ON c.FAM_ID = a.FAM_ID
WHERE
  b.DOS_NUM IS NULL
  AND a.DOS_NUM IS NOT NULL
UNION
-- dossiers (non-IC) où la géométrie est égale à 0
SELECT DISTINCT
	geo.DOS_NUM,
	c.FAM_LIB,
	'surface égale à 0' AS motif
FROM GEO.TA_GG_GEO geo
JOIN GEO.TA_GG_DOSSIER a ON a.DOS_NUM = geo.DOS_NUM
JOIN GEO.TA_GG_FAMILLE c ON c.FAM_ID = a.FAM_ID
WHERE
	geo.GEOM.sdo_gtype IN (2003,2007) AND
	SDO_GEOM.SDO_AREA(geo.GEOM, 1) = 0
ORDER BY DOS_NUM;

COMMENT ON TABLE "GEO"."V_GG_GEO_PROBLEM" IS 'affiche les dossiers dont la géométrie est inexistante ou inexploitable';
