/*
Déclencheur permettant de remplir la table de logs TA_GG_GEO_LOG dans laquelle sont enregistrés chaque insertion, 
modification et suppression des données de la table TA_GG_GEO avec leur date et le pnom de l'agent les ayant effectuées.
*/

CREATE OR REPLACE TRIGGER G_GESTIONGEO.A_IUD_TA_GG_GEO_LOG
AFTER INSERT OR UPDATE OR DELETE ON G_GESTIONGEO.TA_GG_GEO
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

    IF INSERTING THEN -- En cas d'insertion on insère les valeurs de la table TA_GG_GEO_LOG, le numéro d'agent correspondant à l'utilisateur, la date de insertion et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, date_action, fid_type_action, id_perimetre, fid_pnom)
            VALUES(
                    :new.geom,
                    :new.code_insee, 
                    :new.surface, 
                    sysdate, 
                    v_id_insertion, 
                    :new.objectid, 
                    v_id_agent
                );                    
    ELSE
        IF UPDATING THEN -- En cas de modification on insère les valeurs de la table TA_GG_GEO_LOG, le numéro d'agent correspondant à l'utilisateur, la date de modification et le type de modification.
            INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, date_action, fid_type_action, id_perimetre, fid_pnom)
            VALUES(
                    :old.geom,
                    :old.code_insee,
                    :old.surface,
                    sysdate,
                    v_id_modification,
                    :old.objectid,
                    v_id_agent);
        END IF;
    END IF;
    IF DELETING THEN -- En cas de suppression on insère les valeurs de la table TA_GG_GEO_LOG, le numéro d'agent correspondant à l'utilisateur, la date de suppression et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GG_GEO_LOG(geom, code_insee, surface, date_action, fid_type_action, id_perimetre, fid_pnom)
        VALUES(
                :old.geom,
                :old.code_insee,
                :old.surface,
                sysdate,
                v_id_suppression,
                :old.objectid,
                v_id_agent);
    END IF;
END;

/

