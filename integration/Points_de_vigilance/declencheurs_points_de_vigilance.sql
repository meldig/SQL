/*
1. Déclencheur permettant de faire l'audit de la table G_GEO.TA_GG_POINT_VIGILANCE ;
2. Déclencheur empêchant les associations improbables dans la table G_GEO.TA_GG_POINT_VIGILANCE ;
3. En cas d'exeption levée, faire un ROLLBACK ;
*/
-- 1. Déclencheur permettant de faire l'audit de la table G_GEO.TA_GG_POINT_VIGILANCE
create or replace TRIGGER G_GEO.A_IUD_TA_GG_POINT_VIGILANCE_ACTION
AFTER INSERT OR UPDATE OR DELETE ON TA_GG_POINT_VIGILANCE
FOR EACH ROW
    DECLARE
        username VARCHAR2(100);
        v_test NUMBER(38,0);
        v_id_insertion NUMBER(38,0);
        v_id_edition NUMBER(38,0);
        v_id_cloture NUMBER(38,0);
    BEGIN
        -- Valorisation des variables conteant l'id des libelles des actions des pnom et le pnom de chaque utilisateur
        -- Stockage du pnom
        SELECT sys_context('USERENV','OS_USER') into username from dual; 
        -- Stockage de l'id création
        SELECT 
            a.objectid 
            INTO v_id_insertion
        FROM 
            G_GEO.TA_LIBELLE a 
            INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        WHERE
            UPPER(b.valeur) = UPPER('insertion');

        -- Stockage de l'id édition    
        SELECT 
            a.objectid 
            INTO v_id_edition
        FROM 
            G_GEO.TA_LIBELLE a 
            INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        WHERE
            UPPER(b.valeur) = UPPER('édition');

-- En cas d'insertion
        IF INSERTING THEN
            INSERT INTO G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(fid_point_vigilance, pnom, fid_libelle, date_action)
            VALUES(:new.objectid, username, v_id_insertion, sysdate);
        END IF;
-- En cas d'édition
        IF UPDATING THEN
            FOR i IN (SELECT objectid, fid_libelle, fid_point_vigilance FROM G_GEO.TA_GG_POINT_VIGILANCE_AUDIT WHERE :old.objectid = fid_point_vigilance) LOOP                               
                IF i.fid_libelle = v_id_edition AND i.fid_point_vigilance = :new.objectid THEN
                   UPDATE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT a
                   SET a.pnom = username,
                        a.date_action = sysdate
                    WHERE :new.objectid = a.fid_point_vigilance AND a.fid_libelle = v_id_edition;
                ELSE
                    INSERT INTO G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(fid_point_vigilance, pnom, fid_libelle, date_action)
                    VALUES(:new.objectid, username, v_id_edition, sysdate);
                END IF;    
            END LOOP;          
        END IF;
-- En cas de suppression
        IF DELETING THEN
            --INSERT INTO G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(fid_point_vigilance, pnom, fid_libelle, date_action)
            --VALUES(:old.objectid, username, v_id_cloture, sysdate);

            RAISE_APPLICATION_ERROR(-20001, 'Les objets de la table TA_GG_POINT_VIGILANCE ne peuvent pas être supprimés. L''objet '|| :old.objectid ||' a été restauré. Veuillez le modifier ou le déplacer.');
        END IF;

        EXCEPTION
        WHEN OTHERS THEN
            mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GEO.A_IUD_TA_GG_POINT_VIGILANCE_ACTION','trigger@lillemetropole.fr');
    END;
/
-- 2. Déclencheur empêchant les associations improbables dans la table G_GEO.TA_GG_POINT_VIGILANCE
create or replace TRIGGER G_GEO.B_IUX_TA_GG_POINT_VIGILANCE_CONTROLE
BEFORE INSERT OR UPDATE ON TA_GG_POINT_VIGILANCE
FOR EACH ROW
DECLARE
    modification_manuelle NUMBER(38,0);
    creation NUMBER(38,0);
    verification_terrain NUMBER(38,0);
    verification_orthophoto NUMBER(38,0);
    chantier_potentiel NUMBER(38,0);
    chantier_en_cours NUMBER(38,0);
    chantier_termine NUMBER(38,0);
    bati NUMBER(38,0);
    voirie NUMBER(38,0);
    traite NUMBER(38,0);

BEGIN
-- Valorisation des variables
    SELECT
        a.objectid
        INTO modification_manuelle
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Modification manuelle par les topos');

    SELECT
        a.objectid
        INTO creation
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Création dossier');

    SELECT
        a.objectid
        INTO verification_terrain
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Vérification terrain');

    SELECT
        a.objectid
        INTO verification_orthophoto
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('Vérification orthophoto');

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

    SELECT
        a.objectid
        INTO chantier_termine
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('chantier terminé');

    SELECT
        a.objectid
        INTO bati
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('bâti');

    SELECT
        a.objectid
        INTO voirie
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('voirie (clôture, fossé et bordure)');

    SELECT
        a.objectid
        INTO traite
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    WHERE
        UPPER(b.valeur) = UPPER('traité');

 -- Contrôle des associations improbables

    IF (:new.FID_TYPE_SIGNALEMENT = creation AND :new.FID_VERIFICATION = chantier_potentiel) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type création ne peut pas aller avec une vérification de type chantier potentiel');   
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT IN(verification_terrain, verification_orthophoto) AND :new.FID_VERIFICATION = chantier_termine) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type vérification ne peut pas aller avec une vérification de type chantier terminé');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_VERIFICATION = chantier_en_cours) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type "modification manuelle par les topos" ne peut pas aller avec une vérification de type chantier en cours');
    END IF;
    IF (:new.FID_TYPE_SIGNALEMENT = modification_manuelle AND :new.FID_VERIFICATION = chantier_potentiel) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type "modification manuelle par les topos" ne peut pas aller avec une vérification de type chantier potentiel');
    END IF;

    IF UPDATING THEN
        IF (:new.FID_TYPE_SIGNALEMENT IN(verification_terrain, verification_orthophoto) AND :new.FID_LIB_STATUT = traite) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Un signalement de type vérification ne peut pas passer en traité. Veuillez passer le signalement en "création de dossier" ou "modification manuelle par les topos" d''abord.');
        END IF;
    END IF;

    EXCEPTION
            WHEN OTHERS THEN
                mail.sendmail('bjacq@lillemetropole.fr',SQLERRM,'ERREUR TRIGGER - G_GEO.B_IUX_TA_GG_POINT_VIGILANCE_CONTROLE','trigger@lillemetropole.fr');
END;
/