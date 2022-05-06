/*
Création de la vue V_STAT_DOSSIER_PAR_TERRITOIRE dénombrant les dossiers de levés topo par agent et état d'avancement.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE("OBJECTID", "PNOM_AGENT","ETAT","NOMBRE_DOSSIER",
CONSTRAINT "V_STAT_DOSSIER_PAR_TERRITOIRE_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS
WITH
    C_1 AS(
        SELECT
            a.fid_pnom_creation,
            a.fid_etat_avancement,
            COUNT(a.objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
        GROUP BY
            a.fid_pnom_creation,
            a.fid_etat_avancement
    )
    
    SELECT
        rownum,
        b.pnom,
        c.libelle_long,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT b ON b.objectid = a.fid_pnom_creation
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c ON c.objectid = a.fid_etat_avancement;

-- 2. Création des commentaires
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE".objectid IS 'Clé primaire de la Vue.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE".pnom_agent IS 'Pnom des agents créateurs des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE".etat IS 'Etats d''avancement des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE".nombre_dossier IS 'Nombre de dossiers.';
COMMENT ON TABLE "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_TERRITOIRE"  IS 'Vue statistique dénombrant les dossiers de levés topo par agent et état d''avancement.';

-- 3. Création du droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE TO G_ADMIN_SIG;

/

