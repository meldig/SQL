/*
Création de la vue V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT dénombrant les dossiers par état d'avancement.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT" ("OBJECTID", "ETAT_AVANCEMENT", "NOMBRE_DOSSIER",
	 CONSTRAINT "V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS 
WITH
    C_1 AS(
        SELECT
            a.fid_etat_avancement,
            COUNT(a.objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
        GROUP BY
            a.fid_etat_avancement
    )
    SELECT
        rownum,
        b.libelle_long,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT b ON b.objectid = a.fid_etat_avancement;

-- 2. Création des commentaires
COMMENT ON TABLE "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT"  IS 'Vue dénombrant les dossiers par état d''avancement.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT"."OBJECTID" IS 'Clé primaire de la vue.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT"."ETAT_AVANCEMENT" IS 'Etat d''avancement des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT"."NOMBRE_DOSSIER" IS 'Nombre de dossiers.';

-- 3. Création d'un droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT TO G_ADMIN_SIG;

/

