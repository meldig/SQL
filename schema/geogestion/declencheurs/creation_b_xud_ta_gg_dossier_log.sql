create or replace TRIGGER G_GESTIONGEO.B_XUD_TA_GG_DOSSIER_LOG
BEFORE INSERT OR UPDATE OR DELETE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_id_agent NUMBER(38,0);
    v_id_insertion NUMBER(38,0);
    v_id_modification NUMBER(38,0);
    v_id_suppression NUMBER(38,0);
BEGIN
-- selection du numero de l''agent dans la variable USERNUMBER
    SELECT
        COALESCE(a.OBJECTID,99996) INTO v_id_agent 
    FROM 
        G_GESTIONGEO.TA_GG_AGENT a
        RIGHT JOIN (
                    SELECT
                        SYS_CONTEXT('USERENV','OS_USER') AS NOM 
                    FROM 
                        DUAL
                    )b
                    ON a.pnom = b.nom
    ;

    -- Sélection des id des actions présentes dans la table TA_GG_LIBELLE

    SELECT 
        a.objectid INTO v_id_modification 
    FROM 
        G_GESTIONGEO.TA_GG_LIBELLE a
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG b ON b.OBJECTID = a.FID_LIBELLE_LONG
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE c ON c.FID_LIBELLE = a.OBJECTID
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE d ON d.OBJECTID = c.FID_FAMILLE
    WHERE
        TRIM(LOWER(b.valeur)) = TRIM(LOWER('modification'))
        AND
        TRIM(LOWER(d.libelle)) = TRIM(LOWER('type d''action'));



    SELECT 
        a.objectid INTO v_id_suppression 
    FROM 
        G_GESTIONGEO.TA_GG_LIBELLE a
        INNER JOIN G_GESTIONGEO.TA_GG_LIBELLE_LONG b ON b.OBJECTID = a.FID_LIBELLE_LONG
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE_LIBELLE c ON c.FID_LIBELLE = a.OBJECTID
        INNER JOIN G_GESTIONGEO.TA_GG_FAMILLE d ON d.OBJECTID = c.FID_FAMILLE
    WHERE
        TRIM(LOWER(b.valeur)) = TRIM(LOWER('suppression'))
        AND
        TRIM(LOWER(d.libelle)) = TRIM(LOWER('type d''action'));


    IF UPDATING THEN -- En cas de modification on insère les valeurs de la table TA_GG_DOSSIER_LOG, le numéro d'agent correspondant à l'utilisateur, la date de modification et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_LOG(id_dossier, id_etat_avancement, id_famille, id_perimetre, date_debut_leve, date_fin_leve, date_debut_travaux, date_fin_travaux, date_commande_dossier, maitre_ouvrage, responsable_leve, entreprise_travaux, remarque_geometre, remarque_photo_interprete, date_action, fid_type_action, fid_pnom)
        VALUES(
                :old.objectid,
                :old.fid_etat_avancement,
                :old.fid_famille, 
                :old.fid_perimetre, 
                :old.date_debut_leve, 
                :old.date_fin_leve, 
                :old.date_debut_travaux,
                :old.date_fin_travaux,
                :old.date_commande_dossier,
                :old.maitre_ouvrage,
                :old.responsable_leve,
                :old.entreprise_travaux,
                :old.remarque_geometre,
                :old.remarque_photo_interprete,
                sysdate,
                v_id_modification,
                v_id_agent);
    END IF;

    IF DELETING THEN -- En cas de suppression on insère les valeurs de la table TA_GG_DOSSIER_LOG, le numéro d'agent correspondant à l'utilisateur, la date de suppression et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_LOG(id_dossier, id_etat_avancement, id_famille, id_perimetre, date_debut_leve, date_fin_leve, date_debut_travaux, date_fin_travaux, date_commande_dossier, maitre_ouvrage, responsable_leve, entreprise_travaux, remarque_geometre, remarque_photo_interprete, date_action, fid_type_action, fid_pnom)
        VALUES(
                :old.objectid,
                :old.fid_etat_avancement,
                :old.fid_famille, 
                :old.fid_perimetre, 
                :old.date_debut_leve, 
                :old.date_fin_leve, 
                :old.date_debut_travaux,
                :old.date_fin_travaux,
                :old.date_commande_dossier,
                :old.maitre_ouvrage,
                :old.responsable_leve,
                :old.entreprise_travaux,
                :old.remarque_geometre,
                :old.remarque_photo_interprete,
                sysdate,
                v_id_suppression,
                v_id_agent);
    END IF;

END;

