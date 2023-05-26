-- 3.1. Insertion des données dans la table TA_RTGE_POINT_LOG
MERGE INTO G_GESTIONGEO.TA_RTGE_POINT_LOG a
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
			a.FID_IDENTIFIANT AS IDENTIFIANT_OBJET,
			a.CLA_INU AS FID_IDENTIFIANT_TYPE,
			TO_NUMBER(a.GEO_REF) AS FID_NUMERO_DOSSIER,
			SDO_GEOMETRY(3001, 2154,
                SDO_POINT_TYPE(a.GEOM.sdo_point.x, a.GEOM.sdo_point.y, COALESCE(a.GEOM.sdo_point.z,0)),
                NULL, NULL) AS GEOM,
		    CAST(TRIM(a.GEO_TEXTE) AS VARCHAR2 (2048 BYTE)) AS TEXTE,
			a.GEO_POI_LN/100 AS LONGUEUR,
			a.GEO_POI_LA/100 AS LARGEUR,
			a.GEO_POI_AG_ORIENTATION AS ORIENTATION,
			a.GEO_POI_HA/100 AS HAUTEUR,
			a.GEO_POI_AG_INCLINAISON AS INCLINAISON,
			c.OBJECTID AS FID_PNOM_ACTION,
			a.GEO_DM AS DATE_ACTION,
			CTE.OBJECTID AS FID_TYPE_ACTION,
			a.FID_IDENTIFIANT AS FID_IDENTIFIANT_OBJET_INTEGRATION
		FROM
			G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG a
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT c ON TRIM(LOWER(a.GEO_NMN)) = TRIM(LOWER(c.PNOM))
		    INNER JOIN CTE ON a.MODIFICATION = CTE.MODIFICATION
            AND a.GEOM IS NOT NULL
	)b
ON(a.OBJECTID = b.OBJECTID)
WHEN NOT MATCHED THEN INSERT(a.OBJECTID, a.IDENTIFIANT_OBJET, a.FID_IDENTIFIANT_TYPE, a.FID_NUMERO_DOSSIER, a.GEOM, a.TEXTE, a.LONGUEUR, a.LARGEUR, a.ORIENTATION, a.HAUTEUR, a.INCLINAISON, a.FID_PNOM_ACTION, a.DATE_ACTION, a.FID_TYPE_ACTION, a.FID_IDENTIFIANT_OBJET_INTEGRATION)
VALUES(b.OBJECTID, b.IDENTIFIANT_OBJET, b.FID_IDENTIFIANT_TYPE, b.FID_NUMERO_DOSSIER, b.GEOM, b.TEXTE, b.LONGUEUR, b.LARGEUR, b.ORIENTATION, b.HAUTEUR, b.INCLINAISON, b.FID_PNOM_ACTION, b.DATE_ACTION, b.FID_TYPE_ACTION, b.FID_IDENTIFIANT_OBJET_INTEGRATION)
;

/
