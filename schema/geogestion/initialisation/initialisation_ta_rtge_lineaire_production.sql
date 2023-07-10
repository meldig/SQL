-- 2.2. Insertion des données dans la table TA_RTGE_LINEAIRE_PRODUCTION
MERGE INTO G_GESTIONGEO.TA_RTGE_LINEAIRE_PRODUCTION a
USING
	(
		SELECT
			a.OBJECTID AS OBJECTID,
			a.CLA_INU AS FID_IDENTIFIANT_TYPE,
			TO_NUMBER(a.GEO_REF) AS FID_NUMERO_DOSSIER,
			a.GEOM AS GEOM,
			a.GEO_LIG_OFFSET_D/100 AS DECALAGE_DROITE,
			a.GEO_LIG_OFFSET_G/100 AS DECALAGE_GAUCHE,
			b.OBJECTID AS FID_PNOM_CREATION,
			a.GEO_DS AS DATE_CREATION,
			c.OBJECTID AS FID_PNOM_MODIFICATION,
			a.GEO_DM AS DATE_MODIFICATION,
			COALESCE(d.OBJECTID, e.OBJECTID, f.OBJECTID) AS FID_IDENTIFIANT_OBJET_INTEGRATION
		FROM
			G_GESTIONGEO.TEMP_TA_LIG_TOPO_F a
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT b ON TRIM(LOWER(a.GEO_NMS)) = TRIM(LOWER(b.PNOM))
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT c ON TRIM(LOWER(a.GEO_NMN)) = TRIM(LOWER(c.PNOM))
		    LEFT JOIN G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS d ON a.OBJECTID = d.OBJECTID
		    LEFT JOIN G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1 e ON a.OBJECTID = e.OBJECTID
		    LEFT JOIN G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP f ON a.OBJECTID = f.OBJECTID 
		WHERE
			a.GEO_ON_VALIDE =0
			AND a.GEOM IS NOT NULL		    
	) b
ON(a.OBJECTID = b.OBJECTID)
WHEN NOT MATCHED THEN INSERT (a.OBJECTID, a.FID_IDENTIFIANT_TYPE, a.FID_NUMERO_DOSSIER, a.GEOM, a.DECALAGE_DROITE, a.DECALAGE_GAUCHE, a.FID_PNOM_CREATION, a.DATE_CREATION, a.FID_PNOM_MODIFICATION, a.DATE_MODIFICATION, a.FID_IDENTIFIANT_OBJET_INTEGRATION)
VALUES (b.OBJECTID, b.FID_IDENTIFIANT_TYPE, b.FID_NUMERO_DOSSIER, b.GEOM, b.DECALAGE_DROITE, b.DECALAGE_GAUCHE, b.FID_PNOM_CREATION, b.DATE_CREATION, b.FID_PNOM_MODIFICATION, b.DATE_MODIFICATION, b.FID_IDENTIFIANT_OBJET_INTEGRATION)
;

COMMIT;

/
