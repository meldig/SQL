/*
Création de la vue V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE comptant le nombre de dossiers créés par agent, année et commune.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE" ("OBJECTID", "PNOM", "ANNEE", "CODE_INSEE", "NOMBRE_DOSSIER", 
 CONSTRAINT "V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS 
WITH
    C_1 AS(
        SELECT
            b.fid_pnom_creation,
            EXTRACT(year FROM b.date_saisie) AS annee,
            a.code_insee,
            COUNT(b.objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_GEO a
            INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER b ON b.fid_perimetre = a.objectid           
        GROUP BY
            b.fid_pnom_creation,
            EXTRACT(year FROM b.date_saisie),
            a.code_insee
    )
    
    SELECT
        rownum,
        b.pnom,
        a.annee,
        a.code_insee,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT b ON b.objectid = a.fid_pnom_creation;
        
-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE IS 'Vue statistique comptant le nombre de dossiers créés par agent, année et commune.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE.objectid IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE.pnom IS 'Pnom des agents ayant créés des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE.annee IS 'Année de saisie des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE.code_insee IS 'Code INSEE de la commune d''appartenance des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE.nombre_dossier IS 'Nombre de dossiers créés par agent, année et commune.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_COMMUNE_ANNEE TO G_ADMIN_SIG;

/

