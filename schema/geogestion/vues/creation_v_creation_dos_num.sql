/*
Création de la vue V_CREATION_DOS_NUM permettant de rassembler les informations permettant de générer les DOS_NUM via la fonction GET_DOS_NUM().
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_CREATION_DOS_NUM" ("ID_DOSSIER", "ID_PERIMETRE", "CODE_INSEE", "DATE_SAISIE", "DOS_NUM", 
 CONSTRAINT "V_CREATION_DOS_NUM_PK" PRIMARY KEY ("ID_DOSSIER") DISABLE) AS 
SELECT
    a.objectid AS id_dossier,
    b.objectid AS id_perimetre,
    b.code_insee,
    a.date_saisie,
    c.dos_num
FROM
    G_GESTIONGEO.TA_GG_DOSSIER a
    INNER JOIN G_GESTIONGEO.TA_GG_GEO b ON b.objectid = a.fid_perimetre
    LEFT JOIN G_GESTIONGEO.TA_GG_DOS_NUM c ON c.fid_dossier = a.objectid;

-- 2. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.V_CREATION_DOS_NUM IS 'Vue de travail permettant de rassembler les informations permettant de générer les DOS_NUM via la fonction GET_DOS_NUM().';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.id_dossier IS 'Identifiant du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.id_perimetre IS 'Identifiant du périmètre du dossier issu de TA_GG_GEO.';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.code_insee IS 'Code INSEE du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.date_saisie IS 'Date de saisie du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.V_CREATION_DOS_NUM.dos_num IS 'DOS_NUM historiques existant dans la table TA_GG_DOS_NUM. Ces DOS_NUM sont ceux créés AVANT la migration sur oracle 12c en 2022 et le changement de méthode de saisie qu''elle a occasionné.';

-- 3. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.V_CREATION_DOS_NUM TO G_ADMIN_SIG;

/

