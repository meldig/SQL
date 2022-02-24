/*
Création de la vue V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT comptant le nombre de dossiers créés par agent, année et commune.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT" ("OBJECTID", "PNOM_AGENT", "FAMILLE", "ETAT_AVANCEMENT", "NOMBRE_DOSSIER", 
 CONSTRAINT "V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS 
WITH
    C_1 AS(
        SELECT
            fid_pnom_creation,
            fid_famille,
            fid_etat_avancement,
            COUNT(objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER ON       
        GROUP BY
            fid_pnom_creation,
            fid_famille,
            fid_etat_avancement
    )
    
    SELECT
        rownum,
        a.pnom,
        b.libelle AS famille,
        a.fid_etat_avancement,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE b ON b.objectid = a.fid_famille
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c ON c.objectid = a.fid_etat_avancement
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT d ON d.objectid = a.fid_pnom_creation;
        
-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT IS 'Vue statistique comptant le nombre de dossiers par agent, famille, état d''avancement.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT.objectid IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT.pnom_agent IS 'Pnom des agents ayant saisis les dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT.famille IS 'Famille des dossiers (Plan de Récolement).';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT.etat_avancement IS 'Etat d''avancement des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT.nombre_dossier IS 'Nombre de dossiers créés par état d''avancement et année.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_FAMILLE_ETAT TO G_ADMIN_SIG;

/

