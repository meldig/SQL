/*
Création de la vue V_STAT_DOSSIER_PAR_AGENT_ANNEE comptant le nombre de dossiers créés par agent, année et commune.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_AGENT_ANNEE" ("OBJECTID", "PNOM_AGENT", "ANNEE", "NOMBRE_DOSSIER", 
 CONSTRAINT "V_STAT_DOSSIER_PAR_AGENT_ANNEE_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS 
WITH
    C_1 AS(
        SELECT
            fid_pnom_creation,
            EXTRACT(year FROM date_saisie) AS annee,
            COUNT(objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER           
        GROUP BY
            fid_pnom_creation,
            EXTRACT(year FROM date_saisie)
    )
    
    SELECT
        rownum,
        b.pnom,
        a.annee,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT b ON b.objectid = a.fid_pnom_creation;
        
-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE IS 'Vue statistique comptant le nombre de dossiers créés par agent, année et commune.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE.objectid IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE.pnom_agent IS 'Pnom des agents ayant créés des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE.annee IS 'Année de saisie des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE.nombre_dossier IS 'Nombre de dossiers créés par agent, année et commune.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE TO G_ADMIN_SIG;

/

