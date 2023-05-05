-- 2.2. Insertion des données dans la table TA_IC_LINEAIRE
MERGE INTO G_GESTIONGEO.TA_IC_LINEAIRE a
USING
	(
		SELECT
			a.OBJECTID AS OBJECTID,
			a.CLA_INU AS FID_IDENTIFIANT_TYPE,
			TO_NUMBER(REPLACE(a.GEO_REF,'IC_','')) AS FID_NUMERO_DOSSIER,
			a.GEOM AS GEOM,
			b.OBJECTID AS FID_PNOM_CREATION,
			a.GEO_DS AS DATE_CREATION,
			c.OBJECTID AS FID_PNOM_MODIFICATION,
			a.GEO_DM AS DATE_MODIFICATION
		FROM
			G_GESTIONGEO.TEMP_TA_LIG_TOPO_IC a
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT b ON TRIM(LOWER(a.GEO_NMS)) = TRIM(LOWER(b.PNOM))
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT c ON TRIM(LOWER(a.GEO_NMN)) = TRIM(LOWER(c.PNOM))
		WHERE
			a.GEO_ON_VALIDE =0
	) b
ON(a.OBJECTID = b.OBJECTID)
WHEN NOT MATCHED THEN INSERT (a.OBJECTID, a.FID_IDENTIFIANT_TYPE, a.FID_NUMERO_DOSSIER, a.GEOM, a.FID_PNOM_CREATION, a.DATE_CREATION, a.FID_PNOM_MODIFICATION, a.DATE_MODIFICATION)
VALUES (b.OBJECTID, b.FID_IDENTIFIANT_TYPE, b.FID_NUMERO_DOSSIER, b.GEOM, b.FID_PNOM_CREATION, b.DATE_CREATION, b.FID_PNOM_MODIFICATION, b.DATE_MODIFICATION)
;

/
