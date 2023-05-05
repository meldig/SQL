-- Initialisation de la table TA_RTGE_MUF_START_POINT_PTTOPO

MERGE INTO G_GESTIONGEO.TA_RTGE_MUF_START_POINT_PTTOPO a
USING
	(
	SELECT
	    a.objectid AS OBJECTID_LIGNE,
	    b.objectid AS OBJECTID_PTTOPO
	FROM
	    G_GESTIONGEO.TA_RTGE_MUF_START_POINT a
	    INNER JOIN G_GESTIONGEO.TA_PTTOPO_INTEGRATION b ON SDO_EQUAL(a.geom, b.geom) = 'TRUE'
	    AND a.FID_NUMERO_DOSSIER = b.FID_NUMERO_DOSSIER
	)b
ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
AND a.OBJECTID_PTTOPO = b.OBJECTID_PTTOPO)
WHEN NOT MATCHED THEN
INSERT(a.OBJECTID_LIGNE, a.OBJECTID_PTTOPO)
VALUES(b.OBJECTID_LIGNE, b.OBJECTID_PTTOPO)
;

/
