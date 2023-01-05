-- 3.3. Insertion des données dans la table TA_OCSMEL_LOG
MERGE INTO G_GESTIONGEO.TA_OCSMEL_LOG a
USING
	(
		WITH CTE AS
			(
				SELECT
					a.OBJECTID,
					b.valeur,
					CASE
						WHEN TRIM(LOWER(b.valeur )) = TRIM(LOWER('Suppression')) 
						THEN 0
						WHEN TRIM(LOWER(b.valeur )) = TRIM(LOWER('Modification')) 
						THEN 1
					END MODIFICATION
				FROM
					TA_GG_LIBELLE a
					INNER JOIN TA_GG_LIBELLE_LONG b ON a.fid_libelle_long = b.objectid
				WHERE 
					TRIM(LOWER(b.valeur )) IN (TRIM(LOWER('Suppression')),TRIM(LOWER('Modification')))
			)
		SELECT
			a.OBJECTID AS OBJECTID,
			a.FID_IDENTIFIANT AS FID_IDENTIFIANT,
			a.CLA_INU AS IDENTIFIANT_TYPE,
			TO_NUMBER(a.GEO_REF) AS NUMERO_DOSSIER,
			a.GEOM AS GEOM,
			c.OBJECTID AS FID_PNOM_MODIFICATION,
			a.GEO_DM AS DATE_MODIFICATION,
			CTE.OBJECTID AS MODIFICATION
		FROM
			G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG a
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT c ON TRIM(LOWER(a.GEO_NMN)) = TRIM(LOWER(c.PNOM))
   		    INNER JOIN CTE ON a.MODIFICATION = CTE.MODIFICATION
        WHERE
            a.CLA_INU IN (SELECT OBJECTID FROM G_GESTIONGEO.TA_GG_CLASSE)
            AND
            SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.GEOM, 0.005), 0, 5) <> '13033'
            AND
            a.GEOM IS NOT NULL
	)b
ON(a.OBJECTID = b.OBJECTID)
WHEN NOT MATCHED THEN INSERT(a.OBJECTID, a.FID_IDENTIFIANT, a.IDENTIFIANT_TYPE, a.NUMERO_DOSSIER, a.GEOM, a.FID_PNOM_MODIFICATION, a.DATE_MODIFICATION, a.MODIFICATION)
VALUES(b.OBJECTID, b.FID_IDENTIFIANT, b.IDENTIFIANT_TYPE, b.NUMERO_DOSSIER, b.GEOM, b.FID_PNOM_MODIFICATION, b.DATE_MODIFICATION, b.MODIFICATION)
;

/
