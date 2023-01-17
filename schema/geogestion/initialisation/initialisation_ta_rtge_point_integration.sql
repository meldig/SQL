-- 1.1. Insertion des données dans la table TA_RTGE_POINT_INTEGRATION
MERGE INTO G_GESTIONGEO.TA_RTGE_POINT_INTEGRATION a
USING
	(
		SELECT
		    a.OBJECTID,
		    a.GEOM,
		    TO_NUMBER(a.GEO_REF) AS FID_NUMERO_DOSSIER,
		    a.CLA_INU AS FID_IDENTIFIANT_TYPE,
		    a.GEO_TEXTE AS TEXTE,
		    a.GEO_POI_LN AS LONGUEUR,
		    a.GEO_POI_LA AS LARGEUR,
		    a.GEO_POI_AG_ORIENTATION AS ORIENTATION,
		    a.GEO_POI_HA AS HAUTEUR,
		    a.GEO_POI_AG_INCLINAISON AS INCLINAISON,
		    b.OBJECTID AS FID_PNOM_CREATION,
		    a.GEO_DS AS DATE_CREATION,
		    c.OBJECTID AS FID_PNOM_MODIFICATION,
		    a.GEO_DM AS DATE_MODIFICATION
		FROM
		    G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS a
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT b ON TRIM(LOWER(a.GEO_NMS)) = TRIM(LOWER(b.PNOM))
		    LEFT JOIN G_GESTIONGEO.TA_GG_AGENT c ON TRIM(LOWER(a.GEO_NMN)) = TRIM(LOWER(c.PNOM))
		WHERE
		    a.GEO_ON_VALIDE = 0
	) b
ON (a.OBJECTID = b.OBJECTID)
WHEN NOT MATCHED THEN INSERT (a.OBJECTID, a.GEOM, a.FID_NUMERO_DOSSIER, a.FID_IDENTIFIANT_TYPE, a.TEXTE, a.LONGUEUR, a.LARGEUR, a.ORIENTATION, a.HAUTEUR, a.INCLINAISON, a.FID_PNOM_CREATION, a.DATE_CREATION, a.FID_PNOM_MODIFICATION, a.DATE_MODIFICATION)
VALUES (b.OBJECTID, b.GEOM, b.FID_NUMERO_DOSSIER, b.FID_IDENTIFIANT_TYPE, b.TEXTE, b.LONGUEUR, b.LARGEUR, b.ORIENTATION, b.HAUTEUR, b.INCLINAISON, b.FID_PNOM_CREATION, b.DATE_CREATION, b.FID_PNOM_MODIFICATION, b.DATE_MODIFICATION)
;

/
