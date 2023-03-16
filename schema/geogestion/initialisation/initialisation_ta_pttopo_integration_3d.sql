-- Insertion des données dans la table TA_PTTOPO_INTEGRATION_3D
-- mise à 3d avec la colonne ALT des points topo. Si ALT est NULL à lors mise à 0 de l'altitude.
MERGE INTO G_GESTIONGEO.TA_PTTOPO_INTEGRATION_3D a
USING
	(
	WITH CTE AS
		(
		SELECT
		    a.objectid AS OBJECTID,
		    a.FID_NUMERO_DOSSIER AS FID_NUMERO_DOSSIER,
		    a.MAT AS MAT,
		    COALESCE(a.alt,0) AS ALT,
	        a.geom AS GEOM
		FROM 
		    G_GESTIONGEO.TA_PTTOPO_INTEGRATION a
		)
	SELECT
		cte.objectid AS OBJECTID,
		cte.FID_NUMERO_DOSSIER AS FID_NUMERO_DOSSIER,
	    cte.MAT AS MAT,
	    cte.ALT,
	    SDO_GEOMETRY(3001, 2154,
	    SDO_POINT_TYPE(cte.GEOM.sdo_point.x,cte.GEOM.sdo_point.y,cte.alt),
	    NULL, NULL) AS GEOM
	FROM
	    cte cte
	) b
ON (a.OBJECTID = b.OBJECTID)
WHEN NOT MATCHED THEN
INSERT (a.OBJECTID, a.FID_NUMERO_DOSSIER, a.MAT, a.ALT, a.GEOM)
VALUES (b.OBJECTID, b.FID_NUMERO_DOSSIER, b.MAT, b.ALT, b.GEOM)
;
