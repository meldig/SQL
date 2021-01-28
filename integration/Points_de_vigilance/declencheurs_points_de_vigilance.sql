/*
1. Déclencheur permettant de faire l'audit de la table G_GESTIONGEO.TEMP_GG_POINT_VIGILANCE ;
2. Déclencheur empêchant les associations improbables dans la table G_GESTIONGEO.TEMP_GG_POINT_VIGILANCE ;
3. En cas d'exeption levée, faire un ROLLBACK ;
*/
-- 1. Déclencheur permettant de faire l'audit de la table G_GESTIONGEO.TEMP_GG_POINT_VIGILANCE
create or replace TRIGGER G_GESTIONGEO.A_IUX_TEMP_GG_POINT_VIGILANCE_ACTION
AFTER INSERT OR UPDATE ON G_GESTIONGEO.TEMP_GG_POINT_VIGILANCE
FOR EACH ROW
    DECLARE
        username VARCHAR2(100);
        v_src_id NUMBER(38,0);
BEGIN
    -- Sélection du pnom
    SELECT sys_context('USERENV','OS_USER') into username from dual;
    -- Sélection de l'id du pnom correspondant dans la table TA_GG_SOURCE
    SELECT src_id INTO v_src_id FROM G_GESTIONGEO.TA_GG_SOURCE WHERE src_libel = username;

    IF INSERTING THEN -- En cas d'insertion on insère le SRC_ID correspondant à l'utilisateur dans TEMP_GG_POINT_VIGILANCE_AUDIT.fid_pnom_creation et la date de création dans TEMP_GG_POINT_VIGILANCE_AUDIT.date_creation
        INSERT INTO G_GESTIONGEO.TEMP_GG_POINT_VIGILANCE_AUDIT(fid_point_vigilance, fid_pnom_creation, date_creation)
            VALUES(:new.objectid, v_src_id, sysdate);
    END IF;

    IF UPDATING THEN -- En cas d'édition on insère le SRC_ID correspondant à l'utilisateur dans TEMP_GG_POINT_VIGILANCE_AUDIT.fid_pnom_modification et la date de modification dans TEMP_GG_POINT_VIGILANCE_AUDIT.date_modification
        UPDATE G_GESTIONGEO.TEMP_GG_POINT_VIGILANCE_AUDIT
        SET 
            fid_pnom_modification = v_src_id,
            date_modification = sysdate
        WHERE
            fid_point_vigilance = :new.objectid;       
    END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GESTIONGEO.A_IUX_TEMP_GG_POINT_VIGILANCE_ACTION','trigger@lillemetropole.fr');
END;
/
-- 2. Déclencheur empêchant les associations improbables dans la table G_GESTIONGEO.TEMP_GG_POINT_VIGILANCE
create or replace TRIGGER G_GESTIONGEO.B_IUX_TEMP_GG_POINT_VIGILANCE_CONTROLE
BEFORE INSERT OR UPDATE ON TEMP_GG_POINT_VIGILANCE
FOR EACH ROW
DECLARE
    correction_topo NUMBER(38,0);
    chantier_potentiel NUMBER(38,0);
    chantier_en_cours NUMBER(38,0);

BEGIN
-- Valorisation des variables
    SELECT
        a.objectid
        INTO correction_topo
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('correction, modification topo');

    SELECT
        a.objectid
        INTO chantier_potentiel
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('chantier potentiel');

    SELECT
        a.objectid
        INTO chantier_en_cours
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('chantier en cours');

 -- Contrôle des associations improbables
    IF INSERTING THEN
        IF (:new.FID_TYPE_SIGNALEMENT = correction_topo AND :new.FID_VERIFICATION = chantier_en_cours) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type "modification manuelle par les topos" ne peut pas aller avec une vérification de type chantier en cours');
        END IF;
        IF (:new.FID_TYPE_SIGNALEMENT = correction_topo AND :new.FID_VERIFICATION = chantier_potentiel) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type "modification manuelle par les topos" ne peut pas aller avec une vérification de type chantier potentiel');
        END IF;
    END IF;
    IF UPDATING THEN
        IF (:new.FID_TYPE_SIGNALEMENT = correction_topo AND :new.FID_VERIFICATION = chantier_en_cours) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type "modification manuelle par les topos" ne peut pas aller avec une vérification de type chantier en cours');
        END IF;
        IF (:new.FID_TYPE_SIGNALEMENT = correction_topo AND :new.FID_VERIFICATION = chantier_potentiel) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type "modification manuelle par les topos" ne peut pas aller avec une vérification de type chantier potentiel');
        END IF;
    END IF;
/*
    EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GESTIONGEO.B_IUX_TEMP_GG_POINT_VIGILANCE_CONTROLE','trigger@lillemetropole.fr');*/
END;
/