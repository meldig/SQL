------------------------------------------------------
-- INITIALISATION_TA_RTGE_LINEAIRE_PRODUCTION_LOG_2 --
------------------------------------------------------

-- 4.2. Insertion des données dans la table TA_RTGE_LINEAIRE_PRODUCTION_LOG
MERGE INTO G_GESTIONGEO.TA_RTGE_LINEAIRE_PRODUCTION_LOG a
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
				END MODIFICATION
			FROM
				TA_GG_LIBELLE a
				INNER JOIN TA_GG_LIBELLE_LONG b ON a.fid_libelle_long = b.objectid
			WHERE 
				TRIM(LOWER(b.valeur )) IN (TRIM(LOWER('Suppression')))
			)
		SELECT
			a.OBJECTID AS IDENTIFIANT_OBJET,
			a.CLA_INU AS FID_IDENTIFIANT_TYPE,
			TO_NUMBER(a.GEO_REF) AS FID_NUMERO_DOSSIER,
			a.GEOM AS GEOM,
			a.GEO_LIG_OFFSET_D/100 AS DECALAGE_DROITE,
			a.GEO_LIG_OFFSET_G/100 AS DECALAGE_GAUCHE,
			c.OBJECTID AS FID_PNOM_ACTION,
			a.GEO_DM AS DATE_ACTION,
			CTE.OBJECTID AS FID_TYPE_ACTION,
			a.OBJECTID AS FID_IDENTIFIANT_OBJET_INTEGRATION
		FROM
			G_GESTIONGEO.TEMP_TA_LIG_TOPO_F a
			LEFT JOIN G_GESTIONGEO.TA_GG_AGENT c ON TRIM(LOWER(a.GEO_NMN)) = TRIM(LOWER(c.PNOM)),
			CTE
		WHERE
			a.GEO_ON_VALIDE = 1
            AND CLA_INU IN (SELECT OBJECTID FROM G_GESTIONGEO.TA_GG_CLASSE)
            AND a.GEOM IS NOT NULL
	)b
ON(a.IDENTIFIANT_OBJET = b.IDENTIFIANT_OBJET
AND a.FID_TYPE_ACTION = b.FID_TYPE_ACTION)
WHEN NOT MATCHED THEN INSERT(a.IDENTIFIANT_OBJET, a.FID_IDENTIFIANT_TYPE, a.FID_NUMERO_DOSSIER, a.GEOM, a.DECALAGE_DROITE, a.DECALAGE_GAUCHE, a.FID_PNOM_ACTION, a.DATE_ACTION, a.FID_TYPE_ACTION, a.FID_IDENTIFIANT_OBJET_INTEGRATION)
VALUES(b.IDENTIFIANT_OBJET, b.FID_IDENTIFIANT_TYPE, b.FID_NUMERO_DOSSIER, b.GEOM, b.DECALAGE_DROITE, b.DECALAGE_GAUCHE, b.FID_PNOM_ACTION, b.DATE_ACTION, b.FID_TYPE_ACTION, b.FID_IDENTIFIANT_OBJET_INTEGRATION)
;

COMMIT;

/
