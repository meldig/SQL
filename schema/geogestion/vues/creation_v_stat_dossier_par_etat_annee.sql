/*
Création de la vue V_STAT_DOSSIER_PAR_ETAT_ANNEE comptant le nombre de dossiers créés par agent, année et commune.
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_STAT_DOSSIER_PAR_ETAT_ANNEE" ("OBJECTID", "ANNEE", "ETAT_AVANCEMENT", "NOMBRE_DOSSIER", 
 CONSTRAINT "V_STAT_DOSSIER_PAR_ETAT_ANNEE_PK" PRIMARY KEY ("OBJECTID") DISABLE) AS 
WITH
    C_1 AS(
        SELECT
            EXTRACT(year FROM b.date_saisie) AS annee,
            b.fid_etat_avancement,
            COUNT(b.objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_GEO a
            INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER b ON b.fid_perimetre = a.objectid           
        GROUP BY
            EXTRACT(year FROM b.date_saisie),
            b.fid_etat_avancement
    )
    
    SELECT
        rownum,
        a.annee,
        c.libelle_abrege AS etat_avancement,
        a.nombre_dossier
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c ON c.objectid = a.fid_etat_avancement;
        
-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE IS 'Vue statistique comptant le nombre de dossiers par état d''avancement et année.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE.objectid IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE.annee IS 'Année de saisie des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE.etat_avancement IS 'Etat d''avancement des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE.nombre_dossier IS 'Nombre de dossiers créés par état d''avancement et année.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE TO G_ADMIN_SIG;

/

