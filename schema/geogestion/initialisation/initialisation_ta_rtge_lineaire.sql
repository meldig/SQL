-- 2.2. Insertion des données dans la table TA_RTGE_LINEAIRE
MERGE INTO G_GESTIONGEO.TA_RTGE_LINEAIRE a
USING
	(
		SELECT
			a.OBJECTID AS OBJECTID,
			a.CLA_INU AS IDENTIFIANT_TYPE,
			TO_NUMBER(a.GEO_REF) AS NUMERO_DOSSIER,
			a.GEOM AS GEOM,
			a.GEO_LIG_OFFSET_D AS DECALAGE_DROITE,
			a.GEO_LIG_OFFSET_G AS DECALAGE_GAUCHE,
			b.OBJECTID AS FID_PNOM_CREATION,
			a.GEO_DS AS DATE_CREATION,
			c.OBJECTID AS FID_PNOM_MODIFICATION,
			a.GEO_DM AS DATE_MODIFICATION
		FROM
			G_GESTIONGEO.TEMP_TA_LIG_TOPO_F a
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT b ON TRIM(LOWER(a.GEO_NMS)) = TRIM(LOWER(b.PNOM))
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT c ON TRIM(LOWER(a.GEO_NMN)) = TRIM(LOWER(c.PNOM))
		WHERE
			a.GEO_ON_VALIDE =0
	) b
ON(a.OBJECTID = b.OBJECTID)
WHEN NOT MATCHED THEN INSERT (a.OBJECTID, a.IDENTIFIANT_TYPE, a.NUMERO_DOSSIER, a.GEOM, a.DECALAGE_DROITE, a.DECALAGE_GAUCHE, a.FID_PNOM_CREATION, a.DATE_CREATION, a.FID_PNOM_MODIFICATION, a.DATE_MODIFICATION)
VALUES (b.OBJECTID, b.IDENTIFIANT_TYPE, b.NUMERO_DOSSIER, b.GEOM, b.DECALAGE_DROITE, b.DECALAGE_GAUCHE, b.FID_PNOM_CREATION, b.DATE_CREATION, b.FID_PNOM_MODIFICATION, b.DATE_MODIFICATION)
;

/
