/*
Création de la vue V_CREATION_DOS_NUM permettant de récupérer le DOS_NUM d'un dossier de levé quand il existe 
ou quand il n'existe pas, de le créer au format date de saisie (aaaa_mm_jj) + code insee (5 caractères) + identifiant du dossier
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_CREATION_DOS_NUM" ("ID_DOSSIER", "ID_PERIMETRE", "CODE_INSEE", "DATE_SAISIE", "DOS_NUM", 
 CONSTRAINT "V_CREATION_DOS_NUM_PK" PRIMARY KEY ("ID_DOSSIER") DISABLE) AS 
SELECT
a.objectid AS id_dossier,
b.objectid AS id_perimetre,
b.code_insee,
a.date_saisie,
COALESCE(
            TO_CHAR(c.dos_num), 
            TO_CHAR(
                EXTRACT(year FROM a.date_saisie) || '_' || 
                SUBSTR(TO_CHAR(a.date_saisie), INSTR(TO_CHAR(a.date_saisie), '/')+1, 2) || '_' || 
                CASE WHEN EXTRACT(day FROM a.date_saisie) < 10 THEN '0' || TO_CHAR(EXTRACT(day FROM a.date_saisie)) ELSE TO_CHAR(EXTRACT(day FROM a.date_saisie)) END|| '_' || 
                b.code_insee || '_' || 
                a.objectid
            )
        )
FROM
    G_GESTIONGEO.TA_GG_DOSSIER a
    INNER JOIN G_GESTIONGEO.TA_GG_GEO b ON b.objectid = a.fid_perimetre
    LEFT JOIN G_GESTIONGEO.TA_GG_DOS_NUM c ON c.fid_dossier = a.objectid;

-- 2. Création des commentaires
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."ID_DOSSIER" IS 'Identifiant du dossier issu de TA_GG_DOSSIER.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."ID_PERIMETRE" IS 'Identifiant du périmètre du dossier issu de TA_GG_GEO.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."CODE_INSEE" IS 'Code INSEE du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."DATE_SAISIE" IS 'Date de saisie du dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_CREATION_DOS_NUM"."DOS_NUM" IS 'Champ rassemblant les DOS_NUM historiques existant dans la table TA_GG_DOS_NUM et ceux qui sont recréés automatiquement au format date de saisie (aaaa_mm_jj) + code insee (5 caractères) + identifiant du dossier.';
COMMENT ON TABLE "G_GESTIONGEO"."V_CREATION_DOS_NUM"  IS 'Vue proposant les DOS_NUM des dossiers de levés : s''il existe dans TA_GG_DOS_NUM alors il est récupéré, sinon il est créé via la concaténation date de saisie (aaaa_mm_jj) + code insee (5 caractères) + identifiant du dossier.';

-- 3. Création d'un droit de lecture pour les admins
GRANT SELECT ON G_GESTIONGEO.V_CREATION_DOS_NUM TO G_ADMIN_SIG;

/

