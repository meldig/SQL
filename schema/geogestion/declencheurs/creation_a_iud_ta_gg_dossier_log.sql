/*
Déclencheur permettant de remplir la table de logs TA_GG_DOSSIER_LOG dans laquelle sont enregistrés chaque insertion, 
modification et suppression des données de la table TA_GG_GEO avec leur date et le pnom de l'agent les ayant effectuées.
*/

CREATE OR REPLACE TRIGGER G_GESTIONGEO.A_IUD_TA_GG_DOSSIER_LOG
AFTER INSERT OR UPDATE OR DELETE ON G_GESTIONGEO.TA_GG_DOSSIER
FOR EACH ROW
DECLARE
    username VARCHAR2(100);
    v_id_agent NUMBER(38,0);
    v_id_insertion NUMBER(38,0);
    v_id_modification NUMBER(38,0);
    v_id_suppression NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;

    -- Sélection de l'id du pnom correspondant dans la table TA_GG_AGENT
    SELECT objectid INTO v_id_agent FROM G_GESTIONGEO.TA_GG_AGENT WHERE pnom = username;

    -- Sélection des id des actions présentes dans la table TA_LIBELLE
    SELECT 
        a.objectid INTO v_id_insertion 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'insertion';

    SELECT 
        a.objectid INTO v_id_modification 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'édition';
            
    SELECT 
        a.objectid INTO v_id_suppression 
    FROM 
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long 
    WHERE 
        b.valeur = 'suppression';

    IF INSERTING THEN -- En cas d'insertion on insère les valeurs de la table TA_GG_DOSSIER_LOG, le numéro d'agent correspondant à l'utilisateur, la date de insertion et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_DOSSIER_LOG(id_dossier, id_etat_avancement, id_famille, id_perimetre, date_debut_leve, date_fin_leve, date_debut_travaux, date_fin_travaux, date_commande_dossier, maitre_ouvrage, responsable_leve, entreprise_travaux, remarque_geometre, remarque_photo_interprete, date_action, fid_type_action, fid_pnom)
            VALUES( 
                    :new.objectid,
                    :new.fid_etat_avancement,
                    :new.fid_famille, 
                    :new.fid_perimetre, 
                    :new.date_debut_leve, 
                    :new.date_fin_leve, 
                    :new.date_debut_travaux,
                    :new.date_fin_travaux,
                    :new.date_commande_dossier,
                    :new.maitre_ouvrage,
                    :new.responsable_leve,
                    :new.entreprise_travaux,
                    :new.remarque_geometre,
                    :new.remarque_photo_interprete,
                    sysdate, 
                    v_id_insertion, 
                    v_id_agent
                );                    
    ELSE
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

/

