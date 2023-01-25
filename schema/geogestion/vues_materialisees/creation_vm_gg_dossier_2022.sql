/*
Vue matérialisée présentant les dossiers créés en 2022
*/
/*
-- Suppression de l'objet
DROP MATERIALIZED VIEW G_GESTIONGEO.VM_GG_DOSSIER_2022;
*/

-- 1. Création de la VM
CREATE MATERIALIZED VIEW G_GESTIONGEO.VM_GG_DOSSIER_2022 (NUMERO_DOSSIER, CODE_INSEE, ETAT_AVANCEMENT, DATE_CREATION, PNOM_CREATION, DATE_MODIFICATION, DATE_CLOTURE, DATE_DEBUT_LEVE, DATE_FIN_LEVE, DATE_DEBUT_TRAVAUX, DATE_FIN_TRAVAUX, DATE_COMMANDE_DOSSIER, MAITRE_OUVRAGE, RESPONSABLE_LEVE, ENTREPRISE_TRAVAUX, REMARQUE_GEOMETRE, REMARQUE_PHOTO_INTERPRETE)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
WITH
    C_1 AS(
        SELECT
            a.objectid,
            b.code_insee
        FROM
            G_GESTIONGEO.TA_GG_DOSSIER a
            INNER JOIN G_GESTIONGEO.TA_GG_GEO b ON b.objectid = a.fid_perimetre
    )
    
    SELECT
        b.objectid AS numero_dossier,
        a.code_insee,
        c.libelle_court AS etat_avancement,
        b.date_saisie AS date_creation,
        d.pnom AS pnom_creation,
        b.date_modification,
        b.date_cloture,
        b.date_debut_leve,
        b.date_fin_leve,
        b.date_debut_travaux,
        b.date_fin_travaux,
        b.date_commande_dossier,
        b.maitre_ouvrage,
        b.responsable_leve,
        b.entreprise_travaux,
        b.remarque_geometre,
        b.remarque_photo_interprete
    FROM
        C_1 a
        INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER b ON b.objectid = a.objectid
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c ON c.objectid = b.fid_etat_avancement
        INNER JOIN G_GESTIONGEO.TA_GG_AGENT d ON d.objectid = b.fid_pnom_creation
    WHERE
        EXTRACT(Year FROM b.date_saisie) = '2022';
    
-- 2. Création des commentaires de la VM
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.numero_dossier IS 'Identifiant du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.code_insee IS 'Code INSEE du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.etat_avancement IS 'Etats d''avancement des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.date_creation IS 'Date de création du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.pnom_creation IS 'Pnom de l''agent ayant créé le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.date_modification IS 'Date de mise à jour du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.date_cloture IS 'Date de clôture du dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.date_debut_leve IS 'Date de début des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.date_fin_leve IS 'Date de fin des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.date_debut_travaux IS 'Date de début des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.date_fin_travaux IS 'Date de fin des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.date_commande_dossier IS 'Date de commande ou de création de dossier.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.maitre_ouvrage IS 'Nom du maître d''ouvrage.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.responsable_leve IS 'Nom de l''entreprise responsable du levé.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.entreprise_travaux IS 'Entreprise ayant effectué les travaux de levé (si l''entreprise responsable du levé utilise un sous-traitant, alors c''est le nom du sous-traitant qu''il faut mettre ici).';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.remarque_geometre IS 'Précision apportée au dossier par le géomètre telle que sa surface et l''origine de la donnée.';
COMMENT ON COLUMN G_GESTIONGEO.VM_GG_DOSSIER_2022.remarque_photo_interprete IS 'Remarque du photo-interprète lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit.';
COMMENT ON MATERIALIZED VIEW G_GESTIONGEO.VM_GG_DOSSIER_2022 IS 'Vue matérialisée présentant les dossiers créés en 2022';

-- 4. Création de la clé primaire
ALTER MATERIALIZED VIEW VM_GG_DOSSIER_2022 
ADD CONSTRAINT VM_GG_DOSSIER_2022_PK 
PRIMARY KEY (NUMERO_DOSSIER);

-- 6. Don du droit de lecture de la vue matérialisée au schéma G_GESTIONGEO_LEC et aux administrateurs
GRANT SELECT ON G_GESTIONGEO.VM_GG_DOSSIER_2022 TO G_GESTIONGEO_LEC;
GRANT SELECT ON G_GESTIONGEO.VM_GG_DOSSIER_2022 TO G_ADMIN_SIG;

/

