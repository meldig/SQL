--------------------------------------------
-- INITIALISATION_TA_PTTOPO_INTEGRATION_2 --
--------------------------------------------

-- 1.3. Insertion des données dans la table TA_PTTOPO_INTEGRATION
-- insertion sous un autre objectid des points ayant les memes objectid dans la table geo.PTTOPO@cudl
MERGE INTO G_GESTIONGEO.TA_PTTOPO_INTEGRATION a
USING
	(
		SELECT
			COALESCE(a.ALT,0) AS ALT,
			a.MAT AS MAT,
			TO_NUMBER(a.ID_DOS) AS FID_NUMERO_DOSSIER,
			a.OBJECTID AS OBJECTID,
			SDO_GEOMETRY(3001, 2154,
			    SDO_POINT_TYPE(a.GEOM.sdo_point.x,a.GEOM.sdo_point.y, COALESCE(a.ALT,0)),
			    NULL, NULL) AS GEOM,
			6068 AS FID_PNOM_CREATION,
			SYSDATE AS DATE_CREATION
		FROM
			G_GESTIONGEO.TEMP_PTTOPO a
        WHERE a.ID_DOS IN (SELECT a.OBJECTID FROM G_GESTIONGEO.TA_GG_DOSSIER a)
        AND a.GEOM IS NOT NULL
        AND OBJECTID IN (
        					SELECT
        						OBJECTID
        					FROM
        						(
        						SELECT
								    COUNT(OBJECTID),
								    OBJECTID 
								FROM 
								    TEMP_PTTOPO
								GROUP BY OBJECTID HAVING COUNT(OBJECTID) >1
        						)
        					)
	)b
ON(a.ALT = b.ALT
AND a.MAT = b.MAT
AND a.FID_NUMERO_DOSSIER = b.FID_NUMERO_DOSSIER)
WHEN NOT MATCHED THEN INSERT (a.ALT, a.MAT, a.FID_NUMERO_DOSSIER, a.GEOM, a.FID_PNOM_CREATION, a.DATE_CREATION)
VALUES (b.ALT, b.MAT, b.FID_NUMERO_DOSSIER, b.GEOM, b.FID_PNOM_CREATION, b.DATE_CREATION)
;

COMMIT;

/
