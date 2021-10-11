create or replace TRIGGER G_GESTIONGEO.B_IUD_TA_GRILLE_LOG
BEFORE INSERT OR UPDATE OR DELETE ON G_GESTIONGEO.TA_GRILLE
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
        UPPER(b.valeur) = UPPER('insertion');

    SELECT
        a.objectid INTO v_id_modification
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('édition');

    SELECT
        a.objectid INTO v_id_suppression
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('suppression');

    IF INSERTING THEN -- En cas d'insertion on insère les valeurs de la table TA_GRILLE_LOG, le numéro d'agent correspondant à l'utilisateur, la date de insertion et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GRILLE_LOG(id_grille, id_usage, id_etat, id_gestionnaire, geom, date_action, fid_type_action, fid_pnom)
            VALUES(
                    :new.objectid,
                    :new.fid_usage,
                    :new.fid_etat,
                    :new.fid_gestionnaire,
                    :new.geom,
                    sysdate,
                    v_id_insertion,
                    v_id_agent);
    ELSE
        IF UPDATING THEN -- En cas de modification on insère les valeurs de la table TA_GRILLE_LOG, le numéro d'agent correspondant à l'utilisateur, la date de modification et le type de modification.
            INSERT INTO G_GESTIONGEO.TA_GRILLE_LOG(id_grille, id_usage, id_etat, id_gestionnaire, geom, date_action, fid_type_action, fid_pnom)
            VALUES(
                    :old.objectid,
                    :old.fid_usage,
                    :old.fid_etat,
                    :old.fid_gestionnaire,
                    :old.geom,
                    sysdate,
                    v_id_modification,
                    v_id_agent);
        END IF;
    END IF;
    IF DELETING THEN -- En cas de suppression on insère les valeurs de la table TA_GRILLE_LOG, le numéro d'agent correspondant à l'utilisateur, la date de suppression et le type de modification.
        INSERT INTO G_GESTIONGEO.TA_GRILLE_LOG(id_grille, id_usage, id_etat, id_gestionnaire, geom, date_action, fid_type_action, fid_pnom)
        VALUES(
                :old.objectid,
                :old.fid_usage,
                :old.fid_etat,
                :old.fid_gestionnaire,
                :old.geom,
                sysdate,
                v_id_suppression,
                v_id_agent);
    END IF;
    EXCEPTION
        WHEN OTHERS THEN
            mail.sendmail('geotrigger@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GESTIONGEO.B_IUD_TA_GRILLE_LOG','bjacq@lillemetropole.fr','sysdig@lillemetropole.fr');
END;