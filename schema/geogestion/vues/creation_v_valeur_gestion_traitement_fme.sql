-- Création de la vue V_VALEUR_GESTION_TRAITEMENT_FME regroupant les valeurs utilisées dans la gestion des dossiers dans le traitement FME.
-- 1. Création de la vue
CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME"
    (
    "REPERTOIRE",
    "ETAT_ID_FINAL_RECOL",
    "ETAT_ID_FINAL_IC",
    "ETAT_ID_MAJ"
    )
AS
SELECT
    a.repertoire AS REPERTOIRE,
    b.objectid AS ETAT_ID_FINAL_RECOL,
    c.objectid AS ETAT_ID_FINAL_IC,
    d.objectid AS ETAT_ID_MAJ
FROM
    G_GESTIONGEO.TA_GG_REPERTOIRE a,
    G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT b,
    G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c,
    G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT d
WHERE
    UPPER(a.protocole) = UPPER('sftp')
    AND
    TRIM(UPPER(b.libelle_court)) = TRIM(UPPER('Attente Validation (Topo)'))
    AND
    TRIM(UPPER(c.libelle_court)) = TRIM(UPPER('Actif en base'))
    AND
    TRIM(UPPER(d.libelle_court)) = TRIM(UPPER('Attente levé géomètre'));

-- 2. Création des commentaires de la vue
COMMENT ON TABLE "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME" IS 'Vue présentant les valeurs necessaires à la gestion des dossiers: le REPERTOIRE dans lequel les fichiers associés seront déplacer et les valeurs d''état des dossier suivant le type de dossier.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".repertoire IS 'Répertoire qui contient les dossiers de l''application GESTIONGEO';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".etat_id_final_recol IS 'Valeur de la clé étrangère vers la table TA_FID_ETAT_AVANCEMENT afin de mettre à jour l''état d''avancement du dossier suite à l''intégration d''un fichier DWG d''un dossier de recolement.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".etat_id_final_ic IS 'Valeur de la clé étrangère vers la table TA_FID_ETAT_AVANCEMENT afin de mettre à jour l''état d''avancement du dossier suite à l''intégration d''un fichier DWG d''un dossier d''Investigation Complémentaire.';
COMMENT ON COLUMN "G_GESTIONGEO"."V_VALEUR_GESTION_TRAITEMENT_FME".etat_id_maj IS 'Valeur de la clé étrangère vers la table TA_FID_ETAT_AVANCEMENT afin de mettre à jour l''état d''avancement du dossier suite à la suppression de ses éléments topographiques'; 

-- 3. Création d'un droit de lecture aux rôle de lecture et aux admins
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_GESTION_TRAITEMENT_FME TO G_ADMIN_SIG;

/

