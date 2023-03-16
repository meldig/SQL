-- 2.3. Insertion des données dans la table TA_OCSMEL
MERGE INTO G_GESTIONGEO.TA_OCSMEL a
USING
	(
		SELECT
			a.OBJECTID AS OBJECTID,
			a.CLA_INU AS FID_IDENTIFIANT_TYPE,
--			TO_NUMBER(a.GEO_REF) AS NUMERO_DOSSIER,
			a.GEOM AS GEOM,
			b.OBJECTID AS FID_PNOM_CREATION,
			a.GEO_DS AS DATE_CREATION,
			c.OBJECTID AS FID_PNOM_MODIFICATION,
			a.GEO_DM AS DATE_MODIFICATION
		FROM
			G_GESTIONGEO.TEMP_TA_SUR_TOPO_G a
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT b ON TRIM(LOWER(a.GEO_NMS)) = TRIM(LOWER(b.PNOM))
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT c ON TRIM(LOWER(a.GEO_NMN)) = TRIM(LOWER(c.PNOM))
		WHERE
			a.GEO_ON_VALIDE =0
            AND
            	a.geom.sdo_gtype IN (2003,2007)
            AND
            	a.CLA_INU IN (SELECT OBJECTID FROM G_GESTIONGEO.TA_GG_CLASSE)
            AND
            	a.GEOM IS NOT NULL
            AND
                SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.GEOM, 0.005), 0, 5) <> '13033'
	) b
ON (a.OBJECTID = b.OBJECTID)
WHEN NOT MATCHED THEN INSERT(a.OBJECTID, a.FID_IDENTIFIANT_TYPE, a.GEOM, a.FID_PNOM_CREATION, a.DATE_CREATION, a.FID_PNOM_MODIFICATION, a.DATE_MODIFICATION)
VALUES (b.OBJECTID, b.FID_IDENTIFIANT_TYPE, b.GEOM, b.FID_PNOM_CREATION, b.DATE_CREATION, b.FID_PNOM_MODIFICATION, b.DATE_MODIFICATION)
;

/
