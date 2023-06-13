-- Vue des valeurs des classes utilisees qui peuvent être attribuees aux elements du plan de gestion

-- 1. Création de la vue

CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_IDENTIFIANT_PLAN_GESTION"
    (
    "IDENTIFIANT_TYPE",
    "LIBELLE_COURT_TYPE",
    "LIBELLE_LONG_TYPE",
    "IDENTIFIANT_DOMAINE",
    "DOMAINE",
CONSTRAINT "V_IDENTIFIANT_PLAN_GESTION_PK" PRIMARY KEY ("IDENTIFIANT_TYPE") DISABLE)
AS
	(
		SELECT
			a.objectid AS IDENTIFIANT_TYPE,
			a.libelle_court AS LIBELLE_COURT_TYPE,
			a.libelle_long AS LIBELLE_LONG_TYPE,
			c.objectid AS IDENTIFIANT_DOMAINE, 
			c.domaine AS DOMAINE
		FROM
			G_GESTIONGEO.TA_GG_CLASSE a
			INNER JOIN G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE b ON b.fid_classe = a.objectid
			INNER JOIN G_GESTIONGEO.TA_GG_DOMAINE c ON c.objectid = b.fid_domaine
		WHERE
			c.OBJECTID IN (4,--carto gestion surface batiments
				5,--carto gestion surface hors-bati
				8,--carto gestion lignes
				272--carto gestion surface ilots
				)
			AND a.VALIDITE = 1
	);


-- 2. Création des commentaires de la vue
COMMENT ON TABLE G_GESTIONGEO.V_IDENTIFIANT_PLAN_GESTION  IS 'Vue des valeurs des classes utilisees qui peuvent être attribuees aux elements ponctuels releves par les geometres dans le traitement FME.';

-- 3. Creation des commentaires des colonnes
COMMENT ON COLUMN V_IDENTIFIANT_PLAN_GESTION.IDENTIFIANT_TYPE IS 'Cle primaire de la vue - Identifiant de la classe';
COMMENT ON COLUMN V_IDENTIFIANT_PLAN_GESTION.LIBELLE_COURT_TYPE IS 'Libelle court de la classe';
COMMENT ON COLUMN V_IDENTIFIANT_PLAN_GESTION.LIBELLE_LONG_TYPE IS 'Libelle long de la classe';
COMMENT ON COLUMN V_IDENTIFIANT_PLAN_GESTION.IDENTIFIANT_DOMAINE IS 'Identifiant du domaine de la classe';
COMMENT ON COLUMN V_IDENTIFIANT_PLAN_GESTION.DOMAINE IS 'Libelle du domaine de la classe';

-- 4. Création d'un droit de lecture aux rôle de lecture et aux admins
GRANT SELECT ON G_GESTIONGEO.V_IDENTIFIANT_PLAN_GESTION TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_IDENTIFIANT_PLAN_GESTION TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.V_IDENTIFIANT_PLAN_GESTION TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_GESTIONGEO.V_IDENTIFIANT_PLAN_GESTION TO G_ADMIN_SIG;

/